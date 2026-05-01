::  Source code of MicroflashOS
::  A "fantasy operating system" made by KNBnoob1!
::  Website: https://knbn1.github.io

@echo off

setlocal enabledelayedexpansion

:: Define some version strings

set "mfosver=2026.05.01"
set "fbver=5.0"
set "pkgrepo=GigaflashOS Unified Repository [Revision 1]"

:: Define default directories

set "sysdir=mfos"
set "modsdir=extra-mods"
set "userdata=userdata"
set "usrsysdata=mfosdata"

:: Boot process stage 0 - Bootloader

:reboot
cd /d "%~dp0"
title MicroflashOS Bootloader

:: System disk stuffs

set "disk0label=MicroflashOS"

set "disk0=%~dp0%disk0label%"
set "disk0p1=%disk0%/%sysdir%"
set "disk0p2=%disk0%/%userdata%"

:: Special directories

set "usrdir=%disk0p2%/%username%"
set "toggles=%usrdir%/%usrsysdata%/toggles"
set "devices=%disk0p1%/devices"
set "usrmods=%disk0p1%/%modsdir%"
set "pkgdir=%usrdir%/%usrsysdata%/packages"
set "pkgmeta=%pkgdir%/installed"

:: Startup parameters

if exist "%toggles%/echoon" (@echo on)
if not exist "%toggles%/noclear" (cls)
if not exist "%toggles%/nolog" (set "logfile=%~dp0mfos-log.txt") else (set "logfile=NUL")
if not exist "%toggles%/incognito" (set "history=%usrdir%/mfos-history.txt") else (set "history=NUL")

:: Start logging

echo. >>"%logfile%"
echo %time% %date% >>"%logfile%"
echo ========================================= >>"%logfile%"
echo [bootloader] INFO: to log or not to log, that is the question >>"%logfile%"
echo [bootloader] INFO: logging system initialized
echo [bootloader] INFO: log file: %logfile%

if exist "%toggles%/slowboot" (call :slowboot)

:: Transfer control to kernel

echo [bootloader] INFO: loading bundled kernel into memory... >>"%logfile%"
echo [kernel] INFO: hello world, my version is %mfosver% >>"%logfile%"
echo [kernel] INFO: terminating bootloader... done >>"%logfile%"
echo.

:: System disk check


title Finding system disk...
if exist "%disk0label%" (
    echo System disk "%disk0label%" mounted as /
    echo [kernel] INFO: system disk is "%disk0label%" mounted as / >>"%logfile%"
) else (
    echo Unable to mount system disk.
    echo [kernel] ERROR: system disk mount failure >>"%logfile%"
    goto bootfail
)

:: Version check

set /p oldver=<"%disk0label%/version.txt"
echo.
echo Checking version strings...
echo.
echo Bundled kernel: %mfosver%
echo Detected kernel: %oldver%
echo.
if "%oldver%" == "%mfosver%" (
    echo MicroflashOS is on the latest version.
    echo [kernel] INFO: version string valid >>"%logfile%"
) else (
    echo Version mismatch.
    echo [kernel] ERROR: expected "%mfosver%" but got "%oldver%" >>"%logfile%"
    goto bootfail
)

:: Boot process stage 1 - Initialize devices

:bootstageone

echo [kernel] INFO: begin boot process stage 1 >>"%logfile%"

echo.
title Initializing devices...
echo Initializing devices...
echo.

if not exist "%devices%" (cd /d "%disk0p1%" && md devices)
if not exist "%devices%/mem" (cd /d "%devices%" && md mem)

echo System disk - /%sysdir%/>"%devices%/disk0p1"
if not exist "%devices%/disk0p1" (call :devinitfail disk0p1)
echo init "disk0p1"
echo [kdevinit] INFO: system partition initialized >>"%logfile%"

echo Memory sector 1 - Core system>"%devices%/mem/memsect1"
if not exist "%devices%/mem/memsect1" (call :devinitfail memsect1)
echo init "memsect1"
echo [kdevinit] INFO: memory sector 1 initialized >>"%logfile%"

echo Memory sector 2 - Userspace>"%devices%/mem/memsect2"
if not exist "%devices%/mem/memsect2" (call :devinitfail memsect2)
echo init "memsect2"
echo [kdevinit] INFO: memory sector 2 initialized >>"%logfile%"

echo Memory sector 3 - Secret Block>"%devices%/mem/memsect3"
if not exist "%devices%/mem/memsect3" (call :devinitfail memsect3)
echo init "memsect3"
echo [kdevinit] INFO: memory sector 3 initialized >>"%logfile%"

echo Human Interface Devices>"%devices%/hids"
if not exist "%devices%/hids" (call :devinitfail hids)
echo init "hids"
echo [kdevinit] INFO: human interface devices initialized >>"%logfile%"

echo Auditory devices: headphones, speakers, microphones, etc.>"%devices%/audio"
if not exist "%devices%/audio" (call :devinitfail audio)
echo init "audio"
echo [kdevinit] INFO: audio subsystem initialized >>"%logfile%"

if exist "%toggles%/slowboot" (call :slowboot)

:: Boot process stage 2 - Load sysmodules

:bootstagetwo

echo [kernel] INFO: begin boot process stage 2 >>"%logfile%"

echo.
title Loading sysmodules...
echo Loading sysmodules...
echo.

:: Initialization of core sysmodules

if exist "%disk0p1%/kernel.mcm" (call :loadmodok /%sysdir%/kernel.mcm) else (call :loadmodfail /%sysdir%/kernel.mcm)

if exist "%disk0p1%/recovery.mcm" (call :loadmodok /%sysdir%/recovery.mcm) else (call :loadmodfail /%sysdir%/recovery.mcm)

if exist "%disk0p1%/core.mcm" (call :loadmodok /%sysdir%/core.mcm) else (call :loadmodfail /%sysdir%/core.mcm)

if exist "%disk0p1%/fsutils.mcm" (call :loadmodok /%sysdir%/fsutils.mcm) else (call :loadmodfail /%sysdir%/fsutils.mcm)

if exist "%disk0p1%/ltmem.mcm" (call :loadmodok /%sysdir%/ltmem.mcm) else (call :loadmodfail /%sysdir%/ltmem.mcm)

if exist "%disk0p1%/stmem.mcm" (call :loadmodok /%sysdir%/stmem.mcm) else (call :loadmodfail /%sysdir%/stmem.mcm)

