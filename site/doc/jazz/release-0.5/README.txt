This is the Jazz README file for Jazz Version 0.5

INSTALLATION NOTES

* Sun's JDK 1.2 on Solaris often gives many warnings about fonts not being
  available when Jazz applications start up.  This appears to be due to
  a bug in Sun's default java installation.  The problem is that JDK 1.2
  specifies a list of fonts in the jdk1.2/jre/lib/font.properties file.
  If some of these are not available on your system, you will get those
  warnings.  You can either ignore the warnings, or edit the font.properties
  file to remove the fonts that your system does not have.
 
INTELLECTUAL PROPERTY NOTES

In this directory tree, we are pre-releasing Jazz to the interested
development community as Open Source code.

We are intending to follow an Open Source model to make sure that the
widest possible community has access to and builds on the Jazz
platform. In addition to downloading the Jazz source code, you can
request to be added to the Jazz Mailing Lists. You do not need to
register in order to download Jazz, but we appreciate it if you do. In
addition to putting yourself on mailing lists (if you choose), we can
make a stronger case for the success of Jazz if we know who is using
it.

Jazz is copyrighted by the University of Maryland, and is available
for all users, in accordance with the Open Source model. It is
available as free software for license according to the Mozilla Public
License.

Notes about Jazz and Open Source: 

* If you download this code, you need to follow the Mozilla Public
  License (MPL). Please note that we are using MPL only as a legal
  framework for Jazz to be released as Open Source code. It has nothing
  to do with Netscape or Netscape code.

* This is "pre-release" software, meaning: 
    - the terms of the license may change; 
    - the baseline for what constitutes the "Original Code" will 
      definitely change;
    - and we don't have all the open source "infrastructure" in place 
      (such as discussion groups and FTP servers for public posting of
      modifications).

* We are releasing this code only to the "interested development
  community," meaning that if you download the code, we really want your
  feedback on both the code and the open source model that we intend to
  use. Specifically, we intend to build an open source community around
  Jazz as a "platform" for user interfaces, while still permitting
  anyone to use Jazz with any applications they wish, including
  proprietary and legacy applications.

* We have not done all the checking that needs to be completed to
 satisfy section 3.4a (third party intellectual property
  claims). Anyone using the code does so at their own risk.

If you re-distribute this code, with or without modifications, then
one of the provisions of the Mozilla Public License, under which you
are using it, is to include the following statement (Exhibit A):

--------------------------------------------------------------------------------

"The contents of this directory tree are subject to the Mozilla Public
License Version 1.0 (the "License"); you may not use this file except
in compliance with the License. You may obtain a copy of the License
at http://www.mozilla.org/MPL/.

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
the License for the specific language governing rights and limitations
under the License.

The Original Code is the Jazz Java Zooming Interface v0.5. 

The Initial Developer of the Original Code is Ben Bederson. Portions
created by Ben Bederson are Copyright (C) University of Maryland. All
Rights Reserved.

Contributor(s): Ben Bederson; Britt McAlister" 

--------------------------------------------------------------------------------

* The University of Maryland is not responsible for applications which use
  Jazz that infringe on third party's intellectual property protection such
  as patents.  While we do not track patents, there are some patents
  in place which protect certain kinds of user interfaces that applications
  could create using Jazz.  Thus, commercial software developers may want to
  investigate:
    - "Fractal Computer User Centerface with Zooming Capability"
      Perlin and Schwartz, New York University, 1994, US. Patent #5,341,466
    - Xerox PARC patents on magic lenses.
