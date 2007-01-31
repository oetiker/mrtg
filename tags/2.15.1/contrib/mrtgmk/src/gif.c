/*
Iulian Radu [v2.0@07.1999]
*/

void fgif(char* buf,char* ext){
char link[129],host[129],*hosti,url[257];
if(!fh) return;
sscanf(buf,"%s %s",link,host);
if(strcmp(host,"#")){		//host!=# -> search for a host definition
    hosti=findhost(host);
    if(!hosti) return;
    if(strcmp(link,"#")){
        if(base[0]) sprintf(url,"http://%s/%s",base,hosti);
        else strcpy(url,hosti);
        fprintf(fh,"<A HREF=\"%s\">",link);
        fprintf(fh,"<IMG SRC=\"%s%s\">",url,ext);}
    else{
        if(base[0]) sprintf(url,"http://%s/%s",base,hosti);
        else strcpy(url,hosti);
        fprintf(fh,"<A HREF=\"%s.html\">",url);
        fprintf(fh,"<IMG SRC=\"%s%s\">",url,ext);}
    }
else{
    if(strcmp(link,"#")){
        if(base[0]) sprintf(url,"http://%s/%s",base,link);
        else strcpy(url,link);
        fprintf(fh,"<A HREF=\"%s.html\">",url);
        fprintf(fh,"<IMG SRC=\"%s%s\">",url,ext);}
    else{
	fprintf(stderr,"\aERROR: 0 GIF%c # #\n",toupper(ext[1]));
	return;}
    }
fprintf(fh,"</IMG></A>\n");
}

void fgifd(char* buf){
fgif(buf,"-day.gif");
}

void fgifw(char* buf){
fgif(buf,"-week.gif");
}

void fgifm(char* buf){
fgif(buf,"-month.gif");
}

void fgify(char* buf){
fgif(buf,"-year.gif");
}

