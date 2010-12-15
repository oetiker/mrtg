PERL = perl
.SUFFIXES: .gif .pl
.SILENT:
LIB = ..
OPTIONS = -Tw

GIFS =  sample11.gif sample12.gif sample13.gif sample14.gif \
		sample15.gif sample16.gif \
		sample21.gif \
		sample31.gif \
		sample41.gif sample42.gif\
		sample51.gif sample52.gif sample53.gif sample54.gif \
		sample61.gif sample62.gif \
		sample91.gif sample92.gif sample93.gif

all: $(GIFS)

.pl.gif:
	$(PERL) $(OPTIONS) -I$(LIB) $<

clean:
	rm -f $(GIFS)

test:
	$(PERL) $(OPTIONS) -I$(LIB) -M$(MODULE) sample91.pl

# Dependencies

sample14.gif: logo.gif
sample42.gif: sample42.dat
sample54.gif: sample54.dat
