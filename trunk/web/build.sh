#!/bin/sh
PERL5LIB=/home/oetiker/lib/fake-perl/
SITEROOT=`pwd`
PODPATH=`ls */build.sh | sed -e 's|/.*||g' | perl -0777 -e 'print join ":", map {"$_"} split /\n/, <>'`
export PERL5LIB SITEROOT PODPATH
rm */pod*tmp
for x in `ls */build.sh | sed 's|/.*||g'`; do
  echo '****' $x '****'
  (cd $x;./build.sh)
done


