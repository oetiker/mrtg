Monitor v.1.1b
~~~~~~~~~~~~~~
Hi, welcome to the world of Monitor.  This is my first ASP based contribution towards the Internet community at large, but
I hope that there will be lots more to come.

Monitor is a system designed by me with the use of MRTG.  This application will be of most use to Internet Service Providers
who may have a range of clients on Lease Lines running from their backbone.  The system uses a database which keeps record
of all the customers who have Leased Lines.

The database holds the following information:
		LineNumber    (Or Circuit Number)
		LinePassword  (A Password Protecting The Circuit On Monitor)
		EMail_Address (This will be used in a later version)
		Graph_Day     (Enable The Daily Graph)
		Graph_Week    (Enable The Weekly Graph)
		Graph_Month   (Enable The Monthly Graph)
		Graph_Year    (Enable The Yearly Graph)
                Graph_EMail   (This will be used in a later version)

With this information, Monitor provides an easy way for clients to see and monitor their traffic usage after logging into
the monitoring system.  The users are then also provided with the option to customise the layout of their monitoring system,
allowing them to only see the graphs that they need.

Because this is a ASP application, the system has to be hosted on Windows NT Server, or a Unix based server that supports
ASP code.  For Unix based servers (or if this application is ported to the PHP3 Lanuage), the database routines will need
to be redone.  Unix' clones will almost certainly not support the same database methods as NT (This application is designed
to work with Microsoft's ADO engine for interest sakes).



What's Included:
~~~~~~~~~~~~~~~~
I've included the following files in the distribution:
		config.asp   - This is the ASP file where clients can customise the output from the Monitoring system.
		default.asp  - This is the ASP file where the authentication process will happen.
		global.asa   - global.asa takes care of the deletation of the graph images when a session is abandoned or 
                               expires.  We also make sure here that users start on the correct page when entering the
                               web site at any point or file.
		login.asp    - After successfull authentication, this page displays the graphs to the users.
		monitor.html - A page that you can use to explain the service to your clients.
		monitor.inc  - This file holds reference to the Database connection strings, aswell as Session information.
		readme.txt   - You're reading it.
		monitor.mdb  - The Database provided in Microsoft Access 2000 format.  (Please read below for more
		               information.)



Setup:
~~~~~~
Firstly, for the setup of this application on a NT based server, you need to install MRTG on Windows, and have this working.
If you want for some reason not to run MRTG from Windows NT, then please use Samba file sharing, and MAP THE DRIVE to the
Windows NT machine that will host the web pages.  NT will need PHYSICAL FILE ACCESS to the files (Read Only Access will be
sufficient).

Next, you can take the database (Monitor.mdb), and place this somewhere on your system.  The location of the database does 
not matter that much, seeing that you need to setup a ODBC DataSource Name (DSN), to point the the database file.  If you
do not want to use DSN connections, have a look in Monitor.inc and change the DSN entry there to point to the file path 
(DBQ entry).  You will also need to change Monitor.inc to have the correct DSN name in for the DSN you have just created.

Thirdly, you need to setup a bit of file permissions.  This is more than likely the trickiest part of the installation.  

Because MRTG graphs are updated dynamically, we need to implement a system where the graphs are stored OUTSIDE of the web
server.  We need the graphs outside the web server, so that people can't just link to the images on the monitoring system
with a simple <img src="...."> tag in ther html on a local web server.  This is accomplished with the use of the built in
ASP objects CopyFile and DeleteFile.   After a successfull login occured, the ASP code will copy the images (all four -
daily, weekly, monthly, and yearly), from a pre determined MRTG "spool" directory.  This directory will be a global
directory where MRTG saves the images from it's targets.  It can either be a share that is mapped to the local server, or a
local path on the Windows NT host.  You need to explictly give the Iusr_machinename user (or the user under which the IIS
process run), READ access on both the directory, aswell as all the files within.

This will allow the ASP code, to read the binary images from the directory, and copy them to inside the web site.  Next,
what you need to do permission wise, is assign READ, WRITE, and DELETE permissions on both the file and directory inside the
Monitor web site, where the target images will be copied to.  In this example package, the images are copied to the 
images/mrtg/ folder.  

Once you have your database setup, and the file permissions set up correctly, the site should work.  After login, the
application will copy the files from the MRTG spool directory, into it's target directory.  The graphs will then be 
displayed to the user, and will reside on the web server for as long as the session exist.  Once the user logs out, or
when the session expires, the ASP code will automatically issue the DeleteFiles directive which removes the images that
are copied from the MRTG spool directory after the user has logged in.  The images are re-copied at every refresh of the
page, so this will also ensure that images on the monitor web site will remain up-to-date, for as long as the client is 
logged into the system.

The supplied database is in Access 2000 form.  From what I've heard, Access 2000 is not compatible with older versions.
Should you have troubles using this database, please upgrade to Access 2000.  If this is a bit of a harsh thing to ask
(which I also presume), I have decided to include an SQL Script for the creation of the database.  The script is based on
Microsoft SQL Server 6.5, but will give you a pretty good idea on how the database should look inside Access...



Microsoft SQL 6.5 Database Script:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/****** Object:  Table dbo.Monitor_Authenticate    Script Date: 00/06/17 07:45:08 ******/
CREATE TABLE dbo.Monitor_Authenticate (
 ID int IDENTITY (1, 1) NOT NULL ,
 LineNumber numeric(18, 0) NOT NULL ,
 LinePassword varchar (8) NOT NULL ,
 LineSpeed numeric(18, 0) NOT NULL ,
 EMail_Address varchar (50) NOT NULL ,
 Graph_Day bit NOT NULL ,
 Graph_Week bit NOT NULL ,
 Graph_Month bit NOT NULL ,
 Graph_Year bit NOT NULL ,
 Graph_EMail bit NOT NULL ,
 LastVisit datetime NULL ,
 Comment varchar (255) NULL 
)
GO



Bugs & Problems:
~~~~~~~~~~~~~~~~
Yes, there are a few of them inside the code at the date when I released this.  Although they are nothing serious, I feel
that you should take note of this.

	- Client Authentication:  If the web user enteres a Curcuit number and password that do not exist in the database,
				  the Database engine responds with an error.  This will be fixed in a next release and 
				  is not a serious problem to overcome.  Possible solution is to code in a additional
				  if statement to check that the circuit number exist BEFORE the authentication process
				  is initiated.
	- Client Passwords:       The client password is limited in the database to 8 characters.  A JavaScript or something
				  similar should be implemented in the config page which will limit the passwords entered to
				  8 characters to reflect the limitation in the database.  As it is now, the entire password
				  is accepected, although only the first 8 are saved.
	- Date Formating:	  The 'LastVisit' date that is displayed on the pages needs to be re-formatted so that it is
				  more readable.  This change will more than likely be so that the dates will read:
					Mon, 19 June 2000, 20:13:11 

If there is anything else that is 'misbehaving' or that you believe can pose to be a problem, please do not hesitate to 
contact me where I will look into the matter, aswell as issue a update to the code should it be neccessary.



Contacting me:
~~~~~~~~~~~~~~
Please feel free to contact me at any time by sending mail to cgknipe@mweb.co.za,  I'm always looking forward to hearing
from people who uses my code and appreciates the value of implementations done by me.

