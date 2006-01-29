/****************************************************************/
/*                                                              */
/* rdlog2.c (see readme.html for program explanation            */
/*                                                              */
/* author : Philippe Simonet, sip00@vg.swissptt.ch              */
/*                                                              */
/* change log :                                                 */
/*                                                              */
/* v. 1.00 : initial update (SIP) (02.12.97                     */
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


int colorratetable[256];

int colortable[256] = {
			0x000000,	/* 0  BLACK */
			0xff0000,	/* 1  BLUE */
			0x00ff00,	/* 2  GREEN*/
			0xffff00,	/* 3  CYAN */
			0x0000ff,	/* 4  RED */
			0xff00ff,	/* 5  MAGENTA */
			0x00ffff,	/* 6  YELLOW */
			0xffffff,	/* 7  WHITE */
			0x900000,	/* 8  Blue4 */
			0xb00000,	/* 9  Blue3 */
			0xd00000,	/* 10 Blue2 */
			0xffce87,	/* 11 LtBlue */
			0x009000,	/* 12 Green4 */
			0x00b000,	/* 13 Green3 */
			0x00d000,	/* 14 Green2 */
			0x909000,	/* 15 Cyan4 */
			0xb0b000,	/* 16 Cyan3 */
			0xd0d000,	/* 17 Cyan2 */
			0x000090,	/* 18 Red4 */
			0x0000b0,	/* 19 Red3 */
			0x0000d0,	/* 20 Red2 */
			0x900090,	/* 21 Magenta4 */
			0xb000b0,	/* 22 Magenta3 */
			0xd000d0,	/* 23 Magenta2 */
			0x003080,	/* 24 Brown4 */
			0x0040a0,	/* 25 Brown3 */
			0x0060c0,	/* 26 Brown2 */
			0x8080ff,	/* 27 Pink4 */
			0xa0a0ff,	/* 28 Pink3 */
			0xc0c0ff,	/* 29 Pink2 */
			0xe0e0ff,	/* 30 Pink */
			0x00d7ff	/* 31 gold */
};

/************************************************************************/
/* each of these entry contain the description of a graphical object    */
struct sentry {
	int		type;			/* text, line, link, poly */
	int		depth;			/* order in which it appears */
	char	* str;			/* log file name, url, text */
	int		maxrate;		/* max xfer rate */
	int		rate;			/* max xfer rate */
	int		orientation;	/* text orientation, ... */
	int		color;			/* color */
	int		fillcolor;		/* color */
	int		colorindex;		/* color index */
	int		npoints;		/* fig size */	
	int		* coords;		/* coordinates list */
	struct sentry * next;	/* next entry */
}; 

int xsize, ysize, rounds, xoffset, yoffset;
struct sentry * pfirstentry, *pcurrententry, *pareaentry;

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
/* computes a traffic in % by reading 'rounds' lines in a MRTG log file */
/* currently, it takes the maximum of the In or OUT traffic.            */
void read_entry ( struct sentry * pentry) {

	FILE	* logf;
	int		i, j=0, k=0;

	logf = fopen ( pentry->str, "r" );
	if ( pentry->maxrate == 0 ) {
		fprintf ( stderr, "Max rate for %s is null.\n", pentry->str );
		return;
	}		

	if ( logf != NULL ) {
		fscanf(logf, "%*d %d %d", &j, &k);					/* get first line */

		for ( i = 0; i < rounds; i ++ ) {					/* computes mean */
			fscanf(logf, "%*d %d %d %*d %*d", &j, &k);		/* get line */
			/*printf(" - [%d %d]\n", j, k);*/
			switch (pentry->orientation) {
			case IN:
				pentry->rate += j;
				break;
			case OUT:
				pentry->rate += k;
				break;
			default:
				if ( j > k )	pentry->rate += j;
				else			pentry->rate += k;
				break;
			}
		}		
											/* computes the rate 0-9 */
		pentry->rate = pentry->rate / rounds; 
		/*printf ( "%s : %u, %u.\n", pentry->str, (pentry->maxrate*100)/pentry->maxrate, (pentry->rate*10)/pentry->maxrate );*/
		pentry->rate  = (pentry->rate * 10) / pentry->maxrate;
		if ( pentry->rate > 9 ) pentry->rate = 9;
		if ( pentry->rate < 0 ) pentry->rate = 0;
		fclose ( logf );
	} else {
		fprintf ( stderr, "Cannot open file %s.\n", pentry->str );
	};
}

