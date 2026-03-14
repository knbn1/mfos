::  Source code of MicroflashOS
::  A "fantasy operating system" made by KNBnoob1!
::  Website: https://knbn1.github.io

@echo off

:: Setting some variables on startup

set "sysdir=MicroflashOS"
set "disk=%~p0%sysdir%"
set "fbver=4.4"
set "usrdir=userdata"
set "osdata=mfosdata"
set "pkgrepo=GigaflashOS Unified Repository [Revision 1]"
set "mfver=2026.03.15"

:: Rewrite version when DevTools are found

if not exist "%disk%/system/extra-mods/devtools.mfm" (set "new_mfver=%mfver%")
if exist "%disk%/system/extra-mods/devtools.mfm" (set "new_mfver=%mfver%-dev")

:: Boot process starts

:reboot
title MicroflashOS Bootloader
if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/echoon" (@echo on)
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/noclear" (cls)
cd /d %~p0
echo.
echo Detected kernel: %new_mfver%
echo.
if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (echo Slowboot toggle is enabled. && pause && echo.)

:: System disk check

title Finding system disk...
if exist "%sysdir%" (echo System disk '%sysdir%' mounted as /) else (
echo Unable to mount system disk!
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo.
pause
goto recovery
)

:: Initialize devices

echo.
title Initializing devices...
echo Initializing devices...
echo.

if not exist "%disk%/system/devices" (cd /d "%disk%/system/" && md devices)
if not exist "%disk%/system/devices/mem" (cd /d "%disk%/system/devices" && md mem)
if not exist "%disk%/system/devices/storage" (cd /d "%disk%/system/devices" && md storage)

echo Memory sector 1 - Core system files>"%disk%/system/devices/mem/memsect1"
if not exist "%disk%/system/devices/mem/memsect1" (echo Could not initialize device "memsect1" && echo. && pause && goto recovery)
echo Initialized device "memsect1"

echo Memory sector 2 - Userspace>"%disk%/system/devices/mem/memsect2"
if not exist "%disk%/system/devices/mem/memsect2" (echo Could not initialize device "memsect2" && echo. && pause && goto recovery)
echo Initialized device "memsect2"

echo Memory sector 3 - Secret Block>"%disk%/system/devices/mem/memsect3"
if not exist "%disk%/system/devices/mem/memsect3" (echo Could not initialize device "memsect3" && echo. && pause && goto recovery)
echo Initialized device "memsect3"

echo Human Interface Devices>"%disk%/system/devices/hids"
if not exist "%disk%/system/devices/hids" (echo Could not initialize device "hids" && echo. && pause && goto recovery)
echo Initialized device "hids"

echo Auditory devices: headphones, speakers, microphones, etc. >"%disk%/system/devices/audio"
if not exist "%disk%/system/devices/audio" (echo Could not initialize device "audio" && echo. && pause && goto recovery)
echo Initialized device "audio"

echo System disk partition 1 - /system>"%disk%/system/devices/storage/disk0p1"
if not exist "%disk%/system/devices/storage/disk0p1" (echo Could not initialize device "disk0p1" && echo. && pause && goto recovery)
echo Initialized device "disk0p1"

echo System disk partition 2 - /userdata>"%disk%/system/devices/storage/disk0p2"
if not exist "%disk%/system/devices/storage/disk0p2" (echo Could not initialize device "disk0p2" && echo. && pause && goto recovery)
echo Initialized device "disk0p2"

if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (echo. && pause)

:: Start loading sysmodules

title Loading sysmodules...
echo.
echo Loading sysmodules...
echo.

:: Initialization of core sysmodules

