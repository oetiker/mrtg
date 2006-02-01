<define-tag where>\
<perl>
my $path=$WML_SRC_DIRNAME."/".$WML_SRC_BASENAME;
$path =~ s|.+?web/||s;
print "$path.en.html";
</perl>\
</define-tag>

#
# an rrdworld entry
#
#<rrdworld type="extension|application"
#       icon="rumble.png" > <!-- Size 100x66 -->
#
#       <name> RRRRumble </name>
#     <author> Peter Example </author>
#<description> Makes rrdtool rumble when new data is added </description>
#   <homepage> http://somesite.blabla.plac </homepage> 
#       <year> 2005 </year><month> 4 </month>
#    <license> GPL </license>
#
#   <!-- Optional -->   
#
#   <livesite> http://somesite.blabla.plac </livesite> 
#      <email> max@example.com </email>
#
#</rrdworld>

#<gallery image="graph.png" >
#
#      <title> Virus Graph </title>
#     <author> Max Beispiel </author> 
#<description> The five most common critters of the week. </description>
#       <year> 2005 </year><month> 4 </month>
#      
#   <!-- Optional -->   
#
#   <livesite> http://somesite.blabla.plac </livesite> 
#      <email> max@example.com </email>
#
#</gallery>



<define-tag name        endtag=required ><set-var-x name=rwv_name><h3>%body</h3></set-var-x></define-tag>
<define-tag title       endtag=required ><set-var-x name=rwv_title><h2>%body</h2></set-var-x></define-tag>
<define-tag author      endtag=required ><set-var-x name=rwv_author>%body</set-var-x></define-tag>
<define-tag description endtag=required ><set-var-x name=rwv_description>%body</set-var-x></define-tag>
<define-tag homepage    endtag=required ><set-var-x name=rwv_homepage> ... <a href="<subst-in-string %body " " "" />">[home]</a></set-var-x></define-tag>
<define-tag year        endtag=required ><set-var-x name=rwv_year> %body </set-var-x></define-tag>
<define-tag month       endtag=required ><set-var-x name=rwv_month> /%body </set-var-x></define-tag>
<define-tag license     endtag=required ><set-var-x name=rwv_license>License: %body</set-var-x></define-tag>
<define-tag livesite    endtag=required ><set-var-x name=rwv_livesite> <a href="<subst-in-string "%body" " " "" />">[demo]</a></set-var-x></define-tag>
<define-tag email       endtag=required ><set-var-x name=rwv_email>&lt;<subst-in-string <subst-in-string "%body" " " "" /> @ "@<span class="legacy">XYZ-</span>" />&gt;</set-var-x></define-tag>

<define-tag rrdworld endtag=required>
<preserve icon type rwv_name rwv_author rwv_description rwv_homepage rwv_year rwv_month rwv_license rwv_livesite rwv_email/>
<set-var %attributes />
%body
<subst-in-var rwv_year " " ""/>
<subst-in-var rwv_month " " ""/>
<div class="rrdworld">
<if <get-var icon/> <img align="right" src="<subst-in-string <get-var icon/> " " "" />"/> />
<get-var rwv_name/>
<div class="who"><get-var rwv_author/> <get-var rwv_email/> | Date: <get-var rwv_year/><get-var rwv_month/> | <get-var rwv_license/></div>
<div class="desc">
<get-var rwv_description/>
<get-var rwv_homepage/><get-var rwv_livesite/>
</div>
</div>
<restore icon type rwv_name rwv_author rwv_description rwv_homepage rwv_year rwv_month rwv_license rwv_livesite rwv_email/>
</define-tag>

<define-tag gallery endtag=required>
<preserve image rwv_title rwv_author rwv_description rwv_year rwv_month rwv_livesite rwv_email/>
<set-var %attributes />
%body
<subst-in-var rwv_year " " ""/>
<subst-in-var rwv_month " " ""/>
<div class="gallery">
<get-var rwv_title/>
<div class="image"><img src="<subst-in-string <get-var image/> " " "" />"/></div>
<div class="caption"><get-var rwv_description/> -- <get-var rwv_author/> <get-var rwv_email/>, <get-var rwv_year/><get-var rwv_month/> <get-var rwv_livesite/></div>
</div>
<restore image rwv_title rwv_author rwv_description rwv_year rwv_month rwv_livesite rwv_email/>
</define-tag>


<define-tag lastchange>
<perl>
use POSIX qw(strftime); 
use POSIX qw(locale_h); 
  setlocale(LC_TIME,"de");
  my $x_de = strftime "%e. %B %Y", localtime("$(WML_SRC_TIME)"); 
  setlocale(LC_TIME,"en_US");
  my $x_en = strftime "%B %e, %Y", localtime("$(WML_SRC_TIME)"); 
  $x_de=~ s/\s/&nbsp;/g; 
  $x_en=~ s/\s/&nbsp;/g; 
</perl>
<en>
<perl>  
  print $x_en;
</perl>
</en>
<de>
<perl>
  print $x_de;
</perl>
</de>
</define-tag>

<define-tag picture endtag=required>
<div class="pic"><img  src="%body" align=left/></div>
</define-tag>



# vi: ft=wml
