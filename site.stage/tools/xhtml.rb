#!/usr/bin/ruby -w
# http://www.ruby-doc.org/docs/ProgrammingRuby/
require 'rexml/document'
require 'net/http'


# Helper to read a textual navigation structure from a file.
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
		comment = /^(#.*?)?\s*$/
		pat = /^(\t*)(\S+)\s+(.+?)\s*$/
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
			elem = REXML::Document.new "<node title='#{title.strip.gsub ' ', '&nbsp;'}'/>"
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
		dst << "<ul>\n"
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

protected
	# delegates to Page.loadXml
	def loadXhtml src
		Page.loadXml src
	end

end


class Page

	def self.makeAbsoluteUrl(href)
		return nil if href.nil? || href.kind_of?(IO)
		if href.kind_of? String
			pat = /^([^:]+):\/\/([^\/:]*)(?::([0-9]+))?(.*)$/
			url = pat.match href
			return url if !url.nil?
			url = pat.match "file://localhost#{File.expand_path(href)}"
			raise "Pattern mismatch: file://localhost#{File.expand_path(href)}" if url.nil?
			return url
		end
		raise "Unsupported input type [#{href.class}]"
	end

	def self.loadXml(href)
		return nil if href.nil?
		return REXML::Document.new(href) if href.kind_of? IO
		if href.kind_of? String
			pat = /^([^:]+):\/\/([^\/:]*)(?::([0-9]+))?(.*)$/
			url = pat.match href
			if url.nil?
				return REXML::Document.new(File.new(href, 'r'))
			elsif url[1] == 'file'
#				$stderr.puts "Huhu! #{url[1]} #{url[2]} #{url[3]} #{url[4]}"
				return REXML::Document.new(File.new(url[4], 'r'))
			elsif url[1] == 'http'
				http = Net::HTTP.new(url[2], url[3].nil?? 80 : url[3].to_i)					
				response = http.get(url[4], nil )
				return REXML::Document.new(response.body)
			else
				raise "Unsupported protocol [#{m[1]}] in #{href}"
			end
		end
		raise "Unsupported input type [#{href.class}]"
	end

public
	# replace <a name="..."> with <a id="..."> and remove the <a> tag if it's only purpose is the anchor
	def self.fix_anchors(xhtml,report=nil)
		xhtml = xhtml.body if xhtml.kind_of? Page
		# first build a list of all <a> tags
		all_a = []
		xhtml.elements.each("//a") do |a|
			if a.children.length == 0
				all_a << a
				next
			end
			if a.children.length == 1 && a.children[0].kind_of?(REXML::Text) && a.parent.children.length == 1
				all_a << a
				next
			end
		end
		all_a.each do |a|
			a.add_attribute('id', a.attributes['name']) if !a.attributes['name'].nil? && a.attributes['id'] != a.attributes['name']
			a.delete_attribute 'name'
			p = a.parent
			# parent has an id?
			next if !p.attributes['id'].nil?
			next if a.attributes.length > 1
			p.add_attribute 'id', a.attributes['id']
			a.remove
			report.puts "#{p.to_s.gsub(/\s+/, ' ')}" if report
		end
		xhtml
	end

	def initialize(href)
		#@Href = href
		@Url = Page.makeAbsoluteUrl(href)
		@Body = Page.fix_anchors(Page.loadXml(href))		
		$stderr.puts "Not well formed: #{href}" if @Body.nil?
		t = @Body.elements['html/head/title']
		@Title = t.nil?? nil : t.text.strip
	end

	def each_h
	        @Body.elements.each("//*") do |e|
			pat = /^h([1-6])$/
			m = pat.match(e.name)
			next if m.nil?
			yield m[1].to_i, e.texts
		end
	end

	def each_a
	        @Body.elements.each("//*") do |e|
			yield e if e.name == 'a'
		end
	end

	def body
		@Body
	end

	def title
		@Title
	end

	def url
		@Url
	end
end

class Site
	def initialize(hrefs)
		@Url2Page = {}
		@Title2Url = {}
		hrefs.each do |href|
			p = Page.new(href)
			@Url2Page[p.url] = p
			@Title2Url[p.title] = p.url
		end
	end

	def tocs(dst=$stdout)
		@Url2Page.each do |href,p|
			$stdout.puts href
			p.each_h do |level,txt|
				t = "#{txt}".strip
				sep = "\t" * level
				$stdout.puts "#{sep}<h#{level}>#{t}</#{level}>"
			end
		end
	end

	def sitemap_dot(dst=$stdout,ignores=[],requires=[])
		# build one regexp to match
		tmp = []
		ignores.each do |p|
			p = Regexp.new(p) if !p.kind_of?(Regexp)
			tmp << "(#{p.source})"
		end
		ignores = Regexp.new(tmp.join('|'))

		dst.puts "#\# begin #{ignores.source}"
		@Url2Page.each do |href,page|
			page.each_a do |elem|
				ref = elem.attributes['href']
				next if ref.nil?
				next if !ignores.match(ref).nil?
				dst.puts "#{href} -> #{ref}"
			end
		end
		dst.puts '# end'
	end
end