/************************************************************************/
/* in case of trouble ...                                               */
void print_error ( void )
{ 
	fprintf ( stderr, "Read mrtg configuration files and convert them in gif format.\n" );
	fprintf ( stderr, "Use :\n" );
	fprintf ( stderr, "  rdlog -i cfile -o gfile [-m mapfile] -r rounds\n" );
	fprintf ( stderr, "   ifile : input fig file name,\n" );
	fprintf ( stderr, "   gfile : output gif file (will be overwritten),\n" );
	fprintf ( stderr, "   mapfile : output map file (optional, will be overwritten),\n" );
	fprintf ( stderr, "   rounds : number of 5 min intervals to take.\n" );
}

/************************************************************************/
/* free an 'entry' variable                                             */
void free_entry (struct sentry * pentry) {
	if ( pentry!= NULL ) {
		if ( pentry->str != NULL ) free(pentry->str); pentry->str = NULL;
		if ( pentry->coords != NULL ) free(pentry->coords); pentry->coords = NULL;
		free(pentry);
	}
}


/************************************************************************/
/* print an entry for debug purpose                                     */
void print_entry (struct sentry * pentry) {

	printf ( "Entry : " );
	if ( pentry->str != NULL )	printf ( "str '%s' ", pentry->str );
	printf ( ".\n type %i, maxrate %i, orientation %i, npoints %i, color %i, depth %i.\n",
		pentry->type,pentry->maxrate,pentry->orientation,pentry->npoints,pentry->color,pentry->depth );
}

