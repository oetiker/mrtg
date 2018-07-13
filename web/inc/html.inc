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
<h2*>%body</h2*>
</define-tag>

<define-tag h3 whitespace=delete endtag=required>
<h3*>%body</h3*>
</define-tag>
