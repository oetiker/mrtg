set target=%1
set snmpStr=%2
set targetIP=%3
set NewDir=%mrtgwebroot%\%target%
set mrtgcurr=e:\mrtg\prod\bats

e:
cd\
MD %NewDir%
if not exist %mrtgwebroot%\%target%\default.asp copy %mrtgcurr%\default.asp %mrtgwebroot%\%target%\default_fixme.asp

cd %mrtgbin%
%perlbin%\perl %mrtgbin%\cfgmaker --workdir %mrtgwebroot%\%target% %snmpstr%@%targetIP% > %Mrtgcfgbin%\%target%.cfg



e:
cd\mrtg\prod\bats
exit