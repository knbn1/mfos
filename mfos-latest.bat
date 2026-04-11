::  Source code of MicroflashOS
::  A "fantasy operating system" made by KNBnoob1!
::  Website: https://knbn1.github.io

@echo off

:: Define some version strings

set "fbver=4.6"
set "pkgrepo=GigaflashOS Unified Repository [Revision 1]"

:: Define default directories

set "sysdir=mfos"
set "usrdir=userdata"
set "datadir=mfosdata"
set "modsdir=extra-mods"
set "disk0label=MicroflashOS"

:: Boot process stage 0 - Bootloader

:reboot
cd /d %~p0
title MicroflashOS Bootloader

:: System disk stuffs

set "disk0=%~p0%disk0label%"
set "disk0p1=%disk0%/%sysdir%"
set "disk0p2=%disk0%/%usrdir%"

:: Define MicroflashOS version

if not exist "%disk0p1%/%modsdir%/devtools.mfm" (set "mfosver=2026.04.12")
if exist "%disk0p1%/%modsdir%/devtools.mfm" (set "mfosver=2026.04.12-dev")

:: Startup parameters

if exist "%disk0p2%/%username%/%datadir%/toggles/echoon" (@echo on)
if not exist "%disk0p2%/%username%/%datadir%/toggles/noclear" (cls)
if exist "%disk0p2%/%username%/%datadir%/toggles/nolog" (set "syslog=NUL")
if not exist "%disk0p2%/%username%/%datadir%/toggles/nolog" (set "syslog=%~p0mfos-log.txt")

:: Start logging

echo [bootloader] INFO: logging system initialized!
echo [bootloader] INFO: log location: %syslog%
echo [bootloader] INFO: to log or not to log, that is the question > "%syslog%"
echo.
echo Bundled kernel: %mfosver%
echo.

if exist "%disk0p2%/%username%/%datadir%/toggles/slowboot" (echo Slowboot toggle is enabled. && pause && echo. && echo [bootloader] DEBUG: slowboot toggle enabled. >> "%syslog%" )

:: Transfer control to kernel

echo [bootloader] INFO: loading bundled kernel... >> "%syslog%"
echo [kernel] INFO: hello world, my version is %mfosver% >> "%syslog%"
echo [kernel] INFO: terminating bootloader... done! >> "%syslog%"

:: System disk check

title Finding system disk...
if exist "%disk0label%" (
echo System disk "%disk0label%" mounted as /
echo [kernel] INFO: system disk is "%disk0label%" >> "%syslog%"
) else (
echo Unable to mount system disk!
echo [kernel] ERROR: system disk mount failure >> "%syslog%"
title Startup Failure!
echo [kernel] ERROR: startup faiiure! >> "%syslog%"
echo MicroflashOS startup failed. Entering recovery...
echo.
pause
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery
)

:: Boot process stage 1 - Initialize devices

echo.
title Initializing devices...
echo Initializing devices...
echo [kernel] INFO: begin boot process stage 1 >> "%syslog%"
echo.

if not exist "%disk0p1%/devices" (echo [kernel-device-init] WARN: device folder not found, creating... >> "%syslog%" && cd /d "%disk0p1%" && md devices)
if not exist "%disk0p1%/devices/mem" (cd /d "%disk0p1%/devices" && md mem)

