@echo off
setlocal enabledelayedexpansion
del output > nul 2>&1
wmic bios get serialnumber
for /f %%i in ('wmic diskdrive where "MediaType='Fixed hard disk media'" get index /format:list ^| find /c "Index"') do set DISKCOUNT=%%i
for /l %%x in (0, 1, !DISKCOUNT!) do (
	if %%x equ !DISKCOUNT! (
	goto :end
	)
	echo select disk %%x >> output
	echo clean all >> output
)
:end
diskpart /s output