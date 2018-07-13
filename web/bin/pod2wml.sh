pod2wml (){
 base=$1
 [ -z "$descr" ] && descr=$base
 [ -z "$menu" ] && menu=$descr
 pod2html <$base.pod >$base.html
#Thing.pod Thing.html
# pod2html-5.8.8 --infile=$base.pod --outfile=$base.pre --noindex --htmlroot='$(ROOT)' --podroot=$SITEROOT --podpath=$PODPATH
# $SITEROOT/bin/fix-pod2html.pl $base.pre | $SITEROOT/bin/fix-hrefs.pl >$base.html
 echo "<nav:but ${sect}_$base      \"$menu\" 		$base/>" >>navbar.inc
 printf "<dt><a href=\"$base.en.html\">" >>index.inc
 grep -i $base $base.pod |fgrep ' - '|head -1|sed 's| - |</a></dt><dd>|' >>index.inc 
 echo "</dd>" >>index.inc
 echo "<page page=\"${sect}_$base\"" > $base.wml
 perl-5.8.8 -0777 -n -e 's|E<lt>|<|g;s|E<gt>|>|g;m|=head1 AUTHO\S+\s*(.+)| && do {$a=$1;$a =~ s/>.*/>/; $e="no\@address.nowhere";$a=~ s/\s*<(.+?)>\s*,?// and $e=$1; $e=~ s/\s\S+\s/\@/;print "author=\"$a <$e>\"/>\n"}' $base.pod >>$base.wml
true <<'XXXX'
 perl-5.8.8 -0777 -n -e '
  s|.*?(<h1.+)</body>.*|$1|s;
  for($i=5;$i>0;$i--){
         $j=$i-1;
         s|(</?h)$j>|$1$i>|g
  };
  s|<h2.*?>.*?NAME.*?</h2>.*?<p.*?>\s*(.+?)\s*- .*?</p>|<h1>$1</h1>|s;
  s{<li></li>(.+?)(?=<li>|</?ul>|</?ol>)}{<li>$1</li>}sg;
  s|<dt><strong>\s*(.*?)</strong>\s*<dd>|<dt>$1</dt>\n<dd>|sg;
  s|<dd>\s*<p>\s*(.*?)\s*</p>\s*</dd>|<dd>$1</dd>|sg;
  s|<li>\s*<p>([^<]+?)</p>\s*</li>|<li>$1</li>|sg;
  s|<p>\s*</p>|\n|g;
  s|\n\s|\n|g;
  s|\s*</pre>\s*<pre>\s*|\n\n|g;
  s|(\S)</pre>|$1\n</pre>|g;
  s|<pre>(.+?)</pre>|<protect><pre>$1</pre></protect>|gs;
#  s|<strong>\s*(.+?)\s*</strong><br />\s+</dt>|$1</dt>\n|g;
  s|<hr />\s*(<h\d>)|$1|g;
  s|<dd>\s*</dd>||gs;
  s|<a href=".*?/website|<a href="\$(ROOT)|g; 
  s|(<h2><a.*?>)\s*(\S)(.+?)\s*(</a></h2>)|$1$2\L$3\E$4|g;
  print 
 ' $base.html >>$base.wml
# rm $base.html
 perl-5.8.8 -i~ -0777 -p -e 's|</dd>\s*<pre(.*?)</pre>\s*<dd>|</dd><dd><pre$1</pre></dd><dd>|sg' $base.wml
XXXX
 perl-5.8.8 -0777 -n -e '
  s|<h2 id="NAME">.+?TENT">\s*<p>.*?\s-\s(.+?)</p>\s*</div>|<h1 id="NAME">$1</h1>|s;
#  s|</p>\s*<dt>|</p></dd>\n<dt>|sg;
#  s|</pre>\s*<dt>|</pre></dd>\n<dt>|sg;
  s|<pre>(.+?)</pre>|<protect><pre>$1</pre></protect>|gs;
#  s|.*?(<h1.+)</body>.*|$1|s;
#  for($i=5;$i>0;$i--){
#         $j=$i-1;
#         s|(</?h)$j>|$1$i>|g
#  };
#  s{http://search.cpan.org/perldoc\?(cfgmaker|indexmaker|mrtg-.+?)"}{\$(ROOT)/doc/$1.en.html"}g;
#  s|<h2.*?>.*?NAME.*?</h2>.*?<p.*?>\s*(.+?)\s*- .*?</p>|<h1>$1</h1>|s;

  print 
 ' $base.html >>$base.wml
# rm $base.html
 rm $base.html
# $base.pre
 descr=""
}
