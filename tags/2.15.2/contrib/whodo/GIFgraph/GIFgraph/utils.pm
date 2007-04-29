#==========================================================================
#              Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::utils.pm
#
#	Description:
#		Package of general utilities.
#
# $Id: utils.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================
 
package GIFgraph::utils;

use strict qw(vars subs refs);

use vars qw( @EXPORT_OK %EXPORT_TAGS );
require Exporter;

@GIFgraph::utils::ISA = qw( Exporter );
 
@EXPORT_OK = qw( _max _min _round );
%EXPORT_TAGS = ( all => [qw(_max _min _round)],);

$GIFgraph::utils::prog_name    = 'GIFgraph::utils.pm';
$GIFgraph::utils::prog_rcs_rev = '$Revision: 1.1.1.1 $';
$GIFgraph::utils::prog_version = 
	($GIFgraph::utils::prog_rcs_rev =~ /\s+(\d*\.\d*)/) ? $1 : "0.0";

{
    sub _max { 
        my ($a, $b) = @_; 
		return undef	if (!defined($a) and !defined($b));
		return $a 		if (!defined($b));
		return $b 		if (!defined($a));
        ( $a >= $b ) ? $a : $b; 
    }

    sub _min { 
        my ($a, $b) = @_; 
		return undef	if (!defined($a) and !defined($b));
		return $a 		if (!defined($b));
		return $b 		if (!defined($a));
        ( $a <= $b ) ? $a : $b; 
    }

    sub _round { 
        my($n) = shift; 
		sprintf("%.0f", $n);
    }

    sub version {
        $GIFgraph::utils::prog_version;
    }

    $GIFgraph::utils::prog_name;

} # End of package MVU
