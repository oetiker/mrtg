#################################################################
# Makefile for mrtg ...
#################################################################
# this is to fix IRIX who prefers csh
SHELL=/bin/sh
# GD_INCLUDE 
# The path to the include files for the gd graphics library.
#GD_INCLUDE=/usr/local/include/gd
GD_INCLUDE=gd1.2

# GD_LIB
# The path to the gd graphics library: libgd.a
#GD_LIB=/usr/local/lib
GD_LIB=gd1.2

# Where is perl 5 on this machine
# PERL=/usr/local/bin/perl
PERL=/usr/local/gnu/bin/perl5


# CC
# C compiler used to compile rateup. gcc works for me.
# cc from SparcWorks is OK as well
CC=gcc
#CC=cc
# CFLAGS
# Enter '-g' to include debugging info, or '-O2' to optimize
# for gcc
CFLAGS=-g -O -Wall

# for sparcworks
#CFLAGS=-g


########################### End of constants

all:
	@echo  ""
	@echo  ""
	@echo  "INSTRUCTIONS"
	@echo  "------------"
	@echo  "Look in 'readme.html' for full instructions on installing mrtg."
	@echo  "To compile rateup, the C program that accelerates mrtg,"
	@echo  "you will first need to compile the gd graphics library by"
	@echo  "Thomas Boutell (see http://www.boutell.com/gd/)"
	@echo  ""
	@echo  "Once you have compiled the gd library,"
	@echo  "edit 'Makefile' to reflect the paths to the gd"
	@echo  "header files (GD_INCLUDE) and the gd library file (GD_LIB),"
	@echo  "and to your perl 5 binary"
	@echo  ""
	@echo  "* To compile rateup, then type 'make rateup'."
	@echo  "* Do a 'make substitute' to fix the perl5 pointers in the scripts"
	@echo  ""
	@echo  "And now you should realy read the docs!"
	@echo  ""
	@echo  ""

rateup: rateup.c
	$(CC) $(CFLAGS) rateup.c -I$(GD_INCLUDE) -L$(GD_LIB) -lgd -lm -o rateup

PERLFILES = mrtg cfgmaker indexmaker convert

substitute:
	$(PERL) -pi -e 's@^#\!/.*@#!$(PERL)@' $(PERLFILES)


#################################################################
# Private Parts :-)
#################################################################

NUMBER = 2.5.1
VERSION = mrtg-$(NUMBER)

TAR = tar
ZIP = zip
TARCREATE = cvzf
FILES = $(VERSION)/BER.pm \
	$(VERSION)/COPYING \
	$(VERSION)/COPYRIGHT \
	$(VERSION)/Changes \
	$(VERSION)/Contributors \
	$(VERSION)/INSTALL \
	$(VERSION)/Makefile \
	$(VERSION)/Todo \
	$(VERSION)/SNMP_Session.pm \
	$(VERSION)/cfgmaker \
	$(VERSION)/convert \
	$(VERSION)/indexmaker \
	$(VERSION)/mrtg \
	$(VERSION)/mrtg-l.gif \
	$(VERSION)/mrtg-m.gif \
	$(VERSION)/mrtg-r.gif \
	$(VERSION)/mrtg-ti.gif \
	$(VERSION)/mrtg.cfg-dist \
	$(VERSION)/rateup.c \
	$(VERSION)/readme.html \
	$(VERSION)/readme.txt \
	$(VERSION)/contrib \
	$(VERSION)/SNMP_Session.pm-for-perl5.001 \
	$(VERSION)/BER.pm-for-perl5.001 \
	$(VERSION)/mibhelp.txt \
	$(VERSION)/htaccess-dist \
	$(VERSION)/README.logfile-format

ARCHIVE=$(VERSION).tar.gz
ZIPARC=$(VERSION).zip

tar:
	lynx readme.html -dump > readme.txt
	cd ..;\
	ln -s mrtg $(VERSION);\
	$(TAR) $(TARCREATE) $(VERSION)/$(ARCHIVE) $(FILES);\
	$(TAR) $(TARCREATE) $(VERSION)/rateup-sol251-$(NUMBER).tar.gz $(VERSION)/rateup;\
	$(ZIP) -r $(VERSION)/$(ZIPARC) $(FILES);\
	$(ZIP) $(VERSION)/rateup-win32-$(NUMBER).zip $(VERSION)/rateup.exe;\
	rm $(VERSION)
