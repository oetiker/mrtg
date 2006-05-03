# 
#

# $Id: Makefile,v 1.1.1.1 2002/02/26 10:16:30 oetiker Exp $
# $Source: /home/oetiker/data/cvs-repo/AABM-mrtg/contrib/GetSNMPLinesUP/Makefile,v $
# $Log: Makefile,v $
# Revision 1.1.1.1  2002/02/26 10:16:30  oetiker
# Intial Import
#

ADMINDIR=/home/mrtg/bin

# RCSFILES
CI = -ci
CO = -co
COFLAGS = -l

CC = gcc
CFLAGS = -O
LIBS = -lresolv -l44bsd

.c.o:
	$(CC) $(CFLAGS) -c $*.c

TARGETS = 	ModemTable.dial-machine

PROGS =		GetSNMPLinesUP.pl

RCSFILES = $(TARGETS) $(PROGS)

all: install

checkin:
	make clean
	$(CI) $(RCSFILES)
	$(CI) -u Makefile

checkout:
	$(CO) $(COFLAGS) $(RCSFILES)
	$(CO) -l Makefile

linux:
	make CFLAGS="-O -DLINUX" LIBS="" all

install:	$(PROGS) $(TARGETS)
	install -g staff -m 0644 -o root $(TARGETS) $(ADMINDIR)
	install -g staff -m 0755 -o root $(PROGS) $(ADMINDIR)

clean: 
	/bin/rm -f *~ *.o ,* core tmp*

