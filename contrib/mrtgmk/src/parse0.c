/*
Iulian Radu [v2.0@07.1999]
*/

#include "html.c"
#include "defhost.c"
#include "alias.c"
#include "gif.c"
#include "fnct0.c"
#include "parse0.ftbl"

void parse0(char* buf){
char cmd[129],*ebuf;
int i;
ltrim(buf);
sscanf(buf,"%s",cmd);
if(!strcmp(cmd,parse0_ftbl[0].cmd)){
    comment=0;
    return;}
if(comment) return;
for(i=1;i<NEFTBL0;i++)
    if(!strcmp(cmd,parse0_ftbl[i].cmd)){
	if(parse0_ftbl[i].func){
	    ebuf=buf+strlen(parse0_ftbl[i].cmd)+1;
	    trim(ebuf);
	    if(usealias) expand(ebuf);
	    parse0_ftbl[i].func(ebuf);}
	return;}
fprintf(stderr,"\aERROR: 0 %s\n",buf);
}
