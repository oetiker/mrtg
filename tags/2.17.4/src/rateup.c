/*
 MRTG 2.17.4  -- Rateup
 *********************

 Rateup is a fast add-on to the great MRTG Traffic monitor.  It makes
 the database file updates much faster, and creates the graphic image
 files, ready for processing by PPMTOGIF.  It also reduces memory
 requirements by a factor of 10, and increases the speed of updates
 by a factor of at least 10.  This makes it feasible to run mrtg
 every 5 minutes.

 rateup attempts to compensate for missed updates by repeating the last
 sample, and also tries to catch bad update times.  The .log file stores
 real history every five minutes for 31 hours, then 'compresses' the 
 history into 30 minute samples for a week, then 2-hour samples for
 31 days, then daily samples for two years.  This ensures that the
 log files don't grow in size.

 The log files are a slightly different format, but convert.perl
 will fix that for you.

 Enjoy!
 Dave Rand
 dlr@bungi.com

 04/26/99 - There was some compilation bug under Watcom 10.6
            which was fixed when recompiled with VC++ 6.0
			Alexandre Steinberg
			steinberg@base.com.br

*/

#include <stdlib.h>
#include <string.h>
/* VC++ does not have unistd.h */
#ifndef WIN32
#ifndef NETWARE
#include "../config.h"
#endif
#include <unistd.h>
#endif
#include <limits.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <ctype.h>
#ifndef GFORM_GD
#define GFORM_GD gdImagePng
#endif

/* BSD* does not have/need malloc.h */
#if !defined(bsdi) && !defined(__FreeBSD__) && !defined(__OpenBSD__) && !defined(__APPLE__)
#include <malloc.h>
#endif

/* MSVCRT.DLL does not know %ll in printf */
#ifdef __MINGW32_VERSION
#define LLD "%I64d"
#define LLD_FORMAT "I64d"
#endif

#ifdef __EMX__			/* OS/2 */
#define strtoll _strtoll
#define LLD "%Ld"		/* EMX lib use %Ld for long long */
#define LLD_FORMAT "Ld"
#endif

#ifndef LLD
#define  LLD "%lld"
#define  LLD_FORMAT "lld"
#endif


/* WATCOM C/C++ 10.6 under Win95/NT */
/* VC++ 6.0 under Win95/NT */
#if defined(__WATCOMC__) || defined(WIN32)
#include <string.h>
#include <sys/types.h>
#include <direct.h>
#include <io.h>
#endif

#include <gd.h>
#include <gdfonts.h>

char *VERSION = "2.17.4";
char *program, *router, *routerpath;
int histvalid;

/* Options */
short options = 0;
#define OPTION_WITHZEROES	0x0001	/* withzeros */
#define OPTION_UNKNASZERO	0x0002	/* unknaszero */
#define OPTION_TRANSPARENT	0x0004	/* transparent */
#define OPTION_DORELPERCENT	0x0008	/* dorelpercent */
#define OPTION_NOBORDER		0x0010	/* noborder */
#define OPTION_NOARROW		0x0020	/* noarrow */
#define OPTION_NO_I		0x0040	/* ignore 'I' (first) variable */
#define OPTION_NO_O		0x0080	/* ignore 'O' (second) variable */
#define OPTION_PRINTROUTER	0x0200	/* show title in graph */
#define OPTION_LOGGRAPH		0x0400	/* Use a logarithmic Y axis */
#define OPTION_MEANOVER		0x0800	/* max Y = mean-above-the-mean */
#define OPTION_EXPGRAPH		0x1000	/* exponential scale (opposite of logscale) */

time_t NOW;

/* jpt, april 2006 : added 3 lines for date & time logging */
struct tm * stLocal;
time_t timestamp;
char bufftime[32];

char *short_si_def[] = { "", "k", "M", "G", "T" };
int kMGnumber = 4;
char **short_si = short_si_def;
char *longup = NULL;
char *shortup = NULL;
char *pngtitle = NULL;
char *rtimezone = NULL;
char weekformat = 'V';		/* strftime() fmt char for week #  */

#define DAY_COUNT (600)		/* 400 samples is 33.33 hours */
#define DAY_SAMPLE (5*60)	/* Sample every 5 minutes */
#define WEEK_COUNT (600)	/* 400 samples is 8.33 days */
#define WEEK_SAMPLE (30*60)	/* Sample every 30 minutes */
#define MONTH_COUNT (600)	/* 400 samples is 33.33 days */
#define MONTH_SAMPLE (2*60*60)	/* Sample every 2 hours */
#define YEAR_COUNT  (2 * 366)	/* 1 sample / day, 366 days, 2 years */
#define YEAR_SAMPLE (24*60*60)	/* Sample every 24 hours */

/* One 'rounding error' per sample period, so add 4 to total and for 
   good mesure we take 10 :-) */
#define MAX_HISTORY (DAY_COUNT+WEEK_COUNT+MONTH_COUNT+YEAR_COUNT+10)

/* These are the colors used for the variouse parts of the graph */
/* the format is Red,Green,Blue */

#define c_blank 245,245,245
#define c_light 194,194,194
#define c_dark 100,100,100
#define c_major 255,0,0
#define c_in    0,235,12
#define c_out   0,94,255
#define c_grid  0,0,0
#define c_inm   0,166,33
#define c_outm  255,0,255
#define c_outp  239,159,79

int col_in[3];
int col_out[3];
int col_inm[3];
int col_outm[3];
int col_outp[3];

long long kilo = (long long) 1000;
char *kMG = (char *) NULL;


#define MAXL	200		/* Maximum length of last in & out fields */


struct HISTORY
{
  time_t time;
  double in, out, percent, inmax, outmax;
}
 *history;
int Mh;

struct LAST
{
  time_t time;
  char in[MAXL], out[MAXL];
}
last;

#ifndef max
#define max(a,b) ((a) > (b) ? (a) : (b))
#endif
#ifndef min
#define min(a,b) ((a) < (b) ? (a) : (b))
#endif

/*

notes about the NEXT macro ....

* position n to the entry in the history array so that NOW is between
  history[n] and history[n+1]

* calculate the interval according to steptime and position of 
  now within the history array.

for debuging 

    fprintf (stderr,"%s, NOW: %8lu  ST: %4lu  N: %4u HTN: %8lu HTN+1: %8lu IV: %6.0f\n", \
            bufftime,now,steptime,n,history[n].time, history[n+1].time, interval);\

*/

#define NEXT(steptime) \
  inmax = outmax = avc = 0; \
  inr = outr = 0.0;\
  nextnow = now - steptime;\
  if (now == history[n].time && \
      n<histvalid && \
      nextnow == history[n+1].time) { \
    inr = (double) history[n].in;\
    outr = (double) history[n].out;\
    inmax = history[n].inmax;\
    outmax = history[n].outmax;\
    n++;\
  } else {\
    if (now > history[n].time) {\
      fprintf(stderr,"%s, ERROR: Rateup is trying to read ahead of the available data\n" ,bufftime);\
    } else {\
      while (now <= history[n+1].time && n < histvalid){n++;}\
      do {\
	if (now >= history[n].time) {\
	  if (nextnow <= history[n+1].time) {\
	    interval = history[n].time - history[n+1].time;\
	  } else {\
	    interval = history[n].time - nextnow;\
	  }\
	} else {\
	  if (nextnow > history[n+1].time) {\
	    interval = steptime;\
	  } else {\
	    interval = now - history[n+1].time;\
	  }\
	}\
	inr  += (double) history[n].in * interval;\
	outr += (double) history[n].out * interval;\
	avc += interval;\
       inmax =  (long long) max(inmax, history[n].inmax);\
       outmax = (long long) max(outmax,history[n].outmax);\
	if (nextnow <= history[n+1].time) n++; else break;\
      } while (n < histvalid && nextnow < history[n].time);\
\
      if (avc != steptime) {\
       fprintf(stderr,"%s, ERROR: StepTime does not match Avc %8" LLD_FORMAT ". Please Report this.\n", bufftime, avc);\
      }\
\
      inr /= avc; outr /= avc;\
    }\
  }

static double logscale(double y, double maxy)
{
     y = (y * (maxy - 1) / maxy) + 1;
     y = log(y) / log (maxy) * maxy;
     if (y < 0) return 0;
     if (y > maxy) return maxy;
     return y;
}

static double expscale(double y, double maxy)
{
    y = exp(y / maxy * log(maxy));
    return (y - 1) * maxy / (maxy - 1);
}

