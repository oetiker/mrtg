#this seems to confuse just too many things out there ... 
#guess following the standard is not there yet
#<?xml version="1.0" encoding="iso-8859-15"?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.1 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
# this must be the very first line to make doc-type switching work on IE
#use wml::std::logo
#use wml::std::tags
#use wml::des::space
#use wml::des::imgdot
#use wml::std::grid
#use wml::fmt::url
#include <inc/langset.inc>
#include <inc/html.inc>
#include <inc/customtags.inc>
#use wml::des::navbar
#include <inc/navbar-def.inc>
#include <$(ROOT)/navbar.inc>
<html lang="<lang:star: * />" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-15" />
<link* REL="icon" HREF="$(ROOT)/inc/favicon.ico" TYPE="image/ico" />
..Title!>>MRTG - Page without a Title<<..
<title*>MRTG - {#Title#}</title*>
<style type="text/css">
<!--/* <![CDATA[ */
/* ie5 for mac thinks this comment does not end here because of the backslash \*/
@import url("$(ROOT)/design.css");
/* ]]> */-->
</style>
</head>
<body>
<!--[if lt IE 7]><script src="$(ROOT)/inc/IE7/ie7-standard-p.js" type="text/javascript"></script><![endif]-->
<div id="page_header">
<small>
<A HREF="http://people.ee.ethz.ch/~oetiker/webtools/mrtg/<where/>">Swiss Original</A>.&nbsp;Mirrors: 
<A HREF="http://www.bigwebmaster.com/mrtg/<where/>">US</a><!--Brian Annas <questions@bigwebmaster.com>-->
#<A HREF="http://rrdtool.planetmirror.com/<where/>">AU</A><!--jason andrade <jason@dstc.edu.au>-->
#<A HREF="http://rrdtool.cs.pu.edu.tw/<where/>">TW</A><!--Hsun-Chang Chang <hsunchang@gmail.com>-->
#<A HREF="http://ftp.heanet.ie/mirrors/people.ee.ethz.ch/%257Eoetiker/webtools/rrdtool/<where/>">IE</A><!--Colm MacCárthaigh <colm.maccarthaigh@heanet.ie>-->
#<A HREF="http://rrdtool.cyclone.se/<where/>">SE</A><!--Hans Engren <hans@cyclone.se>-->
#<A HREF="http://rrdtool.trexle.net/<where/>">US</A><!--Hossam Hossny <hossam@trexle.com>-->
#<A HREF="http://rrdtool.paracoda.com/<where/>">CA</A><!--Hossam Hossny <admin@paracoda.com>-->
</small>
</div>

<table id="main_container" cellspacing="0" cellpadding="0" border="0">
<tr>
<!-- Navbar code start -->
<td valign="top" id="navbar_container">
<div id="menu">
<navbar:render name=main menumode=inner nohints txtonly select=$(PAGE)/>
</div>
<br/>
<br/>
<br/>
<div>
<a href="http://people.ee.ethz.ch/oetiker/wish"><img border="0" alt="Make Tobi Happy" src="$(ROOT)/inc/button.png"/></a>
</div>
</td>
<!-- Navbar code end -->

<!-- Content code start -->
<td id="content_container">
{#Body#}
<p id="pageauthor">
Last Update: <perl>
<protect pass=2>
use POSIX qw(strftime LC_TIME setlocale); 
foreach my $l (qw($(LANGS))){
        my $lang = lc($l) eq 'de' ? 'de_CH' : $l;
        $lang =~ s/^en.*/sv/i;  
        setlocale(LC_TIME,$lang);
        my $year = strftime "%Y", localtime;
        my $date = strftime "%x", localtime("$(WML_SRC_TIME)"); 
        q{$(AUTHOR)} =~ m{(.+\S+)\s*(<.+>|http://.+)} || die q{No Match for $(AUTHOR)}."\n"; 
        my $text=$1; my $url=$2; $url =~ s/<(\S+)(?:\@|_at_)(\S+)>/mailto:$1\@$2/;
        my $LANG = uc("LANG_$l");
        print <<LINE
[$LANG:$date by <A HREF="$url">$text</A>:$LANG]
LINE
}
</protect>
</perl>
</p>
</td>
</tr>
</table>
<!-- content code end -->
<div class="orange_ruller">&nbsp;</div>

<!-- footer code start -->
<div id="page_footer">
<table class="footer_splitter" cellspacing="0" cellpadding="0" border="0">
<tr><td id="footer_logo">
<img src="$(ROOT)/images/foot_logo.gif" alt="MRTG" />
</td><td>
<small>
Web design by <a href="http://www.templatemonster.com" title=" Template Monster - Website Templates | Flash Templates | Web Templates Design">Template&nbsp;Monster</a>
</small>
</td></tr>
</table>
</div>

<!-- footer code end -->
<hr class="legacy"/>
<p class="legacy" style="border-width: 1px; border-color: red; padding: 5px;">
<en><b>NOTE:</b> The content of this website is accessible with any browser. The
 graphical
design though relies completely on CSS2 styles. If you see this text, this means
that your browser does not support CSS2. Consider upgrading to a standard conformant
browser like Mozilla <a href="http://www.getfirefox.com">Firefox</a> or
<a href="http://www.opera.com">Opera</a> but also Apple's <a href="http://www.apple.com/safari/">Safari</a>
or KDE's <a href="http://www.konqueror.org">Konqueror</a> for example. It may also be that you
are looking at a mirror page which did not copy <a href="$(ROOT)/design.css">the CSS</a> for this page. Or if some pictures
are missing, then the mirror may not have picked up the contents of either the <a href="$(ROOT)/images/">images</a> or the <a href="$(ROOT)/inc/">inc</a> directory.</en>
#<de><b>HINWEIS:</b> Diese Website funktioniert mit jedem Browser. Die graphische Präsentation jedoch
#basiert komplett auf CSS2. Beispiele für CSS2 konforme Browser sind zum Beispiel  <a href="http://www.getfirefox.com">Firefox</a>
#<a href="http://www.opera.com">Opera</a> oder auch <a href="http://www.apple.com/safari/">Safari</a> von Apple und
#<a href="http://www.konqueror.org">Konqueror</a> aus dem KDE Projekt.
#</de>
</p> 
</body>
</html>

# All the rest goes into Body
..Body>>
