use strict;
use warnings;

use Test::More tests => 1;

use FindBin;
use lib "${FindBin::Bin}/../lib/mrtg2";
use locales_mrtg "0.08";

my $LOC = $lang2tran::LOCALE{"brazilian"};
unlike( &$LOC("The statistics were last updated <strong>Ter&ccedil;a, 26 de Outubro"),
        qr/Sa&iacute;ubro/, "Issue #74");

