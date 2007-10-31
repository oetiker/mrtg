<define-tag h1 whitespace=delete endtag=required>
<preserve subtitle />
<set-var %attributes />
{#H1#:<h1*>%body</h1*>:#H1#}
{#H1_FLAT#:<: $x = <<kjhasdflkjhasdf;
%body
kjhasdflkjhasdf
$x =~ s/\\n/ /g; print $x; :>:#H1_FLAT#}
<if <get-var title_is_set /> ""
   {#Title#:{#H1_FLAT#}:#Title#}
/>
<restore subtitle />
</define-tag>

<define-tag title whitespace=delete endtag=required>
<set-var title_is_set=1/>
{#!Title#:<: $_ = <<kjhasdflkjhasdf;
%body
kjhasdflkjhasdf
s/\\n/ /g; print :>:#Title#}
</define-tag>

<define-tag h2 whitespace=delete endtag=required>
<perl>
if ( $addcnt++ == 3 ) {
print <<'GOOGLEAD';
<div>
<script type="text/javascript"><!--
google_ad_client = "pub-8135238818549668";
google_ad_width = 300;
google_ad_height = 250;
google_ad_format = "300x250_as";
google_ad_type = "text_image";
google_ad_channel = "3710326600";
google_color_border = "ffffff";
google_color_bg = "ffffff";
google_color_link = "345d98";
google_color_url = "000000";
google_color_text = "000000";
//--></script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>
GOOGLEAD
}
</perl>

<h3*>%body</h3*>
</define-tag>
<define-tag h3 whitespace=delete endtag=required>
<perl>
if ( $addcnt++ == 2 ) {
print <<'GOOGLEAD';
<div>
<script type="text/javascript"><!--
google_ad_client = "pub-8135238818549668";
google_ad_width = 300;
google_ad_height = 250;
google_ad_format = "300x250_as";
google_ad_type = "text_image";
google_ad_channel = "3710326600";
google_color_border = "ffffff";
google_color_bg = "ffffff";
google_color_link = "345d98";
google_color_url = "000000";
google_color_text = "000000";
//--></script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>
GOOGLEAD
}
</perl>
<h3*>%body</h3*>
</define-tag>