static void
image (file, maxvi, maxvo, maxx, maxy, xscale, yscale, growright, step, bits,
       ytics, yticsf, peak, currdatetimeformat, currdatetimepos)
     char *file;
     long long maxvi, maxvo;
     long maxx;
     long maxy, growright, step, bits;
     double xscale, yscale;
     int ytics;			/* number of tics on the y axis */
     double yticsf;		/* scale everything on the y axis with this factor */
     int peak;
     char *currdatetimeformat;
     int currdatetimepos;
{
  FILE *fo;
  char file_tmp[10240];
  int i, x, n, type;

  long long maxv;
  double origmaxvi, origmaxvo;
  long long maxs, avc, inmax, outmax;
  long long ytrmax;
  double y, lmx1, lmx2, mea1, mea2, temp;
  double inr, outr, muli = 1, interval;
  time_t now, onow, nextnow;
  struct tm tm2, *tm = &tm2;
  char **graph_label;
  char ylab[30];
  /* scaling helpers */
  long long maxv_q;
  long long valsamp, maxin, maxout, digits, digits1, maxpercent = 0;
  long long sca_ten, sca_hun;
  double nmax_q;
  double avmxin, avmxout, avin, avout, latestout = 0, latestin =
    0, nmax, avpercent = 0, latestpercent = 0;
  double nex_ten, nex_hun, nex_rnd;
  double sca_max_q, dummy;
  double percent;
  char *short_si_out;
  char currdatetimestr[256];
  time_t currdatetime;
  int currdatetimepos_x, currdatetimepos_y;
  
#define NO_TIMESTAMPSTR (0)
#define LU_CORNER (1)
#define RU_CORNER (2)
#define LL_CORNER (3)
#define RL_CORNER (4)


  struct HISTORY *lhist;
  /* ################################################# */
  /* Some general definitions for the graph generation */
#define XSIZE (long)((maxx*xscale)+100+((options & OPTION_DORELPERCENT) ? 1 : 0)*30)
#define YSIZE (long)((maxy*yscale)+35)
  /* position the graph */
#define ytr(y) (long)(maxy*yscale+14-((y)*yscale))
  /* translate x/y coord into graph coord */
#define xtr(x) (long)((growright) ? (maxx*xscale+81-((x)*xscale)) : (81+((x)*xscale)))
  /* ################################################# */



  /* GD LIB declarations */
  /* Declare the image */
  gdImagePtr graph, brush_out, brush_outm, brush_outp;
  /* Declare color indexes */
  int i_light, i_dark, i_blank, i_major, i_in, i_out, i_grid, i_inm, i_outm;
  int i_outp, i_outpg;
  /* Dotted style */
  int styleDotted[3];
  if ((graph_label = (char **) calloc (1, sizeof (char *) * maxx)) == NULL)
    {
      fprintf (stderr, "%s, Rateup ERROR: Out of memory in graph creation\n", bufftime);
      exit (1);
    }

  /* multiplicator for bits/bytes */
  if (bits) {
      muli = 8;
  }
  
  maxv = (long long) max (maxvi, maxvo);
  maxv *= (long long) muli;
  
  origmaxvi = maxvi < (long long) 0 ? -maxvi : maxvi;
  origmaxvo = maxvo < (long long) 0 ? -maxvo : maxvo;

  if (step > MONTH_SAMPLE)
    {
      type = 4;
      now = (long) (NOW / YEAR_SAMPLE) * YEAR_SAMPLE;

    }
  else if (step > WEEK_SAMPLE)
    {
      type = 3;
      now = (long) (NOW / MONTH_SAMPLE) * MONTH_SAMPLE;
    }
  else if (step > DAY_SAMPLE)
    {
      type = 2;
      now = (long) (NOW / WEEK_SAMPLE) * WEEK_SAMPLE;
    }
  else
    {
      type = 1;
      now = (long) (NOW / DAY_SAMPLE) * DAY_SAMPLE;
    }
  if ((lhist = calloc (1, sizeof (struct HISTORY) * maxx)) == NULL)
    {
      fprintf (stderr, "%s, Rateup ERROR: Out of memory in graph creation\n", bufftime);
      exit (1);
    }
  onow = now;
  avin = avout = avmxin = avmxout = 0.0;
  inmax = outmax = maxin = maxout = 0;
  valsamp = 0;
  for (maxs = 0, n = 0, x = 0; x < maxx; x++)
    {
      NEXT (step);
      /*scale with muli */
      inr *= muli;
      outr *= muli;
      inmax *= muli;
      outmax *= muli;
      /* ignore times when we have not sampled */
      if (inmax > 0 || outmax > 0 || inr > 0 || outr > 0
	  || (options & OPTION_WITHZEROES)) valsamp++;
      if (x == 0)
	{
	  latestin = inr;
	  latestout = outr;
	  if (outr)
	    {
	      latestpercent = inr * (double) 100. / outr;
	    }
	}
      avin += inr;
      avout += outr;
      avmxin += inmax;
      avmxout += outmax;

      if (peak)
	{
	  maxin = (long long) max (maxin, inmax);
	  maxout = (long long) max (maxout, outmax);
          if (!(options & OPTION_NO_I)){
   	     maxs = (long long) max (maxs, inmax);
          }
          if (!(options & OPTION_NO_O)){
  	     maxs = (long long) max (maxs, outmax);
          }
	}
      else
	{
	  maxin = (long long) max (maxin, inr);
	  maxout = (long long) max (maxout, outr);
          if (!(options & OPTION_NO_I)){
  	     maxs = (long long) max (maxs, inr);
          }
          if (!(options & OPTION_NO_O)){
  	     maxs = (long long) max (maxs, outr);
          }
	}
      if ((options & OPTION_DORELPERCENT) && outr)
	{
	  dummy = (double) 100. *inr / outr;
	  maxpercent = max (dummy, maxpercent);
	}
      now -= step;
    }
  if (options & OPTION_DORELPERCENT)
    {
      if (avout && valsamp)
	{
	  avpercent = (double) 100. *avin / avout;
	}
      else
	{
	  avpercent = 0;
	}
    }
  if (valsamp)
    {
      avin /= valsamp;
      avout /= valsamp;
      avmxin /= valsamp;
      avmxout /= valsamp;
    }

  printf ("" LLD "\n", (long long) (maxin / (long long) muli + .5));
  printf ("" LLD "\n", (long long) (maxout / (long long) muli + .5));
  if (options & OPTION_DORELPERCENT)
    {
      printf ("" LLD "\n", (long long) (maxpercent + .5));
    }
  printf ("" LLD "\n", (long long) (avin / (long long) muli + .5));
  printf ("" LLD "\n", (long long) (avout / (long long) muli + .5));
  if (options & OPTION_DORELPERCENT)
    {
      printf ("" LLD "\n", (long long) (avpercent + .5));
    }
  printf ("" LLD "\n", (long long) (latestin / (long long) muli + .5));
  printf ("" LLD "\n", (long long) (latestout / (long long) muli + .5));
  if (options & OPTION_DORELPERCENT)
    {
      printf ("" LLD "\n", (long long) (latestpercent + .5));
    }
  printf ("" LLD "\n", (long long) (avmxin / (long long) muli + .5));
  printf ("" LLD "\n", (long long) (avmxout / (long long) muli + .5));

  if (maxv < 0 || maxv < maxs)
    {
      maxv = maxs;
    }

  now = onow;

  if (maxv <= 0)
    maxv = 1;

  if (kMG)
    {
      if (short_si[0] != kMG)
        {
          short_si_out = kMG;
          kMGnumber = 0;
          while ((short_si_out = strchr (short_si_out, ',')) != NULL)
	    {
	      short_si_out++;
              kMGnumber++;
	    }
          short_si = calloc(kMGnumber + 1, sizeof(*short_si));
          short_si_out = kMG;
          for (kMGnumber = 0; ; kMGnumber++)
            {
              short_si[kMGnumber] = short_si_out;
             short_si_out = strchr(short_si_out, ',');
              if (short_si_out == NULL) break;
              short_si_out[0] = '\0';
              short_si_out++;
            }
        }
     }
  
  /* mangle the 0.25*maxv value so, that we get a number with either */
  /* one or two digits != 0 and these digits should be at the  */
  /* start of the number ... */

  /* the ceil compensates for rounding with small numbers */
  maxv_q = ceil ((double) maxv / (double) ytics);	/* int */

  digits = 0;
  {
    double number = (double) maxv_q;
    number *= yticsf;		/* we just want to scale the lables nothing else */

/*
       while (number/(double) kilo >= (double)kilo && digits<kMGnumber*3) {
*/
    /* yes this should be kilo, but then the log and pow bits below
       should be base 'kilo' as well and not base 10 */

    while (digits < (long long) kMGnumber * 3 &&
           (number >= (double) 1000 || short_si[digits / 3][0] == '-'))
      {
	number /= (double) 1000;
	digits += 3;
      }
    sca_max_q = (double) ((int) (((double) 100. * (double) number) /
				 (pow
				  ((double) 10.,
				   (double) (int) (log10 ((double) number))))
				 +
				 (double) 9.999) / (int) 10) / (double) 10 *
      (pow ((double) 10., (double) (int) (log10 ((double) number))));
  }

  short_si_out = short_si[min ((signed) (digits / 3), kMGnumber)];

  if (maxv_q * yticsf >= 1)
    {
      digits1 = log10 ((double) maxv_q * yticsf);
    }
  else
    {
      digits1 = 0;
    }

/*  sca_ten = maxv_q / pow(10.0,(double)digits); */
/*  sca_hun = maxv_q / pow(10.0,(double)digits-1); */
  sca_ten = (double) maxv_q *yticsf / pow (10.0, (double) digits1);
  sca_hun = (double) maxv_q *yticsf / pow (10.0, (double) digits1 - 1);
  nex_rnd = (sca_hun) * pow (10.0, (double) digits1 - 1);
  nex_ten = (sca_ten + 1) * pow (10.0, (double) digits1);
  nex_hun = (sca_hun + 1) * pow (10.0, (double) digits1 - 1);

/*  if (nex_ten <= (1.1 * maxv_q))  { */
  if (nex_ten <= (1.1 * maxv_q * yticsf))
    {
      nmax_q = nex_ten;
/*  } else if (maxv_q == nex_rnd) {  */
    }
  else if ((maxv_q * yticsf) == nex_rnd)
    {
      nmax_q = nex_rnd;
    }
  else
    {
      nmax_q = nex_hun;
    }

  sca_max_q = nmax_q / (pow (10.0, (double) ((int) (digits / 3)) * 3));
/*  nmax=sca_max_q*ytics*(pow((double)kilo,(double)((int)(digits1/3))));  */
  nmax =
    (sca_max_q / yticsf) * ytics *
    (pow ((double) kilo, (double) ((int) (digits / 3))));

  if (nmax < 1.)
    {
      nmax = 1.;
    }

  for (n = 0, x = 0; x < maxx; x++)
    {
      lhist[x].time = 0;
      graph_label[x] = NULL;
      /* this seesm to be necessary to work a round a bug in solaris
         where tm for complex TZ settings gets modified after the
         fact ... so we whisk the stuff away into our own memspace
         just in time */
      memcpy (tm, localtime (&history[n].time), sizeof (struct tm));
      switch (type)
	{
	default:
	case 1:
	  if (tm->tm_min < 5)
	    {
	      lhist[x].time |= 1;
	      if (tm->tm_hour == 0)
		lhist[x].time |= 2;
	    }
	  if ((tm->tm_min < 5) && (tm->tm_hour % 2 == 0))
	    {
	      if ((graph_label[x] = calloc (1, sizeof (char) * 4)) == NULL)
		{
		  fprintf (stderr,
			   "%s, Rateup ERROR: Out of memory in graph labeling\n", bufftime);
		  exit (0);
		}
	      else
		{
		  sprintf (graph_label[x], "%i", tm->tm_hour);
		}
	    }
	  break;
	case 2:
	  if (tm->tm_min < 30 && tm->tm_hour == 0)
	    {
	      lhist[x].time |= 1;
	      if (tm->tm_wday == 1)
		lhist[x].time |= 2;
	    }

	  /* fprintf(stderr,"%s, x: %i, min:%i, hour:%i day: %i\n",
	     bufftime,x,tm->tm_min,tm->tm_hour,tm->tm_wday); */
	  if ((tm->tm_min < 30) && (tm->tm_hour == 12))
	    {
	      if ((graph_label[x] = calloc (1, sizeof (char) * 5)) == NULL)
		{
		  fprintf (stderr,
			   "%s, Rateup ERROR: Out of memory in graph labeling\n", bufftime);
		  exit (0);
		}
	      else
		{
		  strftime (graph_label[x], 4, "%a", tm);
		}
	    }

	  break;
	case 3:
	  if (tm->tm_hour < 2)
	    {
	      if (tm->tm_wday == 1)
		lhist[x].time |= 1;
	      if (tm->tm_mday == 1)
		lhist[x].time |= 2;
	    }
	  /* label goes to thursday noon */

	  if ((tm->tm_hour > 10) && (tm->tm_hour <= 12) && (tm->tm_wday == 4))
	    {
	      if ((graph_label[x] = calloc (1, sizeof (char) * 16)) == NULL)
		{
		  fprintf (stderr,
			   "%s, Rateup ERROR: Out of memory in graph labeling\n", bufftime);
		  exit (0);
		}
	      else
		{
		  char fmtbuf[10];
		  sprintf (fmtbuf, "Week %%%c", weekformat);
		  strftime (graph_label[x], 8, fmtbuf, tm);
		}
	    }
	  break;
	case 4:
	  if (tm->tm_mday == 1)
	    lhist[x].time |= 1;
	  if (tm->tm_yday == 0)
	    lhist[x].time |= 2;


	  if (tm->tm_mday == 15)
	    {
	      if ((graph_label[x] = calloc (1, sizeof (char) * 5)) == NULL)
		{
		  fprintf (stderr,
			   "%s, Rateup Error: Out of memory in graph labeling\n", bufftime);
		  exit (0);
		}
	      else
		{
		  strftime (graph_label[x], 4, "%b", tm);
		}
	    }
	  break;
	}

      NEXT (step);

      /*scale with muli */
      inr *= muli;
      outr *= muli;
      inmax *= muli;
      outmax *= muli;


      y = ((double) inr / nmax) * maxy;
      if (y >= maxy)
	y = maxy;
      lhist[x].in = y;

      y = ((double) outr / nmax) * maxy;
      if (y >= maxy)
	y = maxy;
      lhist[x].out = y;

      y = ((double) inmax / nmax) * maxy;
      if (y >= maxy)
	y = maxy;
      lhist[x].inmax = y;

      y = ((double) outmax / nmax) * maxy;
      if (y >= maxy)
	y = maxy;
      lhist[x].outmax = y;

      if (options & OPTION_DORELPERCENT)
	{
	  if (outr != (long long) 0)
	    {
	      percent = (double) inr / (double) outr;
	    }
	  else
	    {
	      percent = (double) 0.;
	    }
	  if (percent > (double) 1)
	    percent = (double) 1.;
	  percent *= maxy;
	  lhist[x].percent = (long long) percent;
	}
      else
	{
	  lhist[x].percent = (long long) 0;
	}

      now -= step;
    }
  origmaxvi = (origmaxvi * muli / nmax ) * maxy;
  origmaxvo = (origmaxvo * muli / nmax ) * maxy;

  /* Log and second-mean scaling added by Benjamin Despres, 2004-10-13 */
  if (options & OPTION_MEANOVER)
    {
      lmx1 = lmx2 = mea1 = mea2 = temp = 0.0;
      for (x = 0; x < maxx; x++)
	{
	  if (lhist[x].in < 1.0)
	    lhist[x].in = 1.0;
	  if (lhist[x].out < 1.0)
	    lhist[x].out = 1.0;
	  if (lhist[x].inmax < 1.0)
	    lhist[x].inmax = 1.0;
	  if (lhist[x].outmax < 1.0)
	    lhist[x].outmax = 1.0;
	  if (lhist[x].in > lmx1)
	    lmx1 = lhist[x].in;
	  if (lhist[x].out > lmx1)
	    lmx1 = lhist[x].out;
	  if (lhist[x].inmax > lmx1)
	    lmx1 = lhist[x].inmax;
	  if (lhist[x].outmax > lmx1)
	    lmx1 = lhist[x].outmax;
	  mea1 +=
	    (lhist[x].in + lhist[x].out + lhist[x].inmax +
	     lhist[x].outmax) / 4.0;
	}
      if (origmaxvi < 1.0)
	origmaxvi = 1.0;
      if (origmaxvo < 1.0)
	origmaxvo = 1.0;

      mea1 /= (double) maxx;
	  for (x = 0; x < maxx; x++)
	    {
	      y =
		(lhist[x].in + lhist[x].out + lhist[x].inmax +
		 lhist[x].outmax) / 4.0;
	      if (y > mea1)
		{
		  mea2 += y;
		  temp += 1.0;
		}
	    }
	  mea2 /= temp;
	  for (x = 0; x < maxx; x++)
	    {
	      if (lhist[x].in > mea2)
		lhist[x].in = mea2;
	      if (lhist[x].out > mea2)
		lhist[x].out = mea2;
	      if (lhist[x].inmax > mea2)
		lhist[x].inmax = mea2;
	      if (lhist[x].outmax > mea2)
		lhist[x].outmax = mea2;
	    }
      for (x = 0; x < maxx; x++)
	{
	  if (lhist[x].in > lmx2)
	    lmx2 = lhist[x].in;
	  if (lhist[x].out > lmx2)
	    lmx2 = lhist[x].out;
	  if (lhist[x].inmax > lmx2)
	    lmx2 = lhist[x].inmax;
	  if (lhist[x].outmax > lmx2)
	    lmx2 = lhist[x].outmax;
	}
      if (lmx2 > 0.0)
	lmx2 = (lmx1 / lmx2);
      for (x = 0; x < maxx; x++)
	{
	  lhist[x].in *= lmx2;
	  lhist[x].out *= lmx2;
	  lhist[x].inmax *= lmx2;
	  lhist[x].outmax *= lmx2;
	}
      origmaxvi *= lmx2;
      origmaxvo *= lmx2;

      sca_max_q *= ((float) mea2 / (float) maxy);
    }
  else if (options & OPTION_LOGGRAPH)
    {
      for (x = 0; x < maxx; x++)
        {
          lhist[x].in = logscale (lhist[x].in, maxy);
          lhist[x].out = logscale (lhist[x].out, maxy);
          lhist[x].inmax = logscale (lhist[x].inmax, maxy);
          lhist[x].outmax = logscale (lhist[x].outmax, maxy);
        }
      origmaxvi = logscale (origmaxvi, maxy);
      origmaxvo = logscale (origmaxvo, maxy);
    }	/* end of primary log and second-mean scaling code (more below) */
  else if (options & OPTION_EXPGRAPH)
    {
      for (x = 0; x < maxx; x++)
        {
          lhist[x].in = expscale (lhist[x].in, maxy);
          lhist[x].out = expscale (lhist[x].out, maxy);
          lhist[x].inmax = expscale (lhist[x].inmax, maxy);
          lhist[x].outmax = expscale (lhist[x].outmax, maxy);
        }
      origmaxvi = expscale (origmaxvi, maxy);
      origmaxvo = expscale (origmaxvo, maxy);
    }

  /* the graph is made ten pixels higher to acomodate the x labels */
  graph = gdImageCreate (XSIZE, YSIZE);
  brush_out = gdImageCreate (1, 2);
  brush_outm = gdImageCreate (1, 2);
  brush_outp = gdImageCreate (1, 2);

  /* the first color allocated will be the background color. */
  i_blank = gdImageColorAllocate (graph, c_blank);
  i_light = gdImageColorAllocate (graph, c_light);
  i_dark = gdImageColorAllocate (graph, c_dark);

  if (options & OPTION_TRANSPARENT)
    {
      gdImageColorTransparent (graph, i_blank);
    }
  gdImageInterlace (graph, 1);

  /* do NOT delete the out variables. they are dummies, but the actual color
     allocation for the brush is essential */
  i_major = gdImageColorAllocate (graph, c_major);
  i_in = gdImageColorAllocate (graph, col_in[0], col_in[1], col_in[2]);
  i_out =
    gdImageColorAllocate (brush_out, col_out[0], col_out[1], col_out[2]);
  i_grid = gdImageColorAllocate (graph, c_grid);
  i_inm = gdImageColorAllocate (graph, col_inm[0], col_inm[1], col_inm[2]);
  i_outm =
    gdImageColorAllocate (brush_outm, col_outm[0], col_outm[1], col_outm[2]);
  i_outp =
    gdImageColorAllocate (brush_outp, col_outp[0], col_outp[1], col_outp[2]);
  i_outpg =
    gdImageColorAllocate (graph, col_outp[0], col_outp[1], col_outp[2]);

  /* draw the image border */
  if (!(options & OPTION_NOBORDER))
    {
      gdImageLine (graph, 0, 0, XSIZE - 1, 0, i_light);
      gdImageLine (graph, 1, 1, XSIZE - 2, 1, i_light);
      gdImageLine (graph, 0, 0, 0, YSIZE - 1, i_light);
      gdImageLine (graph, 1, 1, 1, YSIZE - 2, i_light);
      gdImageLine (graph, XSIZE - 1, 0, XSIZE - 1, YSIZE - 1, i_dark);
      gdImageLine (graph, 0, YSIZE - 1, XSIZE - 1, YSIZE - 1, i_dark);
      gdImageLine (graph, XSIZE - 2, 1, XSIZE - 2, YSIZE - 2, i_dark);
      gdImageLine (graph, 1, YSIZE - 2, XSIZE - 2, YSIZE - 2, i_dark);
    }

  /* draw the incoming traffic */
  if (!(options & OPTION_NO_I))
    {
      for (x = 0; x < maxx; x++)
	{
	  /* peak is always above average, we therefore only draw the upper part */
	  if (peak)
	    gdImageLine (graph, xtr (x), ytr (lhist[x].in),
			 xtr (x), ytr (lhist[x].inmax), i_inm);
#ifdef INCOMING_UNFILLED
	  gdImageLine (graph, xtr (x), ytr (lhist[x].in), xtr (x),
		       ytr (lhist[x + 1].in), i_in);
#else
	  gdImageLine (graph, xtr (x), ytr (0), xtr (x), ytr (lhist[x].in),
		       i_in);
	  /* draw the line a second time offset slightly. makes the graph
	   * look better if xscale is fractional */
	  gdImageLine (graph, xtr (x + 0.5), ytr (0), xtr (x + 0.5),
		       ytr (lhist[x].in), i_in);
#endif
	}
    }

  /* draw the percentage */
  if (options & OPTION_DORELPERCENT)
    {
      gdImageSetBrush (graph, brush_outp);
      for (x = 0; x < maxx - 1; x++)
	gdImageLine (graph, xtr (x), ytr (lhist[x].percent),
		     xtr (x + 1), ytr (lhist[x + 1].percent), gdBrushed);
    }

  /* draw the outgoing traffic */
  if (!(options & OPTION_NO_O))
    {
      gdImageSetBrush (graph, brush_outm);
      if (peak)
	for (x = 0; x < maxx - 1; x++)
	  gdImageLine (graph, xtr (x), ytr (lhist[x].outmax),
		       xtr (x + 1), ytr (lhist[x + 1].outmax), gdBrushed);
      gdImageSetBrush (graph, brush_out);
      for (x = 0; x < maxx - 1; x++)
	gdImageLine (graph, xtr (x), ytr (lhist[x].out),
		     xtr (x + 1), ytr (lhist[x + 1].out), gdBrushed);
    }

  /* print the graph title */
  if (pngtitle != NULL)
    {
      gdImageString (graph, gdFontSmall, 81, 1,
		     (unsigned char *) pngtitle, i_grid);
    }
  else
    {
      if (options & OPTION_PRINTROUTER)
	{
	  gdImageString (graph, gdFontSmall, 81, 1,
			 (unsigned char *) router, i_grid);
	}
    }

  /* draw the graph border */
  gdImageRectangle (graph, xtr (0), ytr (0), xtr (maxx), ytr (maxy), i_grid);

  /*create a dotted style for the grid lines */
  styleDotted[0] = i_grid;
  styleDotted[1] = gdTransparent;
  styleDotted[2] = gdTransparent;
  gdImageSetStyle (graph, styleDotted, 3);

  /* draw the horizontal grid */
  if ((longup == NULL) || (shortup == NULL))
    {
      if (!bits)
	{
	  longup = "Bytes per Second";
	  shortup = "Bytes/s";
	}
      else
	{
	  longup = "Bits per Second";
	  shortup = "Bits/s";
	}
    }
  if (maxy < gdFontSmall->w * 16)
    {
      gdImageStringUp (graph, gdFontSmall, 8,
		       ytr ((maxy - gdFontSmall->w * strlen (shortup)) / 2),
		       (unsigned char *) shortup, i_grid);
    }
  else
    {
      gdImageStringUp (graph, gdFontSmall, 8,
		       ytr ((maxy - gdFontSmall->w * strlen (longup)) / 2),
		       (unsigned char *) longup, i_grid);
    }

      for (i = 0; i <= ytics; i++)
	{

	  gdImageLine (graph, xtr (-2), ytr (i * maxy / ytics),
		       xtr (1), ytr (i * maxy / ytics), i_grid);

	  gdImageLine (graph, xtr (maxx + 2), ytr (i * maxy / ytics),
		       xtr (maxx - 1), ytr (i * maxy / ytics), i_grid);

	  gdImageLine (graph, xtr (0), ytr (i * maxy / ytics),
		       xtr (maxx), ytr (i * maxy / ytics), gdStyled);

/*
    	sprintf(ylab,"%6.1f %s",sca_max_q*i,short_si[digits/3]);
*/
/*    	sprintf(ylab,"%6.1f %s",sca_max_q*i*yticsf,short_si_out);  */
	  temp = sca_max_q * i;
	  if (options & OPTION_LOGGRAPH)
	     temp = expscale(maxy * i / ytics, maxy) * ytics * sca_max_q / maxy;
	  else if (options & OPTION_EXPGRAPH)
	     temp = logscale(maxy * i / ytics, maxy) * ytics * sca_max_q / maxy;
	  else
	     temp = sca_max_q * i;
	  sprintf (ylab, "%6.1f %s", temp, short_si_out);

/*        sprintf(ylab,"%6.1f %s",sca_max_q*i,short_si_out); */
	  gdImageString (graph, gdFontSmall, 23,
			 ytr (i * maxy / ytics + gdFontSmall->h / 2),
			 (unsigned char *) ylab, i_grid);

	  if (options & OPTION_DORELPERCENT)
	    {
	      /* sprintf(ylab,"% 6.1f%%",(float)25.*i); */
	      sprintf (ylab, "% 6.1f%%", (float) (temp / (sca_max_q * ytics) * 100));
	      gdImageString (graph, gdFontSmall, 77 + ((maxx) * xscale) + 1,
			     ytr (i * maxy / ytics + gdFontSmall->h / 2),
			     (unsigned char *) ylab, i_outpg);
	    }
	}

  /* draw vertical grid and horizontal labels */
  for (x = 0; x < maxx; x++)
    {
      if (lhist[x].time)
	{
	  gdImageLine (graph, xtr (x), ytr (-2), xtr (x), ytr (1), i_grid);
	  gdImageLine (graph, xtr (x), ytr (0), xtr (x), ytr (maxy),
		       gdStyled);
	}
      if (graph_label[x] != NULL)
	{
	  gdImageString (graph, gdFontSmall,
			 (xtr (x) - (strlen (graph_label[x]) *
				     gdFontSmall->w / 2)),
			 ytr (-4), (unsigned char *) graph_label[x], i_grid);
	  free (graph_label[x]);
	}
      if (lhist[x].time & 2)
	gdImageLine (graph, xtr (x), ytr (0), xtr (x), ytr (maxy), i_major);
    }

  ytrmax = ytr (origmaxvi);

  /* draw line at peak In value in i_major color */
  /* only draw the line if it's within the graph ... */
  if (ytr (maxy) < ytrmax)
    {
      styleDotted[0] = i_major;
      gdImageSetStyle (graph, styleDotted, 3);
      gdImageLine (graph, xtr (0), ytrmax, xtr (maxx), ytrmax, gdStyled);
    }

  /* draw line at peak Out value in i_major color */
  /* only draw the line if it's within the graph ... */
  ytrmax = ytr (origmaxvo);

  if (ytr (maxy) < ytrmax)
    {
      styleDotted[0] = i_major;
      gdImageSetStyle (graph, styleDotted, 3);
      gdImageLine (graph, xtr (0), ytrmax, xtr (maxx), ytrmax, gdStyled);
    }

  /* draw a red arrow a 0,0 */
  if (!(options & OPTION_NOARROW))
    {
      gdImageLine (graph, xtr (2), ytr (3), xtr (2), ytr (-3), i_major);
      gdImageLine (graph, xtr (1), ytr (3), xtr (1), ytr (-3), i_major);
      gdImageLine (graph, xtr (0), ytr (2), xtr (0), ytr (-2), i_major);
      gdImageLine (graph, xtr (-1), ytr (1), xtr (-1), ytr (-1), i_major);
      gdImageLine (graph, xtr (-2), ytr (1), xtr (-2), ytr (-1), i_major);
      gdImageLine (graph, xtr (-3), ytr (0), xtr (-3), ytr (0), i_major);
    }

  if (currdatetimepos > NO_TIMESTAMPSTR)
    {
      currdatetime = time (NULL);
      strftime (currdatetimestr, 250, currdatetimeformat,
		localtime (&currdatetime));
      switch (currdatetimepos)
	{
	case LL_CORNER:
	  currdatetimepos_x = 3;
	  currdatetimepos_y = YSIZE - gdFontSmall->h - 3;
	  break;
	case RL_CORNER:
	  currdatetimepos_x =
	    XSIZE - strlen (currdatetimestr) * gdFontSmall->w - 3;
	  currdatetimepos_y = YSIZE - gdFontSmall->h - 3;
	  break;
	case LU_CORNER:
	  currdatetimepos_x = 3;
	  currdatetimepos_y = 1;
	  break;
	case RU_CORNER:
	default:
	  currdatetimepos_x =
	    XSIZE - strlen (currdatetimestr) * gdFontSmall->w - 3;
	  currdatetimepos_y = 1;
	};
      gdImageString (graph, gdFontSmall,
		     currdatetimepos_x, currdatetimepos_y,
		     (unsigned char *)currdatetimestr, i_grid);
    }

  snprintf(file_tmp,1000,"%s.tmp_%lu",file,(unsigned long)getpid());

  if ((fo = fopen (file_tmp, "wb")) == NULL)
    {
      perror (program);
      fprintf (stderr, "%s, Rateup Error: Can't open %s for write\n", bufftime, file_tmp);
      exit (1);
    }
  GFORM_GD (graph, fo);
  fclose (fo);
  gdImageDestroy (graph);
  gdImageDestroy (brush_out);
  gdImageDestroy (brush_outm);
  gdImageDestroy (brush_outp);
  free (lhist);
  free (graph_label);
  if (kMG)
    free(short_si);


#ifdef WIN32
  /* got to remove the target under win32
     or rename will not work ... */
  unlink(file);  
#endif
  if (rename(file_tmp,file)){
      perror (program);
      fprintf (stderr, "%s, Rateup Error: Can't rename %s to %s\n", bufftime,file_tmp,file);
      exit (1);
  }


}


