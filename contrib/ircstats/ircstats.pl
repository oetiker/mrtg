#!/usr/local/bin/perl5
# client.pl  v1.5 7 Oct 1997 Matthew Ramsey <mjr@blackened.com>
# http://www.blackened.com/ircstats/
# A simple perl script I use to grab client info on IRC Servers.  While
# it was designed for connecting to an IRC Server, it can easily be
# modified to be used for other purposes.
# Special thanks to Chris Behrens and Doug McLaren.

use Socket;

$DEBUG = 0;

if ($ARGV[0]) {
   $irchost = $ARGV[0] ;
} else {
   print STDERR "Usage: $0 <irc server>\n" ;
   exit 1 ;
}


#$irchost = "irc-e.primenet.com";
$ircport = "6666";
$nick1 = "alskdjf";
$nick2 = "aselkr";

($locclients, $totclients, $numserv, $numchan) =
        getinfo($irchost, $ircport);
$time = time();
print "$locclients\n";
print "$locclients\n";
print "$time\n";
print "";

exit; # We're done!

sub connect_host
{
        local($ip, $port) = @_;

        ($d1, $d2, $proto) = getprotobyname("tcp");
        ($d1, $d2, $d3, $d4, $rawclient) = gethostbyname(`hostname`);
        ($d1, $d2, $d3, $d4, $rawserver) = gethostbyname($ip);
        $clientaddr = pack("Sna4x8", 2, 0, $rawclient);
        $serveraddr = pack("Sna4x8", 2, $port, $rawserver);
        socket(SOCKET, AF_INET, SOCK_STREAM, $proto) || die "No socket: $!";
        bind(SOCKET, $clientaddr);
        connect(SOCKET, $serveraddr) || die "connect failed: $!";
        select(SOCKET);
        $| = 1;
        select(STDOUT);
}

sub getinfo
{
        local($host, $port) = @_;
        local($lc, $ts, $ns, $nc);

        $lc = "0";
        $ts = "0";
        $ns = "0";
        $nc = "0";
        connect_host($host,  $port);
        print SOCKET "user efnet jskd fksj fkjs fkjsfk jfk\nnick 
$nick1\nlusers\n";
        while(<SOCKET>)
        {
                chomp();
                @args = split(' ', "$_");
                if (substr($args[0], 0, 1) eq ":")
                {
                        if ($args[1] eq "433")
                        {
                                print SOCKET "nick $nick2\nlusers\n";
                        }
                        elsif ($args[1] eq "251")
                        {
                                $tc = $args[5] + $args[8];
                                $ns = $args[11];
                        }
                        elsif ($args[1] eq "254")
                        {
                                $nc = $args[3];
                        }
                        elsif ($args[1] eq "255")
                        {
                                $lc = $args[5];
                                last;
                        }
                }
        }
        close(SOCKET);
        return ($lc, $tc, $ns, $nc);
}