echo System disk - /%sysdir%/>"%disk0p1%/devices/disk0p1"
if not exist "%disk0p1%/devices/disk0p1" (echo [kernel-device-init] ERROR: failed to initialize "disk0p1" >> "%syslog%" && echo Could not initialize device "disk0p1" && echo. && pause && echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Initialized device "disk0p1"
echo [kernel-device-init] INFO: system partition initialized >> "%syslog%"

echo Memory sector 1 - Core system files>"%disk0p1%/devices/mem/memsect1"
if not exist "%disk0p1%/devices/mem/memsect1" (echo [kernel-device-init] ERROR: failed to initialize "memsect1" >> "%syslog%" && echo Could not initialize device "memsect1" && echo. && pause && echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Initialized device "memsect1"
echo [kernel-device-init] INFO: memory sector 1 initialized >> "%syslog%"

echo Memory sector 2 - Userspace>"%disk0p1%/devices/mem/memsect2"
if not exist "%disk0p1%/devices/mem/memsect2" (echo [kernel-device-init] ERROR: failed to initialize "memsect2" >> "%syslog%" && echo Could not initialize device "memsect2" && echo. && pause && echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Initialized device "memsect2"
echo [kernel-device-init] INFO: memory sector 2 initialized >> "%syslog%"

echo Memory sector 3 - Secret Block>"%disk0p1%/devices/mem/memsect3"
if not exist "%disk0p1%/devices/mem/memsect3" (echo [kernel-device-init] ERROR: failed to initialize "memsect3" >> "%syslog%" && echo Could not initialize device "memsect3" && echo. && pause && echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Initialized device "memsect3"
echo [kernel-device-init] INFO: memory sector 3 initialized >> "%syslog%"

echo Human Interface Devices>"%disk0p1%/devices/hids"
if not exist "%disk0p1%/devices/hids" (echo [kernel-device-init] ERROR: failed to initialize "hids" >> "%syslog%" && echo Could not initialize device "hids" && echo. && pause && echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Initialized device "hids"
echo [kernel-device-init] INFO: human interface devices initialized >> "%syslog%"

echo Auditory devices: headphones, speakers, microphones, etc. >"%disk0p1%/devices/audio"
if not exist "%disk0p1%/devices/audio" (echo [kernel-device-init] ERROR: failed to initialize "audio" >> "%syslog%" && echo Could not initialize device "audio" && echo. && pause && echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Initialized device "audio"
echo [kernel-device-init] INFO: audio subsystem initialized >> "%syslog%"

if exist "%disk0p2%/%username%/%datadir%/toggles/slowboot" (echo [kernel] DEBUG: slowboot toggle tripped >> "%syslog%" && echo. && pause)

:: Boot process stage 2 - Load sysmodules

title Loading sysmodules...
echo.
echo Loading sysmodules...
echo [kernel] INFO: begin boot process stage 2 >> "%syslog%"

:: Initialization of core sysmodules

if exist "%disk0p1%/kernel.mcm" (echo Loaded /%sysdir%/kernel.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/kernel.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/kernel.mcm
echo [kernel-mods-init] failed to load /%sysdir%/kernel.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/recovery.mcm" (echo Loaded /%sysdir%/recovery.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/recovery.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/recovery.mcm
echo [kernel-mods-init] failed to load /%sysdir%/recovery.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/core.mcm" (echo Loaded /%sysdir%/core.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/core.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/core.mcm
echo [kernel-mods-init] failed to load /%sysdir%/core.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/fsutils.mcm" (echo Loaded /%sysdir%/fsutils.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/fsutils.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/fsutils.mcm
echo [kernel-mods-init] failed to load /%sysdir%/fsutils.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/ltmem.mcm" (echo Loaded /%sysdir%/ltmem.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/ltmem.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/ltmem.mcm
echo [kernel-mods-init] failed to load /%sysdir%/ltmem.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/stmem.mcm" (echo Loaded /%sysdir%/stmem.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/stmem.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/stmem.mcm
echo [kernel-mods-init] failed to load /%sysdir%/stmem.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/cmd.mcm" (echo Loaded /%sysdir%/cmd.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/cmd.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/cmd.mcm
echo [kernel-mods-init] failed to load /%sysdir%/cmd.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/compact.mcm" (echo Loaded /%sysdir%/compact.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/compact.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/compact.mcm
echo [kernel-mods-init] failed to load /%sysdir%/compact.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/proctector.mcm" (echo Loaded /%sysdir%/proctector.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/proctector.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/proctector.mcm
echo [kernel-mods-init] failed to load /%sysdir%/proctector.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )

if exist "%disk0p1%/mfpkg.mcm" (echo Loaded /%sysdir%/mfpkg.mcm && echo [kernel-mods-init] INFO: load core module /%sysdir%/mfpkg.mcm >> "%syslog%") else (
echo Could not load /%sysdir%/mfpkg.mcm
echo [kernel-mods-init] failed to load /%sysdir%/mfpkg.mcm
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery...
echo [kernel] INFO: booting to recovery... >> "%syslog%" && echo [kernel] INFO: booting to recovery... && goto recovery )


:: Initialization of non-critical sysmodules

if exist "%disk0p1%/%modsdir%/sensors.mfm" (echo Loaded /%sysdir%/%modsdir%/sensors.mfm && echo [kernel-mods-init] INFO: loaded extra module /%sysdir%/%modsdir%/sensors.mfm >> "%syslog%")
if exist "%disk0p1%/%modsdir%/audio.mfm" (echo Loaded /%sysdir%/%modsdir%/audio.mfm && echo [kernel-mods-init] INFO: loaded extra module /%sysdir%/%modsdir%/audio.mfm >> "%syslog%")
if exist "%disk0p1%/%modsdir%/graphics.mfm" (echo Loaded /%sysdir%/%modsdir%/graphics.mfm && echo [kernel-mods-init] INFO: loaded extra module /%sysdir%/%modsdir%/graphics.mfm >> "%syslog%")
if exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Loaded /%sysdir%/%modsdir%/devtools.mfm && echo [kernel-mods-init] INFO: loaded extra module /%sysdir%/%modsdir%/devtools.mfm >> "%syslog%")
if exist "%disk0p1%/%modsdir%/databases.mfm" (echo Loaded %sysdir%/%modsdir%/databases.mfm && echo [kernel-mods-init] INFO: loaded extra module /%sysdir%/%modsdir%/databases.mfm >> "%syslog%")

if exist "%disk0p2%/%username%/%datadir%/toggles/slowboot" (echo [kernel] DEBUG: slowboot toggle tripped >> "%syslog%" && echo. && pause)

:: Jailbreak loading process

if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (
  title Hello F145HBR34K!
  echo.
  echo Loading F145HBR34K...
  echo [flashbreak-stage-2] INFO: loading jailbreak... >> "%syslog%"
  echo.
  if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools not found! && echo. && echo F145HBR34K could not be loaded. && echo [flashbreak-stage-2] ERROR: failed to load %disk0p1%/%modsdir%/devtools.mfm, flashbreak could not be loaded. >> "%syslog%") else (
  echo [flashbreak-stage-2] INFO: starting sysmodule patches... >> "%syslog%"

  if not exist "%disk0p1%/cmd.mcm" (echo Sysmodule /%sysdir%/cmd.mcm not found. Please reinstall MicroflashOS. && echo [flashbreak-stage-2] ERROR: failed to load %disk0p1%/%modsdir%/cmd.mfm, flashbreak could not be loaded. >> "%syslog%")
  echo Patching /%sysdir%/cmd.mcm
  echo Command line [%mfosver%] [FLASHBROKEN]>"%disk0p1%/cmd.mcm"
  echo [flashbreak-stage-2] INFO: patched /%sysdir%/cmd.mcm >> "%syslog%"

  if not exist "%disk0p1%/fsutils.mcm" (echo Sysmodule /%sysdir%/fsutils.mcm not found. Jailbreak unsuccessful. && echo [flashbreak-stage-2] ERROR: failed to load %disk0p1%/%modsdir%/fsutils.mfm, flashbreak could not be loaded. >> "%syslog%")
  echo Patching /%sysdir%/fsutils.mcm
  echo File system read/write utilities [%mfosver%] [FLASHBROKEN]>"%disk0p1%/fsutils.mcm"
  echo [flashbreak-stage-2] INFO: patched /%sysdir%/fsutils.mcm >> "%syslog%"

  if not exist "%disk0p1%/proctector.mcm" (echo Sysmodule /%sysdir%/proctector.mcm not found. Jailbreak unsuccessful. && echo [flashbreak-stage-2] ERROR: failed to load %disk0p1%/%modsdir%/proctector.mfm, flashbreak could not be loaded. >> "%syslog%")
  echo Patching /%sysdir%/proctector.mcm
  echo MicroflashOS Protector [%mfosver%] [FLASHBROKEN]>"%disk0p1%/proctector.mcm"
  echo [flashbreak-stage-2] INFO: patched /%sysdir%/proctector.mcm >> "%syslog%"

  if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Sysmodule /%sysdir%/%modsdir%/devtools.mfm not found. Jailbreak unsuccessful. && echo [flashbreak-stage-2] ERROR: failed to load %disk0p1%/%modsdir%/devtools.mfm, flashbreak could not be loaded. >> "%syslog%")
  echo Patching /%sysdir%/%modsdir%/devtools.mfm
  echo DevTools commands [%mfosver%] [FLASHBROKEN]>"%disk0p1%/%modsdir%/devtools.mfm"
  echo [flashbreak-stage-2] INFO: patched /%sysdir%/devtools.mcm >> "%syslog%"

  echo.
  echo All sysmodule patches complete.
  echo [flashbreak-stage-2] INFO: patches completed with no issues! >> "%syslog%"
  echo.
  echo Resuming boot process...
  echo [flashbreak-stage-2] INFO: exiting cleanly to resume boot process >> "%syslog%"
  if exist "%disk0p2%/%username%/%datadir%/toggles/slowboot" (pause)
  ) ) )

:: Boot process stage 3 - Userdata partition

title Checking userdata partition...
echo [kernel] INFO: begin boot process stage 3 >> "%syslog%"
echo.
if exist "%disk0p2%" (echo Userdata partition is /%usrdir%/. && echo Userdata partition - /%usrdir%/>"%disk0p1%/devices/disk0p2" && echo [kernel-device-init] INFO: userdata partition initialized >> "%syslog%")
if exist "%disk0p2%/%username%" (echo Logging in as %username% && echo [kernel-userdata-init] INFO: logging in as %username% >> "%syslog%")

:: Userdata generation

if not exist "%disk0p2%" (
echo Userdata partition not found!
echo [kernel-device-init] ERROR: failed to initialize userdata partition >> "%syslog%"
echo.
echo Creating userdata partition...
echo [kernel-userdata-init] INFO: creating userdata partition >> "%syslog%"
cd /d "%disk0%" && md "%usrdir%" && echo Userdata partition - /%usrdir%/>"%disk0p1%/devices/disk0p2" && echo.
if not exist "%disk0p2%" (echo Userdata partition creation failed! && echo [kernel-userdata-init] ERROR: userdata partition creation failed! >> "%syslog%" && echo. && pause && exit)
)

if not exist "%disk0p2%/%username%" (
echo Userdata for user %username% not found!
echo [kernel-userdata-init] ERROR: no userdata found for user %username% >> "%syslog%"
echo.
echo Creating userdata for %username%...
echo [kernel-userdata-init] INFO: creating userdata for user %username% >> "%syslog%"
cd /d "%disk0p2%" && md %username% && echo.
if not exist "%disk0p2%/%username%/" (echo Userdata creation failed! && echo [kernel-userdata-init] ERROR: userdata creation for user %username% failed! >> "%syslog%" && echo. && pause && exit)
)

if not exist "%disk0p2%/%username%/%datadir%" (
echo Setting up userdata for %username%...
echo [kernel-userdata-init] INFO: setting up userdata for %username% >> "%syslog%"
cd /d "%disk0p2%/%username%" && md "%datadir%" && echo.
if not exist "%disk0p2%/%username%/%datadir%/" (echo Userdata creation failed! && echo [kernel-userdata-init] ERROR: userdata creation for user %username% failed! >> "%syslog%" && echo. && pause && exit)
)

if not exist "%disk0p2%/%username%/%datadir%/toggles/" (
echo Creating configuration directory...
echo [kernel-userdata-init] INFO: creating configuration directory for %username% >> "%syslog%"
cd /d "%disk0p2%/%username%/%datadir%" && md toggles && echo.
if not exist "%disk0p2%/%username%/%datadir%/toggles" (echo Configuration directory creation failed! && echo [kernel-userdata-init] ERROR: configuration directory creation for user %username% failed! >> "%syslog%" && echo. && pause && exit)
)

if not exist "%disk0p2%/%username%/%datadir%/packages/" (
echo Creating package directory...
echo [kernel-userdata-init] INFO: creating package directory for %username% >> "%syslog%"
cd /d "%disk0p2%/%username%/%datadir%"
md packages && cd /d "%disk0p2%/%username%/%datadir%/packages" && md installed && echo.
if not exist "%disk0p2%/%username%/%datadir%/packages/" (echo Package directory creation failed! && echo [kernel-userdata-init] ERROR: package directory creation for user %username% failed! >> "%syslog%" && echo. && pause && exit)
if not exist "%disk0p2%/%username%/%datadir%/packages/installed" (echo Package directory creation failed! && echo [kernel-userdata-init] ERROR: package directory creation for user %username% failed! >> "%syslog%" && echo. && pause && exit)
)

:: Boot process complete!

title System files loaded!
echo.
echo MicroflashOS system files loaded!
echo [kernel] INFO: boot process completed! >> "%syslog%"
echo.
cd /d "%disk0p2%/%username%"
if exist "%disk0p2%/%username%/%datadir%/toggles/slowboot" (pause)

:: Welcome messages

if not exist "%disk0p2%/%username%/%datadir%/toggles/noclear" (cls)
if not exist "%disk0p2%/%username%/%datadir%/toggles/nowelcome" (
echo.
if not exist "%disk0p1%/cmd.mcm" (echo [kernel] ERROR: could not load /%sysdir%/cmd.mcm >> "%syslog%" && echo Command line could not be loaded. Please reinstall MicroflashOS. && echo. && pause && exit)
echo Welcome to MicroflashOS!
echo [cmd] INFO: initialized prompt >> "%syslog%"
echo.
if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo F145HBR34K %fbver% && echo.))
if not exist "%disk0p2%/%username%" (
echo Userdata for user %username% not found!
echo [kernel-userdata-init] ERROR: no userdata for user %username%! >> "%syslog%"
echo. && pause && echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot)
echo Logged in as %username%
echo [cmd] INFO: current user: %username% >> "%syslog%"
echo.
echo Type HELP for a list of commands.
echo Commands are not case-sensitive.
goto prompt
)