static double
diff (a, b)
     char *a, *b;
{
  char res[MAXL], *a1, *b1, *r1;
  int c, x, m;
  if (*a == '-' && *b == '-')
    {
      b1 = b + 1;
      b = a + 1;
      a = b1;
    }

  while (!isdigit ((int) *a))
    a++;
  while (!isdigit ((int) *b))
    b++;
  a1 = &a[strlen (a) - 1];
  m = max (strlen (a), strlen (b));
  r1 = &res[m + 1];
  for (b1 = res; b1 <= r1; b1++)
    *b1 = ' ';
  b1 = &b[strlen (b) - 1];
  r1[1] = 0;			/* Null terminate result */
  c = 0;
  for (x = 0; x < m; x++)
    {
      /* we want to avoid reading off the edge of the string */
      char save_a, save_b;
      save_a = (a1 >= a) ? *a1 : '0';
      save_b = (b1 >= b) ? *b1 : '0';
      *r1 = save_a - save_b - c + '0';
      if (*r1 < '0')
	{
	  *r1 += 10;
	  c = 1;
	}
      else if (*r1 > '9')
	{			/* 0 - 10 */
	  *r1 -= 10;
	  c = 1;
	}
      else
	{
	  c = 0;
	}
      a1--;
      b1--;
      r1--;
    }
  if (c)
    {
      r1 = &res[m + 1];
      for (x = 0; isdigit ((int) *r1) && x < m; x++, r1--)
	{
	  *r1 = ('9' - *r1 + c) + '0';
	  if (*r1 > '9')
	    {
	      *r1 -= 10;
	      c = 1;
	    }
	  else
	    {
	      c = 0;
	    }
	}
      return (-atof (res));
    }
  else
    return (atof (res));
}

