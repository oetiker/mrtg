
Set hostsfile=e:\cisco_devices_to_poll.txt

Set PARSEARG="eol=; tokens=1,2,3* delims=:,	"


For /F %PARSEARG% %%i in (%hostsfile%) Do START /BELOWNORMAL e:\mrtg\prod\bats\RUN_builder.bat %%i %%j %%k


exit
