
   The Multi Router Traffic Grapher
   
  Version 2.5, 24th October 1997
  
   Programming by [1]Tobias Oetiker [2]<oetiker@ee.ethz.ch>
   [3]Dave Rand [4]<dlr@bungi.com>
   and a number of other people from the Global-Village
   Documentation by [5]Tobias Oetiker [6]<oetiker@ee.ethz.ch>
   
   Contents 
     * [7]What is the Multi Router Traffic Grapher
     * [8]Highlights of MRTG
     * [9]The History
     * [10]Release Notes
     * [11]Getting and Installing MRTG
     * [12]Configuration Tips
     * [13]Frequently Asked Questions
     * [14]The MRTG Mailing List
     * [15]Windows NT Notes
       
   What is the Multi Router Traffic Grapher 
   
   The Multi Router Traffic Grapher (MRTG) is a tool to monitor the
   traffic load on network-links. MRTG generates HTML pages containing
   GIF images which provide a LIVE visual representation of this traffic.
   Check [16]http://www.ee.ethz.ch/stats/mrtg/ for an example. MRTG is
   based on Perl and C and works under UNIX and Windows NT. MRTG is being
   successfully used on many sites arrond the net. Check the
   [17]MRTG-Site-Map.
   
   MRTG is available under the GNU PUBLIC LICENSE.
   The only thing I would like to ask happy users to do, is to
   send a Picture Postcard to:
   Tobias Oetiker, D-ELEK, ETH Zentrum, CH-8092 Zurich, Switzerland
   
   MRTG consists of a Perl script which uses SNMP to read the traffic
   counters of your routers and a fast C program which logs the traffic
   data and creates beautiful graphs representing the traffic on the
   monitored network connection. These graphs are embedded into webpages
   which can be viewed from any modern Web-browser
   
   In addition to a detailed daily view, MRTG also creates visual
   representations of the traffic seen during the last seven days, the
   last four weeks and the last twelve months. This is possible because
   MRTG keeps a log of all the data it has pulled from the router. This
   log is automatically consolidated, so that it does not grow over time,
   but still contains all the relevant data for all the traffic seen over
   the last two years. This is all performed in an efficient manner.
   Therefore you can monitor 50 or more network links from any halfway
   decent UNIX box.
   
   MRTG is not limited to monitoring traffic though, it is possible to
   monitor any SNMP variable you choose. You can even use an external
   program to gather the data which should be monitored via MRTG. People
   are using MRTG, to monitor things such as System Load, Login Sessions,
   Modem availability and more. MRTG even allows you to accumulate two or
   more data sources into a single graph.
   
   Highlights of MRTG 
    1. Works on most UNIX platforms and Windows NT
    2. Uses Perl for easy customization
    3. Has a highly portable SNMP implementation written entirely in Perl
       thanks to Simon Leinen. There is no need to install any external
       SNMP package.
    4. MRTG's logfiles do NOT grow. Thanks to the use of a unique data
       consolidation algorithm.
    5. MRTG comes with a semi-automatic configuration tool.
    6. MRTG's query engine checks for port reconfigurations on the router
       and warns the user when they occur.
    7. Time critical routines are written in C thanks to the initiative
       of Dave Rand my Co-Author
    8. Graphics are generated directly in GIF format, using the GD
       library by Thomas Boutell.
    9. The look of the webpages produced by MRTG is highly configurable.
   10. MRTG is available under the GNU PUBLIC LICENSE.
       
   History of MRTG 
   
   In 1994 I was working at a site where we had one 64kbit line to the
   outside world. Obviously everybody was interested in knowing how the
   link was performing. So I wrote a quick hack which created a
   constantly updated graph on the web, showing the traffic load on our
   Internet link. This eventually evolved into a rather configurable Perl
   script called MRTG-1.0 which I released in spring 1995. After a few
   updates I left my job at DMU, to start work at the Swiss Federal
   Institute of Technology. Due to lack of time I had to put MRTG aside.
   One day in January of 1996, I received email from Dave Rand asking if
   I had any ideas why MRTG was so slow. Actually I did. MRTG's
   programming was not very efficient and it was written entirely in
   Perl. After a week or so, Dave wrote back to me and said he had tried
   what I had suggested for improving MRTG's speed. Since the changes did
   not help much, he had decided to rewrite the time-critical sections of
   MRTG in C. The code was attached to his email. His tool increased the
   speed of MRTG by a factor of 40! This got me out of my 'MRTG
   ignorance' and I started to spend my spare time developing of MRTG-2.
   
   Soon after MRTG-2 development had begun I started to give beta copies
   to interested parties. In return I got many feature patches, a lot of
   user feedback and bug fixes. The product you are getting now is the
   result of a wonderful collaboration of many people. I would like to
   take this opportunity to thank them all. (See the files CHANGES and
   CONTRIBUTORS in the MRTG distribution.)
   
   Release Notes 
   
   Version 2.5
          Bugfixes: Skewing at log interval bounderies fixed. White space
          at line-endings in cfgfiles handled gracefully. MaxBytes line
          is only drawn if it is stricly inside the graph. Timezone
          handling improved. Further fighting against the overflow bug.
          Features: More compatible cfgmaker (--vendor switch). Added a
          README about the logfile-format. Made a package in zip format
          available for our NT friends. Same goes for rateup.
          Contribs:: PingProbe updated. Atmmaker to create cfg files for
          FORE ASX. Rewrite of mailstats script.
          
   Version 2.4
          Bugfixes: IconDir works now, mrtg.cfg-dist debugged and
          rewritten, replace int by sprintf "%.0f" to better handle large
          numbers, better 'external command' Target parsing, debugged
          BER.pm ...
          Application tips for Apache-1.2 added to mrtg.cfg-dist
          added nopercent option to supress display of percentage in html
          page.
          added contrib by Philippe.Simonet@SWISSTELECOM.com: a
          c-programm to create gifs showing the traffic distribution over
          time
          
   Version 2.3
          New Configuration Options: IconDir, XScale, YScale, Weekformat
          check 'mrtg.cfg-dist' for details.
          New Pingprobe version
          Improved behaviour of rateup with Unscaled Option, MaxBytes and
          AbsMax set. Now, the graphs will be scaled all the same as soon
          as the traffic goes over MaxBytes.
          Several bugfixes in rateup.c
          
   Version 2.2
          Lots of new and exciting things in the contrib area.
          Made graphs in indexmaker generated pages clickable
          made mrtg observe order of routers in cfg file .... as
          suggested by Mick Ghazey
          Added timezone configurable to set a timezone per router.
          Details in mrtg.cfg-dist as suggested by Jun (John) Wu
          Added MaxBytes sanity check ....
          Fixed portability problem of Makefile under IRIX
          
   Getting and Installing MRTG 
    1. Get the latest Version of MRTG from:
       [18]http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/pub/
    2. Get and compile the GD library by Thomas Boutell:
       [19]http://www.boutell.com/gd/
    3. Make sure you have Perl Version 5.003 or later on your system:
       [20]http://www.perl.com/perl/info/software.html
    4. Edit the MRTG Makefile to fit your system. At least change the
       PERL and GD_LIB variables.
       Then use make rateup to create the rateup binary.
       And make substitute to insert the path of your Perl binary into
       the perlscripts which come with MRTG.
    5. Decide where MRTG should store the webpages it creates. Copy the
       mrtg*.gif files into this directory. They will be referenced in
       the generated webpages. You may also want to move the readme.html
       file to this directory so that you have the docs handy when ever
       you need them.
    6. All the other files from the MRTG distribution should go into your
       MRTG binary directory. This directory can be anywhere because MRTG
       will find its location upon startup. The following files are
       required to be in MRTG-bin: BER.pm, SNMP_Session.pm, mrtg, rateup.
    7. Create your personal mrtg.cfg file. You can use mrtg.cfg-dist as
       an example. It is extensively commented. See the Configuration
       Hints section for some further help. The difficult part in
       creating the configuration file is getting your router-port
       assignment correct. To help you with this, the cfgmaker tool will
       generate all the router specific parts of your configuration file.
       
     cfgmaker <community>@<router-host-name or IP>
       If you don't know the community of your router, try public as
       community name.
    8. If you are upgrading from any pre 2.0 version of MRTG, you need to
       run the convert script with your old logfiles, in order to bring
       them over to the mrtg-2.0 log-file-format.
    9. Try to start MRTG. Type ./mrtg mrtg.cfg on the command line, while
       you are in your MRTG binary directory. MRTG will now parse your
       configuration file, and complain if you have introduced any
       unknown keywords or structures. If MRTG is happy with the cfg
       file, it starts gathering traffic data from the routers you have
       specified. With this information it will then start the rateup
       tool which will create a logfile and a traffic graph GIF for each
       Target. When you start MRTG for the very first time, rateup will
       complain that it can not find any logfiles and the graphs
       generated will look rather empty. Just ignore the complaints. If
       you remove the empty graphs, and run MRTG again, rateup will
       create new graphs which look better.
   10. Integrate MRTG into your crontab. Just add the following line to
       your crontab file to have MRTG run every 5 minutes (The line is
       broken for readability only. Replace the backslash in the first
       line with the second line):
       0,5,10,15,20,25,30,35,40,45,50,55 * * * * \
       <mrtg-bin>/mrtg <path to mrtg-cfg>/mrtg.cfg
       
   Configuration Tips 
     * If you are monitoring a number of links, you might want to create
       an overview page. For our own site I have created the indexmaker
       script, which you can use to create a html page containing hrefs
       that point to your individual traffic statistics pages. Note, that
       you need to edit this script for your purposes. The script you
       got, includes our Universities Logo
       (http://www.ee.ethz.ch/eth.199x32.gif) into the page.
       indexmaker <mrtg.cfg> <regexp for router-names>
     * If you are monitoring many targets, use the special target names
       '^' and '$' to prepend or append text to any of the Keywords in
       the sections below. Note that the definition of the '^' and '$'
       targets are position dependant. They always influence the lines
       bleow in the cfg file.
     * Since MRTG updates it's graphs every 5 minutes, you may experience
       problems with proxy caches and local Netscape browser caches.
       Sometimes these caches will return the old cached graphics instead
       of the real and updated versions from the webserver.
       If you are running the apache webserver, you can use the
       WriteExpire Keyword in the mrtg.cfg file. With this, mrtg will
       create *.meta files for each gif and html page. These files will
       contain 'Expire' headers which the Apache webserver can ship out
       together with the gif and html pages (Use to MetaDir keyword in
       the apache config file to enable this). With the information from
       the expire headers, Netscape and all the proxy caches will know
       when they have to fetch a new version of the file from your
       website and when they can use their cached version.
     * Although MRTG's primary use is traffic monitoring, you can observe
       any SNMP variable you want. People are using it to monitor
       ModemBanks, ServerLoad, ErrorRates on Interfaces and many other
       things. If you are using MRTG for something other than traffic
       monitoring, please send me a short blurb to include here. Best
       would be with a sample URL and some hints about how you have
       configured MRTG ...
       
   Frequently Asked Question with Answers 
   
   Q:I need more documentation ... 
   A:Make sure you have checked the files 'mrtg.cfg-dist' and
   'mibhelp.txt' as well as the contributed scripts in the 'contrib'
   directory of you mrtg distribution. If you need even more infos, make
   sure to check the mailing list archive as well. There has also been an
   article about SNMP and mrtg in a recent Linux Journal. It's author
   David Guerroro has made it available on the net. Check
   [21]http://www.mec.es/~david/papers/snmp 
   
   Q:My perl complains about the SNMP_Session.pm library ... 
   A:If you are running a version of perl before 5.002 you should use
   'SNMP_Session.pm-for-perl5.001.
   
   Q:The GIFs created by MRTG look very strange. Not all the grid lines
   are drawn and ... 
   A:Remove the *-{week,day,month,year}.gif files and start MRTG again.
   Using MRTG for the first time, you might have to do this twice. This
   will also help, when you introduce new routers into the cfg file.
   
   Q: What is my Community Name?
   A:Try 'public', as this is the default Community Name.
   
   Q: I compiled your program and I get the following errors: at the
   command line I typed ./mrtg kirit.cfg and I get :

    Can't locate Socket.pm in @INC at /SNMP_Session.pm line 27.
    BEGIN failed--compilation aborted at /SNMP_Session.pm line 27.
    BEGIN failed--compilation aborted at ./mrtg line 356.

   A: You need to get Perl5 installed properly. Socket.pm comes with
   Perl5 and is an integral part of Perl5. Perl5 comes with compiled in
   defaults about where it should look for its libraries (eg Socket.pm).
   Type 'perl -V' to see what your perl assumes ... And get it fixed ...
   Eg by installing it properly.
   
   If your questions are still not answered, make sure to check out the
   [22]Official MRTG FAQ Site and browse the [23]MRTG Mailinglist
   Archives. 
   MRTG Mailing List 
   
   There are two mailing lists for MRTG available. One is called 'mrtg'
   and is a discussion list for users and developers. The other is called
   'mrtg-announce' and is a low volume list for MRTG related
   announcements.
   
   To subscribe to these mailing lists, send a message with the subject
   line subscribe to either mrtg-request@list.ee.ethz.ch or
   mrtg-announce-request@list.ee.ethz.ch. For posting to the mrtg list
   use the address mrtg@list.ee.ethz.ch.
   
   Further information about the usage of the mailing lists is available
   by sending a message with the subject line 'help' to either one of the
   request addresses.
   
   For past activity there is also a mailing list archive available:
   [24]http://www.ee.ethz.ch/~slist/mrtg
   
   MRTG on Windows NT 
   
   By Stuart Schneider <SchneiS@testlab.orst.edu>
   
   To setup mrtg on a WindowsNT system, you can follow the instructions
   already provided for UNIX systems with the following addition:
   
   6.5. Change the $main::OS setting at the top of the mrtg script to
   equal 'NT'.
   
   Or, for those who need a little extra help, follow these steps:
   
     * Download and unpack the latest version of mrtg from:
       [25]http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/pub/.
     * Download and install the latest version of Perl 5 for Win32 from
       [26]Activware. Check the [27]Perl for Win32 FAQ for more info on
       perl.
     * Download the pre-compiled version of rateup from:
       [28]http://www.testlab.orst.edu/traffic/rateup.zip
     * Edit the main mrtg script downloaded in step #1 and remove the "#"
       from the beginning of the line that reads "$main::OS = 'NT';".
     * Download and install the NT cron daemon from: [29]VSL
     * Create a batch file with the following command: perl {path to
       mrtg}\mrtg {path to mrtg.cfg}\mrtg.cfg
       For example: perl c:\mrtg\mrtg c:\mrtg\mrtg.cfg
     * Use cfgmaker or manually configure your mrtg.cfg file
       (documentation on the structure of the file is in the file
       mrtg.cfg-dist).
     * Execute your batch file from step #6 from a command prompt to
       verify that there are no errors in your mrtg.cfg file and that
       everything is working correctly. (On the first pass it is normal
       to see four warnings from Rateup about your log files for each
       router interface).
     * If everything looks good, configure the cron service to run the
       batch file from step #6 every 5 minutes.
     _________________________________________________________________
   
   If you have any questions about this program, or have it up and
   running,
   we would like to hear from you:
   
   [30][31]MRTG [32]
   2.5-1997/10/24 [33]Tobias Oetiker [34]<oetiker@ee.ethz.ch>
   and [35]Dave Rand [36]<dlr@bungi.com>

References

   1. http://ee-staff.ethz.ch/~oetiker
   2. mailto:oetiker@ee.ethz.ch
   3. http://www.bungi.com/
   4. mailto:dlr@bungi.com
   5. http://ee-staff.ethz.ch/~oetiker
   6. mailto:oetiker@ee.ethz.ch
   7. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#WHAT
   8. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#HIGH
   9. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#HIST
  10. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#RELE
  11. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#INST
  12. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#TIPS
  13. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#FAQ
  14. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#LIST
  15. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/readme.html#NT
  16. http://www.ee.ethz.ch/stats/mrtg/
  17. file://localhost/usr/tardis/delek/staff/support/data/tools/www/mrtg/users.html
  18. http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/pub/
  19. http://www.boutell.com/gd/
  20. http://www.perl.com/perl/info/software.html
  21. http://www.mec.es/~david/papers/snmp
  22. http://www.ltinet.net/info/mrtg/noflashmrtg.htm
  23. http://www.ee.ethz.ch/~slist/mrtg
  24. http://www.ee.ethz.ch/~slist/mrtg
  25. http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/pub/
  26. http://www.activeware.com/Download/download.htm
  27. http://www.endcontsw.com/people/evangelo/Perl_for_Win32_FAQ.html
  28. http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/pub/
  29. http://castor.acs.oakland.edu/cgi-bin/vsl-front/File?archive=winsite-winnt&file=miscutil%2fntcnd22%2ezip
  30. http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html
  31. http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html
  32. http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html
  33. http://ee-staff.ethz.ch/~oetiker
  34. mailto:oetiker@ee.ethz.ch
  35. http://www.bungi.com/
  36. mailto:dlr@bungi.com
