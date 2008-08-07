#!/usr/bin/ruby -w
# http://www.ruby-doc.org/docs/ProgrammingRuby/
require File.dirname(__FILE__) + '/xhtml.rb'

class Nav

	def self.tokenize_navigation src
		src = File.new src if !src.kind_of? IO
		# Parse the navigation txt
		comment = /^#.*$/
		pat = /^(\t*)(\S+)\s+(.+)*$/
		src.each_line do |line|
			#puts line.strip
			next if !comment.match(line).nil?
			m = pat.match line
			if m.nil?
				$stderr.puts "Mismatching entry: [#{line}]"
				next
			end
			yield m[1].length, m[2], m[3]
		end
	end

	def self.parse_navigation_hash src, parent, labels
#		$stderr.puts "parse_navigation src, #{parent.nil? ? 'nil' : 'ok'}, labels"
		stack = [parent]
		prev = nil
		self.tokenize_navigation(src) do |level,href,title|
			labels[href] = title
			level += 1
			while level < stack.length
				stack.pop
			end
			stack.push(prev) if level > stack.length
			stack.last[href] = prev = {}			
		end		
	end

	def self.print_tree_hash parent, dst=$stdout, level=0
		indent = "\t" * level
		dst.puts "<ul>"
		parent.each do |file,children|
			dst.write "#{indent}<li>#{file}"
			print_tree_hash(children, dst, level+1) if children.length > 0
			dst.puts "</li>"
		end
		dst.write "#{indent}</ul>"
	end

	def self.parse_navigation_xml src
		xml = REXML::Document.new
		current = xml
		curr_lev = -1
		self.tokenize_navigation(src) do |level,href,title|
			# don't escape entities in the title:
			elem = REXML::Document.new "<node title='#{title}'/>"
			elem = elem.root
			elem.add_attribute 'href', href
			elem.add_attribute 'level', level.to_s
			if level == curr_lev
				pa = current.parent
			elsif level > curr_lev
				pa = current
				curr_lev += 1
			else
				pa = current.parent
				while level < curr_lev
					pa = pa.parent
					curr_lev -= 1
				end
			end
			pa.add(current=elem)
		end
		xml
	end

	def self.print_tree_xml parent, dst=$stdout, level=0
		indent = "\t" * level
		dst << "<ul>\n"
		parent.each_child do |child|
			dst << "#{indent}<li>#{child.attribute('title').value}"
			print_tree_xml(child, dst, level+1) if child.has_elements?
			dst << "</li>\n"
		end
		dst << "#{indent}</ul>"
	end

	def initialize src
		xml = Nav.parse_navigation_xml(src)
		$stdout.puts xml
	end

	def check_structure
	end

	def inject dsts
		dsts = [dsts] if !dsts.kind_of? Array
		dsts.each {|dst| inject_single dst}
	end

private 
	def inject_single dst
		puts dst

#		anchor = /^#.*$/
#		@Hrefs.each do |file,unused|
#			next if !anchor.match(file).nil?
#			@Xhtml[file] = Page.loadXml(file)
#		end	
	end
end

if ARGV.length == 0 || ARGV[1] == '--help' || ARGV[1] == '-help' || ARGV[1] == '-?'
	puts <<END_OF_HELP
Inject navigation into html pages.

Usage:
	1) cd to the root of the website
	2) call this script with first parameter navigation.txt and multiple html pages following

Example:
	$ cd ~/work/piccolo2d/site.stage
	$ #{__FILE__} #{File.dirname(__FILE__)}/navigation.txt index.html about.html

END_OF_HELP
	exit
end

n = Nav.new ARGV[0]
ARGV[0] = nil
ARGV.compact!
#n.inject ARGV
puts "run"
puts "$ tidy -asxhtml -m -i -wrap 100 #{ARGV.join ' '}"
