/*
Iulian Radu [v2.0@07.1999]
*/

#include "vars.h"

void parsex(char* fcfg);
void parse(char* fcfg);

#include "util.c"
#include "parse.ftbl"
#include "parse0.c"
#include "parsen.c"

void parsex(char* fcfg){
char buf[513];
FILE* f;
f=fopen(fcfg,"rt");
if(!f) return;
while(!feof(f)){
    buf[0]=0;		//look stupid BUT it is not
    fgets(buf,512,f);
    if(xdebug) printf("EXTREM DEBUG: %s\n",buf);
    trim(buf);
    if(!buf[0] || (buf[0]=='#')) continue;
    if(buf[0]=='0') parse0(buf+2);
    else if(isdigit(buf[0]))
	    if(!comment) parsen(buf);
    }	
fclose(f);
}

void parse(char* fcfg){
int i,j;
parsex(fcfg);
closehtml();
if(fm) fclose(fm);
/* close mk? */
for(i=0;i<4;i++)
    for(j=0;j<nmkr[i];j++){
	if(mkri[j][i]) wrchtml(mkri[j][i]);
	mkri[j][i]=NULL;}
system("rm -f *.ndx");
}

