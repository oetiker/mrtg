#!/usr/sepp/bin/perl-5.8.8
undef $/; #slurp alll 
$_ = <>;
while (s/<page[\s\n\r]+(\S+)\s*=\s*(?:"([^"]+)"|([^"\s>]+))/<page/si){
  chomp($VAL{uc($1)}= $2 ? $2: $3);
}

if ($VAL{TYPE} eq 'lone') {
  $sub="_$VAL{TYPE}";
}

s|<page[\s\n\r]*/?>|#include <inc/template${sub}.inc> PAGE="$VAL{PAGE}" AUTHOR="$VAL{AUTHOR}" TYPE="$VAL{TYPE}"\n|si;

print;

