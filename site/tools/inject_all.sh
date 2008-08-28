#!/bin/sh
# inject navigation into all html pages.
#
# must be called from the site's root.
#
tools/inject_navigation.rb *.html applications/*.html learn/*.html play/*.html play/applet/*.html
for f in *.html applications/*.html learn/*.html play/*.html play/applet/*.html; do echo $f;tidy -asxhtml -m -i -wrap 100 $f; done

