# This -*- perl -*- script makes the Makefile
# $Id: Makefile.PL,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
 
#--- Distribution section ---
 
$MODNAME = 'GIFgraph';
 
BEGIN { require 5.001 }
 
use ExtUtils::MakeMaker;
 
my @clean = qw(*% *.html *.b[ac]k *.old .[A-z]* tags);
push @clean, map { "*/$_" } @clean;
 
WriteMakefile(
		'VERSION_FROM'		=> $MODNAME . '.pm',	#finds $VERSION
        'DISTNAME'  		=> $MODNAME,
        'NAME'      		=> $MODNAME,

		($] >= 5.005 ?
			('ABSTRACT'		=> 'Produces GIF graph plots',
			 'AUTHOR'		=> 'Martien Verbruggen (mgjv@comdyn.com.au)',
			) : ()
		),

		'PREREQ_PM'			=> { 'GD' => 0, },
 
        'dist'    			=> {
			'COMPRESS' 		=> 'gzip -9f',
			'SUFFIX'   		=> 'gz', 
		},
 
        'clean'   => { 'FILES' => join(" ", @clean), },
);

