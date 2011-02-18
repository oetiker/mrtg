/*	From FreeBSD: */
/*
 *      tcpblast - test and estimate TCP thruput
 *
 *      Daniel Karrenberg   <dfk@nic.eu.net>
 */

/*
 *	Changes: Rafal Maszkowski <rzm@pdi.net>
 *
 *	ftp://ftp.torun.pdi.net/pub/blast/README
 */

char *verstr="FreeBSD + rzm 961003";

#include <getopt.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#define DEFBLKSIZE (1024)
#define MAXBLKSIZE (32*1024)

struct	sockaddr_in sock_in;
struct	servent *sp;
struct	hostent *host;

unsigned long starts, startms, stops, stopms, expms;
struct timeval ti; 
struct timezone tiz;

char 	greet[MAXBLKSIZE], *ind;
int 	nblocks, f;
int tcp=0, udp=0, randomb=0, blksize=DEFBLKSIZE, setbufsize=-1, port=9, dots=1;

/* Long options.  */
static const struct option long_options[] =
{
  { "help", no_argument, NULL, 'h' },
  { "version", no_argument, NULL, 'V' },
  { NULL, 0, NULL, 0 }
};

void usage(name)
char	*name;
{	
	fprintf(stderr, "\n");
	fprintf(stderr, "usage: %s [options] destination nblocks\n\n", name);
	fprintf(stderr, "tcpblast/udpblast is a simple tool for probing network and estimating its\n");
	fprintf(stderr, "throughoutput. It sends nblocks of %d B blocks of data to specified\n", blksize);
	fprintf(stderr, "destination host\n\n");
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "-t             use TCP (%s)\n", ind[0]=='t' ? "default" : "default if named tcpblast" );
	fprintf(stderr, "-u             use UDP (%s)\n", ind[0]=='u' ? "default" : "default if named udpblast" );
	fprintf(stderr, "-p nnn         use port # nnn instead of default %d\n", port);
	fprintf(stderr, "-r             send random data\n");
	fprintf(stderr, "-s nnn         block size (default %d bytes)\n", blksize);
	fprintf(stderr, "-b nnn         socket buf size (default: %d, %s)\n", setbufsize, setbufsize==-1 ? "don't change" : "change");
	fprintf(stderr, "-d nnn         print dot every nnn blocks, 0 disables (default %d)\n", dots);
	fprintf(stderr, "-V, --version  version\n");
	fprintf(stderr, "-h, --help     this help\n");
	fprintf(stderr, "destination    host name or address\n");
	fprintf(stderr, "nblocks        number of blocks (1..9999)\n");
	fprintf(stderr, "%s version: %s\n", name, verstr);
	exit(1);
}

void usage_small(name)
char	*name;
{	
	fprintf(stderr, "type %s --help for help\n", name);
}

/* randomize the buffer */
void
randbuff(blksize) 
int blksize;
{
	int i;
	for (i=0; i<blksize; i++) {
		greet[i]=rand() % 256;
	}
}