static int
readhist (file)
     char *file;
{
  FILE *fi;
  int x, retcode = 0;
  char buf[256], tempform[50];
  struct HISTORY *hist;
  long long rd[5];
  time_t cur;
  long lasttime;

  sprintf (tempform, "%%ld %%%ds %%%ds\n", MAXL - 1, MAXL - 1);
  if ((fi = fopen (file, "r")) != NULL)
    {
      if (fscanf (fi, tempform, &lasttime, &last.in[0], &last.out[0]) != 3)
	{
	  fprintf (stderr, "%s, Read Error: File %s lin 1\n", bufftime, file);
	  retcode = 1;
	}
      last.time = lasttime;
      cur = last.time;
      x = histvalid = 0;
      hist = history;
      while (!feof (fi))
	{
	  fgets (buf, 256, fi);
	  if (sscanf (buf, "" LLD " " LLD " " LLD " " LLD " " LLD "",
		      &rd[0], &rd[1], &rd[2], &rd[3], &rd[4]) < 5)
	    {
	      rd[3] = rd[1];
	      rd[4] = rd[2];
	    }

/* we are long long now, so don't cut bit 8
	    for (i=0;i<=4;i++){
	      if (rd[i] & 0x80000000)
		rd[i] = 0;
	    }
*/

	  hist->time = rd[0];
	  hist->in = rd[1];
	  hist->out = rd[2];
	  hist->inmax = rd[3];
	  hist->outmax = rd[4];
	  if (hist->inmax < hist->in)
	    hist->inmax = hist->in;
	  if (hist->outmax < hist->out)
	    hist->outmax = hist->out;
	  if (hist->time > cur)
	    {
	      fprintf (stderr,
		       "%s, Rateup ERROR: %s found %s's log file was corrupt\n          or not in sorted order:\ntime: %lu.",
		       bufftime, program, router, (unsigned long) hist->time);
	      retcode = 2;
	      break;
	    }
	  cur = hist->time;
	  if (++x >= Mh)
	    {
	      struct HISTORY *lh;

	      Mh += MAX_HISTORY;
	      lh = realloc (history, (Mh + 1) * sizeof (struct HISTORY));
	      if (lh == NULL)
		{
		  fprintf (stderr,
			   "%s, Rateup WARNING: (pay attention to this)\nWARNING: %s found %s's log file had too many entries, data discarded\n",
			   bufftime, program, router);
		  break;
		}
	      hist = lh + (hist - history);
	      history = lh;
	    }
	  hist++;
	}
      histvalid = x;
      fclose (fi);
    }
  else
    {
      retcode = 1;
    }
  return (retcode);
}