/************************************************************************/
int new_entry( void ) {

	struct sentry * pentry;

	if ( ( pentry = malloc ( sizeof (struct sentry) )) == NULL ) {
		fprintf ( stderr, "Error : memory allocation failure.\n" );
		return ( FALSE );
	}

	if ( pfirstentry == NULL ) {
		pfirstentry = pentry;
	} else {
		pcurrententry->next = pentry;
	}

	pentry->type		=	UNKNOWN;		
	pentry->str			=	NULL;		
	pentry->maxrate		=	0;	
	pentry->rate		=	0;		
	pentry->orientation	=	0;
	pentry->color		=	0;	
	pentry->fillcolor	=	0;	
	pentry->depth		=	0;	
	pentry->colorindex	=	0;	
	pentry->npoints		=	0;
	pentry->coords		=	NULL;
	pentry->next		=	NULL;

	pcurrententry = pentry;

return ( TRUE );
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
/* draw the gif file, based on the tentry desciption                    */
void draw_gif ( FILE * gif )
{
	#define c_blank 245,245,245	/* base colors */
	#define c_light 194,194,194
	#define c_dark 100,100,100
	#define c_black 0,0,0
	#define c_white 255,255,0

    gdImagePtr graph;
	int i_light,i_dark,i_blank, i_black, i_white;
	int bkcolor;

    graph = gdImageCreate(xsize, ysize);

    /* the first color allocated will be the background color. */
	bkcolor = colortable[pareaentry->fillcolor];
    i_blank = gdImageColorAllocate(graph,rgb(bkcolor));
    i_light = gdImageColorAllocate(graph,c_light);
    i_dark = gdImageColorAllocate(graph,c_dark);

    gdImageInterlace(graph, 1); 

    i_black = gdImageColorAllocate(graph,c_black);
    i_white = gdImageColorAllocate(graph,c_white);

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

		gdImageString(graph, gdFontSmall,3,3,asctime( newtime ),i_dark);
	};
	

	while ( 1 ) {
		int i_col, i_col2, depth;
		struct sentry * pentry;

		/* find smallest depth */
		pentry = pfirstentry;
		depth = -1;
		while ( pentry != NULL ) {
			if (pentry->depth > depth) {
				depth = pentry->depth;
				pcurrententry = pentry;
			}
			pentry = pentry->next;
		}
		if ( depth == -1 ) break;
		pcurrententry->depth = -1;

		/* draw this fig */
		switch ( pcurrententry->type) {
		case RECT:
			i_col = find_color(graph, colortable[pcurrententry->color]);


			if ( pcurrententry->fillcolor != -1 ) {

				i_col2 = find_color(graph, colortable[pcurrententry->fillcolor]);

				gdImageFilledRectangle(graph,	
									pcurrententry->coords[0],
									pcurrententry->coords[1],
									pcurrententry->coords[2],
									pcurrententry->coords[3],i_col2);
			}

			gdImageRectangle(graph,	
								pcurrententry->coords[0],
								pcurrententry->coords[1],
								pcurrententry->coords[2],
								pcurrententry->coords[3],i_col);
			break;
		case TEXT:
			i_col = find_color(graph, colortable[pcurrententry->color]);
			if (pcurrententry->orientation == 0) {
				gdImageString(graph, gdFontSmall,
					pcurrententry->coords[0],
					pcurrententry->coords[1],
					pcurrententry->str,
					i_col );
			} else {
				gdImageStringUp(graph, gdFontSmall,
					pcurrententry->coords[0],
					pcurrententry->coords[1],
					pcurrententry->str,
					i_col );
			}
			break;
		case POLY:
		case LINK:
			{
				int x = pcurrententry->coords[0];
				int y = pcurrententry->coords[1];
				int x2, y2, j, k;
				gdImagePtr brush_2pix;

				if (pcurrententry->type == POLY) {
					i_col = find_color(graph, colortable[pcurrententry->color]);
				} else {
					brush_2pix = gdImageCreate(2,2);
					gdImageColorAllocate(
						brush_2pix,
						r(colortable[colorratetable[pcurrententry->rate]]),
						g(colortable[colorratetable[pcurrententry->rate]]),
						b(colortable[colorratetable[pcurrententry->rate]]) );
				    gdImageSetBrush(graph, brush_2pix);
					i_col = gdBrushed;
				}
	
				k = 2;
				for ( j = 1; j < pcurrententry->npoints; j ++ ) {
					x2 = pcurrententry->coords[k++];
					y2 = pcurrententry->coords[k++];
					gdImageLine(graph,	x, y, x2, y2,i_col);
					x = x2; y = y2;
				};

				if (pcurrententry->type == LINK) {
				    gdImageDestroy(brush_2pix);
				};
			
			}

			break;
		default:
			break;
		}
		pcurrententry = pcurrententry->next;
	}

    gdImageGif(graph, gif);    

    gdImageDestroy(graph);
}		


struct sfigrec {
	int		type;
	char	text[500];
	int		colorindex;
	int		depth;
	int		color;
	int		fillcolor;
	int		angle;
	int		coords[500];
	int		npoints;
}; 


