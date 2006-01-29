/*
Iulian Radu [v2.0@07.1999]
*/

void fcomment(char* buf){
comment=1;
}

void finclude(char* buf){
parsex(buf);
}

void fmrtgcfg(char* buf){
char dst[257],src[257],tmp[257];
if(fm) fclose(fm);
sscanf(buf,"%s %s",dst,src);
if(strcmp(dst,src)){
    sprintf(tmp,"cp %s %s",src,dst);
    system(tmp);}
fm=fopen(dst,"a+t");
if(!fm) return;
fprintf(fm,"#----------------------------------------------------------------------\n");
}

void fhtmlfile(char* buf){
closehtml();
fh=fopen(buf,"wt");
mkhtmlh();
}

void fxdebug(char* buf){
if(!strcasecmp(buf,"on")) xdebug=1;
if(!strcasecmp(buf,"off")) xdebug=0;
}

void fcfgdir(char* buf){
strcpy(cfgdir,buf);
}

void fnocfgdir(char* buf){
cfgdir[0]=0;
}

void fhtmlcode0(char* buf){
int i;
if(!fh) return;
for(;identl;identl--){
    for(i=1;i<identl;i++) fprintf(fh,"\t");
    fprintf(fh,"</UL>\n");}
fprintf(fh,"%s\n",buf);
}

void fmrtgtext(char* buf){
if(!fm) return;
fprintf(fm,"#%s\n",buf);
}

void fbody(char* buf){
strcpy(body,buf);
}

void fnobody(char* buf){
body[0]=0;
}

void fbase(char* buf){
strcpy(base,buf);
}

void fnobase(char* buf){
base[0]=0;
}

void fexec(char* buf){
system(buf);
}

void fmsg(char* buf){
printf("%s\n",buf);
}

void ftitle(char* buf){
strcpy(title,buf);
}

void fmklink(char* buf){
char dir[257],host[65],path[257],*hosti,tmp1[257],tmp2[257],crtdir[257];
sscanf(buf,"%s %s %s",dir,host,path);
hosti=findhost(host);
if(!hosti){
    fprintf(stderr,err[9],host);
    return;}
mkdir(dir,S_IREAD | S_IWRITE | S_IEXEC);
getcwd(crtdir,256);
if(chdir(dir)){
    fprintf(stderr,err[10],dir);
    return;}
/* index.html */
sprintf(tmp1,"%s/%s.html",path,hosti);
unlink("index.html");
symlink(tmp1,"index.html");
/* gifs */
sprintf(tmp1,"%s/%s-day.gif",path,hosti);
sprintf(tmp2,"%s-day.gif",hosti);
unlink(tmp2);
symlink(tmp1,tmp2);
sprintf(tmp1,"%s/%s-week.gif",path,hosti);
sprintf(tmp2,"%s-week.gif",hosti);
unlink(tmp2);
symlink(tmp1,tmp2);
sprintf(tmp1,"%s/%s-month.gif",path,hosti);
sprintf(tmp2,"%s-month.gif",hosti);
unlink(tmp2);
symlink(tmp1,tmp2);
sprintf(tmp1,"%s/%s-year.gif",path,hosti);
sprintf(tmp2,"%s-year.gif",hosti);
unlink(tmp2);
symlink(tmp1,tmp2);
/* mrtg imgs */
sprintf(tmp1,"%s/mrtg-l.gif",path);
unlink("mrtg-l.gif");
symlink(tmp1,"mrtg-l.gif");
sprintf(tmp1,"%s/mrtg-m.gif",path);
unlink("mrtg-m.gif");
symlink(tmp1,"mrtg-m.gif");
sprintf(tmp1,"%s/mrtg-r.gif",path);
unlink("mrtg-r.gif");
symlink(tmp1,"mrtg-r.gif");
sprintf(tmp1,"%s/mrtg-tl.gif",path);
unlink("mrtg-tl.gif");
symlink(tmp1,"mrtg-tl.gif");
chdir(crtdir);
}

void wrohtml(FILE* f,char* str,char* fcfg){
fprintf(f,"<HTML>\n");
fprintf(f,"<HEADER>\n");
fprintf(f,"<TITLE>\n");
if(title[0]) fprintf(f,"%s - %s",title,str);
else fprintf(f,"%s - %s",btxt[0],str);
fprintf(f,"</TITLE>\n");
fprintf(f,"</HEADER>\n");
if(body[0]) fprintf(f,"<BODY %s>\n",body);
else fprintf(f,"<BODY>\n");
fprintf(f,"<H1>%s %s %s</H1><P>\n",str,btxt[2],fcfg);
}

