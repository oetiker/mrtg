/*
Iulian Radu [v2.0@07.1999]
*/

int mkndx(char* file){
char tmp[257],xtmp[257],*ptmp;
FILE *fcfg,*fndx;
unsigned long ofs,xofs;
/* open .cfg file */
if(cfgdir[0]) sprintf(tmp,"%s/%s",cfgdir,file);
else strcpy(tmp,file);
fcfg=fopen(tmp,"rt");
if(!fcfg){
    fprintf(stderr,err[0],tmp);
    return 1;}
/* check if file .cfg has length 0 */
if(fseek(fcfg,0,SEEK_END)){	
    fclose(fcfg);
    return 1;}
if(!ftell(fcfg)){
    fprintf(stderr,err[1],tmp);
    sprintf(xtmp,"rm -f %s",tmp);
    system(xtmp);
    return 1;}
if(fseek(fcfg,0,SEEK_SET)) return 1;
/* create de index file */
sprintf(tmp,"%s.ndx",extractfname(file));
fndx=fopen(tmp,"wb");
if(!fndx){
    fclose(fcfg);
    return 1;}
while(!feof(fcfg)){
    xofs=ftell(fcfg);
    tmp[0]=0;
    fgets(tmp,256,fcfg);
    if((tmp[0]=='#') || (tmp[0]==0) || (tmp[0]=='\n')) continue;
    if(!strncmp(tmp,"Target[",7)) ofs=xofs;
    if(!strncmp(tmp,"Title[",6)){
	ptmp=findnc(tmp,2,':');
	trim(ptmp);
	fprintf(fndx,"%08ld %s\n",ofs,ptmp);}
    }
fclose(fndx);
fclose(fcfg);
return 0;
}

void setPI(char* buf,unsigned long* pos,char** ifa){
sscanf(buf,"%08ld",pos);
*ifa=buf+9;
killnl(buf+9);
}

void gettarget(char* buf,char* target){		//word between []
int i;
for(;buf[0]!='[';buf++);
buf++;
for(i=0;buf[0]!=']';buf++,i++) target[i]=buf[0];
target[i]=0;
}

char* findhost(char* buf){
int i;
for(i=0;i<nhosts;i++)
    if(!strcmp(hostsn[i],buf))
	return hostsi[i];
return NULL;	
}

void convertname(char* tmp){
for(;tmp[0];tmp++){
    if(!isalnum(tmp[0])) tmp[0]='_';
    else tmp[0]=tolower(tmp[0]);
    }
}

void fdefhost(char* buf){
char host[129],fcfg[257],tmp[257],target[129],xtarget[129],*port;
FILE *fi;
unsigned long pos;
char *ifa=NULL,
     *txt[]={"day","week","month","year"},
     *xtxt[]={"-day.gif","-week.gif","-month.gif","-year.gif",".html",".log",".old"};
int i,j;
if(!fm){
    fprintf(stderr,err[2]);
    return;}
sscanf(buf,"%s %s",host,fcfg);
if(findhost(host))
    fprintf(stderr,err[6],host);
/* read index file */
sprintf(tmp,"%s.ndx",extractfname(fcfg));
fi=fopen(tmp,"rt");
if(!fi){
    if(mkndx(fcfg)) return;	//create the index file 
    fi=fopen(tmp,"rt");
    if(!fi) return;
    }
port=findnsp(buf,2);
while(!feof(fi)){
    fgets(tmp,256,fi);
    setPI(tmp,&pos,&ifa);		//read pos and interface
    if(!strcasecmp(port,ifa)){
	break;}
    }
if(feof(fi)){
    if(cfgdir[0]) fprintf(stderr,err[3],port,cfgdir,fcfg);
    else fprintf(stderr,err[4],port,fcfg);
    fclose(fi);
    return;}
fclose(fi);
/* comment in mrtg.cfg file */
if(cfgdir[0]){
    fprintf(fm,"\n#host %s, cfgfile %s/%s, port %s\n\n",host,cfgdir,fcfg,port);
    sprintf(tmp,"%s/%s",cfgdir,fcfg);}
else{
    fprintf(fm,"\n#host %s, cfgfile %s, port %s\n\n",host,fcfg,port);
    strcpy(tmp,fcfg);}
/* read config file to extract section */
fi=fopen(tmp,"rt");
if(!fi){
	fprintf(stderr,err[5],tmp);
	return;}
fseek(fi,pos,SEEK_SET);
fgets(buf,256,fi);		/*Target[...*/
gettarget(buf,xtarget);
if(chngname){
    strcpy(target,host);
    convertname(target);	/* switch to lowercase */
    j=strlen(buf);
    for(i=0;i<j;i++){		/* write the line Target[... */
	fprintf(fm,"%c",buf[i]);
	if(buf[i]=='['){
	    for(;i<j;i++) if(buf[i]==']') break;
    	    fprintf(fm,"%s]",target);}
	}
    while(!feof(fi)){		/* write rest of the lines */
	fgets(buf,256,fi);
	j=strlen(buf);
	for(i=0;i<j;i++){
	    fprintf(fm,"%c",buf[i]);
	    if(buf[i]=='['){
		for(;i<j;i++) if(buf[i]==']') break;
    		fprintf(fm,"%s]",target);}
	    }
	if(!strncmp(buf,"#-",2)) break;
	}
    }
else{
    strcpy(target,xtarget);
    fprintf(fm,"%s",buf);
    while(!feof(fi)){
	fgets(buf,256,fi);
	fprintf(fm,"%s",buf);
	if(!strncmp(buf,"#-",2)) break;
	}
    }
fclose(fi);
strcpy(hostsn[nhosts],host);
strcpy(hostsi[nhosts],target);
nhosts++;
/* mk?,? */
for(i=0;i<4;i++){
    for(j=0;j<nmkr[i];j++){
	if(!strcmp(mkrn[j][i],fcfg)){
	    fprintf(mkri[j][i],"<HR><BR><H1>%s %s</H1><BR>\n",btxt[1],host);
	    if(base[0]) fprintf(mkri[j][i],"<A HREF=\"http://%s/%s.html\"><IMG SRC=\"http://%s/%s-%s.gif\"></IMG></A><BR>\n",base,target,base,target,txt[i]);
	    else fprintf(mkri[j][i],"<A HREF=\"%s.html\"><IMG SRC=\"%s-%s.gif\"></IMG></A><BR>\n",target,target,txt[i]);
	    break;}
	}
    }
convertname(host);		/* change again the name, this time host var */
switch(conv){
    case 1:		//convip2name
	for(i=0;i<7;i++){
	    sprintf(tmp,"mv %s%s%s %s%s%s",mrtgoutpath,xtarget,xtxt[i],mrtgoutpath,host,xtxt[i]);
	    system(tmp);}
	break;
    case 2:		//convname2ip
	for(i=0;i<7;i++){
	    sprintf(tmp,"mv %s%s%s %s%s%s",mrtgoutpath,host,xtxt[i],mrtgoutpath,xtarget,xtxt[i]);
	    system(tmp);}
	break;
    }
}

