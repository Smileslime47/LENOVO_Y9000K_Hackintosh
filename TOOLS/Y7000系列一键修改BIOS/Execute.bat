@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges... 
goto request
) else (goto init)

:request
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:init
echo *************************************************************************************************
echo *                                                                                               *
echo * Disclaimer                                                                                    *
echo *                                                                                               *
echo * If you use this script to modify the bios and cause damage, you need to bear the consequences *
echo *                                                                                               *
echo * Support reprinting, but please indicate the source                                            *
echo *                                                                                               *
echo *************************************************************************************************
pause
pushd %~dp0
echo.
echo Initializing backup job...
echo.
WDFInst.exe
if exist Backup/SaSetup_Original.txt (
	echo existed SaSetup backup file
) else H2OUVE-W-CONSOLEx64.exe -gv Backup/SaSetup_Original.txt -n SaSetup

if exist Backup/PchSetup_Original.txt (
	echo existed PchSetup backup file
) else H2OUVE-W-CONSOLEx64.exe -gv Backup/PchSetup_Original.txt -n PchSetup

if exist Backup/CpuSetup_Original.txt (
	echo existed CpuSetup backup file
) else H2OUVE-W-CONSOLEx64.exe -gv Backup/CpuSetup_Original.txt -n CpuSetup

echo.
pause
goto start 

:BuckupBIOS
pushd %~dp0
echo.
.\fptw64.exe -d Backup/16mb.fd
.\fptw64.exe -bios -d Backup/11mb.fd
echo The BIOS backup is complete, please keep it safe! ! !
echo.
pause
goto start

:FalshBIOS
pushd %~dp0
echo.
echo Please put the BIOS file to be flashed under the FalshBIOS folder and rename it to "NewBios.bin"
echo.
echo Make sure that you have successfully performed the "6. Turn off the BIOS Lock" step and restart, otherwise the flashing will fail.
echo.
pause
if not exist "Backup/11mb.fd" (
	.\fptw64.exe -bios -d Backup/11mb.fd
)
if not exist "Backup/16mb.fd" (
	.\fptw64.exe -d Backup/16mb.fd
)
if exist "FalshBIOS/NewBios.bin" (
	echo Start writing, wait patiently, do not close the window! ! !
	.\fptw64.exe -f FalshBIOS/NewBios.bin -bios
) else (
	echo The NewBios.bin file is not found, please confirm that the file exists.
)
echo.
pause
goto start

:ReplaceBiosLogo
pushd %~dp0
echo.
echo Make sure that you have successfully performed the "6. Turn off the BIOS Lock" step and restart, otherwise the flashing will fail.
echo.
pause
if exist "Backup/11mb.fd" (
	if exist "logo/apple_logo_1.jpg" (
		if exist "logo/apple_logo_2.jpg" (
			UEFIReplace.exe Backup/11mb.fd FE4102C1-1B0C-4C92-B285-DC12F491C3A7 19 Logo/apple_logo_1.jpg -o FalshBIOS/AppleLogo_temp.bin -all
			UEFIReplace.exe FalshBIOS/AppleLogo_temp.bin FE4102C1-1B0C-4C92-B285-DC12F491C3A8 19 Logo/apple_logo_2.jpg -o FalshBIOS/AppleLogo.bin -all
			.\fptw64.exe -f FalshBIOS/AppleLogo.bin -bios
			del .\FalshBIOS\AppleLogo_temp.bin
		) else (
			echo Please add the logo file to be replaced to the Logo folder and rename it to apple_logo_2.jpg
		)
	) else (
		echo Please add the logo file to be replaced to the Logo folder and rename it to apple_logo_1.jpg
	)
) else (
	echo Please perform the backup BIOS operation first! ! !
)
echo.
pause
goto start

