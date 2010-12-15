/*****************************
 ** woho's MRTG Logfile cgi **
 *****************************/

// define the path to your htmldocs here:
#define PFAD "/usr/local/httpd/htdocs"

// default HTML header:
#define HTMLHEAD "Content-type: text/html\n\n"

// in english you'd write "Statistics" here:
#define STATS "Auswertung"

// just replace the german word, if necessary:
#define FROM "von"

// just replace the german word, if necessary:
#define TO "bis"

// This is the information at the end of the page. It tells that those month,
// where no data exists, are skipped.
// More info would be usefull, e.g. that mrtg logfiles only collect averages.
#define INFOTEXT "ACHTUNG: Hier sind lediglich Durchschnittswerte der Messzeitr&auml;ume (je 5 Min.) aufsummiert.<BR>Diese Statististik ist somit nicht sehr genau!<BR>Monate, f&uuml;r die keine Mengenaufzeichnungen existieren, werden automatisch ausgeblendet."

// and in the end, the love you take, is equal to the love you make. (John Lennon)