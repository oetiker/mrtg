/*
Iulian Radu [v2.0@07.1999]
*/

char* extractfname(char* fname){
char* cptmp;
cptmp=fname+strlen(fname)-1;
while((cptmp>=fname) && (cptmp[0]!='/')) cptmp--;
return cptmp+1;
}

void ltrim(char* buf){
char* tmp;
for(tmp=buf;tmp[0] && isspace(tmp[0]);tmp++);
strcpy(buf,tmp);
}

void rtrim(char* buf){
char* tmp;
for(tmp=buf-1;buf[0];buf++)
    if(!isspace(buf[0])) tmp=buf;
tmp[1]=0;    
}

void trim(char*buf){
ltrim(buf);
rtrim(buf);
}

char* findnsp(char* str,int n){		/*unde incepe cuvintul de dupa al n-lea spatiu*/
while(str[0] && n)
    if(isspace(str[0])){
	n--;
	for(;str[0] && isspace(str[0]);str++);
	}
    else str++;
return str;
}

char* findnc(char* str,int n,char ch){		/*gaseste al n-lea ch*/
for(;str[0] && n;str++)
    if(str[0]==ch) n--;
return str;
}

void killnl(char* buf){
for(;buf[0];buf++){
    if(buf[0]=='\n'){
    	buf[0]=0;
	return;}
    if(buf[0]=='\r'){
    	buf[0]=0;
	return;}
    }
}
