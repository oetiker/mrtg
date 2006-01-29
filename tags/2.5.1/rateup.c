/*
 $Id: rateup.c,v 2.10 1997/10/24 13:30:06 oetiker Exp oetiker $
 $Log: rateup.c,v $
 Revision 2.10  1997/10/24 13:30:06  oetiker
 updated for 2.5 release

 Revision 2.9  1997/10/09 21:05:21  oetiker
 first startup fixed ...

 Revision 2.8  1997/10/09 12:40:29  oetiker
 fixed the time problems .

 Revision 2.7  1997/10/09 06:22:34  oetiker
 maybe now ?

 Revision 2.5  1997/10/06 07:48:31  oetiker
 release 2.5

 Revision 2.4  1997/10/06 07:46:21  oetiker
 release 2.5

 Revision 2.3  1997/06/12 08:16:56  oetiker
 2.3 release

 Revision 2.2  1997/04/25 06:25:28  oetiker
 made periode a double in order to make it work better on broken compilers

 Revision 2.1  1997/02/22 12:51:19  oetiker
 2.1 release

 Revision 2.0  1997/01/26 10:49:17  oetiker
 2.0 release

 *

 rateup.c  Version 1.03             Thu Mar 28 14:29:14 PST 1996
 Make the last fields arbitrary length.  Well, up to MAXL characters,
 anyway.

 Fix format errors in output, add more rigorous error checking.

 rateup.c  Version 1.02             Thu Mar 28 13:22:27 PST 1996
 Fix format errors in output, add more rigorous error checking.

 rateup.c  Version 1.01             Sun Mar 24 14:41:24 PST 1996
 Add maximum utilization return, and calculation, for the 31 hour
 period (or any period - just pass a negative value as max).

 rateup.c  Version 1.00             Fri Mar 22 18:14:35 PST 1996

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
*/

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <ctype.h>

/* BSDI 2.0.1 does not have malloc.h */
#ifndef bsdi
#ifndef __FreeBSD__
#include <malloc.h>
#endif
#endif

/* WATCOM C/C++ 10.6 under Win95/NT */
#ifdef __WATCOMC__  
#include <string.h>
#include <sys\types.h>
#include <direct.h>
#include <io.h>
#endif

#include <gd.h>
#include <gdfonts.h>

char *Version="$Id: rateup.c,v 2.10 1997/10/24 13:30:06 oetiker Exp oetiker $";
char *program,*router,*routerpath;
int histvalid;
time_t NOW;

char *short_si[] = {"","k","M","G","T"};
char *longup = NULL;
char *shortup = NULL;
char weekformat = 'W';			/* strftime() fmt char for week #  */

#define DAY_COUNT (600)			/* 400 samples is 33.33 hours */
#define DAY_SAMPLE (5*60)		/* Sample every 5 minutes */
#define WEEK_COUNT (600)		/* 400 samples is 8.33 days */
#define WEEK_SAMPLE (30*60)		/* Sample every 30 minutes */
#define MONTH_COUNT (600)		/* 400 samples is 33.33 days */
#define MONTH_SAMPLE (2*60*60)		/* Sample every 2 hours */
#define YEAR_COUNT  (2 * 366)		/* 1 sample / day, 366 days, 2 years */
#define YEAR_SAMPLE (24*60*60)		/* Sample every 24 hours */

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

int col_in[3];
int col_out[3];
int col_inm[3];
int col_outm[3];

#define MAXL	200	/* Maximum length of last in & out fields */


struct HISTORY {
    time_t time;
    unsigned long in, out, inmax, outmax;
} *history;
int Mh;

struct LAST {
    time_t time;
    char in[MAXL],out[MAXL];
} last;

#ifndef __WATCOMC__
#define max(a,b) ((a) > (b) ? (a) : (b))
#endif

/*

notes about the NEXT macro ....

* position n to the entry in the history array so that NOW is between
  history[n] and history[n+1]

* calculate the interval according to steptime and position of 
  now within the history array.

for debuging 

    fprintf (stderr,"NOW: %8lu  ST: %4lu  N: %4u HTN: %8lu HTN+1: %8lu IV: %6.0f\n", \
            now,steptime,n,history[n].time, history[n+1].time, interval);\

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
      fprintf(stderr,"ERROR: Rateup is trying to read ahead of the available data\n");\
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
	inmax =  max(inmax, history[n].inmax);\
	outmax = max(outmax,history[n].outmax);\
	if (nextnow <= history[n+1].time) n++; else break;\
      } while (n < histvalid && nextnow < history[n].time);\
\
      if (avc != steptime) {\
	fprintf(stderr,"ERROR: StepTime does not match Avc %8lu. Please Report this.\n", avc);\
      }\
\
      inr /= avc; outr /= avc;\
    }\
  }

 
void image(file,maxv,maxx,maxy,xscale,yscale,growright,step, bits, peak)
char *file;
long maxv;
unsigned long maxx,maxy,growright,step,bits;
double xscale,yscale;
int peak;
{
    FILE *fo;
    int i,x,y,n,type;
    
    unsigned long origmaxv,maxs, avc, inmax, outmax;
    double inr, outr,muli, interval;
    time_t now,onow,nextnow;
    struct tm *tm;
    char *graph_label[600];
    char ylab[30];
    /* scaling helpers */
    long maxv_q;
    unsigned long valsamp,maxin,maxout,digits,
      sca_ten,sca_hun,nmax_q;
    double avin, avout,latestout=0,latestin=0,nmax;
    double nex_ten,nex_hun,nex_rnd,sca_max_q;
    

    struct HISTORY *lhist;
    /* ################################################# */
    /* Some general definitions for the graph generation */
