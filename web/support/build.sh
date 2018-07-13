#!/bin/sh
sect=doc
src=/home/oetiker/checkouts/mrtg/src/
. ../bin/pod2wml.sh

pod2descr() {
	pod=$1.pod
        descr=`egrep "$1 *- " $pod|head -1|sed 's/.*- //'`  
        menu=`egrep "$1 *- " $pod|head -1|sed 's/ -.*//'`     
}


# build probe list
rm -f navbar.inc
rm -f index.inc

for pod in  mrtg-forum.pod; do
 base=`echo $pod |sed 's,.pod,,'` 
 echo $base
 cat  $src/doc/$pod > $base.pod
 pod2descr $base
 pod2wml $base
done

mv mrtg-forum.wml index.wml
