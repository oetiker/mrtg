##################################################################
# $Id: Makefile,v 1.6 1997/02/28 17:32:48 pwo Exp $
# mrtg-ping-probe release $Name: Release_1_6_0 $
#
# Copyright (c) 1997 by Peter W. Osel <pwo@guug.de>, Cupertino.
# All Rights Reserved.
#
# See the file COPYRIGHT in the distribution for the exact terms.
#
##################################################################
# Makefile for mrtg-ping-probe
##################################################################

all:	man

POD =	mrtg-ping-probe
MAN =	$(POD).1
HTML =	$(POD).html
TEX =	$(POD).tex

FILES = COPYING COPYRIGHT INSTALL Makefile NEWS README \
	check-ping-fmt mrtg-ping-cfg mrtg-ping-probe mrtg.cfg-ping

man: $(MAN)
$(MAN):	$(POD)
	pod2man $(POD) > $(MAN)

html: $(HTML)
$(HTML): $(POD)
	pod2html $(POD) > $(HTML)

tex: $(TEX)
$(TEX):	$(POD)
	pod2latex $(POD) > $(TEX)

shar: mrtg-ping-probe.shar.01
mrtg-ping-probe.shar.01: $(FILES)
	shar -n mrtg-ping-probe -a -z -c -o mrtg-ping-probe.shar $(FILES)

clean:
	rm -f $(MAN) $(HTML) $(TEX)

realclean:	clean

distclean:	realclean