#define XSIZE (unsigned long)((maxx*xscale)+100)
#define YSIZE (unsigned long)((maxy*yscale)+35)
    /* position the graph */
#define ytr(y) (unsigned long)(maxy*yscale+14-((y)*yscale))
    /* translate x/y coord into graph coord */
#define xtr(x) (unsigned long)((growright) ? (maxx*xscale+77-((x)*xscale)) : (77+((x)*xscale))) 
    /* ################################################# */ 

    /* GD LIB declarations */
    /* Declare the image */
    gdImagePtr graph,brush_out,brush_outm;
    /* Declare color indexes */
    int i_light,i_dark,i_blank, i_major, i_in, i_out, i_grid, i_inm, i_outm;
    /* Dotted style */
    int styleDotted[3];

    /* multiplicator for bits/bytes */
    muli = 7*bits+1;
    maxv *= muli;
    origmaxv = labs(maxv);
    if (step > MONTH_SAMPLE) {
	type = 4;
         now = (long)(NOW / YEAR_SAMPLE)*YEAR_SAMPLE;

    } else if (step > WEEK_SAMPLE) {
	type = 3;
         now = (long)(NOW / MONTH_SAMPLE)*MONTH_SAMPLE;	
    } else if (step > DAY_SAMPLE) {
	type = 2;
         now = (long)(NOW / WEEK_SAMPLE)*WEEK_SAMPLE;
   } else {
	type = 1;
	now = (long)(NOW / DAY_SAMPLE)*DAY_SAMPLE;
    }
    if ((lhist = calloc(1,sizeof(struct HISTORY) * maxx)) == NULL) {
	fprintf(stderr,"Rateup ERROR: Out of memory in graph creation\n");
	exit(1);
    }
    onow = now;
    avin = avout = 0.0;
    inmax = outmax = maxin = maxout = 0;
    valsamp =0;
    for (maxs = 0,n=0,x=0; x<maxx; x++) {
	NEXT(step);
	/*scale with muli */
	inr *=muli; outr *=muli; inmax *=muli; outmax *=muli;	
	/* ignore times when we have not sampled */
	if(inr>0 || outr>0) valsamp++;
	if (x==0) {latestin=inr;latestout=outr;}
	avin += inr;
	avout += outr;
	if (peak) {
		maxin = max(maxin,inmax);
    	        maxout = max(maxout,outmax);
	        maxs = max(maxs,inmax);
	        maxs = max(maxs,outmax);
	} else {
		maxin = max(maxin,inr);
		maxout = max(maxout,outr);
		maxs = max(maxs,inr);
		maxs = max(maxs,outr);	
	}
	now -= step;
    }
    if (valsamp) {
       	avin /= valsamp;
	avout /= valsamp;
    }
	
    printf("%lu\n",(unsigned long)(maxin/muli));
    printf("%lu\n",(unsigned long)(maxout/muli));
    printf("%lu\n",(unsigned long)(avin/muli));
    printf("%lu\n",(unsigned long)(avout/muli));
    printf("%lu\n",(unsigned long)(latestin/muli));
    printf("%lu\n",(unsigned long)(latestout/muli));

    if (maxv<0 || maxv < maxs) {maxv = maxs;}
      
    now = onow;

    if (maxv <= 0) maxv = 1;

    /* mangle the 0.25*maxv value so, that we get a number with either */
    /* one or two digits != 0 and these digits should be at the  */
    /* start of the number ... */

    /* the ceil compensates for rounding with small numbers */
    maxv_q = ceil((double)maxv / 4.0);    /* int */
     
    if (maxv_q) {
    	digits = log10((double)maxv_q);
    } else {
	digits=0;
    }

    sca_ten = maxv_q / pow(10.0,(double)digits);
    sca_hun = maxv_q / pow(10.0,(double)digits-1);
    nex_rnd = (sca_hun) * pow(10.0,(double)digits-1);
    nex_ten = (sca_ten+1) * pow(10.0,(double)digits);
    nex_hun = (sca_hun+1) * pow(10.0,(double)digits-1);

    if (nex_ten <= (1.1 * maxv_q))  {
	nmax_q = nex_ten; 
    } else if (maxv_q == nex_rnd) {
	nmax_q = nex_rnd; 
    } else {
	nmax_q = nex_hun;
    }

    sca_max_q = nmax_q/(pow(10.0,(double)((int)(digits/3))*3));
      
    nmax=nmax_q*4;
    if (nmax < 1.) {nmax=1.;}

    for (n=0,x=0; x<maxx; x++) {
      	lhist[x].time = 0;
	graph_label[x] = NULL;
	tm = localtime(&history[n].time);
	switch(type){
	default:
	case 1:
	  if (tm->tm_min == 0) {
	    lhist[x].time |= 1;
	    if (tm->tm_hour == 0)
	      lhist[x].time |= 2;
	  }
	  if ((tm->tm_min == 0) && (tm->tm_hour % 2 == 0))  {
	    if ((graph_label[x] = calloc(1,sizeof(char) * 4)) == NULL) {
	      fprintf(stderr,"Rateup ERROR: Out of memory in graph labeling\n");
	      exit(0);
	    } else {
	      sprintf(graph_label[x],"%i",tm->tm_hour);
	    }
	  }
	  break;
	case 2:
	  if (tm->tm_min < 30 && tm->tm_hour == 0) {
	    lhist[x].time |= 1;
	    if (tm->tm_wday == 1)
	      lhist[x].time |= 2;
	  } 
	  
          /* fprintf(stderr,"x: %i, min:%i, hour:%i day: %i\n",
	     x,tm->tm_min,tm->tm_hour,tm->tm_wday); */
	  if ((tm->tm_min < 30) && 
	      (tm->tm_hour == 12))  {
	    if ((graph_label[x] = calloc(1,sizeof(char) * 5)) == NULL) {
	      fprintf(stderr,"Rateup ERROR: Out of memory in graph labeling\n");
	      exit(0);
	    } else {
	      strftime(graph_label[x],4,"%a",tm);
	    }
	  }
	  
	  break;
	case 3:
	  if (tm->tm_hour < 2) {
	    if (tm->tm_wday == 1) 
	      lhist[x].time |= 1;
	    if (tm->tm_mday == 1)
	      lhist[x].time |= 2;
	  }
	  /* label goes to thursday noon */
	  
	  if ((tm->tm_hour > 10) &&
	      (tm->tm_hour <= 12) &&
	      (tm->tm_wday == 4))  {
	    if ((graph_label[x] = calloc(1,sizeof(char) * 16)) == NULL) {
	      fprintf(stderr,"Rateup ERROR: Out of memory in graph labeling\n");
	      exit(0);
	    } else {
	      char fmtbuf[10];
	      sprintf (fmtbuf, "Week %%%c", weekformat);
	      strftime(graph_label[x],8,fmtbuf, tm);
	    }
	  }
	  break;
	case 4:
	  if (tm->tm_mday == 1) 
	    lhist[x].time |= 1;
	  if (tm->tm_yday == 0)
	    lhist[x].time |= 2;
	  

	  if (tm->tm_mday ==15)  {
	    if ((graph_label[x] = calloc(1,sizeof(char) * 5)) == NULL) {
	      fprintf(stderr,"Rateup Error: Out of memory in graph labeling\n");
	      exit(0);
	    } else {
	      strftime(graph_label[x],4,"%b",tm);
	    }
	  }
	  break;
	}

	NEXT(step);
	/*scale with muli */
	inr *=muli; outr *=muli; inmax *=muli; outmax *=muli;		

	y = ((double)inr/nmax) * maxy;
	if (y >= maxy) y = maxy;
	lhist[x].in = y;
	y = ((double)outr/nmax) * maxy;
	if (y >= maxy) y = maxy;
	lhist[x].out = y;
	y = ((double)inmax/nmax) * maxy;
	if (y >= maxy) y = maxy;
	if (x && y < (lhist[x-1].inmax)) {
	  y += (lhist[x-1].inmax); y /= 2;
	}
        lhist[x].inmax = y;
	y = ((double)outmax/nmax) * maxy;
	if (y >= maxy) y = maxy;
	if (x && y < (lhist[x-1].outmax)) {
	  y += (lhist[x-1].outmax); y /= 2;
	}
        lhist[x].outmax = y;
	
	now -= step;
    }

    /* the graph is made ten pixels higher to acomodate the x labels */
    graph = gdImageCreate(XSIZE, YSIZE);
    brush_out = gdImageCreate(1,2);
    brush_outm = gdImageCreate(1,2);
    
    /* the first color allocated will be the background color. */
    i_blank = gdImageColorAllocate(graph,c_blank);
    i_light = gdImageColorAllocate(graph,c_light);
    i_dark = gdImageColorAllocate(graph,c_dark);

    /* gdImageColorTransparent(graph, i_blank); */
    gdImageInterlace(graph, 1); 
    
    i_major = gdImageColorAllocate(graph,c_major);
    i_in = gdImageColorAllocate(graph,col_in[0], col_in[1], col_in[2]);
    i_out = gdImageColorAllocate(brush_out,col_out[0], col_out[1], col_out[2]);
    i_grid = gdImageColorAllocate(graph,c_grid );
    i_inm = gdImageColorAllocate(graph,col_inm[0], col_inm[1], col_inm[2]);
    i_outm = gdImageColorAllocate(brush_outm,col_outm[0], col_outm[1], col_outm[2]);
    
    /* draw the image border */
    gdImageLine(graph,0,0,XSIZE-1,0,i_light);
    gdImageLine(graph,1,1,XSIZE-2,1,i_light);
    gdImageLine(graph,0,0,0,YSIZE-1,i_light);
    gdImageLine(graph,1,1,1,YSIZE-2,i_light);
    gdImageLine(graph,XSIZE-1,0,XSIZE-1,YSIZE-1,i_dark);
    gdImageLine(graph,0,YSIZE-1,XSIZE-1,YSIZE-1,i_dark);
    gdImageLine(graph,XSIZE-2,1,XSIZE-2,YSIZE-2,i_dark);
    gdImageLine(graph,1,YSIZE-2,XSIZE-2,YSIZE-2,i_dark);


    /* draw the incoming traffic */
    for (x=0; x<maxx; x++) {
      /* peak is always above average, we therefore only draw the upper part */
      if (peak) gdImageLine(graph,xtr(x),ytr(lhist[x].in),
                                  xtr(x),ytr(lhist[x].inmax),i_inm);
#ifdef INCOMING_UNFILLED
      gdImageLine(graph,xtr(x),ytr(lhist[x].in),xtr(x),ytr(lhist[x+1].in),i_in);
#else
      gdImageLine(graph,xtr(x),ytr(0),xtr(x),ytr(lhist[x].in),i_in);
      /* draw the line a second time offset slightly. makes the graph
       * look better if xscale is fractional */
      gdImageLine(graph,xtr(x+0.5),ytr(0),xtr(x+0.5),ytr(lhist[x].in),i_in);
#endif
    }
    /* draw the outgoing traffic */
    gdImageSetBrush(graph, brush_outm);
    if (peak) for (x=0; x<maxx-1; x++) 
       gdImageLine(graph,xtr(x), ytr(lhist[x].outmax),
		   xtr(x+1), ytr(lhist[x+1].outmax),
		   gdBrushed);
    gdImageSetBrush(graph, brush_out);   
    for (x=0; x<maxx-1; x++) 
      gdImageLine(graph,xtr(x),ytr(lhist[x].out),
		  xtr(x+1),ytr(lhist[x+1].out),
		  gdBrushed);
 
    /* draw the graph border */
    
    gdImageRectangle(graph,
		     xtr(0),ytr(0),xtr(maxx),ytr(maxy),i_grid);
    
    /*create a dotted style for the grid lines*/
    styleDotted[0] = i_grid;
    styleDotted[1] = gdTransparent;
    styleDotted[2] = gdTransparent;
    gdImageSetStyle(graph, styleDotted, 3);
    
    /* draw the horizontal grid */
    if ((longup == NULL) || (shortup == NULL)) {
	if (!bits) { longup = "Bytes per Second"; shortup = "Bytes/s"; }
	else { longup = "Bits per Second"; shortup = "Bits/s"; }
    }
    if (maxy < gdFontSmall->w*16) {	
	gdImageStringUp(graph, gdFontSmall,8, ytr((maxy-gdFontSmall->w*strlen(shortup))/2),
		      shortup, i_grid);
    } else {
	gdImageStringUp(graph, gdFontSmall,8, ytr((maxy-gdFontSmall->w*strlen(longup))/2),
		      longup, i_grid);
    }
    for(i=0;i<=4;i++){
      
	gdImageLine(graph,xtr(-2),ytr(i*maxy/4),
		    xtr(1),ytr(i*maxy/4),i_grid);

	gdImageLine(graph,xtr(maxx+2),ytr(i*maxy/4),
		    xtr(maxx-1),ytr(i*maxy/4),i_grid);

	gdImageLine(graph,xtr(0),ytr(i*maxy/4),
		    xtr(maxx),ytr(i*maxy/4),gdStyled);
	
    	sprintf(ylab,"%6.1f %s",sca_max_q*i,short_si[digits/3]);
        gdImageString(graph, gdFontSmall,23, 
        	      ytr(i*maxy/4+gdFontSmall->h/2),
		      ylab, i_grid);
    }
    
    /* draw vertical grid and horizontal labels */
    for (x=0; x<maxx; x++) {
      if (lhist[x].time) {
	gdImageLine(graph,xtr(x),ytr(-2),xtr(x),ytr(1),i_grid);
	gdImageLine(graph,xtr(x),ytr(0),xtr(x),ytr(maxy),gdStyled); 
      }
      if (graph_label[x] != NULL) {
        gdImageString(graph, gdFontSmall,
		      (xtr(x) - (strlen(graph_label[x]) * 
			    gdFontSmall->w / 2)), 
		      ytr(-4),
		      graph_label[x], i_grid);
	free(graph_label[x]);
      }
      if (lhist[x].time & 2)
	gdImageLine(graph,xtr(x),ytr(0),xtr(x),ytr(maxy),i_major);
    }

    /* draw line at peak value in i_major color */
    /* only draw the line if it's within the graph ... */
    if ( ytr( maxy ) < ytr(((double)origmaxv/nmax)*maxy)) {
      styleDotted[0] = i_major; 
      gdImageSetStyle(graph, styleDotted, 3);
      gdImageLine(graph, xtr(0),ytr(((double)origmaxv/nmax)*maxy),
		  xtr(maxx),ytr(((double)origmaxv/nmax)*maxy),
		  gdStyled);
    }


    /* draw a red arrow a 0,0 */
    gdImageLine(graph, xtr(2),ytr(3),xtr(2),ytr(-3), i_major);
    gdImageLine(graph, xtr(1),ytr(3),xtr(1),ytr(-3), i_major);
    gdImageLine(graph, xtr(0),ytr(2),xtr(0),ytr(-2), i_major);
    gdImageLine(graph, xtr(-1),ytr(1),xtr(-1),ytr(-1), i_major);
    gdImageLine(graph, xtr(-2),ytr(1),xtr(-2),ytr(-1), i_major);
    gdImageLine(graph, xtr(-3),ytr(0),xtr(-3),ytr(0), i_major);


    if ((fo = fopen(file,"wb")) == NULL) {
      perror(program);
      fprintf(stderr,"Rateup Error: Can't open %s for write\n",file);
      exit(1);
    }
    gdImageGif(graph, fo);    
    fclose(fo);
    gdImageDestroy(graph);
    gdImageDestroy(brush_out);
    gdImageDestroy(brush_outm);
    free(lhist);
}

	    
double diff(a,b)
char *a,*b;
{
    char res[MAXL], *a1, *b1, *r1;
    int c,x,m;

    while (!isdigit(*a))
	a++;
    while (!isdigit(*b))
	b++;
    a1 = &a[strlen(a)-1];
    m = max(strlen(a),strlen(b));
    r1 = &res[m+1];
    for (b1 = res;b1 <= r1; b1++) *b1 = ' ';
    b1 = &b[strlen(b)-1];
    r1[1] = 0;	/* Null terminate result */
    c = 0;
    for (x=0; x<m; x++) {
	if (a1 >= a && b1 >= b) {
	    *r1 = ((*a1 - c) - *b1) + '0';
	} else if (a1 >= a) {
	    *r1 = (*a1 - c);
	} else {
	    *r1 = ('0' - *b1 - c) + '0';
	}
	if (*r1 < '0') {
	    *r1 += 10; 
	    c=1;
	} else {
	    c=0;
	}
	a1--;b1--;r1--;
    }
    if (c) {
	r1 = &res[m+1];
	for (x=0; isdigit(*r1) && x<m; x++,r1--)  {
	    *r1 = ('9' - *r1 + c) + '0';
	    if (*r1 < '0') {
		*r1 += 10; 
		c=1;
	    } else {
		c=0;
	    }
	}
	return(-atof(res));
    } else
	return(atof(res));
}

