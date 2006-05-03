#!/usr/bin/perl
#
# usage: ./mergelocale.pl skeleton.pm0 lang1.pmd lang2.pmd
# the script then creates locales_mrtg.pm
#
# If you want to modify a locale, modify the pmd file and rerun 
# this script and copy the generated locales_mrtg.pm to the run directory.
#
# If you want to translate a locale, copy one of the existing locales and 
# translate. Then rerun and copy. 
#
#################################################################
#
# Distributed under the GNU copyleft
#
###################################################################

open(OUTFILE,"> locales_mrtg.pm");

@patchdb=(
'PATCHTAG\s*00',
'PATCHTAG\s*10',
'PATCHTAG\s*20',
'PATCHTAG\s*30',
'PATCHTAG\s*40',
'PATCHTAG\s*50',
'PATCHTAG\s*60',
);

while(@ARGV){
  push(@languages,shift);
};

foreach $patchtag (@patchdb)
{
  for $i (@languages)
  {
    open(LANGF,"< $i");
    $patch="";
    while(<LANGF>)
    {
      if(/\#.\S*PATCHTAG/)
      { 
        $patch=/$patchtag/;
      }
      else
      {
        if($patch) { print OUTFILE $_; };
      };
    };
  };
};