if exist "%disk0p1%/cmd.mcm" (call :loadmodok /%sysdir%/cmd.mcm) else (call :loadmodfail /%sysdir%/cmd.mcm)

if exist "%disk0p1%/compact.mcm" (call :loadmodok /%sysdir%/compact.mcm) else (call :loadmodfail /%sysdir%/compact.mcm)

if exist "%disk0p1%/proctector.mcm" (call :loadmodok /%sysdir%/proctector.mcm) else (call :loadmodfail /%sysdir%/proctector.mcm)

if exist "%disk0p1%/mfpkg.mcm" (call :loadmodok /%sysdir%/mfpkg.mcm) else (call :loadmodfail /%sysdir%/mfpkg.mcm)


:: Initialization of non-critical sysmodules

if exist "%usrmods%/sensors.mfm" (call :loadmodok /%sysdir%/%modsdir%/sensors.mfm)
if exist "%usrmods%/audio.mfm" (call :loadmodok /%sysdir%/%modsdir%/audio.mfm)
if exist "%usrmods%/graphics.mfm" (call :loadmodok /%sysdir%/%modsdir%/graphics.mfm)
if exist "%usrmods%/devtools.mfm" (call :loadmodok /%sysdir%/%modsdir%/devtools.mfm)

if exist "%toggles%/slowboot" (call :slowboot)

:: F145HBR34K stage 2 patcher

:bootstagetwo-fbpatch

if exist "%usrmods%/devtools.mfm" (
    if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (
    title Hello F145HBR34K!
    echo.
    echo Loading F145HBR34K...
    echo [fb-s2init] INFO: loading jailbreak... >>"%logfile%"
    echo.
    if not exist "%usrmods%/devtools.mfm" (
        echo DevTools not found.
        echo.
        echo F145HBR34K could not be loaded.
        echo [fb-s2init] ERROR: failed to load /%sysdir%/%modsdir%/devtools.mfm
    ) else (
        echo [fb-s2init] INFO: loading sysmodule patches... >>"%logfile%"

        if not exist "%disk0p1%/cmd.mcm" (call :fbpatchfail /%sysdir%/cmd.mcm)
        echo Patching /%sysdir%/cmd.mcm
        echo Command line [%mfosver%] [FLASHBROKEN]>"%disk0p1%/cmd.mcm"
        echo [fb-s2init] INFO: patched /%sysdir%/cmd.mcm >>"%logfile%"

        if not exist "%disk0p1%/fsutils.mcm" (call :fbpatchfail /%sysdir%/fsutils.mcm)
        echo Patching /%sysdir%/fsutils.mcm
        echo File system read/write utilities [%mfosver%] [FLASHBROKEN]>"%disk0p1%/fsutils.mcm"
        echo [fb-s2init] INFO: patched /%sysdir%/fsutils.mcm >>"%logfile%"

        if not exist "%disk0p1%/proctector.mcm" (call :fbpatchfail /%sysdir%/proctector.mcm)
        echo Patching /%sysdir%/proctector.mcm
        echo MicroflashOS Protector [%mfosver%] [FLASHBROKEN]>"%disk0p1%/proctector.mcm"
        echo [fb-s2init] INFO: patched /%sysdir%/proctector.mcm >>"%logfile%"

        if not exist "%usrmods%/devtools.mfm" (call :fbpatchfail /%sysdir%/%modsdir%/devtools.mfm)
        echo Patching /%sysdir%/%modsdir%/devtools.mfm
        echo DevTools commands [%mfosver%] [FLASHBROKEN]>"%usrmods%/devtools.mfm"
        echo [fb-s2init] INFO: patched /%sysdir%/devtools.mcm >>"%logfile%"

        echo.
        echo All sysmodule patches complete.
        echo [fb-s2init] INFO: patches complete >>"%logfile%"
        echo.
        set "fbloaded=yessir"
        echo Resuming boot process...
        echo [fb-s2init] INFO: resuming boot process >>"%logfile%"
        if exist "%toggles%/slowboot" (call :slowboot)
        )
    )
)

:: Boot process stage 3 - Userdata partition

:bootstagethree

echo [kernel] INFO: begin boot process stage 3 >>"%logfile%"

title Checking userdata partition...

echo.
if exist "%disk0p2%" (
    echo Userdata partition - /%userdata%/>"%devices%/disk0p2"
    echo Userdata partition is /%userdata%/
    echo [kdevinit] INFO: userdata partition initialized >>"%logfile%"
)

:: Userdata generation

if not exist "%disk0p2%" (
    echo Userdata partition not found.
    echo [kdevinit] WARN: failed to initialize userdata partition >>"%logfile%"
    echo.
    echo Creating userdata partition...
    echo [kusrinit] INFO: creating userdata partition >>"%logfile%"
    cd /d "%disk0%"
    md "%userdata%"
    echo Userdata partition - /%userdata%/>"%devices%/disk0p2"
    echo.
    if not exist "%disk0p2%" (
        echo Userdata partition creation failed.
        echo [kusrinit] ERROR: userdata partition creation failed >>"%logfile%"
        call :pauseexit
    )
)

if not exist "%usrdir%" (
    echo Userdata for user %username% not found.
    echo [kusrinit] WARN: no userdata found for user %username% >>"%logfile%"
    echo.
    echo Creating userdata for %username%...
    echo [kusrinit] INFO: creating userdata for user %username% >>"%logfile%"
    cd /d "%disk0p2%"
    md %username%
    echo.
    if not exist "%usrdir%/" (
        echo Userdata creation failed.
        echo [kusrinit] ERROR: userdata creation for user %username% failed >>"%logfile%"
        call :pauseexit
    )
)

if not exist "%usrdir%/%usrsysdata%" (
    echo Setting up userdata for %username%...
    echo [kusrinit] INFO: setting up userdata for %username% >>"%logfile%"
    cd /d "%usrdir%"
    md "%usrsysdata%"
    echo.
    if not exist "%usrdir%/%usrsysdata%/" (
        echo Userdata creation failed.
        echo [kusrinit] ERROR: userdata creation for user %username% failed >>"%logfile%"
        call :pauseexit
    )
)

if not exist "%toggles%/" (
    echo Creating toggle directory...
    echo [kusrinit] INFO: creating toggle directory for %username% >>"%logfile%"
    cd /d "%usrdir%/%usrsysdata%"
    md toggles
    echo.
    if not exist "%usrdir%/%usrsysdata%/toggles" (
        echo Toggle directory creation failed.
        echo [kusrinit] ERROR: toggle directory creation for user %username% failed >>"%logfile%"
        call :pauseexit
    )
)

