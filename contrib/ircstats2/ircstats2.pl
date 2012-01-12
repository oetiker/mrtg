#!/usr/bin/perl
# ircstats2.pl v1.3 06 Apr 2001 Lucas Nussbaum <lucas@schickler.net>
# More info can be found on http://www.schickler.net/lucas/ircstats2.php
# based on ircstats from Matt Ramsey (MR227) mjr@geeks.org, mjr@nin.com
# Used to generate stats on the Kewl.Org IRC Network
# If you see something that should be changed, please notify me !

use Socket;

# pseudo-client parameters
$nick = "StatsMaker234";
$ident = "Stats";
$realname = "http://www.schickler.net/lucas/";

# server and port to connect to
$ircserver = "127.0.0.1";
$ircport = "6667";

# Where to store the output data (directory MUST exist)
# The number of users on each server will be in a file named like the server.
# An additionnal file named 'global' will be created, containing the sum of
# all servers' users.
# An example configuration file is included.
$datapath = "/home/lucas/ircstats2/temp";

# Where to put the PID file
$pidfile = "/home/lucas/ircstats2/ircstats2.pid";

# NOTE: Set those variables to 0 to enable, put a # in front of the 
# lines to disable.
# Count the global number of users in "globalusersmrtg" file (MRTG format)
$globalusersmrtg=0;
# Count the channels in "channelsmrtg" file (MRTG format)
$channelsmrtg=0;
# Count the global number of ircops in "ircopsmrtg" file (MRTG format)
$ircopsmrtg=0;
# Count the number of servers in "serversmrtg" file (MRTG format)
$serversmrtg=0;
# Count the global number of users in "globalusersplain" file
# (Plain text, to be used with others scripts)
$globalusersplain=0;
# Count the channels in "channelsplain" file (Plain text, 
# to be used with others scripts)
$channelsplain=0;
# Count the global number of ircops in "ircopsplain" file
# (Plain text, to be used with others scripts)
$ircopsplain=0;
# Count the number of servers in "serversmrtg file (MRTG format)
$serversplain=0;
# ircops number offset (not to count services, for example)
$ircopsoffset=0;
# servers number offset (not to count services, for example)
$serversoffset=0;

# Servers to poll
$server{"cybernet.langochat.net"}=0;
$server{"sicfa.langochat.net"}=0;
$server{"free.langochat.net"}=0;
$server{"jeuxgroup.langochat.net"}=0;
$server{"diligo.langochat.net"}=0;

##############################################
### DO NOT MODIFY ANYTHING BELOW THIS LINE ###
##############################################

print "Now daemonizing ...\n";
&daemonize;

if (!(($globalusersmrtg eq "")&&($globalusersplain eq "")&&($channelsmrtg eq "")&&($channelsplain eq "")&&($ircopsmrtg eq "")&&($ircopsplain eq "")&&($serversplain eq "")&&($serversmrtg eq ""))) {
	$needlusers=1;
}
($g, $g, $proto) = getprotobyname("tcp");
while (true) {
	($g, $g, $g, $g, $rawserver) = gethostbyname($ircserver);
	if ($rawserver) {
		$serveraddr = pack("Sna4x8", 2, $ircport, $rawserver);
		socket(SOCKET, AF_INET, SOCK_STREAM, $proto) || die "No socket: $!";
		if (connect(SOCKET, $serveraddr)){
			select(SOCKET); $| = 1;
			select(STDOUT); $| = 1; 
			print SOCKET "USER $ident a b :$realname\n";
			print SOCKET "NICK $nick\n";
			while (<SOCKET>){
				@i = split(" ",$_);
				if ($i[1] eq "433") {print SOCKET "NICK ".$nick.time()."\n";}
				elsif ($i[1] eq "437") {print SOCKET "NICK ".$nick.time()."\n";}
				elsif ($i[1] eq "376") {&getinfo;}
				elsif ($i[1] eq "402") {$server{lc($i[3])}=0;}
				elsif ($i[1] eq "265") {
					$i[0]=~s/\://;
					$server{lc($i[0])}=$i[6];
				}
				elsif ($i[1] eq "266") {
					if ($globalusersmrtg ne "") {
						$globalusersmrtg=$i[6];
					}
					if ($globalusersplain ne "") {
						$globalusersplain=$i[6];
					}
				}
				elsif ($i[1] eq "254") {
					if ($channelsmrtg ne "") {
						$channelsmrtg=$i[3];
					}
					if ($channelsplain ne "") {
						$channelsplain=$i[3];
					}
				}
				elsif ($i[1] eq "251") {
					if ($serversmrtg ne "") {
						$serversmrtg=$i[11]-$serversoffset;
					}
					if ($serversplain ne "") {
						$serversplain=$i[11]-$serversoffset;
					}
				}
				elsif ($i[1] eq "252") {
					if ($ircopsmrtg ne "") {
						$ircopsmrtg=$i[3]-$ircopsoffset;
					}
					if ($ircopsplain ne "") {
						$ircopsplain=$i[3]-$ircopsoffset;
					}
				}
				elsif ($i[0] eq "PING") {
					&saveinfo;
					print SOCKET "PONG $i[1]\n";
					&getinfo;
				}
			}
		}
		close(SOCKET);
	}
	sleep(120);
}