:SetKernelDebugSerialPort
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv SetKernelDebugSerialPort_Original.txt -n PchSetup
for /f "tokens=1,10" %%i in (SetKernelDebugSerialPort_Original.txt) do if %%i==00000000: (
	if %%j == 00 ( 
		echo Kernel Debug Serial Port Mode has been modified, no need to modify
		del SetKernelDebugSerialPort_Original.txt
		pause
		goto start		
	)
)
if exist "SetKernelDebugSerialPort.txt" (
    echo Writing.....
	H2OUVE-W-CONSOLEx64.exe -sv SetKernelDebugSerialPort.txt -n PchSetup
) else (
    if exist "SetKernelDebugSerialPort_Original.txt" (
		powershell -Command "(gc SetKernelDebugSerialPort_Original.txt) -replace '00000000: (.{23}) 03 (.*)', '00000000: $1 00 $2' | Out-File SetKernelDebugSerialPort.txt -Encoding ASCII"
		echo Writing.....
		H2OUVE-W-CONSOLEx64.exe -sv SetKernelDebugSerialPort.txt -n PchSetup
		del SetKernelDebugSerialPort_Original.txt
		del SetKernelDebugSerialPort.txt
	) else (
		echo unable to find SetKernelDebugSerialPort_Original.txt
	)
)
echo.
pause
goto start

:SetGraphicDevice
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv SetGraphicDevice_Original.txt -n SaSetup
for /f "tokens=1,14" %%i in (SetGraphicDevice_Original.txt) do if %%i==00000130: (
	if %%j == 04 ( 
		echo Graphics card mode has been modified, no need to modify
		del SetGraphicDevice_Original.txt
		pause
		goto start		
	)
)
if exist "SetGraphicDevice.txt" (
    echo ÕýÔÚÐ´Èë¡­¡­
	H2OUVE-W-CONSOLEx64.exe -sv SetGraphicDevice.txt -n SaSetup
) else (
    if exist "SetGraphicDevice_Original.txt" (
		powershell -Command "(gc SetGraphicDevice_Original.txt) -replace '00000130: (.{35}) 01 (.*)', '00000130: $1 04 $2' | Out-File SetGraphicDevice.txt -Encoding ASCII"
		echo Writing.....
		H2OUVE-W-CONSOLEx64.exe -sv SetGraphicDevice.txt -n PchSetup
		del SetGraphicDevice_Original.txt
		del SetGraphicDevice.txt
	) else (
		echo unable to find SetGraphicDevice_Original.txt
	)
)
echo.
pause
goto start

:SetGPIO
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv SetGPIO_Original.txt -n PchSetup
for /f "tokens=1,10" %%i in (SetGPIO_Original.txt) do if %%i==00000010: (
	if %%j == 01 ( 
		echo GPIO interrupt mode is enabled, no need to modify
		del SetGPIO_Original.txt
		pause
		goto start		
	)
)
if exist "SetGPIO.txt" (
    echo Writing.....
	H2OUVE-W-CONSOLEx64.exe -sv SetGPIO.txt -n PchSetup
) else (
    if exist "SetGPIO_Original.txt" (
		powershell -Command "(gc SetGPIO_Original.txt) -replace '00000010: (.{23}) 00 (.*)', '00000010: $1 01 $2' | Out-File SetGPIO.txt -Encoding ASCII"
		echo Writing.....
		H2OUVE-W-CONSOLEx64.exe -sv SetGPIO.txt -n PchSetup
		del SetGPIO_Original.txt
		del SetGPIO.txt
	) else (
		echo unable to find SetGPIO_Original.txt
	)
)
echo.
pause
goto start

:BiosLock
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv BiosLock_Original.txt -n PchSetup
for /f "tokens=1,9" %%i in (BiosLock_Original.txt) do if %%i==00000010: (
	set t1=%%j )
for /f "tokens=1,3" %%m in (BiosLock_Original.txt) do if %%m==000006D0: (
	set t2=%%n )

if %t1% == 00 (
	if %t2% == 00 (
		echo BIOS programming has been unlocked, no need to modify
		del BiosLock_Original.txt
		pause
		goto start )
)
if exist "BiosLock.txt" (
    echo Writing...
    H2OUVE-W-CONSOLEx64.exe -sv BiosLock.txt -n PchSetup
) else (
    if exist "BiosLock_Original.txt" (
		powershell -Command "(gc BiosLock_Original.txt) -replace '00000010: (.{20}) 01 (.*)', '00000010: $1 00 $2' | Out-File BiosLock_Temp.txt -Encoding ASCII"
		powershell -Command "(gc BiosLock_Temp.txt) -replace '000006D0: (.{2}) 01 (.*)', '000006D0: $1 00 $2' | Out-File BiosLock.txt -Encoding ASCII"		
		echo Writing...
		H2OUVE-W-CONSOLEx64.exe -sv BiosLock.txt -n PchSetup
		del BiosLock_Temp.txt
		del BiosLock_Original.txt
		del BiosLock.txt
	) else (
		echo unable to find BiosLock_Original.txt
	)
)
echo.
pause
goto ex

