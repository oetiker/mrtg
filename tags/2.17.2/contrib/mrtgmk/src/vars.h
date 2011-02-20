#ifndef _VARS_H_
#define _VARS_H_

FILE *fh=NULL,*fm=NULL;		//html and mrtg files
int  xdebug=0;			//say if produce extreme debug
int  comment=0;			//say if inside of a comment block
char cfgdir[257]="";		//path of the cfg file

#define N_HOSTS 4096
int  nhosts=0;			//# of defined states
char hostsn[N_HOSTS][65];	//host name
char hostsi[N_HOSTS][33];	//host definition as interface

int  identl=0;	
char body[257]="";		//code appended to body tag
char base[257]="";		//base for html files

#define N_ALIAS 128
int nalias=0;			//# of defined aliases
char aliasn[N_ALIAS][33];	//name of the aliases and their contents
char aliasi[N_ALIAS][129];	//name of the interfaces and their resolv

int usealias=0;			//say if is allowed to use aliases
int chngname=0;			//say if change the name of the output files
int conv=0;			//say if change or not the name of the files

char title[65];			//title of the html page

#define N_MK 128
int   nmkr[4]={ 0,		//# of files procesed for mkd
		0,		//# of files procesed for mkw
		0,		//# of files procesed for mkm
		0};		//# of files procesed for mky
char  mkrn[N_MK][8][257];	//0=name of the cfg procesed for mkd
				//1=name of the cfg procesed for mkw
				//2=name of the cfg procesed for mkm
				//3=name of the cfg procesed for mky
				//4=name of the router procesed for mkd
				//5=name of the router procesed for mkw
				//6=name of the router procesed for mkm
				//7=name of the router procesed for mky

FILE* mkri[N_MK][4];		//0=FILE* for mkd
				//1=FILE* for mkw
				//2=FILE* for mkm
				//3=FILE* for mky

char mrtgoutpath[256];		//used be convname2ip and convip2name

#endif
