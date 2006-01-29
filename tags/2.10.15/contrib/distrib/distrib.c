/****************************************************************/
/*                                                              */
/* distrib.c (see readme.html for program explanation)          */
/*                                                              */
/* author : Philippe Simonet, Philippe.Simonet@swiisstelecom.com*/
/*                                                              */
/* change log :                                                 */
/*                                                              */
/* v. 1.00 : initial update (SIP) (23.06.97)                    */
/*                                                              */
/*                                                              */
/*                                                              */


/************************************************************************/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <time.h>
#include "gd.h"
#include "gdfonts.h"

#define FALSE		0
#define TRUE		1

#define	TEXT		1
#define	RECT		2
#define	POLY		3
#define	COLOR		4
#define	COLORDEF	5
#define	LINK		6
#define	COMPOUND	7
#define	ENDCOMPOUND	8
#define	GIFAREA		9
#define	URL			10
#define	IN			11
#define	OUT			12
#define	INOUT		13
#define	UNKNOWN		99


#ifndef max
 #define max(a,b) ((a)>(b))?(a):(b)
#endif

#ifndef min
 #define min(a,b) ((a)<(b))?(a):(b)
#endif

int distcount;
int xsize, ysize, rounds, rate;
int dist[1000][2];

/************************************************************************/
/* analyze command-line options */
static int		optind = 0; 		/* Global argv index. 	*/
static char		*scan = NULL;  		/* Private scan pointer. */
static int		scale = 15;

int getopt1( int argc, char *argv[], char *optstring, char ** optarg )
{
    int 		c;			/* return value */
    char 		*place;
    char    	*index();

    *optarg = NULL;

							/* check argument validity */
    if (scan == NULL || *scan == '\0') {
        if (optind == 0) optind++;
        if (optind >= argc) return EOF;
        place = argv[optind];
        if (place[0] != '-' || place[1] == '\0') return EOF;
        optind++;
        if (place[1] == '-' && place[2] == '\0') return EOF;
        scan = place+1;
    }

    c = *scan++;			/* get option character */
    place = strchr(optstring, c);
    if (place == NULL || c == ':') return '?';


							/* set optarg if needed */
    if (*++place == ':') {
        if (*scan != '\0') {
        	*optarg = scan; scan = NULL;
        } else {
        	*optarg = argv[optind], optind++;
        }
    }
    return c;
}

/************************************************************************/
void computes_distrib ( FILE * fi, int length, int nb, unsigned int maxbytes ) {
	int i,j;
	unsigned long time, in, out, maxin, maxout;

	for ( i = 0; i < length; i ++ ) {
		in = 0; out = 0; 

		/* compute mean on 'nb' items */
		for (j = 0; j < nb; j ++ ) {
			unsigned long wi, wo;

			if (fscanf(fi,"%lu %lu %lu %lu %lu\n",&time,&wi,&wo,&maxin, &maxout) != 5) {
				printf ( "config file error !!!\n" );
			} else {
				in += wi; out += wo;
			}
		}

		in /= nb; out /= nb;

		if ( in  >= maxbytes ) in  = maxbytes-1;
		if ( out >= maxbytes ) out = maxbytes-1;

		dist[(( in*distcount)/maxbytes)][0] ++;
		dist[((out*distcount)/maxbytes)][1] ++;
	}

};

/************************************************************************/
/* in case of trouble ...                                               */
void print_error ( void )
{ 
	fprintf ( stderr, "Read mrtg log files and build distribution graphs.\n" );
	fprintf ( stderr, "Version 1.1, 27.06.97.\n" );
	fprintf ( stderr, "Use : case 1 : (1 distr. log file)\n" );
	fprintf ( stderr, "  distrib -i logfile -o gfile -w width -h height -t type -r rate -d count\n" );
	fprintf ( stderr, "   ifile : input log file name,\n" );
	fprintf ( stderr, "   gfile : output gif file (will be overwritten),\n" );
	fprintf ( stderr, "   count : histogram count,\n" );
	fprintf ( stderr, "   rate : line rate,\n" );
	fprintf ( stderr, "   type : length of measurement (d/w/m/y).\n" );
	fprintf ( stderr, "Use : case 2 : (distr. from distrib. file)\n" );
	fprintf ( stderr, "  distrib -i distrib -o gfile -w width -h height -t x -r top -d count\n" );
	fprintf ( stderr, "   ifile : input distribution summary file name,\n" );
	fprintf ( stderr, "   gfile : output gif file (will be overwritten),\n" );
	fprintf ( stderr, "   top : how may top n,\n" );
	fprintf ( stderr, "   count : histogram count,\n" );
	fprintf ( stderr, "   type : 'x'.\n" );
}

