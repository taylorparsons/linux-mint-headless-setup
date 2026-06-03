@echo off
setlocal EnableExtensions

set "OUTPUT_DIR=%USERPROFILE%\Desktop\Linux-Mint-Download"
set "MINT_DOWNLOAD_URL=https://www.linuxmint.com/download.php"
set "MINT_XFCE_URL=https://www.linuxmint.com/edition.php?id=327"
set "RUFUS_HOME_URL=https://rufus.ie/"
set "RUFUS_ARCHIVE_URL=https://rufus.ie/downloads/?pubDate=20260128"
set "STATUS_FILE=%OUTPUT_DIR%\download-status.txt"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

> "%STATUS_FILE%" (
    echo Linux Mint and Rufus download helper
    echo Output folder: %OUTPUT_DIR%
    echo.
    echo Linux Mint download page: %MINT_DOWNLOAD_URL%
    echo Linux Mint XFCE page: %MINT_XFCE_URL%
    echo Rufus home page: %RUFUS_HOME_URL%
    echo Rufus 3.22 archive page: %RUFUS_ARCHIVE_URL%
    echo.
    echo This script opens the official pages and points you to the working Rufus 3.22 archive page.
    echo Linux Mint ISO download still needs you to choose the mirror and save the file.
)

echo Opening the official Linux Mint and Rufus pages...
start "" "%MINT_DOWNLOAD_URL%"
start "" "%MINT_XFCE_URL%"
start "" "%RUFUS_HOME_URL%"
start "" "%RUFUS_ARCHIVE_URL%"

echo.
echo Download Rufus 3.22 manually from the archive page that just opened.
echo That archive page is the working Windows 7 source.
>> "%STATUS_FILE%" echo Use the archive page to download Rufus 3.22 manually.

echo.
echo Next steps:
echo 1. In the browser, use the Linux Mint XFCE page to choose a mirror.
echo 2. Download the Linux Mint XFCE 64-bit ISO.
echo 3. On the archive page, click Rufus 3.22 and save it.
echo 4. Run Rufus 3.22 after the ISO download finishes.
echo.
echo Review this file for the links and result:
echo %STATUS_FILE%
pause
