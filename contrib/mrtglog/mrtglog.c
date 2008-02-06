/*****************************
 ** woho's MRTG Logfile cgi **
 *****************************/
#define VERSION "1.2"
#include "./mrtglog.h"
#include <time.h>
#include <stdio.h>

typedef struct
{
time_t t;
float in;
float out;
}	mrtg;

int str2time(char *s);
signed long runden(float zahl);

/************************************/
int main(int argc, char *argv[])
{
mrtg	ar[3000];
int i, y, a1, a2, a3, a4 , a5, diff,
    newmon, oldmon=13, year;
char s[128], *str, *ctmp, *start, *stop, *log,
     ch, ch2, ch3, hex[8];
time_t t1, t2;
struct tm *zeit;
float  IN, OUT, ISUM=0, OSUM=0;
FILE *fp;

if (argc==4)
 {
 start = argv[1];
 stop  = argv[2];
 log   = argv[3];
 }
else
 {
 ctmp = (char *) getenv("QUERY_STRING");
//printf("%sQUERY_STRING: '%s'\n",HTMLHEAD,ctmp);
 if (ctmp)
  {
  y = strlen(ctmp) + 1;
  str = (char *)malloc (y * sizeof(char));
  *str = '\0';
  for (i = 0; i < strlen(ctmp); i++)
   {
   ch = ctmp[i];
//   fflush (stdout);
   if (ctmp[i] == '+') ch = ' ';
   if (ctmp[i] == '%')
    {
    ch2 = ctmp[i+1];
    ch3 = ctmp[i+2];
    i += 2;
    snprintf (hex, sizeof(hex), "%c%c", ch2, ch3);
    ch = strtol (hex, NULL, 16);
    if ((ch == 10) || (ch == 13)) ch = ' ';
    }
   snprintf (&str[strlen(str)], y-strlen(str),"%c",ch);
   }
  while (str)
   { 
   ctmp = str;
   while (*ctmp != '=' && *ctmp != '&')  { *ctmp = tolower (*ctmp); ctmp++; }
   if ((char *)strstr(str,"start") == str)
    {
    start = ctmp+1;
    ctmp = (char *) strchr(start, '&');
    }
   else if ((char *)strstr(str,"stop") == str)
    {
    stop = ctmp+1;
    ctmp = (char *) strchr(stop, '&');
    }
   else if ((char *)strstr(str,"log") == str)
    {
    log = ctmp+1;
    ctmp = (char *) strchr(log, '&');
    }
   else { printf("%sParameter '%s' Fehlerhaft\n",HTMLHEAD,str); exit(1); }
   if (ctmp) { str = ctmp+1; *ctmp = '\0'; }
   else str = NULL;
   }
  }
 }

if  (!start || !stop || !log)
 {
 printf("%sUsage: mrtglog 01/05/03 31/05/03 mrtg.log # Count all traffic in May 2003\n",HTMLHEAD);
 exit(1);
 }

i = y = IN = OUT = 0;
t1 = str2time(start);
t2 = str2time(stop);
sprintf(s,"%s%s.log",PFAD,log);
fp = fopen(s,"r");
if (fp)
 {
 while (fgets(s, 100, fp))
    {
	if (sscanf(s, "%d %d %d %d %d\n", &a1, &a2, &a3, &a4, &a5) == 5)
	    {
		ar[y].t   = a1;
		ar[y].in  = a2;
		ar[y].out = a3;
		y++;
	    }
    }
 fclose(fp);
 }
else { printf("%scan't open '%s'!\n",HTMLHEAD,s); exit(1); }

str = (char *) strrchr(log,'/');
if (str) *str++;
else str = log;
if (ctmp = (char *) strstr(str,".log")) *ctmp=0;

printf("%s<HTML>\n<HEAD>\n<TITLE>%s %s %s %s %s %s</TITLE>\n"
"<STYLE TYPE=\"text/css\">\n<!--\n\
body {font-family:Arial,Helvetica; font-size:10pt;}\n\
table,tr,td,th {font-family:Arial,Helvetica; font-size:10pt;}\n\
pre {font-family:Courier; font-size:10pt;}\n\
p {font-family:Arial,Helvetica; font-size:10pt;}\n\
ul,ol,li {font-family:Arial,Helvetica; font-size:10pt;}\n\
dt {font-family:Arial,Helvetica; font-size:10pt;}\n\
dd {font-family:Arial,Helvetica; font-size:10pt;}\n\
address {font-family:Arial,Helvetica; font-size:8pt; font-style:italic;}\n\
h1 { font-family:Avantgarde,Arial,Helvetica; font-size:24pt; font-weight:bold;}\n\
h2 { font-family:Avantgarde,Arial,Helvetica; font-size:18pt; font-weight:bold;}\n\
h3 { font-family:Avantgarde,Arial,Helvetica; font-size:12pt; font-weight:bold;}\n\
h4 { font-family:Avantgarde,Arial,Helvetica; font-size:10pt; font-weight:bold;}\n\
h5,h6 { font-family:Avantgarde,Aria,Helvetical; font-size:10pt; font-style:italic;}\n\
.small {font-family:Arial,Helvetica; font-size:8pt;}\n\
.normal {font-family:Arial,Helvetica; font-size:10pt;}\n\
#rot { color:#FF0000; }\n\
#gruen { color:#00a000; }\n\
#normal { color:#000000; }\n\
-->\n</STYLE>\n</HEAD>\n\
<BODY BGCOLOR=\"#FFFFFF\">\n\
<TABLE CELLSPANNING=10 CELLPADDING=5 CELLSPACING=0 BGCOLOR=#D5FFD5 BORDER=1>\n\
<TR><TD COLSPAN=4 ALIGN=CENTER><H1 ID=\"rot\">%s</H1>\n\
<H3>%s %s %s %s %s</H3></TD></TR>\n\
<TR><TH COLSPAN=2  ALIGN=RIGHT>IN</TH><TH ALIGN=RIGHT>OUT</TH><TH ALIGN=RIGHT>TOTAL</TH></TR>\n",
HTMLHEAD,str,STATS,FROM,start,TO,stop,str,STATS,FROM,start,TO,stop);

for (i = 0; i < y; i++)
 {
 if ((t1 <= ar[i].t) && (ar[i].t <= t2))
  {
  zeit = gmtime((const time_t *)&ar[i].t);
  newmon = zeit->tm_mon;
  if ((oldmon != 13 && newmon != oldmon) || i+1 == y)
   {
   if (i+1 == y)
    {
    diff = ar[i].t - ar[i+1].t;
    IN  = IN  + ar[i].in  * diff;
    OUT = OUT + ar[i].out * diff;
    }
   if (IN == 0 && OUT == 0) break;
   ISUM += IN; OSUM += OUT;
   printf("<TR><TD ALIGN=RIGHT>%04i/%i</TD><TD ALIGN=RIGHT>%d MB</TD><TD ALIGN=RIGHT>%d MB</TD><TD ALIGN=RIGHT>%d MB</TD></TR>\n",
          year+1900,oldmon+1,runden(IN/1024/1024),runden(OUT/1024/1024),runden((IN+OUT)/1024/1024));
   IN = OUT = 0;
   }
  if (i+1 < y)
   {
   oldmon = newmon;
   year = zeit->tm_year;
   diff = ar[i].t - ar[i+1].t;
   IN  = IN  + ar[i].in  * diff;
   OUT = OUT + ar[i].out * diff;
   }
  }
 }
/*if (IN != 0 || OUT != 0)
 {
 ISUM += IN; OSUM += OUT;
 printf("<TR><TD ALIGN=RIGHT>%04i/%i</TD><TD ALIGN=RIGHT>%d MB</TD><TD ALIGN=RIGHT>%d MB</TD><TD ALIGN=RIGHT>%d MB</TD></TR>\n",
        year+1900,oldmon+1,runden(IN/1024/1024),runden(OUT/1024/1024),runden((IN+OUT)/1024/1024));
 }*/
printf("<TR><TD ALIGN=RIGHT><B>TOTAL</B></TD><TD ALIGN=RIGHT>%d MB</TD><TD ALIGN=RIGHT>%d MB</TD><TD ALIGN=RIGHT>%d MB</TD></TR>\n\
<TR><TD COLSPAN=4 WIDH=100\%>\n<FORM ACTION=\"%s\" method=\"GET\">\n\
von <INPUT NAME=\"START\" TYPE=\"text\" VALUE=\"%s\" SIZE=\"10\" MAXLENGTH=\"8\">\n\
bis <INPUT NAME=\"STOP\" TYPE=\"text\" VALUE=\"%s\" SIZE=\"10\" MAXLENGTH=\"8\">\n\
<INPUT NAME=\"LOG\" TYPE=\"hidden\" VALUE=\"%s\">\n\
<INPUT TYPE=\"submit\" VALUE=\"Aktualisieren\">\n\
</FORM>\n<P ALIGN=JUSTIFY CLASS=\"small\">%s</TD></TR>\n</TABLE>\n\
<CLASS=\"small\">mrtglog %s, copyleft 2000 by <A HREF=\"http://www.netpark.at\">http://www.netpark.at</A>\n</BODY>\n</HTML>",
runden(ISUM/1024/1024),runden(OSUM/1024/1024),runden((ISUM+OSUM)/1024/1024),
argv[0],start,stop,log,INFOTEXT,VERSION);
return 0;
}