if not exist "%pkgdir%/" (
    echo Creating package directory...
    echo [kusrinit] INFO: creating package directory for %username% >>"%logfile%"
    cd /d "%usrdir%/%usrsysdata%"
    md packages
    cd /d "%pkgdir%"
    md installed
    echo.
    if not exist "%pkgdir%/" if not exist "%pkgmeta%" (
        echo Package directory creation failed.
        echo [kusrinit] ERROR: package directory creation for user %username% failed >>"%logfile%"
        call :pauseexit
    )
)

if exist "%usrdir%" (
    echo Logging in as %username%
    echo [kusrinit] INFO: logging in as %username% >>"%logfile%"
)

:: Boot process complete!

:bootcomplete

title System files loaded!
echo.
echo MicroflashOS system files loaded.
echo [kernel] INFO: boot process completed >>"%logfile%"
cd /d "%usrdir%"

if exist "%toggles%/slowboot" (call :slowboot)

:: Welcome messages

if not exist "%toggles%/noclear" (cls)
echo.
if not exist "%disk0p1%/cmd.mcm" (
    echo [kernel] ERROR: could not load /%sysdir%/cmd.mcm >>"%logfile%"
    echo Command line could not be loaded. Please reinstall MicroflashOS.
    goto :pauseexit
)
echo Welcome to MicroflashOS.
echo [cmd] INFO: initialized prompt >>"%logfile%"
echo.
if "%fbloaded%"=="yessir" (echo F145HBR34K %fbver% && echo.)
if not exist "%usrdir%" (
    echo Userdata for user %username% not found.
    echo [kusrinit] ERROR: no userdata for user %username% >>"%logfile%"
    call :halt
    goto reboot
)
echo Logged in as %username%
echo [cmd] INFO: current user: %username% >>"%logfile%"
echo.
echo Type HELP for a list of commands.
echo Commands are not case-sensitive.

:: User prompt

:prompt

echo.

if not exist "%disk0p1%/cmd.mcm" (
    echo [kernel] ERROR: could not load /%sysdir%/cmd.mcm >>"%logfile%"
    echo Command line could not be loaded. Please reinstall MicroflashOS.
    goto :pauseexit
)

:: Titlebar stuff

set "titlebar=MicroflashOS %mfosver%"
title %titlebar%
if exist "%usrmods%/devtools.mfm" (title %titlebar% [DevTools])
if "%fbloaded%"=="yessir" (
    title %titlebar% [DevTools] [F145HBR34K %fbver%]
    echo [flashbreak] INFO: modified titlebar >>"%logfile%"
)
if exist "%toggles%/showdir" (
    echo [cmd] DEBUG: showing current directory >>"%logfile%"
    echo Current directory: %cd%
    echo.
)

:: Reset last run command variable

set "cmd="
set "binary="

:: Command whitelist

set "cmdlist=about help clock clear reboot recovery shutdown mkdir delete list cd home homewipe mfpkg devtools-uninstall mountsys modules toggles flashbreak-uninstall flashbreak-reboot nuke dumper winflash mountvirt getargs"

:: receive input from the user:

echo [cmd] INFO: load user prompt >>"%logfile%"
echo [cmd] INFO: waiting for user input >>"%logfile%"

set /p "cmd=%username%@%userdomain%: "

title Processing command...
echo [cmd] INFO: received command "%cmd%" >>"%logfile%"

:: analysis with "for"

for /f "tokens=1 delims= " %%a in ("%cmd%") do (
    set "binary=%%a"
)

echo [cmd] DEBUG: extracted main command "%binary%" >>"%logfile%"

:: compare %binary% with command list

echo [cmd] DEBUG: checking "%binary%" against whitelist >>"%logfile%"

set "found=nope"

for %%w in (%cmdlist%) do (
    if /i "%binary%"=="%%w" set "found=yep"
)
if "%found%"=="nope" (
    goto nocommand
)
:: use call command
echo.
call :%cmd%
goto prompt

:: Main help section

:help
if not exist "%disk0p1%/core.mcm" (goto nocommand)
call :cmdok
echo Utilities:
echo.
echo about: Show some system info
echo clock: Print current date and time
echo clear: Clear console output
echo.
echo Power options:
echo.
echo reboot: Reboot
echo recovery: Reboot to recovery mode
echo shutdown: Power off
echo.
echo [help] INFO: load help section for /%sysdir%/core.mcm >>"%logfile%"
if exist "%disk0p1%/fsutils.mcm" (
    echo File management:
    echo.
    echo mkdir [directory]: Create a directory
    echo delete [thing]: Delete a file/directory
    echo list: List available files/directories
    echo cd [dir or path]: Change to a directory
    echo home: Quickly return to user directory
    echo homewipe: Wipe all user directories
    echo [help] INFO: load help section for /%sysdir%/fsutils.mcm >>"%logfile%"
)
if exist "%usrmods%/devtools.mfm" (
    echo.
    echo Developer commands:
    echo.
    echo devtools-uninstall: DevTools uninstaller
    echo mountsys: Mount and modify system disk contents
    echo modules: List installed system modules
    echo toggles [create/delete/enabled/list] [toggle]: Manage system toggles
    echo [help] INFO: load help section for /%sysdir%/%modsdir%/devtools.mfm >>"%logfile%"
    if "%fbloaded%"=="yessir" (
        echo.
        echo F145HBR34K commands:
        echo.
        echo flashbreak-uninstall: Uninstall jailbreak
        echo flashbreak-reboot: Force reboot
        echo [help] INFO: load help section for /%sysdir%/%modsdir%/flashbreak.mfm >>"%logfile%"
    )
)
if exist "%disk0p1%/mfpkg.mcm" (
    echo.
    echo Package management:
    echo.
    echo mfpkg [install/uninstall/list/available] [package ID]: Package management
    echo.
    echo [help] INFO: load help section for /%sysdir%/mfpkg.mcm >>"%logfile%"
    echo Commands for installed packages:
    echo.
    if exist "%pkgdir%/nuke.mfp" (
        echo nuke: Nuke.
        echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/nuke.mfp >>"%logfile%"
    )
    if exist "%pkgdir%/dumper.mfp" (
        echo dumper: MicroflashOS firmware dumper by nsp
        echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/dumper.mfp >>"%logfile%"
    )
    if exist "%pkgdir%/winflash.mfp" (
        echo winflash: WinFlash compatibility layer for Windows software
        echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/winflash.mfp >>"%logfile%"
    )
    if exist "%pkgdir%/mountvirt.mfp" (
        echo mountvirt: Mount and boot to a system disk of your choice
        echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/mountvirt.mfp >>"%logfile%"
    )
)
goto execdone

