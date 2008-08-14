
This directory contains verious tools that ease the
maintenance of the piccolo2d website content.

Usually they must be started with the site's root as current
directory, e.g.
$ svn checkout http://piccolo2d.googlecode.com/svn/site.stage
$ cd site.stage
$ tools/inject_navigation.rb index.html learn/about.html

Each file starts with a brief description of it's purpose.

The most important ones are:

svn-mime-types.sh
	Set the correnct mimetypes of all files (requires find, xargs, svn)

inject_navigation.rb
	inject navigation into html files (requires ruby)

giftopng.sh
	convert a gif image to png (requires netpbm, replace)

validate.sh
	validate xhtml (requires cat, xmllint)

