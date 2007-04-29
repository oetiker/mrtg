/*
Iulian Radu [v2.0@07.1999]
*/

void mkhtmlh(){			/*use fh global*/
if(!fh) return;
fprintf(fh,"<HTML>\n");
fprintf(fh,"<HEADER>\n");
fprintf(fh,"<TITLE>\n");
if(title[0]) fprintf(fh,title);
else fprintf(fh,btxt[0]);
fprintf(fh,"</TITLE>\n");
fprintf(fh,"</HEADER>\n");
if(body[0]) fprintf(fh,"<BODY %s>\n",body);
else fprintf(fh,"<BODY>\n");
}

void closehtml(){		/*use fh global*/
int i;
if(!fh) return;
for(;identl;identl--){
    for(i=1;i<identl;i++) fprintf(fh,"\t");
    fprintf(fh,"</UL>\n");}
fprintf(fh,"</BODY>\n");
fprintf(fh,"</HTML>\n");
fclose(fh);
fh=NULL;
}

