pod2wml (){
 base=$1
 [ -z "$descr" ] && descr=$base
 [ -z "$menu" ] && menu=$descr
 pod2html --infile=$base.pod --outfile=$base.pre --noindex --htmlroot='$(ROOT)' --podroot=$SITEROOT --podpath=$PODPATH
 $SITEROOT/bin/fix-pod2html.pl $base.pre | $SITEROOT/bin/fix-hrefs.pl >$base.html
 echo "<nav:but ${sect}_$base      \"$menu\" 		$base/>" >>navbar.inc
 printf "<dt><a href=\"$base.en.html\">" >>index.inc
 grep -i $base $base.pod |fgrep ' - '|head -1|sed 's| - |</a></dt><dd>|' >>index.inc 
 echo "</dd>" >>index.inc
 echo "<page page=\"${sect}_$base\"" > $base.wml
 perl -0777 -n -e 's|E<lt>|<|g;s|E<gt>|>|g;m|=head1 AUTHO\S+\s*(.+)| && do {$a=$1;$a =~ s/>.*/>/; $e="no\@address.nowhere";$a=~ s/\s*<(.+?)>\s*,?// and $e=$1; $e=~ s/\s\S+\s/\@/;print "author=\"$a <$e>\"/>\n"}' $base.pod >>$base.wml
 # perl -0777 -n -e 's|.*?(<h1.+)</body>.*|$1|s;for($i=5;$i>0;$i--){$j=$i-1;s|(</?h)$j>|$1$i>|g}; s|<h2><a name="name">NAME</a></h2>.*?<p>(.+?) - .*?</p>|<h1>$1</h1>|s;s|<p>\s*</p>||g;s|<hr.*?>||g;s|</pre>\s*<pre>|\n|g;s|<br\s*/>\s*</dt>|</dt>|g;s|</dd>\s*<dd>||g;print ' $base.html >>$base.wml
 perl -0777 -n -e '
  s|.*?(<h1.+)</body>.*|$1|s;
  for($i=5;$i>0;$i--){
         $j=$i-1;
         s|(</?h)$j>|$1$i>|g
  };
  s|<h2.*?>.*?NAME.*?</h2>.*?<p.*?>\s*(.+?)\s*- .*?</p>|<h1>$1</h1>|s;
  s{<li></li>(.+?)(?=<li>|</?ul>|</?ol>)}{<li>$1</li>}sg;
  s|<p>\s*</p>|\n|g;
  s|\n\s|\n|g;
  s|\s*</pre>\s*<pre>\s*|\n\n|g;
  s|(\S)</pre>|$1\n</pre>|g;
  s|<pre>(.+?)</pre>|<protect><pre>$1</pre></protect>|gs;
  s|<strong>\s*(.+?)\s*</strong><br />\s+</dt>|$1</dt>\n|g;
  s|<hr />\s*<h2>|<h2>|g;
  s|<dd>\s*</dd>||gs;
  s|<a href=".*?/website|<a href="\$(ROOT)|g; 
  s|(<h2><a.*?>)\s*(\S)(.+?)\s*(</a></h2>)|$1$2\L$3\E$4|g;
  print 
 ' $base.html >>$base.wml
# rm $base.html
 perl -i~ -0777 -p -e 's|</dd>\s*<pre(.*?)</pre>\s*<dd>|</dd><dd><pre$1</pre></dd><dd>|sg' $base.wml
 rm $base.html $base.pre
 descr=""
}