/************************************/
int str2time(char *s)
{
    struct tm  tim;
    int d, m, y;
    if (sscanf(s, "%d.%d.%d", &d, &m, &y) != 3)
     { printf("%scant convert %s to date\n",HTMLHEAD, s); exit(10); }
    if (y < 100) y = y + 2000;    
    tim.tm_sec = tim.tm_min = tim.tm_hour = 0;
    tim.tm_mday = d;
    tim.tm_mon  = m - 1;
    tim.tm_year = y - 1900;
    return mktime(&tim);
}

/************************************/
signed long runden(float zahl)
{
signed long basis, nachkomma;

if (!zahl) return 0;
basis = zahl;
if ((nachkomma = labs((zahl-basis)*10)) == 0) return basis;
if (nachkomma > 5) { if (basis > 0) return ++basis; else return --basis; }
else
 if (nachkomma < 5) return basis;
 else
  {
  nachkomma = labs((zahl-basis)*100);
  if (nachkomma > 50) { if (basis > 0) return ++basis; else return --basis; }
  else
   if (nachkomma < 50) return basis;
   else
    {
    nachkomma = labs((zahl-basis)*1000);
    if (nachkomma > 500) { if (basis > 0) return ++basis; else return --basis; }
    else
     if (nachkomma < 500) return basis;
     else
      {
      nachkomma = labs((zahl-basis)*10000);
      if (nachkomma > 5000) { if (basis > 0) return ++basis; else return --basis; }
      else if (nachkomma < 5000) return basis;
      else return basis;
      }
    }
  }
}
// and in the end, the love you take, is equal to the love you make. (John Lennon)