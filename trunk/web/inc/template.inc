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
<A HREF="http://oss.oetiker.ch/mrtg/<where/>">Swiss Original</A>.
&nbsp;Mirrors: 
#<A HREF="http://mrtg.planetmirror.com/<where/>">AU</a><!--jason andrade <jason@dstc.edu.au> -->
#<A HREF="http://mirrors.bchosting.com/mrtg/<where/>">CA</a><!--Chris Phillips BChosting.com-->
#<A HREF="http://mrtg.paracoda.com/<where/>">CA</a><!--Hossam Hossny <admin@paracoda.com> -->
<A HREF="http://www.mrtg.cz/<where/>">CZ</a><!--Martin Och <martin@och.cz>-->
<A HREF="http://mrtg-fr.agarik.com/<where/>">FR</a><!--Laurent SEROR seror@agarik.com-->
#<A HREF="http://www.mrtg.it/<where/>">IT</a><!--Vicki Vinci root@power.it -->
<A HREF="http://mrtg.magaltavor.com/<where/>">LB</a><!-- Jocelyn habib <jhabib@terra.net.lb> -->
#<A HREF="http://mrtg.grunn.org/<where/>">NL</a><!--Webmaster <webmaster@grunn.org>-->
<A HREF="http://mrtg.meulie.net/<where/>">NO</a><!--Evert Meulie <evert@meulie.net> -->
#<A HREF="http://mrtg.francenet.ro/<where/>">RO</a><!--Dan Draghici <dan.draghici@ulbsibiu.ro>-->
<A HREF="http://mrtg.cs.pu.edu.tw/<where/>">TW</a><!--Hsun-Chang Chang <hsunchang@gmail.com>-->
<A HREF="http://mrtg.mirror.graemef.net/<where/>">UK</a><!--Graeme Fowler <graeme@graemef.net>-->
#<A HREF="http://www.bigwebmaster.com/mrtg/<where/>">US</a><!--Brian Annas <questions@bigwebmaster.com>-->
#<A HREF="/<where/>"></a><!---->
#<A HREF="/<where/>"></a><!---->
#<A HREF="/<where/>"></a><!---->

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
<a href="http://people.ee.ethz.ch/oetiker/wish/"><img border="0" alt="Make Tobi Happy" src="$(ROOT)/inc/button.png"/></a>
</div>
<div id="googlead_search">
<!-- SiteSearch Google -->
<form method="get" action="http://www.google.com/custom" target="_top">
<table border="0" bgcolor="#ffffff">
<tr><td nowrap="nowrap" valign="top" align="left" height="32">
<a href="http://www.google.com/">
<img src="http://www.google.com/logos/Logo_25wht.gif" border="0" alt="Google" align="middle"></img></a>
<br/>
<input type="hidden" name="domains" value="oss.oetiker.ch"></input>
<input type="text" name="q" size="22" maxlength="255" value=""></input>
</td></tr>
<tr>
<td nowrap="nowrap">
<table>
<tr>
<td>
<input type="radio" name="sitesearch" value="oss.oetiker.ch" checked="checked"></input>
<font size="-1" color="#000000">oss.oetiker.ch</font>
</td>
<td>
<input type="radio" name="sitesearch" value=""></input>
<font size="-1" color="#000000">Web</font>
</td>
</tr>
</table>
<input type="submit" name="sa" value="Search"></input>
<input type="hidden" name="client" value="pub-8135238818549668"></input>
<input type="hidden" name="forid" value="1"></input>
<input type="hidden" name="channel" value="1985457903"></input>
<input type="hidden" name="ie" value="ISO-8859-1"></input>
<input type="hidden" name="oe" value="ISO-8859-1"></input>
<input type="hidden" name="cof" value="GALT:#FE754D;GL:1;DIV:#345D98;VLC:345D98;AH:center;BGC:FFFFFF;LBGC:E4E4E4;ALC:345D98;LC:345D98;T:000000;GFNT:345D98;GIMP:345D98;LH:35;LW:100;L:http://oss.oetiker.ch/mrtg/images/mrtg_logo.gif;S:http://oss.oetiker.ch/mrtg;LP:1;FORID:1;"></input>
<input type="hidden" name="hl" value="en"></input>
</td></tr></table>
</form>
</div>
<!-- SiteSearch Google -->
</td>
<!-- Navbar code end -->

<!-- Content code start -->
<td id="content_container">
<div id="googlead_right">
<script type="text/javascript"><!--
google_ad_client = "pub-8135238818549668";
google_ad_width = 160;
google_ad_height = 600;
google_ad_format = "160x600_as";
google_ad_type = "text";
google_ad_channel ="3435820243";
google_color_border = "FE754D";
google_color_bg = "F0F0F0";
google_color_link = "000000";
google_color_url = "345D98";
google_color_text = "000000";
//--></script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>
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
<perl>
if ( -s "$(WML_SRC_FILENAME)" > 4000 ) {
print <<'GOOGLEAD';
<p>
<script type="text/javascript"><!--
google_ad_client = "pub-8135238818549668";
google_ad_width = 728;
google_ad_height = 90;
google_ad_format = "728x90_as";
google_ad_type = "text";
google_ad_channel ="3710326600";
google_color_border = "FE754D";
google_color_bg = "F0F0F0";
google_color_link = "000000";
google_color_url = "345D98";
google_color_text = "000000";
//--></script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</p>
GOOGLEAD
}
</perl>
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
