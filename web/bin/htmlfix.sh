#! /bin/sh
case $1 in
*.html)
#   tidy -latin1 -wrap 0 -q -asxhtml $1  >$1.fixed  2>$1.report
#   TIDY_RET=$?
   exit 0
   TIDY_RET=0
   perl -i -0777 -p -e 's/^\s*//;s{="mailto:(oetiker|tobi|tobias)@(oetiker.ch|ee.ethz.ch)"}{="http://tobi.oetiker.ch/"}g;s{="mailto:(\S*?)\@(\S*?)"}{="mailto:$1@..delete..this..$2"}g' $1.fixed
   # yes, beleive it or not IE chockes on propper xhtml pages ... sigh
   perl -i -0777 -p -e 's/^\s*<\?xml.+?\?>\s*//;'  $1.fixed
   if [ $TIDY_RET != 0 ]; then
        echo Parsing: $1
        egrep -v "^(HTML Tidy|$1:|To learn|Please send|HTML and CSS|Lobby your)" $1.report
        rm $1.report
        name=`basename $1 .html`
        name=`basename $name .en`
        name=`basename $name .de`
        touch -m -t 198001010000 $name.*.html
        exit 1
   fi
   mv $1.fixed $1
   rm $1.report
;;
esac
