@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "OUTPUT_DIR=%USERPROFILE%\Desktop\ThinkPad-Linux-Install-Info"
set "THRESHOLD_BYTES=214748364800"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo ThinkPad Linux preflight
echo Output folder: "%OUTPUT_DIR%"
echo.

echo Capturing system information...
systeminfo > "%OUTPUT_DIR%\systeminfo.txt"
wmic computersystem get Name,Manufacturer,Model,SystemType,TotalPhysicalMemory /format:list > "%OUTPUT_DIR%\computer-system.txt"
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed /format:list > "%OUTPUT_DIR%\cpu-info.txt"
wmic bios get Manufacturer,SMBIOSBIOSVersion,ReleaseDate,SerialNumber /format:list > "%OUTPUT_DIR%\bios-info.txt"
wmic diskdrive get Model,InterfaceType,MediaType,Size,Status /format:list > "%OUTPUT_DIR%\physical-disk-info.txt"
wmic logicaldisk get DeviceID,Description,FileSystem,FreeSpace,Size,VolumeName /format:list > "%OUTPUT_DIR%\logical-disk-info.txt"
wmic memorychip get BankLabel,Capacity,Speed,Manufacturer,PartNumber /format:list > "%OUTPUT_DIR%\memory-info.txt"
wmic path win32_videocontroller get Name,AdapterRAM,DriverVersion,VideoProcessor /format:list > "%OUTPUT_DIR%\graphics-info.txt"
wmic nic where "NetEnabled=true" get Name,MACAddress,Speed /format:list > "%OUTPUT_DIR%\network-adapter-info.txt"

set "C_FREE_BYTES="
for /f "tokens=2 delims==" %%A in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value ^| find "="') do set "C_FREE_BYTES=%%A"

if not defined C_FREE_BYTES (
    echo Could not read free space for drive C:.
    echo Check "%OUTPUT_DIR%\logical-disk-info.txt" manually.
) else (
    > "%OUTPUT_DIR%\c-drive-free-space.txt" (
        echo C: free space in bytes: !C_FREE_BYTES!
        echo Threshold bytes for 200 GB: %THRESHOLD_BYTES%
    )
    call :CompareNumbers "!C_FREE_BYTES!" "%THRESHOLD_BYTES%"
    if "!COMPARE_RESULT!"=="GE" (
        echo C: free space looks sufficient for dual boot.
        echo Recommendation: shrink C: by 102400 MB or 153600 MB.
    ) else (
        echo Warning: C: free space is under 200 GB.
        echo Do not continue without cleanup.
    )
)

echo.
echo Exact Disk Management steps for shrinking C:
echo 1. Press Windows key + R.
echo 2. Type diskmgmt.msc and press Enter.
echo 3. Wait for Disk Management to load completely.
echo 4. Right-click the C: partition.
echo 5. Click Shrink Volume...
echo 6. Wait while Windows calculates available shrink space.
echo 7. In the amount to shrink box, enter 102400 for 100 GB or 153600 for 150 GB.
echo 8. Click Shrink.
echo 9. Leave the new space as Unallocated.
echo 10. Do not create a new partition there in Windows.

echo.
echo Final checklist before creating the Linux USB:
echo - Confirm your Windows files are backed up.
echo - Confirm the Desktop folder contains the saved hardware reports.
echo - Confirm C: still opens normally in Windows Explorer.
echo - Confirm you understand the shrink amount you plan to use.
echo - Confirm you will stop if Disk Management shows an unexpectedly small shrink limit.
echo - Confirm you have a USB flash drive ready for Linux Mint.
echo - Confirm you will not run DiskPart unless you choose the optional manual script.

echo.
echo Preflight complete. Review the files in:
echo "%OUTPUT_DIR%"
goto :eof

:CompareNumbers
set "LEFT=%~1"
set "RIGHT=%~2"
set "COMPARE_RESULT=LT"
call :TrimLeadingZeros LEFT
call :TrimLeadingZeros RIGHT
if not defined LEFT set "LEFT=0"
if not defined RIGHT set "RIGHT=0"
if "!LEFT!"=="!RIGHT!" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if not "!LEFT:~12!"=="" (
    if "!RIGHT:~12!"=="" (
        set "COMPARE_RESULT=GE"
        goto :eof
    )
)
if "!LEFT:~11!"=="" if not "!RIGHT:~11!"=="" goto :eof
if not "!LEFT:~11!"=="" if "!RIGHT:~11!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~10!"=="" if not "!RIGHT:~10!"=="" goto :eof
if not "!LEFT:~10!"=="" if "!RIGHT:~10!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~9!"=="" if not "!RIGHT:~9!"=="" goto :eof
if not "!LEFT:~9!"=="" if "!RIGHT:~9!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~8!"=="" if not "!RIGHT:~8!"=="" goto :eof
if not "!LEFT:~8!"=="" if "!RIGHT:~8!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~7!"=="" if not "!RIGHT:~7!"=="" goto :eof
if not "!LEFT:~7!"=="" if "!RIGHT:~7!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~6!"=="" if not "!RIGHT:~6!"=="" goto :eof
if not "!LEFT:~6!"=="" if "!RIGHT:~6!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~5!"=="" if not "!RIGHT:~5!"=="" goto :eof
if not "!LEFT:~5!"=="" if "!RIGHT:~5!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~4!"=="" if not "!RIGHT:~4!"=="" goto :eof
if not "!LEFT:~4!"=="" if "!RIGHT:~4!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~3!"=="" if not "!RIGHT:~3!"=="" goto :eof
if not "!LEFT:~3!"=="" if "!RIGHT:~3!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~2!"=="" if not "!RIGHT:~2!"=="" goto :eof
if not "!LEFT:~2!"=="" if "!RIGHT:~2!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT:~1!"=="" if not "!RIGHT:~1!"=="" goto :eof
if not "!LEFT:~1!"=="" if "!RIGHT:~1!"=="" (
    set "COMPARE_RESULT=GE"
    goto :eof
)
if "!LEFT!" GTR "!RIGHT!" set "COMPARE_RESULT=GE"
goto :eof

:TrimLeadingZeros
set "VALUE=!%~1!"
:TrimLoop
if "!VALUE!"=="" goto :TrimDone
if not "!VALUE:~0,1!"=="0" goto :TrimDone
set "VALUE=!VALUE:~1!"
goto :TrimLoop
:TrimDone
set "%~1=!VALUE!"
goto :eof