/************************************************************************/
#define r(color) ((color&0x0000ff)>>0)
#define g(color) ((color&0x00ff00)>>8)
#define b(color) ((color&0xff0000)>>16)
#define rgb(color) ((color&0x0000ff)>>0),((color&0x00ff00)>>8),((color&0xff0000)>>16)

/************************************************************************/
/* build a color or find the nearest color in the color table           */ 
int find_color ( gdImagePtr graph, int color ) {
	int i_col;

	if ( (i_col = gdImageColorExact(graph,r(color), g(color), b(color))) == -1 ) {
		if ( (i_col = gdImageColorAllocate(graph,r(color), g(color), b(color))) == -1 ) {
			i_col = gdImageColorClosest(graph,r(color), g(color), b(color));
		}
	}
	return (i_col);
}


/************************************************************************/
/* draw the gif file */
void draw_distrib_gif ( FILE * score, FILE * gif )
{
	#define c_blank 245,245,245	/* base colors */
	#define c_light 194,194,194
	#define c_dark 100,100,100
	#define c_black 0,0,0
	#define c_white 255,255,0
	#define c_blue 0,0,255
	#define c_red 255,0,0
	#define c_green 0,255,0

    gdImagePtr graph;
	int i_light,i_dark,i_blank, i_black, i_white, i_blue, i_red, i_green;
	int color[4000][2];

    graph = gdImageCreate(xsize, ysize);

    /* the first color allocated will be the background color. */

    i_blank = gdImageColorAllocate(graph,c_blank);
    i_light = gdImageColorAllocate(graph,c_light);
    i_dark = gdImageColorAllocate(graph,c_dark);

    gdImageInterlace(graph, 1); 

    i_black = gdImageColorAllocate(graph,c_black);
    i_white = gdImageColorAllocate(graph,c_white);
    i_red = gdImageColorAllocate(graph,c_red);
    i_green = gdImageColorAllocate(graph,c_green);
    i_blue = gdImageColorAllocate(graph,c_blue);


	{ 
		int i;
		for (i = 0; i <= distcount; i++ ) {
			color[distcount - i - 1][0] = gdImageColorAllocate(graph, (255*i)/distcount, 255, (255*i)/distcount);
		}
		for (i = 0; i <= distcount; i++ ) {
			color[distcount - i - 1][1] = gdImageColorAllocate(graph, (255*i)/distcount, (255*i)/distcount, 255);
		}
	}


    /* draw the image border */
    gdImageLine(graph,0,0,xsize-1,0,i_light);
    gdImageLine(graph,1,1,xsize-2,1,i_light);
    gdImageLine(graph,0,0,0,ysize-1,i_light);
    gdImageLine(graph,1,1,1,ysize-2,i_light);
    gdImageLine(graph,xsize-1,0,xsize-1,ysize-1,i_dark);
    gdImageLine(graph,0,ysize-1,xsize-1,ysize-1,i_dark);
    gdImageLine(graph,xsize-2,1,xsize-2,ysize-2,i_dark);
    gdImageLine(graph,1,ysize-2,xsize-2,ysize-2,i_dark);

	{									/* date the graph */
		struct tm *newtime;
		time_t aclock;
		time( &aclock );				/* Get time in seconds */
		newtime = localtime( &aclock ); /* Convert time to struct */
										/* tm form */

		gdImageString(graph, gdFontSmall,gdFontSmall->w,3,asctime( newtime ),i_dark);
	};
	

	/*i_col = find_color(graph, colortable[pcurrententry->color]);
      gdImageFilledRectangle(graph,	
				pcurrententry->coords[0],
				pcurrententry->coords[1],
				pcurrententry->coords[2],
				pcurrententry->coords[3],i_col2);
	 }
	gdImageString(graph, gdFontSmall,
		pcurrententry->coords[0],
		pcurrententry->coords[1],
		pcurrententry->str,
		i_col );
	gdImageStringUp(graph, gdFontSmall,
		pcurrententry->coords[0],
		pcurrententry->coords[1],
		pcurrententry->str,
		i_col );


   gdImagePtr brush_2pix;
    brush_2pix = gdImageCreate(2,2);
	gdImageColorAllocate(
			brush_2pix,
			r(colortable[colorratetable[pcurrententry->rate]]),
			g(colortable[colorratetable[pcurrententry->rate]]),
			b(colortable[colorratetable[pcurrententry->rate]]) );
	gdImageSetBrush(graph, brush_2pix);
	i_col = gdBrushed;
	gdImageLine(graph,	x, y, x2, y2,i_col);
    gdImageDestroy(brush_2pix);*/

	/* draw axes and graphs */
	{
		int w = gdFontSmall->w, h = gdFontSmall->h, i, j, k, incrx, incry;
		char str[4000];
		int nbaxesx = (rate + 1);
		int nbaxesy = 6;
		int textx = 7;
		int texty = 15;

		incry = (ysize-(h*2)-(w*texty))/(nbaxesy-1); 
		incrx = (xsize-(w*(textx+2)))/(nbaxesx-1);
		j = 100;
		for ( i = h*2; i <= ((h*2) + (incry * (nbaxesy-1))) ; i+= incry ) {
			gdImageLine(graph,w*textx,i,w*textx + (incrx*(nbaxesx-1)),i,i_black); /* horizontal */
			sprintf ( str, "%3u%%", j ); j-= 100/(nbaxesy-1);
			gdImageString(graph, gdFontSmall,w,i-h/2,str,i_black );
			}
		j = 0;
		for ( i = w*7; i <= ((w*7) + (incrx * (nbaxesx-1))) ; i+= incrx ) {
			/*gdImageLine(graph,i,h*2,i,h*2 + (incry*(AXESY-1)),i_black);*/ /* vertical */
			/*sprintf ( str, "%3u%%", j ); j+= (100/(AXESX-1));
			gdImageStringUp(graph, gdFontSmall, i - w/2, ysize - h, str, i_black );*/
		}


		for ( i = 0; i < rate; i ++ ) {
			char *name,*ptr;
			int tin=0, tout=0;
			int x1, x2, y1, y2, mrgx;

			if ( fscanf ( score, "%s", str ) == EOF ) break;
			/*printf ( "%s\n", str );*/
			name = str;

			if ((ptr = strtok( str, ":")) == NULL) continue;
			/*printf ( "%s:", name );*/

			for ( j = 0; j < distcount; j++ ) {

				dist[j][0] = dist[j][0] = 0;
				
				if ((ptr = strtok( NULL, "/,")) == NULL) continue;
				dist[j][0] = atoi(ptr); tin += dist[j][0];
				
				if ((ptr = strtok( NULL, "/,")) == NULL) continue;
				dist[j][1] = atoi(ptr); tout += dist[j][1];

				/*printf ( "%u/%u,",dist[j][0],dist[j][1]  );*/
			}

			/*printf ( "\n" );*/

			/* draw label and graphs */
			mrgx = incrx/5;
			x1 = (w*textx) + (i*incrx) + (incrx/2) - (h/2);
			y1 = ysize-h;
			gdImageStringUp( graph, gdFontSmall, x1, y1, str, i_black );
			for (k = 0; k < 2; k ++ ) {
				y1 = ysize-((texty-4) * w);
				if ( k == 0 ) {
					x1 = (w*textx) + (i*incrx) + mrgx;
					x2 = x1 + (incrx/3);
					gdImageStringUp( graph, gdFontSmall, x1, y1, "in", i_black );
				} else {
					x2 = (w*textx) + ((i+1)*incrx) - mrgx;
					x1 = x2 - (incrx/3);
					gdImageStringUp( graph, gdFontSmall, x1, y1, "out", i_black );
				}

				y2 = h*2 + (incry*(nbaxesy-1));
				for ( j = distcount-1; j >=0 ; j-- ) {
					y1 = y2 - (((ysize-(h*2)-(w*texty) - 2) * dist[j][k]) / tin);
					if (j == 0) { /* 'correct' cumulative error */
						y1 = h*2;
					}
					gdImageFilledRectangle(graph, x1, y1, x2, y2,color[j][k]);
					gdImageRectangle(graph, x1, y1, x2, y2,i_black);
					y2 = y1;
				}
			}

			/*

			int x1, x2, y1, y2, mrgx;
			mrgx = incrx/5;

			x1 = (w*7) + (i*incrx) + mrgx;
			x2 = x1 + (incrx/3);
			y2 = h*2 + (incry*(AXESY-1)) - 2;
			y1 = y2 - (((ysize-(h*2)-(w*7) - 2) * dist[i][0]) / rounds);
			gdImageFilledRectangle(graph, x1, y1, x2, y2,i_green);
			gdImageRectangle(graph, x1, y1, x2, y2,i_dark);

			x2 = (w*7) + ((i+1)*incrx) - mrgx;
			x1 = x2 - (incrx/3);
			y2 = h*2 + (incry*(AXESY-1)) - 2;
			y1 = y2 - (((ysize-(h*2)-(w*7) - 2) * dist[i][1]) / rounds);
			gdImageFilledRectangle(graph, x1, y1, x2, y2,i_blue);
			gdImageRectangle(graph, x1, y1, x2, y2,i_dark);
			*/
		}
	}
	

    gdImageGif(graph, gif);    

    gdImageDestroy(graph);
}


