@echo off
setlocal enabledelayedexpansion
if exist "output" (
	del output
)
wmic bios get serialnumber
set DISKPOSITION=0
for /f %%i in ('wmic diskdrive ^| find /c "Fixed hard disk media"') do set DISKCOUNT=%%i
if !DISKCOUNT! equ 0 (
	echo Internal storage not found.
	set USBDRIVE=%cd:~0,2%
	if not exist !USBDRIVE!\driver\iaStorAC.inf (
		echo Drivers may be needed to detect the internal storage. 
		echo Please copy the extracted Intel Rapid Storage driver in a folder named driver then execute this script again.
		goto :end
	)
	echo Loading Intel Rapid Storage driver and trying again.	
	drvload !USBDRIVE!\driver\iaStorAC.inf
	set DISKPOSITION=1
	for /f %%i in ('wmic diskdrive ^| find /c "Fixed hard disk media"') do set DISKCOUNT=%%i
	if !DISKCOUNT! equ 0 (
		echo Internal storage not found.
		goto :end
	)
)
for /l %%x in (!DISKPOSITION!, 1, !DISKCOUNT!) do (
	if !DISKPOSITION! equ 0 (
		if %%x equ !DISKCOUNT! (
		goto :diskpart
		)
		echo select disk %%x >> output
		echo clean all >> output
	)
	if !DISKPOSITION! equ 1 (
		echo select disk %%x >> output
		echo clean all >> output
		if %%x equ !DISKCOUNT! (
		goto :diskpart
		)
	)
)
:diskpart
diskpart /s output
:end