:: User prompt

:prompt

echo.
if not exist "%disk0p1%/cmd.mcm" (echo [kernel] ERROR: could not load /%sysdir%/cmd.mcm >> "%syslog%" && echo Command line could not be loaded. Please reinstall MicroflashOS. && echo. && pause && exit)

:: Titlebar stuff

set "titlebar=MicroflashOS %mfosver%"
title %titlebar%
if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (title %titlebar% [F145HBR34K %fbver%] && echo [flashbreak] INFO: modified titlebar >> "%syslog%"))
if exist "%disk0p2%/%username%/%datadir%/toggles/showdir" (echo [cmd] DEBUG: showing directories is enabled! >> "%syslog%" && echo Current directory: %cd% && echo.)

:: Reset last run command variable

set "cmd="
echo [cmd] INFO: waiting for user input >> "%syslog%"
set /p "cmd=%username%@%userdomain%: "

:: thanks Gemini!

title Processing command...
echo [cmd] INFO: received command "%cmd%" >> "%syslog%"
set "cmd_found=false"
for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
    if /i "%%A"=="%cmd%" set "cmd_found=true"
)
if "%cmd_found%"=="false" (
    echo.
    echo Invalid command.
    echo [cmd] INFO: command invalid! >> "%syslog%"
    echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt
)
echo [cmd] INFO: command valid! >> "%syslog%"
goto %cmd%