static void
readfile ()
{
  char buf[128];
  int err, x;
  time_t now;
  struct HISTORY *hist;

  sprintf (buf, "%s.log", router);
  if ((err = readhist (buf)) != 0)
    {				/* Read of log file failed.  Try backup */
      fprintf (stderr,
	       "%s, Rateup WARNING: %s could not read the primary log file for %s\n",
	       bufftime, program, router);
      sprintf (buf, "%s.old", router);
      if ((err = readhist (buf)) != 0)
	{			/* Backup failed too. New file? */
	  fprintf (stderr,
		   "%s, Rateup WARNING: %s The backup log file for %s was invalid as well\n",
		   bufftime, program, router);
	  if (err == 2)
	    exit (1);

	  /* File does not exist - it must be created */
	  now = NOW - DAY_SAMPLE;
	  hist = history;
	  histvalid = DAY_COUNT + WEEK_COUNT + MONTH_COUNT + YEAR_COUNT - 1;
	  last.time = now;
	  /* calculating a diff does not make sense */
	  last.in[0] = 'x';
	  now /= DAY_SAMPLE;
	  now *= DAY_SAMPLE;
	  for (x = 0; x < DAY_COUNT; x++, hist++)
	    {
	      hist->time = now;
	      hist->in = hist->inmax = hist->out = hist->outmax = 0;
	      now -= DAY_SAMPLE;
	    }
	  now /= WEEK_SAMPLE;
	  now *= WEEK_SAMPLE;
	  for (x = 0; x < WEEK_COUNT; x++, hist++)
	    {
	      hist->time = now;
	      hist->in = hist->inmax = hist->out = hist->outmax = 0;
	      now -= WEEK_SAMPLE;
	    }
	  now /= MONTH_SAMPLE;
	  now *= MONTH_SAMPLE;
	  for (x = 0; x < MONTH_COUNT; x++, hist++)
	    {
	      hist->time = now;
	      hist->in = hist->inmax = hist->out = hist->outmax = 0;
	      now -= MONTH_SAMPLE;
	    }
	  now /= YEAR_SAMPLE;
	  now *= YEAR_SAMPLE;
	  for (x = 0; x < YEAR_COUNT; x++, hist++)
	    {
	      hist->time = now;
	      hist->in = hist->inmax = hist->out = hist->outmax = 0;
	      now -= YEAR_SAMPLE;
	    }
	}
    }
}

