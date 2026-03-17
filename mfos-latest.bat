::  Source code of MicroflashOS
::  A "fantasy operating system" made by KNBnoob1!
::  Website: https://knbn1.github.io

@echo off

:: Setting some variables on startup

set "sysdisk=MicroflashOS"
set "disk=%~p0%sysdisk%"
set "fbver=4.4"
set "usrdir=userdata"
set "osdata=mfosdata"
set "sysdir=mfos"
set "pkgrepo=GigaflashOS Unified Repository [Revision 2]"
set "mfver=2026.03.18-rbtest"

:: Rewrite version when DevTools are found

if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (set "new_mfver=%mfver%")
if exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (set "new_mfver=%mfver%-dev")

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
if exist "%sysdisk%" (echo System disk '%sysdisk%' mounted as /) else (
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

if not exist "%disk%/%sysdir%/devices" (cd /d "%disk%/%sysdir%/" && md devices)
if not exist "%disk%/%sysdir%/devices/mem" (cd /d "%disk%/%sysdir%/devices" && md mem)
if not exist "%disk%/%sysdir%/devices/storage" (cd /d "%disk%/%sysdir%/devices" && md storage)

echo Memory sector 1 - Core system files>"%disk%/%sysdir%/devices/mem/memsect1"
if not exist "%disk%/%sysdir%/devices/mem/memsect1" (echo Could not initialize device "memsect1" && echo. && pause && goto recovery)
echo Initialized device "memsect1"

echo Memory sector 2 - Userspace>"%disk%/%sysdir%/devices/mem/memsect2"
if not exist "%disk%/%sysdir%/devices/mem/memsect2" (echo Could not initialize device "memsect2" && echo. && pause && goto recovery)
echo Initialized device "memsect2"

echo Memory sector 3 - Secret Block>"%disk%/%sysdir%/devices/mem/memsect3"
if not exist "%disk%/%sysdir%/devices/mem/memsect3" (echo Could not initialize device "memsect3" && echo. && pause && goto recovery)
echo Initialized device "memsect3"

echo Human Interface Devices>"%disk%/%sysdir%/devices/hids"
if not exist "%disk%/%sysdir%/devices/hids" (echo Could not initialize device "hids" && echo. && pause && goto recovery)
echo Initialized device "hids"

echo Auditory devices: headphones, speakers, microphones, etc. >"%disk%/%sysdir%/devices/audio"
if not exist "%disk%/%sysdir%/devices/audio" (echo Could not initialize device "audio" && echo. && pause && goto recovery)
echo Initialized device "audio"

echo System disk partition 1 - /%sysdir%>"%disk%/%sysdir%/devices/storage/disk0p1"
if not exist "%disk%/%sysdir%/devices/storage/disk0p1" (echo Could not initialize device "disk0p1" && echo. && pause && goto recovery)
echo Initialized device "disk0p1"

echo System disk partition 2 - /userdata>"%disk%/%sysdir%/devices/storage/disk0p2"
if not exist "%disk%/%sysdir%/devices/storage/disk0p2" (echo Could not initialize device "disk0p2" && echo. && pause && goto recovery)
echo Initialized device "disk0p2"

if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (echo. && pause)

:: Start loading sysmodules

title Loading sysmodules...
echo.
echo Loading sysmodules...
echo.

:: Initialization of core sysmodules

if exist "%disk%/%sysdir%/ltmem.mcm" (echo Loaded /%sysdir%/ltmem.mcm) else (
echo Could not load /%sysdir%/ltmem.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/stmem.mcm" (echo Loaded /%sysdir%/stmem.mcm) else (
echo Could not load /%sysdir%/stmem.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/core.mcm" (echo Loaded /%sysdir%/core.mcm) else (
echo Could not load /%sysdir%/core.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/fsutils.mcm" (echo Loaded /%sysdir%/fsutils.mcm) else (
echo Could not load /%sysdir%/fsutils.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/recovery.mcm" (echo Loaded /%sysdir%/recovery.mcm) else (
echo Could not load /%sysdir%/recovery.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/cmd.mcm" (echo Loaded /%sysdir%/cmd.mcm) else (
echo Could not load /%sysdir%/cmd.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/kernel.mcm" (echo Loaded /%sysdir%/kernel.mcm) else (
echo Could not load /%sysdir%/kernel.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/compact.mcm" (echo Loaded /%sysdir%/compact.mcm) else (
echo Could not load /%sysdir%/compact.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/proctector.mcm" (echo Loaded /%sysdir%/proctector.mcm) else (
echo Could not load /%sysdir%/proctector.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )

if exist "%disk%/%sysdir%/mfpkg.mcm" (echo Loaded /%sysdir%/mfpkg.mcm) else (
echo Could not load /%sysdir%/mfpkg.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
goto recovery )


:: Initialization of non-critical sysmodules

if exist "%disk%/%sysdir%/extra-mods/sensors.mfm" (echo Loaded /%sysdir%/extra-mods/sensors.mfm)
if exist "%disk%/%sysdir%/extra-mods/audio.mfm" (echo Loaded /%sysdir%/extra-mods/audio.mfm)
if exist "%disk%/%sysdir%/extra-mods/graphics.mfm" (echo Loaded /%sysdir%/extra-mods/graphics.mfm)
if exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Loaded /%sysdir%/extra-mods/devtools.mfm)
if exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Loaded %sysdir%/extra-mods/databases.mfm)