int readhist(file)
char *file;
{
    FILE *fi;
    int i,x, retcode = 0;
    char buf[256];
    struct HISTORY *hist;
    double rd[5];
    time_t cur;

    if ((fi = fopen(file,"r")) != NULL) {
	if (fscanf(fi,"%ld %s %s\n",&last.time,&last.in[0],&last.out[0]) != 3)
	   retcode = 1;
        cur = last.time;
	x = histvalid=0;
	hist = history;
	while(!feof(fi)) {
	    fgets(buf,256,fi);
	    if (sscanf(buf,"%lf %lf %lf %lf %lf",
                 &rd[0],&rd[1],&rd[2],&rd[3],&rd[4]) <5 ) {
	      rd[3]=rd[1];rd[4]=rd[2]; }
	    for (i=0;i<=4;i++){
	      rd[i]=rd[i] < 0 ? 0 : rd[i];
	    }
					
	    hist->time=rd[0];
	    hist->in=rd[1];
	    hist->out=rd[2];
	    hist->inmax=rd[3];
	    hist->outmax=rd[4];
	    if (hist->inmax < hist->in)
		hist->inmax = hist->in;
	    if (hist->outmax < hist->out)
		hist->outmax = hist->out;
	    if (hist->time > cur) {
		fprintf(stderr,"Rateup ERROR: %s found %s's log file was corrupt\n              or not in sorted order.",program,router);
	        retcode = 2;
		break;
	    }
	    cur = hist->time;
	    if (++x >= Mh) {
		struct HISTORY *lh;

		Mh += MAX_HISTORY;
		lh = realloc(history, (Mh + 1) * sizeof(struct HISTORY));
		if (lh == NULL)
		{
		    fprintf(stderr,"Rateup WARNING: (pay attention to this)\nWARNING: %s found %s's log file had too many entries, data discarded\n",program,router);
		    break;
		}
		hist = lh + (hist - history);
		history = lh;
	    }
	    hist++;
	}
	histvalid = x;
	fclose(fi);
    } else {
	retcode = 1;
    }
    return(retcode);
}