:: About me

:about
if not exist "%disk0p1%/core.mcm" (goto nocommand)
call :cmdok
echo MicroflashOS version: %mfosver%
echo [about] INFO: mfos version is %mfosver% >>"%logfile%"
if exist "%usrmods%/devtools.mfm" (
    if "%fbloaded%"=="yessir" (
        echo F145HBR34K version: %fbver%
        echo [about] INFO: flashbreak version is %mfosver% >>"%logfile%"
    )
)
echo Mounted system disk: %disk0label%
echo [about] INFO: mounted system disk is %disk0label% >>"%logfile%"
echo.
echo Hostname: %userdomain%
echo [about] INFO: hostname is %userdomain% >>"%logfile%"
echo Processor: %processor_identifier% (%NUMBER_OF_PROCESSORS% cores)
echo [about] INFO: processor is %processor_identifier% with %NUMBER_OF_PROCESSORS% cores >>"%logfile%"
echo Architecture: %processor_architecture%
echo [about] INFO: architecture is %processor_architecture% >>"%logfile%"
echo.
echo Made by Kenneth White.
if "%fbloaded%"=="yessir" (
    echo Jailbreak by Team Centurion with help from Team Starburst
    echo Special thanks to nsp and the GigaflashOS devs.
)
goto execdone

:clock
if not exist "%disk0p1%/core.mcm" (goto nocommand)
call :cmdok
echo Time: %time%
echo Date: %date%
echo [clock] INFO: fetched time is %time% and date is %date% >>"%logfile%"
goto execdone

:: Clear the shell

:clear
if not exist "%disk0p1%/core.mcm" (goto nocommand)
call :cmdok
if not exist "%toggles%/noclear" (
    cls
    echo [cmd] INFO: user requested shell clearance >>"%logfile%"
)
goto execdone

:: Power options

:shutdown
if not exist "%disk0p1%/core.mcm" (goto nocommand)
call :cmdok
title Shutting down...
echo Shutting down...
echo [kernel] INFO: intercepted shutdown request >>"%logfile%"
exit

:: File manager

:mkdir
if not exist "%disk0p1%/fsutils.mcm" (goto nocommand)
call :cmdok
title File Manager
if "%1"=="" (
    echo Make what?
    echo [fsutils] ERROR: no directory provided >>"%logfile%"
    goto prompt
)
if exist "%1" (
    echo Directory already exists.
    echo [fsutils] ERROR: directory "%1" already exists >>"%logfile%"
    goto prompt
)
mkdir "%*"
if not exist "%1" (
    echo Failed to create directory "%1
    echo [fsutils] ERROR: failed to create directory "%1" >>"%logfile%"
    goto prompt
)
echo Created.
goto execdone

:delete
if not exist "%disk0p1%/fsutils.mcm" (goto nocommand)
call :cmdok
title File Manager
if "%1"=="" (echo Delete what? && goto prompt)
if not exist "%1" (
    echo File/directory does not exist.
    echo [fsutils] ERROR: specified file/directory "%1" does not exist >>"%logfile%"
    goto prompt
)
del "%1" /f /q
if not exist "%1" (
    echo Deleted file.
    echo [fsutils] INFO: deleted file "%1" >>"%logfile%"
    goto execdone
)
rd "%1" /s /q
if not exist "%1" (
    echo Deleted directory.
    echo [fsutils] INFO: deleted folder "%1" >>"%logfile%"
    goto execdone
)
echo.
echo Failed to delete file/directory "%1"
echo [fsutils] ERROR: failed to delete "%1" >>"%logfile%"
goto prompt

:list
if not exist "%disk0p1%/fsutils.mcm" (goto nocommand)
call :cmdok
title File Manager
echo [fsutils] INFO: listing objects in "%cd%" >>"%logfile%"
echo Directories:
echo.
dir /a:d /b
echo.
echo Files:
echo.
dir /a:-d /b
goto execdone

:cd
if not exist "%disk0p1%/fsutils.mcm" (goto nocommand)
call :cmdok
title File Manager
if "%1"=="" (
    echo Change to where?
    echo [fsutils] ERROR: no path provided >>"%logfile%"
    goto prompt
)
if not exist "%1" (
    echo Directory invalid.
    echo [fsutils] ERROR: invalid path >>"%logfile%"
    goto prompt
)
cd "%1"
echo Changed directory to "%1"
echo [fsutils] INFO: changed directory to "%1" >>"%logfile%"
echo [fsutils] DEBUG: current path is "%cd%" >>"%logfile%"
goto execdone

:: Userdata management

:home
if not exist "%disk0p1%/fsutils.mcm" (goto nocommand)
call :cmdok
title File Manager
if not exist "%usrdir%" (
    echo.
    echo Userdata for current user not found.
    echo [fsutils] ERROR: could not find userdata for current user >>"%logfile%"
    goto prompt
)
cd /d "%usrdir%"
echo Welcome home.
echo [fsutils] INFO: reverted current path to home directory >>"%logfile%"
echo [fsutils] DEBUG: current path is "%cd%" >>"%logfile%"
goto execdone

:homewipe
if not exist "%disk0p1%/fsutils.mcm" (goto nocommand)
call :cmdok
title File Manager
echo This command wipes userdata for all users, both logged out and logged in.
echo This effectively returns MicroflashOS to a "clean" state.
echo Back up any data before continuing.
echo.
call :userauth
echo.
if not exist "%disk0p2%" (
    echo Userdata partition not found.
    echo [fsutils] ERROR: could not load userdata partition >>"%logfile%"
    goto prompt
)
echo Found users:
dir /a:d /b "%disk0p2%"
echo.
echo Wiping userdata...
cd /d "%disk0%"
rd "%userdata%" /s /q
if exist "%disk0p2%" (
    echo.
    echo Userdata wipe failed.
    echo [fsutils] ERROR: userdata partition wipe failed >>"%logfile%"
    goto prompt
)
echo [fsutils] INFO: userdata wipe successful >>"%logfile%"
echo Wipe succeeded. The system will now reboot.
call :halt
goto reboot

:: DevTools

