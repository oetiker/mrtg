# -*- mode: Perl -*-
######################################################################
### Localization of mrtg output pages
######################################################################
#                                                                    #
#   This is a generated perl module file.                            #
#   Please see the perl script mergelocale.pl and the language       #
#   databasefiles skelton.pm0 and locale.*.pmd in translate/.        #
#   If you want to contribute to mrtg change in the *.pmd files.     #
#   If you just want to change your own mrtg: Go ahead and edit!     #
#                                                                    #
######################################################################
### Defines programs which handles centralized pattern matching and pattern 
### replacements in order to translate the given strings
######################################################################
### Created by:  Morten Storgaard Nielsen <msn@ipt.dtu.dk>
###################################################################
#
# Distributed under the GNU copyleft
#
###################################################################
### Locale by: 
###      Chinese/¤¤¤åÁcÅé
###      => Tate Chen ³¯¥@°¶ <tate@joy-tech.com.tw>
###      => Ryan Huang ¶ÀªF¶© <ryan@asplord.com>
###      Brazil/Brazilian Portuguese
###      => Luiz Felipe R E <luizfelipe@encarnacao.com>
###      => Gleydson Mazoli da Silva <gleydson@debian.org> (Atualização)
###      Bulgarian/Áúëãàğñêè
###      => Yovko Lambrev <yovko@sdf.lonestar.org>
###      catalan/Català
###      => LLuís Gras <lluis@seccat.com>
###      Simplified Chinese/¼òÌåÖĞÎÄ
###      => »Æ»ª¶° <webmaster@kingisme.com>
###	 => QQ:582955 »¶Ó­ÌÖÂÛFreeBSD
###	 => ĞŞÕıÁËÔ­À´µÄ´íÎó.·¢²¼ĞÂ°æ±¾.
###      Croatian/Hrvatski
###      => Dinko Korunic <kreator@fly.srk.fer.hr>
###      Czech/Èesky
###      => Martin Och <martin@och.cz>
###      Danish/Dansk   
###      => Morten Storgaard Nielsen <msn@ipt.dtu.dk>
###      Dutch/Nederlands
###      => Barry van Dijk <barry@dijk.com>
###      Estonian/Eesti   
###      => Klemens Kasemaa <klem@linux.ee>
###      ÆüËÜ¸ì(EUC-JP)
###      => Fuminori Uematsu <uematsu@kgz.com>
###      Finnish/Suomi
###      => Jussi Siponen <jussi.siponen@online.tietokone.fi>
###      French/Francais
###      => Fabrice Prigent <fabrice.prigent@univ-tlse1.fr>
###         and Stéphane Marzloff <secrer@le-bar.fdn.fr>
###      Galician/Galego
###      => David Garabana Barro <dgaraban@arrakis.es>
###      Chinese/¼òÌåºº×Ö
###      => Zhanghui ÕÅ»Ô <zhanghui2@asiainfo.com>
###      Chinese/ÖĞÎÄ¼òÌå
###      => Peter Wong ×ÓÈÙ<me@tcpip.com.cn>
###      German/Deutsch   
###      => Ilja Pavkovic <illsen@gumblfarz.de>
###      Greek/Ellinika
###      => Simos Xenitellis <simos@hellug.gr>
###      Hungarian/Magyar   
###      => Levente Nagy <levinet@euroweb.hu>
###      Icelandic/Islenska   
###      => Halldor Karl Högnason <halldor.hognason@islandssimi.is>
###      Indonesian/Indonesia   
###      => Jamaludin Ahmad <jamaludin@jamalinux.com>
###      taken from malaysian translation 
###        by  Assakhof Ab. Satar <assakhof@mimos.my> 
###      $BF|K\8l(B(ISO-2022-JP)
###      => Fuminori Uematsu <uematsu@kgz.com>
###      Italian/Italiano
###      => Andrea Rossi <rouge@shiny.it>
###      Korean
###      => Kensoon Hwang <lovesh@static.co.kr>
###         CHOI Junho <cjh@kr.FreeBSD.org>
###      Lithuanian/Lietuviğkai
###      => ve <ve@hardcore.lt>
###      Macedonian/Makedonski   
###      => Delev Zoran <delevz@esmak.com.mk>
###      Malaysian/Malay   
###      => Assakhof Ab. Satar <assakhof@mimos.my>
###      Norwegian/norsk   
###      => Knut Grøneng <knut.groneng@merkantildata.no
###      Polish/Polski
###      => Lukasz Jokiel <Lukasz.Jokiel@klonex.com.pl>
###      Portuguese/Português   
###      => Diogo Gomes <etdgomes@ua.pt> 
###      Romãn/Romanian
###      => József Szilágyi <jozsi@maxiq.ro>
###      Russian/òÕÓÓËÉÊ
###      => äÍÉÔÒÉÊ óÉ×ÁŞÅÎËÏ <dima@chg.ru>
###      Russian1251/Ğóññêèé1251
###      => Àëåêñàíäğ Ğåäşê <aredyuk@irmcity.com>
###      Serbian/Srpski
###      => Ratko Bucic <ratko@ni.ac.yu>
###      Slovak/Slovensky
###      => Ladislav Mihok <laco@mrokh.shmu.sk>
###      Slovenian/Slovensko
###      => Aljosa Us <us@sweet-sorrow.com>
###      Spanish/Español
###      => Marcelo Roccasalva <marcelo@linuxfan.com>
###      Swedish/Svenska   
###      => Clas Mayer <clas@mayer.se>
###      Turkish/Türkçe
###      => Özgür C. Demir <ozgurcd@koc.net>
###      Ukrainian/õËÒÁ§ÎÓØËÁ
###      => óÅÒÇ¦Ê çÕÍ¦Î¦ÌÏ×ÉŞ <gray@arte-fact.net>
###      Ukrainian/Óêğà¿íñüêà
###      => Olexander Kunytsa <xakep@snark.ukma.kiev.ua>
###
### Contributions and fixes by:
###
###      0.05 fixed DARK GREEN entry		(msn@ipt.dtu.dk)
###           fixed credits for native language (msn@ipt.dtu.dk)
###	 0.06 added the PATCHTAGs               (msn@ipt.dtu.dk)
###           fixed several small errors        (msn@ipt.dtu.dk)
###	 0.07 changed PATCHTAG to support 
###           mergelocale.pl                    (msn@ipt.dtu.dk)
###
######################################################################
###
package locales_mrtg;

require 5.002;
# make sure we do not get hit by UTF-8 here
no locale;
use strict;
use vars qw(@ISA @EXPORT $VERSION);
use Exporter;

$VERSION = '0.07';

@ISA = qw(Exporter);

@EXPORT = qw
(
  &english
  &big5
  &brazilian 
  &bulgarian
  &catalan
  &chinese
  &croatian
  &czech
  &danish
  &dutch
  &estonian
  &eucjp
  &german
  &french
  &galician
  &gb
  &gb2312
  &german
  &greek
  &hungarian
  &icelandic 
  &indonesia
  &iso2022jp
  &italian
  &korean
  &lithuanian
  &macedonian
  &malay
  &norwegianh
  &polish
  &portuguese
  &romanian
  &russian
  &russian1251
  &serbian
  &slovak
  &slovenian
  &spanish
  &swedish
  &turkish
  &ukrainian
  &ukrainian1251
);

%lang2tran::LOCALE=  
(
  'english'      => \&english,
  'default'      => \&english, 
  'big5'         => \&big5, 
  '¤¤¤åÁcÅé'     => \&big5,
  'brazil'       => \&brazilian,
  'brazilian'    => \&brazilian,
  'bulgarian'	 => \&bulgarian,
  'áúëãàğñêè'    => \&bulgarian,
  'catalan'	 => \&catalan,
  'catalan'	 => \&catalan,
  'chinese'          => \&chinese,
  '¼òÌåÖĞÎÄ'         => \&chinese,
  'croatian'	 => \&croatian,
  'hrvatski'       => \&croatian,
  'czech' 	 => \&czech,
  'danish'       => \&danish, 
  'dansk'        => \&danish,
  'dutch'        => \&dutch,
  'nederlands'   => \&dutch,
  'estonian'       => \&estonian, 
  'eesti'        => \&estonian,
  'eucjp'        => \&eucjp,
  'euc-jp'       => \&eucjp, 
  'finnish'       => \&finnish, 
  'suomi'        => \&finnish,
  'french'       => \&french,
  'francais'     => \&french,
  'galician'       => \&galician,
  'galego'        => \&galician,
  'gb'         => \&gb, 
  '¼òÌåºº×Ö'     => \&gb,
  'gb2312'         => \&gb2312, 
  'ÖĞÎÄ¼òÌå'     => \&gb2312,
  'german'       => \&german, 
  'german'        => \&german,
  'greek'    	 => \&greek,
  'ellinika' 	 => \&greek,
  'hungarian'       => \&hungarian, 
  'magyar'        => \&hungarian,
  'icelandic'       => \&icelandic, 
  'islenska'        => \&icelandic,
  'indonesia'     => \&indonesia, 
  'indonesian'	  => \&indonesia, 
  'iso2022jp'    => \&iso2022jp,
  'iso-2022-jp'  => \&iso2022jp, 
  'italian'    	 => \&italian,
  'italiano' 	 => \&italian,
  'korean'      => \&korean,
  'lithuanian'       => \&lithuanian, 
  'lietuviğkai'        => \&lithuanian,
  'macedonian'       => \&macedonian, 
  'makedonski'        => \&macedonian,
  'malay'       => \&malay, 
  'malaysian'   => \&malay,
  'norwegian'       => \&norwegian, 
  'norsk'        => \&norwegian,
  'polish'	 => \&polish,
  'polski'       => \&polish,
  'portuguese'     => \&portuguese,
  'romanian'     => \&romanian,
  'romãn'        => \&romanian,
  'russian'	 => \&russian,
  'òÕÓÓËÉÊ'      => \&russian,
  'russian1251'	 => \&russian1251,
  'Ğóññêèé1251'      => \&russian1251,
  'serbian' 	 => \&serbian,
  'slovak' 	 => \&slovak,
  'slovenian' 	 => \&slovenian,
  'spanish'	 => \&spanish,
  'espanol'	 => \&spanish,
  'swedish'       => \&swedish, 
  'svenska'        => \&swedish,
  'turkish'	 => \&turkish,
  'turkce'	 => \&turkish,
  'ukrainian'	 => \&ukrainian,
  'õËÒÁ§ÎÓØËÁ'      => \&ukrainian,
  'ukrainian1251'	=> \&ukrainian1251,
  'Óêğà¿íñüêà1251'	=> \&ukrainian1251,
);

