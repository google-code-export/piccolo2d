#!/usr/bin/ruby -w

require 'rexml/document'
require 'net/http'

class Page

private 

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

Site.new(ARGV).sitemap_dot($stdout,[/^[a-z]+:/])
#$stdout.puts Page.fix_anchors(Page.new($stdin))

