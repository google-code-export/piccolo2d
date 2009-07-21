
Jumpstart how to edit the website:

1) checkout the site stage from https://piccolo2d.googlecode.com/svn/site 
   (beware, lots of stuff!)

2) edit whatever you want to fix,

3) re-inject the navigation html code into the static html pages:
   $ ruby tools/inject_navigation.rb index.html ...

4) tidy the html as the above script asks you to,

5) ensure proper mime-type settings (svn):
   $ sh tools/svn-mime-types.sh
   
6) verify - test your changes locally

7) commit to svn and verify your changes at http://piccolo2d.googlecode.com/svn/site/

8) wait until your changes are published from svn to http://piccolo2d.org 
   automatically every 4 hours at 3,7,etc UTC.


For more background visit:
- http://code.google.com/p/piccolo2d/wiki/WebSiteHowTo
- http://code.google.com/p/piccolo2d/issues/detail?id=42
