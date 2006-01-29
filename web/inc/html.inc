<define-tag h1 whitespace=delete endtag=required>
<preserve subtitle />
<set-var %attributes />
<h1*>%body</h1*>
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