:: Main help section

:help
echo.
if not exist "%disk0p1%/core.mcm" (echo Invalid command. && echo [help] ERROR: could not load /%sysdir%/core.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Utilities:
echo.
echo about: Show some system info
echo clock: Prints current date and time
echo clear: Clears console output
echo.
echo Power options:
echo.
echo reboot: Reboot system
echo recovery: Reboot to recovery mode
echo shutdown: Shutdown system
echo.
echo [help] INFO: loaded help section for /%sysdir%/core.mcm >> "%syslog%"
if exist "%disk0p1%/fsutils.mcm" (
echo File management:
echo.
echo mkdir: Create a directory
echo mkfile: Create a file
echo del: Delete a file/directory
echo list: List available files/directories
echo cd: Change to a directory
echo home: Quickly change to user directory
echo homewipe: Wipe user directory
echo [help] INFO: loaded help section for /%sysdir%/fsutils.mcm >> "%syslog%"
)
if exist "%disk0p1%/%modsdir%/devtools.mfm" (
echo.
echo Developer commands:
echo.
echo devtools-uninstall: DevTools uninstaller
echo mountsys: Mount system disk to modify contents
echo modules: List installed system modules "sysmodules"
echo toggles-[create/delete/enabled/list]: Manage system "toggles"
echo [help] INFO: loaded help section for /%sysdir%/%modsdir%/devtools.mfm >> "%syslog%"
if exist  "%disk0p1%/%modsdir%/flashbreak.mfm" (
echo.
echo F145HBR34K commands:
echo.
echo flashbreak-uninstall: Uninstall jailbreak
echo flashbreak-reboot: Force reboot regardless of core.mcm presence
echo [help] INFO: loaded help section for /%sysdir%/%modsdir%/flashbreak.mfm >> "%syslog%"
)
)
if exist "%disk0p1%/mfpkg.mcm" (
echo.
echo Package management:
echo.
echo mfpkg-[install/uninstall/list]: Local package management
echo mfpkg-[dl/rm]-[package ID]: Install/uninstall package directly
echo mfpkg-repo-available: Check available packages in repository
echo.
echo [help] INFO: loaded help section for /%sysdir%/mfpkg.mcm >> "%syslog%"
echo Commands for installed packages:
echo.
if exist "%disk0p2%/%username%/%datadir%/packages/nuke.mfp" (echo nuke: Nuke. && echo [mfpkg] INFO: found package /%usrdir%/%username%/%datadir%/packages/nuke.mfp >> "%syslog%")
if exist "%disk0p2%/%username%/%datadir%/packages/dumper.mfp" (echo dumper: MicroflashOS firmware dumper by nsp && echo [mfpkg] INFO: found package /%usrdir%/%username%/%datadir%/packages/dumper.mfp >> "%syslog%")
if exist "%disk0p2%/%username%/%datadir%/packages/winflash.mfp" (echo winflash: WinFlash compatibility layer for Windows software && echo [mfpkg] INFO: found package /%usrdir%/%username%/%datadir%/packages/winflash.mfp >> "%syslog%")
if exist "%disk0p2%/%username%/%datadir%/packages/mountvirt.mfp" (echo mountvirt: Mount and boot to a system disk of your choice && echo [mfpkg] INFO: found package /%usrdir%/%username%/%datadir%/packages/mountvirt.mfp >> "%syslog%")
)
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: MicroflashOS Recovery

:recovery
if not exist "%disk0p2%/%username%/%datadir%/toggles/noclear" (cls)
cd /d "%~p0"
title MicroflashOS Recovery
echo.
echo Reinstalling MicroflashOS.
echo.
pause
if not exist "%~p0%disk0label%" (md "%disk0label%")
if not exist "%~p0%disk0label%" (echo. && echo Failed to format system disk! && echo. && pause && exit)
echo.
echo System disk "%disk0label%" mounted as /
cd /d "%~p0%disk0label%"
if exist %sysdir% (rd %sysdir% /s /q)
if not exist %sysdir% (md %sysdir%)
if not exist %sysdir% (echo. && echo Failed to create operating system data directory! && echo. && pause && exit)

echo.
echo Installing core sysmodules...
echo.

echo Long-term memory [%mfosver%]>"%disk0p1%/ltmem.mcm"
if not exist "%disk0p1%/ltmem.mcm" (echo Failed to install sysmodule "/%sysdir%/ltmem.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/ltmem.mcm

echo Short-term memory [%mfosver%]>"%disk0p1%/stmem.mcm"
if not exist "%disk0p1%/stmem.mcm" (echo Failed to install sysmodule "/%sysdir%/stmem.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/stmem.mcm

echo Core MicroflashOS commands [%mfosver%]>"%disk0p1%/core.mcm"
if not exist "%disk0p1%/core.mcm" (echo Failed to install sysmodule "/%sysdir%/core.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/core.mcm

echo File system read/write utilities [%mfosver%]>"%disk0p1%/fsutils.mcm"
if not exist "%disk0p1%/fsutils.mcm" (echo Failed to install sysmodule "/%sysdir%/fsutils.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/fsutils.mcm

echo Command line [%mfosver%]>"%disk0p1%/cmd.mcm"
if not exist "%disk0p1%/cmd.mcm" (echo Failed to install sysmodule "/%sysdir%/cmd.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/cmd.mcm

echo MicroflashOS recovery [%mfosver%]>"%disk0p1%/recovery.mcm"
if not exist "%disk0p1%/recovery.mcm" (echo Failed to install sysmodule "/%sysdir%/recovery.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/recovery.mcm

echo MicroflashOS kernel.mcm [%mfosver%]>"%disk0p1%/kernel.mcm"
if not exist "%disk0p1%/kernel.mcm" (echo Failed to install sysmodule "/%sysdir%/kernel.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/kernel.mcm

echo MicroflashOS Ultracompacter [%mfosver%]>"%disk0p1%/compact.mcm"
if not exist "%disk0p1%/compact.mcm" (echo Failed to install sysmodule "/%sysdir%/compact.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/compact.mcm

echo MicroflashOS Protector [%mfosver%]>"%disk0p1%/proctector.mcm"
if not exist "%disk0p1%/proctector.mcm" (echo Failed to install sysmodule "/%sysdir%/proctector.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/proctector.mcm

echo MicroflashOS Package Manager [%mfosver%]>"%disk0p1%/mfpkg.mcm"
if not exist "%disk0p1%/mfpkg.mcm" (echo Failed to install sysmodule "/%sysdir%/mfpkg.mcm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/mfpkg.mcm

echo.
echo Installing additional sysmodules...
echo.

if not exist "%disk0p1%/%modsdir%" (md "%disk0p1%/%modsdir%")
cd /d "%disk0p1%/%modsdir%"

echo Audio output [%mfosver%]>"%disk0p1%/%modsdir%/audio.mfm"
if not exist "%disk0p1%/%modsdir%/audio.mfm" (echo Failed to install sysmodule "/%sysdir%/%modsdir%/audio.mfm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/%modsdir%/audio.mfm

echo Graphics subsystem [%mfosver%]>"%disk0p1%/%modsdir%/graphics.mfm"
if not exist "%disk0p1%/%modsdir%/graphics.mfm" (echo Failed to install sysmodule "/%sysdir%/%modsdir%/graphics.mfm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/%modsdir%/graphics.mfm

echo All-in-one sensor package [%mfosver%]>"%disk0p1%/%modsdir%/sensors.mfm"
if not exist "%disk0p1%/%modsdir%/sensors.mfm" (echo Failed to install sysmodule "/%sysdir%/%modsdir%/sensors.mfm". && echo. && pause && echo [kernel] INFO: booting to recovery... && goto recovery)
echo Installed /%sysdir%/%modsdir%/sensors.mfm

echo.
echo MicroflashOS installation complete. && echo. && pause && echo.
title Rebooting...
echo Rebooting...
goto reboot

:: About me

:about
echo.
if not exist "%disk0p1%/core.mcm" (echo Invalid command. && echo [help] ERROR: could not load /%sysdir%/core.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo MicroflashOS version: %mfosver%
echo [about] INFO: mfos version is %mfosver% >> "%syslog%"
if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo F145HBR34K version: %fbver% && echo [about] INFO: flashbreak version is %mfosver% >> "%syslog%") )
echo Mounted system disk: %disk0label%
echo [about] INFO: mounted system disk is %disk0label% >> "%syslog%"
echo.
echo Hostname: %userdomain%
echo [about] INFO: hostname is %userdomain% >> "%syslog%"
echo Processor: %processor_identifier% (%NUMBER_OF_PROCESSORS% cores)
echo [about] INFO: processor is %processor_identifier% with %NUMBER_OF_PROCESSORS% cores >> "%syslog%"
echo Architecture: %processor_architecture%
echo [about] INFO: architecture is %processor_architecture% >> "%syslog%"
echo.
echo Made by Kenneth White.
if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (
echo Jailbreak by Team Centurion with help from Team Starburst
echo Special thanks to nsp and the GigaflashOS devs! ) )
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:clock
echo.
if not exist "%disk0p1%/core.mcm" (echo Invalid command. && echo [help] ERROR: could not load /%sysdir%/core.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Time: %time% && echo Date: %date%
echo [clock] INFO: fetched time is %time% and date is %date% >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Clear the shell

:clear
if not exist "%disk0p1%/core.mcm" (echo Invalid command. && echo [help] ERROR: could not load /%sysdir%/core.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p2%/%username%/%datadir%/toggles/noclear" (cls && echo [cmd] INFO: user requested shell clearance >> "%syslog%")
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Power options

:shutdown
echo.
if not exist "%disk0p1%/core.mcm" (echo Invalid command. && echo [help] ERROR: could not load /%sysdir%/core.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title Shutting down...
echo Shutting down...
echo [cmd] INFO: shutting down... >> "%syslog%"
exit

:: File manager

:mkdir
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title File Manager
echo.
set /p "mkd=Directory to create: "
if exist "%mkd%" (echo. && echo Directory already exists! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
md "%mkd%"
if not exist "%mkd%" (echo. && echo Directory creation failed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Directory created.
echo [fsutils] INFO: created directory "%mkd%" >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mkfile
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title File Manager
echo.
set /p "mkf_name=New file name: "
echo.
set /p "mkf_contents=File contents: "
if exist "%mkf_name%" (echo File already exists! && echo [fsutils] ERROR: attempted to create file "%mkf_name%" but file with that name already exists! >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo %mkf_contents%>"%mkf_name%"
if not exist "%mkf_name%" (echo File creation failed! && echo [fsutils] ERROR: could not create file "%mkf_name%" >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo File created.
echo [fsutils] INFO: created file "%mkf_name%" containing "%mkf_contents%" >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:del
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title File Manager
echo.
set /p "del=File/directory to delete: "
if not exist "%del%" (echo. && echo File/directory does not exist. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
del "%del%" /f /q
if not exist "%del%" (echo. && echo Deleted file! && echo [fsutils] INFO: deleted file "%del%" >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
rd "%del%" /s /q
if not exist "%del%" (echo. && echo Deleted folder! && echo [fsutils] INFO: deleted folder "%del%" >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Failed to delete file/directory "%del%"!
echo [fsutils] ERROR: failed to delete "%del%" >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:list
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title File Manager
echo.
echo [fsutils] INFO: listing objects in current directory... >> "%syslog%"
echo Directories:
echo.
dir /a:d /b
echo.
echo Files:
echo.
dir /a:-d /b
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:cd
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title File Manager
echo.
set /p "chdir=Name of directory to change to: "
echo.
if not exist "%chdir%" (echo Directory invalid! && echo [fsutils] ERROR: invalid directory >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd "%chdir%"
echo Changed directory to "%chdir%"
echo [fsutils] INFO: changed directory to "%chdir%" >> "%syslog%"
echo [fsutils] INFO: current path is %cd%  >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Userdata management

:home
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title File Manager
if not exist "%disk0p2%/%username%" (echo. && echo Userdata for current user not found. && echo [fsutils] ERROR: could not find userdata for current user! >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd /d "%disk0p2%/%username%"
echo.
echo Welcome home!
echo [fsutils] INFO: reverted current path to home >> "%syslog%"
echo [fsutils] INFO: current path is %cd%  >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:homewipe
title File Manager
echo. 
if not exist "%disk0p1%/fsutils.mcm" (echo Invalid command. && echo [cmd] ERROR: could not load /%sysdir%/fsutils.mcm >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p2%" (echo Userdata partition not found. && echo [fsutils] ERROR: could not load userdata partition! >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo This command wipes userdata for all users, both logged out and logged in.
echo This effectively returns MicroflashOS to a "clean" state.
echo Back up any data before continuing!
echo.
echo [fsutils] INFO: requesting user confirmation to wipe userdata partition >> "%syslog%"
pause
echo.
echo Found users:
dir /a:d /b "%disk0p2%"
echo.
echo Wiping userdata...
cd /d "%disk0%" && rd "%usrdir%" /s /q
if exist "%disk0p2%" (echo. && echo Userdata wipe failed! && echo [fsutils] ERROR: could not wipe userdata partition! >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Wipe succeeded. The system will now reboot.
echo [fsutils] INFO: all userdata wiped! >> "%syslog%"
echo.
pause
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot

:: DevTools

:devtools-uninstall
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS DevTools Uninstaller
echo.
echo Uninstalling DevTools...
echo.
pause
echo.
set "curdir=%cd%"
cd /d "%disk0p1%/%modsdir%/" && del devtools.mfm /f
if exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Uninstall failed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd /d "%disk0p2%/%username%/%datadir%/packages/installed/" && del 001-DevTools /f
if exist "%disk0p2%/%username%/%datadir%/packages/installed/001-DevTools" (echo Uninstall failed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo DevTools uninstalled.
echo You will not be able to use developer commands anymore.
cd /d "%curdir%"
echo.
echo The system will reboot.
echo.
pause
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot

:mountsys
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/" (echo System partition not found! && echo [mountsys] ERROR: system partition not found! >> "%syslog%" && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS System Partition Mounter
echo.
echo Mounting disk0p1...
echo.
cd /d "%disk0p1%/"
echo [mountsys] INFO: mounted system partition >> "%syslog%"
echo Your current directory has been changed to the system partition.
echo Modifying the system partition directly may break your device!
echo Use with caution!
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:modules
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo [modules] INFO: listing installed sysmodules... >> "%syslog%"
echo Critical sysmodules:
echo.
dir /a:-d /b "%disk0p1%/"
echo.
echo Additional sysmodules:
echo.
dir /a:-d /b "%disk0p1%/%modsdir%/"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:toggles-create
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
set /p "cfgadd=Name of toggle: "
echo %cfgadd%>"%disk0p2%/%username%/%datadir%/toggles/%cfgadd%"
if not exist "%disk0p2%/%username%/%datadir%/toggles/%cfgadd%" (echo. && echo Failed to write toggle. && echo [toggle-manager] ERROR: could not write toggle %cfgadd% >> "%syslog%" && echo. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Toggle written.
echo [toggle-manager] INFO: written toggle "%cfgadd%" >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:toggles-delete
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
set /p "cfgdel=Toggle to delete: "
del "%disk0p2%/%username%/%datadir%/toggles/%cfgdel%" /f /q
if exist "%disk0p2%/%username%/%datadir%/toggles/%cfgdel%" (echo. && echo Failed to delete toggle. && echo [toggle-manager] ERROR: could not delete toggle %cfgdel% >> "%syslog%" && echo. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Toggle deleted.
echo [toggle-manager] INFO: deleted toggle "%cfgdel%" >> "%syslog%"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:toggles-enabled
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Enabled toggles:
echo [toggle-manager] INFO: listing enabled toggles... >> "%syslog%"
echo.
dir /a:-d /b "%disk0p2%/%username%/%datadir%/toggles/"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:toggles-list
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Toggles in MicroflashOS as of this version [%mfosver%]:
echo [toggle-manager] INFO: listing all toggles... >> "%syslog%"
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
echo noclear: Disable clearing shell output (this also affects the "clear" command)
echo nolog: Disables all logging functions within MicroflashOS
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Jailbreak

:flashbreak-uninstall
echo.
if not exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [flashbreak] ERROR: required dependency "DevTools" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo F145HBR34K Uninstaller
echo.
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %mfosver%
echo.
echo Uninstalling jailbreak...
echo.
pause
cd /d "%disk0p1%/%modsdir%" && del flashbreak.mfm /f /q
if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo Uninstall failed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt) )
cd /d "%disk0p2%/%username%/%datadir%/packages/installed" && del 002-F145HBR34K /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/installed/002-F145HBR34K" (echo Uninstall failed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo.
echo Jailbreak uninstalled.
echo All F145HBR34K commands will be invalidated.
echo.
echo The system will reboot.
echo.
pause
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot

:flashbreak-reboot
echo.
if not exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Forcing a reboot...
echo.
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot

:: Package manager functions

:mfpkg-install
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo.
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
    echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt
)
goto %pkginst%

:mfpkg-uninstall
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo.
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
    echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt
)
goto %pkgrm%

:mfpkg-list
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo.
echo Installed packages:
echo.
dir /a:-d /b "%disk0p2%/%username%/%datadir%/packages/installed/"
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

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
echo ID 006: Virtual System Disk Mounter
echo [mfpkg] INFO: showing details for repository "%pkgrepo%" >> "%syslog%")
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Installers

:mfpkg-dl-001
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Downloading DevTools (pID 001)
echo.
echo Executing installer...
echo.
title MicroflashOS DevTools Installer
if exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools are already installed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installing DevTools...
echo.
echo DevTools commands [%mfosver%]>"%disk0p1%/%modsdir%/devtools.mfm"
if exist "%disk0p1%/%modsdir%/devtools.mfm" (
echo Installed package from %pkgrepo%> "%disk0p2%/%username%/%datadir%/packages/installed/001-DevTools"
if not exist "%disk0p2%/%username%/%datadir%/packages/installed/001-DevTools" (echo Failed to register package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed successfully!
echo Developer commands have been added to the help section.
echo.
echo The system will now reboot.
echo.
pause
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot
)
echo DevTools failed to install.
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-dl-002
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Downloading F145HBR34K (pID 002)
echo.
echo Executing installer...
echo.
title F145HBR34K Installer
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [mfpkg] ERROR: required dependency "DevTools" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %mfosver%
echo.
if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo Error: F145HBR34K already installed! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt) )

if not exist "%disk0p1%/cmd.mcm" (echo Sysmodule /%sysdir%/cmd.mcm not found. Jailbreak unsuccessful. && echo. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Validated /%sysdir%/cmd.mcm

if not exist "%disk0p1%/fsutils.mcm" (echo Sysmodule /%sysdir%/fsutils.mcm not found. Jailbreak unsuccessful. && echo. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Validated /%sysdir%/fsutils.mcm

if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo Sysmodule /%sysdir%/%modsdir%/devtools.mfm not found. Jailbreak unsuccessful. && echo. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Validated /%sysdir%/%modsdir%/devtools.mfm

echo.
echo Installing system module /%sysdir%/%modsdir%/flashbreak.mfm...
echo.
echo F145HBR34K jailbreak utility [%mfosver%]>"%disk0p1%/%modsdir%/flashbreak.mfm"

if exist "%disk0p1%/%modsdir%/devtools.mfm" (if exist "%disk0p1%/%modsdir%/flashbreak.mfm" (
echo Installed package from %pkgrepo%> "%disk0p2%/%username%/%datadir%/packages/installed/002-F145HBR34K"
if not exist "%disk0p2%/%username%/%datadir%/packages/installed/002-F145HBR34K" (echo Failed to register package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed successfully!
echo.
echo F145HBR34K commands have been added to the help section.
echo The system will now reboot.
echo.
pause
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot
) )
echo F145HBR34K failed to install.
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-dl-003
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Downloading WinFlash Compatibility Layer (pID 003)
echo.
echo Microsoft Windows Compatibility Layer for MicroflashOS >"%disk0p2%/%username%/%datadir%/packages/winflash.mfp"
if not exist "%disk0p2%/%username%/%datadir%/packages/winflash.mfp" (echo Failed to install package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed package from %pkgrepo%> "%disk0p2%/%username%/%datadir%/packages/installed/003-WinFlash"
if not exist "%disk0p2%/%username%/%datadir%/packages/installed/003-WinFlash" (echo Failed to register package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed /%usrdir%/%datadir%/packages/winflash.mfp
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-dl-004
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Downloading Nuke (pID 004)
echo.
echo Self destruct tool LMAO by Kenneth White >"%disk0p2%/%username%/%datadir%/packages/nuke.mfp"
if not exist "%disk0p2%/%username%/%datadir%/packages/nuke.mfp" (echo Failed to install package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed package from %pkgrepo%> "%disk0p2%/%username%/%datadir%/packages/installed/004-Nuke"
if not exist "%disk0p2%/%username%/%datadir%/packages/installed/004-Nuke" (echo Failed to register package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed /%usrdir%/%datadir%/packages/nuke.mfp
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-dl-005
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Downloading dumper (pID 005)
echo.
echo MicroflashOS Dumper by nsp >"%disk0p2%/%username%/%datadir%/packages/dumper.mfp"
if not exist "%disk0p2%/%username%/%datadir%/packages/dumper.mfp" (echo Failed to install package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed package from %pkgrepo%> "%disk0p2%/%username%/%datadir%/packages/installed/005-dumper"
if not exist "%disk0p2%/%username%/%datadir%/packages/installed/005-dumper" (echo Failed to register package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed /%usrdir%/%datadir%/packages/dumper.mfp
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt


:mfpkg-dl-006
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Downloading mountvirt (pID 006)
echo.
echo Virtual System Disk Mounter by GigaflashOS Devs >"%disk0p2%/%username%/%datadir%/packages/mountvirt.mfp"
if not exist "%disk0p2%/%username%/%datadir%/packages/mountvirt.mfp" (echo Failed to install package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed package from %pkgrepo%> "%disk0p2%/%username%/%datadir%/packages/installed/006-mountvirt"
if not exist "%disk0p2%/%username%/%datadir%/packages/installed/006-mountvirt" (echo Failed to register package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Installed /%usrdir%/%datadir%/packages/mountvirt.mfp
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Uninstallers

:mfpkg-rm-003
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling WinFlash Compatibility Layer (pID 003)
echo.
set "curdir=%cd%"
cd /d "%disk0p2%/%username%/%datadir%/packages/"
del winflash.mfp /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/winflash.mfp" (echo Failed to uninstall package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd /d "%disk0p2%/%username%/%datadir%/packages/installed"
del "003-WinFlash" /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/installed/003-WinFlash" (echo Failed to unregister package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Uninstalled /%usrdir%/%datadir%/packages/winflash.mfp
cd /d %curdir%
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-rm-004
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling Nuke (pID 004)
echo.
set "curdir=%cd%"
cd /d "%disk0p2%/%username%/%datadir%/packages/"
del nuke.mfp /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/nuke.mfp" (echo Failed to uninstall package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd /d "%disk0p2%/%username%/%datadir%/packages/installed"
del "004-Nuke" /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/installed/004-Nuke" (echo Failed to unregister package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Uninstalled /%usrdir%/%datadir%/packages/nuke.mfp
cd /d %curdir%
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-rm-005
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling dumper (pID 006)
echo.
set "curdir=%cd%"
cd /d "%disk0p2%/%username%/%datadir%/packages/"
del dumper.mfp /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/dumper.mfp" (echo Failed to uninstall package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd /d "%disk0p2%/%username%/%datadir%/packages/installed"
del "005-dumper" /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/installed/005-dumper" (echo Failed to unregister package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Uninstalled /%usrdir%/%datadir%/packages/dumper.mfp
cd /d %curdir%
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mfpkg-rm-006
echo.
if not exist "%disk0p1%/mfpkg.mcm" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Package Manager
echo Uninstalling mountvirt (pID 006)
echo.
set "curdir=%cd%"
cd /d "%disk0p2%/%username%/%datadir%/packages/"
del mountvirt.mfp /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/mountvirt.mfp" (echo Failed to uninstall package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
cd /d "%disk0p2%/%username%/%datadir%/packages/installed"
del "006-mountvirt" /f /q
if exist "%disk0p2%/%username%/%datadir%/packages/installed/006-mountvirt" (echo Failed to unregister package. && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
echo Uninstalled /%usrdir%/%datadir%/packages/mountvirt.mfp
cd /d %curdir%
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:: Custom packages

:nuke
echo.
if not exist "%disk0p2%/%username%/%datadir%/packages/nuke.mfp" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [nuke] ERROR: required dependency "DevTools" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title Nuke
echo Nuking system disk. ALL DATA WILL BE WIPED!
echo.
pause
echo.
if exist "%disk0p1%" (
rd "%disk0p1%" /s /q
echo System disk nuked.
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt
)
echo System disk not found.
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:dumper
echo.
if not exist "%disk0p2%/%username%/%datadir%/packages/dumper.mfp" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [dumper] ERROR: required dependency "DevTools" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo F145HBR3AK not found. Please install pID 002. && echo [dumper] ERROR: required dependency "F145HBR34K" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title MicroflashOS Dumper
echo MicroflashOS Dumper by nsp
echo.
if exist "%disk0p1%" (
  echo System disk mounted!
  echo.
  echo Dumping current MicroflashOS system disk to %~p0dump
  echo.
  xcopy "%disk0%" "%~p0dump\" /w /e /f
  echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt
) 
echo Could not find system disk. System may be corrupt!
echo.
echo Please enter recovery mode to repair your system.
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:winflash
echo.
if not exist "%disk0p2%/%username%/%datadir%/packages/winflash.mfp" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title WinFlash
cls && echo.
echo Type EXIT and press Enter to return to MicroflashOS.
echo.
cmd.exe
echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt

:mountvirt
echo.
if not exist "%disk0p2%/%username%/%datadir%/packages/mountvirt.mfp" (echo Invalid command. && echo [cmd] ERROR: no command exists >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/%modsdir%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [mountvirt] ERROR: required dependency "DevTools" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
if not exist "%disk0p1%/%modsdir%/flashbreak.mfm" (echo F145HBR3AK not found. Please install pID 002. && echo [mountvirt] ERROR: required dependency "F145HBR34K" is missing! >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
title Virtual System Disk Mounter
echo Virtual system disks must be placed in the same directory as the Batch file.
echo Looking in: %~p0
echo.
echo NOTE: Don't fill in the blank with blanks!
echo.
set /p "sysvirt=Name of system disk: "
echo.
if not exist "%~p0%sysvirt%" (echo System disk not found! && echo [cmd] INFO: command execution complete >> "%syslog%" && echo [cmd] INFO: returning to prompt >> "%syslog%" && goto prompt)
set "disk0label=%sysvirt%"
echo Mounted virtual disk! Rebooting...
echo.
pause
echo [cmd] INFO: rebooting... >> "%syslog%" && goto reboot


