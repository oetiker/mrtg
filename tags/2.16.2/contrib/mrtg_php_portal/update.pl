#!/bin/perl
#
#

my ($filelist,$file,$result);
my @f_list;

# Change the path to the folder where you store the mrtg .cfg files
$deleted=`del /F /Q c:\\mrtg\\conf\\*_l`;  # this is to remove the _l files before running Mrtg
$filelist=`dir /B c:\\mrtg\\conf\\*.cfg`; # Get the list of the cfg files
@f_list=split(/\n/,$filelist);

foreach $file (@f_list){
    if($file||($file ne "File not Found")||($file=~/\.cfg$/)){
	$result=`perl.exe e:\\mrtg\\bin\\mrtg e:\\mrtg\\conf\\$file`; # Run Mrtg for each host with a cfg file.
    }
}