if exist "%disk%/system/ltmem.mcm" (echo Loaded /system/ltmem.mcm) else (
echo Could not load /system/ltmem.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/stmem.mcm" (echo Loaded /system/stmem.mcm) else (
echo Could not load /system/stmem.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/core.mcm" (echo Loaded /system/core.mcm) else (
echo Could not load /system/core.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/fsutils.mcm" (echo Loaded /system/fsutils.mcm) else (
echo Could not load /system/fsutils.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/recovery.mcm" (echo Loaded /system/recovery.mcm) else (
echo Could not load /system/recovery.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/cmd.mcm" (echo Loaded /system/cmd.mcm) else (
echo Could not load /system/cmd.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/kernel.mcm" (echo Loaded /system/kernel.mcm) else (
echo Could not load /system/kernel.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/compact.mcm" (echo Loaded /system/compact.mcm) else (
echo Could not load /system/compact.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/proctector.mcm" (echo Loaded /system/proctector.mcm) else (
echo Could not load /system/proctector.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/system/mfpkg.mcm" (echo Loaded /system/mfpkg.mcm) else (
echo Could not load /system/mfpkg.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

:: Initialization of non-critical sysmodules

if exist "%disk%/system/extra-mods/sensors.mfm" (echo Loaded /system/extra-mods/sensors.mfm)
if exist "%disk%/system/extra-mods/audio.mfm" (echo Loaded /system/extra-mods/audio.mfm)
if exist "%disk%/system/extra-mods/graphics.mfm" (echo Loaded /system/extra-mods/graphics.mfm)
if exist "%disk%/system/extra-mods/devtools.mfm" (echo Loaded /system/extra-mods/devtools.mfm)

if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (echo. && pause)

:: Jailbreak loading process

if exist "%disk%/system/extra-mods/flashbreak.mfm" (
  title Hello F145HBR34K!
  echo Loading F145HBR34K...
  echo.
  if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found! && echo. && echo F145HBR34K could not be loaded.) else (
  echo Decrypting sysmodules...
  echo.

  if not exist "%disk%/system/cmd.mcm" (echo Sysmodule /system/cmd.mcm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /system/cmd.mcm
  echo Command line [%new_mfver%] [FLASHBROKEN]>"%disk%/system/cmd.mcm"

  if not exist "%disk%/system/fsutils.mcm" (echo Sysmodule /system/fsutils.mcm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /system/fsutils.mcm
  echo File system read/write utilities [%new_mfver%] [FLASHBROKEN]>"%disk%/system/fsutils.mcm"

  if not exist "%disk%/system/proctector.mcm" (echo Sysmodule /system/proctector.mcm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /system/proctector.mcm
  echo MicroflashOS Protector [%new_mfver%] [FLASHBROKEN]>"%disk%/system/proctector.mcm"

  if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Sysmodule /system/extra-mods/devtools.mfm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /system/extra-mods/devtools.mfm
  echo DevTools commands [%new_mfver%] [FLASHBROKEN]>"%disk%/system/extra-mods/devtools.mfm"

  echo.
  echo Sysmodule decryption complete.
  echo Bootloader unlock complete.
  echo.
  echo Finishing boot process...
  echo.
  if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (pause)
  if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/noclear" (cls)
  ) )

:: Userdata check

title Checking userdata directory...
echo.
if exist "%disk%/%usrdir%/%username%" (echo Userdata directory is %sysdir%/%usrdir%. && echo.)

:: Userdata regeneration

if not exist "%disk%/%usrdir%/%username%" (
echo Userdata directory not found!
echo.
echo Creating userdata directory... && cd /d "%disk%" && rd "%usrdir%" /s /q && md "%usrdir%" && cd "%usrdir%" && md %username% && echo.
if not exist "%disk%/%usrdir%/%username%/" (echo Userdata directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%" (
echo Userdata directory exists but hasn't been set up, doing that now...
cd /d "%disk%/%usrdir%/%username%" && md "%osdata%" && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/" (echo Userdata directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/" (
echo Creating configuration directory...
cd /d "%disk%/%usrdir%/%username%/%osdata%" && md toggles && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles" (echo Configuration directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/" (
echo Creating package directory...
cd /d "%disk%/%usrdir%/%username%/%osdata%"
md packages && cd /d "%disk%/%usrdir%/%username%/%osdata%/packages" && md installed && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/" (echo Package directory creation failed! && echo. && pause && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed" (echo Package directory creation failed! && echo. && pause && goto prompt)
)

:: Boot process complete!

title System files loaded!
echo MicroflashOS system files loaded!
echo.
cd /d "%disk%/%usrdir%/%username%"
if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (pause)

:: Welcome messages

if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/noclear" (cls)
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/nowelcome" (
echo.
echo Welcome to MicroflashOS!
echo.
if exist "%disk%/system/extra-mods/flashbreak.mfm" (echo F145HBR34K %fbver% && echo.)
echo Logged in as %username%
echo.
echo Type HELP for a list of commands.
echo Commands are not case-sensitive.
goto prompt
)

:: User prompt

:prompt

echo.
if not exist "%disk%/system/cmd.mcm" (echo Command line could not be loaded. Please reinstall MicroflashOS. && echo. && pause && exit)

:: Titlebar stuff

set "titlebar=MicroflashOS %new_mfver%"
title %titlebar%
if exist "%disk%/system/extra-mods/flashbreak.mfm" (title %titlebar% [F145HBR34K %fbver%])

if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/showdir" (echo Current directory: %cd% && echo.)

:: Reset last run command variable

set "cmd="

set /p "cmd=%username%@%userdomain%: "

:: thanks Gemini!

title Processing command...
set "cmd_found=false"
for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
    if /i "%%A"=="%cmd%" set "cmd_found=true"
)
if "%cmd_found%"=="false" (
    echo.
    echo Invalid command.
    goto prompt
)
goto %cmd%

:: Main help section

:help
echo.
if not exist "%disk%/system/core.mcm" (echo Invalid command. && goto prompt)
echo Utilities:
echo.
echo about: Show some system info
echo time: Prints current date and time
echo clear: Clears console output
echo.
echo Power options:
echo.
echo reboot: Reboot system
echo recovery: Reboot to recovery mode
echo shutdown: Shutdown system
echo.
if exist "%disk%/system/fsutils.mcm" (
echo File management:
echo.
echo mkdir: Create a directory
echo mkfile: Create a file
echo del: Delete a file/directory
echo list: List available files/directories
echo cd: Change to a directory
echo home: Quickly change to user directory
echo homewipe: Wipe user directory
)
if exist "%disk%/system/extra-mods/devtools.mfm" (
echo.
echo Developer commands:
echo.
echo devtools-uninstall: DevTools uninstaller
echo mountsys: Mount system disk to modify contents
echo modules: List installed system modules "sysmodules"
echo toggles-[create/delete/enabled/list]: Manage system "toggles"
if exist  "%disk%/system/extra-mods/flashbreak.mfm" (
echo.
echo F145HBR34K commands:
echo.
echo flashbreak-uninstall: Uninstall jailbreak
echo flashbreak-reboot: Force reboot regardless of core.mcm presence
)
)
if exist "%disk%/system/mfpkg.mcm" (
echo.
echo Package management:
echo.
echo mfpkg-[install/uninstall/list]: Local package management
echo mfpkg-[dl/rm]-[package ID]: Install/uninstall package directly
echo mfpkg-repo-available: Check available packages in repository
echo.
echo Commands for installed packages:
echo.
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/nuke.mfp" (echo nuke: Nuke.)
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/dumper.mfp" (echo dumper: MicroflashOS firmware dumper by nsp)
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/winflash.mfp" (echo winflash: WinFlash compatibility layer for Windows software)
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp" (echo mountvirt: Mount and boot to a system disk of your choice)
)
goto prompt

:: MicroflashOS Recovery

:recovery
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/noclear" (cls)
cd /d "%~p0"
title MicroflashOS Recovery
echo.
echo Reinstalling MicroflashOS.
echo.
pause
if not exist "%~p0%sysdir%" (md "%sysdir%")
if not exist "%~p0%sysdir%" (echo. && echo Failed to format system disk! && echo. && pause && goto recovery)
echo.
echo System disk '%sysdir%' mounted as /
cd /d "%~p0%sysdir%"
if not exist system (md system)
if not exist system (echo. && echo Failed to create operating system data directory! && echo. && pause && goto recovery)

echo.
echo Installing core sysmodules...
echo.

echo Long-term memory [%new_mfver%]>"%disk%/system/ltmem.mcm"
if not exist "%disk%/system/ltmem.mcm" (echo Failed to install sysmodule "/system/ltmem.mcm". && echo. && pause && goto recovery)
echo Installed /system/ltmem.mcm

echo Short-term memory [%new_mfver%]>"%disk%/system/stmem.mcm"
if not exist "%disk%/system/stmem.mcm" (echo Failed to install sysmodule "/system/stmem.mcm". && echo. && pause && goto recovery)
echo Installed /system/stmem.mcm

echo Core MicroflashOS commands [%new_mfver%]>"%disk%/system/core.mcm"
if not exist "%disk%/system/core.mcm" (echo Failed to install sysmodule "/system/core.mcm". && echo. && pause && goto recovery)
echo Installed /system/core.mcm

echo File system read/write utilities [%new_mfver%]>"%disk%/system/fsutils.mcm"
if not exist "%disk%/system/fsutils.mcm" (echo Failed to install sysmodule "/system/fsutils.mcm". && echo. && pause && goto recovery)
echo Installed /system/fsutils.mcm

echo Command line [%new_mfver%]>"%disk%/system/cmd.mcm"
if not exist "%disk%/system/cmd.mcm" (echo Failed to install sysmodule "/system/cmd.mcm". && echo. && pause && goto recovery)
echo Installed /system/cmd.mcm

echo MicroflashOS recovery [%new_mfver%]>"%disk%/system/recovery.mcm"
if not exist "%disk%/system/recovery.mcm" (echo Failed to install sysmodule "/system/recovery.mcm". && echo. && pause && goto recovery)
echo Installed /system/recovery.mcm

echo MicroflashOS kernel.mcm [%new_mfver%]>"%disk%/system/kernel.mcm"
if not exist "%disk%/system/kernel.mcm" (echo Failed to install sysmodule "/system/kernel.mcm". && echo. && pause && goto recovery)
echo Installed /system/kernel.mcm

echo MicroflashOS Ultracompacter [%new_mfver%]>"%disk%/system/compact.mcm"
if not exist "%disk%/system/compact.mcm" (echo Failed to install sysmodule "/system/compact.mcm". && echo. && pause && goto recovery)
echo Installed /system/compact.mcm

echo MicroflashOS Protector [%new_mfver%]>"%disk%/system/proctector.mcm"
if not exist "%disk%/system/proctector.mcm" (echo Failed to install sysmodule "/system/proctector.mcm". && echo. && pause && goto recovery)
echo Installed /system/proctector.mcm

echo MicroflashOS Package Manager [%new_mfver%]>"%disk%/system/mfpkg.mcm"
if not exist "%disk%/system/mfpkg.mcm" (echo Failed to install sysmodule "/system/mfpkg.mcm". && echo. && pause && goto recovery)
echo Installed /system/mfpkg.mcm

echo.
echo Installing additional sysmodules...
echo.

if not exist "%disk%/system/extra-mods" (md "%disk%/system/extra-mods")
cd /d "%disk%/system/extra-mods"

echo Audio output [%new_mfver%]>"%disk%/system/extra-mods/audio.mfm"
if not exist "%disk%/system/extra-mods/audio.mfm" (echo Failed to install sysmodule "/system/extra-mods/audio.mfm". && echo. && pause && goto recovery)
echo Installed /system/extra-mods/audio.mfm

echo Graphics subsystem [%new_mfver%]>"%disk%/system/extra-mods/graphics.mfm"
if not exist "%disk%/system/extra-mods/graphics.mfm" (echo Failed to install sysmodule "/system/extra-mods/graphics.mfm". && echo. && pause && goto recovery)
echo Installed /system/extra-mods/graphics.mfm

echo All-in-one sensor package [%new_mfver%]>"%disk%/system/extra-mods/sensors.mfm"
if not exist "%disk%/system/extra-mods/sensors.mfm" (echo Failed to install sysmodule "/system/extra-mods/sensors.mfm". && echo. && pause && goto recovery)
echo Installed /system/extra-mods/sensors.mfm

:: Post-installation activities

echo.
if exist "%disk%/%usrdir%/%username%" (echo Existing userdata directory found! && echo After booting run 'homewipe' to regenerate userdata directory. && echo.)

if not exist "%disk%/%usrdir%/%username%" (
echo Creating userdata directory... && cd /d "%disk%" && rd "%usrdir%" /s /q && md "%usrdir%" && cd "%usrdir%" && md %username% && echo.
if not exist "%disk%/%usrdir%/%username%/" (echo Userdata directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%" (
echo Setting up userdata directory...
cd /d "%disk%/%usrdir%/%username%" && md "%osdata%" && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/" (echo Userdata directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/" (
echo Creating configuration directory...
cd /d "%disk%/%usrdir%/%username%/%osdata%" && md toggles && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles" (echo Configuration directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/" (
echo Creating package directory...
cd /d "%disk%/%usrdir%/%username%/%osdata%"
md packages && cd /d "%disk%/%usrdir%/%username%/%osdata%/packages" && md installed && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/" (echo Package directory creation failed! && echo. && pause && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed" (echo Package directory creation failed! && echo. && pause && goto prompt)
)

echo MicroflashOS installation complete. && echo. && pause && echo.
title Rebooting...
echo Rebooting...
goto reboot

:: About me

:about
echo.
if not exist "%disk%/system/core.mcm" (echo Invalid command. && goto prompt)
echo MicroflashOS version: %new_mfver%
if exist "%disk%/system/extra-mods/flashbreak.mfm" (echo F145HBR34K version: %fbver%)
echo Mounted system disk: %sysdir%
echo.
echo Hostname: %userdomain%
echo Processor: %processor_identifier% (%NUMBER_OF_PROCESSORS% cores)
echo Architecture: %processor_architecture%
echo.
echo Made by Kenneth White.
if exist "%disk%/system/extra-mods/flashbreak.mfm" (
echo Jailbreak by Team Centurion with help from Team Starburst
echo Special thanks to nsp and the GigaflashOS devs! )
goto prompt

:time
echo.
if not exist "%disk%/system/core.mcm" (echo Invalid command. && goto prompt)
echo Time: %time%
echo Date: %date%
goto prompt

:: Clear the shell

:clear
if not exist "%disk%/system/core.mcm" (echo Invalid command. && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/noclear" (cls)
goto prompt

:: Power options

:shutdown
echo.
if not exist "%disk%/system/core.mcm" (echo Invalid command. && goto prompt)
title Shutting down...
echo Shutting down...
exit

:: File manager

:mkdir
title File Manager
echo.
if not exist "%disk%/system/fsutils.mcm" (echo Invalid command. && goto prompt)
set /p "mkd=Directory to create: "
if exist "%mkd%" (echo. && echo Directory already exists! && goto prompt)
md "%mkd%"
if not exist "%mkd%" (echo. && echo Directory creation failed! && goto prompt)
echo.
echo Directory created.
goto prompt

:mkfile
title File Manager
echo.
if not exist "%disk%/system/fsutils.mcm" (echo Invalid command. && goto prompt)
set /p "mkf_name=New file name: "
echo.
set /p "mkf_contents=Contents: "
if exist "%mkf_name%" (echo File/directory already exists! && goto prompt)
echo %mkf_contents%>"%mkf_name%"
if not exist "%mkf_name%" (echo File creation failed! && goto prompt)
echo.
echo File created.
goto prompt

:del
title File Manager
if not exist "%disk%/system/fsutils.mcm" (echo. && echo Invalid command. && goto prompt)
echo.
set /p "del=File/directory to delete: "
if not exist "%del%" (echo. && echo File/directory does not exist. && goto prompt)
del "%del%" /f /q
if not exist "%del%" (echo. && echo Deleted! && goto prompt)
rd "%del%" /s /q
if not exist "%del%" (echo. && echo Deleted! && goto prompt)
echo.
echo Failed to delete file/directory "%del%"!
goto prompt

:list
title File Manager
echo.
if not exist "%disk%/system/fsutils.mcm" (echo Invalid command. && goto prompt)
echo Directories:
echo.
dir /a:d /b
echo.
echo Files:
echo.
dir /a:-d /b
goto prompt

:cd
title File Manager
echo.
if not exist "%disk%/system/fsutils.mcm" (echo Invalid command. && goto prompt)
set /p "chdir=Name of directory to change to: "
echo.
if not exist "%chdir%" (echo Directory invalid! && goto prompt)
cd /d "%chdir%"
echo Changed directory to "%chdir%".
goto prompt

:: Userdata directory management

:home
title File Manager
if not exist "%disk%/system/fsutils.mcm" (echo. && echo Invalid command. && goto prompt)
if not exist "%disk%/%usrdir%/%username%" (echo. && echo Userdata directory not found. && goto prompt)
cd /d "%disk%/%usrdir%/%username%"
echo.
echo Welcome home!
goto prompt

:homewipe
title File Manager
echo. 
if not exist "%disk%/system/fsutils.mcm" (echo Invalid command. && goto prompt)
if not exist "%disk%/%usrdir%/%username%" (echo Userdata directory not found. && goto prompt)
echo This command wipes userdata.
echo Back up any data before continuing!
echo.
pause
echo.
echo Creating userdata directory... && cd /d "%disk%" && rd "%usrdir%" /s /q && md "%usrdir%" && cd "%usrdir%" && md %username% && echo.
if not exist "%disk%/%usrdir%/%username%/" (echo Userdata directory creation failed! && echo. && pause && goto prompt)

if not exist "%disk%/%usrdir%/%username%/%osdata%" (
echo Setting up userdata directory...
cd /d "%disk%/%usrdir%/%username%" && md "%osdata%" && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/" (echo Userdata directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/" (
echo Creating configuration directory...
cd /d "%disk%/%usrdir%/%username%/%osdata%" && md toggles && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles" (echo Configuration directory creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/" (
echo Creating package directory...
cd /d "%disk%/%usrdir%/%username%/%osdata%"
md packages && cd /d "%disk%/%usrdir%/%username%/%osdata%/packages" && md installed && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/" (echo Package directory creation failed! && echo. && pause && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed" (echo Package directory creation failed! && echo. && pause && goto prompt)
)

echo Userdata directory creation succeeded!
goto prompt

:: DevTools

:devtools-uninstall
title MicroflashOS DevTools Uninstaller
echo.
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo Uninstalling DevTools...
echo.
pause
echo.
set "curdir=%cd%"
cd /d "%disk%/system/extra-mods/" && del devtools.mfm /f
if exist "%disk%/system/extra-mods/devtools.mfm" (echo Uninstall failed! && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed/" && del 001-DevTools /f
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/001-DevTools" (echo Uninstall failed! && goto prompt)
echo DevTools uninstalled.
echo You will not be able to use developer commands anymore.
cd /d "%curdir%"
set "new_mfver=%mfver%"
goto prompt

:mountsys
echo.
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
if not exist "%disk%/system/" (echo System disk not found! Please reinstall MicroflashOS. && goto prompt)
title MicroflashOS System Mounter
echo Mounting...
echo.
cd /d "%disk%/system/"
echo Your current directory has been changed to the system disk root.
echo Please be aware that modifying the system disk directly may lead to a brick!
goto prompt

:modules
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo.
echo Critical sysmodules:
echo.
dir /a:-d /b "%disk%/system/"
echo.
echo Additional sysmodules:
echo.
dir /a:-d /b "%disk%/system/extra-mods/"
goto prompt

:toggles-create
echo.
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
set /p "cfgadd=Name of toggle: "
echo %cfgadd%>"%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgadd%"
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgadd%" (echo. && echo Failed to write toggle. && echo. && goto prompt)
echo.
echo Configuration written.
goto prompt

:toggles-delete
echo.
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
set /p "cfgdel=Toggle to delete: "
del "%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgdel%" /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgdel%" (echo. && echo Failed to delete toggle. && echo. && goto prompt)
echo.
echo Configuration deleted.
goto prompt

:toggles-enabled
echo.
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo Enabled toggles:
echo.
dir /a:-d /b "%disk%/%usrdir%/%username%/%osdata%/toggles/"
goto prompt

:toggles-list
echo.
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo Available toggles in MicroflashOS as of version %new_mfver%:
echo.
echo Tweaks:
echo.
echo showdir: Shows current directory in command line before prompt. Useful for navigating complex directory trees
echo nowelcome: Goes straight to the prompt without displaying current version, logged in user, etc 
echo.
echo Debugging tools:
echo.
echo slowboot: Add pauses during boot sequence
echo echoon: Disables echo OFF so command that generated shell output is shown
echo noclear: Disable clearing shell output (this also affects the 'clear' command)
goto prompt

:: Jailbreak

:flashbreak-uninstall
echo.
if not exist "%disk%/system/extra-mods/flashbreak.mfm" (echo Invalid command. && goto prompt)
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
echo F145HBR34K Uninstaller
echo.
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %new_mfver%
echo.
echo Uninstalling jailbreak...
echo.
pause
cd /d "%disk%/system/extra-mods" && del flashbreak.mfm /f /q
if exist "%disk%/system/extra-mods/flashbreak.mfm" (echo Uninstall failed! && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed" && del 002-F145HBR34K /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/002-F145HBR34K" (echo Uninstall failed! && goto prompt)
echo.
echo Jailbreak uninstalled.
echo All F145HBR34K commands will be invalidated.
echo.
echo The system will reboot.
echo.
pause
goto reboot

:flashbreak-reboot
echo.
if not exist "%disk%/system/extra-mods/flashbreak.mfm" (echo Invalid command. && goto prompt)
echo Forcing a reboot...
echo.
goto reboot

:: Package manager functions

:mfpkg-install
title MicroflashOS Package Manager
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
set /p "pkginst_id=Package ID to install: "
set "pkginst=mfpkg-dl-%pkginst_id%
title Finding package...
set "pkginst_found=false"
for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
    if /i "%%A"=="%pkginst%" set "pkginst_found=true"
)
if "%pkginst_found%"=="false" (
    echo.
    echo Package ID is invalid.
    goto prompt
)
goto %pkginst%

:mfpkg-uninstall
title MicroflashOS Package Manager
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
set /p "pkgrm_id=Package ID to uninstall: "
set "pkgrm=mfpkg-rm-%pkgrm_id%"
title Finding package...
set "pkgrm_found=false"
for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
    if /i "%%A"=="%pkgrm%" set "pkgrm_found=true"
)
if "%pkgrm_found%"=="false" (
    echo.
    echo Could not find a suitable uninstaller.
    echo Maybe the package has its own uninstaller?
    goto prompt
)
goto %pkgrm%

:mfpkg-list
title MicroflashOS Package Manager
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
echo Installed packages:
echo.
dir /a:-d /b "%disk%/%usrdir%/%username%/%osdata%/packages/installed/"
goto prompt

:mfpkg-repo-available
title MicroflashOS Package Manager
echo.
echo Repository: %pkgrepo%
if "%pkgrepo%" == "GigaflashOS Unified Repository [Revision 1]" (
echo.
echo ID 001: MicroflashOS DevTools
echo ID 002: F145HBR34K jailbreak
echo ID 003: WinFlash Compatibility Layer
echo ID 004: nuke
echo ID 005: MicroflashOS Dumper
echo ID 006: Virtual System Disk Mounter )
goto prompt

:: Installers

:mfpkg-dl-001
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading DevTools (pID 001)
echo.
echo Executing installer...
echo.
title MicroflashOS DevTools Installer
if exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools are already installed! && goto prompt)
echo Installing DevTools...
echo.
echo DevTools commands [%new_mfver%]>"%disk%/system/extra-mods/devtools.mfm"
set "new_mfver=%mfver%-dev"
if exist "%disk%/system/extra-mods/devtools.mfm" (
echo Installed successfully!
echo Developer commands have been added to the help section.
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/001-DevTools"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/001-DevTools" (echo Failed to register package. && goto prompt)
goto prompt
)
echo DevTools failed to install.
goto prompt

:mfpkg-dl-002
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading F145HBR34K (pID 002)
echo.
echo Executing installer...
echo.
title F145HBR34K Installer
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %new_mfver%
echo.
if exist "%disk%/system/extra-mods/flashbreak.mfm" (echo Error: F145HBR34K already installed! && goto prompt)

if not exist "%disk%/system/cmd.mcm" (echo Sysmodule /system/cmd.mcm not found. Please reinstall MicroflashOS. && echo. && goto prompt)
echo Validated /system/cmd.mcm

if not exist "%disk%/system/fsutils.mcm" (echo Sysmodule /system/fsutils.mcm not found. Please reinstall MicroflashOS. && echo. && goto prompt)
echo Validated /system/fsutils.mcm

if not exist "%disk%/system/extra-mods/devtools.mfm" (echo Sysmodule /system/extra-mods/devtools.mfm not found. Please reinstall MicroflashOS. && echo. && goto prompt)
echo Validated /system/extra-mods/devtools.mfm

echo.
echo Installing system module /system/extra-mods/flashbreak.mfm...
echo.
echo F145HBR34K jailbreak utility [%new_mfver%]>"%disk%/system/extra-mods/flashbreak.mfm"

if exist "%disk%/system/extra-mods/flashbreak.mfm" (
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/002-F145HBR34K"
echo Installed successfully!
echo.
echo F145HBR34K commands have been added to the help section.
echo The system will now reboot.
echo.
pause
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/002-F145HBR34K" (echo Failed to register package. && goto prompt)
goto reboot
)

echo.
echo Jailbreak installation failed!
goto prompt

:mfpkg-dl-003
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading WinFlash Compatibility Layer (pID 003)
echo.
echo Executing installer...
echo.
echo Microsoft Windows Compatibility Layer for MicroflashOS >"%disk%/%usrdir%/%username%/%osdata%/packages/winflash.mfp"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/winflash.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/003-WinFlash"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/003-WinFlash" (echo Failed to register package. && goto prompt)
echo Installed /%usrdir%/%osdata%/packages/winflash.mfp
goto prompt

:mfpkg-dl-004
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading Nuke (pID 004)
echo.
echo Executing installer...
echo.
echo Self destruct tool LMAO by Kenneth White >"%disk%/%usrdir%/%username%/%osdata%/packages/nuke.mfp"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/nuke.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/004-Nuke"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/004-Nuke" (echo Failed to register package. && goto prompt)
echo Installed /%usrdir%/%osdata%/packages/nuke.mfp
goto prompt

:mfpkg-dl-005
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading dumper (pID 005)
echo.
echo Executing installer...
echo.
echo MicroflashOS Dumper by nsp >"%disk%/%usrdir%/%username%/%osdata%/packages/dumper.mfp"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/dumper.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/005-dumper"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/005-dumper" (echo Failed to register package. && goto prompt)
echo Installed /%usrdir%/%osdata%/packages/dumper.mfp
goto prompt

:mfpkg-dl-006
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading mountvirt (pID 006)
echo.
echo Executing installer...
echo.
echo Virtual System Disk Mounter by GigaflashOS Devs >"%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/006-mountvirt"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/006-mountvirt" (echo Failed to register package. && goto prompt)
echo Installed /%usrdir%/%osdata%/packages/mountvirt.mfp
goto prompt

:: Uninstallers

:mfpkg-rm-003
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling WinFlash Compatibility Layer (pID 003)
echo.
set "curdir=%cd%"
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/"
del winflash.mfp /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/winflash.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed"
del "003-WinFlash" /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/003-WinFlash" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%usrdir%/%osdata%/packages/winflash.mfp
cd /d %curdir%
goto prompt

:mfpkg-rm-004
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling Nuke (pID 004)
echo.
set "curdir=%cd%"
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/"
del nuke.mfp /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/nuke.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed"
del "004-Nuke" /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/004-Nuke" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%usrdir%/%osdata%/packages/nuke.mfp
cd /d %curdir%
goto prompt

:mfpkg-rm-005
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling dumper (pID 006)
echo.
set "curdir=%cd%"
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/"
del dumper.mfp /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/dumper.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed"
del "005-dumper" /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/005-dumper" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%usrdir%/%osdata%/packages/dumper.mfp
cd /d %curdir%
goto prompt

:mfpkg-rm-006
echo.
if not exist "%disk%/system/mfpkg.mcm" (echo Invalid command. && goto prompt)s
title MicroflashOS Package Manager
echo Uninstalling mountvirt (pID 006)
echo.
set "curdir=%cd%"
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/"
del mountvirt.mfp /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed"
del "006-mountvirt" /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/006-mountvirt" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%usrdir%/%osdata%/packages/mountvirt.mfp
cd /d %curdir%
goto prompt

:: Custom packages

:nuke
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/nuke.mfp" (echo Invalid command. && goto prompt)
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
title Nuke
echo Nuking system disk. ALL DATA WILL BE WIPED!
echo.
pause
echo.
if exist "%disk%/system" (
rd "%disk%/system" /s /q
echo System disk nuked.
goto prompt
)
echo System disk not found.
goto prompt

:dumper
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/dumper.mfp" (echo Invalid command. && goto prompt)
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
if not exist "%disk%/system/extra-mods/flashbreak.mfm" (echo This package requires F145HBR34K to function. Please install pID 002. && goto prompt)
title MicroflashOS Dumper
echo MicroflashOS Dumper by nsp
echo.
if exist "%disk%/system" (
  echo System disk mounted!
  echo.
  echo Dumping current MicroflashOS system disk to %~p0dump
  echo.
  xcopy "%disk%" "%~p0dump\" /w /e /f
  goto prompt
) 
echo Could not find system disk. System may be corrupt!
echo.
echo Please enter recovery mode to repair your system.
goto prompt

:winflash
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/winflash.mfp" (echo Invalid command. && goto prompt)
title WinFlash
cls && echo.
echo Type EXIT and press Enter to return to MicroflashOS.
echo.
cmd.exe
goto prompt

:mountvirt
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp" (echo Invalid command. && goto prompt)
if not exist "%disk%/system/extra-mods/flashbreak.mfm" (echo Invalid command. && goto prompt)
if not exist "%disk%/system/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
title Virtual System Disk Mounter
echo Virtual system disks should be placed in the same directory as the Batch file.
echo Current directory: %~p0
echo.
echo NOTE: Don't fill in the blank with blanks!
echo.
set /p "sysvirt=Name of system disk: "
echo.
if not exist "%~p0%sysvirt%" (echo System disk not found! && goto prompt)
set "sysdir=%sysvirt%"
echo Mounted virtual disk! Rebooting...
echo.
pause
goto reboot
