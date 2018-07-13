#!/bin/sh
perl -n -e 's/Tobi//;s/\s*[&+]\s*//;s/\s+and\s+//; /^From:\s*(\S+\s\S+)/i && do { $x=$1; $x =~ s/\s*<.+//;$x =~ s/"//g; $x=~ s/\s*location\s*$//; print "$x;\n"}' /home/oetiker/checkouts/mrtg/src/CHANGES | sort -u >contrib.inc