%credits::LOCALE=
  (
# default
   'default' =>
   "<HR NOSHADE>
    Prepared for localization by
    <NOBR><A HREF=\"http://www.ipt.dtu.dk\">Morten S. Nielsen</A>
  <A HREF=\"mailto:msn\@ipt.dtu.dk\">
  &lt;msn\@ipt.dtu.dk&gt;</A></NOBR>",
# Chinese/¤¤¤åÁcÅé
   'big5' =>
   "  <HR NOSHADE>
    ¤¤¤å¤Æ§@ªÌ
    <NOBR><A HREF=\"http://www.joy-tech.com.tw/~tate\">Tate Chen</A>
  <A HREF=\"mailto:tate\@joy-tech.com.tw\">
  &lt;tate\@joy-tech.com.tw&gt;</A></NOBR>
  and
  <NOBR><A HREF=\"http://asplord.com\">¶ÀªF¶©</A>
  <A HREF=\"mailto:ryan\@asplord.com\">
  &lt;ryan\@asplord.com&gt;</A>  
  </NOBR>",
# Brazil/brazilian
   'brazilian' =>
   "  <HR NOSHADE>
    Localiza&ccedil;&atilde;o efetuada por
    <NOBR><A HREF=\"http://www.encarnacao.com\">Luiz Felipe R E</A>
  <A HREF=\"mailto:luizfelipe\@encarnacao.com\">
  &lt;luizfelipe\@encarnacao.com&gt;</A>
   atualização por
    <NOBR>Gleydson Mazioli da Silva
  <A HREF=\"mailto:gleydson\@debian.org\">
  &lt;gleydson\@debian.org&gt;</A></NOBR>",
# Bulgarian/Áúëãàğñêè
   'bulgarian' =>
   "  <HR NOSHADE>
    Ëîêàëèçàöèÿ íà áúëãàğñêè åçèê: 
    <NOBR><A HREF=\"http://linux.gyuvet.ch/\">Éîâêî Ëàìáğåâ</A>
  <A HREF=\"mailto:yovko\@sdf.lonestar.org\">
  &lt;yovko\@sdf.lonestar.org&gt;</A></NOBR>",
# catalan/catalan
    'catalan' =>
    "  <HR NOSHADE>
      Preparat per a localització per:
     <NOBR><A HREF=\"mailto:lluis\@seccat.com\">LLuís Gras</A>
     </NOBR>",
# Simplified Chinese/¼òÌåÖĞÎÄ
   'chinese' =>
   "  <HR NOSHADE>
    È«ĞÂ¼òÌåÖĞÎÄºº»¯£º
    <NOBR><A HREF=\"http://www.kingisme.com\">»Æ»ª¶°</A>
  <A HREF=\"mailto:webmaster\@kingisme.com\">
  &lt;webmaster\@kingisme.com&gt;</A></NOBR>",
# Croatian/hrvatski
   'croatian' =>
   "  <HR NOSHADE>
  <TD WIDTH=388 ALIGN=RIGHT><FONT FACE=\"Arial,Helvetica\" SIZE=2>
  Hrvatska lokalizacija - <NOBR>Dinko Korunic
  <A HREF=\"mailto:kreator\@fly.srk.fer.hr\">
  &lt;kreator\@fly.srk.fer.hr&gt;</A></NOBR>",
# Czech/Èesky
   'czech' =>
   "  <HR NOSHADE>
    Èeskı pøeklad pøipravil
    <NOBR><A HREF=\"http://www.och.cz\">Martin Och</A>
  <A HREF=\"mailto:martin\@och.cz\">
  &lt;martin\@och.cz&gt;</A></NOBR>",
# Danish/dansk
   'danish' =>
   "  <HR NOSHADE>
    Forberedt for sprog samt oversat til dansk af
    <NOBR><A HREF=\"http://www.ipt.dtu.dk\">Morten S. Nielsen</A>
  <A HREF=\"mailto:msn\@ipt.dtu.dk\">
  &lt;msn\@ipt.dtu.dk&gt;</A></NOBR>",
# the danish string means: "Prepared for languages and translated to danish by"
# Dutch/nederlands
   'dutch' =>
   "  <HR NOSHADE>
    Vertaald naar het Nederlands door
    <NOBR><A HREF=\"http://doema.peterson.nl\">Barry van Dijk</A>
  <A HREF=\"mailto:barry\@dijk.com\">
  &lt;barry\@dijk.com&gt;</A>;
  Aangepast door Paul Slootman
  <A HREF=\"mailto:paul\@debian.org\">&lt;paul\@debian.org&gt;</A></NOBR>",
# Estonian/Eesti
   'estonian' =>
   "  <HR NOSHADE>
  T&otilde;lge eesti keelde 
    <NOBR><A HREF=\"http://www.linux.ee/~klem\">Klemens Kasemaa</A>
  <A HREF=\"mailto:klem\@linux.ee\">
  &lt;klem\@linux.ee&gt;</A></NOBR>",
# the estonian string means: "Translation to estonian by"
# eucjp/euc-jp
   'eucjp' =>
   "  <HR>
  <FONT SIZE=2>ÆüËÜ¸ìÌõ(EUC-JP)ºîÀ®
  <A HREF=\"http://www.kgz.com/~uematsu/\">¿¢¾¾ Ê¸ÆÁ</A>
  <A HREF=\"mailto:uematsu\@kgz.com\">&lt;uematsu\@kgz.com&gt;</A></FONT>
",
# Finnish/Suomi
   'finnish' =>
   "  <HR NOSHADE>
    Lokalisoinut
    <NOBR>Jussi Siponen
  <A HREF=\"mailto:jussi.siponen\@online.tietokone.fi\">
  &lt;jussi.siponen\@online.tietokone.fi&gt;</A></NOBR>",
# the Finnish string means: "Localized by"
# French/francais
   'french' =>
   "  <HR NOSHADE>
    Localisation effectu&eacute;e par
    <NOBR><A HREF=\"http://cache.univ-tlse1.fr/les.personnes/fabrice.prigent\">Fabrice Prigent</A>
  <A HREF=\"mailto:fabrice.prigent\@univ-tlse1.fr\">
  &lt;fabrice.prigent\@univ-tlse1.fr&gt;</A></NOBR>",
# Galician/Galego
   'galician' =>
   "  <HR NOSHADE>
    Traducido ao galego por
    <NOBR>David Garabana Barro
<A HREF=\"mailto:dgaraban\@arrakis.es\">&lt;dgaraban\@arrakis.es&gt;</A>
    </NOBR>",
# Chinese/¼òÌåºº×Ö
   'gb' =>
   "  <HR NOSHADE>
    ¤¤¤å¤Æ§@ªÌ
    <NOBR><A HREF=\"http://www.asiainfo.com/~zhanghui\">Hui Zhang</A>
  <A HREF=\"mailto:zhanghui2\@asiainfo.com\">
  &lt;zhanghui\@asiainfo.com&gt;</A></NOBR>",
# Chinese/ÖĞÎÄ¼òÌå
   'gb2312' =>
   "  <HR NOSHADE>
    ÖĞÎÄ»¯×÷Õß
    <NOBR><A HREF=\"http://linux.tcpip.com.cn\">Peter Wong</A>
  <A HREF=\"mailto:webmaster\@tcpip.com.cn\">
  &webmaster\@tcpip.com.cn&gt;</A></NOBR>",
# German/deutsch
   'german' =>
   "  <HR NOSHADE>
    Vorbereitet für die Lokalisation von
    <NOBR><A HREF=\"http://www.gumblfarz.de/~illsen\">Ilja Pavkovic</A>
  <A HREF=\"mailto:illsen\@gumblfarz.de\">
  &lt;illsen\@gumblfarz.de&gt;</A></NOBR>",
# Greek/Ellinika
   'greek' =>
   "  <HR NOSHADE>
    Ğñïåôïéìáóßá óôá åëëçíéêÜ áğü ôï
    <NOBR><A HREF=\"http://hq.hellug.gr/~nls\">Óßìï Îåíéôİëëç</A>
  <A HREF=\"mailto:S.Xenitellis\@hellug.gr\">
  &lt;S.Xenitellis\@hellug.gr&gt;</A></NOBR>",
# Hungarian/magyar
   'hungarian' =>
   "  <HR NOSHADE>
    Magyaros&iacute;totta
    <NOBR>Nagy Levente
  <A HREF=\"mailto:levinet\@euroweb.hu\">
  &lt;levinet\@euroweb.hu&gt;</A></NOBR>",
# the hungarian string means: "Prepared for languages and translated to Hungarian by"
# Icelandic/islenska
   'icelandic' =>
   "  <HR NOSHADE>
    &THORN;&yacute;tt yfir &aacute; &iacute;slensku af  
  <NOBR><A HREF=\"http://www.islandssimi.is\">Halld&oacute;r Karl H&ouml;gnason</A>
  <A HREF=\"mailto:halldor.hognason\@islandssimi.is\">
  &lt;halldor.hognason\@islandssimi.is&gt;</A></NOBR>",
# Indonesian/Indonesia
   'indonesia' =>
   "  <HR NOSHADE>
    Terjemahan ke bahasa Indonesia oleh:
    <NOBR><A HREF=\"http://www.jamalinux.com\">Jamaludin Ahmad</A>
  <A HREF=\"mailto:jamaludin_at_jamalinux_dot_com\">
  &lt;jamaludin\@jamalinux.com&gt;</A></NOBR>",
# iso2022jp/iso-2022-jp
   'iso2022jp' =>
   "  <HR>
  <FONT SIZE=2>\e\$BF|K\\8lLu\e(B(ISO-2022-JP)\e\$B:n\@.\e(B
  <A HREF=\"http://www.kgz.com/~uematsu/\">\e\$B?\">>\e(B \e\$BJ8FA\e(B</A>
  <A HREF=\"mailto:uematsu\@kgz.com\">&lt;uematsu\@kgz.com&gt;</A></FONT>
",
# Italian/Italiano
   'italian' =>
   "  <HR NOSHADE>
    Localizzazione effettuata da
    <NOBR><A HREF=\"http://www.shinystat.it\">Andrea Rossi</A>
  <A HREF=\"mailto:rouge\@shiny.it\">
  &lt;rouge\@shiny.it&gt;</A></NOBR>",
# korean
   ,'korean' =>
   "  <HR NOSHADE>
    ÇÑ±Û¸Ş½ÃÁö ¹ø¿ª:
    <NOBR><A HREF=\"mailto:lovesh\@static.co.kr\">È²°Ç¼ø</A>
    ,<A HREF=\"mailto:cjh\@kr.FreeBSD.org\">ÃÖÁØÈ£</A>
  </NOBR>",
# Lithuanian/lietuviğkai
   'lithuanian' =>
   "  <HR NOSHADE>
    Paruoğë ir á lietuviø kalbà iğvertë
    <NOBR><A HREF=\"http://www.hardcore.lt\">ve</A>
  <A HREF=\"mailto:ve\@hardcore.lt\">
  &lt;ve\@hardcore.lt&gt;</A></NOBR>",
# the lithuanian string means: "Prepared for languages and translated to lithuanian by"
# Macedonian/makedonski
   'macedonian' =>
   "  <HR NOSHADE>
    Makedonska lokalizacija - 
    <NOBR><A HREF=\"http://www.esmak.com.mk\">Delev D Zoran</A>
  <A HREF=\"mailto:delevz\@esmak.com.mk\">
  &lt;delevz\@esmak.com.mk&gt;</A></NOBR>",
# the macedonian string means: "Prepared for languages and translated to macedonian by"
# Malaysian/Malay
   'malay' =>
   "  <HR NOSHADE>
    Terjemahan ke bahasa Malaysia/Indonesia oleh:
    <NOBR><A HREF=\"http://www.mimos.my\">Assakhof Ab. Satar</A>
  <A HREF=\"mailto:assakhof\@mimos.my\">
  &lt;assakhof\@mimos.my&gt;</A></NOBR>",
# Danish/dansk
   'norwegian' =>
   "  <HR NOSHADE>
    Oversatt til norsk av
    <NOBR>Knut Grøneng</A>
  <A HREF=\"mailto:knut.groneng\@merkantildata.no\">
  &lt;knut.groneng\@merkantildata.no&gt;</A></NOBR>",
# the norwegian string means: "Translated to norwegian by"
# Polish/polski
   'polish' =>
   "  <HR NOSHADE>
    Polska lokalizacja
  <NOBR><A HREF=\"http://www.klonex.com.pl/~lcj\">Lukasz Jokiel</A>
  <A HREF=\"mailto:Lukasz.Jokiel\@klonex.com.pl\">
  &lt;Lukasz.Jokiel\@klonex.com.pl&gt;</A></NOBR>",
# Português/portuguese 
   'portuguese' =>
   "  <HR NOSHADE>
    Traduzido por 
    <NOBR><A HREF=\"http://sweet.ua.pt/~etdgomes\">Diogo Gomes</A>
  <A HREF=\"mailto:etdgomes\@ua.pt\">
  etdgomes\@ua.pt</A></NOBR>",
# Romãn/romanian
   'romanian' =>
   "  <HR NOSHADE>
    Tradus de
    <NOBR><A HREF=\"http://szjozsef.go.ro/\">József Szilágyi</A>
  <A HREF=\"mailto:jozsi\@maxiq.ro\">
  &lt;jozsi\@maxiq.ro&gt;</A></NOBR>",
# Russian/òÕÓÓËÉÊ
   'russian' =>
   "  <HR NOSHADE>
    ğÅÒÅ×ÏÄ ÎÁ ÒÕÓÓËÉÊ ÑÚÙË:
    <NOBR><A HREF=\"http://mitya.pp.ru/\">äÍÉÔÒÉÊ óÉ×ÁŞÅÎËÏ</A>
  <A HREF=\"mailto:mitya\@cavia.pp.ru\">
  &lt;mitya\@cavia.pp.ru&gt;</A></NOBR>",
# Russian1251/Ğóññêèé1251
   'russian1251' =>
   "  <HR NOSHADE>
    Ïåğåâîä íà ğóññêèé ÿçûê (êîäèğîâêà 1251):
    <NOBR><A HREF=\"http://www.irmcity.com\">Àëåêñàíäğ Ğåäşê</A>
  <A HREF=\"mailto:aredyuk\@irmcity.com\">
  &lt;aredyuk\@irmcity.com&gt;</A></NOBR>",
# Serbian/Srpski
   'serbian' =>
   "  <HR NOSHADE>
  <TD WIDTH=388 ALIGN=RIGHT><FONT FACE=\"Arial,Helvetica\" SIZE=2>
  Ported to Serbian by / Srpski prevod uradio: 
    <NOBR>Ratko Buèiæ
  <A HREF=\"mailto:ratko\@ni.ac.yu\">
  &lt;ratko\@ni.ac.yu&gt;</A></NOBR>",
# Slovak/Slovensky
   'slovak' =>
   "  <HR NOSHADE>
    Slovenskı preklad pripravil
    <NOBR>Ing. Ladislav Mihok
  <A HREF=\"mailto:laco\@mrokh.shmu.sk\">
  &lt;laco\@mrokh.shmu.sk&gt;</A></NOBR>",
# Slovenian/Slovensko
   'slovenian' =>
   "  <HR NOSHADE>
  <TD WIDTH=388 ALIGN=RIGHT><FONT FACE=\"Arial,Helvetica\" SIZE=2>
  Slovenski prevod pripravil
    <NOBR>Aljosa Us
  <A HREF=\"mailto:us\@sweet-sorrow.com\">
  &lt;us\@sweet-sorrow.com&gt;</A></NOBR>",
# Spanish/español
    'spanish' =>
    "  <HR NOSHADE>
      Preparado para localización por
     <NOBR><A HREF=\"mailto:marcelo\@linuxfan.com\">Marcelo Roccasalva</A>
     </NOBR>",
# Swedish/Svenska
   'swedish' =>
   "  <HR NOSHADE>
    &Oumlversatt till svenska av
    <NOBR>Clas Mayer
  <A HREF=\"mailto:clas\@mayer.se\">
  &lt;clas\@mayer.se&gt;</A></NOBR>",
# the Swedish string means: "Prepared for languages and translated to Swedish by"
# Turkish/Türkçe
    'turkish' =>
    "  <HR NOSHADE>
      Türkçeleştiren
     <NOBR><A HREF=\"mailto:ozgurcd\@koc.net\">Özgür C. Demir</A>
     </NOBR>",
# Ukrainian/õËÒÁ§ÎÓØËÁ
   'ukrainian' =>
   "  <HR NOSHADE>
    ğÅÒÅËÌÁÄ ÎÁ ÕËÒÁ§ÎÓØËÕ ÍÏ×Õ:
    <NOBR><A HREF=\"http://www.arte-fact.net/~gray/\">óÅÒÇ¦Ê çÕÍ¦Î¦ÌÏ×ÉŞ</A>
  <A HREF=\"mailto:gray\@arte-fact.net\">
  &lt;gray\@arte-fact.net&gt;</A></NOBR>",
# Ukrainian1251/Óêğà¿íñüêà1251
   'ukrainian1251'	=>
   "  <HR NOSHADE>
  Ïåğåêëàä óêğà¿íñüêîş (cp1251):
  <NOBR>Îëåêñàíäğ Êóíèöÿ<A HREF=\"mailto:xakep\@snark.ukma.kiev.ua\">
  &lt;xakep\@snark.ukma.kiev.ua&gt;</A></NOBR>",
  );

$credits::LOCALE{'¤¤¤åÁcÅé'}=$credits::LOCALE{'big5'};
$credits::LOCALE{'brazil'}=$credits::LOCALE{'brazilian'};
$credits::LOCALE{'áúëãàğñêè'}=$credits::LOCALE{'bulgarian'};
$credits::LOCALE{'catalan'}=$credits::LOCALE{'catalan'};
$credits::LOCALE{'¼òÌåÖĞÎÄ'}=$credits::LOCALE{'Chinese'};
$credits::LOCALE{'hrvatski'}=$credits::LOCALE{'croatian'};
$credits::LOCALE{'czech'}=$credits::LOCALE{'czech'};
$credits::LOCALE{'dansk'}=$credits::LOCALE{'danish'};
$credits::LOCALE{'nederlands'}=$credits::LOCALE{'dutch'};
$credits::LOCALE{'eesti'}=$credits::LOCALE{'estonian'};
$credits::LOCALE{'euc-jp'}=$credits::LOCALE{'eucjp'};
$credits::LOCALE{'finnish'}=$credits::LOCALE{'finnish'};
$credits::LOCALE{'francais'}=$credits::LOCALE{'french'};
$credits::LOCALE{'galego'}=$credits::LOCALE{'galician'};
$credits::LOCALE{'¼òÌåºº×Ö'}=$credits::LOCALE{'gb'};
$credits::LOCALE{'ÖĞÎÄ¼òÌå'}=$credits::LOCALE{'gb2312'};
$credits::LOCALE{'deutsch'}=$credits::LOCALE{'german'};
$credits::LOCALE{'ellinika'}=$credits::LOCALE{'greek'};
$credits::LOCALE{'magyar'}=$credits::LOCALE{'hungarian'};
$credits::LOCALE{'islenska'}=$credits::LOCALE{'icelandic'};
$credits::LOCALE{'indonesian'}=$credits::LOCALE{'indonesia'};
$credits::LOCALE{'iso-2022-jp'}=$credits::LOCALE{'iso2022jp'};
$credits::LOCALE{'italiano'}=$credits::LOCALE{'italian'};
$credits::LOCALE{'korean'}=$credits::LOCALE{'korean'};
$credits::LOCALE{'lietuviğkai'}=$credits::LOCALE{'lithuanian'};
$credits::LOCALE{'macedonian'}=$credits::LOCALE{'macedonian'};
$credits::LOCALE{'malaysian'}=$credits::LOCALE{'malay'};
$credits::LOCALE{'norsk'}=$credits::LOCALE{'norwegian'};
$credits::LOCALE{'polski'}=$credits::LOCALE{'polish'};
$credits::LOCALE{'portuguese'}=$credits::LOCALE{'portuguese'};
$credits::LOCALE{'romãn'}=$credits::LOCALE{'romanian'};
$credits::LOCALE{'òÕÓÓËÉÊ'}=$credits::LOCALE{'russian'};
$credits::LOCALE{'Ğóññêèé1251'}=$credits::LOCALE{'russian1251'};
$credits::LOCALE{'serbian'}=$credits::LOCALE{'serbian'};
$credits::LOCALE{'slovak'}=$credits::LOCALE{'slovak'};
$credits::LOCALE{'slovenian'}=$credits::LOCALE{'slovenian'};
$credits::LOCALE{'espanol'}=$credits::LOCALE{'spanish'};
$credits::LOCALE{'svenska'}=$credits::LOCALE{'swedish'};
$credits::LOCALE{'turkce'}=$credits::LOCALE{'turkish'};
$credits::LOCALE{'õËÒÁ§ÎÓØËÁ'}=$credits::LOCALE{'ukrainian'};
$credits::LOCALE{'Óêğà¿íñüêà1251'}=$credits::LOCALE{'ukrainian1251'};

# English - default
sub english
{
  return shift;
};

# Chinese Big5 Code

sub big5
{
  my $string = shift;
  return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=big5',
     'Maximal 5 Minute Incoming Traffic'      => '5¤ÀÄÁ³Ì¤j¬y¤J¶q',
     'Maximal 5 Minute Outgoing Traffic'      => '5¤ÀÄÁ³Ì¤j¬y¥X¶q',
     'the device'                             => '¸Ë¸m',
     'The statistics were last updated(.*)'   => '¤W¦¸²Î­p§ó·s®É¶¡: $1',
     ' Average\)</B><BR>'                     => ' ¥­§¡)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>¥­§¡$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>³Ì¤j$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>¥Ø«e$1',
     'version'                                => 'ª©¥»',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>¨C¤é ¹Ïªí ($1 ¤ÀÄÁ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>¨C¶g ¹Ïªí (30 ¤ÀÄÁ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>¨C¤ë ¹Ïªí (2 ¤p®É',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>¨C¦~ ¹Ïªí (1 ¤Ñ',
     'Incoming Traffic in (\S+) per Second'   => '¨C¬í¬y¤J¶q (³æ¦ì $1)',
     'Outgoing Traffic in (\S+) per Second'   => '¨C¬í¬y¥X¶q (³æ¦ì $1)',
     'Incoming Traffic in (\S+) per Minute'   => '¨C¤ÀÄÁ¬y¤J¶q (³æ¦ì $1)',
     'Outgoing Traffic in (\S+) per Minute'   => '¨C¤ÀÄÁ¬y¥X¶q (³æ¦ì $1)',
     'Incoming Traffic in (\S+) per Hour'     => '¨C¤p®É¬y¤J¶q (³æ¦ì $1)',
     'Outgoing Traffic in (\S+) per Hour'     => '¨C¤p®É¬y¥X¶q (³æ¦ì $1)',
     'at which time (.*) had been up for(.*)' => '³]³Æ¦WºÙ $1¡A¤w¹B§@®É¶¡(UPTIME): $2',
     '(\S+) per minute'			              => '$1/¤À',
     '(\S+) per hour'			              => '$1/¤p®É',    
     '(.+)/s$'                                => '$1/¬í',
     # '(.+)/min$'                              => '$1/¤À',
     '(.+)/h$'                                => '$1/¤p®É',
     # 'Bits'                                   => 'Bits',
     # 'Bytes'                                  => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;¬y¤J:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;¬y¥X:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;¦Ê¤À¤ñ:</FONT>',
     'Ported to OpenVMS Alpha by'             => '²¾´Ó¨ì OpenVM Alpha §@ªÌ',
     'Ported to WindowsNT by'                 => '²¾´Ó¨ì WindowsNT §@ªÌ',
     'and'                                    => '¤Î',
     '^GREEN'                                 => 'ºñ¦â',
     'BLUE'                                   => 'ÂÅ¦â',
     'DARK GREEN'                             => '¾¥ºñ¦â',
     # 'MAGENTA'                                => 'µµ¦â',
     # 'AMBER'                                  => 'µ[¬Ä¦â'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday =
    (
      'Sunday'    => '¬P´Á¤é',        'Sun' => '¤é',
      'Monday'    => '¬P´Á¤@',        'Mon' => '¤@',
      'Tuesday'   => '¬P´Á¤G',        'Tue' => '¤G',
      'Wednesday' => '¬P´Á¤T',        'Wed' => '¤T',
      'Thursday'  => '¬P´Á¥|',        'Thu' => '¥|',
      'Friday'    => '¬P´Á¤­',        'Fri' => '¤­',
      'Saturday'  => '¬P´Á¤»',        'Sat' => '¤»'
    );

%month =
    (
      'January'   => '¤@¤ë',   'February'  => '¤G¤ë',    'March'     => '¤T¤ë',
      'Jan'       => '¤@',     'Feb'       => '¤G',      'Mar'       => '¤T',
      'April'     => '¥|¤ë',   'May'       => '¤­¤ë',    'June'      => '¤»¤ë',
      'Apr'       => '¥|',     'May'       => '¤­',      'Jun'       => '¤»',
      'July'      => '¤C¤ë',   'August'    => '¤K¤ë',    'September' => '¤E¤ë',
      'Jul'       => '¤C',     'Aug'       => '¤K',      'Sep'       => '¤E',
      'October'   => '¤Q¤ë',   'November'  => '¤Q¤@¤ë',  'December'  => '¤Q¤G¤ë',
      'Oct'       => '¤Q',     'Nov'       => '¤Q¤@',    'Dec'       => '¤Q¤G'
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      {
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0];
        $foo[4]=$quux[1];
      };
      return "$foo[3] ¦~ $month{$foo[2]} $foo[1] ¤é $wday{$foo[0]} $foo[4]";
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Brazilian (Portugues)

sub brazilian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Tr&aacute;fego M&aacute;ximo de Entrada em 5 minutos',
     'Maximal 5 Minute Outgoing Traffic'      => 'Tr&aacute;fego M&aacute;ximo de Sa&iacute;da em 5 minutos',
     'the device'                             => 'dispositivo',
     'The statistics were last updated (.*)'  => '&Uacute;ltima atualiza&ccedil;&atilde;o das estat&iacute;sticas: $1',
     ' Average\)</B><BR>'                     => ' - m&eacute;dia)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>M&eacute;dia$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>M&aacute;x$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Atual$1',
     'version'                                => 'vers&atilde;o',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Gr&aacute;fico `Di&aacute;rio\' ($1 minutos',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Gr&aacute;fico `Semanal\' (30 minutos' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Gr&aacute;fico `Mensal\' (2 horas',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Gr&aacute;fico `Anual\' (1 dia', 
     'Incoming Traffic in (\S+) per Second'   => 'Tr&aacute;fego de Entrada em $1 por segundo',
     'Outgoing Traffic in (\S+) per Second'   => 'Tr&aacute;fego de Sa&iacute;da em $1 por segundo',
     'at which time (.*) had been up for(.*)' => 'nesta hora $1 estava ativo por $2',
     # '([kMG]?)([bB])/s'                     => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                   => '\$1\$2/min',
     # '([kMG]?)([bB])/h'                     => '$1$2/t',
     # 'Bits'                                 => 'Bits',
     # 'Bytes'                                => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Entr.:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Sa&iacute;:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Porc.:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Adaptado para o Alpha OpenVMS por', 
     'Ported to WindowsNT by'                 => 'Adaptado para o WindowsNT por',
     'and'                                    => 'e',
     '^GREEN'                                  => 'VERDE',
     'BLUE'                                   => 'AZUL',
     'DARK GREEN'                             => 'VERDE ESCURO',
     'MAGENTA'                                => 'LIL&Aacute;S',
     'AMBER'                                  => 'AMBAR'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Domingo',       'Sun' => 'Dom',
      'Monday'    => 'Segunda',       'Mon' => 'Seg',
      'Tuesday'   => 'Ter&ccedil;a',  'Tue' => 'Ter',
      'Wednesday' => 'Quarta',        'Wed' => 'Qua',
      'Thursday'  => 'Quinta',        'Thu' => 'Qui',
      'Friday'    => 'Sexta',         'Fri' => 'Sex',
      'Saturday'  => 'S&aacute;bado', 'Sat' => 'S&aacute;b' 

    );

%month = 
    (
      'January'   => 'Janeiro',   'February'  => 'Fevereiro' ,  'March'     => 'Mar&ccedil;o',
      'Jan'       => 'Jan',       'Feb'       => 'Fev',         'Mar'       => 'Mar',
      'April'     => 'Abril',     'May'       => 'Maio',        'June'      => 'Junho', 
      'Apr'       => 'Abr',       'May'       => 'Mai',         'Jun'       => 'Jun',
      'July'      => 'Julho',     'August'    => 'Agosto',      'September' => 'Setembro', 
      'Jul'       => 'Jul',       'Aug'       => 'Ago',         'Sep'       => 'Set', 
      'October'   => 'Outubro',   'November'  => 'Novembro',    'December'  => 'Dezembro', 
      'Oct'       => 'Out',       'Nov'       => 'Nov',         'Dec'       => 'Dez' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." &agrave;s ".$quux[1]; 
      };
      return "$wday{$foo[0]}, $foo[1] de $month{$foo[2]} de $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};


# Bulgarian

sub bulgarian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=windows-1251',
     'Maximal 5 Minute Incoming Traffic'      => 'Ìàêñèìàëåí âõîäÿù òğàôèê çà 5 ìèíóòè',
     'Maximal 5 Minute Outgoing Traffic'      => 'Ìàêñèìàëåí èçõîäÿù òğàôèê çà 5 ìèíóòè',
     'the device'                             => 'óñòğîéñòâîòî',
     'The statistics were last updated(.*)'   => 'Ñòàòèñòè÷åñêèòå äàííè ñà îò÷åòåíè íà: $1',
     ' Average\)</B><BR>'                     => ' ñğåäíî)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Ñğåäíî$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Ìàêñ.$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Òåêóùî$1',
     'version'                                => 'âåğñèÿ',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Äíåâíà ãğàôèêà (ïğåç $1 ìèíóòè',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Ñåäìè÷íà ãğàôèêà (ïğåç 30 ìèíóòè' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Ìåñå÷íà ãğàôèêà (ïğåç 2 ÷àñà',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Ãîäèøíà ãğàôèêà (ïğåç 1 äåí', 
     'Incoming Traffic in (\S+) per Second'   => 'Âõîäÿù òğàôèê â $1 çà ñåêóíäà',
     'Outgoing Traffic in (\S+) per Second'   => 'Èçõîäÿù òğàôèê â $1 çà ñåêóíäà',
     'at which time (.*) had been up for(.*)' => 'â êîåòî âğåìå $1 ğàáîòè îò $2',
     #'([kMG]?)([bB])/s'                      => '$1$1/ñåê',
     #'([kMG]?)([bB])/min'                    => '$1$2/ìèí',
     '([kMG]?)([bB])/h'                       => '$1$2/÷',
     'Bits'                                  => 'áèòà',
     'Bytes'                                 => 'áàéòà',
     '&nbsp;In:</FONT>'                       => '&nbsp;Âõ.:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Èçõ.:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Ïğîöåíò:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Ïîğò çà OpenVMS Alpha îò',
     'Ported to WindowsNT by'                 => 'Ïîğò çà WindowsNT îò',
     'and'                                    => 'è',
     '^GREEN'                                  => 'çåëåí',
     'BLUE'                                   => 'ñèí',
     'DARK GREEN'                             => 'òúìíîçåëåí',
     'MAGENTA'                                => 'êåğåìèäåí',
     'AMBER'                                  => 'êåõëèáàğ'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => ' Íåäåëÿ',		'Sun' => 'Íä',
      'Monday'    => ' Ïîíåäåëíèê',	'Mon' => 'Ïí',
      'Tuesday'   => ' Âòîğíèê',	'Tue' => 'Âò',
      'Wednesday' => ' Ñğÿäà',		'Wed' => 'Ñğ',
      'Thursday'  => ' ×åòâúğòúê',	'Thu' => '×ò',
      'Friday'    => ' Ïåòúê',		'Fri' => 'Ïò',
      'Saturday'  => ' Ñúáîòà',		'Sat' => 'Ñá' 
    );

%month = 
    (
      'January'   => 'ßíóàğè',   'February'  => 'Ôåâğóàğè' ,    'March'     => 'Ìàğò',
      'Jan'       => 'ßíó',       'Feb'       => 'Ôåâ',         'Mar'       => 'Ìàğ',
      'April'     => 'Àïğèë',     'May'       => 'Ìàé',         'June'      => 'Şíè', 
      'Apr'       => 'Àïğ',       'May'       => 'Ìàé',         'Jun'       => 'Şíè',
      'July'      => 'Şëè',   'August'    => 'Àâãóñò',        'September' => 'Ñåïòåìâğè', 
      'Jul'       => 'Şëè',       'Aug'       => 'Àâã',         'Sep'       => 'Ñåï', 
      'October'   => 'Îêòîìâğè',   'November'  => 'Íîåìâğè',    'December'  => 'Äåêåìâğè', 
      'Oct'       => 'Îêò',       'Nov'       => 'Íîå',         'Dec'       => 'Äåê' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]."Ç. × ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# catalan

sub catalan
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Tr&agrave;fic entrant m&agrave;xim en 5 minuts',
     'Maximal 5 Minute Outgoing Traffic'      => 'Tr&agrave;fic sortint m&agrave;xim en 5 minuts',
     'the device'                             => 'el dispositiu',
     'The statistics were last updated(.*)'   => 'Estad&iacute;stiques actualitzades el $1',
     ' Average\)</B><BR>'                     => ' Promig)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Promig $1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>M&agrave;xim$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Actual$1',
     'version'                                => 'versi&oacute',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Gr&agrave;fic diari ($1 minuts :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Gr&agrave;fic setmanal (30 minuts :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Gr&agrave;fic mensual (2 hores :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Gr&agrave;fic anual (1 dia :', 
     'Incoming Traffic in (\S+) per Second'   => 'Tr&agrave;fic entrant en $1 per segon',
     'Outgoing Traffic in (\S+) per Second'   => 'Tr&agrave;fic sortint en $1 per segon',
     'at which time (.*) had been up for(.*)' => '$1 ha estat funcionant durant $2',
     # '([kMG]?)([bB])/s'                      => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                    => '\$1\$2/min',
     # '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                  => 'Bits',
     # 'Bytes'                                 => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Entrant:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Sortint:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Percentatge:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Portat a OpenVMS Alpha per',
     'Ported to WindowsNT by'                 => 'Portat a WindowsNT per',
     'and'                                    => 'i',
     '^GREEN'                                  => 'VERD',
     'BLUE'                                   => 'BLAU',
     'DARK GREEN'                             => 'VERD FOSC',
     'MAGENTA'                                => 'MAGENTA',
     'AMBER'                                  => 'AMBAR'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Diumenge',	'Sun' => 'Dg',
      'Monday'    => 'Dilluns',		'Mon' => 'Dl',
      'Tuesday'   => 'Dimarts',		'Tue' => 'Dm',
      'Wednesday' => 'Dimecres',	'Wed' => 'Dc',
      'Thursday'  => 'Dijous',		'Thu' => 'Dj',
      'Friday'    => 'Divendres',	'Fri' => 'Dv',
      'Saturday'  => 'Dissabte',	'Sat' => 'Ds' 
    );

%month = 
    (
      'January'   => 'Gener',     'February' => 'Febrer' ,    'March'     => 'Març',
      'Jan'       => 'Gen',       'Feb'      => 'Feb',        'Mar'       => 'Mar',
      'April'     => 'Abril',     'May'      => 'Maig',       'June'      => 'Juny', 
      'Apr'       => 'Abr',       'May'      => 'Mai',        'Jun'       => 'Jun',
      'July'      => 'Juliol',    'August'   => 'Agost',      'September' => 'Setembre', 
      'Jul'       => 'Jul',       'Aug'      => 'Ago',        'Sep'       => 'Set', 
      'October'   => 'Octubre',   'November' => 'Novembre',   'December'  => 'Desembre', 
      'Oct'       => 'Oct',       'Nov'      => 'Nov',        'Dec'       => 'Des' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." a les ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] de $month{$foo[2]} de $foo[3]"; 
    };
   return $string;

};

# Simplified Chinese

sub chinese
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=gb2312',
     'Maximal 5 Minute Incoming Traffic'      => '5·ÖÖÓ×î´óÁ÷ÈëÁ¿',
     'Maximal 5 Minute Outgoing Traffic'      => '5·ÖÖÓ×î´óÁ÷³öÁ¿',
     'the device'                             => 'Éè±¸',
     'The statistics were last updated(.*)'   => '×îºóÍ³¼Æ¸üĞÂÊ±¼ä£º$1',
     ' Average\)</B><BR>'                     => ' Æ½¾ù)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Æ½¾ù$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>×î´ó$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>µ±Ç°$1',
     'version'                                => '°æ±¾',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Ã¿ÈÕ Í¼±í ($1 ·ÖÖÓ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Ã¿ÖÜ Í¼±í (30 ·ÖÖÓ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Ã¿ÔÂ Í¼±í (2 Ğ¡Ê±',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Ã¿Äê Í¼±í (1 Ìì', 
     'Incoming Traffic in (\S+) per Second'   => 'Ã¿ÃëÁ÷ÈëÁ¿ (µ¥Î» $1 )',
     'Outgoing Traffic in (\S+) per Second'   => 'Ã¿ÃëÁ÷³öÁ¿ (µ¥Î» $1 )',
     'at which time (.*) had been up for(.*)' => ' $1 ÒÑÔËĞĞÁË£º $2 ',
     '(.+)/s$'                                => '$1/Ãë',
     '(.+)/min$'                              => '$1/·Ö',
     '(.+)/h$'                                => '$1/Ê±',
     # 'Bits'                                 => 'Bits',
     # 'Bytes'                                => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Á÷Èë£º</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Á÷³ö£º</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;°Ù·Ö±È£º</FONT>',
     'Ported to OpenVMS Alpha by'             => 'ÒÆÖ²µ½ OpenVMS µÄÊÇ', 
     'Ported to WindowsNT by'                 => 'ÒÆÖ²µ½ WindowsNT µÄÊÇ',
     'and'                                    => 'Óë',
     '^GREEN'                                 => 'ÂÌÉ«',
     'BLUE'                                   => 'À¶É«',
     'DARK GREEN'                             => 'Ä«ÂÌ',
     'MAGENTA'                                => '×ÏÉ«',
     'AMBER'                                  => 'çúçêÉ«'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'ĞÇÆÚÌì',    'Sun' => 'ÈÕ',
      'Monday'    => 'ĞÇÆÚÒ»',    'Mon' => 'Ò»',
      'Tuesday'   => 'ĞÇÆÚ¶ş',    'Tue' => '¶ş',
      'Wednesday' => 'ĞÇÆÚÈı',    'Wed' => 'Èı',
      'Thursday'  => 'ĞÇÆÚËÄ',    'Thu' => 'ËÄ',
      'Friday'    => 'ĞÇÆÚÎå',    'Fri' => 'Îå',
      'Saturday'  => 'ĞÇÆÚÁù',    'Sat' => 'Áù' 

    );

%month = 
    (
      'January'   => ' Ò» ÔÂ',    'February'  => ' ¶ş ÔÂ',      'March'     => ' Èı ÔÂ',
      'April'     => ' ËÄ ÔÂ',    'May'       => ' Îå ÔÂ',      'June'      => ' Áù ÔÂ', 
      'July'      => ' Æß ÔÂ',    'August'    => ' °Ë ÔÂ',      'September' => ' ¾Å ÔÂ', 
      'October'   => ' Ê® ÔÂ',    'November'  => 'Ê®Ò»ÔÂ',      'December'  => 'Ê®¶şÔÂ', 
      'Jan'       => '£±ÔÂ',      'Feb'       => '£²ÔÂ',        'Mar'       => '£³ÔÂ',
      'Apr'       => '£´ÔÂ',      'May'       => '£µÔÂ',        'Jun'       => '£¶ÔÂ',
      'Jul'       => '£·ÔÂ',      'Aug'       => '£¸ÔÂ',        'Sep'       => '£¹ÔÂ', 
      'Oct'       => '10ÔÂ',      'Nov'       => '11ÔÂ',        'Dec'       => '12ÔÂ' 

	);


  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	  if($foo[3]=~(/(.*)at(.*)/))
        { 
          @quux=split(/at/,$foo[3]);
	      $foo[3]=$quux[0];
          $foo[4]=$quux[1]; 
        };
      return "$foo[3]Äê $month{$foo[2]} $foo[1] ÈÕ £¬$wday{$foo[0]} £¬$foo[4]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};

sub croatian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);


  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp


  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-2',
     'Maximal 5 Minute Incoming Traffic'      => 'Maksimalni ulazni promet unutar 5 minuta',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maksimalni izlazni promet unutar 5 minuta',
     'the device'                             => 'ureğaj',
     'The statistics were last updated(.*)'   => 'Statistike su zadnji puta izmijenjene $1',
     ' Average\)</B><BR>'                     => ' prosjeèna vrijednost)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=left><SMALL>Prosjeèno$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=left><SMALL>Maksimalno$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=left><SMALL>Trenutno$1',
     'version'                                => 'verzija',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Dnevne statistike (svakih $1 minuta',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Tjedne statistike (svakih 30 minuta' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Mjeseène statistike (svakih 2 sata',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Godi¹nje statistike (svaki 1 dan', 
     'Incoming Traffic in (\S+) per Second'   => 'Ulazni promet - $1 po sekundi',
     'Outgoing Traffic in (\S+) per Second'   => 'Izlazni promet - $1 po sekundi',
     'at which time (.*) had been up for(.*)' => 'gdje $1 je bio aktivan $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/g',
     'Bits'                                => 'Bitova',
     'Bytes'                              => 'Bajtova',
     '&nbsp;In:</FONT>'                      => '&nbsp;Unutra:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Van:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Postotak:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Port na OpenVMS Alpha od', 
     'Ported to WindowsNT by'                 => 'Post od WindowsNT od',
     'and'                                    => 'i',
     '^GREEN'                                  => 'ZELENA',
     'BLUE'                                   => 'PLAVA',
     'DARK GREEN'                             => 'TAMNO ZELENA',
     'MAGENTA'                                => 'LJUBIÈASTA',
     'AMBER'                                  => 'AMBER'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Nedjelja',     'Sun' => 'Ned',
      'Monday'    => 'Ponedjeljak',  'Mon' => 'Pon',
      'Tuesday'   => 'Utorak',        'Tue' => 'Uto',
      'Wednesday' => 'Srijeda',         'Wed' => 'Sri',
      'Thursday'  => 'Èetvrtak',      'Thu' => 'Èet',
      'Friday'    => 'Petak',        'Fri' => 'Pet',
      'Saturday'  => 'Subota',        'Sat' => 'Sub' 

    );

%month = 
    (
      'January'   => 'Sijeèanj',     'February'  => 'Veljaèa',      'March'     => 'O¾ujak',
      'Jan'       => 'Sij',          'Feb'       => 'Vel',         'Mar'       => 'O¾u',
      'April'     => 'Travanj',     'May'       => 'Svibanj',        'June'      => 'Lipanj', 
      'Apr'       => 'Tra',          'May'       => 'Svi',         'Jun'       => 'Lip',
      'July'      => 'Srpanj',       'August'    => 'Kolovoz',    'September' => 'Rujan', 
      'Jul'       => 'Srp',          'Aug'       => 'Kol',         'Sep'       => 'Ruj', 
      'October'   => 'Listopad', 'November'  => 'Studeni',   'December'  => 'Prosinac', 
      'Oct'       => 'Lis',          'Nov'       => 'Stu',         'Dec'       => 'Pro' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." godine"." u".$quux[1]; 
      };
      return "$wday{$foo[0]} dana $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Czech

sub czech
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=windows-1250',
     'Maximal 5 Minute Incoming Traffic'      => 'Maximální 5 minutovı pøíchozí tok',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maximální 5 minutovı odchozí tok',
     'the device'                             => 'zaøízení',
     'The statistics were last updated(.*)'   => 'Poslední aktualizace statistiky:$1',
     ' Average\)</B><BR>'                     => ' prùmìr)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Prùm.$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max.$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Akt.$1',
     'version'                                => 'verze',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Denní graf ($1 minutovı',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Tıdenní graf (30 minutovı' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Mìsíèní graf (2 hodinovı',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Roèní graf (1 denní', 
     'Incoming Traffic in (\S+) per Second'   => 'Pøíchozí tok v $1 za sec.',
     'Outgoing Traffic in (\S+) per Second'   => 'Odchozí tok v $1 za sec.',
     'at which time (.*) had been up for(.*)' => 'od posledního restartu $1 ubìhlo: $2',
     #'([kMG]?)([bB])/s'                       => '\$1\$2/s',
     #'([kMG]?)([bB])/min'     	      	      => '\$1\$2/min',
     #'([kMG]?)([bB])/h'                       => '$1$2/h',
     'Bits'                                   => 'bitech',
     'Bytes'                                  => 'bajtech',
     #'&nbsp;In:</FONT>'                       => '&nbsp;In:</FONT>',
     #'&nbsp;Out:</FONT>'                      => '&nbsp;Out:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Proc.</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Na OpenVMS portoval', 
     'Ported to WindowsNT by'                 => 'Na WindowsNT portoval',
     'and'                                    => 'a',
     '^GREEN'                                  => 'Zelená',
     'BLUE'                                   => 'Modrá',
     'DARK GREEN'                             => 'Tmavì zelená',
     'MAGENTA'                                => 'Fialová',
     'AMBER'                                  => 'lutá'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Nedìle',		'Sun' => 'Ne',
      'Monday'    => 'Pondìli',		'Mon' => 'Po',
      'Tuesday'   => 'Úterı',		'Tue' => 'Út',
      'Wednesday' => 'Støeda',		'Wed' => 'St',
      'Thursday'  => 'Ètvrtek',		'Thu' => 'Èt',
      'Friday'    => 'Pátek',		'Fri' => 'Pá',
      'Saturday'  => 'Sobota',		'Sat' => 'So' 
    );

%month = 
    (
 'January' => 'Leden',   'February' => 'Únor',      'March'     => 'Bøezen',
 'Jan'     => 'Leden',   'Feb'      => 'Únor',      'Mar'       => 'Bøezen',
 'April'   => 'Duben',   'May'      => 'Kvìten',    'June'      => 'Èerven',
 'Apr'     => 'Duben',   'May'      => 'Kvìten',    'Jun'       => 'Èerven',
 'July'    => 'Èervenec','August'   => 'Srpen',     'September' => 'Záøí',
 'Jul'     => 'Èervenec','Aug'      => 'Srpen',     'Sep'       => 'Záøí', 
 'October' => 'Øíjen',   'November' => 'Listopad',  'December'  => 'Prosinec', 
 'Oct'     => 'Øíjen',   'Nov'      => 'Listopad',  'Dec'       => 'Prosinec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0].",".$quux[1]." hod."; 
      };
      return "$wday{$foo[0]} $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings

  return $string;

}
#
# Danish

sub danish
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Maksimal indg&aring;ende trafik i 5 minutter',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maksimal udg&aring;ende trafik i 5 minutter',
     'the device'                             => 'enheden',
     'The statistics were last updated(.*)'   => 'Statistikken blev sidst opdateret$1',
     ' Average\)</B><BR>'                     => ' Middel)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Middel$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Nu$1',
     'version'                                => 'version',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Daglig\' graf ($1 minuts',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Ugentlig\' graf (30 minuts' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`M&aring;nedlig\' graf (2 times',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`&Aring;rlig\' graf (1 dags', 
     'Incoming Traffic in (\S+) per Second'   => 'Indg&aring;ende trafik i $1 per sekund',
     'Outgoing Traffic in (\S+) per Second'   => 'Udg&aring;ende trafik i $1 per sekund',
     'at which time (.*) had been up for(.*)' => 'hvor $1 havde v&aelig;ret oppe i$2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes'
     '&nbsp;In:</FONT>'                      => '&nbsp;Ind:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Ud:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Procent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Port til OpenVMS af', 
     'Ported to WindowsNT by'                 => 'Port til WindowsNT af',
     'and'                                    => 'og',
     '^GREEN'                                  => 'GR&Oslash;N',
     'BLUE'                                   => 'BL&Aring;',
     'DARK GREEN'                             => 'M&Oslash;RKEGR&Oslash;N',
     'MAGENTA'                                => 'LYSLILLA',
     'AMBER'                                  => 'RAV'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'S&oslash;ndag',    'Sun' => 'S&oslash;n',
      'Monday'    => 'Mandag',           'Mon' => 'Man',
      'Tuesday'   => 'Tirsdag',          'Tue' => 'Tir',
      'Wednesday' => 'Onsdag',           'Wed' => 'Ons',
      'Thursday'  => 'Torsdag',          'Thu' => 'Tor',
      'Friday'    => 'Fredag',           'Fri' => 'Fre',
      'Saturday'  => 'L&oslash;rdag',    'Sat' => 'L&oslash;r' 

    );

%month = 
    (
      'January'   => 'Januar',    'February'  => 'Februar' ,    'March'     => 'Marts',
      'Jan'       => 'Jan',       'Feb'       => 'Feb',         'Mar'       => 'Mar',
      'April'     => 'April',     'May'       => 'Maj',         'June'      => 'Juni', 
      'Apr'       => 'Apr',       'May'       => 'Maj',         'Jun'       => 'Jun',
      'July'      => 'Juli',      'August'    => 'August',      'September' => 'September', 
      'Jul'       => 'Jul',       'Aug'       => 'Aug',         'Sep'       => 'Sep', 
      'October'   => 'Oktober',   'November'  => 'November',    'December'  => 'December', 
      'Oct'       => 'Okt',       'Nov'       => 'Nov',         'Dec'       => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
      return "$wday{$foo[0]} den $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };

# Dutch

sub dutch
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Maximaal inkomend verkeer per 5 minuten',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maximaal uitgaand verkeer per 5 minuten',
     'the device'                             => 'het apparaat',
     'The statistics were last updated(.*)'   => 'Statistieken voor het laatst bijgewerkt op$1',
     ' Average\)</B><BR>'                     => ' gemiddeld)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Gemiddeld$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Actueel$1',
     'version'                                => 'versie',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Dagelijkse\' grafiek ($1 minuten',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Wekelijkse\' grafiek (30 minuten' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`Maandelijkse\' grafiek (2 uur',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`Jaarlijkse\' grafiek (1 dag', 
     'Incoming Traffic in (\S+) per Second'   => 'Inkomend verkeer in $1 per seconde',
     'Outgoing Traffic in (\S+) per Second'   => 'Uitgaand verkeer in $1 per seconde',
     'at which time (.*) had been up for(.*)' => 'op het moment dat $1 reeds actief was voor$2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/u',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes'
     # '&nbsp;In:</FONT>'                      => '&nbsp;In:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Uit:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Procent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Ported naar OpenVMS door', 
     'Ported to WindowsNT by'                 => 'Ported naar WindowsNT door',
     'and'                                    => 'en',
     'DARK GREEN'                             => 'DONKER GROEN',
     '^GREEN'                                  => 'GROEN',
     'BLUE'                                   => 'BLAUW',
     'MAGENTA'                                => 'LILA',
     'AMBER'                                  => 'AMBER'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'zondag',           'Sun' => 'zon',
      'Monday'    => 'maandag',          'Mon' => 'maa',
      'Tuesday'   => 'dinsdag',          'Tue' => 'din',
      'Wednesday' => 'woensdag',         'Wed' => 'woe',
      'Thursday'  => 'donderdag',        'Thu' => 'don',
      'Friday'    => 'vrijdag',          'Fri' => 'vri',
      'Saturday'  => 'zaterdag',         'Sat' => 'zat' 

    );

%month = 
    (
      'January'   => 'januari',   'February'  => 'februari',    'March'     => 'maart',
      'Jan'       => 'jan',       'Feb'       => 'feb',         'Mar'       => 'mrt',
      'April'     => 'april',     'May'       => 'mei',         'June'      => 'juni', 
      'Apr'       => 'apr',       'May'       => 'mei',         'Jun'       => 'jun',
      'July'      => 'juli',      'August'    => 'augustus',    'September' => 'september', 
      'Jul'       => 'jul',       'Aug'       => 'aug',         'Sep'       => 'sep', 
      'October'   => 'oktober',   'November'  => 'november',    'December'  => 'december', 
      'Oct'       => 'okt',       'Nov'       => 'nov',         'Dec'       => 'dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
        if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." om".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Estonian

sub estonian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => '5 minuti maksimaalne sisenev liiklus',
     'Maximal 5 Minute Outgoing Traffic'      => '5 minuti maksimaalne v&auml;ljuv liiklus',
     'the device'                             => 'seade',
     'The statistics were last updated(.*)'   => 'Statistikat uuendati viimati$1',
     ' Average\)</B><BR>'                     => ' keskmine)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Keskmine$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Hetkel$1',
     'version'                                => 'versioon',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`P&auml;evane\' graafik ($1 minuti',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`N&auml;dala\' graafik (30 minuti' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`Kuu \' graafik (2 tunni',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`Aasta\' graafik (1 p&auml;eva', 
     'Incoming Traffic in (\S+) per Second'   => 'Sisenev liiklus $1 sekundi kohta',
     'Outgoing Traffic in (\S+) per Second'   => 'V&auml;ljuv liiklus $1 sekundi kohta',
     'at which time (.*) had been up for(.*)' => 'kui $1 on katkematult t&ouml;&ouml;tanud$2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
      'Bits'                                => 'bitti',
      'Bytes'                              => 'baiti',
     '&nbsp;In:</FONT>'                      => '&nbsp;sisse:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;v&auml;lja:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;protsent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'portis OpenVMS-le:', 
     'Ported to WindowsNT by'                 => 'portis WindowsNT-le:',
     'and'                                    => 'ja',
     '^GREEN'                                  => 'ROHELINE',
     'BLUE'                                   => 'SININE',
     'DARK GREEN'                             => 'TUMEROHELINE',
     'MAGENTA'                                => 'LILLA',
     'AMBER'                                  => 'HELEROHELINE'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'p&uuml;hap&auml;ev',    'Sun' => 'P',
      'Monday'    => 'esmasp&auml;ev',           'Mon' => 'E',
      'Tuesday'   => 'teisip&auml;ev',          'Tue' => 'T',
      'Wednesday' => 'kolmap&auml;ev',           'Wed' => 'K',
      'Thursday'  => 'neljap&auml;ev',          'Thu' => 'N',
      'Friday'    => 'reede',           'Fri' => 'R',
      'Saturday'  => 'laup&auml;ev',    'Sat' => 'L' 

    );

%month = 
    (
      'January'   => 'jaanuar',    'February'  => 'veebruar' ,    'March'     => 'm&auml;rts',
      'Jan'       => 'jaan',       'Feb'       => 'veebr',         'Mar'       => 'm&auml;rts',
      'April'     => 'aprill',     'May'       => 'mai',         'June'      => 'juuni', 
      'Apr'       => 'aprill',       'May'       => 'mai',         'Jun'       => 'juuni',
      'July'      => 'juuli',      'August'    => 'august',      'September' => 'september', 
      'Jul'       => 'juuli',       'Aug'       => 'aug',         'Sep'       => 'sept', 
      'October'   => 'oktoober',   'November'  => 'november',    'December'  => 'detsember', 
      'Oct'       => 'okt',       'Nov'       => 'nov',         'Dec'       => 'dets' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
      return "$wday{$foo[0]}, $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };

# eucjp

sub eucjp
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=euc-jp',
     'Maximal 5 Minute Incoming Traffic'      => 'ºÇÂç¤Î5Ê¬´Ö¤Î¼õ¿®ÎÌ',
     'Maximal 5 Minute Outgoing Traffic'      => 'ºÇÂç¤Î5Ê¬´Ö¤ÎÁ÷¿®ÎÌ',
     'the device'                             => '¥Ç¥Ğ¥¤¥¹',
     'The statistics were last updated(.*)'   => '¹¹¿·Æü»ş$1',
     ' Average\)</B><BR>'                     => '¤ÎÊ¿¶Ñ)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Ê¿¶ÑÃÍ$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>ºÇÂçÃÍ$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>¸½ºßÃÍ$1',
     'version'                                => 'version',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Æü´Ö¥°¥é¥Õ($1Ê¬´Ö',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>½µ´Ö¥°¥é¥Õ(30Ê¬´Ö',
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>·î´Ö¥°¥é¥Õ(2»ş´Ö',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Ç¯´Ö¥°¥é¥Õ(1Æü',
     'Incoming Traffic in (\S+) per Second'   => '¼õ¿®ÎÌ($1/ÉÃ)',
     'Incoming Traffic in (\S+) per Minute'   => '¼õ¿®ÎÌ($1/Ê¬)',
     'Incoming Traffic in (\S+) per Hour'     => '¼õ¿®ÎÌ($1/»ş)',
     'Outgoing Traffic in (\S+) per Second'   => 'Á÷¿®ÎÌ($1/ÉÃ)',
     'Outgoing Traffic in (\S+) per Minute'   => 'Á÷¿®ÎÌ($1/Ê¬)',
     'Outgoing Traffic in (\S+) per Hour'     => 'Á÷¿®ÎÌ($1/»ş)',
     'at which time (.*) had been up for(.*)' => '$1 ¤Î²ÔÆ¯»ş´Ö$2',
     'Average max 5 min values for `Daily\' Graph \((.*) Minute interval\):&nbsp;&nbsp;' => 'Æü´Ö¥°¥é¥Õ¤Ç¤ÎºÇÂç¤Î5Ê¬´Ö($1Ê¬Ëè)¤ÎÊ¿¶Ñ:&nbsp;&nbsp;',
     'Average max 5 min values for `Weekly\' Graph \(30 Minute interval\):&nbsp;&nbsp;' => '½µ´Ö¥°¥é¥Õ¤Ç¤ÎºÇÂç¤Î5Ê¬´Ö(30Ê¬Ëè)¤ÎÊ¿¶Ñ:&nbsp;&nbsp;',
     'Average max 5 min values for `Monthly\' Graph \(2 Hour interval\):&nbsp;&nbsp;' => '·î´Ö¥°¥é¥Õ¤Ç¤ÎºÇÂç¤Î5Ê¬´Ö(2»ş´ÖËè)¤ÎÊ¿¶Ñ:&nbsp;&nbsp;',
     'Average max 5 min values for `Yearly\' Graph \(1 Day interval\):&nbsp;&nbsp;' => 'Ç¯´Ö¥°¥é¥Õ¤Ç¤ÎºÇÂç¤Î5Ê¬´Ö(1ÆüËè)¤ÎÊ¿¶Ñ:&nbsp;&nbsp;',
     '([kMG]?)([bB])/s'                       => '$1$2/ÉÃ',
     '([kMG]?)([bB])/min'                     => '$1$2/Ê¬',
     '([kMG]?)([bB])/h'                       => '$1$2/»ş',
     'Bits'                                   => '¥Ó¥Ã¥È',
     'Bytes'                                  => '¥Ğ¥¤¥È',
     '&nbsp;In:</FONT>'                       => '&nbsp;¼õ¿®:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Á÷¿®:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;ÈæÎ¨:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'OpenVMS Alpha¤Ø¤Î°Ü¿¢',
     'Ported to WindowsNT by'                 => 'WindowsNT¤Ø¤Î°Ü¿¢',
     'and'                                    => 'and',
     '^GREEN'                                 => 'ÎĞ',
     'BLUE'                                   => 'ÀÄ',
     'DARK GREEN'                             => '¿¼ÎĞ',
     'MAGENTA'                                => '¥Ş¥¼¥ó¥¿',
     'AMBER'                                  => 'àèàá'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => '(Æü)', #'Sun' => 'Sun',
      'Monday'    => '(·î)', #'Mon' => 'Mon',
      'Tuesday'   => '(²Ğ)', #'Tue' => 'Tue',
      'Wednesday' => '(¿å)', #'Wed' => 'Wed',
      'Thursday'  => '(ÌÚ)', #'Thu' => 'Thu',
      'Friday'    => '(¶â)', #'Fri' => 'Fri',
      'Saturday'  => '(ÅÚ)', #'Sat' => 'Sat'
    );

%month = 
    (
      'January'   => '1·î',    'February' => '2·î',
      'March'     => '3·î',    'April'    => '4·î',
      'May'       => '5·î',    'June'     => '6·î',
      'July'      => '7·î',    'August'   => '8·î',
      'September' => '9·î',    'October'  => '10·î',
      'November'  => '11·î',   'December' => '12·î',
#     'Jan'   => 'Jan',    'Feb'     => 'Feb',     'Mar'    => 'Mar',
#     'Apr'   => 'Apr',    'May'     => 'May',     'Jun'    => 'Jun',
#     'Jul'   => 'Jul',    'Aug'     => 'Aug',     'Sep'    => 'Sep', 
#     'Oct'   => 'Oct',    'Nov'     => 'Nov',     'Dec'    => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+) (.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/ at /,$foo[3]);
      }
	else
      { 
        @quux=split(/ /,$foo[3], 2);
      };
      return "$quux[0]Ç¯$month{$foo[2]}$foo[1]Æü$wday{$foo[0]} $quux[1]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };
# Finnish

sub finnish
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Tulevan liikenteen maksimi 5 minuutin aikana',
     'Maximal 5 Minute Outgoing Traffic'      => 'L&auml;htev&auml;n liikenteen maksimi 5 minuutin aikana',
     'the device'                             => 'laite',
     'The statistics were last updated(.*)'   => 'Tiedot p&auml;ivitetty viimeksi $1',
     ' Average\)</B><BR>'                     => '',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Keskim&auml;&auml;rin$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maksimi$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>T&auml;ll&auml; hetkell&auml;$1',
     'version'                                => 'versio',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>P&auml;iv&auml;raportti (skaala $1 minuutti(a))</B><BR>',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Viikkoraportti (skaala 30 minuuttia)</B><BR>' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Kuukausiraportti (skaala 2 tuntia)</B><BR>',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Vuosiraportti (skaala 1 vuorokausi)</B><BR>', 
     'Incoming Traffic in (\S+) per Second'   => 'Tuleva liikenne $1 sekunnissa',
     'Outgoing Traffic in (\S+) per Second'   => 'L&auml;htev&auml; liikenne $1 sekunnissa',
     'Incoming Traffic in (\S+) per Minute'   => 'Tuleva liikenne $1 minuutissa',
     'Outgoing Traffic in (\S+) per Minute'   => 'L&auml;htev&auml; liikenne $1 minuutissa',
     'Incoming Traffic in (\S+) per Hour'     => 'Tuleva liikenne $1 tunnissa',
     'Outgoing Traffic in (\S+) per Hour'     => 'L&auml;htev&auml; liikenne $1 tunnissa',
     'at which time (.*) had been up for(.*)' => 'jolloin $1 on toiminut yht&auml;jaksoisesti $2',
     '(\S+) per minute'			      => '$1 minuutissa',
     '(\S+) per hour'			      => '$1 tunnissa',    
     '(.+)/s$'                                => '$1/s',
     # '(.+)/min'                             => '$1/min',
     #'(.+)/h$'                               => '$1/h',
     #'([kMG]?)([bB])/s'                      => '$1$2/s',
     #'([kMG]?)([bB])/min'                    => '$1$2/min',
     #'([kMG]?)([bB])/h'                      => '$1$2/h',
     'Bits'                                   => 'bitti&auml;',
     'Bytes'                                  => 'tavua',
     '&nbsp;In:</FONT>'                       => '&nbsp;Tuleva:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;L&auml;htev&auml;:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Prosenttia:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'OpenVMS -j&auml;rjestelm&auml;lle sovittanut', 
     'Ported to WindowsNT by'                 => 'WindowsNT -j&auml;rjestelm&auml;lle sovittanut',
     'and'                                    => 'ja',
     '^GREEN'                                 => 'VIHRE&Auml;',
     'BLUE'                                   => 'SININEN',
     'DARK GREEN'                             => 'TUMMANVIHRE&Auml;',
     'MAGENTA'                                => 'PINKKI',
     'AMBER'                                  => 'PUNAINEN',
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Sunnuntai',   'Sun' => 'Su',
      'Monday'    => 'Maanantai',   'Mon' => 'Ma',
      'Tuesday'   => 'Tiistai',     'Tue' => 'Ti',
      'Wednesday' => 'Keskiviikko', 'Wed' => 'Ke',
      'Thursday'  => 'Torstai',     'Thu' => 'To',
      'Friday'    => 'Perjantai',   'Fri' => 'Pe',
      'Saturday'  => 'Lauantai',    'Sat' => 'La' 
    );

%month = 
    (
      'January'   => 'Tammi',      'February'  => 'Helmi' , 'March'     => 'Maalis',
      'Jan'       => 'Tam',        'Feb'       => 'Hel',    'Mar'       => 'Maa',
      'April'     => 'Huhti',      'May'       => 'Touko',  'June'      => 'Kes&auml;', 
      'Apr'       => 'Huh',        'May'       => 'Tou',    'Jun'       => 'Kes',
      'July'      => 'Hein&auml;', 'August'    => 'Elo',    'September' => 'Syys', 
      'Jul'       => 'Hei',        'Aug'       => 'Elo',    'Sep'       => 'Syy', 
      'October'   => 'Loka',       'November'  => 'Marras', 'December'  => 'Joulu', 
      'Oct'       => 'Lok',        'Nov'       => 'Mar',    'Dec'       => 'Kou' 
    );

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if( $wday{$foo[0]} && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kello ".$quux[1]; 
      };
      return "$wday{$foo[0]}, $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};



# French

sub french
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Trafic maximal en entr&eacute;e sur 5 minutes',
     'Maximal 5 Minute Outgoing Traffic'      => 'Trafic maximal en sortie sur 5 minutes',
     'the device'                             => 'le mat&eacute;riel',
     'The statistics were last updated(.*)'   => 'Les statistiques ont &eacute;t&eacute; mises &agrave; jour le $1',
     ' Average\)</B><BR>'                     => ' Moyenne)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Moyenne$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Actuel$1',
     'version'                                => 'version',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Graphique quotidien (sur $1 minutes :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Graphique hebdomadaire (sur 30 minutes :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Graphique mensuel  (sur 2 heures :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Graphique annuel (sur 1 jour :', 
     'Incoming Traffic in (\S+) per Second'   => 'Trafic d\'entr&eacute;e en $1 par seconde',
     'Outgoing Traffic in (\S+) per Second'   => 'Trafic de sortie en $1 par seconde',
     'at which time (.*) had been up for(.*)' => '$1 &eacute;tait alors en marche depuis $2',
     # '([kMG]?)([bB])/s'                      => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                    => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                  => 'Bits',
     # 'Bytes'                                 => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Entr&eacute;e:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Sortie:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Pourcentage:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Port&eacute; sur OpenVMS Alpha par',
     'Ported to WindowsNT by'                 => 'Port&eacute; sur WindowsNT par',
     'and'                                    => 'et',
     '^GREEN'                                  => 'VERT',
     'BLUE'                                   => 'BLEU',
     'DARK GREEN'                             => 'VERT SOMBRE',
     'MAGENTA'                                => 'MAGENTA',
     'AMBER'                                  => 'AMBRE'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Dimanche',	'Sun' => 'Dim',
      'Monday'    => 'Lundi',		'Mon' => 'Lun',
      'Tuesday'   => 'Mardi',		'Tue' => 'Mar',
      'Wednesday' => 'Mercredi',	'Wed' => 'Mer',
      'Thursday'  => 'Jeudi',		'Thu' => 'Jeu',
      'Friday'    => 'Vendredi',	'Fri' => 'Ven',
      'Saturday'  => 'Samedi',		'Sat' => 'Sam' 
    );

%month = 
    (
      'January'   => 'Janvier',   'February'  => 'F&eacute;vrier' ,    'March'     => 'Mars',
      'Jan'       => 'Jan',       'Feb'       => 'Fev',         'Mar'       => 'Mar',
      'April'     => 'Avril',     'May'       => 'Mai',         'June'      => 'Juin', 
      'Apr'       => 'Avr',       'May'       => 'Mai',         'Jun'       => 'Jun',
      'July'      => 'Juillet',   'August'    => 'Ao&ucirc;t',        'September' => 'Septembre', 
      'Jul'       => 'Jul',       'Aug'       => 'Aou',         'Sep'       => 'Sep', 
      'October'   => 'Octobre',   'November'  => 'Novembre',    'December'  => 'D&eacute;cembre', 
      'Oct'       => 'Oct',       'Nov'       => 'Nov',         'Dec'       => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." &agrave; ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." &agrave; $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};


# Galician

sub galician
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Tr&&aacute;fico entrante m&aacute;ximo en 5 minutos',
     'Maximal 5 Minute Outgoing Traffic'      => 'Tr&&aacute;fico sa&iacute;nte m&aacute;ximo en 5 minutos',
     'the device'                             => 'o dispositivo',
     'The statistics were last updated(.*)'   => 'Estas estat&iacute;sticas actualiz&aacute;ronse o $1',
     ' Average\)</B><BR>'                     => ' de Media)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Media$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>M&aacute;x$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Actual$1',
     'version'                                => 'versi&oacute;n',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Gr&aacute;fica diaria ($1 minutos',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Gr&aacute;fica semanal (30 minutos' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Gr&aacute;fica mensual (2 horas',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Gr&aacute;fica anual (1 d&iacute;a', 
     'Incoming Traffic in (\S+) per Second'   => 'Tr&aacute;fico entrante en $1 por segundo',
     'Outgoing Traffic in (\S+) per Second'   => 'Tr&aacute;fico sa&iacute;nte en $1 por segundo',
     'at which time (.*) had been up for(.*)' => 'nese intre $1 levaba prendida $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/h',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes'
     '&nbsp;In:</FONT>'                      => '&nbsp;Entrante:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Sa&iacute;nte:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Tanto por ciento:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Portado a OpenVMS Alpha por', 
     'Ported to WindowsNT by'                 => 'Portado a Windows NT por',
     'and'                                    => 'e',
     '^GREEN'                                  => 'VERDE',
     'BLUE'                                   => 'AZUL',
     'DARK GREEN'                             => 'VERDE OSCURO',
     'MAGENTA'                                => 'ROSA',
     'AMBER'                                  => 'AMBAR'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Domingo',         'Sun' => 'Dom',
      'Monday'    => 'Luns',            'Mon' => 'Lun',
      'Tuesday'   => 'Martes',          'Tue' => 'Mar',
      'Wednesday' => 'M&eacute;rcores', 'Wed' => 'm&eacute;r',
      'Thursday'  => 'Xoves',           'Thu' => 'Xov',
      'Friday'    => 'Venres',          'Fri' => 'Ven',
      'Saturday'  => 'S&aacute;bado',   'Sat' => 'S&aacute;b' 

    );

%month = 
    (
      'January'   => 'Xaneiro',   'February'  => 'Febreiro' ,   'March'     => 'Marzo',
      'Jan'       => 'Xan',       'Feb'       => 'Feb',         'Mar'       => 'Mar',
      'April'     => 'Abril',     'May'       => 'Maio',        'June'      => 'Xu&ntilde;o', 
      'Apr'       => 'Abr',       'May'       => 'Mai',         'Jun'       => 'Xu&ntilde;',
      'July'      => 'Xullo',     'August'    => 'Agosto',      'September' => 'Setembro', 
      'Jul'       => 'Xul',       'Aug'       => 'Ago',         'Sep'       => 'Set', 
      'October'   => 'Outubro',   'November'  => 'Novembro',    'December'  => 'Decembro', 
      'Oct'       => 'Out',       'Nov'       => 'Nov',         'Dec'       => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." &aacute;s ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] de $month{$foo[2]} de $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };
# Chinese gb Code

sub gb
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=gb',
     'Maximal 5 Minute Incoming Traffic'      => '5·ÖÖÓ×î´óµÄÁ÷Á¿',
     'Maximal 5 Minute Outgoing Traffic'      => '5·ÖÖÓ×î´óµÄÁ÷³öÁ÷Á¿',
     'the device'                             => 'µ±Ç°Éè±¸',
     'The statistics were last updated(.*)'   => 'Í³¼ÆĞÅÏ¢¸üĞÂÓÚ: $1',
     ' Average\)</B><BR>'                     => 'Æ½¾ù)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Æ½¾ù$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>×î´ó$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>µ±Ç°$1',
     'version'                                => '°æ±¾',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>ÈÕ·ÖÎöÍ¼($1·ÖÖÓ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>ÖÜ·ÖÎöÍ¼(30·ÖÖÓ'  ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>ÔÂ·ÖÎöÍ¼(2Ğ¡Ê±',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Äê·ÖÎöÍ¼(1Ìì',
     'Incoming Traffic in (\S+) per Second'   => 'Ã¿ÃëµÄÁ÷ÈëÁ÷Á¿(µ¥Î»$1)',
     'Outgoing Traffic in (\S+) per Second'   => 'Ã¿ÃëµÄÁ÷³öÁ÷Á¿(µ¥Î»$1)',
     'at which time (.*) had been up for(.*)' => 'ÆäÊ± $1ÒÑ¾­¸üĞÂ(UPTIME): $2',
     '([kMG]?)([bB])/s'                       => '$1$2/s',
     '([kMG]?)([bB])/min'                     => '$1$2/m',
     '([kMG]?)([bB])/h'                       => '$1$2/h',
    # 'Bits'                                   => 'Bits',
    # 'Bytes'                                  => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Á÷Èë:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Á÷³ö:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;°Ù·Ö±È:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'OpenVMSµÄ¶Ë¿Ú',
     'Ported to WindowsNT by'                 => 'WindowsNTµÄ¶Ë¿Ú',
     'and'                                    => 'Óë',
     '^GREEN'                                 => 'ÂÌÉ«',
     'BLUE'                                   => 'À¼É«',
     'DARK GREEN'                             => '°µÂÌ',
     'MAGENTA'                                => 'ºÖÉ«',
     'AMBER'                                  => '×ÏÉ«'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday =
    (
      'Sunday'    => 'ÖÜÈÕ',        'Sun' => 'ÖÜÈÕ',
      'Monday'    => 'ÖÜÒ»',        'Mon' => 'ÖÜÒ»¤@',
      'Tuesday'   => 'ÖÜ¶ş',        'Tue' => 'ÖÜ¶ş¤G',
      'Wednesday' => 'ÖÜÈı',        'Wed' => 'ÖÜÈı¤T',
      'Thursday'  => 'ÖÜËÄ',        'Thu' => 'ÖÜËÄ¥|',
      'Friday'    => 'ÖÜÎå',        'Fri' => 'ÖÜÎå',
      'Saturday'  => 'ÖÜÁù',        'Sat' => 'ÖÜÁù'

    );

%month =
    (
      'January'   => '1ÔÂ',   'February'  => '2ÔÂ',    'March'     => '3ÔÂ',
      'Jan'       => '1ÔÂ',     'Feb'       => '2ÔÂ',      'Mar'       => '3ÔÂ',
      'April'     => '4ÔÂ',   'May'       => '5ÔÂ',    'June'      => '6ÔÂ',
      'Apr'       => '4ÔÂ',     'May'       => '5ÔÂ',      'Jun'       => '6ÔÂ',
      'July'      => '7ÔÂ',   'August'    => '8ÔÂ',    'September' => '9ÔÂ',
      'Jul'       => '7ÔÂ',     'Aug'       => '8ÔÂ',      'Sep'       => '9ÔÂ',
      'October'   => '10ÔÂ',   'November'  => '11ÔÂ',  'December'  => '12ÔÂ',
      'Oct'       => '10ÔÂ',     'Nov'       => '11ÔÂ',    'Dec'       => '12ÔÂ'

    );


  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
        @quux=split(/at/,$foo[3]);
	if($foo[3]=~(/(.*)at(.*)/))
      { 
         $foo[3]=$quux[0];
         $foo[4]=$quux[1];
      };
       return "$foo[3]Äê $month{$foo[2]} $foo[1]ÈÕ, $wday{$foo[0]}, $foo[4]";
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Chinese gb2312 Code

sub gb2312
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=charset=gb2312',
     'Maximal 5 Minute Incoming Traffic'      => '5·ÖÖÓ×î´óÁ÷ÈëÁ¿',
     'Maximal 5 Minute Outgoing Traffic'      => '5·ÖÖÓ×î´óÁ÷³öÁ¿',
     'the device'                             => '×°ÖÃ',
     'The statistics were last updated(.*)'   => 'ÉÏ´ÎÍ³¼Æ¸üĞÂÊ±¼ä: $1',
     ' Average\)</B><BR>'                     => ' Æ½¾ù)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Æ½¾ù$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>×î´ó$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Ä¿Ç°$1',
     'version'                                => '°æ±¾',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Ã¿ÈÕ Í¼±í ($1 ·ÖÖÓ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Ã¿ÖÜ Í¼±í (30 ·ÖÖÓ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Ã¿ÔÂ Í¼±í (2 Ğ¡Ê±',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Ã¿Äê Í¼±í (1 Ìì',
     'Incoming Traffic in (\S+) per Second'   => 'Ã¿ÃëÁ÷ÈëÁ¿ (µ¥Î» $1)',
     'Outgoing Traffic in (\S+) per Second'   => 'Ã¿ÃëÁ÷³öÁ¿ (µ¥Î» $1)',
     'at which time (.*) had been up for(.*)' => 'Éè±¸Ãû³Æ $1£¬ÒÑÔË×÷Ê±¼ä(UPTIME): $2',
     '([kMG]?)([bB])/s'                       => '\$1\$2/Ãë',
     '([kMG]?)([bB])/min'                     => '\$1\$2/·Ö',
     '([kMG]?)([bB])/h'                       => '$1$2/Ê±',
    # 'Bits'                                   => 'Bits',
    # 'Bytes'                                  => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Á÷Èë:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Á÷³ö:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;°Ù·Ö±È:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'ÒÆÖ²µ½ OpenVM Alpha ×÷Õß',
     'Ported to WindowsNT by'                 => 'ÒÆÖ²µ½ WindowsNT ×÷Õß',
     'and'                                    => '¼°',
     '^GREEN'                                 => 'ÂÌÉ«',
     'BLUE'                                   => 'À¶É«',
     'DARK GREEN'                             => 'Ä«ÂÌÉ«',
     'MAGENTA'                                => '×ÏÉ«',
     'AMBER'                                  => 'çúçêÉ«'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday =
    (
      'Sunday'    => 'ĞÇÆÚÌì',        'Sun' => 'ÈÕ',
      'Monday'    => 'ĞÇÆÚÒ»',        'Mon' => 'Ò»',
      'Tuesday'   => 'ĞÇÆÚ¶ş',        'Tue' => '¶ş',
      'Wednesday' => 'ĞÇÆÚÈı',        'Wed' => 'Èı',
      'Thursday'  => 'ĞÇÆÚËÄ',        'Thu' => 'ËÄ',
      'Friday'    => 'ĞÇÆÚÎå',        'Fri' => 'Îå',
      'Saturday'  => 'ĞÇÆÚÁù',        'Sat' => 'Áù'

    );

%month =
    (
      'January'   => 'Ò»ÔÂ',   'February'  => '¶şÔÂ',    'March'     => 'ÈıÔÂ',
      'Jan'       => 'Ò»',     'Feb'       => '¶ş',      'Mar'       => 'Èı',
      'April'     => 'ËÄÔÂ',   'May'       => 'ÎåÔÂ',    'June'      => 'ÁùÔÂ',
      'Apr'       => 'ËÄ',     'May'       => 'Îå',      'Jun'       => 'Áù',
      'July'      => 'ÆßÔÂ',   'August'    => '°ËÔÂ',    'September' => '¾ÅÔÂ',
      'Jul'       => 'Æß',     'Aug'       => '°Ë',      'Sep'       => '¾Å',
      'October'   => 'Ê®ÔÂ',   'November'  => 'Ê®Ò»ÔÂ',  'December'  => 'Ê®¶şÔÂ',
      'Oct'       => 'Ê®',     'Nov'       => 'Ê®Ò»',    'Dec'       => 'Ê®¶ş'

    );


  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
        @quux=split(/at/,$foo[3]);
	if($foo[3]=~(/(.*)at(.*)/))
      { 
         $foo[3]=$quux[0];
         $foo[4]=$quux[1];
      };
       return "$foo[3] $month{$foo[2]} $foo[1] ÈÕ, $wday{$foo[0]}, $foo[4]";
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# German

sub german
{
  my $string = shift;
  return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Maximaler hereinkommender Traffic in 5 Minuten',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maximaler hinausgehender Traffic in 5 Minuten',
     'the device'                             => 'das Gerät',
     'The statistics were last updated(.*)'   => 'Die Statistiken wurden am $1 zuletzt aktualisiert',
     ' Average\)</B><BR>'                     => '',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Mittel$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maximal$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Aktuell$1',
     'version'                                => 'Version',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Tages&uuml;bersicht (Skalierung $1 Minute(n))</B><BR>',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Wochen&uuml;bersicht (Skalierung 30 Minuten)</B><BR>' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Monats&uuml;bersicht (Skalierung 2 Stunden)</B><BR>',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Jahres&uuml;bersicht (Skalierung 1 Tag)</B><BR>', 
     'Incoming Traffic in (\S+) per Second'   => 'Hereinkommender Traffic in $1 pro Sekunde',
     'Outgoing Traffic in (\S+) per Second'   => 'Hinausgehender Traffic in $1 pro Sekunde',
     'Incoming Traffic in (\S+) per Minute'   => 'Hereinkommender Traffic in $1 pro Minute',
     'Outgoing Traffic in (\S+) per Minute'   => 'Hinausgehender Traffic in $1 pro Minute',
     'Incoming Traffic in (\S+) per Hour'     => 'Hereinkommender Traffic in $1 pro Stunde',
     'Outgoing Traffic in (\S+) per Hour'     => 'Hinausgehender Traffic in $1 pro Stunde',
     'at which time (.*) had been up for(.*)' => 'zu diesem Zeitpunkt lief $1 seit $2',
     '(\S+) per minute'			      => '$1 pro Minute',
     '(\S+) per hour'			      => '$1 pro Stunde',    
     '(.+)/s$'                                 => '$1/s',
     # '(.+)/min'                     => '$1/min',
     '(.+)/h$'                       => '$1/std',
     #'([kMG]?)([bB])/s'                       => '$1$2/s',
     #'([kMG]?)([bB])/min'                     => '$1$2/min',
     #'([kMG]?)([bB])/h'                       => '$1$2/std',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                               => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Herein:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Hinaus:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Prozent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Portierung nach OpenVMS von', 
     'Ported to WindowsNT by'                 => 'Portierung nach WindowsNT von',
     'and'                                    => 'und',
     '^GREEN'                                 => 'GR&Uuml;N',
     'BLUE'                                   => 'BLAU',
     'DARK GREEN'                             => 'DUNKELGR&Uuml;N',
     # 'MAGENTA'                                => 'ROSA',
     # 'AMBER'                               => 'AMBER',
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Sonntag',     'Sun' => 'So',
      'Monday'    => 'Montag',      'Mon' => 'Mo',
      'Tuesday'   => 'Dienstag',    'Tue' => 'Di',
      'Wednesday' => 'Mittwoch',    'Wed' => 'Mi',
      'Thursday'  => 'Donnerstag',  'Thu' => 'Do',
      'Friday'    => 'Freitag',     'Fri' => 'Fr',
      'Saturday'  => 'Samstag',     'Sat' => 'Sa' 
    );

%month = 
    (
      'January'   => 'Januar',    'February'  => 'Februar' ,    'March'     => 'M&auml;rz',
      'Jan'       => 'Jan',       'Feb'       => 'Feb',         'Mar'       => 'M&auml;r',
      'April'     => 'April',     'May'       => 'Mai',         'June'      => 'Juni', 
      'Apr'       => 'Apr',       'May'       => 'Mai',         'Jun'       => 'Jun',
      'July'      => 'Juli',      'August'    => 'August',      'September' => 'September', 
      'Jul'       => 'Jul',       'Aug'       => 'Aug',         'Sep'       => 'Sep', 
      'October'   => 'Oktober',   'November'  => 'November',    'December'  => 'Dezember', 
      'Oct'       => 'Okt',       'Nov'       => 'Nov',         'Dec'       => 'Dez' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." um ".$quux[1]; 
      };
      return "$wday{$foo[0]}, den $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};



# Greek 

sub greek
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-7',
     'Maximal 5 Minute Incoming Traffic'      => 'Ìİãéóôï Åéóåñ÷üìåíï Öïñôßï óôá 5 ËåğôÜ',
     'Maximal 5 Minute Outgoing Traffic'      => 'Ìİãéóôï Åîåñ÷üìåíï Öïñôßï óôá 5 ËåğôÜ',
     'the device'                             => 'ç óõóêåõŞ',
     'The statistics were last updated(.*)'   => 'Ôá óôáôéóôéêÜ åíçìåñşèçêáí ôåëåõôáßá öïñÜ ôç(í)/ôï $1',
     ' Average\)</B><BR>'                     => ' Ìİóïò ¼ñïò)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Ìİóïò ¼ñïò$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Ìİãéóôï$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Ôñİ÷ïí$1',
     'version'                                => 'İêäïóç',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>ÇìåñŞóéï ÃñÜöçìá (êÜèå $1 ëåğôÜ :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Åâäïìáäéáßï ÃñÜöçìá (êÜèå 30 ëåğôÜ :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Ìçíéáßï ÃñÜöçìá  (êÜèå 2 şñåò :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>ÅôŞóéï ÃñÜöçìá (êÜèå 1 ìİñá :', 
     'Incoming Traffic in (\S+) per Second'   => 'Åéóåñ÷üìåíï Öïñôßï óå $1 áíÜ äåõôåñüëåğôï',
     'Outgoing Traffic in (\S+) per Second'   => 'Åîåñ÷üìåíï Öïñôßï óå $1 áíÜ äåõôåñüëåğôï',
     'at which time (.*) had been up for(.*)' => 'óôïí ïğïßï ÷ñüíï $1 Şôáí åíåñãŞ ãéá $2',
     # '([kMG]?)([bB])/s'                      => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                    => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                  => 'Bits',
     # 'Bytes'                                 => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Åéóåñ÷üìåíá:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Åîåñ÷üìåíá:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Ğïóïóôü:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Ìåôáöåñìİíï óå OpenVMS Alpha áğü',
     'Ported to WindowsNT by'                 => 'Ìåôáöåñìİíï óå WindowsNT áğü',
     'and'                                    => 'êáé',
     '^GREEN'                                  => 'ĞÑÁÓÉÍÏ',
     'BLUE'                                   => 'ÌĞËÅ',
     'DARK GREEN'                             => 'ÓÊÏÕÑÏ ĞÑÁÓÉÍÏ',
     'MAGENTA'                                => 'ÌÙÂ',
     'AMBER'                                  => 'ĞÏÑÔÏÊÁËÉ'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'ÊõñéáêŞ',		'Sun' => 'Êõñ',
      'Monday'    => 'Äåõôİñá',		'Mon' => 'Äåõ',
      'Tuesday'   => 'Ôñßôç',		'Tue' => 'Ôñé',
      'Wednesday' => 'ÔåôÜñôç',		'Wed' => 'Ôåô',
      'Thursday'  => 'Ğİìğôç',		'Thu' => 'Ğåì',
      'Friday'    => 'ĞáñáóêåõŞ',	'Fri' => 'Ğáñ',
      'Saturday'  => 'ÓÜââáôï',		'Sat' => 'Óáâ' 
    );

%month = 
    (
      'January'   => 'Éáíïõñßïõ',   'February'  => 'Öåâñïõáñßïõ' ,  'March'     => 'Ìáñôßïõ',
      'Jan'       => 'Éáí',          'Feb'       => 'Öåâ',           'Mar'       => 'Ìáñ',
      'April'     => 'Áğñéëßïõ',     'May'       => 'ÌáÀïõ',         'June'      => 'Éïõíßïõ', 
      'Apr'       => 'Áğñ',          'May'       => 'Ìáé',           'Jun'       => 'Éïõ',
      'July'      => 'Éïõëßïõ',      'August'    => 'Áõãïıóôïõ',     'September' => 'Óåğôåìâñßïõ', 
      'Jul'       => 'Éïõ',          'Aug'       => 'Áõã',           'Sep'       => 'Óåğ', 
      'October'   => 'Ïêôùâñßïõ',    'November'  => 'Íïåìâñßïõ',     'December'  => 'Äåêåìâñßïõ', 
      'Oct'       => 'Ïêô',          'Nov'       => 'Íïå',           'Dec'       => 'Äåê' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." óôéò ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." &agrave; $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Hungarian


sub hungarian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-2',
     'Maximal 5 Minute Incoming Traffic'      => 'Maxim&aacute;lis bej&ouml;v&otilde; forgalom 5 perc alatt',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maxim&aacute;lis kimen&otilde; forgalom 5 perc alatt',
     'the device'                             => 'az eszk&ouml;z',
     'The statistics were last updated(.*)'   => 'A statisztika utols&oacute; friss&iacute;t&eacute;se:$1',
     ' Average\)</B><BR>'                     => ' &aacute;tlag)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>&Aacute;tlagos$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maximum$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Pillanatnyi$1',
     'version'                                => 'verzi&oacute;',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Napi\' grafikon ($1 perces',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Heti\' grafikon (30 perces' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`Havi\' grafikon (2 &oacute;r&aacute;s',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`&Eacute;ves\' grafikon (1 napos', 
     'Incoming Traffic in (\S+) per Second'   => 'Bej&ouml;v&otilde; forgalom $1 per m&aacute;sodpercben',
     'Outgoing Traffic in (\S+) per Second'   => 'Kimen&otilde; forgalom $1 per m&aacute;sodpercben',
     'at which time (.*) had been up for(.*)' => 'amikor a $1 &uuml;zemideje $2 volt.',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
     'Bits'                                => 'Bit',
     'Bytes'                              => 'Byte',
     '&nbsp;In:</FONT>'                      => '&nbsp;be:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;ki:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;sz&aacute;zale&acute;k:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'OpenVMS-re portolta', 
     'Ported to WindowsNT by'                 => 'WindowsNT-re portolta',
     'and'                                    => '&eacute;s',
     '^GREEN'                                  => 'Z&Ouml;LD',
     'BLUE'                                   => 'K&Eacute;K',
     'DARK GREEN'                             => 'S&Ouml;T&Eacute;T Z&Ouml;LD',
     'MAGENTA'                                => 'B&Iacute;BOR',
     'AMBER'                                  => 'S&Aacute;RGA'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'vas&aacute;rnap',		'Sun' => 'vas',
      'Monday'    => 'h&eacute;tf&otilde;',	'Mon' => 'h&eacute;t',
      'Tuesday'   => 'kedd',			'Tue' => 'kedd',
      'Wednesday' => 'szerda',			'Wed' => 'sze',
      'Thursday'  => 'cs&uuml;t&ouml;rt&ouml;k','Thu' => 'cs&uuml;t',
      'Friday'    => 'p&eacute;ntek',           'Fri' => 'p&eacute;n',
      'Saturday'  => 'szombat',    		'Sat' => 'szo' 

    );

%month = 
    (
      'January'   => 'janu&aacute;r',    'February'  => 'febru&aacute;r' ,    'March'     => 'm&aacute;rcius',
      'Jan'       => 'jan',       'Feb'       => 'feb',         'Mar'       => 'marc',
      'April'     => '&aacute;prilis',     'May'       => 'm&aacute;jus',         'June'      => 'j&uacute;nius', 
      'Apr'       => 'apr',       'May'       => 'maj',         'Jun'       => 'jun',
      'July'      => 'j&uacute;lius',      'August'    => 'augusztus',      'September' => 'szeptember', 
      'Jul'       => 'jul',       'Aug'       => 'aug',         'Sep'       => 'szept', 
      'October'   => 'okt&oacute;ber',   'November'  => 'november',    'December'  => 'december', 
      'Oct'       => 'okt',       'Nov'       => 'nov',         'Dec'       => 'dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
	return "$quux[0]. $month{$foo[2]} $foo[1]., $wday{$foo[0]} $quux[1]";
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };
# Icelandic 

sub icelandic
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'H&aacute;marks 5 m&iacute;n&uacute;tna umfer&eth; inn',
     'Maximal 5 Minute Outgoing Traffic'      => 'H&aacute;marks 5 m&iacute;n&uacute;tna umfer&eth; &uacute;t',
     'the device'                             => 'tæki&eth;',
     'The statistics were last updated(.*)'   => 'G&ouml;gnin voru s&iacute;&eth;ast uppf&aelig;r&eth;$1',
     ' Average\)</B><BR>'                     => ' Me&eth;altal)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Me&eth;altal$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>H&aacute;mark',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>N&uacute;$1',
     'version'                                => '&uacute;tg&aacute;fa',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Dagleg\' sta&eth;a ($1 m&iacute;n&uacute;tur',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Vikuleg\' sta&eth;a (30 m&iacute;n&uacute;tur',
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`M&aacute;na&eth;arleg\' sta&eth;a (2 klst.',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`&Aarleg\' sta&eth;a (1 dags', 
     'Incoming Traffic in (\S+) per Second'   => 'Umfer&eth; inn &iacute; $1 &aacute; sek&uacute;ndu',
     'Outgoing Traffic in (\S+) per Second'   => 'Umfer&eth; &uacute;t &iacute; $1 &aacute; sek&uacute;ndu',
     'at which time (.*) had been up for(.*)' => '&thorn;egar $1 haf&eth;i veri&eth; uppi &iacute;$2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/sek',
     # '([kMG]?)([bB])/min'              => '\$1\$2/m&iacute;n',
     '([kMG]?)([bB])/h'                       => '$1$2/klst',
     # 'Bits'                                => 'Bitar',
     # 'Bytes'                              => 'B&aelig;ti'
     '&nbsp;In:</FONT>'                      => '&nbsp;Inn:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;&Uacute;t:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Pr&oacute;sent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Sta&eth;f&aelig;rt &aacute; OpenVMS af', 
     'Ported to WindowsNT by'                 => 'Sta&eth;f&aelig;rt &aacute; WindowsNT af',
     'and'                                    => 'og',
     '^GREEN'                                  => 'GR&AElig;Nt',
     'BLUE'                                   => 'BL&Aacute;TT',
     'DARK GREEN'                             => 'D&Ouml;KK GR&AElig;NN',
     'MAGENTA'                                => 'BL&Aacute;RAU&ETH;UR',
     'AMBER'                                  => 'GULBR&Uacute;NN'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Sunnudagur',            'Sun' => 'Sun',
      'Monday'    => 'M&aacute;nudagur',      'Mon' => 'M&aacute;n',
      'Tuesday'   => '&THORN;ri&eth;judagur', 'Tue' => '&THORN;ri',
      'Wednesday' => 'Mi&eth;vikudagur',      'Wed' => 'Mi&eth;',
      'Thursday'  => 'Fimmtudagur',           'Thu' => 'Fim',
      'Friday'    => 'F&ouml;studagur',       'Fri' => 'F&ouml;s',
      'Saturday'  => 'Laugardagur',           'Sat' => 'Lau' 

    );

%month = 
    (
      'January'   => 'Jan&uacute;ar',    'February'  => 'Febr&uacute;ar' ,    'March'     => 'Mars',
      'Jan'       => 'Jan',       'Feb'       => 'Feb',         'Mar'       => 'Mar',
      'April'     => 'Apr&iacute;l',     'May'       => 'Ma&iacute;',         'June'      => 'J&uacute;n&iacute;', 
      'Apr'       => 'Apr',       'May'       => 'Ma&iacute;',         'Jun'       => 'J&uacute;n',
      'July'      => 'J&uacute;l&iacute;',      'August'    => '&Aacute;g&uacute;st',      'September' => 'September', 
      'Jul'       => 'J&uacute;l',       'Aug'       => '&Aacute;g&uacute;',         'Sep'       => 'Sep', 
      'October'   => 'Okt&oacute;ber',   'November'  => 'N&oacute;vember',    'December'  => 'Desember', 
      'Oct'       => 'Okt',       'Nov'       => 'N&oacute;v',         'Dec'       => 'Des' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
      return "$wday{$foo[0]} den $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Malaysian/Indonesian/Malay

sub indonesia
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Trafik Masuk Maksimum dalam 5 Menit',
     'Maximal 5 Minute Outgoing Traffic'      => 'Trafik Keluar Maksimum dalam 5 Menit',
     'the device'                             => 'device',
     'The statistics were last updated(.*)'   => 'Statistik ini terakhir kali diupdate pada $1',
     ' Average\)</B><BR>'                     => ')</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Rata-rata $1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maksimum $1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Sekarang $1',
     'version'                                => 'versi',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Grafik Harian (Rata-rata per $1 menit',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Grafik Mingguan (Rata-rata per 30 menit',
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Grafik Bulanan (Rata-rata per 2 jam',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Grafik Tahunan (Rata-rata per hari',
     'Incoming Traffic in (\S+) per Second'   => 'Trafik Masuk $1 per detik',
     'Outgoing Traffic in (\S+) per Second'   => 'Trafik Keluar $1 per detik',
     'at which time (.*) had been up for(.*)' => 'Pada saat $1 telah aktif selama $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/j',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Masuk</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Keluar</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Persentase:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Porting ke  OpenVMS Alpha oleh',
     'Ported to WindowsNT by'                 => 'Porting ke WindowsNT oleh',
     'and'                                    => 'dan',
     '^GREEN'                                 => 'HIJAU',
     'BLUE'                                   => 'BIRU',
     'DARK GREEN'                             => 'HIJAU GELAP',
     'MAGENTA'                                => 'MAGENTA',
     'AMBER'                                  => 'AMBAR'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday =
    (
      'Sunday'    => 'Ahad',    'Sun' => 'Aha',
      'Monday'    => 'Senin',   'Mon' => 'Sen',
      'Tuesday'   => 'Selasa',  'Tue' => 'Sel',
      'Wednesday' => 'Rabu',    'Wed' => 'Rab',
      'Thursday'  => 'Kamis',   'Thu' => 'Kam',
      'Friday'    => 'Jumat',   'Fri' => 'Jum',
      'Saturday'  => 'Sabtu',   'Sat' => 'Sab'
    );

%month = 
    (
      'January'   => 'Januari',   'February'  => 'Februari' ,   'March'     => 'Maret',
      'Jan'       => 'Jan',       'Feb'       => 'Feb',         'Mar'       => 'Mar',
      'April'     => 'April',     'May'       => 'Mei',         'June'      => 'Juni', 
      'Apr'       => 'Apr',       'May'       => 'Mei',         'Jun'       => 'Jun',
      'July'      => 'Juli',      'August'    => 'Agustus',     'September' => 'September', 
      'Jul'       => 'Jul',       'Aug'       => 'Ags',         'Sep'       => 'Sep', 
      'October'   => 'Oktober',   'November'  => 'November',    'December'  => 'Desember', 
      'Oct'       => 'Okt',       'Nov'       => 'Nov',         'Dec'       => 'Des' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." pada ".$quux[1]; 
      };
	return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]";
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# iso2022jp

sub iso2022jp
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-2022-jp',
     'Maximal 5 Minute Incoming Traffic'      => "\e\\\$B:GBg\\\$N\e(B5\e\\\$BJ,4V\\\$N<u?.NL\e(B",
     'Maximal 5 Minute Outgoing Traffic'      => "\e\\\$B:GBg\\\$N\e(B5\e\\\$BJ,4V\\\$NAw?.NL\e(B",
     'the device'                             => "\e\\\$B%G%P%\\\$%9\e(B",
     'The statistics were last updated(.*)'   => "\e\\\$B99?7F|;~\e(B\$1",
     ' Average\)</B><BR>'                     => "\e\\\$B\\\$NJ?6Q\e(B)</B><BR>",
     '<TD ALIGN=right><SMALL>Average(.*)'     => "<TD ALIGN=right><SMALL>\e\\\$BJ?6QCM\e(B\$1",
     '<TD ALIGN=right><SMALL>Max(.*)'         => "<TD ALIGN=right><SMALL>\e\\\$B:GBgCM\e(B\$1",
     '<TD ALIGN=right><SMALL>Current(.*)'     => "<TD ALIGN=right><SMALL>\e\\\$B8=:_CM\e(B\$1",
     'version'                                => 'version',
     '<B>`Daily\' Graph \((.*) Minute'        => "<B>\e\\\$BF|4V%0%i%U\e(B(\$1\e\\\$BJ,4V\e(B",
     '<B>`Weekly\' Graph \(30 Minute'         => "<B>\e\\\$B=54V%0%i%U\e(B(30\e\\\$BJ,4V\e(B",
     '<B>`Monthly\' Graph \(2 Hour'           => "<B>\e\\\$B7n4V%0%i%U\e(B(2\e\\\$B;~4V\e(B",
     '<B>`Yearly\' Graph \(1 Day'             => "<B>\e\\\$BG/4V%0%i%U\e(B(1\e\\\$BF|\e(B",
     'Incoming Traffic in (\S+) per Second'   => "\e\\\$B<u?.NL\e(B(\$1/\e\\\$BIC\e(B)",
     'Incoming Traffic in (\S+) per Minute'   => "\e\\\$B<u?.NL\e(B(\$1/\e\\\$BJ,\e(B)",
     'Incoming Traffic in (\S+) per Hour'     => "\e\\\$B<u?.NL\e(B(\$1/\e\\\$B;~\e(B)",
     'Outgoing Traffic in (\S+) per Second'   => "\e\\\$BAw?.NL\e(B(\$1/\e\\\$BIC\e(B)",
     'Outgoing Traffic in (\S+) per Minute'   => "\e\\\$BAw?.NL\e(B(\$1/\e\\\$BJ,\e(B)",
     'Outgoing Traffic in (\S+) per Hour'     => "\e\\\$BAw?.NL\e(B(\$1/\e\\\$B;~\e(B)",
     'at which time (.*) had been up for(.*)' => "\$1 \e\\\$B\\\$N2TF/;~4V\e(B\$2",
     'Average max 5 min values for `Daily\' Graph \((.*) Minute interval\):&nbsp;&nbsp;' => "\e\\\$BF|4V%0%i%U\\\$G\\\$N:GBg\\\$N\e(B5\e\\\$BJ,4V\e(B(\$1\e\\\$BJ,Kh\e(B)\e\\\$B\\\$NJ?6Q\e(B:&nbsp;&nbsp;",
     'Average max 5 min values for `Weekly\' Graph \(30 Minute interval\):&nbsp;&nbsp;' => "\e\\\$B=54V%0%i%U\\\$G\\\$N:GBg\\\$N\e(B5\e\\\$BJ,4V\e(B(30\e\\\$BJ,Kh\e(B)\e\\\$B\\\$NJ?6Q\e(B:&nbsp;&nbsp;",
     'Average max 5 min values for `Monthly\' Graph \(2 Hour interval\):&nbsp;&nbsp;' => "\e\\\$B7n4V%0%i%U\\\$G\\\$N:GBg\\\$N\e(B5\e\\\$BJ,4V\e(B(2\e\\\$B;~4VKh\e(B)\e\\\$B\\\$NJ?6Q\e(B:&nbsp;&nbsp;",
     'Average max 5 min values for `Yearly\' Graph \(1 Day interval\):&nbsp;&nbsp;' => "\e\\\$BG/4V%0%i%U\\\$G\\\$N:GBg\\\$N\e(B5\e\\\$BJ,4V\e(B(1\e\\\$BF|Kh\e(B)\e\\\$B\\\$NJ?6Q\e(B:&nbsp;&nbsp;",
     '([kMG]?)([bB])/s'                       => "\$1\$2/\e\\\$BIC\e(B",
     '([kMG]?)([bB])/min'                     => "\$1\$2/\e\\\$BJ,\e(B",
     '([kMG]?)([bB])/h'                       => "\$1\$2/\e\\\$B;~\e(B",
     'Bits'                                   => "\e\\\$B%S%C%H\e(B",
     'Bytes'                                  => "\e\\\$B%P%\\\$%H\e(B",
     '&nbsp;In:</FONT>'                       => "&nbsp;\e\\\$B<u?.\e(B:</FONT>",
     '&nbsp;Out:</FONT>'                      => "&nbsp;\e\\\$BAw?.\e(B:</FONT>",
     '&nbsp;Percentage</FONT>'                => "&nbsp;\e\\\$BHfN(\e(B:</FONT>",
     'Ported to OpenVMS Alpha by'             => "OpenVMS Alpha\e\\\$B\\\$X\\\$N0\\\\?\"\e(B",
     'Ported to WindowsNT by'                 => "WindowsNT\e\\\$B\\\$X\\\$N0\\\\?\"\e(B",
     'and'                                    => 'and',
     '^GREEN'                                 => "\e\\\$BNP\e(B",
     'BLUE'                                   => "\e\\\$B\\\@D\e(B",
     'DARK GREEN'                             => "\e\\\$B?<NP\e(B",
     'MAGENTA'                                => "\e\\\$B%^%<%s%?\e(B",
     'AMBER'                                  => "\e\\\$B`h`a\e(B"
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => "(\e\$BF|\e(B)", #'Sun' => 'Sun',
      'Monday'    => "(\e\$B7n\e(B)", #'Mon' => 'Mon',
      'Tuesday'   => "(\e\$B2P\e(B)", #'Tue' => 'Tue',
      'Wednesday' => "(\e\$B?e\e(B)", #'Wed' => 'Wed',
      'Thursday'  => "(\e\$BLZ\e(B)", #'Thu' => 'Thu',
      'Friday'    => "(\e\$B6b\e(B)", #'Fri' => 'Fri',
      'Saturday'  => "(\e\$BEZ\e(B)", #'Sat' => 'Sat'
    );

%month = 
    (
      'January'   => "1\e\$B7n\e(B",    'February' => "2\e\$B7n\e(B",
      'March'     => "3\e\$B7n\e(B",    'April'    => "4\e\$B7n\e(B",
      'May'       => "5\e\$B7n\e(B",    'June'     => "6\e\$B7n\e(B",
      'July'      => "7\e\$B7n\e(B",    'August'   => "8\e\$B7n\e(B",
      'September' => "9\e\$B7n\e(B",    'October'  => "10\e\$B7n\e(B",
      'November'  => "11\e\$B7n\e(B",   'December' => "12\e\$B7n\e(B",
#     'Jan'   => 'Jan',    'Feb'     => 'Feb',     'Mar'    => 'Mar',
#     'Apr'   => 'Apr',    'May'     => 'May',     'Jun'    => 'Jun',
#     'Jul'   => 'Jul',    'Aug'     => 'Aug',     'Sep'    => 'Sep', 
#     'Oct'   => 'Oct',    'Nov'     => 'Nov',     'Dec'    => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+) (.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/ at /,$foo[3]);
      }
	else
      { 
        @quux=split(/ /,$foo[3], 2);
      };
      return "$quux[0]\e\$BG/\e(B$month{$foo[2]}$foo[1]\e\$BF|\e(B$wday{$foo[0]} $quux[1]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };
# Italian

sub italian
{
  my $string = shift;
  return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                    => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Traffico massimo in entrata su 5 minuti',
     'Maximal 5 Minute Outgoing Traffic'      => 'Traffico massimo in uscita su 5 minuti',
     'the device'                             => 'Il dispositivo',
     'The statistics were last updated(.*)'   => 'Le statistiche l\' ultima volta sono state aggiornate $1',
     ' Average\)</B><BR>'                     => ' Media)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Media$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Attuale$1',
     'version'                                => 'versione',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Grafico giornaliero (su $1 minuti :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Grafico settimanale (su 30 minuti :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Grafico mensile  (su 2 ore :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Grafico annuale (su 1 giorno :', 
     'Incoming Traffic in (\S+) per Second'   => 'Traffico in ingresso in $1 per Secondo',
     'Outgoing Traffic in (\S+) per Second'   => 'Traffico in uscita in $1 per Secondo',
     'Incoming Traffic in (\S+) per Minute'   => 'Traffico in ingresso in $1 per Minuto',
     'Outgoing Traffic in (\S+) per Minute'   => 'Traffico in uscita $1 per Minuto',
     'Incoming Traffic in (\S+) per Hour'     => 'Traffico in ingresso $1 per Ora',
     'Outgoing Traffic in (\S+) per Hour'     => 'Traffico in uscita $1 per Ora',   
     'at which time (.*) had been up for(.*)' => '$1 &eacute attivo da $2',
     '(\S+) per minute'                       => '$1 per Minuto',
     '(\S+) per hour'                         => '$1 per Ora',
     '(.+)/s$'                                => '$1/s',  
     # '(.+)/min'                             => '$1/min',
     '(.+)/h$'                                => '$1/ora',                  
     # '([kMG]?)([bB])/s'                     => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                   => '\$1\$2/min',
     # '([kMG]?)([bB])/h'                     => '$1$2/t',
     # 'Bits'                                 => 'Bits',
     # 'Bytes'                                => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Ingresso:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Uscita:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Percentuale:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Ported su OpenVMS Alpha da',
     'Ported to WindowsNT by'                 => 'Ported su WindowsNT da',
     'and'                                    => 'e',
     '^GREEN'                                 => 'VERDE',
     'BLUE'                                   => 'BLU',
     'DARK GREEN'                             => 'VERDE SCURO',
     #'MAGENTA'                                => 'MAGENTA',
     #'AMBER'                                  => 'AMBRA'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Domenica',	'Sun' => 'Dom',
      'Monday'    => 'Lunedi',		'Mon' => 'Lun',
      'Tuesday'   => 'Martedi',		'Tue' => 'Mar',
      'Wednesday' => 'Mercoledi',	'Wed' => 'Mer',
      'Thursday'  => 'Giovedi',		'Thu' => 'Gio',
      'Friday'    => 'Venerdi',		'Fri' => 'Ven',
      'Saturday'  => 'Sabato',		'Sat' => 'Sab' 
    );

%month = 
    (
      'January'   => 'Gennaio',   'February'  => 'Febbraio' ,   'March'     => 'Marzo',
      'Jan'       => 'Gen',       'Feb'       => 'Feb',         'Mar'       => 'Mar',
      'April'     => 'Aprile',    'May'       => 'Maggio',      'June'      => 'Giugno', 
      'Apr'       => 'Apr',       'May'       => 'Mag',         'Jun'       => 'Giu',
      'July'      => 'Luglio',    'August'    => 'Agosto',      'September' => 'Settembre', 
      'Jul'       => 'Lug',       'Aug'       => 'Ago',         'Sep'       => 'Set', 
      'October'   => 'Ottobre',   'November'  => 'Novembre',    'December'  => 'Dicembre', 
      'Oct'       => 'Ott',       'Nov'       => 'Nov',         'Dec'       => 'Dic' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." alle ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." &agrave; $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
   return $string;

};


# Korean

sub korean
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=\"euc-kr\"',
     'Maximal 5 Minute Incoming Traffic'      => '5ºĞ°£ ÃÖ´ë ¼ö½Å',
     'Maximal 5 Minute Outgoing Traffic'      => '5ºĞ°£ ÃÖ´ë ¼Û½Å',
     'the device'                             => 'ÀåÄ¡',
     'The statistics were last updated(.*)'   => 'ÃÖÁ¾ °»½Å ÀÏ½Ã: $1',
     ' Average\)</B><BR>'                     => ' Æò±Õ°ª ±âÁØ)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Æò±Õ$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>ÃÖ´ë$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>ÇöÀç$1',
     'version'                                => '¹öÀü',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>ÀÏ°£ ±×·¡ÇÁ ($1 ºĞ ´ÜÀ§',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>ÁÖ°£ ±×·¡ÇÁ (30 ºĞ ´ÜÀ§' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>¿ù°£ ±×·¡ÇÁ (2 ½Ã°£ ´ÜÀ§',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>¿¬°£ ±×·¡ÇÁ (1 ÀÏ ´ÜÀ§', 
     'Incoming Traffic in (\S+) per Second'   => 'ÃÊ´ç ¼ö½ÅµÈ Æ®·¡ÇÈ ($1)',
     'Outgoing Traffic in (\S+) per Second'   => 'ÃÊ´ç ¼Û½ÅµÈ Æ®·¡ÇÈ ($1)',
     'at which time (.*) had been up for(.*)' => '$1ÀÇ °¡µ¿ ½Ã°£: $2',
     '([kMG]?)([bB])/s'                       => '$1$2/ÃÊ',
     '([kMG]?)([bB])/min'                     => '$1$2/ºĞ',
     '([kMG]?)([bB])/h'                       => '$1$2/½Ã',
     'Bits'                                   => 'ºñÆ®',
     'Bytes'                                  => '¹ÙÀÌÆ®',
     '&nbsp;In:</FONT>'                       => '&nbsp;¼ö½Å:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;¼Û½Å:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;ÆÛ¼¾Æ®:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'OpenVMS Alpha Æ÷ÆÃ', 
     'Ported to WindowsNT by'                 => 'WindowsNT Æ÷ÆÃ',
     'and'                                    => '¿Í',
     '^GREEN'                                 => '³ì»ö',
     'BLUE'                                   => 'Ã»»ö',
     'DARK GREEN'                             => 'ÁøÇÑ³ì»ö',
     'MAGENTA'                                => 'ºĞÈ«»ö',
     'AMBER'                                  => 'ÁÖÈ²»ö'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'ÀÏ¿äÀÏ',    'Sun' => 'ÀÏ',
      'Monday'    => '¿ù¿äÀÏ',    'Mon' => '¿ù',
      'Tuesday'   => 'È­¿äÀÏ',    'Tue' => 'È­',
      'Wednesday' => '¼ö¿äÀÏ',    'Wed' => '¼ö',
      'Thursday'  => '¸ñ¿äÀÏ',    'Thu' => '¸ñ',
      'Friday'    => '±İ¿äÀÏ',    'Fri' => '±İ',
      'Saturday'  => 'Åä¿äÀÏ',    'Sat' => 'Åä' 

    );

%month = 
    (
      'January'   => '1¿ù',  'February'  => '2¿ù' ,  'March'     => '3¿ù',
      'Jan'       => '1¿ù',  'Feb'       => '2¿ù',   'Mar'       => '3¿ù',
      'April'     => '4¿ù',  'May'       => '5¿ù',   'June'      => '6¿ù', 
      'Apr'       => '4¿ù',  'May'       => '5¿ù',   'Jun'       => '6¿ù',
      'July'      => '7¿ù',  'August'    => '8¿ù',   'September' => '9¿ù', 
      'Jul'       => '7¿ù',  'Aug'       => '8¿ù',   'Sep'       => '9¿ù', 
      'October'   => '10¿ù', 'November'  => '11¿ù',  'December'  => '12¿ù', 
      'Oct'       => '10¿ù', 'Nov'       => '11¿ù',  'Dec'       => '12¿ù' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
  {
    if($foo[3]=~(/(.*)at(.*)/))
    { 
      @quux=split(/at/,$foo[3]);
#      $foo[3]=$quux[0]." kl.".$quux[1]; 
      $foo[3]=$quux[0];
      $foo[4]=$quux[1]; 
    };
    return $foo[3]."³â $month{$foo[2]} $foo[1]ÀÏ $wday{$foo[0]} $foo[4]";
#    return "$wday{$foo[0]} den $foo[1]. $month{$foo[2]} $foo[3]"; 

  };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
 return $string;
};

# Lithuanian

sub lithuanian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=windows-1257',
     'Maximal 5 Minute Incoming Traffic'      => 'Maksimalus 5 minuèiø áeinantis srautas',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maksimalus 5 minuèiø iğeinantis srautas',
     'the device'                             => 'árenginys',
     'The statistics were last updated(.*)'   => 'Statistika atnaujinta$1',
     ' Average\)</B><BR>'                     => ' vidurkis)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>vid$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>dabar$1',
     'version'                                => 'versija',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>\'dienos\' grafikas ($1 min.',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>\'savaitës\' grafikas (30 min.' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>\'mënesio\' grafikas (2 val.',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>\'metø\' grafikas (1 d.', 
     'Incoming Traffic in (\S+) per Second'   => 'Áeinantis srautas, $1 per sekundæ',
     'Outgoing Traffic in (\S+) per Second'   => 'Iğeinantis srautas i $1 per sekundæ',
     'at which time (.*) had been up for(.*)' => '$1 veikia jau $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     # '([kMG]?)([bB])/h'                       => '$1$2/h',
     'Bits'                                => 'bitai',
     'Bytes'                              => 'baitai',
     '&nbsp;In:</FONT>'                      => '&nbsp;á:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;iğ:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;procentai:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Perkëlë á OpenVMS Alpha:', 
     'Ported to WindowsNT by'                 => 'Perkëlë á WindowsNT:',
     'and'                                    => 'ir',
     '^GREEN'                                 => 'ŞALIA ',
     'BLUE'                                   => 'MËLYNA ',
     'DARK GREEN'                             => 'TAMSIAI ŞALIA ',
     'MAGENTA'                                => 'RAUDONA ',
     'AMBER'                                  => 'GINTARINË '
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'sekmadiená',       'Sun' => 'Sek',
      'Monday'    => 'pirmadiená',       'Mon' => 'Pir',
      'Tuesday'   => 'antradiená',       'Tue' => 'Ant',
      'Wednesday' => 'treèiadiená',      'Wed' => 'Tre',
      'Thursday'  => 'ketvirtadiená',    'Thu' => 'Ket',
      'Friday'    => 'penktadiená',      'Fri' => 'Pen',
      'Saturday'  => 'ğeğtadiená',       'Sat' => 'Ğeğ' 

    );

%month = 
    (
      'January'   => 'sausio',    'February'  => 'vasario' ,    'March'     => 'kovo',
      'Jan'       => 'Sau',       'Feb'       => 'Vas',         'Mar'       => 'Kov',
      'April'     => 'balandşio', 'May'       => 'geguşës',     'June'      => 'birşelio', 
      'Apr'       => 'Bal',       'May'       => 'Geg',         'Jun'       => 'Bir',
      'July'      => 'liepos',    'August'    => 'rugpjûèio',   'September' => 'rugsëjo', 
      'Jul'       => 'Lie',       'Aug'       => 'Rgp',         'Sep'       => 'Rgs', 
      'October'   => 'spalio',    'November'  => 'lapkrièio',   'December'  => 'gruodşio', 
      'Oct'       => 'Spa',       'Nov'       => 'Lap',         'Dec'       => 'Gru' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[1].", ".$quux[0]; 
      };
      return "$foo[3] $month{$foo[2]} $foo[1], $wday{$foo[0]}" ;
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };
# Macedonian

sub macedonian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=windows-1251',
     'Maximal 5 Minute Incoming Traffic'      => 'Ìàêñèìàëåí 5 ìèíóòåí âëåçåí ñîîáğàà¼',
     'Maximal 5 Minute Outgoing Traffic'      => 'Ìàêñèìàëåí 5 ìèíóòåí èçëåçåí ñîîáğàà¼',
     'the device'                             => 'óğåä',
     'The statistics were last updated(.*)'   => 'Ïîñëåäíî àæóğèğàœå íà ïîäàòîöèòå$1',
     ' Average\)</B><BR>'                     => ' ïğîñåê)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Ïğîñå÷åí$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Ìàêñèìàë$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Ìoìåíò$1',
     'version'                                => 'âåğçè¼à',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Äíåâåí\' ãğàô ($1 ìèíóòè',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Íåäåëåí\' ãğàô (30 ìèíóòè' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`Ìåñå÷åí\' ãğàô (2 ÷àñà',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`Ãîäèøåí\' ãğàô (1 äåí', 
     'Incoming Traffic in (\S+) per Second'   => 'Âëåçåí ñîîáğàà¼ - $1 âî ñåêóíäà',
     'Outgoing Traffic in (\S+) per Second'   => 'Èçëåçåí ñîîáğàà¼ - $1 âî ñåêóíäà',
     'at which time (.*) had been up for(.*)' => 'Âğåìå íà íåïğåêèíàòî ğàáîòåœå íà ñèñòåìîò $1 : $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/h',
     # 'Bits'                                => 'Áèòîâè',
     # 'Bytes'                              => 'Áà¼òè'
     '&nbsp;In:</FONT>'                      => '&nbsp;Âëåç:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Èçëåç:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Ïğîöåíò:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Ïîğòèğàíî íà OpenVMS îä', 
     'Ported to WindowsNT by'                 => 'Ïîğòèğàíî íà WindowsNT îä',
     'and'                                    => 'è',
     '^GREEN'                                  => 'Çåëåíà',
     'BLUE'                                   => 'Ñèíà',
     'DARK GREEN'                             => 'Òåìíî Çåëåíà',
     'MAGENTA'                                => 'Âèîëåòîâà',
     'AMBER'                                  => 'Ïîğòîêàëîâà'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Íåäåëà',  		'Sun' => 'Íåä',
      'Monday'    => 'Ïîíåäåëíèê',        'Mon' => 'Ïîí',
      'Tuesday'   => 'Âòîğíèê', 	      'Tue' => 'Âòî',
      'Wednesday' => 'Ñğåäà',  	      'Wed' => 'Ñğå',
      'Thursday'  => '×åòâğòîê',          'Thu' => '×åò',
      'Friday'    => 'Ïåòîê', 	      'Fri' => 'Ïåò',
      'Saturday'  => 'Ñàáîòà', 		'Sat' => 'Ñàá' 

    );

%month = 
    (
      'January'   => '£àíóàğ',    'February'  => 'Ôåâğóàğ' ,    'March'     => 'Ìàğò',
      'Jan'       => '£àí',       'Feb'       => 'Ôåâ',         'Mar'       => 'Ìàğ',
      'April'     => 'Àïğèë',     'May'       => 'Ìà¼',         'June'      => '£óíè', 
      'Apr'       => 'Àïğ',       'May'       => 'Ìà¼',         'Jun'       => '£óí',
      'July'      => '£óëè',      'August'    => 'Àâãóñò',      'September' => 'Ñåïòåìâğè', 
      'Jul'       => '£óë',       'Aug'       => 'Àâã',         'Sep'       => 'Ñåï', 
      'October'   => 'Îêòîìâğè',  'November'  => 'Íîåìâğè',     'December'  => 'Äåêåìâğè', 
      'Oct'       => 'Îêò',       'Nov'       => 'Íîå',         'Dec'       => 'Äåê' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
      return "$wday{$foo[0]} äåí $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };# Malaysian/Malay

sub malay
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Maksimum 5 Minit Trafik Masuk',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maksimum 5 Minit Trafik Keluar',
     'the device'                             => 'alatan',
     'The statistics were last updated(.*)'   => 'Statistik ini kali terakhir dikemaskini pada $1',
     ' Average\)</B><BR>'                     => ' secara purata)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Purata $1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maksimum $1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Kini $1',
     'version'                                => 'versi',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Graf `Harian\' ($1 minit :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Graf `Mingguan\' (30 minit :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Graf `Bulanan\' (2 jam :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Graf `Tahunan\' (1 hari :',
     'Incoming Traffic in (\S+) per Second'   => 'Trafik Masuk $1 per saat',
     'Outgoing Traffic in (\S+) per Second'   => 'Traffic Keluar $1 per saat',
     'at which time (.*) had been up for(.*)' => 'Sehingga waktu $1 ia telah aktif selama $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/j',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Masuk</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Keluar</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Peratus:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Pengubahsuaian ke  OpenVMS Alpha oleh',
     'Ported to WindowsNT by'                 => 'Pengubahsuaian ke WindowsNT oleh',
     'and'                                    => 'dan',
     '^GREEN'                                 => 'HIJAU',
     'BLUE'                                   => 'BIRU',
     'DARK GREEN'                             => 'HIJAU GELAP',
     'MAGENTA'                                => 'MAGENTA',
     'AMBER'                                  => 'AMBAR'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday =
    (
      'Sunday'    => 'Ahad',    'Sun' => 'Aha',
      'Monday'    => 'Isnin',   'Mon' => 'Isn',
      'Tuesday'   => 'Selasa',  'Tue' => 'Sel',
      'Wednesday' => 'Rabu',    'Wed' => 'Rab',
      'Thursday'  => 'Khamis',  'Thu' => 'Kha',
      'Friday'    => 'Jumaat',  'Fri' => 'Jum',
      'Saturday'  => 'Sabtu',   'Sat' => 'Sab'
    );

%month = 
    (
      'January'   => 'Januari',   'February'  => 'Februari' ,   'March'     => 'Mac',
      'Jan'       => 'Jan',       'Feb'       => 'Feb',         'Mar'       => 'Mac',
      'April'     => 'April',     'May'       => 'Mei',         'June'      => 'Jun', 
      'Apr'       => 'Apr',       'May'       => 'Mei',         'Jun'       => 'Jun',
      'July'      => 'Julai',     'August'    => 'Ogos',        'September' => 'September', 
      'Jul'       => 'Jul',       'Aug'       => 'Ogo',         'Sep'       => 'Sep', 
      'October'   => 'Oktober',   'November'  => 'November',    'December'  => 'Disember', 
      'Oct'       => 'Okt',       'Nov'       => 'Nov',         'Dec'       => 'Dis' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." pada ".$quux[1]; 
      };
	return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]";
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Norwegian

sub norwegian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Maksimal inng&aring;ende trafikk i 5 minutter',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maksimal utg&aring;ende trafikk i 5 minutter',
     'the device'                             => 'enhetden',
     'The statistics were last updated(.*)'   => 'Statistikken ble sist oppdatert $1',
     ' Average\)</B><BR>'                     => ' gjennomsnitt)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Gjennomsnitt$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>N&aring;$1',
     'version'                                => 'versjon',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Daglig\' graf ($1 minutts',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Ukentlig\' graf (30 minutts' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`M&aring;nedlig\' graf (2 times',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`&Aring;rlig\' graf (1 dags', 
     'Incoming Traffic in (\S+) per Second'   => 'Inng&aring;ende trafikk i $1 per sekund',
     'Outgoing Traffic in (\S+) per Second'   => 'Utg&aring;ende trafikk i $1 per sekund',
     'at which time (.*) had been up for(.*)' => 'hvor $1 hadde v&aelig;rt oppe i $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes'
     '&nbsp;In:</FONT>'                      => '&nbsp;Inn:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Ut:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Prosent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Port til OpenVMS av', 
     'Ported to WindowsNT by'                 => 'Port til WindowsNT av',
     'and'                                    => 'og',
     '^GREEN'                                  => 'GR&Oslash;NN',
     'BLUE'                                   => 'BL&Aring;',
     'DARK GREEN'                             => 'M&Oslash;RKEGR&Oslash;NN',
     'MAGENTA'                                => 'MAGENTA',
     'AMBER'                                  => 'GUL'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'S&oslash;ndag',    'Sun' => 'S&oslash;n',
      'Monday'    => 'Mandag',           'Mon' => 'Man',
      'Tuesday'   => 'Tirsdag',          'Tue' => 'Tir',
      'Wednesday' => 'Onsdag',           'Wed' => 'Ons',
      'Thursday'  => 'Torsdag',          'Thu' => 'Tor',
      'Friday'    => 'Fredag',           'Fri' => 'Fre',
      'Saturday'  => 'L&oslash;rdag',    'Sat' => 'L&oslash;r' 

    );

%month = 
    (
      'January'   => 'Januar',    'February'  => 'Februar' ,    'March'     => 'Mars',
      'Jan'       => 'Jan',       'Feb'       => 'Feb',         'Mar'       => 'Mar',
      'April'     => 'April',     'May'       => 'Mai',         'June'      => 'Juni', 
      'Apr'       => 'Apr',       'May'       => 'Mai',         'Jun'       => 'Jun',
      'July'      => 'Juli',      'August'    => 'August',      'September' => 'September', 
      'Jul'       => 'Jul',       'Aug'       => 'Aug',         'Sep'       => 'Sep', 
      'October'   => 'Oktober',   'November'  => 'November',    'December'  => 'Desember', 
      'Oct'       => 'Okt',       'Nov'       => 'Nov',         'Dec'       => 'Des' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
      return "$wday{$foo[0]} den $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };

sub polish
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);


  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp


  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-2',
     'Maximal 5 Minute Incoming Traffic'      => 'Maksymalny ruch przychodz±cy w ci±gu 5 minut',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maksymalny ruch wychodz±cy w ci±gu 5 minut',
     'the device'                             => 'urz±dzenie',
     'The statistics were last updated(.*)'   => 'Ostatnie uaktualnienie statystyki $1',
     ' Average\)</B><BR>'                     => ' ¦rednia)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=left><SMALL>¦rednio$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=left><SMALL>Maksymalnie$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=left><SMALL>Aktualnie$1',
     'version'                                => 'wersja',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>`Dzienny\' Graf w ci±gu ($1 Minut/y - ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>`Tygodniowy\' Graf w ci±gu (30 minut - ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>`Miesiêczny\' Graf w ci±gu (2 Godzin - ',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>`Roczny\' Graf w  ci±gu (1 Dnia - ', 
     'Incoming Traffic in (\S+) per Second'   => 'Ruch przychodz±cy - $1 na sekundê',
     'Outgoing Traffic in (\S+) per Second'   => 'Ruch wychodz±cy - $1 na sekundê',
     'at which time (.*) had been up for(.*)' => 'gdy $1 by³ w³±czony przez $2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/g',
     'Bits'                                => 'Bity',
     'Bytes'                              => 'Bajty',
     '&nbsp;In:</FONT>'                      => '&nbsp;Do:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;&nbsp;Z:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Procent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Port dla OpenVMS Alpha dziêki', 
     'Ported to WindowsNT by'                 => 'Port dla WindowsNT dziêki',
     'and'                                    => 'i',
     '^GREEN'                                  => 'ZIELONY',
     'BLUE'                                   => 'NIEBIESKI',
     'DARK GREEN'                             => 'CIEMNO ZIELONY',
     'MAGENTA'                                => 'KARMAZYNOWY',
     'AMBER'                                  => 'BURSZTYNOWY'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Niedziela',     'Sun' => 'Nie',
      'Monday'    => 'Poniedzia³ek',  'Mon' => 'Pon',
      'Tuesday'   => 'Wtorek',        'Tue' => 'Wto',
      'Wednesday' => '¦roda',         'Wed' => '¦ro',
      'Thursday'  => 'Czwartek',      'Thu' => 'Czw',
      'Friday'    => 'Pi±tek',        'Fri' => 'Pi±',
      'Saturday'  => 'Sobota',        'Sat' => 'Sob' 

    );

%month = 
    (
      'January'   => 'Stycznia',     'February'  => 'Lutego',      'March'     => 'Marca',
      'Jan'       => 'Sty',          'Feb'       => 'Lut',         'Mar'       => 'Mar',
      'April'     => 'Kwietnia',     'May'       => 'Maja',        'June'      => 'Czerwca', 
      'Apr'       => 'Kwi',          'May'       => 'Maj',         'Jun'       => 'Cze',
      'July'      => 'Lipca',        'August'    => 'Sierpnia',    'September' => 'Wrze¶nia', 
      'Jul'       => 'Lip',          'Aug'       => 'Sie',         'Sep'       => 'Wrz', 
      'October'   => 'Pa¼dziernika', 'November'  => 'Listopada',   'December'  => 'Grudnia', 
      'Oct'       => 'Pa¼',          'Nov'       => 'Lis',         'Dec'       => 'Gru' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." o godzinie".$quux[1]; 
      };
      return "$wday{$foo[0]} dzieñ $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Português 

sub portuguese 
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Tráfego Maximal Recebido em 5 minutos',
     'Maximal 5 Minute Outgoing Traffic'      => 'Tráfego Maximal Enviado em 5 minutos',
     'the device'                             => 'o dispositivo',
     'The statistics were last updated(.*)'   => 'As Estatísticas foram actualizadas pela última vez na $1',
     ' Average\)</B><BR>'                     => '',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Média$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max.$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Actual$1',
     'version'                                => 'Versão',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Gráfico Diário (em intervalos de $1 Minutos)</B><BR>',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Gráfico Semanal</B><BR>' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Gráfico Mensal</B><BR>',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Gráfico Anual</B><BR>', 
     'Incoming Traffic in (\S+) per Second'   => 'Tráfego recebido em  $1/segundo',
     'Outgoing Traffic in (\S+) per Second'   => 'Tráfego enviado em $1/segundo',
     'Incoming Traffic in (\S+) per Minute'   => 'Tráfego recebido em $1/minuto',
     'Outgoing Traffic in (\S+) per Minute'   => 'Tráfego enviado em $1/minuto',
     'Incoming Traffic in (\S+) per Hour'     => 'Tráfego recebido em $1/hora',
     'Outgoing Traffic in (\S+) per Hour'     => 'Tráfego recebido em $1/hora',
     'at which time (.*) had been up for(.*)' => 'quando o $1, tinha um <I>uptime</I> de $2',
     '(\S+) per minute'			      => '$1/minuto',
     '(\S+) per hour'			      => '$1/hora',    
     '(.+)/s$'                                 => '$1/s',
     # '(.+)/min'                     => '$1/min',
     '(.+)/h$'                       => '$1/h',
     #'([kMG]?)([bB])/s'                       => '$1$2/s',
     #'([kMG]?)([bB])/min'                     => '$1$2/min',
     #'([kMG]?)([bB])/h'                       => '$1$2/h',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                               => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Rec.:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Env.:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Perc.:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Portado para OpenVMS Alpha por', 
     'Ported to WindowsNT by'                 => 'Portado para WindowsNT por',
     'and'                                    => 'e',
     '^GREEN'                                 => 'VERDE',
     'BLUE'                                   => 'AZUL',
     'DARK GREEN'                             => 'VERDE ESCURO',
     # 'MAGENTA'                                => 'MAGENTA',
     # 'AMBER'                               => 'AMBAR',
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Domingo',     'Sun' => 'Dom',
      'Monday'    => 'Segunda-Feira',      'Mon' => 'Seg',
      'Tuesday'   => 'Terça-Feira',    'Tue' => 'Ter',
      'Wednesday' => 'Quarta-Feira',    'Wed' => 'Qua',
      'Thursday'  => 'Quinta-Feira',  'Thu' => 'Qui',
      'Friday'    => 'Sexta-Feira',     'Fri' => 'Sex',
      'Saturday'  => 'Sábado',     'Sat' => 'Sab' 
    );

%month = 
    (
      'January'   => 'Janeiro',    'February'  => 'Fevereiro' ,    'March'     => 'Março',
      'Jan'       => 'Jan',       'Feb'       => 'Fev',         'Mar'       => 'Mar',
      'April'     => 'Abril',     'May'       => 'Maio',         'June'      => 'Junho', 
      'Apr'       => 'Abr',       'May'       => 'Mai',         'Jun'       => 'Jun',
      'July'      => 'Julho',      'August'    => 'Agosto',      'September' => 'Setembro', 
      'Jul'       => 'Jul',       'Aug'       => 'Ago',         'Sep'       => 'Set', 
      'October'   => 'Outubro',   'November'  => 'Novembro',    'December'  => 'Dezembro', 
      'Oct'       => 'Out',       'Nov'       => 'Nov',         'Dec'       => 'Dez' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." pelas ".$quux[1]; 
      };
      return "$wday{$foo[0]}, $foo[1] de $month{$foo[2]} de $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};



# Romanian

sub romanian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-8859-2

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-2',
     'Maximal 5 Minute Incoming Traffic'      => 'Traficul Maxim de intrare pe 5 Minute',
     'Maximal 5 Minute Outgoing Traffic'      => 'Traficul Maxim de iesire pe 5 Minute',
     'the device'                             => 'echipamentul',
     'The statistics were last updated(.*)'   => 'Ultima actualizare :$1',
     ' Average\)</B><BR>'                     => '',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Medie$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maxim$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Curent$1',
     'version'                                => 'versiunea',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Graficul \'Zilnic\' (medie pe $1 minute)</B><BR>',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Graficul \'Sãptãmânal\' (medie pe 30 de minute)</B><BR>' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Graficul \'Lunar\' (medie pe 2 ore)</B><BR>',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Graficul \'Anual\' (medie pe 1 zi)</B><BR>', 
     'Incoming Traffic in (\S+) per Second'   => 'Traficul de intrare [$1/secundã]',
     'Outgoing Traffic in (\S+) per Second'   => 'Traficul de ieºire [$1/secundã]',
     'at which time <B>(\S+)</B> had been up for <B>(\S+)</B>' => 'când <B>$1</B> funcşiona de <B>$2</B>',
     'at which time <B>(\S+)</B> had been up for <B>(\S+) day, (\S+)</B>' => 'când <B>$1</B> funcşiona de <B>$2 zi, $3</B>',
     'at which time <B>(\S+)</B> had been up for <B>(\S+) days, (\S+)</B>' => 'când <B>$1</B> funcşiona de <B>$2 zile, $3</B>',
     #'(.+)/s$'                               => '$1/s',
     #'(.+)/min'                              => '$1/min',
     '(.+)/h$'                                => '$1/ora',
     #'([kMG]?)([bB])/s'                      => '$1$2/s',
     #'([kMG]?)([bB])/min'                    => '$1$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/ora',
     'Bits'                                   => 'Bişi',
     'Bytes'                                  => 'Octeşi',
     '&nbsp;In:</FONT>'                       => '&nbsp;int:&nbsp;</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;ieº:&nbsp;</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;procent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Translatat sub OpenVMS de', 
     'Ported to WindowsNT by'                 => 'Translatat sub WindowsNT de',
     'and'                                    => 'ºi',
     '^GREEN'                                 => 'VERDE',
     'BLUE'                                   => 'ALBASTRU',
     'DARK GREEN'                             => 'VERDE ÎNCHIS',
     'MAGENTA'                                => 'PURPURIU',
     'AMBER'                                  => 'GALBEN',
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'duminicã',     'Sun' => 'lu',
      'Monday'    => 'luni',         'Mon' => 'ma',
      'Tuesday'   => 'marşi',        'Tue' => 'mi',
      'Wednesday' => 'miercuri',     'Wed' => 'jo',
      'Thursday'  => 'joi',          'Thu' => 'vi',
      'Friday'    => 'vineri',       'Fri' => 'sâ',
      'Saturday'  => 'sâmbãtã',      'Sat' => 'du' 
    );

%month = 
    (
      'January'   => 'ianuarie',    'February'  => 'februarie' ,    'March'     => 'martie',
      'Jan'       => 'ian',         'Feb'       => 'feb',           'Mar'       => 'mar',
      'April'     => 'aprilie',     'May'       => 'mai',           'June'      => 'iunie', 
      'Apr'       => 'apr',         'May'       => 'mai',           'Jun'       => 'iun',
      'July'      => 'iulie',       'August'    => 'august',        'September' => 'septembrie', 
      'Jul'       => 'iul',         'Aug'       => 'aug',           'Sep'       => 'sep', 
      'October'   => 'octombrie',   'November'  => 'noiembrie',     'December'  => 'decembrie', 
      'Oct'       => 'oct',         'Nov'       => 'noi',           'Dec'       => 'dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0].", ora ".$quux[1]; 
      };
      return "$wday{$foo[0]}, $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings

  return $string;

};


# Russian

sub russian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=koi8-r',
     'Maximal 5 Minute Incoming Traffic'      => 'íÁËÓÉÍÁÌØÎÙÊ ×ÈÏÄÑİÉÊ ÔÒÁÆÉË ÚÁ 5 ÍÉÎÕÔ',
     'Maximal 5 Minute Outgoing Traffic'      => 'íÁËÓÉÍÁÌØÎÙÊ ÉÓÈÏÄÑİÉÊ ÔÒÁÆÉË ÚÁ 5 ÍÉÎÕÔ',
     'the device'                             => 'ÕÓÔÒÏÊÓÔ×Ï',
     'The statistics were last updated(.*)'   => 'ğÏÓÌÅÄÎÅÅ ÏÂÎÏ×ÌÅÎÉÅ ÓÔÁÔÉÓÔÉËÉ: $1',
     ' Average\)</B><BR>'                     => ')</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>óÒÅÄÎÉÊ$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>íÁËÓ.$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>ôÅËÕİÉÊ$1',
     'version'                                => '×ÅÒÓÉÑ',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>óÕÔÏŞÎÙÊ ÔÒÁÆÉË (ÓÒÅÄÎÅÅ ÚÁ $1 ÍÉÎÕÔ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>îÅÄÅÌØÎÙÊ ÔÒÁÆÉË (ÓÒÅÄÎÅÅ ÚÁ 30 ÍÉÎÕÔ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>íÅÓÑŞÎÙÊ ÔÒÁÆÉË  (ÓÒÅÄÎÅÅ ÚÁ 2 ŞÁÓÁ',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>çÏÄÏ×ÏÊ ÔÒÁÆÉË (ÓÒÅÄÎÅÅ ÚÁ 1 ÄÅÎØ', 
     'Incoming Traffic in (\S+) per Second'   => '÷ÈÏÄÑİÉÊ ÔÒÁÆÉË × $1 × ÓÅËÕÎÄÕ',
     'Outgoing Traffic in (\S+) per Second'   => 'éÓÈÏÄÑİÉÊ ÔÒÁÆÉË × $1 × ÓÅËÕÎÄÕ',
     'at which time (.*) had been up for(.*)' => '× ÜÔÏ ×ÒÅÍÑ $1 ÂÙÌÁ ×ËÌÀŞÅÎÁ $2',
     #'([kMG]?)([bB])/s'                      => '$1$1/ÓÅË',
     #'([kMG]?)([bB])/min'                    => '$1$2/ÍÉÎ',
     '([kMG]?)([bB])/h'                       => '$1$2/ŞÁÓ',
     'Bits'                                  => 'ÂÉÔÁÈ',
     'Bytes'                                 => 'ÂÁÊÔÁÈ',
     '&nbsp;In:</FONT>'                       => '&nbsp;÷È:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;éÓÈ:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;ğÒÏÃÅÎÔÙ:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'áÄÁĞÔÉÒÏ×ÁÎÏ ÄÌÑ OpenVMS Alpha',
     'Ported to WindowsNT by'                 => 'áÄÁĞÔÉÒÏ×ÁÎÏ ÄÌÑ WindowsNT',
     'and'                                    => 'É',
     '^GREEN'                                  => 'úåìåîùê',
     'BLUE'                                   => 'óéîéê',
     'DARK GREEN'                             => 'ôåíîïúåìåîùê',
     'MAGENTA'                                => 'æéïìåôï÷ùê',
     'AMBER'                                  => 'ñîôáòîùê'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => ' ÷ÏÓËÒÅÓÅÎØÅ',	'Sun' => '÷Ó',
      'Monday'    => ' ğÏÎÅÄÅÌØÎÉË',	'Mon' => 'ğÎ',
      'Tuesday'   => ' ÷ÔÏÒÎÉË',	'Tue' => '÷Ô',
      'Wednesday' => ' óÒÅÄÁ',		'Wed' => 'óÒ',
      'Thursday'  => ' şÅÔ×ÅÒÇ',	'Thu' => 'şÔ',
      'Friday'    => ' ğÑÔÎÉÃÁ',	'Fri' => 'ğÔ',
      'Saturday'  => ' óÕÂÂÏÔÁ',	'Sat' => 'óÂ' 
    );

%month = 
    (
      'January'   => 'ñÎ×ÁÒÑ',   'February'  => 'æÅ×ÒÁÌÑ' ,    'March'     => 'íÁÒÔÁ',
      'Jan'       => 'ñÎ×',       'Feb'       => 'æÅ×',         'Mar'       => 'íÁÒ',
      'April'     => 'áĞÒÅÌÑ',     'May'       => 'íÁÑ',         'June'      => 'éÀÎÑ', 
      'Apr'       => 'áĞÒ',       'May'       => 'íÁÑ',         'Jun'       => 'éÀÎ',
      'July'      => 'éÀÌÑ',   'August'    => 'á×ÇÕÓÔÁ',        'September' => 'óÅÎÔÑÂÒÑ', 
      'Jul'       => 'éÀÌ',       'Aug'       => 'á×Ç',         'Sep'       => 'óÅÎ', 
      'October'   => 'ïËÔÑÂÒÑ',   'November'  => 'îÏÑÂÒÑ',    'December'  => 'äÅËÁÂÒÑ', 
      'Oct'       => 'ïËÔ',       'Nov'       => 'îÏÑ',         'Dec'       => 'äÅË' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]."Ç. × ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Russian1251 Code

sub russian1251
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=windows-1251',
     'Maximal 5 Minute Incoming Traffic'      => 'Ìàêñèìàëüíûé âõîäÿùèé òğàôèê çà 5 ìèíóò',
     'Maximal 5 Minute Outgoing Traffic'      => 'Ìàêñèìàëüíûé èñõîäÿùèé òğàôèê çà 5 ìèíóò',
     'the device'                             => 'óñòğîéñòâî',
     'The statistics were last updated(.*)'   => 'Âğåìÿ ïîñëåäíåãî îáíîâëåíèÿ: $1',
     ' Average\)</B><BR>'                     => ')</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD><SMALL>Â ñğåäíåì$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD><SMALL>Ìàêñèìàëüíî$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD><SMALL>Ñåé÷àñ$1',
     'version'                                => 'âåğñèÿ',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Ñóòî÷íûé òğàôèê (ñğåäíåå çà $1 ìèíóò',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Íåäåëüíûé òğàôèê (ñğåäíåå çà 30 ìèíóò' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Ìåñÿ÷íûé òğàôèê  (ñğåäíåå çà 2 ÷àñà',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Ãîäîâîé òğàôèê (ñğåäíåå çà 1 äåíü', 
     'Incoming Traffic in (\S+) per Second'   => 'Âõîäÿùèé òğàôèê â $1 â ñåêóíäó',
     'Outgoing Traffic in (\S+) per Second'   => 'Èñõîäÿùèé òğàôèê â $1 â ñåêóíäó',
     'at which time <B>(\S+)</B> had been up for <B>(\S+)</B>' => 'âğåìÿ ïîñëå èíèöèàëèçàöèè óñòğîéñòâà <B>$1</B>: <B>$2</B>.',
     'at which time <B>(\S+)</B> had been up for <B>(\S+) day, (\S+)</B>' => 'âğåìÿ ïîñëå èíèöèàëèçàöèè óñòğîéñòâà <B>$1</B>: <B>$2 ñóòêè</B>, <B>$3</B>.',
     'at which time <B>(\S+)</B> had been up for <B>(\S+) days, (\S+)</B>' => 'âğåìÿ ïîñëå èíèöèàëèçàöèè óñòğîéñòâà <B>$1</B>: <B>$2 ñóòîê</B>, <B>$3</B>.',
     #'([kMG]?)([bB])/s'                      => '$1$1/ñåê',
     #'([kMG]?)([bB])/min'                    => '$1$2/ìèí',
     '([kMG]?)([bB])/h'                       => '$1$2/÷àñ',
     'Bits'                                  => 'áèòàõ',
     'Bytes'                                 => 'áàéòàõ',
     '&nbsp;In:</FONT>'                       => '&nbsp;Âõ:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Èñõ:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Ïğîöåíòû:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Àäàïòèğîâàíî äëÿ OpenVMS Alpha',
     'Ported to WindowsNT by'                 => 'Àäàïòèğîâàíî äëÿ WindowsNT',
     'and'                                    => 'è',
     '^GREEN'                                  => 'ÇÅËÅÍÛÉ',
     'BLUE'                                   => 'ÑÈÍÈÉ',
     'DARK GREEN'                             => 'ÒÅÌÍÎÇÅËÅÍÛÉ',
     'MAGENTA'                                => 'ÔÈÎËÅÒÎÂÛÉ',
     'AMBER'                                  => 'ßÍÒÀĞÍÛÉ'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => ' Âîñêğåñåíüå',	'Sun' => 'Âñ',
      'Monday'    => ' Ïîíåäåëüíèê',	'Mon' => 'Ïí',
      'Tuesday'   => ' Âòîğíèê',	'Tue' => 'Âò',
      'Wednesday' => ' Ñğåäà',		'Wed' => 'Ñğ',
      'Thursday'  => ' ×åòâåğã',	'Thu' => '×ò',
      'Friday'    => ' Ïÿòíèöà',	'Fri' => 'Ïò',
      'Saturday'  => ' Ñóááîòà',	'Sat' => 'Ñá' 
    );

%month = 
    (
      'January'   => 'ßíâàğÿ',   'February'  => 'Ôåâğàëÿ' ,    'March'     => 'Ìàğòà',
      'Jan'       => 'ßíâ',       'Feb'       => 'Ôåâ',         'Mar'       => 'Ìàğ',
      'April'     => 'Àïğåëÿ',     'May'       => 'Ìàÿ',         'June'      => 'Èşíÿ', 
      'Apr'       => 'Àïğ',       'May'       => 'Ìàÿ',         'Jun'       => 'Èşí',
      'July'      => 'Èşëÿ',   'August'    => 'Àâãóñòà',        'September' => 'Ñåíòÿáğÿ', 
      'Jul'       => 'Èşë',       'Aug'       => 'Àâã',         'Sep'       => 'Ñåí', 
      'October'   => 'Îêòÿáğÿ',   'November'  => 'Íîÿáğÿ',    'December'  => 'Äåêàáğÿ', 
      'Oct'       => 'Îêò',       'Nov'       => 'Íîÿ',         'Dec'       => 'Äåê' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]."ã. â ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};
# Serbian

sub serbian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=windows-1250',
     'Maximal 5 Minute Incoming Traffic'      => 'Najveæi 5 minutni ulazni saobraæaj',
     'Maximal 5 Minute Outgoing Traffic'      => 'Najveæi 5 minutni izlazni saobraæaj',
     'the device'                             => 'uredjaj',
     'The statistics were last updated(.*)'   => 'Poslednje auriranje podataka:$1',
     ' Average\)</B><BR>'                     => ' prosek)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Proseèni$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maksimalni$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Trenutni$1',
     'version'                                => 'verzija',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Dnevni graf ($1 minutni ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Nedeljni graf (30 minutni ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Meseèni graf (2 sata ',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Godišnji graf (1 dnevni ', 
     'Incoming Traffic in (\S+) per Second'   => 'Ulazni saobraæaj - $1 u sekundi.',
     'Outgoing Traffic in (\S+) per Second'   => 'Izlazni saobraæaj - $1 u sekundi.',
     'Incoming Traffic in (\S+) per Minute'   => 'Ulazni saobraæaj - $1 u minutu',
     'Outgoing Traffic in (\S+) per Minute'   => 'Izlazni saobraæaj - $1 u minutu',
     'Incoming Traffic in (\S+) per Hour'     => 'Ulazni saobraæaj - $1 na sat',
     'Outgoing Traffic in (\S+) per Hour'     => 'Izlazni saobraæaj - $1 na sat',
     'at which time (.*) had been up for(.*)' => 'Vreme neprekidnog rada sistema $1 : $2',
     #'([kMG]?)([bB])/s'                       => '\$1\$2/s',
     #'([kMG]?)([bB])/min'     	      	      => '\$1\$2/min',
     #'([kMG]?)([bB])/h'                       => '$1$2/h',
     'Bits'                                   => 'Bita',
     'Bytes'                                  => 'Bajta',
     '&nbsp;In:</FONT>'                       => '&nbsp;Ulaz:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Izlaz:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Procenat</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Na OpenVMS portovao', 
     'Ported to WindowsNT by'                 => 'Na WindowsNT portovao',
     'and'                                    => 'i',
     '^GREEN'                                  => 'Zeleno',
     'BLUE'                                   => 'Plavo',
     'DARK GREEN'                             => 'Tamnozeleno',
     'MAGENTA'                                => 'Ljubièasto',
     'AMBER'                                  => 'Narandasto'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Nedelja',		'Sun' => 'Ned',
      'Monday'    => 'Ponedeljak',	'Mon' => 'Pon',
      'Tuesday'   => 'Utorak',		'Tue' => 'Uto',
      'Wednesday' => 'Sreda',		'Wed' => 'Sre',
      'Thursday'  => 'Èetvrtak',	'Thu' => 'Èet',
      'Friday'    => 'Petak',		'Fri' => 'Pet',
      'Saturday'  => 'Subota',		'Sat' => 'Sub' 
    );

%month = 
    (
 'January' => 'januar', 'February' => 'februar', 'March'     => 'mart',
 'Jan'     => 'Jan', 'Feb'      => 'Feb', 'Mar'       => 'Mar',
 'April'   => 'april',	'May'      => 'maj',     'June'      => 'jun',
 'Apr'     => 'Apr',  'May'      => 'Maj',     'Jun'       => 'Jun',
 'July'    => 'jul',	'August'   => 'avgust',  'September' => 'septembar',
 'Jul'     => 'Jul',	'Aug'      => 'Avg',  'Sep'       => 'Sep', 
 'October' => 'oktobar','November' => 'novembar','December'  => 'decembar', 
 'Oct'     => 'Okt',  'Nov'      => 'Nov',  'Dec'       => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0].",".$quux[1]." "; 
      };
      return "$wday{$foo[0]} $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings

  return $string;

}
#
# Slovak

sub slovak
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-2',
     'Maximal 5 Minute Incoming Traffic'      => 'Maximálny 5 minútovı prichádzajúci tok',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maximálny 5 minútovı odchádzajúci tok',
     'the device'                             => 'zariadenie',
     'The statistics were last updated(.*)'   => 'Posledná aktualizácia ¹tatistík:$1',
     ' Average\)</B><BR>'                     => ' priemer)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Priem.$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max.$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Akt.$1',
     'version'                                => 'verzia',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Dennı graf ($1 minútovı',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Tı¾dennı graf (30 minútovı' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Mesaènı graf (2 hodinovı',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Roènı graf (1 dennı', 
     'Incoming Traffic in (\S+) per Second'   => 'Prichádzajúci tok v $1 za sekundu.',
     'Outgoing Traffic in (\S+) per Second'   => 'Odchádzajúci tok v $1 za sekundu.',
     'at which time (.*) had been up for(.*)' => 'Èas od posledného re¹tartu $1 : $2',
     #'([kMG]?)([bB])/s'                       => '\$1\$2/s',
     #'([kMG]?)([bB])/min'     	      	      => '\$1\$2/min',
     #'([kMG]?)([bB])/h'                       => '$1$2/h',
     'Bits'                                   => 'bitoch',
     'Bytes'                                  => 'bytoch',
     #'&nbsp;In:</FONT>'                       => '&nbsp;In:</FONT>',
     #'&nbsp;Out:</FONT>'                      => '&nbsp;Out:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Perc.</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Na OpenVMS portoval', 
     'Ported to WindowsNT by'                 => 'Na WindowsNT portoval',
     'and'                                    => 'a',
     '^GREEN'                                  => 'Zelená',
     'BLUE'                                   => 'Modrá',
     'DARK GREEN'                             => 'Tmavozelená',
     'MAGENTA'                                => 'Fialová',
     'AMBER'                                  => '®ltá'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Nedeµa',		'Sun' => 'Ne',
      'Monday'    => 'Pondelok',	'Mon' => 'Po',
      'Tuesday'   => 'Utorok',		'Tue' => 'Ut',
      'Wednesday' => 'Streda',		'Wed' => 'St',
      'Thursday'  => '©tvrtok',		'Thu' => '©t',
      'Friday'    => 'Piatok',		'Fri' => 'Pi',
      'Saturday'  => 'Sobota',		'Sat' => 'So' 
    );

%month = 
    (
 'January' => 'Január', 'February' => 'Február', 'March'     => 'Marec',
 'Jan'     => 'Január', 'Feb'      => 'Február', 'Mar'       => 'Marec',
 'April'   => 'Apríl',	'May'      => 'Máj',     'June'      => 'Jún',
 'Apr'     => 'Apríl',  'May'      => 'Máj',     'Jun'       => 'Jún',
 'July'    => 'Júl',	'August'   => 'August',  'September' => 'September',
 'Jul'     => 'Júl',	'Aug'      => 'August',  'Sep'       => 'September', 
 'October' => 'Október','November' => 'November','December'  => 'December', 
 'Oct'     => 'Október','Nov'      => 'November','Dec'       => 'December' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0].",".$quux[1]." hod."; 
      };
      return "$wday{$foo[0]} $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings

  return $string;

}
#
# Slovenian

sub slovenian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=windows-1250',
     'Maximal 5 Minute Incoming Traffic'      => 'Najvecji petminutni vhodni promet',
     'Maximal 5 Minute Outgoing Traffic'      => 'Najvecji petminutni izhodni promet',
     'the device'                             => 'naprava',
     'The statistics were last updated(.*)'   => 'Zadnja posodobitev podatkov:$1',
     ' Average\)</B><BR>'                     => ' povprecje)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Povprecje$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Maksimalno$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Trenutno$1',
     'version'                                => 'verzija',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Dnevni graf ($1 min.',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Tedenski graf (30 min.' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Mesecni graf (2 urno',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Letni graf (1 dnevno', 
     'Incoming Traffic in (\S+) per Second'   => 'Vhodni promet v $1 na sekundo.',
     'Outgoing Traffic in (\S+) per Second'   => 'Izhodni promet v $1 na sekundo.',
     'at which time (.*) had been up for(.*)' => 'Cas od zadnjega restarta sistema $1 : $2',
     #'([kMG]?)([bB])/s'                       => '\$1\$2/s',
     #'([kMG]?)([bB])/min'     	      	      => '\$1\$2/min',
     #'([kMG]?)([bB])/h'                       => '$1$2/h',
     'Bits'                                   => 'bitov',
     'Bytes'                                  => 'bytov',
     '&nbsp;In:</FONT>'                       => '&nbsp;Vhod:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Izhod:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Proc.</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Na OpenVMS portiral', 
     'Ported to WindowsNT by'                 => 'Na WindowsNT portiral',
     'and'                                    => 'in',
     '^GREEN'                                  => 'Zeleno',
     'BLUE'                                   => 'Modro',
     'DARK GREEN'                             => 'Temnozeleno',
     'MAGENTA'                                => 'Vijolicasto',
     'AMBER'                                  => 'Oranzno'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Nedelja',		'Sun' => 'Ne',
      'Monday'    => 'Ponedeljek',	'Mon' => 'Po',
      'Tuesday'   => 'Torek',		'Tue' => 'To',
      'Wednesday' => 'Sreda',		'Wed' => 'Sr',
      'Thursday'  => 'Cetrtek',		'Thu' => 'Ce',
      'Friday'    => 'Petek',		'Fri' => 'Po',
      'Saturday'  => 'Sobota',		'Sat' => 'So' 
    );

%month = 
    (
 'January' => 'Januar', 'February' => 'Februar', 'March'     => 'Marec',
 'Jan'     => 'Jan', 'Feb'      => 'Feb', 'Mar'       => 'Mar',
 'April'   => 'April',	'May'      => 'Maj',     'June'      => 'Jun',
 'Apr'     => 'Apr',  'May'      => 'Maj',     'Jun'       => 'Jun',
 'July'    => 'Julij',	'August'   => 'Avgust',  'September' => 'September',
 'Jul'     => 'Jul',	'Aug'      => 'Avg',  'Sep'       => 'Sep', 
 'October' => 'Oktober','November' => 'November','December'  => 'December', 
 'Oct'     => 'Okt','Nov'      => 'Nov','Dec'       => 'Dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0].",".$quux[1]." "; 
      };
      return "$wday{$foo[0]} $foo[1]. $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings

  return $string;

}
#
# Spanish

sub spanish
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Tr&aacute;fico entrante m&aacute;ximo en 5 minutos',
     'Maximal 5 Minute Outgoing Traffic'      => 'Tr&aacute;fico saliente m&aacute;ximo en 5 minutos',
     'the device'                             => 'el dispositivo',
     'The statistics were last updated(.*)'   => 'Estad&iacute;sticas actualizadas el $1',
     ' Average\)</B><BR>'                     => ' Promedio)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Promedio $1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>M&aacute;x$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Actual$1',
     'version'                                => 'version',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Gr&aacute;fico diario ($1 minutos :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Gr&aacute;fico semanal (30 minutos :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Gr&aacute;fico mensual (2 horas :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Gr&aacute;fico anual (1 d&iacute;a :', 
     'Incoming Traffic in (\S+) per Second'   => 'Tr&aacute;fico entrante en $1 por segundo',
     'Outgoing Traffic in (\S+) per Second'   => 'Tr&aacute;fico saliente en $1 por segundo',
     'at which time (.*) had been up for(.*)' => '$1 ha estado funcionando durante $2',
     # '([kMG]?)([bB])/s'                      => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                    => '\$1\$2/min',
     # '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                  => 'Bits',
     # 'Bytes'                                 => 'Bytes'
     '&nbsp;In:</FONT>'                       => '&nbsp;Entrante:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Saliente:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Porcentaje:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Portado a OpenVMS Alpha por',
     'Ported to WindowsNT by'                 => 'Portado a WindowsNT por',
     'and'                                    => 'y',
     '^GREEN'                                  => 'VERDE',
     'BLUE'                                   => 'AZUL',
     'DARK GREEN'                             => 'VERDE OSCURO',
     'MAGENTA'                                => 'MAGENTA',
     'AMBER'                                  => 'AMBAR'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Domingo',		'Sun' => 'Dom',
      'Monday'    => 'Lunes',		'Mon' => 'Lun',
      'Tuesday'   => 'Martes',		'Tue' => 'Mar',
      'Wednesday' => 'Mi&eacute;rcoles','Wed' => 'Mi&eacute;',
      'Thursday'  => 'Jueves',		'Thu' => 'Jue',
      'Friday'    => 'Viernes',		'Fri' => 'Vie',
      'Saturday'  => 'S&aacute;bado',	'Sat' => 'Sab' 
    );

%month = 
    (
 'January' => 'Enero',   'February' => 'Febrero' ,  'March'     => 'Marzo',
 'Jan'     => 'Ene',     'Feb'      => 'Feb',       'Mar'       => 'Mar',
 'April'   => 'Abril',   'May'      => 'Mayo',      'June'      => 'Junio', 
 'Apr'     => 'Abr',     'May'      => 'Mai',       'Jun'       => 'Jun',
 'July'    => 'Julio',   'August'   => 'Agosto',    'September' => 'Setiembre', 
 'Jul'     => 'Jul',     'Aug'      => 'Ago',       'Sep'       => 'Set', 
 'October' => 'Octubre', 'November' => 'Noviembre', 'December'  => 'Diciembre', 
 'Oct'     => 'Oct',     'Nov'       => 'Nov',      'Dec'       => 'Dic' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." a las ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] de $month{$foo[2]} de $foo[3]"; 
    };
  return $string;
}
# Swedish

sub swedish
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     #'charset=iso-8859-1'                     => 'charset=iso-8859-1',
     'Maximal 5 Minute Incoming Traffic'      => 'Maximalt inkommande trafik i 5 minuter',
     'Maximal 5 Minute Outgoing Traffic'      => 'Maximalt utg&aring;ende trafik i 5 minuter',
     'the device'                             => 'enheten',
     'The statistics were last updated(.*)'   => 'Statistiken blev senast uppdaterad$1',
     ' Average\)</B><BR>'                     => ')</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Medel$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>Max$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>Senaste$1',
     'version'                                => 'version',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Daglig graf (samplingsintervall $1 minut(er)',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Veckovis graf (medelvärde per 30 minuter' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>M&aring;natlig graf (medelvärde per 2 timmar',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>&Aring;rlig graf (medelvärde per dygn', 
     'Incoming Traffic in (\S+) per Second'   => 'Inkommande trafik i $1 per sekund',
     'Outgoing Traffic in (\S+) per Second'   => 'Utgående trafik i $1 per sekund',
     'at which time (.*) had been up for(.*)' 		=> 'då $1 varit ig&aring;ng i$2',
     # '([kMG]?)([bB])/s'                 => '\$1\$2/s',
     # '([kMG]?)([bB])/min'              => '\$1\$2/min',
     '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                => 'Bits',
     # 'Bytes'                              => 'Bytes',
     '&nbsp;In:</FONT>'                      => '&nbsp; In:</FONT>',
     '&nbsp;Out:</FONT>'                     => '&nbsp;Ut:</FONT>',
     '&nbsp;Percentage</FONT>'               => '&nbsp;Procent:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'Portad till OpenVMS av', 
     'Ported to WindowsNT by'                 => 'Portad till WindowsNT av',
     'and'                                    => 'och',
     '^GREEN'                                  => 'GR&Ouml;N',
     'BLUE'                                   => 'BL&Aring;',
     'DARK GREEN'                             => 'M&Ouml;RKGR&Ouml;N',
     'MAGENTA'                                => 'MANGENTA',
     'AMBER'                                  => 'BRUN',

  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 's&ouml;ndag',    'Sun' => 's&ouml;n',
      'Monday'    => 'm&aring;ndag',           'Mon' => 'm&aring;n',
      'Tuesday'   => 'tisdag',          'Tue' => 'tis',
      'Wednesday' => 'onsdag',           'Wed' => 'ons',
      'Thursday'  => 'torsdag',          'Thu' => 'tor',
      'Friday'    => 'fredag',           'Fri' => 'fre',
      'Saturday'  => 'l&ouml;rdag',    'Sat' => 'l&ouml;r' 

    );

%month = 
    (
      'January'   => 'januari',   'February'  => 'februari',    'March'     => 'mars',
      'Jan'       => 'jan',       'Feb'       => 'feb',         'Mar'       => 'mar',
      'April'     => 'april',     'May'       => 'maj',         'June'      => 'juni', 
      'Apr'       => 'apr',       'May'       => 'maj',         'Jun'       => 'jun',
      'July'      => 'juli',      'August'    => 'augusti',      'September' => 'september', 
      'Jul'       => 'jul',       'Aug'       => 'aug',         'Sep'       => 'sep', 
      'October'   => 'oktober',   'November'  => 'november',    'December'  => 'december', 
      'Oct'       => 'okt',       'Nov'       => 'nov',         'Dec'       => 'dec' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." kl.".$quux[1]; 
      };
      return "$wday{$foo[0]} den $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

  };
# Turkish

sub turkish
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...

  %translations =
  (  
     'charset=iso-8859-9'                     => 'charset=iso-8859-9',
     'Maximal 5 Minute Incoming Traffic'      => '5 dakika için en yüksek giriş trafiği',
     'Maximal 5 Minute Outgoing Traffic'      => '5 dakika için en yüksek çıkış trafiği',
     'the device'                             => 'aygıt',
     'The statistics were last updated(.*)'   => 'İstatistiklerin en son güncellenmesi $1',
     ' Average\)</B><BR>'                     => ' Ortalama)</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>Ortalama $1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>EnYüksek;x$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>ŞuAnki$1',
     'version'                                => 'sürüm',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>Günlük ($1 dakika :',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>Haftalık (30 dakika :' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>Aylık (2 saat :',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>Yıllık (1 gün :', 
     'Incoming Traffic in (\S+) per Second'   => '$1 deki saniyelik giriş trafiği',
     'Outgoing Traffic in (\S+) per Second'   => '$1 deki saniyelik çıkış trafiği',
     'at which time (.*) had been up for(.*)' => '$1 Ne zamandan $2 beri ayakta',
     # '([kMG]?)([bB])/s'                      => '\$1\$2/s',
     # '([kMG]?)([bB])/min'                    => '\$1\$2/min',
     # '([kMG]?)([bB])/h'                       => '$1$2/t',
     # 'Bits'                                  => 'Bit',
     # 'Bytes'                                 => 'Byte'
     '&nbsp;In:</FONT>'                       => '&nbsp;Giriş:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;Çıkış:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;Yüzge:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'OpenVMS Alpha ya uyarlayan',
     'Ported to WindowsNT by'                 => 'WindowsNT ye uyarlayan',
     'and'                                    => 've',
     '^GREEN'                                 => 'YEŞİL',
     'BLUE'                                   => 'MAVİ',
     'DARK GREEN'                             => 'KOYU YEŞİL',
     'MAGENTA'                                => 'MACENTA',
     'AMBER'                                  => 'AMBER'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => 'Pazar',		'Pzr' => 'Dom',
      'Monday'    => 'Pazartesi',	'Pzt' => 'Lun',
      'Tuesday'   => 'Salı',		'Sal' => 'Mar',
      'Wednesday' => 'Çarşamba',	'Çrş' => 'Mi&eacute;',
      'Thursday'  => 'Perşembe',	'Prş' => 'Jue',
      'Friday'    => 'Cuma',		'Cum' => 'Vie',
      'Saturday'  => 'Cumartesi',	'Cmr' => 'Sab' 
    );

%month = 
    (
 'January' => 'Ocak',    'February' => 'Şubat',     'March'     => 'Mart',
 'Jan'     => 'Ock',     'Feb'      => 'Şub',       'Mar'       => 'Mar',
 'April'   => 'Nisan',   'May'      => 'Mayıs',     'June'      => 'Haziran', 
 'Apr'     => 'Nis',     'May'      => 'May',       'Jun'       => 'Hzr',
 'July'    => 'Temmuz',  'August'   => 'Agustos',   'September' => 'Eylül', 
 'Jul'     => 'Tem',     'Aug'      => 'Agu',       'Sep'       => 'Eyl', 
 'October' => 'Ekim',    'November' => 'Kasım',     'December'  => 'Aralık', 
 'Oct'     => 'Ekm',     'Nov'      => 'Kas',       'Dec'       => 'Ara' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]." a las ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] de $month{$foo[2]} de $foo[3]"; 
    };
}


# Ukrainian

sub ukrainian
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  
  # regexp => replacement string NOTE does not use autovars $1,$2...
  # charset=iso-2022-jp

  %translations =
  (  
     'charset=iso-8859-1'                     => 'charset=koi8-u',
     'Maximal 5 Minute Incoming Traffic'      => 'íÁËÓÉÍÁÌØÎÉÊ ×È¦ÄÎÉÊ ÔÒÁÆ¦Ë ÚÁ 5 È×ÉÌÉÎ',
     'Maximal 5 Minute Outgoing Traffic'      => 'íÁËÓÉÍÁÌØÎÉÊ ×ÉÈ¦ÄÎÉÊ ÔÒÁÆ¦Ë ÚÁ 5 È×ÉÌÉÎ',
     'the device'                             => 'ĞÒÉÓÔÒ¦Ê',
     'The statistics were last updated(.*)'   => 'ïÓÔÁÎÎ¤ ÏÎÏ×ÌÅÎÎÑ ÓÔÁÔÉÓÔÉËÉ ÂÕÌÏ ×: $1',
     ' Average\)</B><BR>'                     => ')</B><BR>',
     '<TD ALIGN=right><SMALL>Average(.*)'     => '<TD ALIGN=right><SMALL>óÅÒÅÄÎ¦Ê$1',
     '<TD ALIGN=right><SMALL>Max(.*)'         => '<TD ALIGN=right><SMALL>íÁËÓ.$1',
     '<TD ALIGN=right><SMALL>Current(.*)'     => '<TD ALIGN=right><SMALL>ğÏÔÏŞÎÉÊ$1',
     'version'                                => '×ÅÒÓ¦Ñ',
     '<B>`Daily\' Graph \((.*) Minute'        => '<B>äÏÂÏ×ÉÊ ÔÒÁÆ¦Ë (ÓÅÒÅÄÎ¤ ÚÁ $1 È×ÉÌÉÎ',
     '<B>`Weekly\' Graph \(30 Minute'         => '<B>ôÉÖÎÅ×ÉÊ ÔÒÁÆ¦Ë (ÓÅÒÅÄÎ¤ ÚÁ 30 È×ÉÌÉÎ' ,
     '<B>`Monthly\' Graph \(2 Hour'           => '<B>í¦ÓÑŞÎÉÊ ÔÒÁÆ¦Ë  (ÓÅÒÅÄÎ¤ ÚÁ 2 ÇÏÄÉÎÉ',
     '<B>`Yearly\' Graph \(1 Day'             => '<B>ò¦ŞÎÉÊ ÔÒÁÆ¦Ë (ÓÅÒÅÄÎ¤ ÚÁ 1 ÄÅÎØ', 
     'Incoming Traffic in (\S+) per Second'   => '÷È¦ÄÎÉÊ ÔÒÁÆ¦Ë × $1 ÚÁ ÓÅËÕÎÄÕ',
     'Outgoing Traffic in (\S+) per Second'   => '÷ÉÈ¦ÄÎÉÊ ÔÒÁÆ¦Ë × $1 ÚÁ ÓÅËÕÎÄÕ',
     'at which time (.*) had been up for(.*)' => '$1 ÂÕÌÏ ×ËÌÀŞÅÎÏ Ï $2',
     #'([kMG]?)([bB])/s'                      => '$1$1/Ó',
     #'([kMG]?)([bB])/min'                    => '$1$2/È×',
     '([kMG]?)([bB])/h'                       => '$1$2/ÇÏÄ',
     'Bits'                                  => 'Â¦ÔÁÈ',
     'Bytes'                                 => 'ÂÁÊÔÁÈ',
     '&nbsp;In:</FONT>'                       => '&nbsp;÷È:</FONT>',
     '&nbsp;Out:</FONT>'                      => '&nbsp;÷ÉÈ:</FONT>',
     '&nbsp;Percentage</FONT>'                => '&nbsp;÷¦ÄÓÏÔËÉ:</FONT>',
     'Ported to OpenVMS Alpha by'             => 'áÄÁĞÔÏ×ÁÎÏ ÄÌÑ OpenVMS Alpha',
     'Ported to WindowsNT by'                 => 'áÄÁĞÔÏ×ÁÎÏ ÄÌÑ WindowsNT',
     'and'                                    => '¦',
     '^GREEN'                                  => 'úåìåîéê',
     'BLUE'                                   => 'óéî¶ê',
     'DARK GREEN'                             => 'ôåíîïúåìåîéê',
     'MAGENTA'                                => 'æ¶ïìåôï÷éê',
     'AMBER'                                  => 'âõòûôéîï÷éê'
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => ' îÅÄ¦ÌÀ',		'Sun' => 'îÄ',
      'Monday'    => ' ğÏÎÅÄ¦ÌÏË',	'Mon' => 'ğÎ',
      'Tuesday'   => ' ÷¦×ÔÏÒÏË',	'Tue' => '÷×',
      'Wednesday' => ' óÅÒÅÄÕ',		'Wed' => 'óÒ',
      'Thursday'  => ' şÅÔ×ÅÒ',		'Thu' => 'şÔ',
      'Friday'    => ' ğ\'ÑÔÎÉÃÀ',	'Fri' => 'ğÔ',
      'Saturday'  => ' óÕÂÏÔÕ',		'Sat' => 'óÂ' 
    );

%month = 
    (
      'January'   => 'ó¦ŞÎÑ',   'February'  => 'ìÀÔÏÇÏ' ,    'March'     => 'âÅÒÅÚÎÑ',
      'Jan'       => 'ó¦Ş',     'Feb'       => 'ìÀÔ',        'Mar'       => 'âÅÒ',
      'April'     => 'ë×¦ÔÎÑ',  'May'       => 'ôÒÁ×ÎÑ',     'June'      => 'şÅÒ×ÎÑ', 
      'Apr'       => 'ë×¦',     'May'       => 'ôÒÁ',        'Jun'       => 'şÅÒ',
      'July'      => 'ìÉĞÎÑ',   'August'    => 'óÅÒĞÎÑ',     'September' => '÷ÅÒÅÓÎÑ', 
      'Jul'       => 'ìÉĞ',     'Aug'       => 'óÅÒ',        'Sep'       => '÷ÅÒ', 
      'October'   => 'öÏ×ÔÎÑ',  'November'  => 'ìÉÓÔÏĞÁÄÁ',  'December'  => 'çÒÕÄÎÑ', 
      'Oct'       => 'öÏ×',     'Nov'       => 'ìÉÓ',        'Dec'       => 'çÒÕ' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]."Ò. Ï ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};


# Ukrainian1251 - windowze encoding

sub ukrainian1251
{
  my $string = shift;
return "" unless defined $string;
  my(%translations,%month,%wday);

  my($i,$j);
  my(@dollar,@quux,@foo);

  %translations =
  (
  'charset=iso-8859-1'				=> 'charset=windows-1251',
  'Maximal 5 Minute Incoming Traffic'		=> 'Ìàêñèìàëüíèé âõ³äíèé òğàô³ê çà 5 õâèëèí',
  'Maximal 5 Minute Outgoing Traffic'		=> 'Ìàêñèìàëüíèé âèõ³äíèé òğàô³ê çà 5 õâèëèí',
  'the device'					=> 'ïğèñòğ³é',
  'The statistics were last updated(.*)'	=> 'Îñòàííº îíîâëåííÿ ñòàòèñòèêè: $1',
  ' Average\)</B><BR>'				=> ')</B><BR>',
  '<TD ALIGN=right><SMALL>Average(.*)'		=> '<TD ALIGN=right><SMALL>Ñåğåäí³é$1',
  '<TD ALIGN=right><SMALL>Max(.*)'		=> '<TD ALIGN=right><SMALL>Ìàêñèìàëüíèé$1',
  '<TD ALIGN=right><SMALL>Current(.*)'		=> '<TD ALIGN=right><SMALL>Ïîòî÷íèé$1',
  'version'					=> 'âåğñ³ÿ',
  '<B>`Daily\' Graph \((.*) Minute'		=> '<B>Äåííèé òğàô³ê (â ñåğåäíüîìó çà $1 õâèëèí',
  '<B>`Weekly\' Graph \(30 Minute'		=> '<B>Òèæíåâèé òğàô³ê (â ñåğåäíüîìó çà 30 õâèëèí' ,
  '<B>`Monthly\' Graph \(2 Hour'		=> '<B>Ì³ñÿ÷íèé òğàô³ê (â ñåğåäíüîìó çà äâi ãîäèíè',
  '<B>`Yearly\' Graph \(1 Day'			=> '<B>Ğ³÷íèé òğàô³ê (â ñåğåäíüîìó çà îäèí äåíü', 
  'Incoming Traffic in (\S+) per Second'	=> 'Âõ³äíèé òğàô³ê â $1 çà ñåêóíäó',
  'Outgoing Traffic in (\S+) per Second'	=> 'Âèõ³äíèé òğàô³ê â $1 çà ñåêóíäó',
  'at which time (.*) had been up for(.*)'	=> '$1 â ä³¿: $2',
  '([kMG]?)([bB])/s'				=> '$1$1/ñåê',
  '([kMG]?)([bB])/min'				=> '$1$2/õâ',
  '([kMG]?)([bB])/h'				=> '$1$2/ãîä',
  '([bB])/s'					=> '$1/ñåê',
  '([bB])/min'					=> '$1/õâ',
  '([bB])/h'					=> '$1/ãîä',
  'Bits'					=> 'á³òàõ',
  'Bytes'					=> 'áàéòàõ',
  '&nbsp;In:</FONT>'				=> '&nbsp;âõ³ä:</FONT>',
  '&nbsp;Out:</FONT>'				=> '&nbsp;âèõ³ä:</FONT>',
  '&nbsp;Percentage</FONT>'			=> '&nbsp;Â³äñîòîê:</FONT>',
  'Ported to OpenVMS Alpha by'			=> 'Ïîğòîâàíî íà OpenVMS Alpha',
  'Ported to WindowsNT by'			=> 'Ïîğòîâàíî íà WindowsNT',
  'and'						=> 'òà',
  'RED'						=> '×ÅĞÂÎÍÈÉ',
  '^GREEN'					=> 'ÇÅËÅÍÈÉ',
  'BLUE'					=> 'ÑÈÍ²É',
  'DARK GREEN'					=> 'ÒÅÌÍÎÇÅËÅÍÈÉ',
  'MAGENTA'					=> 'Ô²ÎËÅÒÎÂÈÉ',
  'AMBER'					=> 'ÁÓĞØÒÈÍÎÂÈÉ',
  );

# maybe expansions with replacement of whitespace would be more appropriate

foreach $i (keys %translations)
{  
  my $trans = $translations{$i};
  $trans =~ s/\|/\|/;  
  return $string if eval " \$string =~ s|\${i}|${trans}| ";
};

%wday = 
    (
      'Sunday'    => ' Íåä³ëÿ',		'Sun' => 'Íä',
      'Monday'    => ' Ïîíåä³ëîê',	'Mon' => 'Ïí',
      'Tuesday'   => ' Â³âòîğîê',	'Tue' => 'Âò',
      'Wednesday' => ' Ñåğåäà',		'Wed' => 'Ñğ',
      'Thursday'  => ' ×åòâåğ',		'Thu' => '×ò',
      'Friday'    => ' Ï\'ÿòíèöÿ',	'Fri' => 'Ïò',
      'Saturday'  => ' Ñóáîòà',		'Sat' => 'Ñá' 
    );

%month = 
    (
      'January'   => 'Ñ³÷íÿ',   'February'  => 'Ëşòîãî' ,    'March'     => 'Áåğåçíÿ',
      'Jan'       => 'Ñ³÷',       'Feb'       => 'Ëşò',         'Mar'       => 'Áåğ',
      'April'     => 'Êâ³òíÿ',     'May'       => 'Òğàâíÿ',         'June'      => '×åğâíÿ', 
      'Apr'       => 'Êâò',       'May'       => 'Òğâ',         'Jun'       => '×åğ',
      'July'      => 'Ëèïíÿ',   'August'    => 'Ñåğïíÿ',        'September' => 'Âåğåñíÿ', 
      'Jul'       => 'Ëèï',       'Aug'       => 'Ñåğ',         'Sep'       => 'Âåğ', 
      'October'   => 'Æîâòíÿ',   'November'  => 'Ëèñòîïàäà',    'December'  => 'Ãğóäíÿ', 
      'Oct'       => 'Æîâ',       'Nov'       => 'Ëèñ',         'Dec'       => 'Ãğä' 
    );

  @foo=($string=~/(\S+),\s+(\S+)\s+(\S+)(.*)/);
  if($foo[0] && $wday{$foo[0]} && $foo[2] && $month{$foo[2]} )
    {
	if($foo[3]=~(/(.*)at(.*)/))
      { 
        @quux=split(/at/,$foo[3]);
        $foo[3]=$quux[0]."ğ. ".$quux[1]; 
      };
      return "$wday{$foo[0]} $foo[1] $month{$foo[2]} $foo[3]"; 
    };

#
# handle two different time/date formats:  
# return "$wday, $mday $month ".($year+1900)." at $hour:$min";
# return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
#

# handle nontranslated strings which ought to be translated
# print STDERR "$_\n" or print DEBUG "not translated $_";
# but then again we might not want/need to translate all strings
  
  return $string;

};