/************************************************************************/
int getfig ( FILE * config, struct sfigrec * fig ) 
{
	char		buf[1000], str[1000], *s;
	int			i, n, type, color, colorindex, depth, pen_style, font, flags, x, y;
	int			style, thickness, pen_color, fill_color, fill_style, join_style, cap_style, radius, fa, ba, npts;
	float		tx_size, angle, style_val;

	fig->type = UNKNOWN;

	if ( fgets (buf, 1000, config ) == NULL ) {
		return ( TRUE );
	}

	switch ( buf[0] ) {
	case '0':	/* color ref */
			n = sscanf(buf, "%*d %d #%06x", &colorindex, &color );
			/*printf ( "colordef : %d, %d.\n", colorindex, color );*/
			fig->type = COLORDEF;
			fig->color = ((color & 0xff0000)>>16) | (color & 0x00ff00) | ((color & 0x0000ff)<<16);
			fig->colorindex = colorindex;
			break;
	case '2':	/* polyline */
			n = sscanf(buf, "%*d%d%d%d%d%d%d%d%d%f%d%d%d%d%d%d",
				   &type, &style, &thickness, &pen_color, &fill_color,
				   &depth, &pen_style, &fill_style, &style_val,
				   &join_style, &cap_style, &radius, &fa, &ba, &npts);
			/*puts ( buf );*/
			/*printf ("type %d, style %d, thickness %d, pen_color %d, fill_color %d, depth %d, pen_style %d, fill_style %d, style_val %f, join_style %d, cap_style %d, radius %d, fa %d, ba %d, npts %d ",
				   type, style, thickness, pen_color, fill_color,
				   depth, pen_style, fill_style, style_val,
				   join_style, cap_style, radius, fa, ba, npts);*/
			fig->depth = depth;
			fig->color = pen_color;
			fig->npoints = npts;
			for ( i = 0; i < npts; i ++ ) {
				fscanf(config, "%d%d", &x, &y);
				fig->coords[i*2] = x; fig->coords[i*2+1] = y;
				/*printf ( "[%d %d] ", x, y );*/
			}
			fig->type = POLY;
			if ( type == 2 ) { /* rectangle */
				fig->type = RECT;
				if ( fill_style == -1 ) {
					fig->fillcolor = -1;
				} else {
					fig->fillcolor = fill_color;
				}
				x = min(fig->coords[0],fig->coords[4]);
				y = min(fig->coords[1],fig->coords[5]);
				fig->coords[2] = max(fig->coords[0],fig->coords[4]);
				fig->coords[3] = max(fig->coords[1],fig->coords[5]);
				fig->coords[0] = x;
				fig->coords[1] = y;
				fig->npoints = 2;
			}
			/*printf ( ".\n" );*/
			break;
	case '4':	/* text */
			n = sscanf(buf, "%*d%d%d%d%d%d%f%f%d%*f%*f%d%d %[^\n]",
				&type, &color, &depth, &pen_style, &font, &tx_size, &angle,	&flags, &x, &y, str);
			s = strstr ( str, "\\001" );
			if ( s != NULL ) s[0] = 0;
			/*printf ( "text : type %d, color %d, depth %d, pen_style %d, font %d, ty_size %f, angle %f, flags %d, x %d, y %d, s [%s].\n",
				type, color, depth, pen_style, font, tx_size, angle, flags, x, y, str );*/
			fig->type = TEXT;
			strcpy (fig->text, str);
			fig->depth = depth;
			fig->color = color;
			if ( angle < 1) {
				fig->angle = 0;
				fig->coords[0] = x;
				fig->coords[1] = y-150;
			} else {
				fig->angle = 1;
				fig->coords[0] = x-150;
				fig->coords[1] = y;
			}
			fig->npoints = 1;
			break;
	case '6':	/* compound */
			fig->type = COMPOUND;
			/*printf ( "compound.\n" );*/
			break;
	case '-':	/* compound end */
			fig->type = ENDCOMPOUND;
			/*printf ( "end of compound.\n" );*/
			break;
	default:
			break;
	}
	
	return ( FALSE );

}


