Distrib for MRTG contribution.

Introduction
------------

- 'distrib' read mrtg log files and computes traffic distribution in 
  the time. It ouputs a graph with : 
  usage 1 : distrib -i infile -o giffile -w width -h height -t mode -r rate -d count
	(width / height in pixels)
	mode : d(ay), w(eek), m(onth), y(ear)
	count : how many categories of trafic must be taken

	- in x the percentage of trafic utilisation (% bandwith)
	- in y how many times the utilization was reached (% time)


  usage 2 : distrib -i infile -o giffile -w width -h height -t x -r top -d count
	(width / height in pixels)
	this option builds another graph, with more than interface, but the same informations 'stacked' 
	one on the other ...


- 'distrib.pl' use distrib to make a complete html ('distrib.html, distrib.gif') file 
  with all target defined in the file mrtg.cfg (!).

  usage : distrib.pl


Installation
------------

- distrib uses the GD library, as mrtg does. In order to compile it, you must
  have the following files : 

	GDFONTS.H
	GDFONTS.C
	MTABLES.C
	GD.H
	GD.C

	and ... distrib.c

	on unix, gcc distrib.c -I/yourgdinclude -L/yourgdlibrary -lgd -lm -o distrib
	on a PC with NT or 95, make a project with RDLOG2.C, GD.C, GDFONTS.C



All suggestions, bugs reports and others are welcome ...


Philippe Simonet, Philippe.Simonet@swisstelecom.com, 24.06.97