:devtools-uninstall
if not exist "%usrmods%/devtools.mfm" (goto nocommand)
call :cmdok
title MicroflashOS DevTools Uninstaller
echo Uninstalling DevTools...
echo.
call :userauth
echo.
echo [devtools] INFO: begin uninstallation >>"%logfile%"
cd /d "%usrmods%/"
del devtools.mfm /f
if exist "%usrmods%/devtools.mfm" (
    echo Failed to delete DevTools sysmodule.
    echo [devtools] ERROR: could not delete devtools sysmodule >>"%logfile%"
    goto prompt
)
echo [devtools] INFO: deleted sysmodule devtools.mfm >>"%logfile%"
cd /d "%pkgmeta%/"
del 001-DevTools /f
if exist "%pkgmeta%/001-DevTools" (goto unregfail)
echo [devtools] INFO: unregistered devtools package >>"%logfile%"
echo DevTools uninstalled.
echo You will not be able to use developer commands anymore.
echo [devtools] INFO: uninstallation complete >>"%logfile%"
echo.
echo The system will reboot.
call :halt
goto reboot

:mountsys
if not exist "%usrmods%/devtools.mfm" (goto nocommand)
call :cmdok
title MicroflashOS System Partition Mounter
if not exist "%disk0p1%/" (
    echo System partition not found.
    echo [mountsys] ERROR: system partition not found >>"%logfile%"
    goto prompt
)
echo Mounting disk0p1...
echo.
cd /d "%disk0p1%/"
echo [mountsys] INFO: mounted system partition >>"%logfile%"
echo The system partition has been made accessible to the current user.
echo.
echo Modifying the system partition directly may break your device.
echo Use with caution.
goto execdone

:modules
if not exist "%usrmods%/devtools.mfm" (goto nocommand)
call :cmdok
echo [modules] INFO: listing installed sysmodules... >>"%logfile%"
echo Critical sysmodules:
echo.
dir /a:-d /b "%disk0p1%/"
echo.
echo Additional sysmodules:
echo.
dir /a:-d /b "%usrmods%/"
goto execdone

:toggles
if not exist "%usrmods%/devtools.mfm" (goto nocommand)
call :cmdok
if "%1"=="" (
    echo [create/delete/enabled/list]
    echo [toggle-manager] ERROR: no option selected >>"%logfile%"
    goto prompt
)
if "%1"=="create" (
    if "%2"=="" (
        echo Please enter a toggle name.
        echo [toggle-manager] ERROR: no toggle specified >>"%logfile%"
        goto prompt
    )
    echo "%2">"%toggles%/%2"
    if not exist "%toggles%/%2" (
        echo Failed to write toggle.
        echo [toggle-manager] ERROR: could not write toggle "%2" >>"%logfile%"
        echo.
        goto prompt
    )
    echo Toggle written.
    echo [toggle-manager] INFO: written toggle "%2" >>"%logfile%"
    goto execdone
)
if "%1"=="delete" (
    if "%2"=="" (
        echo Please enter a toggle name.
        echo [toggle-manager] ERROR: no toggle specified >>"%logfile%"
        goto prompt
    )
    if not exist "%toggles%/%2" (
        echo Toggle does not exist.
        echo [toggle-manager] ERROR: toggle "%2" nonexistent >>"%logfile%"
        goto prompt
    )
    del "%toggles%/%2" /f /q
    if exist "%toggles%/%2" (
        echo Failed to delete toggle.
        echo [toggle-manager] ERROR: could not delete toggle "%2" >>"%logfile%"
        goto prompt
    )
    echo Toggle deleted.
    echo [toggle-manager] INFO: deleted toggle "%2" >>"%logfile%"
    goto execdone
)
if "%1"=="enabled" (
    echo Enabled toggles:
    echo [toggle-manager] INFO: listing enabled toggles... >>"%logfile%"
    echo.
    dir /a:-d /b "%toggles%/"
    goto execdone
)
if "%1"=="list" (
    echo Toggles in MicroflashOS as of this version [%mfosver%]:
    echo [toggle-manager] INFO: listing available toggles... >>"%logfile%"
    echo.
    echo Tweaks:
    echo.
    echo showdir: Shows current directory in command line before prompt
    echo incognito: Disables writing to the command history file
    echo allowdisabled: Allow using disabled commands
    echo.
    echo Debugging tools:
    echo.
    echo slowboot: Add pauses during boot sequence
    echo echoon: Disables echo OFF so command that generated shell output is shown
    echo noclear: Disable clearing shell output (this also affects the "clear" command
    echo nolog: Disables system logging functions within MicroflashOS
    goto execdone
)
echo Invalid arguments.
echo [toggle-manager] ERROR: invalid arguments >>"%logfile%"
goto prompt

:: Jailbreak

:flashbreak-uninstall
if not exist "%usrmods%/flashbreak.mfm" (goto nocommand)
call :cmdok
if not exist "%usrmods%/devtools.mfm" (call :nodev)
echo F145HBR34K Uninstaller
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %mfosver%
echo.
echo Uninstalling jailbreak...
echo.
call :userauth
echo.
cd /d "%usrmods%"
del flashbreak.mfm /f /q
if exist "%usrmods%/flashbreak.mfm" (
    echo Failed to delete F145HBR34K sysmodule.
    echo [flashbreak] ERROR: could not delete flashbreak sysmodule >>"%logfile%"
    goto prompt
)
echo [flashbreak] INFO: deleted sysmodule flashbreak.mfm >>"%logfile%"
cd /d "%pkgmeta%"
del 002-F145HBR34K /f /q
if exist "%pkgmeta%/002-F145HBR34K" (goto unregfail)
echo.
echo Jailbreak uninstalled.
echo All F145HBR34K commands will be invalidated.
echo [flashbreak] INFO: uninstallation complete >>"%logfile%"
echo.
echo The system will reboot.
call :halt
goto reboot

:flashbreak-reboot
if not exist "%usrmods%/flashbreak.mfm" (goto nocommand)
call :cmdok
echo Forcing a reboot...
echo.
goto reboot

:: Package manager functions

:mfpkg
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
call :cmdok
title MicroflashOS Package Manager

if "%1"=="list" (
    echo Installed packages:
    echo.
    dir /a:-d /b "%pkgmeta%/"
    echo [mfpkg] INFO: listed installed packages >>"%logfile%"
    goto execdone
)

if "%1"=="available" (
    echo Repository: %pkgrepo%
    if "%pkgrepo%" == "GigaflashOS Unified Repository [Revision 1]" (
    echo.
    echo ID 001: MicroflashOS DevTools
    echo ID 002: F145HBR34K jailbreak
    echo ID 003: WinFlash Compatibility Layer
    echo ID 004: nuke
    echo ID 005: MicroflashOS Dumper
    echo ID 006: Virtual System Disk Mounter
    echo [mfpkg] INFO: showing details for repository "%pkgrepo%" >>"%logfile%")
    goto execdone
)

if "%1"=="install" (
    if "%2"=="" (
        echo No package ID specified.
        echo [mfpkg] ERROR: no package ID specified >>"%logfile%"
        goto prompt
    )
    set "pkgtarget=%2"
    set "pkgcmd=mfpkg-dl-!pkgtarget!"
    title Finding package...
    set "pkgfound=false"
    for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
        if /i "%%A"=="!pkgcmd!" set "pkgfound=true"
    )
    if "!pkgfound!"=="false" (
        echo Package ID is invalid.
        echo [mfpkg] ERROR: installation pID invalid >>"%logfile%"
        goto prompt
    )
    set "pkgfound="
    goto !pkgcmd!
)

