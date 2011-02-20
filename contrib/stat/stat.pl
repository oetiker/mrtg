#!/usr/bin/perl -w
# $Id: stat.pl,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
####################
# New updates for stat.pl
####################
%D_STAT=(
    RQ => 0,
    RR => 1,
    RIQ => 2,
    RNXD => 3,
    RFwdQ => 4,
    RFwdR => 5,
    RDupQ => 6,
    RDupR => 7,
    RFail => 8,
    RFErr => 9,
    RErr => 10,
    RTCP => 11,
    RAXFR => 12,
    RLame => 13,
    ROpts => 14,
    SSysQ => 15,
    SAns => 16,
    SFwdQ => 17,
    SDupQ => 18,
    SFail => 19,
    SFErr => 20,
    SErr => 21,
    RNotNsq => 22,
    SNaAns => 23,
    SNXD => 24,
);                     
# This file is to feed mrtg with right information.
# You could do this more fancy with up-time and stuff like that,
# but that will be maybe in a couple of versions upward.
# This works and i dont want to be like other big companys that gives out
# Programs that want work but is all that fancy.
#
# Any way please do change this files so the right PATH to youre scripts
# are there.
# Requirements:
# this scripts require MRTG (of course), i wont get in how to configure this,
# because im not sure how to do it correctly, i manged to get it to work.
# but i sugest you take a real good look how to configure MRTG.
# more requirement is , perl version 5.004_05. Look at the documentation
# on MRTG this one needs you to have some patches for some OS.
#
# If you want to use getting iformation from a remote DNS, sure you could use
# my script dns.named but beware that this is NOT safe maybe you should use 
# If you want to use getting iformation from a remote DNS, sure you could use
# scp to get youre file, but if not, be sure to set the rights so no non-auth
# could see what password is.
# dns.named requires expect version 5.26.0 (i havent tested on other versions)
#
# im not the greatest script maker but i managed this to work, but if
# you have any comments or you have some great changes please be free to send them to calle@volvo.se                                          

# HOSTNAME youre domain this will show up in the web-page
#
# OK now to this new version of this program
# $LOG is where you find youre named.stats *
# in Bind 8.2.1 the way to get youre named.stats is "ndc stats"
# in Bind 4.9.3 kill -ABRT `cat /var/run/named.pid`
# in Bind kill -ILL `cat /var/run/named.pid`
# 
# $RUN you have to set that to where youre script is set to run ex my $RUN = "/home/myhomeaccount/";
#  
# now to the real new thing that is you can have 2 graphs in one MRTG session
# you have to set the $INCOMING and $OUTGOING, $INCOMING  = $D_STAT{"RQ"}; <-- this one needs to be set to look
# for wich Data you want to see on the first Graph (RQ is Requested Queries)
#
# now to the other $OUTGOING = $D_STAT{"RFail"}; i set default but can be changed for what you want
# RFail Requested Failure i done a short list of What some of them means , but if you want to have a complete list 
# you could look into the DNS and Bind book from O'reilly page 166
#
# Short list of some of the things you could pull out
#
# RQ: Requested Queries.
# RR: Count of responses recieved from relay.
# RIQ: Count of reverse queries recieved from relay.
# RNXD: Count of "no such domain" answeres.
# RFwdQ: Count of queries received from relay that nedded more processing
# RFwdR: Count of is the reponses recived from relay that answered the
# original query and were passed back to application.
# RDupR: Is the count of duplicat response from relay.
# RFail: Is the count of SERVFAIL response from relay.
# RFErr: is the count of FORMERR response from relay. 
# RErr: is the count of errors that werent either SERVFAIL or FORMERR
# RLame: Count of lame DELEGATIONS.
# and so on read the book. 

my $HOSTNAME = "HOST\.YOURE\.DOMAIN";   
my $LOG = "/home/";
my $RUN = "/home/";

my $INCOMING  = $D_STAT{"RQ"};
my $OUTGOING = $D_STAT{"RFail"};



#######################################
#### Please Dont toch this part
######################################
my $QUE_P_MIN =();
my $QUE_P_OTHER = ();
my @N_STATS=();
my @OLD_S=();
my $UPTIME = ();


sub HIST {
    
    open (STAT , "$LOG") or die "could not find or open file $LOG";
    @N_STAT = <STAT>;
    close (STAT);           

    
    open (V_OLD , "$RUN/OLD");
    my @OLD_S = <V_OLD>;
    close (V_OLD); 
    
    	
   
    my $G_FLAG = "no";

    

    foreach $line (@N_STAT) {
        
        if ( $line =~ m/^([0-9]+)\s+\S+\s+\S+\sreset/ ){
	    $UPTIME = $1;
	}
	
	if ( $G_FLAG =~ /yes/) {
	    
	    my @NUM_QUE=split ' ',$line;
            open ( LOGGER , "> $RUN/OLD");

            print LOGGER "$NUM_QUE[$INCOMING]\n";
	    print LOGGER "$NUM_QUE[$OUTGOING]\n";

            close ( LOGGER );
	    $QUE_P_MIN = $NUM_QUE[$INCOMING]-$OLD_S[0];
	    $QUE_P_OTHER = $NUM_QUE[$OUTGOING]-$OLD_S[1];
            $G_FLAG = "no";
        }                                 
	
	


	if ($line =~ /(Global)/) {
	    $G_FLAG = "yes";
	}
    }
    
    print "$QUE_P_MIN\n$QUE_P_OTHER\n$UPTIME\n$HOSTNAME\n";
}

&HIST();
	




    