/************************************************************************/
/* draw the gif file, based on the tentry desciption                    */
void draw_gif ( FILE * gif )
{
	#define c_blank 245,245,245	/* base colors */
	#define c_light 194,194,194
	#define c_dark 100,100,100
	#define c_black 0,0,0
	#define c_white 255,255,0
	#define c_blue 0,0,255
	#define c_red 255,0,0
	#define c_green 0,255,0

    gdImagePtr graph;
	int i_light,i_dark,i_blank, i_black, i_white, i_blue, i_red, i_green;

    graph = gdImageCreate(xsize, ysize);

    /* the first color allocated will be the background color. */
    i_blank = gdImageColorAllocate(graph,c_blank);
    i_light = gdImageColorAllocate(graph,c_light);
    i_dark = gdImageColorAllocate(graph,c_dark);

    gdImageInterlace(graph, 1); 

    i_black = gdImageColorAllocate(graph,c_black);
    i_white = gdImageColorAllocate(graph,c_white);
    i_red = gdImageColorAllocate(graph,c_red);
    i_green = gdImageColorAllocate(graph,c_green);
    i_blue = gdImageColorAllocate(graph,c_blue);

    /* draw the image border */
    gdImageLine(graph,0,0,xsize-1,0,i_light);
    gdImageLine(graph,1,1,xsize-2,1,i_light);
    gdImageLine(graph,0,0,0,ysize-1,i_light);
    gdImageLine(graph,1,1,1,ysize-2,i_light);
    gdImageLine(graph,xsize-1,0,xsize-1,ysize-1,i_dark);
    gdImageLine(graph,0,ysize-1,xsize-1,ysize-1,i_dark);
    gdImageLine(graph,xsize-2,1,xsize-2,ysize-2,i_dark);
    gdImageLine(graph,1,ysize-2,xsize-2,ysize-2,i_dark);

	{									/* date the graph */
		struct tm *newtime;
		time_t aclock;
		time( &aclock );				/* Get time in seconds */
		newtime = localtime( &aclock ); /* Convert time to struct */
										/* tm form */

		gdImageString(graph, gdFontSmall,gdFontSmall->w,3,asctime( newtime ),i_dark);
	};
	

	/*i_col = find_color(graph, colortable[pcurrententry->color]);
      gdImageFilledRectangle(graph,	
				pcurrententry->coords[0],
				pcurrententry->coords[1],
				pcurrententry->coords[2],
				pcurrententry->coords[3],i_col2);
	 }
	gdImageString(graph, gdFontSmall,
		pcurrententry->coords[0],
		pcurrententry->coords[1],
		pcurrententry->str,
		i_col );
	gdImageStringUp(graph, gdFontSmall,
		pcurrententry->coords[0],
		pcurrententry->coords[1],
		pcurrententry->str,
		i_col );


   gdImagePtr brush_2pix;
    brush_2pix = gdImageCreate(2,2);
	gdImageColorAllocate(
			brush_2pix,
			r(colortable[colorratetable[pcurrententry->rate]]),
			g(colortable[colorratetable[pcurrententry->rate]]),
			b(colortable[colorratetable[pcurrententry->rate]]) );
	gdImageSetBrush(graph, brush_2pix);
	i_col = gdBrushed;
	gdImageLine(graph,	x, y, x2, y2,i_col);
    gdImageDestroy(brush_2pix);*/

	/* draw axes and graphs */
	{
		int w = gdFontSmall->w, h = gdFontSmall->h, i, j, incrx, incry, maxio;
		char str[20];
		#define AXESX (distcount + 1)
		#define AXESY 6

		maxio = 0;
		for ( i = 0; i < distcount; i ++ ) {
			if (maxio < dist[i][0]) maxio = dist[i][0];
			if (maxio < dist[i][1]) maxio = dist[i][1];
		}
		
		incry = (ysize-(h*2)-(w*7))/(AXESY-1); incrx = (xsize-(w*9))/(AXESX-1);
		j = 100;
		for ( i = h*2; i <= ((h*2) + (incry * (AXESY-1))) ; i+= incry ) {
			gdImageLine(graph,w*7,i,w*7 + (incrx*(AXESX-1)),i,i_black); /* horizontal */
			sprintf ( str, "%3u%%", j ); j-= 100/(AXESY-1);
			gdImageString(graph, gdFontSmall,w,i-h/2,str,i_black );
			}
		j = 0;
		for ( i = w*7; i <= ((w*7) + (incrx * (AXESX-1))) ; i+= incrx ) {
			gdImageLine(graph,i,h*2,i,h*2 + (incry*(AXESY-1)),i_black); /* vertical */
			sprintf ( str, "%3u%%", j ); j+= (100/(AXESX-1));
			gdImageStringUp(graph, gdFontSmall, i - w/2, ysize - h, str, i_black );
		}


		for ( i = 0; i < distcount; i ++ ) {
			int x1, x2, y1, y2, mrgx;
			mrgx = incrx/5;

			x1 = (w*7) + (i*incrx) + mrgx;
			x2 = x1 + (incrx/3);
			y2 = h*2 + (incry*(AXESY-1)) - 2;
			y1 = y2 - (((ysize-(h*2)-(w*7) - 2) * dist[i][0]) / rounds);
			/* printf ( "x1 %u, y1 %u, x2 %u, y2 %u.\n", x1, y1, x2, y2 );*/
			gdImageFilledRectangle(graph, x1, y1, x2, y2,i_green);
			gdImageRectangle(graph, x1, y1, x2, y2,i_dark);

			x2 = (w*7) + ((i+1)*incrx) - mrgx;
			x1 = x2 - (incrx/3);
			y2 = h*2 + (incry*(AXESY-1)) - 2;
			y1 = y2 - (((ysize-(h*2)-(w*7) - 2) * dist[i][1]) / rounds);
			/* printf ( "x1 %u, y1 %u, x2 %u, y2 %u.\n", x1, y1, x2, y2 );*/
			gdImageFilledRectangle(graph, x1, y1, x2, y2,i_blue);
			gdImageRectangle(graph, x1, y1, x2, y2,i_dark);
		}
	}
	
    gdImageGif(graph, gif);    

    gdImageDestroy(graph);
}		