static void
update (in, out, abs_max, absupdate)
     char *in, *out;
     long long abs_max;
     int absupdate;
{
  FILE *fo;
  char buf[128], buf1[128], buf2[128];
  time_t now, nextnow, plannow;
  long long inrate, outrate;
  long long avc, inmax, outmax;
  double period, interval;
  int x, n, nout;
  struct HISTORY *lhist, *hist;
  double inr, outr;

  now = NOW;

  if (now < last.time)
    {
      fprintf (stderr,
	       "%s, Rateup ERROR: %s found that %s's log file time of %lu was greater than now (%lu)\nERROR: Let's not do the time warp, again. Logfile unchanged.\n",
	       bufftime, program, router, (unsigned long) last.time,
	       (unsigned long) now);
      return;
    }
  sprintf (buf, "%s.tmp_%lu", router,(unsigned long)getpid());
  sprintf (buf1, "%s.log", router);
  sprintf (buf2, "%s.old", router);
  if ((lhist = calloc (1, sizeof (struct HISTORY) * (MAX_HISTORY + 1))) ==
      NULL)
    {
      fprintf (stderr, "%s, Rateup ERROR: Out of memory in update\n", bufftime);
      exit (1);
    }
  hist = lhist;

  period = (now - last.time);
  if (period <= 0 || period > (60 * 60) || last.in[0] == 'x')
    {				/* if last update is strange */
      if (options & OPTION_UNKNASZERO)
	{
	  inrate = 0;		/* sync unknown to zero */
	  outrate = 0;
	}
      else
	{
	  inrate = history[0].in;	/* Sync by using last value */
	  outrate = history[0].out;
	}
    }
  else
    {
      /* gauge and absolute */
      if (strcmp (in, "-1") == 0 ||	/* if current count missing */
	  strcmp (last.in, "-1") == 0)
	{			/* or previous count missing */
	  if (options & OPTION_UNKNASZERO)
	    {			/* then use 0 or last value */
	      inrate = 0;
	    }
	  else
	    {
	      inrate = history[0].in;
	    }
	}
      else
	{
	  if ((absupdate != 0) && (absupdate != 3) && (absupdate != 4))
	    {
	      inr = diff (in, "0");
	    }
	  else
	    {
	      inr = diff (in, last.in);
	      if (inr < 0) {
                if (inr > - (long long) 1 << 32) { 	/* wrapped 32-bit counter? */
  		    inr += (long long) 1 << 32;
                }
                else {
  		    inr = 0;
                }
              }                                        
	    }
	  if (absupdate == 2)
	    {
	      inrate = inr + .5;
	    }
	  else if (absupdate == 3)
	    {
	      inrate = inr * (3600.0 / (period * 1.0)) + .5;
	    }
	  else if (absupdate == 4)
	    {
	      inrate = inr * (60.0 / (period * 1.0)) + .5;
	    }
	  else
	    {
	      inrate = inr / period + .5;
	    }
	}
      if (strcmp (out, "-1") == 0 ||	/* if current count missing */
	  strcmp (last.out, "-1") == 0)
	{			/* or previous count missing */
	  if (options & OPTION_UNKNASZERO)
	    {			/* then use 0 or last value */
	      outrate = 0;
	    }
	  else
	    {
	      outrate = history[0].out;
	    }
	}
      else
	{
	  if ((absupdate != 0) && (absupdate != 3) && (absupdate != 4))
	    {
	      outr = diff (out, "0");
	    }
	  else
	    {
	      outr = diff (out, last.out);
	      if (outr < 0) {	/* wrapped  counter? */
                if (outr > - (long long) 1 << 32) {
  		    outr += (long long) 1 << 32;
                }
                else {
  		    outr = 0; /* 64bit counters do not wrap usually */
                }
              }
	    }
	  if (absupdate == 2)
	    {
	      outrate = outr + .5;
	    }
	  else if (absupdate == 3)
	    {
	      outrate = outr * (3600.0 / (period * 1.0)) + .5;
	    }
	  else if (absupdate == 4)
	    {
	      outrate = outr * (60.0 / (period * 1.0)) + .5;
	    }
	  else
	    {
	      outrate = outr / period + .5;
	    }
	}
    }



  if (inrate < 0 ||  inrate > abs_max)
    {
      if (options & OPTION_UNKNASZERO)
	{
	  inrate = 0;		/* sync unknown to zero */
	}
      else
	{
	  inrate = history[0].in;	/* Sync by using last value */
	}
    }
  if (outrate < 0 || outrate > abs_max)
    {
      if (options & OPTION_UNKNASZERO)
	{
	  outrate = 0;		/* sync unknown to zero */
	}
      else
	{
	  outrate = history[0].out;	/* Sync by using last value */
	}
    }
  if ((fo = fopen (buf, "w")) != NULL)
    {
      fprintf (fo, "%lu %s %s\n", (unsigned long) now, in, out);
      last.time = now;
      /* what is this good for? */
      /* gauge und absolute */
      if ((absupdate != 0) && (absupdate != 3) && (absupdate != 4))
	{
	  strcpy (last.in, "0");
	  strcpy (last.out, "0");
	}
      else
	{
	  strcpy (last.in, in);
	  strcpy (last.out, out);
	}
      fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
	       (unsigned long) now, inrate, outrate, inrate, outrate);
      nout = 1;
      hist->time = now;
      hist->in = inrate;
      hist->out = outrate;
      hist->inmax = inrate;
      hist->outmax = outrate;
      hist++;

      /* just in case we were dead for a long time, don't try to gather 
         data from non existing log entries  */
      now = plannow = history[0].time;

      plannow /= DAY_SAMPLE;
      plannow *= DAY_SAMPLE;
      n = 0;

      /* gobble up every shred of data we can get ... */
      if (plannow < now)
	{
	  NEXT ((unsigned long) (now - plannow));
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   (long long) inmax, (long long) outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now = plannow;

	}

      for (x = 1; x < DAY_COUNT; x++)
	{
	  NEXT (DAY_SAMPLE);
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   (long long) inmax, (long long) outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now -= DAY_SAMPLE;
	}

      plannow = now;
      plannow /= WEEK_SAMPLE;
      plannow *= WEEK_SAMPLE;

      if (plannow < now)
	{
	  NEXT ((unsigned long) (now - plannow));
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   inmax, outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now = plannow;

	}

      for (x = 0; x < WEEK_COUNT; x++)
	{
	  NEXT (WEEK_SAMPLE);
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   inmax, outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now -= WEEK_SAMPLE;
	}

      plannow = now;
      plannow /= MONTH_SAMPLE;
      plannow *= MONTH_SAMPLE;

      if (plannow < now)
	{
	  NEXT ((unsigned long) (now - plannow));
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   inmax, outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now = plannow;

	}

      for (x = 0; x < MONTH_COUNT; x++)
	{
	  NEXT (MONTH_SAMPLE);
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   inmax, outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now -= MONTH_SAMPLE;
	}

      plannow = now;
      plannow /= YEAR_SAMPLE;
      plannow *= YEAR_SAMPLE;

      if (plannow < now)
	{
	  NEXT ((unsigned long) (now - plannow));
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   inmax, outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now = plannow;

	}

      for (x = 0; x < YEAR_COUNT; x++)
	{
	  NEXT (YEAR_SAMPLE);
	  fprintf (fo, "%lu " LLD " " LLD " " LLD " " LLD "\n",
		   (unsigned long) now, (long long) inr, (long long) outr,
		   inmax, outmax);
	  hist->time = now;
	  hist->in = inr;
	  hist->out = outr;
	  hist->inmax = inmax;
	  hist->outmax = outmax;
	  nout++;
	  hist++;
	  now -= YEAR_SAMPLE;
	}

      if (ferror (fo) || fclose (fo))
	{
	  perror (program);
	  fprintf (stderr, "%s, Rateup ERROR: Can't write new log file\n", bufftime);
	  exit (1);
	}
#ifdef WIN32
      /* another fix to get things working under NT */
      if (unlink (buf2))
	{
	  fprintf (stderr,
		   "%s, Rateup WARNING: %s Can't remove %s updating log file\n",
		   bufftime, program, buf2);
	}
#endif
      if (rename (buf1, buf2))
	{
	  fprintf (stderr,
		   "%s, Rateup WARNING: %s Can't rename %s to %s updating log file\n",
		   bufftime, program, buf1, buf2);
	}
      if (rename (buf, buf1))
	{
	  fprintf (stderr,
		   "%s, Rateup WARNING: %s Can't rename %s to %s updating log file\n",
		   bufftime, program, buf, buf1);
	}
      for (n = 0; n < nout && n < MAX_HISTORY; n++)
	{
	  history[n] = lhist[n];
	}
    }
  else
    {
      perror (program);
      fprintf (stderr, "%s, Rateup ERROR: Can't open %s for write\n", bufftime, buf);
      exit (1);
    }
  free (lhist);
}

static void
init_colour (int *colmap, int c0, int c1, int c2)
{
  *colmap++ = c0;
  *colmap++ = c1;
  *colmap = c2;
}

/* Constants for readparm option */
#define LENGTH_OF_BUFF  (2048)
#define NUMBER_OF_PARM   (100)

char buff[LENGTH_OF_BUFF + 1];
char *program;

static int
readparam (char const *file)
{
  FILE *fp = NULL;
  int cbuf;

  /* Open the file */
  if ((fp = fopen (file, "r")) == NULL)
    {
      fprintf (stderr, "%s, %s ERROR: Can't open parameters file: %s\n", bufftime, program,
	       file);
      return (1);
    }
  /* Check we actually got something */
  if (!(cbuf = fread (buff, 1, LENGTH_OF_BUFF, fp)))
    {
      fprintf (stderr, "%s, %s ERROR: Parameters file empty\n", bufftime, program);
      fclose(fp);
      return (1);
    }
  fclose (fp);
  buff[cbuf] = '\0';

/* #define READPARAM_INFO */
#ifdef READPARAM_INFO

  fprintf (stderr, "%s, %s INFO: Read: %d bytes from File: '%s'\n", bufftime, program, cbuf,
	   file);

#endif

  return (0);
}