if "%1"=="uninstall" (
    if "%2"=="" (
        echo No package ID specified.
        echo [mfpkg] ERROR: no package ID specified >>"%logfile%"
        goto prompt
    )
    set "pkgtarget=%2"
    set "pkgcmd=mfpkg-rm-!pkgtarget!"
    title Finding package...
    set "pkgfound=false"
    for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
        if /i "%%A"=="!pkgcmd!" set "pkgfound=true"
    )
    if "!pkgfound!"=="false" (
        echo Package ID is invalid.
        echo [mfpkg] ERROR: installation pID invalid >>"%logfile%"
        goto prompt
    )
    set "pkgfound="
    goto !pkgcmd!
)
echo Invalid arguments.
echo [mfpkg] ERROR: invalid arguments >>"%logfile%"
goto prompt

:: Installers

:mfpkg-dl-001
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
echo Downloading DevTools (pID 001)
echo [mfpkg] INFO: downloading %pkgtarget% >>"%logfile%"
echo.
echo Executing installer...
echo.
title MicroflashOS DevTools Installer
echo Installing DevTools...
echo.
echo MicroflashOS Developer Tools [%mfosver%]>"%usrmods%/devtools.mfm"
if not exist "%usrmods%/devtools.mfm" (
    echo Failed to install sysmodule.
    echo [mfpkg] ERROR: failed to install /%sysdir%/%modsdir%/devtools.mfm
    goto prompt
)
echo %pkgrepo%>"%pkgmeta%/001-DevTools"
if not exist "%pkgmeta%/001-DevTools" (goto inregfail)
echo Installed successfully.
echo Developer commands have been added to the help section.
echo.
echo The system will now reboot.
call :halt
set "pkgtarget="
goto reboot

:mfpkg-dl-002
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
echo Downloading F145HBR34K (pID 002)
echo [mfpkg] INFO: downloading %pkgtarget% >>"%logfile%"
echo.
echo Executing installer...
echo.
title F145HBR34K Installer
if not exist "%usrmods%/devtools.mfm" (goto nodev)
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %mfosver%
echo.
echo Installing F145HBR34K sysmodule...
echo.
echo F145HBR34K jailbreak [%mfosver%]>"%usrmods%/flashbreak.mfm"
if not exist "%usrmods%/flashbreak.mfm" (
    echo Failed to install sysmodule.
    echo [mfpkg] ERROR: failed to install /%sysdir%/%modsdir%/flashbreak.mfm
    goto prompt
)
echo %pkgrepo%>"%pkgmeta%/002-F145HBR34K"
if not exist "%pkgmeta%/002-F145HBR34K" (goto inregfail)
echo Installed successfully.
echo.
echo F145HBR34K commands have been added to the help section.
echo The system will now reboot.
call :halt
set "pkgtarget="
goto reboot

:mfpkg-dl-003
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
echo Downloading WinFlash Compatibility Layer (pID 003)
echo [mfpkg] INFO: downloading %pkgtarget% >>"%logfile%"
echo.
echo Microsoft Windows Compatibility Layer for MicroflashOS>"%pkgdir%/winflash.mfp"
if not exist "%pkgdir%/winflash.mfp" (goto insfail)
echo %pkgrepo%>"%pkgmeta%/003-WinFlash"
if not exist "%pkgmeta%/003-WinFlash" (goto inregfail)
goto instdone

:mfpkg-dl-004
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
echo Downloading Nuke (pID 004)
echo [mfpkg] INFO: downloading %pkgtarget% >>"%logfile%"
echo.
echo MicroflashOS self-destruct tool by Kenneth White>"%pkgdir%/nuke.mfp"
if not exist "%pkgdir%/nuke.mfp" (goto insfail)
echo %pkgrepo%>"%pkgmeta%/004-Nuke"
if not exist "%pkgmeta%/004-Nuke" (goto inregfail)
goto instdone

:mfpkg-dl-005
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
echo Downloading dumper (pID 005)
echo [mfpkg] INFO: downloading %pkgtarget% >>"%logfile%"
echo.
echo MicroflashOS Dumper by nsp>"%pkgdir%/dumper.mfp"
if not exist "%pkgdir%/dumper.mfp" (goto insfail)
echo %pkgrepo%>"%pkgmeta%/005-dumper"
if not exist "%pkgmeta%/005-dumper" (goto inregfail)
goto instdone

:mfpkg-dl-006
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
echo Downloading mountvirt (pID 006)
echo [mfpkg] INFO: downloading %pkgtarget% >>"%logfile%"
echo.
echo Virtual System Disk Mounter by GigaflashOS Devs>"%pkgdir%/mountvirt.mfp"
if not exist "%pkgdir%/mountvirt.mfp" (goto insfail)
echo %pkgrepo%>"%pkgmeta%/006-mountvirt"
if not exist "%pkgmeta%/006-mountvirt" (goto inregfail)
goto instdone

:: Uninstallers

:mfpkg-rm-003
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
if not exist "%pkgmeta%/003-WinFlash" (call :nopkg)
echo Uninstalling WinFlash Compatibility Layer (pID 003)
echo.
set "curdir=%cd%"
cd /d "%pkgdir%/"
del winflash.mfp /f /q
if exist "%pkgdir%/winflash.mfp" (goto uninsfail)
cd /d "%pkgmeta%"
del "003-WinFlash" /f /q
if exist "%pkgmeta%/003-WinFlash" (goto unregfail)
goto uninstdone