/************************************************************************/
void main ( int argc, char * argv[] )
{
	FILE			*config = NULL, *gif = NULL;		
	char 			*sconfig = NULL, *sgif = NULL;
	char 			*optarg;
	char			type;
	int				i; 

	/* globals */
	xsize = 400, ysize = 150; type = 'd'; rate = 1250000; distcount = 10;

	do	{
		/***************************************************************/
		/* 0 : read program arguments */
		while ( ( i = getopt1( argc, argv, "o:i:t:w:h:r:d:", &optarg ) ) != EOF ) {
			switch ( i ) {
				case 'i':
					sconfig = optarg;
					break;
				case 'o':			
					sgif = optarg;
					break;
				case 'w':			
					if ( optarg != NULL ) { 
						xsize = atoi (optarg);
					}
					break;
				case 'r':			
					if ( optarg != NULL ) { 
						rate = atoi (optarg);
					}
					break;
				case 'd':			
					if ( optarg != NULL ) { 
						distcount = atoi (optarg);
					}
					break;
				case 'h':			
					if ( optarg != NULL ) { 
						ysize = atoi (optarg);
					}
					break;
				case 't':			
					if ( optarg != NULL ) type = optarg[0];

					if (type != 'd' && type != 'm' && type != 'w' && type != 'y' && type != 'x' ) {
						print_error();
						exit (0);
					}
					break;
				case '?':			
					print_error();
					exit (0);
					break;
				default:
					break;
			}
		}
	
		
		if ( sgif == NULL || sconfig == NULL ) {
			print_error();
			break;
		}


		/***************************************************************/
		/* 1 : OPEN FILES */
		gif = fopen ( sgif, "wb" );
		if ( gif == NULL ) {
			fprintf ( stderr, "Error opening %s.\n", sgif );
			fclose ( config );
			break;
		}

		config = fopen ( sconfig, "r" );
		if ( config == NULL ) {
			fprintf ( stderr, "Error opening %s.\n", sconfig );
			break;
		}

		if ( type != 'x' ) {
	
			/***************************************************************/
			for ( i = 0; i < distcount; i ++ ) {
				dist[i][0] = 0;	dist[i][1] = 0;
			}
			{	/* read first line ... */
				unsigned long time, in, out;
				fscanf ( config, "%lu %lu %lu\n", &time, &in, &out ); /* read first line */
			}
			switch ( type ) {
			case 'd':
				computes_distrib ( config, 288,  1, rate );
				rounds = 288;								/* 288 * 5' = 24 hours */
				break;
			case 'w':
				computes_distrib ( config, 100,  6, rate ); /* 600 * 5', with mean on 6  (30')*/
				computes_distrib ( config, 236,  1, rate );
				rounds = 336;								/* 336 * 30' = 7 days */
				break;
			case 'm':
				computes_distrib ( config,  25, 24, rate ); /* 600 * 5', with mean on 24 (2hours) */
				computes_distrib ( config, 150,  4, rate ); /* 600 *30', with mean on 4 */
				computes_distrib ( config, 185,  1, rate );
				rounds = 360;								/* 260 * 2 hours = 30 days */
				break;
			case 'y':
				computes_distrib ( config,   2,300, rate ); /* 600 * 5', with mean on 300  ~= 1 day */
				computes_distrib ( config,  12, 50, rate ); /* 600 *30', with mean on 50 ~= 1 day */
				computes_distrib ( config,  50, 12, rate ); /* 600 * 2h, with mean on 12 */
				computes_distrib ( config, 300,  1, rate );
				rounds = 364;
				break;
			}
	
			for ( i = 0; i < distcount; i ++ ) {
				printf ( "%u:%u,%u.\n", i, dist[i][0],dist[i][1] );
			}
	
			/***************************************************************/
			draw_gif ( gif );
			/***************************************************************/
			fclose ( gif );
			fclose ( config );
	
			break;
		} else {
			draw_distrib_gif ( config, gif );
			fclose ( config );
			fclose ( gif );
			break;
		}

	} while ( TRUE );

}