void readfile() {
    char buf[128];
    int err, x;
    time_t now;
    struct HISTORY *hist;

    sprintf(buf,"%s.log",router);
    if ((err = readhist(buf)) != 0) {	/* Read of log file failed.  Try backup */
        fprintf(stderr,"Rateup WARNING: %s could not read the primary log file for %s\n",program,router);
	sprintf(buf,"%s.old",router);
	if ((err = readhist(buf)) != 0) {	/* Backup failed too. New file? */
	    fprintf(stderr,"Rateup WARNING: %s The backup log file for %s was invalid as well\n",program,router);
	    if (err == 2) exit(1);

	    /* File does not exist - it must be created */
 	    now = NOW - DAY_SAMPLE;
	    hist = history;
	    histvalid = DAY_COUNT+WEEK_COUNT+MONTH_COUNT+YEAR_COUNT-1;
	    last.time = now;
	    /* calculating a diff does not make sense */
	    last.in[0] = 'x';
	    now /= DAY_SAMPLE;
	    now *= DAY_SAMPLE;        
	    for (x=0; x <DAY_COUNT; x++, hist++) {
		hist->time = now;
	        hist->in = hist->inmax = hist->out = hist->outmax = 0;	
		now -= DAY_SAMPLE;
	    }
	    now /= WEEK_SAMPLE;
	    now *= WEEK_SAMPLE;
	    for (x=0; x<WEEK_COUNT; x++,hist++) {
		hist->time = now;
	        hist->in = hist->inmax = hist->out = hist->outmax = 0;	
		now -= WEEK_SAMPLE;
	    }
	    now /= MONTH_SAMPLE;
	    now *= MONTH_SAMPLE;
	    for (x=0; x<MONTH_COUNT; x++,hist++) {
		hist->time = now;
	        hist->in = hist->inmax = hist->out = hist->outmax = 0;	
		now -= MONTH_SAMPLE;
	    }
	    now /= YEAR_SAMPLE;
	    now *= YEAR_SAMPLE;
	    for (x=0; x<YEAR_COUNT; x++,hist++) {
		hist->time = now;
	        hist->in = hist->inmax = hist->out = hist->outmax = 0;	
		now -= YEAR_SAMPLE;
	    }	    
	}
    }
}
	     