if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/slowboot" (echo. && pause)

:: Jailbreak loading process

if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (
  title Hello F145HBR34K!
  echo Loading F145HBR34K...
  echo.
  if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found! && echo. && echo F145HBR34K could not be loaded.) else (
  echo Decrypting sysmodules...
  echo.

  if not exist "%disk%/%sysdir%/cmd.mcm" (echo Sysmodule /%sysdir%/cmd.mcm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /%sysdir%/cmd.mcm
  echo Command line [%new_mfver%] [FLASHBROKEN]>"%disk%/%sysdir%/cmd.mcm"

  if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Sysmodule /%sysdir%/fsutils.mcm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /%sysdir%/fsutils.mcm
  echo File system read/write utilities [%new_mfver%] [FLASHBROKEN]>"%disk%/%sysdir%/fsutils.mcm"

  if not exist "%disk%/%sysdir%/proctector.mcm" (echo Sysmodule /%sysdir%/proctector.mcm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /%sysdir%/proctector.mcm
  echo MicroflashOS Protector [%new_mfver%] [FLASHBROKEN]>"%disk%/%sysdir%/proctector.mcm"

  if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Sysmodule /%sysdir%/extra-mods/devtools.mfm not found. Please reinstall MicroflashOS. && echo. && pause && goto recovery)
  echo Patching /%sysdir%/extra-mods/devtools.mfm
  echo DevTools commands [%new_mfver%] [FLASHBROKEN]>"%disk%/%sysdir%/extra-mods/devtools.mfm"

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

title Checking userdata partition...
echo.
if exist "%disk%/%usrdir%/%username%" (echo Userdata partition is %sysdisk%/%usrdir%. && echo.)

:: Userdata regeneration

if not exist "%disk%/%usrdir%/%username%" (
echo Userdata partition not found!
echo.
echo Creating userdata partition... && cd /d "%disk%" && rd "%usrdir%" /s /q && md "%usrdir%" && cd "%usrdir%" && md %username% && echo.
if not exist "%disk%/%usrdir%/%username%/" (echo Userdata partition creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%" (
echo Userdata partition exists but hasn't been set up, doing that now...
cd /d "%disk%/%usrdir%/%username%" && md "%osdata%" && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/" (echo Userdata partition creation failed! && echo. && pause && goto prompt)
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
if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo F145HBR34K %fbver% && echo.)
echo Logged in as %username%
echo.
echo Type HELP for a list of commands.
echo Commands are not case-sensitive.
goto prompt
)

:: User prompt

:prompt

echo.
if not exist "%disk%/%sysdir%/cmd.mcm" (echo Command line could not be loaded. Please reinstall MicroflashOS. && echo. && pause && exit)

:: Titlebar stuff

set "titlebar=MicroflashOS %new_mfver%"
title %titlebar%
if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (title %titlebar% [F145HBR34K %fbver%])

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
if not exist "%disk%/%sysdir%/core.mcm" (echo Invalid command. && goto prompt)
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
if exist "%disk%/%sysdir%/fsutils.mcm" (
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
if exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (
echo.
echo Developer commands:
echo.
echo devtools-uninstall: DevTools uninstaller
echo mountsys: Mount system disk to modify contents
echo modules: List installed system modules "sysmodules"
echo toggles-[create/delete/enabled/list]: Manage system "toggles"
if exist "%disk%/%sysdir%/extra-mods/databases.mfm (
echo.
echo Database management:
echo.
echo entities-[add/del/list/wipe]: Entity database management
echo locations-[add/del/list/wipe]: Location database management
echo objects-[add/del/list/wipe]: Object database management
)
if exist  "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (
echo.
echo F145HBR34K commands:
echo.
echo flashbreak-uninstall: Uninstall jailbreak
echo flashbreak-reboot: Force reboot regardless of core.mcm presence
)
)
if exist "%disk%/%sysdir%/mfpkg.mcm" (
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
if not exist "%~p0%sysdisk%" (md "%sysdisk%")
if not exist "%~p0%sysdisk%" (echo. && echo Failed to format system disk! && echo. && pause && goto recovery)
echo.
echo System disk '%sysdisk%' mounted as /
cd /d "%~p0%sysdisk%"
if not exist %sysdir% (md %sysdir%)
if not exist %sysdir% (echo. && echo Failed to create operating system data directory! && echo. && pause && goto recovery)

echo.
echo Installing core sysmodules...
echo.

echo Long-term memory [%new_mfver%]>"%disk%/%sysdir%/ltmem.mcm"
if not exist "%disk%/%sysdir%/ltmem.mcm" (echo Failed to install sysmodule "/%sysdir%/ltmem.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/ltmem.mcm

echo Short-term memory [%new_mfver%]>"%disk%/%sysdir%/stmem.mcm"
if not exist "%disk%/%sysdir%/stmem.mcm" (echo Failed to install sysmodule "/%sysdir%/stmem.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/stmem.mcm

echo Core MicroflashOS commands [%new_mfver%]>"%disk%/%sysdir%/core.mcm"
if not exist "%disk%/%sysdir%/core.mcm" (echo Failed to install sysmodule "/%sysdir%/core.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/core.mcm

echo File system read/write utilities [%new_mfver%]>"%disk%/%sysdir%/fsutils.mcm"
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Failed to install sysmodule "/%sysdir%/fsutils.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/fsutils.mcm

echo Command line [%new_mfver%]>"%disk%/%sysdir%/cmd.mcm"
if not exist "%disk%/%sysdir%/cmd.mcm" (echo Failed to install sysmodule "/%sysdir%/cmd.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/cmd.mcm

echo MicroflashOS recovery [%new_mfver%]>"%disk%/%sysdir%/recovery.mcm"
if not exist "%disk%/%sysdir%/recovery.mcm" (echo Failed to install sysmodule "/%sysdir%/recovery.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/recovery.mcm

echo MicroflashOS kernel.mcm [%new_mfver%]>"%disk%/%sysdir%/kernel.mcm"
if not exist "%disk%/%sysdir%/kernel.mcm" (echo Failed to install sysmodule "/%sysdir%/kernel.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/kernel.mcm

echo MicroflashOS Ultracompacter [%new_mfver%]>"%disk%/%sysdir%/compact.mcm"
if not exist "%disk%/%sysdir%/compact.mcm" (echo Failed to install sysmodule "/%sysdir%/compact.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/compact.mcm

echo MicroflashOS Protector [%new_mfver%]>"%disk%/%sysdir%/proctector.mcm"
if not exist "%disk%/%sysdir%/proctector.mcm" (echo Failed to install sysmodule "/%sysdir%/proctector.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/proctector.mcm

echo MicroflashOS Package Manager [%new_mfver%]>"%disk%/%sysdir%/mfpkg.mcm"
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Failed to install sysmodule "/%sysdir%/mfpkg.mcm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/mfpkg.mcm

echo.
echo Installing additional sysmodules...
echo.

if not exist "%disk%/%sysdir%/extra-mods" (md "%disk%/%sysdir%/extra-mods")
cd /d "%disk%/%sysdir%/extra-mods"

echo Audio output [%new_mfver%]>"%disk%/%sysdir%/extra-mods/audio.mfm"
if not exist "%disk%/%sysdir%/extra-mods/audio.mfm" (echo Failed to install sysmodule "/%sysdir%/extra-mods/audio.mfm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/extra-mods/audio.mfm

echo Graphics subsystem [%new_mfver%]>"%disk%/%sysdir%/extra-mods/graphics.mfm"
if not exist "%disk%/%sysdir%/extra-mods/graphics.mfm" (echo Failed to install sysmodule "/%sysdir%/extra-mods/graphics.mfm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/extra-mods/graphics.mfm

echo All-in-one sensor package [%new_mfver%]>"%disk%/%sysdir%/extra-mods/sensors.mfm"
if not exist "%disk%/%sysdir%/extra-mods/sensors.mfm" (echo Failed to install sysmodule "/%sysdir%/extra-mods/sensors.mfm". && echo. && pause && goto recovery)
echo Installed /%sysdir%/extra-mods/sensors.mfm

:: Post-installation activities

echo.
if exist "%disk%/%usrdir%/%username%" (echo Existing userdata partition found! && echo After booting run 'homewipe' to regenerate userdata partition. && echo.)

if not exist "%disk%/%usrdir%/%username%" (
echo Creating userdata partition... && cd /d "%disk%" && rd "%usrdir%" /s /q && md "%usrdir%" && cd "%usrdir%" && md %username% && echo.
if not exist "%disk%/%usrdir%/%username%/" (echo Userdata partition creation failed! && echo. && pause && goto prompt)
)

if not exist "%disk%/%usrdir%/%username%/%osdata%" (
echo Setting up userdata partition...
cd /d "%disk%/%usrdir%/%username%" && md "%osdata%" && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/" (echo Userdata partition creation failed! && echo. && pause && goto prompt)
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
if not exist "%disk%/%sysdir%/core.mcm" (echo Invalid command. && goto prompt)
echo MicroflashOS version: %new_mfver%
if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo F145HBR34K version: %fbver%)
echo Mounted system disk: %sysdisk%
echo.
echo Hostname: %userdomain%
echo Processor: %processor_identifier% (%NUMBER_OF_PROCESSORS% cores)
echo Architecture: %processor_architecture%
echo.
echo Made by Kenneth White.
if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (
echo Jailbreak by Team Centurion with help from Team Starburst
echo Special thanks to nsp and the GigaflashOS devs! )
goto prompt

:time
echo.
if not exist "%disk%/%sysdir%/core.mcm" (echo Invalid command. && goto prompt)
echo Time: %time%
echo Date: %date%
goto prompt

:: Clear the shell

:clear
if not exist "%disk%/%sysdir%/core.mcm" (echo Invalid command. && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/noclear" (cls)
goto prompt

:: Power options

:shutdown
echo.
if not exist "%disk%/%sysdir%/core.mcm" (echo Invalid command. && goto prompt)
title Shutting down...
echo Shutting down...
exit

:: File manager

:mkdir
title File Manager
echo.
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo. && echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Invalid command. && goto prompt)
set /p "chdir=Name of directory to change to: "
echo.
if not exist "%chdir%" (echo Directory invalid! && goto prompt)
cd /d "%chdir%"
echo Changed directory to "%chdir%".
goto prompt

:: Userdata partition management

:home
title File Manager
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo. && echo Invalid command. && goto prompt)
if not exist "%disk%/%usrdir%/%username%" (echo. && echo Userdata partition not found. && goto prompt)
cd /d "%disk%/%usrdir%/%username%"
echo.
echo Welcome home!
goto prompt

:homewipe
title File Manager
echo. 
if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Invalid command. && goto prompt)
if not exist "%disk%/%usrdir%/%username%" (echo Userdata partition not found. && goto prompt)
echo This command wipes all userdata.
echo Back up any data before continuing!
echo.
pause
echo.
echo Creating userdata partition... && cd /d "%disk%" && rd "%usrdir%" /s /q && md "%usrdir%" && cd "%usrdir%" && md %username% && echo.
if not exist "%disk%/%usrdir%/%username%/" (echo Userdata partition creation failed! && echo. && pause && goto prompt)

if not exist "%disk%/%usrdir%/%username%/%osdata%" (
echo Setting up userdata partition...
cd /d "%disk%/%usrdir%/%username%" && md "%osdata%" && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/" (echo Userdata partition creation failed! && echo. && pause && goto prompt)
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

echo Userdata partition creation succeeded!
goto prompt

:: DevTools

:devtools-uninstall
title MicroflashOS DevTools Uninstaller
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo Uninstalling DevTools...
echo.
pause
echo.
set "curdir=%cd%"
cd /d "%disk%/%sysdir%/extra-mods/" && del devtools.mfm /f
if exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Uninstall failed! && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/installed/" && del 001-DevTools /f
if exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/001-DevTools" (echo Uninstall failed! && goto prompt)
echo DevTools uninstalled.
echo You will not be able to use developer commands anymore.
cd /d "%curdir%"
set "new_mfver=%mfver%"
goto prompt

:mountsys
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
if not exist "%disk%/%sysdir%/" (echo System disk not found! Please reinstall MicroflashOS. && goto prompt)
title MicroflashOS System Mounter
echo Mounting...
echo.
cd /d "%disk%/%sysdir%/"
echo Your current directory has been changed to the system disk root.
echo Please be aware that modifying the system disk directly may lead to a brick!
goto prompt

:modules
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo.
echo Critical sysmodules:
echo.
dir /a:-d /b "%disk%/%sysdir%/"
echo.
echo Additional sysmodules:
echo.
dir /a:-d /b "%disk%/%sysdir%/extra-mods/"
goto prompt

:toggles-create
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
set /p "cfgadd=Name of toggle: "
echo %cfgadd%>"%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgadd%"
if not exist "%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgadd%" (echo. && echo Failed to write toggle. && echo. && goto prompt)
echo.
echo Configuration written.
goto prompt

:toggles-delete
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
set /p "cfgdel=Toggle to delete: "
del "%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgdel%" /f /q
if exist "%disk%/%usrdir%/%username%/%osdata%/toggles/%cfgdel%" (echo. && echo Failed to delete toggle. && echo. && goto prompt)
echo.
echo Configuration deleted.
goto prompt

:toggles-enabled
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
echo Enabled toggles:
echo.
dir /a:-d /b "%disk%/%usrdir%/%username%/%osdata%/toggles/"
goto prompt

:toggles-list
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo Invalid command. && goto prompt)
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
echo F145HBR34K Uninstaller
echo.
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %new_mfver%
echo.
echo Uninstalling jailbreak...
echo.
pause
cd /d "%disk%/%sysdir%/extra-mods" && del flashbreak.mfm /f /q
if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo Uninstall failed! && goto prompt)
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
if not exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo Invalid command. && goto prompt)
echo Forcing a reboot...
echo.
goto reboot

:: Package manager functions

:mfpkg-install
title MicroflashOS Package Manager
echo.
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
echo Installed packages:
echo.
dir /a:-d /b "%disk%/%usrdir%/%username%/%osdata%/packages/installed/"
goto prompt

:mfpkg-repo-available
title MicroflashOS Package Manager
echo.
echo Repository: %pkgrepo%
if "%pkgrepo%" == "GigaflashOS Unified Repository [Revision 2]" (
echo.
echo ID 001: MicroflashOS DevTools
echo ID 002: F145HBR34K jailbreak
echo ID 003: WinFlash Compatibility Layer
echo ID 004: nuke
echo ID 005: MicroflashOS Dumper
echo ID 006: Virtual System Disk Mounter
echo ID 007: Robolibs Database Manager [BETA] )
goto prompt

:: Installers

:mfpkg-dl-001
echo.
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading DevTools (pID 001)
echo.
echo Executing installer...
echo.
title MicroflashOS DevTools Installer
if exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools are already installed! && goto prompt)
echo Installing DevTools...
echo.
echo DevTools commands [%new_mfver%]>"%disk%/%sysdir%/extra-mods/devtools.mfm"
set "new_mfver=%mfver%-dev"
if exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading F145HBR34K (pID 002)
echo.
echo Executing installer...
echo.
title F145HBR34K Installer
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %new_mfver%
echo.
if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo Error: F145HBR34K already installed! && goto prompt)

if not exist "%disk%/%sysdir%/cmd.mcm" (echo Sysmodule /%sysdir%/cmd.mcm not found. Please reinstall MicroflashOS. && echo. && goto prompt)
echo Validated /%sysdir%/cmd.mcm

if not exist "%disk%/%sysdir%/fsutils.mcm" (echo Sysmodule /%sysdir%/fsutils.mcm not found. Please reinstall MicroflashOS. && echo. && goto prompt)
echo Validated /%sysdir%/fsutils.mcm

if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo Sysmodule /%sysdir%/extra-mods/devtools.mfm not found. Please reinstall MicroflashOS. && echo. && goto prompt)
echo Validated /%sysdir%/extra-mods/devtools.mfm

echo.
echo Installing system module /%sysdir%/extra-mods/flashbreak.mfm...
echo.
echo F145HBR34K jailbreak utility [%new_mfver%]>"%disk%/%sysdir%/extra-mods/flashbreak.mfm"

if exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (
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

:mfpkg-dl-003
echo.
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading mountvirt (pID 006)
echo.
echo Executing installer...
echo.
echo Virtual System Disk Mounter by GigaflashOS Devs >"%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/mountvirt.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/006-mountvirt"
if not exist "%disk%/%usrdir/%username%/%osdata%/packages/installed/006-mountvirt" (echo Failed to register package. && goto prompt)
echo Installed /%usrdir%/%osdata%/packages/mountvirt.mfp
goto prompt

:mfpkg-dl-007
echo.
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
title MicroflashOS Package Manager
echo Downloading databases (pID 007)
echo.
echo Executing installer...
echo.
echo Robolibs Database Manager - Project Epsilon>"%disk%/%usrdir%/%username%/%osdata%/packages/dbman.mfp"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/dbman.mfp" (echo Failed to install package. && goto prompt)
echo Robolibs Database Manager - Project Epsilon [%new_mfver%]>"%disk%/%sysdir%/extra-mods/databases.mfm"
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Failed to install sysmodule "/%sysdir%/extra-mods/databases.mfm". && echo. && goto prompt)
echo Installed %sysdir%/extra-mods/databases.mfm
echo.
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages"

if exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases" (echo Existing databases detected, flushing... && rd databases /s /q && echo.)
md databases
if not exist databases (echo Failed to initialize database storage location! && goto prompt)
cd /d "%disk%/%usrdir%/%username%/%osdata%/packages/databases"

echo Creating entity database... && mkdir entities && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities/" (echo Entity database creation failed! && echo. && goto prompt)
echo Creating location database... && mkdir locations && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations/" (echo Location database creation failed! && echo. && goto prompt)
echo Creating object database... && mkdir objects && echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects/" (echo Object database creation failed! && echo. && goto prompt)

echo Installed package from %pkgrepo%> "%disk%/%usrdir%/%username%/%osdata%/packages/installed/007-databases"
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/installed/007-databases" (echo Failed to register package. && goto prompt)

echo Installed databases.
echo.
echo The system will now reboot.
echo.
pause && goto reboot

:: Uninstallers

:mfpkg-rm-003
echo.
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)
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
if not exist "%disk%/%sysdir%/mfpkg.mcm" (echo Invalid command. && goto prompt)s
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
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
title Nuke
echo Nuking system disk. ALL DATA WILL BE WIPED!
echo.
pause
echo.
if exist "%disk%/%sysdir%" (
rd "%disk%/%sysdir%" /s /q
echo System disk nuked.
goto prompt
)
echo System disk not found.
goto prompt

:dumper
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/dumper.mfp" (echo Invalid command. && goto prompt)
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
if not exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo This package requires F145HBR34K to function. Please install pID 002. && goto prompt)
title MicroflashOS Dumper
echo MicroflashOS Dumper by nsp
echo.
if exist "%disk%/%sysdir%" (
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
if not exist "%disk%/%sysdir%/extra-mods/flashbreak.mfm" (echo Invalid command. && goto prompt)
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo DevTools not found. Please install pID 001. && goto prompt)
title Virtual System Disk Mounter
echo Virtual system disks should be placed in the same directory as the Batch file.
echo Current directory: %~p0
echo.
echo NOTE: Don't fill in the blank with blanks!
echo.
set /p "sysvirt=Name of system disk: "
echo.
if not exist "%~p0%sysvirt%" (echo System disk not found! && goto prompt)
set "sysdisk=%sysvirt%"
echo Mounted virtual disk! Rebooting...
echo.
pause
goto reboot

:: databases - initial implementation

:: Entity database management

:entities-add
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo Entity database not found! && goto prompt)
set /p "entity_add=Entity to add to database: "
echo.
set /p "entity_desc=Entity description: "
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo Entity database not found! && goto prompt)
echo %entity_add%: %entity_desc%>"%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities/%entity_add%"
echo Entity %entity_add% added.
goto prompt

:entities-del
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo Entity database not found! && goto prompt)
set /p "entity_del=Entity to delete from database: "
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo Entity database not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities/%entity_del%" (echo Database entry not found! && goto prompt)
del "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities/%entity_del%" /f
echo Entity %entity_del% deleted.
goto prompt

