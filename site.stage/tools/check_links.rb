#!/usr/bin/ruby -w
#
# Call with parameter --help to get help.
#
# http://www.ruby-doc.org/docs/ProgrammingRuby/
require File.dirname(__FILE__) + '/xhtml.rb'

# Search broken links
class LinkChecker < Navigation

protected
	# Cached delegate to Page.loadXml
	def loadXhtml src
		x = @Xhtml[src]
		@Xhtml[src] = x = Page.loadXml(src) if x.nil?
		x
	end

	# Cached id lookup
	def findIdNodes src, id
		i = @Ids[src]
		if i.nil?
			x = loadXhtml src
			raise "Http 404    : #{src}" if x.nil?
			hash = {}
			x.each_element("//*[@id]") do |elem|
				v = elem.attribute('id').value
				hash[v] = [] if hash[v].nil?
				hash[v] << elem
			end
			@Ids[src] = i = hash
		end
		ret = i[id]
		ret.nil?? [] : ret
	end

	# Check existence of
	# - local file
	# - id within local file
	# - remote file (http head, cached)
	def check_resource href, check_anchor=true
		# distinguish local files and other
		if /^[a-z]+:/.match href
			url = /^([^:]+):\/\/([^\/:]*)(?::([0-9]+))?(.*)$/.match href
			if url && 'http' == url[1]
				# cached http head resquests
				response = @HttpHead[href]
				if response.nil?
					begin
						http = Net::HTTP.new(url[2], url[3].nil?? 80 : url[3].to_i)
						path = url[4]
						path = '/' if path.nil? || path == ''
						@HttpHead[href] = response = http.head(path, nil )
					rescue ArgumentError => e
						raise "Http Head   : #{e.message}: #{href}"
					end
				end
				raise "Http #{response.code}    : #{href}" if '200' != response.code
			end
		else
			m = /([^#]+)(?:#(\S+))?/.match href
			if !check_anchor || m[2].nil?
				begin
					stat = File.stat(m[1])
					raise "Http 404    : #{href}" if !stat.file?
				rescue Errno::ENOENT => e
					raise "Http 404    : #{href}"
				end
			else
				ids = findIdNodes m[1], m[2]
				raise "Missing id  : #{href}" if ids.length == 0
				raise "Multiple ids: #{href}" if ids.length > 1			
			end
		end				
		return true
	end

	def each_file
		Navigation.walk_tree_xml(@Xml, "", "  ") do |_dst,child|
			href = child.attribute('href').value
			yield href if href[0,1] != '#'
		end
		nil
	end

public
	def initialize src
		super src
		@Xhtml = {}
		@Ids = {}
		@HttpHead = {}
	end

	# Check if all navigation kinks are ok
	def check_navigation log=$stdout		
		log.puts '-----------------------------------------------------------'
		log.puts 'check_navigation'
		anchor = /#(\S+)/
		errors = []
		Navigation.walk_tree_xml(@Xml, "", "  ") do |_dst,child|
			href = child.attribute('href').value
			if href[0,1] == '#'
				p = child
				while anchor.match(p.attribute('href').value)
					p = p.parent
				end
				href = "#{p.attribute('href').value}#{href}"
			end
			begin
				check_resource href
#				log.puts "Link OK     : #{href}"
			rescue RuntimeError => e
				errors << e
				log.puts e.message
			end
		end
		errors
	end

	def check_a_href log=$stdout
		ignore = ['http://validator.w3.org/check/referer', 'http://jigsaw.w3.org/css-validator/check/referer', 'http://code.google.com/p/piccolo2d/issues/entry?template=User%20defect%20report']		
		log.puts '-----------------------------------------------------------'
		log.puts 'check_a_href'
		each_file do |file|
#			log.puts file
			doc = loadXhtml file
			# compute the prefix for relative paths
			prefix = File.dirname(file) + '/'
			doc.each_element('//a[@href]') do |a|
				href = a.attribute('href').value
				if href[0,1] == '#'
					# add file if it's an anchor
					href = file + href 
				else
					# add the prefix if it's a relative path (not starting with a protocol)
					href = prefix + href if /[a-z]+:/.match(href).nil?
				end
				next if ignore.include? href
#				log.puts "\t\t#{href}"
				begin
					check_resource href, false
#					log.puts "Link OK     : #{file} -> #{href}"
				rescue Exception => e
					log.puts "#{e.message} [#{file}]"
				end
			end
		end
	end

	def check_img log=$stdout
		log.puts '-----------------------------------------------------------'
		log.puts 'check_img'
		each_file do |file|
#			log.puts file
			doc = loadXhtml file
			# compute the prefix for relative paths
			prefix = File.dirname(file) + '/'
			doc.each_element('//img[@src]') do |img|
				href = img.attribute('src').value
				# add the prefix if it's a relative path (not starting with a protocol)
				href = prefix + href if /[a-z]+:/.match(href).nil?
#				log.puts "\t#{href}"
				begin
					check_resource href, false
#					log.puts "Link OK     : #{file} -> #{href}"
				rescue Exception => e
					log.puts "#{e.message} [#{file}]"
				end
			end
		end
	end
end


###########################################################
#### main program #########################################
###########################################################

if ARGV[0] == '--help' || ARGV[0] == '-help' || ARGV[0] == '-?'
	puts <<END_OF_HELP
Search broken navigation, links and images references.

Usage:
	1) cd to the root of the website
	2) call this script without parameters

Example:
	$ cd ~/work/piccolo2d/site.stage
	$ #{__FILE__}

END_OF_HELP
	exit
end

# use the first parameter as navigation structure file path
n = LinkChecker.new(File.dirname(__FILE__) + '/navigation.txt')
n.check_navigation
n.check_a_href
n.check_img

