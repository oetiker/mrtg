
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

for pod in  mrtg.pod mrtg-unix-guide.pod mrtg-nt-guide.pod mrtg-nw-guide.pod mrtg-reference.pod cfgmaker.pod indexmaker.pod mrtg-contrib.pod mrtg-faq.pod mrtg-ipv6.pod mrtg-logfile.pod mrtg-mibhelp.pod mrtg-rrd.pod mrtg-webserver.pod; do
 base=`echo $pod |sed 's,.pod,,'` 
 echo $base
 cat  $src/doc/$pod > $base.pod
 pod2descr $base
 pod2wml $base
done