/************************************************************************/
void main ( int argc, char * argv[] )
{
	FILE			*config = NULL, *gif = NULL, *map = NULL;		
	char 			*sconfig = NULL, *sgif = NULL, *smap = NULL;
	char 			*optarg;
	int				i; 

	/* globals */
	xsize = 100, ysize = 100;
	rounds = 6;

	do	{
		/***************************************************************/
		/* 0 : read program arguments */
		while ( ( i = getopt1( argc, argv, "o:i:r:m:", &optarg ) ) != EOF ) {
			switch ( i ) {
				case 'i':
					sconfig = optarg;
					break;
				case 'o':			
					sgif = optarg;
					break;
				case 'm':			
					smap = optarg;
					break;
				case 'r':			
					rounds = atoi (optarg);
					if ( rounds < 1 ) {
						print_error();
						exit (0);
					};
					break;
				case '?':			
					print_error();
					exit (0);
					break;
				default:
					break;
			}
		}


		if ( sconfig == NULL || sgif == NULL ) {
			print_error();
			break;
		}

	
		/***************************************************************/
		/* 1 : OPEN FILES */
		config = fopen ( sconfig, "r" );
		if ( config == NULL ) {
			fprintf ( stderr, "Error opening %s.\n", sconfig );
			break;
		}

		gif = fopen ( sgif, "wb" );
		if ( gif == NULL ) {
			fprintf ( stderr, "Error opening %s.\n", sgif );
			fclose ( config );
			break;
		}

		if ( smap != NULL ) {
			map = fopen ( smap, "w" );
			if ( map == NULL ) {
				fprintf ( stderr, "Error opening %s.\n", sgif );
				fclose ( config );
				fclose ( gif );
				break;
			}
			fprintf ( map, "  <map name=\"map1\">\n" );
		}


		/***************************************************************/
		/* 2 : SCAN CONFIG FILE */
		pcurrententry = NULL; pfirstentry = NULL; pareaentry = NULL;
		for ( i = 0; i < 256; i++ ) {
			colorratetable[i] = 0;
		}
		for ( i = 32; i < 256; i++ ) {
			colortable[i] = 0;
		}

		while ( TRUE ) {
			struct sfigrec	figrec;

			/********************************************/
			/* get one fig record */
			if ( getfig ( config, &figrec ) == TRUE ) break;

			switch (figrec.type) {
			case COLORDEF:
				if ( figrec.colorindex < 256 ) colortable[figrec.colorindex] = figrec.color;
				/*printf ( "color table[%i] : %i.\n", figrec.colorindex, colortable[figrec.colorindex] );*/
				break;
			case TEXT:
				if ( new_entry() == FALSE ) break;
				pcurrententry->type = UNKNOWN;
				pcurrententry->color = figrec.color;
				pcurrententry->depth = figrec.depth;

				if ( strncmp("color:", figrec.text, 6 ) == 0 ) { /* special 'color:' text */
					i = atoi ( figrec.text+6 );
					if ( i < 256 ) colorratetable[i] = figrec.color;
					/*printf ( "color rate[%i] : %i.\n", i, colorratetable[i] );*/
					break;
				}

				if ( (pcurrententry->str = malloc ( strlen(figrec.text) + 1 )) == NULL ) {
					fprintf ( stderr, "Error : memory allocation failure.\n" );
					break;
				}
				if ( (pcurrententry->coords = (int *)malloc(figrec.npoints * (sizeof (int)) * 2 )) == NULL ) {
					fprintf ( stderr, "Error : memory allocation failure.\n" );
					break;
				}
				pcurrententry->type = TEXT;
				pcurrententry->npoints = figrec.npoints;
				pcurrententry->orientation = figrec.angle;
				strcpy (pcurrententry->str,figrec.text);
				memcpy (pcurrententry->coords,figrec.coords,figrec.npoints * (sizeof (int)) * 2);
				break;
			case POLY:
			case RECT:
				if ( new_entry() == FALSE ) break;
				pcurrententry->type = UNKNOWN;
				pcurrententry->depth = figrec.depth;
				pcurrententry->color = figrec.color;
				pcurrententry->fillcolor = figrec.fillcolor;
				if ( (pcurrententry->coords = (int *)malloc(figrec.npoints * (sizeof (int)) * 2 )) == NULL ) {
					fprintf ( stderr, "Error : memory allocation failure.\n" );
					continue;
				}
				pcurrententry->type = figrec.type;
				pcurrententry->npoints = figrec.npoints;
				memcpy (pcurrententry->coords,figrec.coords,figrec.npoints * (sizeof (int)) * 2);
				break;
			case COMPOUND:			/* compound must be links ... */
				if ( new_entry() == FALSE ) break;
				do {
					if ( getfig ( config, &figrec ) == TRUE ) break;
					if ( figrec.type == ENDCOMPOUND ) break;
					if ( figrec.type == TEXT ) {
						/*printf (" txt %s.\n", figrec.text );*/
						if ( strncmp("gifarea", figrec.text, 7 ) == 0 ) {
							pcurrententry->type = GIFAREA;
							pareaentry = pcurrententry;
							/*printf ( " gifarea : [%i / %i] ", pcurrententry->coords[0], pcurrententry->coords[1]);
							printf ( " [%i / %i].\n", pcurrententry->coords[2], pcurrententry->coords[3]);*/
						} else if ( strncmp("url:", figrec.text, 4 ) == 0 ) {
							if ( (pcurrententry->str = malloc ( strlen(figrec.text) + 1 )) == NULL ) {
								fprintf ( stderr, "Error : memory allocation failure.\n" );
								break;
							}
							pcurrententry->type = URL;
							strcpy (pcurrententry->str,figrec.text+4);
							/*printf (" url %s.\n", pcurrententry->str );*/
						} else if ( strncmp("log:", figrec.text, 4 ) == 0 ) {
							char * s = figrec.text + 4;
							if ( s[0] == '>' ) {
								pcurrententry->orientation = OUT;
								s++;
							} else if ( s[0] == '<' ) {
								pcurrententry->orientation = IN;
								s++;
							} else {
								pcurrententry->orientation = INOUT;
							}
							if ( (pcurrententry->str = malloc ( strlen(s) + 1 )) == NULL ) {
								fprintf ( stderr, "Error : memory allocation failure.\n" );
								break;
							}
							pcurrententry->type = LINK;
							strcpy (pcurrententry->str,s);
							/*printf (" str %s.\n", pcurrententry->str );*/
						} else if ( strncmp("speed:", figrec.text, 6 ) == 0 ) {
							pcurrententry->maxrate = atoi ( figrec.text+6 );
							/*printf (" max rate : %i.\n", pcurrententry->maxrate );*/
						}
					}
					if ( (figrec.type == POLY) || (figrec.type == RECT) ) {
						pcurrententry->color = figrec.color; /* default color */
						pcurrententry->depth = figrec.depth;
						pcurrententry->fillcolor = figrec.fillcolor; 
						if ( (pcurrententry->coords = (int *)malloc(figrec.npoints * (sizeof (int)) * 2 )) == NULL ) {
							fprintf ( stderr, "Error : memory allocation failure.\n" );
							break;
						}
						pcurrententry->npoints = figrec.npoints;
						memcpy (pcurrententry->coords,figrec.coords,figrec.npoints * (sizeof (int)) * 2);
					}
				} while ( 1 );
				if ( pcurrententry->type==LINK && pcurrententry->coords != NULL ) {
					read_entry ( pcurrententry );
					/*printf (" link : log : %s.log, max rate : %i.\n", pcurrententry->str, pcurrententry->maxrate );*/
				}
				break;
			case ENDCOMPOUND:
			case UNKNOWN:
			default:
				break;
			}

		}

		/***************************************************************/
		/* checks */
		if ( pareaentry == NULL ) {
			fprintf ( stderr, "Error : no gif area specified.\n");
			break;
		}
		xsize = (pareaentry->coords[2] - pareaentry->coords[0]);
		ysize = (pareaentry->coords[3] - pareaentry->coords[1]);
		xoffset = pareaentry->coords[0]; yoffset = pareaentry->coords[1];
		/*printf ( "size : %i %i.\n", xsize, ysize );
		printf ( "offset : %i %i.\n", xoffset, yoffset );*/

		/***************************************************************/
		/*  do translations	                                           */
		pcurrententry = pfirstentry;
		while ( pcurrententry != NULL ) {
			for (i = 0; i < pcurrententry->npoints; i ++) {
				pcurrententry->coords[i*2]		-=	xoffset;
				pcurrententry->coords[i*2+1]	-=	yoffset;
				pcurrententry->coords[i*2] /= scale;
				pcurrententry->coords[i*2+1] /= scale;
			}
			if ( smap != NULL ) {
				if ( pcurrententry->type==URL && pcurrententry->coords != NULL ) {
					fprintf ( map, "   <area href=%s alt=\"%s\" shape=rect coords=\"%i,%i,%i,%i\">\n", 
						pcurrententry->str,pcurrententry->str,
						pcurrententry->coords[0],pcurrententry->coords[1],
						pcurrententry->coords[2],pcurrententry->coords[3] );
				}
			}
			pcurrententry = pcurrententry->next;
		}
		xsize /= scale; ysize /=scale;

		/***************************************************************/
		/* 3 : draw gif file                                           */
		draw_gif ( gif );
		
		/***************************************************************/
		/* 4 : clean-up all											   */
		{
			struct sentry * pentry;
			pcurrententry = pfirstentry;
			do {
				pentry = pcurrententry->next;
				free_entry(pcurrententry);
				pcurrententry = pentry;
			} while ( pentry != NULL );
		}
		
		fclose ( gif );
		fclose ( config );

		if ( smap != NULL ) {
			/*<area href=lk311.html alt="lk311.html" shape=rect coords="240,12,270,24">*/
			fprintf ( map, "  </map>\n" );
			fclose ( map );
		}
		
		break;

	} while ( TRUE );

}

