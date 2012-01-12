#ifndef _TXT_H_
#define _TXT_H_

char* etxt[]={
    "by",
    "needed",
    "optionally",
    "configuration file"
    };

char* btxt[]={
    "Traffic analyses",	
    "Traffic analysis for",
    ".gifs for hosts in the .cfg file"
    };

char* err[]={
    "\aERROR: openning file %s\n",
    "\aERROR: index file %s has length 0 and I erase it\n",
    "\aERROR: was not defined a mrtg.cfg file\n",
    "\aERROR: port %s missing from %s/%s\n",
    "\aERROR: port %s missing from %s\n",
    "\aERROR: configuration file %s is missing\n",
    "\aERROR: host %s redefined\n",
    "\aERROR: alias %s redefined\n",
    "\aERROR: alias %s not precedently defined\n",
    "\aERROR: host %s not precedently defined\n",
    "\aERROR: I can't switch in directory %s\n",	//10
    "\aERROR: argument for CHECK4ALIAS was %s",
    "\aERROR: argument for CHNGTRGNAME was %s"
    };
    
#endif
    