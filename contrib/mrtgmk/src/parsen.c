/*
Iulian Radu [v2.0@07.1999]
*/

int ident=0;

#include "fnctn.c"
#include "parsen.ftbl"

int formathtml(){		/* put UL or /UL */
int i,j,k;
if(ident<1){
    return 1;}
if(!fh) return 1;
if(!identl){
    fprintf(fh,"<UL TYPE=\"disc\">\n");
    identl++;}
if(ident<identl){
    i=identl-ident;
    k=identl-1;
    for(;i;i--,k--){
        for(j=0;j<k;j++) fprintf(fh,"\t");
	fprintf(fh,"</UL>\n");}
    }
if(ident>identl){
    i=ident-identl;
    k=identl;
    for(;i;i--,k++){
        for(j=0;j<k;j++) fprintf(fh,"\t");
	fprintf(fh,"<UL TYPE=\"disc\">\n");}
    }
for(i=0;i<ident;i++) fprintf(fh,"\t");
identl=ident;
return 0;
}

void parsen(char* buf){
char cmd[129],*ebuf;
int i;
ltrim(buf);
sscanf(buf,"%d %s",&ident,cmd);
for(i=0;i<NEFTBLn;i++)
    if(!strcmp(cmd,parsen_ftbl[i].cmd)){
	if(parsen_ftbl[i].func){
	    ebuf=findnsp(buf,2);
	    rtrim(ebuf);
	    if(usealias) expand(ebuf);
	    if(formathtml()){
		fprintf(stderr,"\aERROR: %s\n",ebuf);
		return;}
	    parsen_ftbl[i].func(ebuf);}
	return;}
fprintf(stderr,"\aERROR: %s\n",buf);
}