:mfpkg-rm-004
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
if not exist "%pkgmeta%/004-Nuke" (call :nopkg)
echo Uninstalling Nuke (pID 004)
echo.
set "curdir=%cd%"
cd /d "%pkgdir%/"
del nuke.mfp /f /q
if exist "%pkgdir%/nuke.mfp" (goto uninsfail)
cd /d "%pkgmeta%"
del "004-Nuke" /f /q
if exist "%pkgmeta%/004-Nuke" (goto unregfail)
goto uninstdone

:mfpkg-rm-005
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
if not exist "%pkgmeta%/005-dumper" (call :nopkg)
echo Uninstalling dumper (pID 006)
echo.
set "curdir=%cd%"
cd /d "%pkgdir%/"
del dumper.mfp /f /q
if exist "%pkgdir%/dumper.mfp" (goto uninsfail)
cd /d "%pkgmeta%"
del "005-dumper" /f /q
if exist "%pkgmeta%/005-dumper" (goto unregfail)
goto uninstdone

:mfpkg-rm-006
if not exist "%disk0p1%/mfpkg.mcm" (goto nocommand)
title MicroflashOS Package Manager
if not exist "%pkgmeta%/006-mountvirt" (call :nopkg)
echo Uninstalling mountvirt (pID 006)
echo.
set "curdir=%cd%"
cd /d "%pkgdir%/"
del mountvirt.mfp /f /q
if exist "%pkgdir%/mountvirt.mfp" (goto uninsfail)
cd /d "%pkgmeta%"
del "006-mountvirt" /f /q
if exist "%pkgmeta%/006-mountvirt" (goto unregfail)
goto uninstdone

:: Custom packages

:nuke
if not exist "%pkgdir%/nuke.mfp" (goto nocommand)
call :cmdok
if not exist "%usrmods%/devtools.mfm" (goto nodev)
title Nuke
echo Nuking system disk. ALL DATA WILL BE WIPED.
echo.
call :userauth
echo.
if exist "%disk0p1%" (
    rd "%disk0p1%" /s /q
    echo System disk nuked.
    goto execdone
)
echo System disk not found.
goto prompt

:dumper
if not exist "%pkgdir%/dumper.mfp" (goto nocommand)
call :cmdok
if not exist "%usrmods%/devtools.mfm" (goto nodev)
if "%fbloaded%" NEQ "yessir" (goto nofb)
title MicroflashOS Dumper
echo MicroflashOS Dumper by nsp
echo.
if exist "%disk0p1%" (
  echo System disk mounted.
  echo.
  echo Dumping current MicroflashOS system disk to %~dp0dump
  echo.
  xcopy "%disk0%" "%~dp0dump\" /w /e /f
  goto execdone
) 
echo Could not find system disk. System may be corrupt.
echo.
echo Please enter recovery mode to repair your system.
goto prompt

:winflash
if not exist "%pkgdir%/winflash.mfp" (goto nocommand)
call :cmdok
title WinFlash
cls
echo Type EXIT and press Enter to return to MicroflashOS.
echo.
echo [winflash] INFO: loading cmd.exe >>"%logfile%"
cmd.exe
echo [winflash] INFO: welcome back to mfos >>"%logfile%"
goto execdone

:mountvirt
if not exist "%pkgdir%/mountvirt.mfp" (goto nocommand)
call :cmdok
if not exist "%usrmods%/devtools.mfm" (goto nodev)
if "%fbloaded%" NEQ "yessir" (goto nofb)
title Virtual System Disk Mounter
echo Virtual system disks must be placed in the same directory as the Batch file.
echo Looking in: %~dp0
echo.
set /p "sysvirt=Name of system disk: "
echo.
if "%sysvirt%"=="" (
    echo Please enter a valid system disk name.
    goto prompt
)
if not exist "%~dp0%sysvirt%" (
    echo System disk not found.
    goto prompt
)
set "disk0label=%sysvirt%"
echo Mounted virtual disk. Rebooting...
call :halt
goto reboot

:: Debugging commands

:getargs
call :cmdok
echo showing maximum 3
echo.
echo raw: "%*"
echo.
echo arg1: "%1"
echo arg2: "%2"
echo arg3: "%3"
goto execdone



:: MicroflashOS Recovery

:recovery
cls
cd /d "%~dp0"
title MicroflashOS Recovery
echo.
echo Installing MicroflashOS.
call :halt

:: System disk creation

if not exist "%~dp0%disk0label%" (md "%disk0label%")
if not exist "%~dp0%disk0label%" (
    echo.
    echo Failed to format system disk.
    call :pauseexit
)
echo.
echo System disk "%disk0label%" mounted as /
cd /d "%~dp0%disk0label%"
if exist %sysdir% (rd %sysdir% /s /q)
if not exist %sysdir% (md %sysdir%)
if not exist %sysdir% (
    echo.
    echo Failed to create operating system data directory.
    call :pauseexit
)

:: Core sysmodule installation

echo.
echo Installing core sysmodules...
echo.

echo Long-term memory [%mfosver%]>"%disk0p1%/ltmem.mcm"
if not exist "%disk0p1%/ltmem.mcm" (call :modinstfail /%sysdir%/ltmem.mcm)
echo Installed /%sysdir%/ltmem.mcm

echo Short-term memory [%mfosver%]>"%disk0p1%/stmem.mcm"
if not exist "%disk0p1%/stmem.mcm" (call :modinstfail /%sysdir%/stmem.mcm)
echo Installed /%sysdir%/stmem.mcm

echo Core MicroflashOS commands [%mfosver%]>"%disk0p1%/core.mcm"
if not exist "%disk0p1%/core.mcm" (call :modinstfail /%sysdir%/core.mcm)
echo Installed /%sysdir%/core.mcm

echo File system read/write utilities [%mfosver%]>"%disk0p1%/fsutils.mcm"
if not exist "%disk0p1%/fsutils.mcm" (call :modinstfail /%sysdir%/fsutils.mcm)
echo Installed /%sysdir%/fsutils.mcm

echo Command line [%mfosver%]>"%disk0p1%/cmd.mcm"
if not exist "%disk0p1%/cmd.mcm" (call :modinstfail /%sysdir%/cmd.mcm)
echo Installed /%sysdir%/cmd.mcm

echo MicroflashOS recovery [%mfosver%]>"%disk0p1%/recovery.mcm"
if not exist "%disk0p1%/recovery.mcm" (call :modinstfail /%sysdir%/recovery.mcm)
echo Installed /%sysdir%/recovery.mcm

