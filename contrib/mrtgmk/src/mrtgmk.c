/*
Iulian Radu [v2.0@07.1999]
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>
#include <unistd.h>

#include "txte.h"	//for english messages
//#include "txtro.h"	//pentru mesaje in romaneste
#include "parse.c"

void intro(char* aname){
printf("\n%s (mrtgmk) %s Iulian Radu [v2.2@1.2000]\n\n",extractfname(aname),etxt[0]);
}

void help(char* aname){
printf("%s <cfg.fname>\n",aname);
printf("  <cfg.fname>  = %s\n",etxt[3]);
printf("    <> = %s\n",etxt[1]);
printf("    [] = %s\n",etxt[2]);
printf("\n");
exit(1);
}

int main(int argc,char** argv){
intro(argv[0]);
if(argc!=2) help(argv[0]);
parse(argv[1]);
return 0;
}

