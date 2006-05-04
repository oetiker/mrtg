#!/usr/local/bin/perl5
# -*- mode: Perl -*-
##################################################################
# This file updates the installation specific values
##################################################################
# Created by Laurie Gellatly <gellatly@one.net.au>
#################################################################
#
# Distributed under the GNU copyleft
#
# $Id: installov.pl,v 1.1.1.1 2002/02/26 10:16:36 oetiker Exp $
#
use strict;
use vars '$DEBUG';
my $DEBUG = 0;

my($cmdfile,$cnt,$cntl,$infile,$delim,$s,$sysn,@cmds,@lines,@to,@from); 

sub main {

  $cmdfile = $ARGV[0];
  shift @ARGV;
  $infile = $ARGV[0];
  die <<USAGE  unless $cmdfile && $infile;

USAGE: installov cmdfile script/s

EXAMPLE:  installov installov.cmd ovadd ovdel mrtgmenu


USAGE
   open (CMD,"<".$cmdfile);
   @cmds = <CMD>;
   close (CMD);
   chomp (@cmds);
   for ($cnt = 0; $cnt < @cmds; ++$cnt){
      if ('s' eq substr($cmds[$cnt],0,1)){
         $delim = substr($cmds[$cnt],1,1);
         ($s,$from[$cnt],$to[$cnt]) = split (/$delim/,$cmds[$cnt]);
      }
   }
   while ($infile){
      open (SCRIPTF,"<".$infile);
      @lines = <SCRIPTF>;
      close (SCRIPTF);
      chomp(@lines);
      for ($cntl = 0; $cntl < @lines; ++$cntl){
         for ($cnt = 0; $cnt < @to; ++$cnt){
            $lines[$cntl] =~ s~$from[$cnt]~$to[$cnt]~;
         }
      }
      open (SCRIPTF,">".$infile);
      for ($cntl = 0; $cntl < @lines; ++$cntl){
         print SCRIPTF $lines[$cntl]."\n";
      }
      close (SCRIPTF);
      shift @ARGV;
      $infile = $ARGV[0];
   }
}

main;
exit(0);

