/*
Iulian Radu [v2.0@07.1999]
*/

int apos=-1;			//memorize position of a free cell

char* findalias(char* buf){
int i;
apos=-1;
for(i=0;i<nalias;i++){
    if(!strcmp(aliasn[i],buf))
	return aliasi[i];
    if(!aliasn[i][0]) apos=i;	//no need to scan all defined aliases
    }
if(strncmp(buf,"HOST_",5)) return NULL;	
return findhost(buf+5);
}

void falias(char* buf){
char alias[129],*replace;
sscanf(buf,"%s",alias);
replace=findnsp(buf,1);
if(findalias(alias))
    fprintf(stderr,err[7],alias);
else
    if(apos<0){
	strcpy(aliasn[nalias],alias);
	strcpy(aliasi[nalias],replace);
	nalias++;}
    else{
	strcpy(aliasn[apos],alias);
	strcpy(aliasi[apos],replace);}
}

void fcheck4alias(char* buf){
if(!strcasecmp(buf,"yes")){
    usealias=1;
    return;}
if(!strcasecmp(buf,"no")){
    usealias=0;
    return;}
fprintf(stderr,err[11],buf);    
}

char* expand(char* str){
char buf[257],al[129];
int i,j,k;
char* alias;
for(i=j=0;str[i];i++,j++)
    if(str[i]!='%') buf[j]=str[i];
    else{
    	for(i++,k=0;(str[i]) && (str[i]!='%');i++,k++)
	    al[k]=str[i];
	al[k]=0;
	alias=findalias(al);
	if(!alias){
	    fprintf(stderr,err[8],al);
	    return str;}
	strcpy(buf+j,alias);
	j+=strlen(alias)-1;}
buf[j]=0;
strcpy(str,buf);	
return str;
}

void fdelalias(char* buf){
int i;
for(i=0;i<nalias;i++)
    if(!strcmp(aliasn[i],buf))
	aliasn[i][0]=0;
}