:entities-list
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo Entity database not found! && goto prompt)
dir "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" /b
goto prompt

:entities-wipe
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo Entity database not found! && goto prompt)
echo Wipe all database entries?
echo.
pause
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities" (echo. && echo Entity database not found! && goto prompt)
echo.
cd "%disk%/%usrdir%/%username%/%osdata%/packages/databases/entities"
del *.* /f /q
cd %cd%
echo Entity database wiped.
goto prompt

:: Location database management

:locations-add
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
set /p "location_add=Location to add to database: "
echo.
set /p "location_desc=Location description: "
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
echo %location_add%: %location_desc%>"%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations/%location_add%"
echo Location %location_add% added.
goto prompt

:locations-del
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
set /p "location_del=Location to delete from database: "
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations/%location_del%" (echo Database entry not found! && goto prompt)
del "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations/%location_del%" /f
echo Location %location_del% deleted.
goto prompt

:locations-list
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
dir "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" /b
goto prompt

:locations-wipe
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
echo Wipe all database entries?
echo.
pause
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations" (echo Location database not found! && goto prompt)
cd "%disk%/%usrdir%/%username%/%osdata%/packages/databases/locations"
del *.* /f /q
cd %cd%
echo Location database wiped.
goto prompt

:: Object database management

:objects-add
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
set /p "object_add=Object to add to database: "
echo.
set /p "object_desc=Object description: "
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
echo %object_add%: %object_desc%>"%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects/%object_add%"
echo Object %object_add% added.
goto prompt

:objects-del
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
set /p "object_del=Object to delete from database: "
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects/%object_del%" (echo Database entry not found! && goto prompt)
del "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects/%object_del%" /f
echo Object %object_del% deleted.
goto prompt

:objects-list
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
dir "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" /b
goto prompt

:objects-wipe
echo.
if not exist "%disk%/%sysdir%/extra-mods/devtools.mfm" (echo This package requires DevTools to function. Please install pID 001. && goto prompt
if not exist "%disk%/%sysdir%/extra-mods/databases.mfm" (echo Database manager not found! && goto prompt)
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
echo Wipe all database entries?
echo.
pause
echo.
if not exist "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects" (echo Object database not found! && goto prompt)
cd "%disk%/%usrdir%/%username%/%osdata%/packages/databases/objects"
del *.* /f /q
cd %cd%
echo Object database wiped.
goto prompt
