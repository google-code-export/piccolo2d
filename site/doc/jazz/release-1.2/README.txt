This is the Jazz README file for Jazz Version 1.2

INTRODUCTION
	
Welcome to Jazz! We have just released Jazz version 1.2, a revolutionary 
way to create robust, full-featured graphical applications in Java, with 
striking features such as zooming and multiple representation. Jazz is an 
extensive toolkit based on the Java2D API.

REQUIRMENTS

To run Jazz applications you need to install the Java 2 Runtime Environment, 
which can be downloaded from "http://www.javasoft.com/j2se/".

GETTING STARTED

Jazz comes with seven jar files that are located in the ./build directory. 
Note, if you downloaded the source release you will have to build these 
jars yourself, see the file build.xml for instruction. The jar files are;

  ./build/jazz.jar     - This jar contains the Jazz 2d graphics framework. 
  ./build/jazzx.jar    - This jar contains nonessential, but mabye usefull jazz framework code.
  ./build/hinote.jar   - This jar contains Hinote, a zoomable drawing program with hyperlinks.
  ./build/help.jar     - This jar is used by the Hinote application.
  ./build/graphit.jar  - This jar contains Graphit, a simple jazz graph drawing program.
  ./build/examples.jar - This jar contains simple examples of the jazz programs.
  ./build/tests.jar    - This jar contains unit tests for classes in the jazz framework.

These jar files (excluding jazz.jar which is a library) can all be run by 
double clicking with the mouse on the jar file or by running the command 

  	java -jar <jar file name>

MORE INFORMATION

More Jazz documentation can be found in the ./doc directory of this release 
and on the Jazz web site, "http://www.cs.umd.edu/hcil/jazz/". 

INSTALLATION NOTES

The Java 2 SDK is a development environment for building applications, 
applets, and components that can be deployed on implementations of the 
Java 2 Platform. 

* Sun's JDK 1.2 on Solaris often gives many warnings about fonts not being
  available when Jazz applications start up.  This appears to be due to
  a bug in Sun's default java installation.  The problem is that JDK 1.2
  specifies a list of fonts in the jdk1.2/jre/lib/font.properties file.
  If some of these are not available on your system, you will get those
  warnings.  You can either ignore the warnings, or edit the font.properties
  file to remove the fonts that your system does not have.

* The standard 'unzip' utility on Solaris does not respect filename case,
  and leaves files in MS-DOS file format.  If you use unzip on Solaris
  (and possibly other Unix systems), you must specify the -U and -a options.
  i.e: unzip -U -a jazz-1.1-compiled.zip