echo MicroflashOS kernel.mcm [%mfosver%]>"%disk0p1%/kernel.mcm"
if not exist "%disk0p1%/kernel.mcm" (call :modinstfail /%sysdir%/kernel.mcm)
echo Installed /%sysdir%/kernel.mcm

echo MicroflashOS Ultracompacter [%mfosver%]>"%disk0p1%/compact.mcm"
if not exist "%disk0p1%/compact.mcm" (call :modinstfail /%sysdir%/compact.mcm)
echo Installed /%sysdir%/compact.mcm

echo MicroflashOS Protector [%mfosver%]>"%disk0p1%/proctector.mcm"
if not exist "%disk0p1%/proctector.mcm" (call :modinstfail /%sysdir%/proctector.mcm)
echo Installed /%sysdir%/proctector.mcm

echo MicroflashOS Package Manager [%mfosver%]>"%disk0p1%/mfpkg.mcm"
if not exist "%disk0p1%/mfpkg.mcm" (call :modinstfail /%sysdir%/mfpkg.mcm)
echo Installed /%sysdir%/mfpkg.mcm

:: Extmods installation

echo.
echo Installing additional sysmodules...
echo.

if not exist "%usrmods%" (md "%usrmods%")
cd /d "%usrmods%"

echo Audio output [%mfosver%]>"%usrmods%/audio.mfm"
if not exist "%usrmods%/audio.mfm" (call :modinstfail /%sysdir%/%modsdir%/audio.mfm)
echo Installed /%sysdir%/%modsdir%/audio.mfm

echo Graphics subsystem [%mfosver%]>"%usrmods%/graphics.mfm"
if not exist "%usrmods%/graphics.mfm" (call :modinstfail /%sysdir%/%modsdir%/graphics.mfm)
echo Installed /%sysdir%/%modsdir%/graphics.mfm

echo All-in-one sensor package [%mfosver%]>"%usrmods%/sensors.mfm"
if not exist "%usrmods%/sensors.mfm" (call :modinstfail /%sysdir%/%modsdir%/sensors.mfm)
echo Installed /%sysdir%/%modsdir%/sensors.mfm

echo.
echo Registering MicroflashOS version...
echo.
cd /d "%~dp0%disk0label%"
echo %mfosver%>"version.txt"
if not exist "version.txt" (
    echo Failed to register MicroflashOS version.
    call :pauseexit
)

echo MicroflashOS installation complete.
call :halt
echo.
title Rebooting...
echo Rebooting...
goto reboot



:: Some consolidations

:: Proctector authorization

:userauth
echo [proctector] INFO: requesting user authorization >>"%logfile%"
set /p "confirmation=Type "CONFIRM" (case-sensitive) to confirm this action: "
if "%confirmation%" == "CONFIRM" (
    set "confirmation="
    echo [proctector] INFO: authorized >>"%logfile%"
    goto :eof
) else (
    echo.
    echo User authorization failed.
    echo [kernel] ERROR: user authorization failed >> "%logfile%"
    goto prompt
)

:: Command execution successful

:execdone
echo [cmd] INFO: command execution complete >> "%logfile%"
goto prompt

:cmdok
echo [cmd] INFO: command valid >>"%logfile%"
if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
goto :eof

:: Failed some dependency checks

:nocommand
echo.
echo Invalid command.
if not exist "%toggles%/incognito" (echo [invalid] "%cmd%" >>"%history%")
echo [cmd] ERROR: command "%cmd%" invalid >>"%logfile%"
goto prompt

:nodev
echo DevTools not found. Install pID 001.
echo [cmd] ERROR: required dependency "DevTools" is missing >>"%logfile%"
goto prompt

:nofb
echo F145HBR34K not found. Install pID 002.
echo [cmd] ERROR: required dependency "F145HBR34K" is missing >>"%logfile%"
goto prompt

:: Generic boot failure

:bootfail
echo.
title Startup Failure!
echo MicroflashOS startup failed. Entering recovery...
call :halt
echo [kernel] INFO: booting to recovery... >>"%logfile%"
echo [kernel] INFO: booting to recovery...
goto recovery

:: Recovery mode

:modinstfail
echo Failed to install sysmodule "%1"
goto :pauseexit

:: Package-related stuff

:nopkg
echo Package not installed.
goto prompt

:instdone
echo Installed package ID %pkgtarget%
echo [mfpkg] INFO: installed pID %pkgtarget% >>"%logfile%"
set "pkgtarget="
goto execdone

:uninstdone
echo Uninstalled package ID %pkgtarget%
echo [mfpkg] INFO: uninstalled pID %pkgtarget% >>"%logfile%"
cd /d %curdir%
set "pkgtarget="
goto execdone

:insfail
echo Failed to install package %pkgtarget%
echo [mfpkg] ERROR: failed to install pID %pkgtarget% >>"%logfile%"
set "pkgtarget="
goto prompt

:inregfail
echo Failed to register package %pkgtarget%
echo [mfpkg] ERROR: failed to register pID %pkgtarget% >>"%logfile%"
set "pkgtarget="
goto prompt

:uninsfail
echo Failed to uninstall package %pkgtarget%
echo [mfpkg] ERROR: failed to uninstall pID %pkgtarget% >>"%logfile%"
set "pkgtarget="
goto prompt

:unregfail
echo Failed to unregister package %pkgtarget%
echo [mfpkg] ERROR: failed to unregister pID %pkgtarget% >>"%logfile%"
set "pkgtarget="
goto prompt

:: Boot process

:devinitfail
echo [kdevinit] ERROR: failed to initialize "%1" >>"%logfile%"
echo Could not initialize device "%1"
goto pauseexit

:loadmodok
echo OK %1
echo [kmodsinit] INFO: loaded %1 >>"%logfile%"
goto :eof

:loadmodfail
echo FAIL %1
echo [kmodsinit] ERROR: failed to load %1 >>"%logfile%"
goto bootfail

:fbpatchfail
echo Sysmodule %1 not found. Jailbreak unsuccessful.
echo [fb-s2init] ERROR: failed to load %1 >>"%logfile%"
set fbloaded=nope
goto bootstagethree

:slowboot
echo.
echo Slowboot toggle tripped.
call :halt
echo [bootloader] DEBUG: slowboot toggle tripped >>"%logfile%"
goto :eof

:: Common pause and exit function

:pauseexit
call :halt
exit

:halt
echo.
pause
goto :eof