sub saveinfo {
	foreach $s (keys %server){
		open(OUTPUT,">$datapath/$s");
		print OUTPUT "$server{$s}\n$server{$s}\n$time\n";
		close(OUTPUT); 
	}
	if ($globalusersmrtg ne "") {
		open(OUTPUT, ">$datapath/globalusersmrtg");
		print OUTPUT "$globalusersmrtg\n$globalusersmrtg\n$time\n";
		close(OUTPUT);
	}
	if ($channelsmrtg ne "") {
		open(OUTPUT, ">$datapath/channelsmrtg");
		print OUTPUT "$channelsmrtg\n$channelsmrtg\n$time\n";
		close(OUTPUT);
	}
	if ($serversmrtg ne "") {
		open(OUTPUT, ">$datapath/serversmrtg");
		print OUTPUT "$serversmrtg\n$serversmrtg\n$time\n";
		close(OUTPUT);
	}
	if ($ircopsmrtg ne "") {
		open(OUTPUT, ">$datapath/ircopsmrtg");
		print OUTPUT "$ircopsmrtg\n$ircopsmrtg\n$time\n";
		close(OUTPUT);
		$ircopsmrtg=0; # raw 252 pas disp si pas opers

	}
	if ($globalusersplain ne "") {
		open(OUTPUT,">$datapath/globalusersplain");
		print OUTPUT "$globalusersplain";
		close(OUTPUT);
	}
	if ($channelsplain ne "") {
		open(OUTPUT, ">$datapath/channelsplain");
		print OUTPUT "$channelsplain";
		close(OUTPUT);
	}
	if ($serversplain ne "") {
		open(OUTPUT, ">$datapath/serversplain");
		print OUTPUT "$serversplain";
		close(OUTPUT);
	}
	if ($ircopsplain ne "") {
		open(OUTPUT, ">$datapath/ircopsplain");
		print OUTPUT "$ircopsplain";
		close(OUTPUT);
		$ircopsplain=0; # raw 252 pas disp si pas opers
	}
}

sub getinfo {
	foreach $s (keys %server) {
		print SOCKET "lusers * $s\n";
	}
	$time=time();
	if ($needlusers==1) {
		print SOCKET "lusers\n";
	}
}

sub daemonize () {
	chdir "/" or die "Can't chdir to /: $!";
	open STDIN, "/dev/null" or die "Can't read /dev/null: $!";
	open STDOUT, ">/dev/null" or die "Can't write to /dev/null: $!";
	defined (my $pid = fork) or die "Can't fork: $!";
	if ($pid) {
		if ($pidfile) {
			open(PIDFILE,">$pidfile");         
			print PIDFILE "$pid\n";                           
			close(PIDFILE);
		}
		exit;
	}
	setsid or die "Can't start a new session: $!";
	open STDERR, ">&STDOUT" or die "Can't dup stdout: $!";
}