int
main(argc, argv)
     int argc;
     char **argv;
{	register int i; char optchar;

	/* non-random data - is modem compressing it? */
	bzero(greet, MAXBLKSIZE);
	memset(greet, 'a', MAXBLKSIZE); 

	/* find first letter in the name - usage() needs it */
	ind=rindex(argv[0], '/');
	if (ind==NULL) ind=argv[0]; else ind++;

	while ((optchar = getopt_long (argc, argv, "tup:rs:b:d:Vh", long_options, NULL)) != EOF)
	switch (optchar) {
		case '\0': break;
		case 't': if (tcp==0) tcp=1;		break;
		case 'u': if (udp==0) udp=1;		break;
		case 'r': srand(0 /* may be an option */); randomb=1;		break;
		case 's': blksize=abs(atoi(optarg));	break;
		case 'b': setbufsize=abs(atoi(optarg));	break;
		case 'd': dots=abs(atoi(optarg));	break;
		case 'p': port=abs(atoi(optarg));	break;
		case 'V': printf("%s version: %s\n", argv[0], verstr);	return 0;	break;
		case 'h': usage(argv[0]);
		default: ;
	}

/* correctness */
	if (tcp && udp) {
		printf("cannot use both TCP and UDP\n");
		usage_small(argv[0]);
		exit(2);
	}

	/* if neither -t nor -u is chosen use first character of the
	   program name */
		if ( (tcp==0) && (udp==0) && (ind[0]=='t') ) tcp=1;
		if ( (tcp==0) && (udp==0) && (ind[0]=='u') ) udp=1;

	if (!tcp && !udp) {
		printf("must use either TCP or UDP\n");
		usage_small(argv[0]);
		exit(3);
	}

	/* after options processing we need two args left */
	if (argc - optind != 2) {
		if (argc - optind != 0) printf("give both hostname and block count\n");
		usage_small(argv[0]);
		exit(4);
	}

	nblocks = atoi(argv[optind+1]);
        if (nblocks<=0 || nblocks>=10000) {
		fprintf(stderr, "%s: 1 < nblocks <= 9999 \n", argv[0]);
		exit(5);
	}


	bzero((char *)&sock_in, sizeof (sock_in));
	sock_in.sin_family = AF_INET;
	if (tcp) f = socket(AF_INET, SOCK_STREAM, 0);
	else     f = socket(AF_INET, SOCK_DGRAM, 0);
	if (f < 0) {
		perror("tcp/udpblast: socket");
		exit(6);
	}

	{ unsigned int bufsize, size;
		/* get/setsockopt doesn't return any error really for SO_SNDBUF,
		   at least on Linux, it limits the buffer only [256..65536] */
		if (getsockopt(f, SOL_SOCKET, SO_SNDBUF, &bufsize, &size)==-1)
			printf("tcp/udpblast getsockopt: %s", strerror(errno));
		printf("read SO_SNDBUF = %d\n", bufsize);
		if (setbufsize!=-1) {
			if (setsockopt(f, SOL_SOCKET, SO_SNDBUF, &setbufsize, sizeof(setbufsize))==-1)
				printf("tcp/udpblast getsockopt: %s", strerror(errno));
			if (getsockopt(f, SOL_SOCKET, SO_SNDBUF, &bufsize, &size)==-1)
				printf("tcp/udpblast getsockopt: %s", strerror(errno));
			printf("set  SO_SNDBUF = %d\n", bufsize);
		}
	}

	if (bind(f, (struct sockaddr*)&sock_in, sizeof (sock_in)) < 0) {
		perror("tcp/udpblast: bind");
		exit(7);
	}

	host = gethostbyname(argv[optind]);
	if (host) {
		sock_in.sin_family = host->h_addrtype;
		bcopy(host->h_addr, &sock_in.sin_addr, host->h_length);
	} else {
		sock_in.sin_family = AF_INET;
		sock_in.sin_addr.s_addr = inet_addr(argv[optind]);
		if (sock_in.sin_addr.s_addr == -1) {
			fprintf(stderr, "%s: %s unknown host\n", argv[0], argv[optind]);
			exit(8);
		}
	}
	sock_in.sin_port = htons(port);

	if (connect(f, (struct sockaddr*)&sock_in, sizeof(sock_in)) <0)
	{
		perror("tcp/udpblast connect:");
		exit(9);
	}

	printf("Sending %s %s data using %d B blocks.\n",
		randomb ? "random":"non-random", tcp ? "TCP":"UDP", blksize);

	if (gettimeofday(&ti, &tiz) < 0)
	{
		perror("tcp/udpblast time:");
		exit(10);
	}
	starts  = ti.tv_sec;
	startms = ti.tv_usec / 1000L;


	for (i=0; i<nblocks; i++)
	{
		if (randomb) randbuff(blksize);
		if (write(f, greet, (size_t)blksize) != blksize)
			perror("tcp/udpblast send:");
		if ( (dots!=0) && ( (dots==1) || (i%dots==1) ) ) write(1, ".", 1);
	}

	if (gettimeofday(&ti, &tiz) < 0)
	{
		perror("tcp/udpblast time:");
		exit(11);
	}
	stops  = ti.tv_sec;
	stopms = ti.tv_usec / 1000L;

	expms = (stops-starts)*1000 + (stopms-startms);
	printf("\n%d KB in %ld msec", (nblocks*blksize)/1024, expms);
	printf("  =  %.1f b/s", ((double) (nblocks*blksize))/expms*8000);
	printf("  =  %.1f B/s", ((double) (nblocks*blksize))/expms*1000);
	printf("  =  %.1f KB/s\n", 
		(double) (nblocks*blksize) / (double) (expms*1024.0) * 1000 );
	return(0);
}