:CfgLock
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv CfgLock_Original.txt -n CpuSetup
for /f "tokens=1,16" %%i in (CfgLock_Original.txt) do if %%i==00000030: (
	if %%j == 00 ( 
		echo CFG Lock is unlocked, no need to modify
		del CfgLock_Original.txt
		pause
		goto start		
	)
)
if exist "CfgLock.txt" (
    echo Writing...
    H2OUVE-W-CONSOLEx64.exe -sv CfgLock.txt -n CpuSetup
) else (
    if exist "CfgLock_Original.txt" (
		powershell -Command "(gc CfgLock_Original.txt) -replace '00000030: (.{41}) 01 (.*)', '00000030: $1 00 $2' | Out-File CfgLock.txt -Encoding ASCII"
		echo Writing...
		H2OUVE-W-CONSOLEx64.exe -sv CfgLock.txt -n CpuSetup
		del CfgLock.txt
		del CfgLock_Original.txt
	) else (
		echo unable to find CfgLock_Original.txt
	)
)
echo.
pause
goto start

:SetDvmt
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv SetDvmt_Original.txt -n SaSetup
for /f "tokens=1,9" %%i in (SetDvmt_Original.txt) do if %%i==00000100: (
	if %%j == 02 ( 
		echo DVMT Pre-Allocated is already 64M, no need to modify
		del SetDvmt_Original.txt
		pause
		goto start		
	)
)
if exist "SetDvmt.txt" (
    echo Writing...
    H2OUVE-W-CONSOLEx64.exe -sv SetDvmt.txt -n SaSetup
) else (
    if exist "SetDvmt_Original.txt" (
		powershell -Command "(gc SetDvmt_Original.txt) -replace '00000100: (.{20}) 01 (.*)', '00000100: $1 02 $2' | Out-File SetDvmt.txt -Encoding ASCII"
		echo Writing...
		H2OUVE-W-CONSOLEx64.exe -sv SetDvmt.txt -n SaSetup
		del SetDvmt_Original.txt
		del SetDvmt.txt
	) else (
		echo unable to find SetDvmt_Original.txt
	)
)
echo.
pause
goto start

:start
cls
title Lenovo Y series one-click BIOS modification tool
:menu
echo.
echo =============================================================
echo.
echo Please select the operation
echo.
echo Savior Y7000 series black apple group: 1014806625 (full)
echo.
echo The rescuer Y7000 series black apple group: 216384299
echo.
echo =============================================================
echo.
echo For all laptops, execute steps 5, 7, 8 one-by-one.
echo.
echo For laptops with 8th-gen processors, execute step 4 as well.
echo.
echo =============================================================
echo.
echo  1. Backup current BIOS
echo.
echo  2. Flash your own BIOS
echo.
echo  3. Replace BIOS OEM LOGO
echo.
echo  4. Set kernel debug serial port
echo.
echo  5. Touchpad to enable GPIO mode
echo.
echo  6. Shut down BIOS Lock
echo.
echo  7. Shut down CFG Lock
echo.
echo  8. Modify DVMT to 64M
echo.
echo  0. Exit settings
echo.
echo.

:sel
set sel=
set /p sel= please_choose:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="0" goto ex
if /i "%sel%"=="1" goto BuckupBIOS
if /i "%sel%"=="2" goto FalshBIOS
if /i "%sel%"=="3" goto ReplaceBiosLogo
if /i "%sel%"=="4" goto SetKernelDebugSerialPort
if /i "%sel%"=="5" goto SetGPIO
if /i "%sel%"=="6" goto BiosLock
if /i "%sel%"=="7" goto CfgLock
if /i "%sel%"=="8" goto SetDvmt
echo Invalid choice, please re-enter
echo.
goto sel
echo.

:ex
choice /C yn /M "Y: restart now N: restart later"
if errorlevel 2 goto end
if errorlevel 1 goto restart

:restart
%systemroot%\system32\shutdown -r -t 0

:end
echo Thanks to the group friends of Xiaoxin pro13 for providing the basic script