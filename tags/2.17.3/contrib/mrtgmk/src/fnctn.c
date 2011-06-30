/*
Iulian Radu [v2.0@07.1999]
*/

void fhtmlcoden(char* buf){
int i;
for(i=1;i<identl;i++)
    fprintf(fh,"\t");
fprintf(fh,"<LI>%s</LI>\n",buf);
}

void fhtmllinkn(char* buf){
char link[129];
int i;
for(i=1;i<identl;i++)
    fprintf(fh,"\t");
sscanf(buf,"%s",link);
if(base[0]) fprintf(fh,"<LI><A HREF=\"http://%s/%s\">",base,link);
else fprintf(fh,"<LI><A HREF=\"%s\">",link);
fprintf(fh,"%s",findnsp(buf,1));
fprintf(fh,"</A></LI>\n");
}

void fdata(char* buf){
char host[129],*text,*hosti,url[257];
sscanf(buf,"%s",host);
hosti=findhost(host);
if(!hosti) return;
text=findnsp(buf,1);
if(base[0]) sprintf(url,"http://%s/%s",base,hosti);
else strcpy(url,hosti);
fprintf(fh,"<LI><A HREF=\"%s.html\">",url);
fprintf(fh,"%s",text);
fprintf(fh,"</A></LI>\n");
}

void flink2dhn(char* buf){
char host[129],*hosti;
int i;
for(i=1;i<identl;i++)
    fprintf(fh,"\t");
sscanf(buf,"%s",host);
hosti=findhost(host);
if(!hosti){
    fprintf(stderr,err[9],host);
    return;}
if(base[0]) fprintf(fh,"<LI><A HREF=\"http://%s/%s.html\">",base,hosti);
else fprintf(fh,"<LI><A HREF=\"%s.html\">",hosti);
fprintf(fh,"%s",findnsp(buf,1));
fprintf(fh,"</A></LI>\n");
}