void wrchtml(FILE* f){
fprintf(f,"</BODY>\n");
fprintf(f,"</HTML>\n");
}

void fmkd(char* buf){
char fcfg[257],fhtml[257];
FILE* f;
int i;
sscanf(buf,"%s %s",fcfg,fhtml);
for(i=0;i<nmkr[0];i++)
    if(!strcmp(mkrn[i][4],fhtml)){
	f=mkri[i][0];
	break;}
if(i==nmkr[0]){
    f=fopen(fhtml,"wt");
    if(!f) return;
    wrohtml(f,"day",fcfg);}
i=nmkr[0]++;
mkri[i][0]=f;
strcpy(mkrn[i][0],fcfg);
strcpy(mkrn[i][4],fhtml);
}

void fmkw(char* buf){
char fcfg[257],fhtml[257];
FILE* f;
int i;
sscanf(buf,"%s %s",fcfg,fhtml);
for(i=0;i<nmkr[1];i++)
    if(!strcmp(mkrn[i][5],fhtml)){
	f=mkri[i][1];
	break;}
if(i==nmkr[0]){
    f=fopen(fhtml,"wt");
    if(!f) return;
    wrohtml(f,"week",fcfg);}
i=nmkr[1]++;
mkri[i][1]=f;
strcpy(mkrn[i][1],fcfg);
strcpy(mkrn[i][5],fhtml);
}

void fmkm(char* buf){
char fcfg[257],fhtml[257];
FILE* f;
int i;
sscanf(buf,"%s %s",fcfg,fhtml);
for(i=0;i<nmkr[2];i++)
    if(!strcmp(mkrn[i][6],fhtml)){
	f=mkri[i][2];
	break;}
if(i==nmkr[2]){
    f=fopen(fhtml,"wt");
    if(!f) return;
    wrohtml(f,"month",fcfg);}
strcpy(mkrn[nmkr[2]++][2],fcfg);
i=nmkr[2]++;
mkri[i][2]=f;
strcpy(mkrn[i][2],fcfg);
strcpy(mkrn[i][6],fhtml);
}

void fmky(char* buf){
char fcfg[257],fhtml[257];
FILE* f;
int i;
sscanf(buf,"%s %s",fcfg,fhtml);
for(i=0;i<nmkr[3];i++)
    if(!strcmp(mkrn[i][7],fhtml)){
	f=mkri[i][3];
	break;}
if(i==nmkr[3]){
    f=fopen(fhtml,"wt");
    if(!f) return;
    wrohtml(f,"year",fcfg);}
i=nmkr[3]++;
mkri[i][3]=f;
strcpy(mkrn[i][3],fcfg);
strcpy(mkrn[i][7],fhtml);
}

void fhtmllink0(char* buf){
char link[129];
int i;
if(!fh) return;
for(;identl;identl--){
    for(i=1;i<identl;i++) fprintf(fh,"\t");
    fprintf(fh,"</UL>\n");}
sscanf(buf,"%s",link);
if(base[0]) fprintf(fh,"<A HREF=\"http://%s/%s\">",base,link);
else fprintf(fh,"<A HREF=\"%s\">",link);
fprintf(fh,"%s",findnsp(buf,1));
fprintf(fh,"</A>\n");
}

void flink2dh0(char* buf){
char host[129],*hosti;
int i;
if(!fh) return;
for(;identl;identl--){
    for(i=1;i<identl;i++) fprintf(fh,"\t");
    fprintf(fh,"</UL>\n");}
sscanf(buf,"%s",host);
hosti=findhost(host);
if(!hosti){
    fprintf(stderr,err[9],host);
    return;}
if(base[0]) fprintf(fh,"<A HREF=\"http://%s/%s.html\">",base,hosti);
else fprintf(fh,"<A HREF=\"%s.html\">",hosti);
fprintf(fh,"%s",findnsp(buf,1));
fprintf(fh,"</A>\n");
}

void fchngtrgname(char* buf){
if(!strcasecmp(buf,"yes")){
    chngname=1;
    return;}
if(!strcasecmp(buf,"no")){
    chngname=0;
    return;}
fprintf(stderr,err[12],buf);    
}

void fconvip2name(char* buf){
conv=1;
sscanf(buf,"%s",mrtgoutpath);
}

void fconvname2ip(char* buf){
conv=2;
sscanf(buf,"%s",mrtgoutpath);
}