void update(in, out, abs_max, absupdate)
char *in, *out;
unsigned long abs_max;
int absupdate;
{
    FILE *fo;
    char buf[128],buf1[128],buf2[128];
    time_t now,nextnow,plannow;
    long inrate, outrate;
    unsigned long avc, inmax, outmax;
    double period, interval;
    int x,n,nout;
    struct HISTORY *lhist,*hist;
    double inr, outr;

    now = NOW;
 
    if (now < last.time) {
       fprintf(stderr,"Rateup ERROR: %s found that %s's log file time of %lu was greater than now (%lu)\nERROR: Let's not do the time warp, again. Logfile unchanged.\n",program,router,last.time,now);
       return;
    }
    sprintf(buf,"%s.tmp",router);
    sprintf(buf1,"%s.log",router);
    sprintf(buf2,"%s.old",router);
    if ((lhist = calloc(1,sizeof(struct HISTORY) * (MAX_HISTORY + 1))) == NULL) {
	fprintf(stderr,"Rateup ERROR: Out of memory in update\n");
	exit(1);
    }
    hist = lhist;

    period = ( now - last.time);
    if (period <= 0 || period > (60*60) || last.in[0] == 'x') {	/* if last update is strange */
	inrate = history[0].in;			/* Sync by using last value */
	outrate = history[0].out;
    } else {
      /* gauge and absolute */
	if (absupdate != 0) {
	    strcpy(last.in,"0");
	    strcpy(last.out,"0");
	}
	/* gauge option */
	if (absupdate == 2) {
	    inrate = diff(in,last.in);
	    outrate = diff(out,last.out);
	} else {
	    inrate = diff(in,last.in) / period;
	    outrate = diff(out,last.out) / period;
	}
    }
    if (inrate < 0 || inrate > abs_max) inrate = history[0].in;
    if (outrate < 0 || outrate > abs_max) outrate = history[0].out;
    if ((fo = fopen(buf,"w")) != NULL) {
	fprintf(fo,"%lu %s %s\n",now,in,out);
	last.time = now;
        /* what is this good for? */
	/* gauge und absolute */
	if (absupdate) {
	    strcpy(last.in,"0");
	    strcpy(last.out,"0");
	} else {
	    strcpy(last.in,in);
	    strcpy(last.out,out);
        }
	fprintf(fo,"%lu %lu %lu %lu %lu\n",now, inrate, outrate, inrate, outrate);
	nout = 1;
	hist->time = now;
	hist->in = inrate; hist->out = outrate;
	hist->inmax = inrate; hist->outmax = outrate;
	hist++;

	/* just in case we were dead for a long time, don't try to gather 
           data from non existing log entries  */
	now = plannow = history[0].time;
	
	plannow /= DAY_SAMPLE;
	plannow *= DAY_SAMPLE;        
	n = 0;

	/* gobble up every shred of data we can get ... */
	if (plannow < now) {
	  NEXT((now-plannow));
	  fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		  (unsigned long)inr,(unsigned long)outr,inmax,outmax);
	  hist->time = now;
	  hist->in = inr; hist->out = outr;
	  hist->inmax = inmax; hist->outmax = outmax;
	  nout++;hist++;	  
	  now = plannow;

	}

	for (x=1; x<DAY_COUNT; x++) {
	    NEXT(DAY_SAMPLE);
	    fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		(unsigned long)inr,(unsigned long)outr,inmax,outmax);
	    hist->time = now;
	    hist->in = inr; hist->out = outr;
	    hist->inmax = inmax; hist->outmax = outmax;
	    nout++;hist++;
	    now -= DAY_SAMPLE;
	}

	plannow=now;	
	plannow /= WEEK_SAMPLE;
	plannow *= WEEK_SAMPLE;

	if (plannow < now) {
	  NEXT((now-plannow));
	  fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		  (unsigned long)inr,(unsigned long)outr,inmax,outmax);
	  hist->time = now;
	  hist->in = inr; hist->out = outr;
	  hist->inmax = inmax; hist->outmax = outmax;
	  nout++;hist++;	  
	  now = plannow;

	}
	
	for (x=0; x<WEEK_COUNT; x++) {
	    NEXT(WEEK_SAMPLE);
	    fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		(unsigned long)inr,(unsigned long)outr,inmax,outmax);
	    hist->time = now;
	    hist->in = inr; hist->out = outr;
	    hist->inmax = inmax; hist->outmax = outmax;
	    nout++;hist++;
	    now -= WEEK_SAMPLE;
	}

	plannow=now;	
	plannow /= MONTH_SAMPLE;
	plannow *= MONTH_SAMPLE;

	if (plannow < now) {
	  NEXT((now-plannow));
	  fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		  (unsigned long)inr,(unsigned long)outr,inmax,outmax);
	  hist->time = now;
	  hist->in = inr; hist->out = outr;
	  hist->inmax = inmax; hist->outmax = outmax;
	  nout++;hist++;	  
	  now = plannow;

	}

	for (x=0; x<MONTH_COUNT; x++) {
	    NEXT(MONTH_SAMPLE);
	    fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		(unsigned long)inr,(unsigned long)outr,inmax,outmax);
	    hist->time = now;
	    hist->in = inr; hist->out = outr;
	    hist->inmax = inmax; hist->outmax = outmax;
	    nout++;hist++;
	    now -= MONTH_SAMPLE;
	}

	plannow=now;	
	plannow /= YEAR_SAMPLE;
	plannow *= YEAR_SAMPLE;

	if (plannow < now) {
	  NEXT((now-plannow));
	  fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		  (unsigned long)inr,(unsigned long)outr,inmax,outmax);
	  hist->time = now;
	  hist->in = inr; hist->out = outr;
	  hist->inmax = inmax; hist->outmax = outmax;
	  nout++;hist++;	  
	  now = plannow;

	}

	for (x=0; x<YEAR_COUNT; x++) {
	    NEXT(YEAR_SAMPLE);
	    fprintf(fo,"%lu %lu %lu %lu %lu\n",now,
		(unsigned long)inr,(unsigned long)outr,inmax,outmax);
	    hist->time = now;
	    hist->in = inr; hist->out = outr;
	    hist->inmax = inmax; hist->outmax = outmax;
	    nout++;hist++;
	    now -= YEAR_SAMPLE;
	}

	if (ferror(fo) || fclose(fo)) {
	    perror(program);
	    fprintf(stderr,"Rateup ERROR: Can't write new log file\n");
	    exit(1);
	}
	/* another fix to get things working under NT */
	if (unlink(buf2)) {
	    fprintf(stderr,"Rateup WARNING: %s Can't remove %s updating log file\n",
		    program,buf2);
	}        
	
	if (rename(buf1,buf2)) {
	    fprintf(stderr,"Rateup WARNING: %s Can't rename %s to %s updating log file\n",
		    program,buf1,buf2);
	}
	if (rename(buf,buf1)) {
	    fprintf(stderr,"Rateup WARNING: %s Can't rename %s to %s updating log file\n",
		    program,buf,buf1);
	}
	for (n=0; n<nout && n < MAX_HISTORY; n++) {
	    history[n] = lhist[n];
	}
    } else {
	perror(program);
	fprintf(stderr,"Rateup ERROR: Can't open %s for write\n",buf);
	exit(1);
    }
    free(lhist);
}

