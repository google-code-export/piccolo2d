#!/usr/bin/ruby -w
#
# Call without parameters to get help.
#
# http://www.ruby-doc.org/docs/ProgrammingRuby/
require File.dirname(__FILE__) + '/xhtml.rb'

# Helper to inject navigation into html pages, 
# TODO link-check and 
# TODO visualise as site-map.
class Navigation

	# Read the textual navigation structure and provide an
	# iterator (level,url,title) of each entry.
	# Comment lines starting with # are ignored.
	# 
	# Yields level, url, title
	# [src] either a path to the navigation.txt file or an IO or something else supporting each_line.
	def self.tokenize_navigation src
		src = File.new src if src.kind_of? String
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

	# Read the textual navigation structure and return a xml document
	# for further processing.
	# [src] input for tokenize_navigation(src)
	def self.parse_navigation_xml src
		xml = REXML::Document.new
		current = xml
		curr_lev = -1
		self.tokenize_navigation(src) do |level,href,title|
			# keep html entities in the title - don't escape the &:
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

	# Render the navigation structure (xml as from parse_navigation_xml)
	# into nested <ul> lists.
	#
	# Titles only, no links.
	#
	# [parent] the xml node to print
	# [dst] destination. Must support <<
	# [level] indentation level
	def self.print_tree_xml parent, dst=$stdout, level=0
		self.walk_tree_xml(parent, dst, "  ", level) do |dst,child|
			dst << child.attribute('title').value
		end
	end

	# Closure to render the navigation structure (xml as from parse_navigation_xml)
	# into nested <ul> lists.
	# 
	# yields dst,child
	#
	# [parent] the xml node to print
	# [dst] destination. Must support <<
	# [indent] indentation atom
	# [level] indentation level
	def self.walk_tree_xml parent, dst, indent="\t", level=0, &block
		# yield and recursion: 
		# http://www.google.com/search?q=ruby+yield+recursive
		# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/76211
		indent = indent * level
		dst << "<ul class='nav'>\n"
		parent.each_child do |child|
			dst << "#{indent}<li>"
			block.call(dst,child)
			walk_tree_xml(child, dst, indent, level+1, &block) if child.has_elements?
			dst << "</li>\n"
		end
		dst << "#{indent}</ul>"
	end

	def initialize src
		@Xml = Navigation.parse_navigation_xml(src)
		# $stderr.puts @Xml
	end

	def check_structure
	end

	# Iterate and delegate to inject_single
	# [dsts] either a relative path to a single file or an array of such.
	def inject dsts
		dsts = [dsts] if !dsts.kind_of? Array
		dsts.each {|dst| inject_single dst}
	end

private
	# delegates to Page.loadXml
	def loadXhtml src
		Page.loadXml src
	end

	# Inject navigation into one html page.
	# [dst] relative path of the page to inject into. 
	# The path is interpreted both as the path to the physical
	# file to inject into AND the relative URL of the page on the website.
	def inject_single dst, log=$stderr
		log.puts "Injecting #{dst}"
		# eagerly load the page xhtml to inject into:
		xhtml = loadXhtml dst

		# prefix relative paths
		# get the nesting level compared to the cwd
		cwd = File.expand_path('.')
		pwd = File.dirname(File.expand_path(dst))
		nesting = pwd.count('/') - cwd.count('/')
		prefix = '../' * nesting

		# clone the whole navigation as is:
		x = @Xml.deep_clone

		# find the desired page's navigation node:
		node = x.get_elements("descendant-or-self::node[@href='#{dst}']")
		raise "Page [#{dst}] not found in navigation structure." if node.length == 0
		raise "Page [#{dst}] found multiple times in navigation structure." if node.length > 1
		node = node[0]

		# mark all 'node' children of the node and all it's ancestors:
		xpath = ['ancestor-or-self::/node']
		# mark all 1st level child anchors of the node
		xpath << 'node[starts-with(@href,\'#\')]'
		# mark all 2nd level child anchors of the node
		xpath << 'node[starts-with(@href,\'#\')]/node[starts-with(@href,\'#\')]'
		node.each_element(xpath.join('|')) { |c| c.add_attribute 'keep', 'true' }

		# log.puts x

		# remove all unmarked elements
		x.each_element("descendant::node[not(@keep='true')]") {|e| e.remove}
		# log.puts x

		# create xhtml snippet to inject
		div = <<END_OF_HAVIGATION_HEAD
<div id='navigation'>
<!-- 
	this navigation node is auto-generated and injected
	by the script #{__FILE__}
	
	DO NOT EDIT IT MANUALLY!!!	
-->
END_OF_HAVIGATION_HEAD
		Navigation.walk_tree_xml(x, div, "  ") do |_dst,child|
			title = child.attribute('title').value
			href = child.attribute('href').value
			href = prefix + href if href[0,1] != '#' # don't prefix anchors
			if child == node
				_dst << title # could also add a class
			else
				_dst << "<a href='#{href}'>#{title}</a>"
			end
		end
		div << <<END_OF_NAVIGATION_FOOT
<p>
	<img src='#{prefix}images/giny-small.jpg' alt='a nice graph' />
</p>
<p>
	<a href='http://validator.w3.org/check/referer'><img src='http://www.w3.org/Icons/valid-xhtml10-blue'
	alt='Valid XHTML 1.0!' style='border:0;width:88px;height:31px' /></a>
	<a href='http://jigsaw.w3.org/css-validator/check/referer'><img src='http://www.w3.org/Icons/valid-css-blue'
	alt='Valid CSS1!' style='border:0;width:88px;height:31px' /></a>
	</p>
<p class='bugreport'>
	<a href='http://code.google.com/p/piccolo2d/issues/entry?template=User%20defect%20report'>I
	found an error!</a>
</p>
END_OF_NAVIGATION_FOOT

		div << "</div>"
		div = REXML::Document.new div

		# inject
		n = xhtml.get_elements("descendant::*[@id='navigation']")
		raise "Id 'navigation' not found in page [#{dst}]." if n.length == 0
		raise "Id 'navigation' found multiple times in page [#{dst}]." if n.length > 1
		n = n[0]
		n.parent.replace_child n, div

		# write back the injected file
		xhtml.write File.open(dst, "w")
	end

	# DEPRECATED will be removed soon.
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

	# DEPRECATED will be removed soon.
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
end

###########################################################
#### main program #########################################
###########################################################

if ARGV.length < 2 || ARGV[1] == '--help' || ARGV[1] == '-help' || ARGV[1] == '-?'
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

# use the first parameter as navigation structure file path
n = Navigation.new ARGV[0]
# and the rest as paths to html pages to inject into.
ARGV[0] = nil
ARGV.compact!
n.inject ARGV
puts <<END_OF_HELP
...finished. Now please run html tidy on all files:
$ for f in #{ARGV.join ' '}; do echo $f;tidy -asxhtml -m -i -wrap 100 \$f; done
END_OF_HELP

