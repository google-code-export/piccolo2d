#!/bin/sh

dir=.
svn=svn

find $dir -name "*.css" | xargs $svn propset svn:mime-type text/css
find $dir -name "*.dll" | xargs $svn propset svn:mime-type application/octet-stream
find $dir -name "*.gif" | xargs $svn propset svn:mime-type image/gif
find $dir -name "*.html" | xargs $svn propset svn:mime-type text/html
find $dir -name "*.jar" | xargs $svn propset svn:mime-type application/x-java-archive
find $dir -name "*.jpeg" -or -name "*.jpg" | xargs $svn propset svn:mime-type image/jpeg
find $dir -name "*.js" | xargs $svn propset svn:mime-type text/javascript
find $dir -name "*.pdf" | xargs $svn propset svn:mime-type application/pdf
find $dir -name "*.png" | xargs $svn propset svn:mime-type image/png
find $dir -name "*.txt" | xargs $svn propset svn:mime-type text/plain
find $dir -name "*.xml" | xargs $svn propset svn:mime-type text/xml
find $dir -name "*.zip" | xargs $svn propset svn:mime-type application/zip

