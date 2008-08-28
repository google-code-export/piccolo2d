#!/usr/bin/ruby -w
#
# Call with parameter --help to get help.
#
# http://www.ruby-doc.org/docs/ProgrammingRuby/
require File.dirname(__FILE__) + '/xhtml.rb'

# Helper to inject navigation into html pages, 
# TODO link-check and 
# TODO visualise as site-map.
class NavigationInjector < Navigation

	def initialize src
		super src
	end

	# Iterate and delegate to inject_single
	# [dsts] either a relative path to a single file or an array of such.
	def inject dsts
		dsts = [dsts] if !dsts.kind_of? Array
		dsts.each do |dst|
			begin
				inject_single dst
			rescue Exception => e
				$stderr.puts "Warning: #{e}"
			end
		end
	end

private
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

		# remove all unmarked elements
		x.each_element("descendant::node[not(@keep='true')]") {|e| e.remove}

		# create xhtml snippet to inject
		div = <<END_OF_NAVIGATION_HEAD
<div id='navigation'>
<!-- 
this navigation node is auto-generated and injected
by the script #{__FILE__}

DO NOT EDIT IT MANUALLY!!!	
-->
<p>
	<a href='#{prefix}index.html'><img src='#{prefix}images/Piccolo2D-Logo-small.png' alt='Piccolo2D Logo' /></a>
</p>
END_OF_NAVIGATION_HEAD
		Navigation.walk_tree_xml(x, div, "  ") do |_dst,child|
			title = child.attribute('title').value
			href = child.attribute('href').value
			href = prefix + href if href[0,1] != '#' # don't prefix anchors
			if child == node
				_dst << "<a class='selected' href='#{href}'>#{title}</a>"
			else
				_dst << "<a href='#{href}'>#{title}</a>"
			end
		end
		div << <<END_OF_NAVIGATION_FOOT
<p>
	<img src='#{prefix}images/giny-small.png' alt='a nice graph' />
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
</div>
END_OF_NAVIGATION_FOOT
		# parse
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
end

###########################################################
#### main program #########################################
###########################################################

if ARGV.length < 1 || ARGV[0] == '--help' || ARGV[0] == '-help' || ARGV[0] == '-?'
	puts <<END_OF_HELP
Inject navigation into html pages.

Usage:
	1) cd to the root of the website
	2) call this script with multiple html files as parameters

Example:
	$ cd ~/work/piccolo2d/site.stage
	$ #{__FILE__} index.html about.html

END_OF_HELP
	exit
end

n = NavigationInjector.new "#{File.dirname(__FILE__)}/navigation.txt"
n.inject ARGV
puts <<END_OF_HELP
...finished. Now please run html tidy on all files:
$ for f in #{ARGV.join ' '}; do echo $f;tidy -asxhtml -m -i -wrap 100 \$f; done
END_OF_HELP

