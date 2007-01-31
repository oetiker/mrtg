Mrtg PHP 'Portal'
-----------------

Intro:
I've made these quick hacks to provide a 'user-friendly' web interface for adding, removing and updating the mrtg polled hosts.
The PHP scripts grab the parameters from html forms and run cfgmaker, indexmaker and mrtg with these parameters.

Requirement:
Web server with PHP4
Perl

Configuration of the script:
Desarchive the mrtg_php_portal.zip file in your mrtg and put the perl script 'Update.pl' in the mrtg folder (e.g.: c:\mrtg), put the Php script config file 'config.inc.php' in the conf folder (e.g.: c:\mrtg\conf), put the 6 remaining php script in the www folder (e.g.: c:\mrtg\www).
Summary of the script usage:
- update.pl, this script takes all the .cfg file in conf and update the Mrtg stats for these configs. You can run this script with MrtgSvc or 5mrtg.
- config.inc.php, this is the file were all paths and passwords for the script are configured.
- index.php, this script generates a single index with a link to all the .html file located in e:\mrtgwww.
- login.php, this script protect the admin section with a password configured in the config.inc.php file.
- setup.php, this script generate the mrtg config file with cfgmaker, create a index file for the new host and run mrtg with the parameters from the form.
- remove.php, this script delete the config file, html file and index file of a host that need to be removed.
- admin.php, this script create a html page with the admin choice (add, remove, update).
- Update.php, this script re-run mrtg for the selected host.
Edit the config.inc.php and configure the path for the environment and configure the admin password also.


Thanks:
To 'Putzi' (he will recognize himself) for the help with Perl.

Contact:
Damien Hauser
damien@detonate.net