void init_colour(int *colmap, int c0, int c1, int c2) {
  *colmap++ = c0;
  *colmap++ = c1;
  *colmap = c2;
}
	

int main(argc,argv)
int argc;
char **argv;
{
    int x,argi,used,initarg;

    program = argv[0];
    if (argc < 2) {
	fprintf(stderr,"Version: %s\nUsage: %s directory basename [sampletime] [t sampletime] [u|a|g in out abs_max] [i/p file maxv maxx maxy growright step bits]\n",Version,program);
	fprintf(stderr,"Version: %s\nUsage: %s directory basename [t time] [u|a|g in out abs_max] [i/p file maxv maxx maxy growright step bits]\n",Version,program);
	return(1);
    }
    routerpath = argv[1];
    /* this is for NT compatibility, because it does not seem to like
       rename across directories */
    if (chdir(routerpath)) {
    	fprintf(stderr,"Rateup ERROR: Chdir to %s failed ...\n",routerpath);
    	return(1);
    }

    /* Initialiase the colour variables  - should be overwritten */
    init_colour(&col_in[0], c_in);
    init_colour(&col_out[0], c_out);
    init_colour(&col_inm[0], c_inm);
    init_colour(&col_outm[0], c_outm);

    if ((history = calloc(1,sizeof(struct HISTORY)*(MAX_HISTORY + 1))) 
	== NULL) {
      fprintf(stderr,"Rateup ERROR: Out of memory in main\n");
      exit(1);
    }
#ifdef __WATCOMC__
     memset(history,0,sizeof(struct HISTORY)*(MAX_HISTORY + 1));
#endif

    Mh = MAX_HISTORY;

    router = argv[2];
    
    NOW = atol(argv[3]);

    /* from  mrtg-2.x with x>5 rateup calling syntax changed to
       to support time properly ... this is for backward compat
       we check if now is remotely reasonable ... 
       */

    if (NOW > 10*365*24*60*60) {
      initarg=4;
    } else {
      initarg=3;
      time(&NOW);
    }
    readfile();
    used = 1;
    for (argi = initarg; argi < argc; argi += used) {
	switch(argv[argi][0]) {
	    case 'i':	/* Create PPM Image record */
	      image(argv[argi+1], /* Image*/
		    atol(argv[argi+2]),  /* Max Value */
		    atol(argv[argi+3]),  /* xsize maxx */
		    atol(argv[argi+4]),  /* ysize maxy */
		    atof(argv[argi+5]),  /* xscale */
		    atof(argv[argi+6]),  /* yscale */
		    atol(argv[argi+7]),  /* growright */
		    atol(argv[argi+8]),  /* step */
		    atol(argv[argi+9]),  /* bits */
		    0);
	      used = 10;
	      break;
	    case 'p':	/* Create PPM Image record with Peak values*/
		image(argv[argi+1],
		      atol(argv[argi+2]),  /* Max Value */
		      atol(argv[argi+3]),  /* xsize maxx */
		      atol(argv[argi+4]),  /* ysize maxy */
		      atof(argv[argi+5]),  /* xscale */
		      atof(argv[argi+6]),  /* yscale */
		      atol(argv[argi+7]),  /* growright */
		      atol(argv[argi+8]),  /* step */
	   	      atol(argv[argi+9]),  /* bits */
		      1);
		used = 10;
		break;
	    case 'r':	/* Create random records, then update */
		for (x=0; x<histvalid; x++) {
		    history[x].in = rand() % atoi(argv[argi+1]);
		    history[x].out = rand() % atoi(argv[argi+2]);
		}
	    case 'u':	/* Update file */
		update(argv[argi+1],argv[argi+2],atol(argv[argi+3]),0);
		used = 4;
		break;
	    case 'a':	/* Absolute Update file */
		update(argv[argi+1],argv[argi+2],atol(argv[argi+3]),1);
		used = 4;
		break;
	    case 'g':	/* Gauge Update file */
		update(argv[argi+1],argv[argi+2],atol(argv[argi+3]),2);
		used = 4;
		break;
	    case 'W':	/* Week format */
		weekformat = argv[argi+1][0];
		used = 2;
		break;
	    case 'c':	/* Colour Map */
	        sscanf(argv[argi+1],"#%2x%2x%2x", &col_in[0], &col_in[1],
						&col_in[2]);
		sscanf(argv[argi+2],"#%2x%2x%2x", &col_out[0], &col_out[1],
						&col_out[2]);
		sscanf(argv[argi+3],"#%2x%2x%2x", &col_inm[0], &col_inm[1],
						&col_inm[2]);
		sscanf(argv[argi+4],"#%2x%2x%2x", &col_outm[0], &col_outm[1],
						&col_outm[2]);
		used = 5;
		break;
	    case 't':
		NOW = atol(argv[argi+1]);
		used = 2;
		break;
	    case 'l':  /* Legend */
	        { int i; 
	          char * pstr, * qstr;
		  longup = (char *)calloc(1,100); 
		  *longup = 0;
		  /* this rather twisty argument scanning is necesary
		     because NT command.coms rather dumb argument
		     passing .... or because we don't know
		     better. Under Unix we just would say.  if
		     ((sscanf(argv[argi+1],"[%[^]]]", longup); */
		  for (i=1; i<argc; i++) {
		    qstr = argv[argi+i];
		    if (qstr[0] == '[') {
		       qstr++; *longup=0;
		    }
		    if ((strlen(longup)+strlen(qstr)) > (size_t)99) {
		       fprintf(stderr,"Rateup ERROR: Legend to long ... !\n");
		       return(1);
		    }
		    if ((pstr = strchr(qstr, ']')) != NULL) {      
		       *pstr = 0;       
		       strcat (longup,qstr);
		       break;
		    }
		    strcat (longup,qstr);
		    strcat (longup," ");
		  }
		  used = 1+i;
		}
		longup[strlen(longup)]=0; /* remove the last space */
		shortup = longup;
		break;
	    default:
	        fprintf(stderr,"Rateup ERROR: Can't cope with %s, sorry!\n",argv[argi]);
	        return(1);
	}
    }
    return(0);
}



