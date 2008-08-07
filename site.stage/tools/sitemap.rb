#!/usr/bin/ruby -w
# http://www.ruby-doc.org/docs/ProgrammingRuby/
require File.dirname(__FILE__) + '/xhtml.rb'

Site.new(ARGV).sitemap_dot($stdout,[/^[a-z]+:/])
#$stdout.puts Page.fix_anchors(Page.new($stdin))

