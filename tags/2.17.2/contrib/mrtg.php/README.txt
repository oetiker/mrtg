===============================
MRTG-PHP
       The MTRG log file lister
===============================
Version 1.021
       Written by
              David Boyer &
                     Jo Joseph
===============================

* Intro *

MRTG-PHP is a php based web page that will look for log files from MRTG
and list them on a single page.  It also grabs certain bits of information
from the linked log file to show a description of what file is linked.

The way is was written allows it to automatically find and update itself
if any new log files appear.  It will list them and add the proper links
and text.  Hopefully it will also work with any future versions of MRTG.

It was written because I wanted a way to list MRTG log files, and didn't
want to always come back and update it.  I've found it very handy, I hope
someone out there does too.

* Requirements *

Web server (IIS,Apache etc..)
PHP 3 or higher

* Compatibility *

This is know to work with MRTG V2.9.7 running on a linux apache server.
It's unknown if it'll work with other versions as I've been unable to
try it out on any others.  If you have a different versions of MRTG or
run it on a Windows machine, let me know if it works.  If it doesn't I
will try and fix it, if you fix the code send me some info on what you
changed so I can update the next release and credit you with the bug fix.

* Contact *

David Boyer
E-Mail  : crazydave@ntlworld.com
WebSite : http://www.efsection31.com

Jo Jeseph
E-Mail  : joseph_j@glan-hafren.ac.uk