int
main (argc, argv)
     int argc;
     char **argv;
{
  int x, argi, used, initarg;

  program = argv[0];

    /* jpt, april 2006 : 3 lines for date & time logging */
    (void) time(&timestamp);
    stLocal = localtime(&timestamp);
    strftime(bufftime, 32, "%Y-%m-%d %H:%M:%S", stLocal);

  /* Is Argv[1] a path/file to passed parameters? */
  if ((argc > 1) && (strncasecmp (argv[1], "-F", 2) == 0))
    {
      char *b, *c, *l;
      if (readparam (argv[2]))
	{
	  return (1);
	}
      /* Parse buffer into argv[] */
      argv = calloc (NUMBER_OF_PARM + 1, sizeof (char *));
      argc = 0;
      b = buff;
      l = b + strlen (b);
      while (b < l)
	{
	  if (b[0] == '"')
	    {
	      b++;
	      c = strstr (b, "\"");
	      if (c != NULL)
		{
		  *c = '\0';
		  argv[argc] = b;
		  argc++;
		  b = c + 2;
		}
	      else
		{
		  fprintf (stderr,
			   "%s, Rateup ERROR: Parameter %d [%s] missing quote\n",
			   bufftime, argc, b);
		  break;
		}
	    }
	  else
	    {
	      c = strstr (b, " ");
	      if (c != NULL)
		{
		  *c = '\0';
		  argv[argc] = b;
		  argc++;
		  b = c + 1;
		}
	      else
		{
		  argv[argc] = b;
		  argc++;
		  b = l;
		}
	    }
	  if (argc == NUMBER_OF_PARM)
	    {
	      break;
	    }
	}
      /* Check we didn't fill argv[] */
      if (argc == NUMBER_OF_PARM)
	{
	  fprintf (stderr, "%s, Rateup ERROR: Too many parameters read: %d\n",
		   bufftime, argc);
	  return (1);
	}

      /* Check we didn't end early */
      if (b < l)
	{
	  return (1);
	}

      /* Mark End of argv[] */
      argv[argc] = NULL;

#ifdef READPARAM_DEBUG

      for (i = 0; i < argc; i++)
	{
	  printf ("ParameterX %2d : '%s'\n", i, argv[i] ? argv[i] : "<null>");
	}

#endif
    }

  if (argc < 3)
    {
      fprintf (stderr, "%s, %s for MRTG %s\n"
	       "Usage: %s -f <parameter file>\n"
	       "       %s directory basename [sampletime] [t sampletime] "
	       "[-(t)ransparent] [-(b)order]"
	       "[u|a|g|h|m in out abs_max] "
	       "[i/p file maxvi maxvo maxx maxy growright step bits]\n",
	       bufftime, program, VERSION, program, program);
      return (1);
    }

  routerpath = argv[1];
  /* this is for NT compatibility, because it does not seem to like
     rename across directories */
  if (chdir (routerpath))
    {
      fprintf (stderr, "%s, Rateup ERROR: Chdir to %s failed ...\n", bufftime, routerpath);
      return (1);
    }

  /* Initialiase the colour variables  - should be overwritten */
  init_colour (&col_in[0], c_in);
  init_colour (&col_out[0], c_out);
  init_colour (&col_inm[0], c_inm);
  init_colour (&col_outm[0], c_outm);
  init_colour (&col_outp[0], c_outp);

  if ((history = calloc (1, sizeof (struct HISTORY) * (MAX_HISTORY + 1))) ==
      NULL)
    {
      fprintf (stderr, "%s, Rateup ERROR: Out of memory in main\n", bufftime);
      exit (1);
    }
#if defined(__WATCOMC__) || defined(NETWARE)
  memset (history, 0, sizeof (struct HISTORY) * (MAX_HISTORY + 1));
#endif

  Mh = MAX_HISTORY;

  router = argv[2];
  if (strlen(router) > 120)
  {
      fprintf (stderr, "%s, Rateup ERROR: Too long basename\n", bufftime);
      exit (1);
  }

  /* from  mrtg-2.x with x>5 rateup calling syntax changed to
     to support time properly ... this is for backward compat
     we check if now is remotely reasonable ... 
   */

  if (argc > 3)
    {
      NOW = atol (argv[3]);
      if (NOW > 10 * 365 * 24 * 60 * 60)
	{
	  initarg = 4;
	}
      else
	{
	  initarg = 3;
	  time (&NOW);
	}
    }
  else
    {
      initarg = 3;
      time (&NOW);
    }

  readfile ();
  used = 1;

  for (argi = initarg; argi < argc; argi += used)
    {
      switch (argv[argi][0])
	{
	case '-':		/* -options */
	  switch (argv[argi][1])
	    {
	    case 'a':		/* Turn off the direction arrow */
	      options |= OPTION_NOARROW;
	      used = 1;
	      break;
	    case 'A':		/* Turn on the direction arrow */
	      options &= ~OPTION_NOARROW;
	      used = 1;
	      break;
	    case 'b':		/* Turn off the shaded border */
	      options |= OPTION_NOBORDER;
	      used = 1;
	      break;
	    case 'B':		/* Turn on the shaded border */
	      options &= ~OPTION_NOBORDER;
	      used = 1;
	      break;
	    case 'i':		/* Do not graph the I variable */
	      options |= OPTION_NO_I;
	      used = 1;
	      break;
	    case 'I':		/* Graph the I variable */
	      options &= ~OPTION_NO_I;
	      used = 1;
	      break;
	    case 'o':		/* Do not graph the O variable */
	      options |= OPTION_NO_O;
	      used = 1;
	      break;
	    case 'O':		/* Graph the O variable */
	      options &= ~OPTION_NO_O;
	      used = 1;
	      break;
	    case 'l':		/* logarithmic scaling */
	      options |= OPTION_LOGGRAPH;
	      options &= ~OPTION_MEANOVER;
	      options &= ~OPTION_EXPGRAPH;
	      used = 1;
	      break;
	    case 'm':		/* second-mean scaling */
	      options |= OPTION_MEANOVER;
	      options &= ~OPTION_LOGGRAPH;
	      options &= ~OPTION_EXPGRAPH;
	      used = 1;
	      break;
	    case 'p':		/* print router name in image */
	      options |= OPTION_PRINTROUTER;
	      used = 1;
	      break;
	    case 't':		/* Transparent Image */
	      options |= OPTION_TRANSPARENT;
	      used = 1;
	      break;
	    case 'T':		/* non-Transparent Image */
	      options &= ~OPTION_TRANSPARENT;
	      used = 1;
	      break;
            case 'x':		/* exponential scaling */
	      options |= OPTION_EXPGRAPH;
	      options &= ~OPTION_MEANOVER;
	      options &= ~OPTION_LOGGRAPH;
	      used = 1;
	      break;
	    case 'z':		/* unknown as zero */
	      options |= OPTION_UNKNASZERO;
	      used = 1;
	      break;
	    case 'Z':		/* repeat last */
	      options &= ~OPTION_UNKNASZERO;
	      used = 1;
	      break;
	    case '0':		/* assume zeroes */
	      options |= OPTION_WITHZEROES;
	      used = 1;
	      break;
	    default:
	      fprintf (stderr, "%s, Rateup ERROR: Unknown option: %s, sorry!\n",
		       bufftime, argv[argi]);
	      return (1);
	    }
	  break;
	case 'i':		/* Create PPM Image record */
	  image (argv[argi + 1],	/* Image */
		 strtoll (argv[argi + 2], NULL, 10),	/* Max Value In */
		 strtoll (argv[argi + 3], NULL, 10),	/* Max Value Out */
		 atol (argv[argi + 4]),	/* xsize maxx */
		 atol (argv[argi + 5]),	/* ysize maxy */
		 atof (argv[argi + 6]),	/* xscale */
		 atof (argv[argi + 7]),	/* yscale */
		 atol (argv[argi + 8]),	/* growright */
		 atol (argv[argi + 9]),	/* step */
		 atol (argv[argi + 10]),	/* bits */
		 atol (argv[argi + 11]),	/* ytics */
		 atof (argv[argi + 12]),	/* yticsfactor */
		 0, argv[argi + 13], atol (argv[argi + 14]));
	  used = 15;
	  break;
	case 'p':		/* Create PPM Image record with Peak values */
	  image (argv[argi + 1], strtoll (argv[argi + 2], NULL, 10),	/* Max Value In */
		 strtoll (argv[argi + 3], NULL, 10),	/* Max Value Out */
		 atol (argv[argi + 4]),	/* xsize maxx */
		 atol (argv[argi + 5]),	/* ysize maxy */
		 atof (argv[argi + 6]),	/* xscale */
		 atof (argv[argi + 7]),	/* yscale */
		 atol (argv[argi + 8]),	/* growright */
		 atol (argv[argi + 9]),	/* step */
		 atol (argv[argi + 10]),	/* bits */
		 atol (argv[argi + 11]),	/* ytics */
		 atof (argv[argi + 12]),	/* yticsfactor */
		 1, argv[argi + 13], atol (argv[argi + 14]));
	  used = 15;
	  break;
	case 'r':		/* Create random records, then update */
	  for (x = 0; x < histvalid; x++)
	    {
	      history[x].in = rand () % atoi (argv[argi + 1]);
	      history[x].out = rand () % atoi (argv[argi + 2]);
	    }
	case 'u':		/* Update file */
	  if (argv[argi][1] == 'p')
	    {
	      options |= OPTION_DORELPERCENT;
	    }
	  update (argv[argi + 1], argv[argi + 2],
		  strtoll (argv[argi + 3], NULL, 10), 0);
	  used = 4;
	  break;
	case 'a':		/* Absolute Update file */
	  if (argv[argi][1] == 'p')
	    {
	      options |= OPTION_DORELPERCENT;
	    }
	  update (argv[argi + 1], argv[argi + 2],
		  strtoll (argv[argi + 3], NULL, 10), 1);
	  used = 4;
	  break;
	case 'g':		/* Gauge Update file */
	  if (argv[argi][1] == 'p')
	    {
	      options |= OPTION_DORELPERCENT;
	    }
	  update (argv[argi + 1], argv[argi + 2],
		  strtoll (argv[argi + 3], NULL, 10), 2);
	  used = 4;
	  break;
	case 'h':
	  if (argv[argi][1] == 'p')
	    {
	      options |= OPTION_DORELPERCENT;
	    }
	  update (argv[argi + 1], argv[argi + 2],
		  strtoll (argv[argi + 3], NULL, 10), 3);
	  used = 4;
	  break;
	case 'm':
	  if (argv[argi][1] == 'p')
	    {
	      options |= OPTION_DORELPERCENT;
	    }
	  update (argv[argi + 1], argv[argi + 2],
		  strtoll (argv[argi + 3], NULL, 10), 4);
	  used = 4;
	  break;
	case 'W':		/* Week format */
	  weekformat = argv[argi + 1][0];
	  used = 2;
	  break;
	case 'c':		/* Colour Map */
	  sscanf (argv[argi + 1], "#%2x%2x%2x", &col_in[0], &col_in[1],
		  &col_in[2]);
	  sscanf (argv[argi + 2], "#%2x%2x%2x", &col_out[0], &col_out[1],
		  &col_out[2]);
	  sscanf (argv[argi + 3], "#%2x%2x%2x", &col_inm[0], &col_inm[1],
		  &col_inm[2]);
	  sscanf (argv[argi + 4], "#%2x%2x%2x", &col_outm[0], &col_outm[1],
		  &col_outm[2]);
	  used = 5;
	  break;
	case 'C':		/* Extented Colour Map */
	  sscanf (argv[argi + 1], "#%2x%2x%2x", &col_in[0], &col_in[1],
		  &col_in[2]);
	  sscanf (argv[argi + 2], "#%2x%2x%2x", &col_out[0], &col_out[1],
		  &col_out[2]);
	  sscanf (argv[argi + 3], "#%2x%2x%2x", &col_inm[0], &col_inm[1],
		  &col_inm[2]);
	  sscanf (argv[argi + 4], "#%2x%2x%2x", &col_outm[0], &col_outm[1],
		  &col_outm[2]);
	  sscanf (argv[argi + 5], "#%2x%2x%2x", &col_outp[0], &col_outp[1],
		  &col_outp[2]);
	  used = 6;
	  break;
	case 't':
	  NOW = atol (argv[argi + 1]);
	  used = 2;
	  break;
	case 'k':
	  kilo = atol (argv[argi + 1]);
	  used = 2;
	  break;
	case 'K':
	  kMG = calloc (strlen (argv[argi + 1]) + 1, sizeof (char));
	  strcpy (kMG, argv[argi + 1]);
	  used = 2;
	  break;
	case 'Z':		/* Timezone name */
	  rtimezone = argv[argi + 1];
	  used = 2;
	  break;
	case 'l':		/* YLegend - rewritten by Oliver Haidi, re-rewritten by Jon Barber */
	  {
	    int i, j, k, loop = 1;
	    int start = 1, got_esc = 0, append_ok;
	    char *qstr;
	    longup = (char *) calloc (1, 100);
	    *longup = 0;
	    /* this rather twisty argument scanning is necesary
	       because NT command.coms rather dumb argument
	       passing .... or because we don't know
	       better. Under Unix we just would say.  if
	       ((sscanf(argv[argi+1],"[%[^]]]", longup); */
	    /* at start, check 1st char must be [ */
	    if (argv[argi + 1][0] != '[')
	      {
		fprintf (stderr,
			 "%s, Rateup ERROR: YLegend: Option must be passed with '[' at start and  ']' at end (these will not be printed).\n", bufftime);
		return (1);
	      }
	    for (i = 1; (i < argc) && loop; i++)
	      {			/* check all args until unescaped ']'  */
		qstr = argv[argi + i];
		for (j = start; ((size_t) j < strlen (qstr)) && loop; j++)
		  {
		    start = 0;	/* 1st char in 1st arg already checked */
		    append_ok = 1;	/* OK to append unless we find otherwise */
		    if (qstr[j] == '\\')
		      {
			if (++got_esc == 1)
			  {
			    append_ok = 0;	/* don't append 1st '/' */
			  }
			else
			  {
			    got_esc = 0;	/* 2nd '/' in a row, i.e. '//' */
			  }
		      }
		    if (qstr[j] == ']')
		      {		/* is this the end? */
			if (got_esc == 1)
			  {
			    if (strlen (qstr + j) >= 2)
			      {
				append_ok = 1;
				got_esc = 0;
			      }
			    else
			      {
				fprintf (stderr,
					 "%s, 1a: rateup ERROR: YLegend:  use \"\\]\" for \"]\" or \"\\\\\" for \"\\\".\n", bufftime);
				return (1);
			      }
			  }
			else
			  {
			    if (strlen (qstr + j) >= 2)
			      {
				fprintf (stderr,
					 "%s, 2a: rateup ERROR: YLegend:  use \"\\]\" for \"]\" or \"\\\\\" for \"\\\".\n", bufftime);
				return (1);
			      }
			    loop = 0;
			    append_ok = 0;
			  }
		      }
		    if (append_ok == 1)
		      {
			k = strlen (longup);
			if ((size_t) (k + 1) > 99)
			  {
			    fprintf (stderr,
				     "%s, 3a: rateup ERROR: YLegend too long\n", bufftime);
			    return (1);
			  }
			longup[k] = qstr[j];
			longup[k + 1] = 0;
		      }
		  }		/* for (j=start...)   */
		/* append space */
		k = strlen (longup);
		if ((size_t) (k + 1) > 99)
		  {
		    fprintf (stderr, "%s, 4a: rateup ERROR: YLegend too long\n", bufftime);
		    return (1);
		  }
		longup[k] = ' ';
		longup[k + 1] = 0;
	      }			/* for (i =1 ... */
	    used = i;
	  }
	  /* remove trailing space */
	  longup[max (0, (signed) strlen (longup) - 1)] = 0;
	  shortup = longup;
	  /* fprintf(stderr, "%s, YLegend = \"%s\"\n", bufftime, longup);  */
	  break;
	case 'T':		/* pngTitle - based on YLegend */
	  {
	    int i, j, k, loop = 1;
	    int start = 1, got_esc = 0, append_ok;
	    char *qstr;
	    pngtitle = (char *) calloc (1, 100);
	    *pngtitle = 0;
	    /* this rather twisty argument scanning is necesary
	       because NT command.coms rather dumb argument
	       passing .... or because we don't know
	       better. Under Unix we just would say.  if
	       ((sscanf(argv[argi+1],"[%[^]]]", pngtitle); */
	    /* at start, check 1st char must be [ */
	    if (argv[argi + 1][0] != '[')
	      {
		fprintf (stderr,
			 "%s, Rateup ERROR: YLegend: Option must be passed with '[' at start and  ']' at end (these will not be printed).\n", bufftime);
		return (1);
	      }
	    for (i = 1; (i < argc) && loop; i++)
	      {			/* check all args until unescaped ']'  */
		qstr = argv[argi + i];
		for (j = start; ((size_t) j < strlen (qstr)) && loop; j++)
		  {
		    start = 0;	/* 1st char in 1st arg already checked */
		    append_ok = 1;	/* OK to append unless we find otherwise */
		    if (qstr[j] == '\\')
		      {
			if (++got_esc == 1)
			  {
			    append_ok = 0;	/* don't append 1st '/' */
			  }
			else
			  {
			    got_esc = 0;	/* 2nd '/' in a row, i.e. '//' */
			  }
		      }
		    if (qstr[j] == ']')
		      {		/* is this the end? */
			if (got_esc == 1)
			  {
			    if (strlen (qstr + j) >= 2)
			      {
				append_ok = 1;
				got_esc = 0;
			      }
			    else
			      {
				fprintf (stderr,
					 "%s, 1b: rateup ERROR: YLegend:  use \"\\]\" for \"]\" or \"\\\\\" for \"\\\".\n", bufftime);
				return (1);
			      }
			  }
			else
			  {
			    if (strlen (qstr + j) >= 2)
			      {
				fprintf (stderr,
					 "%s, 2b: rateup ERROR: YLegend:  use \"\\]\" for \"]\" or \"\\\\\" for \"\\\".\n", bufftime);
				return (1);
			      }
			    loop = 0;
			    append_ok = 0;
			  }
		      }
		    if (append_ok == 1)
		      {
			k = strlen (pngtitle);
			if ((size_t) (k + 1) > 99)
			  {
			    fprintf (stderr,
				     "%s, 3b: rateup ERROR: YLegend too long\n", bufftime);
			    return (1);
			  }
			pngtitle[k] = qstr[j];
			pngtitle[k + 1] = 0;
		      }
		  }		/* for (j=start...)   */
		/* append space */
		k = strlen (pngtitle);
		if ((size_t) (k + 1) > 99)
		  {
		    fprintf (stderr, "%s, 4b: rateup ERROR: YLegend too long\n", bufftime);
		    return (1);
		  }
		pngtitle[k] = ' ';
		pngtitle[k + 1] = 0;
	      }			/* for (i =1 ... */
	    used = i;
	  }
	  /* remove trailing space */
	  pngtitle[max (0, (signed) strlen (pngtitle) - 1)] = 0;
	  /* fprintf(stderr, "%s, YLegend = \"%s\"\n", bufftime, pngtitle);  */
	  break;
	default:
	  fprintf (stderr, "%s, Rateup ERROR: Can't cope with %s, sorry!\n",
		   bufftime, argv[argi]);
	  return (1);
	}
    }
  return (0);
}
