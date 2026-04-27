::  Source code of MicroflashOS
::  A "fantasy operating system" made by KNBnoob1!
::  Website: https://knbn1.github.io

@echo off

:: Define some version strings

set "version=2026.04.28"
set "fbver=4.8"
set "pkgrepo=GigaflashOS Unified Repository [Revision 1]"

:: Define default directories

set "sysdir=mfos"
set "modsdir=extra-mods"
set "userdata=userdata"
set "usrsysdata=mfosdata"

:: Boot process stage 0 - Bootloader

:reboot
cd /d "%~p0"
title MicroflashOS Bootloader

:: System disk stuffs

set "disk0label=MicroflashOS"

set "disk0=%~p0%disk0label%"
set "disk0p1=%disk0%/%sysdir%"
set "disk0p2=%disk0%/%userdata%"

:: Special directories

set "usrdir=%disk0p2%/%username%"
set "toggles=%usrdir%/%usrsysdata%/toggles"
set "devices=%disk0p1%/devices"
set "usrmods=%disk0p1%/%modsdir%"

:: Startup parameters

if exist "%toggles%/echoon" (@echo on)
if not exist "%toggles%/noclear" (cls)
if not exist "%toggles%/nolog" (set "logfile=%~p0mfos-log.txt") else (set "logfile=NUL")
if not exist "%toggles%/incognito" (set "history=%usrdir%/mfos-history.txt") else (set "history=NUL")

:: Start logging

echo. >>"%logfile%"
echo %time% %date% >>"%logfile%"
echo =================================== >>"%logfile%"
echo [bootloader] INFO: to log or not to log, that is the question >>"%logfile%"
echo [bootloader] INFO: logging system initialized!
echo [bootloader] INFO: log file: %logfile%
echo.

if exist "%toggles%/slowboot" (echo Slowboot toggle is enabled. && pause && echo. && echo [bootloader] DEBUG: slowboot toggle enabled. >>"%logfile%" )

:: Transfer control to kernel

echo [bootloader] INFO: loading bundled kernel into memory... >>"%logfile%"
echo [kernel] INFO: hello world, my version is %version% >>"%logfile%"
echo [kernel] INFO: terminating bootloader... done! >>"%logfile%"

:: System disk check

title Finding system disk...
if exist "%disk0label%" (
echo System disk "%disk0label%" mounted as /
echo [kernel] INFO: system disk is "%disk0label%" mounted as / >>"%logfile%"
) else (
echo Unable to mount system disk!
echo [kernel] ERROR: system disk mount failure >>"%logfile%"
title Startup Failure!
echo [kernel] ERROR: startup faiiure! >>"%logfile%"
echo MicroflashOS startup failed. Entering recovery...
echo.
pause
echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )

:: Version check

if not exist "%toggles%/novercheck" (
echo.
echo Checking version strings...
set /p oldver=<"%disk0label%/version.txt"
echo.
echo Bundled kernel: %version%
echo Detected kernel: %oldver%
echo.
if "%oldver%" == "%version%" (echo MicroflashOS is on the latest version. && echo [kernel] INFO: version string valid! >>"%logfile%") else (
echo Version mismatch!
echo [kernel] ERROR: version mismatch! expected "%version%" but got "%oldver%" >>"%logfile%"
echo [kernel] INFO: forcing update >>"%logfile%"
title Startup Failure!
echo MicroflashOS startup failed. Entering recovery...
echo.
pause
echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
)

:: Boot process stage 1 - Initialize devices

echo.
title Initializing devices...
echo Initializing devices...
echo [kernel] INFO: begin boot process stage 1 >>"%logfile%"
echo.

if not exist "%devices%" (cd /d "%disk0p1%" && md devices)
if not exist "%devices%/mem" (cd /d "%devices%" && md mem)

echo System disk - /%sysdir%/>"%devices%/disk0p1"
if not exist "%devices%/disk0p1" (echo [kdevinit] ERROR: failed to initialize "disk0p1" >>"%logfile%" && echo Could not initialize device "disk0p1" && echo. && pause && echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
echo Initialized device "disk0p1"
echo [kdevinit] INFO: system partition initialized >>"%logfile%"

echo Memory sector 1 - Core system>"%devices%/mem/memsect1"
if not exist "%devices%/mem/memsect1" (echo [kdevinit] ERROR: failed to initialize "memsect1" >>"%logfile%" && echo Could not initialize device "memsect1" && echo. && pause && echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
echo Initialized device "memsect1"
echo [kdevinit] INFO: memory sector 1 initialized >>"%logfile%"

echo Memory sector 2 - Userspace>"%devices%/mem/memsect2"
if not exist "%devices%/mem/memsect2" (echo [kdevinit] ERROR: failed to initialize "memsect2" >>"%logfile%" && echo Could not initialize device "memsect2" && echo. && pause && echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
echo Initialized device "memsect2"
echo [kdevinit] INFO: memory sector 2 initialized >>"%logfile%"

echo Memory sector 3 - Secret Block>"%devices%/mem/memsect3"
if not exist "%devices%/mem/memsect3" (echo [kdevinit] ERROR: failed to initialize "memsect3" >>"%logfile%" && echo Could not initialize device "memsect3" && echo. && pause && echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
echo Initialized device "memsect3"
echo [kdevinit] INFO: memory sector 3 initialized >>"%logfile%"

echo Human Interface Devices>"%devices%/hids"
if not exist "%devices%/hids" (echo [kdevinit] ERROR: failed to initialize "hids" >>"%logfile%" && echo Could not initialize device "hids" && echo. && pause && echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
echo Initialized device "hids"
echo [kdevinit] INFO: human interface devices initialized >>"%logfile%"

echo Auditory devices: headphones, speakers, microphones, etc.>"%devices%/audio"
if not exist "%devices%/audio" (echo [kdevinit] ERROR: failed to initialize "audio" >>"%logfile%" && echo Could not initialize device "audio" && echo. && pause && echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery )
echo Initialized device "audio"
echo [kdevinit] INFO: audio subsystem initialized >>"%logfile%"

if exist "%toggles%/slowboot" (echo [kernel] DEBUG: slowboot toggle tripped >>"%logfile%" && echo. && pause)

:: Boot process stage 2 - Load sysmodules

title Loading sysmodules...
echo.
echo Loading sysmodules...
echo [kernel] INFO: begin boot process stage 2 >>"%logfile%"
echo.

:: Initialization of core sysmodules

if exist "%disk0p1%/kernel.mcm" (echo /%sysdir%/kernel.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/kernel.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/kernel.mcm
echo [kmodsinit] failed to load /%sysdir%/kernel.mcm
goto boot2fail)

if exist "%disk0p1%/recovery.mcm" (echo /%sysdir%/recovery.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/recovery.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/recovery.mcm
echo [kmodsinit] failed to load /%sysdir%/recovery.mcm
goto boot2fail)

if exist "%disk0p1%/core.mcm" (echo /%sysdir%/core.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/core.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/core.mcm
echo [kmodsinit] failed to load /%sysdir%/core.mcm
goto boot2fail)

if exist "%disk0p1%/fsutils.mcm" (echo /%sysdir%/fsutils.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/fsutils.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/fsutils.mcm
echo [kmodsinit] failed to load /%sysdir%/fsutils.mcm
goto boot2fail)

if exist "%disk0p1%/ltmem.mcm" (echo /%sysdir%/ltmem.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/ltmem.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/ltmem.mcm
echo [kmodsinit] failed to load /%sysdir%/ltmem.mcm
goto boot2fail)

if exist "%disk0p1%/stmem.mcm" (echo /%sysdir%/stmem.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/stmem.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/stmem.mcm
echo [kmodsinit] failed to load /%sysdir%/stmem.mcm
goto boot2fail)

if exist "%disk0p1%/cmd.mcm" (echo /%sysdir%/cmd.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/cmd.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/cmd.mcm
echo [kmodsinit] failed to load /%sysdir%/cmd.mcm
goto boot2fail)

if exist "%disk0p1%/compact.mcm" (echo /%sysdir%/compact.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/compact.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/compact.mcm
echo [kmodsinit] failed to load /%sysdir%/compact.mcm
goto boot2fail)

if exist "%disk0p1%/proctector.mcm" (echo /%sysdir%/proctector.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/proctector.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/proctector.mcm
echo [kmodsinit] failed to load /%sysdir%/proctector.mcm
goto boot2fail)

if exist "%disk0p1%/mfpkg.mcm" (echo /%sysdir%/mfpkg.mcm && echo [kmodsinit] INFO: load cormod /%sysdir%/mfpkg.mcm >>"%logfile%") else (
echo Could not load /%sysdir%/mfpkg.mcm
echo [kmodsinit] failed to load /%sysdir%/mfpkg.mcm
goto boot2fail)


:: Initialization of non-critical sysmodules

if exist "%usrmods%/sensors.mfm" (echo /%sysdir%/%modsdir%/sensors.mfm && echo [kmodsinit] INFO: load extmod /%sysdir%/%modsdir%/sensors.mfm >>"%logfile%")
if exist "%usrmods%/audio.mfm" (echo /%sysdir%/%modsdir%/audio.mfm && echo [kmodsinit] INFO: load extmod /%sysdir%/%modsdir%/audio.mfm >>"%logfile%")
if exist "%usrmods%/graphics.mfm" (echo /%sysdir%/%modsdir%/graphics.mfm && echo [kmodsinit] INFO: load extmod /%sysdir%/%modsdir%/graphics.mfm >>"%logfile%")
if exist "%usrmods%/devtools.mfm" (echo /%sysdir%/%modsdir%/devtools.mfm && echo [kmodsinit] INFO: load extmod /%sysdir%/%modsdir%/devtools.mfm >>"%logfile%")
if exist "%usrmods%/databases.mfm" (echo %sysdir%/%modsdir%/databases.mfm && echo [kmodsinit] INFO: load extmod /%sysdir%/%modsdir%/databases.mfm >>"%logfile%")

if exist "%toggles%/slowboot" (echo [kernel] DEBUG: slowboot toggle tripped >>"%logfile%" && echo. && pause)

:: Jailbreak loading process

if exist "%usrmods%/devtools.mfm" (if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (
  title Hello F145HBR34K!
  echo.
  echo Loading F145HBR34K...
  echo [fb-s2init] INFO: loading jailbreak... >>"%logfile%"
  echo.
  if not exist "%usrmods%/devtools.mfm" (echo DevTools not found! && echo. && echo F145HBR34K could not be loaded. && echo [fb-s2init] ERROR: failed to load %usrmods%/devtools.mfm, flashbreak could not be loaded. >>"%logfile%") else (
  echo [fb-s2init] INFO: loading sysmodule patches... >>"%logfile%"

  if not exist "%disk0p1%/cmd.mcm" (echo Sysmodule /%sysdir%/cmd.mcm not found. Jailbreak unsuccessful. && echo [fb-s2init] ERROR: failed to load %usrmods%/cmd.mfm, flashbreak could not be loaded. >>"%logfile%")
  echo Patching /%sysdir%/cmd.mcm
  echo Command line [%version%] [FLASHBROKEN]>"%disk0p1%/cmd.mcm"
  echo [fb-s2init] INFO: patched /%sysdir%/cmd.mcm >>"%logfile%"

  if not exist "%disk0p1%/fsutils.mcm" (echo Sysmodule /%sysdir%/fsutils.mcm not found. Jailbreak unsuccessful. && echo [fb-s2init] ERROR: failed to load %usrmods%/fsutils.mfm, flashbreak could not be loaded. >>"%logfile%")
  echo Patching /%sysdir%/fsutils.mcm
  echo File system read/write utilities [%version%] [FLASHBROKEN]>"%disk0p1%/fsutils.mcm"
  echo [fb-s2init] INFO: patched /%sysdir%/fsutils.mcm >>"%logfile%"

  if not exist "%disk0p1%/proctector.mcm" (echo Sysmodule /%sysdir%/proctector.mcm not found. Jailbreak unsuccessful. && echo [fb-s2init] ERROR: failed to load %usrmods%/proctector.mfm, flashbreak could not be loaded. >>"%logfile%")
  echo Patching /%sysdir%/proctector.mcm
  echo MicroflashOS Protector [%version%] [FLASHBROKEN]>"%disk0p1%/proctector.mcm"
  echo [fb-s2init] INFO: patched /%sysdir%/proctector.mcm >>"%logfile%"

  if not exist "%usrmods%/devtools.mfm" (echo Sysmodule /%sysdir%/%modsdir%/devtools.mfm not found. Jailbreak unsuccessful. && echo [fb-s2init] ERROR: failed to load %usrmods%/devtools.mfm, flashbreak could not be loaded. >>"%logfile%")
  echo Patching /%sysdir%/%modsdir%/devtools.mfm
  echo DevTools commands [%version%] [FLASHBROKEN]>"%usrmods%/devtools.mfm"
  echo [fb-s2init] INFO: patched /%sysdir%/devtools.mcm >>"%logfile%"

  echo.
  echo All sysmodule patches complete.
  echo [fb-s2init] INFO: patches completed with no issues! >>"%logfile%"
  echo.
  echo Resuming boot process...
  echo [fb-s2init] INFO: resuming boot process >>"%logfile%"
  if exist "%toggles%/slowboot" (pause)
  ) ) )

:: Boot process stage 3 - Userdata partition

title Checking userdata partition...
echo [kernel] INFO: begin boot process stage 3 >>"%logfile%"
echo.
if exist "%disk0p2%" (echo Userdata partition is /%userdata%/. && echo Userdata partition - /%userdata%/>"%devices%/disk0p2" && echo [kdevinit] INFO: userdata partition initialized >>"%logfile%")

:: Userdata generation

if not exist "%disk0p2%" (
echo Userdata partition not found!
echo [kdevinit] WARN: failed to initialize userdata partition >>"%logfile%"
echo.
echo Creating userdata partition...
echo [kusrinit] INFO: creating userdata partition >>"%logfile%"
cd /d "%disk0%" && md "%userdata%" && echo Userdata partition - /%userdata%/>"%devices%/disk0p2" && echo.
if not exist "%disk0p2%" (echo Userdata partition creation failed! && echo [kusrinit] ERROR: userdata partition creation failed! >>"%logfile%" && echo. && pause && exit)
)

if not exist "%usrdir%" (
echo Userdata for user %username% not found!
echo [kusrinit] WARN: no userdata found for user %username% >>"%logfile%"
echo.
echo Creating userdata for %username%...
echo [kusrinit] INFO: creating userdata for user %username% >>"%logfile%"
cd /d "%disk0p2%" && md %username% && echo.
if not exist "%usrdir%/" (echo Userdata creation failed! && echo [kusrinit] ERROR: userdata creation for user %username% failed! >>"%logfile%" && echo. && pause && exit)
)

if not exist "%usrdir%/%usrsysdata%" (
echo Setting up userdata for %username%...
echo [kusrinit] INFO: setting up userdata for %username% >>"%logfile%"
cd /d "%usrdir%" && md "%usrsysdata%" && echo.
if not exist "%usrdir%/%usrsysdata%/" (echo Userdata creation failed! && echo [kusrinit] ERROR: userdata creation for user %username% failed! >>"%logfile%" && echo. && pause && exit)
)

if not exist "%toggles%/" (
echo Creating configuration directory...
echo [kusrinit] INFO: creating configuration directory for %username% >>"%logfile%"
cd /d "%usrdir%/%usrsysdata%" && md toggles && echo.
if not exist "%usrdir%/%usrsysdata%/toggles" (echo Configuration directory creation failed! && echo [kusrinit] ERROR: configuration directory creation for user %username% failed! >>"%logfile%" && echo. && pause && exit)
)

if not exist "%usrdir%/%usrsysdata%/packages/" (
echo Creating package directory...
echo [kusrinit] INFO: creating package directory for %username% >>"%logfile%"
cd /d "%usrdir%/%usrsysdata%"
md packages && cd /d "%usrdir%/%usrsysdata%/packages" && md installed && echo.
if not exist "%usrdir%/%usrsysdata%/packages/" if not exist "%usrdir%/%usrsysdata%/packages/installed" (echo Package directory creation failed! && echo [kusrinit] ERROR: package directory creation for user %username% failed! >>"%logfile%" && echo. && pause && exit)
)

if exist "%usrdir%" (echo Logging in as %username% && echo [kusrinit] INFO: logging in as %username% >>"%logfile%")

:: Boot process complete!

title System files loaded!
echo.
echo MicroflashOS system files loaded!
echo [kernel] INFO: boot process completed! >>"%logfile%"
echo.
cd /d "%usrdir%"
if exist "%toggles%/slowboot" (pause)

:: Welcome messages

if not exist "%toggles%/noclear" (cls)
echo.
if not exist "%disk0p1%/cmd.mcm" (echo [kernel] ERROR: could not load /%sysdir%/cmd.mcm >>"%logfile%" && echo Command line could not be loaded. Please reinstall MicroflashOS. && echo. && pause && exit)
echo Welcome to MicroflashOS!
echo [cmd] INFO: initialized prompt >>"%logfile%"
echo.
if exist "%usrmods%/devtools.mfm" (if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (echo F145HBR34K %fbver% && echo.))
if not exist "%usrdir%" (
echo Userdata for user %username% not found!
echo [kusrinit] ERROR: no userdata for user %username%! >>"%logfile%"
echo. && pause && echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot)
echo Logged in as %username%
echo [cmd] INFO: current user: %username% >>"%logfile%"
echo.
echo Type HELP for a list of commands.
echo Commands are not case-sensitive.
goto prompt

:: MicroflashOS Recovery

:recovery
cls
cd /d "%~p0"
title MicroflashOS Recovery
echo.
echo Installing MicroflashOS.
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

echo Long-term memory [%version%]>"%disk0p1%/ltmem.mcm"
if not exist "%disk0p1%/ltmem.mcm" (echo Failed to install sysmodule "/%sysdir%/ltmem.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/ltmem.mcm

echo Short-term memory [%version%]>"%disk0p1%/stmem.mcm"
if not exist "%disk0p1%/stmem.mcm" (echo Failed to install sysmodule "/%sysdir%/stmem.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/stmem.mcm

echo Core MicroflashOS commands [%version%]>"%disk0p1%/core.mcm"
if not exist "%disk0p1%/core.mcm" (echo Failed to install sysmodule "/%sysdir%/core.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/core.mcm

echo File system read/write utilities [%version%]>"%disk0p1%/fsutils.mcm"
if not exist "%disk0p1%/fsutils.mcm" (echo Failed to install sysmodule "/%sysdir%/fsutils.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/fsutils.mcm

echo Command line [%version%]>"%disk0p1%/cmd.mcm"
if not exist "%disk0p1%/cmd.mcm" (echo Failed to install sysmodule "/%sysdir%/cmd.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/cmd.mcm

echo MicroflashOS recovery [%version%]>"%disk0p1%/recovery.mcm"
if not exist "%disk0p1%/recovery.mcm" (echo Failed to install sysmodule "/%sysdir%/recovery.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/recovery.mcm

echo MicroflashOS kernel.mcm [%version%]>"%disk0p1%/kernel.mcm"
if not exist "%disk0p1%/kernel.mcm" (echo Failed to install sysmodule "/%sysdir%/kernel.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/kernel.mcm

echo MicroflashOS Ultracompacter [%version%]>"%disk0p1%/compact.mcm"
if not exist "%disk0p1%/compact.mcm" (echo Failed to install sysmodule "/%sysdir%/compact.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/compact.mcm

echo MicroflashOS Protector [%version%]>"%disk0p1%/proctector.mcm"
if not exist "%disk0p1%/proctector.mcm" (echo Failed to install sysmodule "/%sysdir%/proctector.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/proctector.mcm

echo MicroflashOS Package Manager [%version%]>"%disk0p1%/mfpkg.mcm"
if not exist "%disk0p1%/mfpkg.mcm" (echo Failed to install sysmodule "/%sysdir%/mfpkg.mcm". && echo. && pause && exit)
echo Installed /%sysdir%/mfpkg.mcm

echo.
echo Installing additional sysmodules...
echo.

if not exist "%usrmods%" (md "%usrmods%")
cd /d "%usrmods%"

echo Audio output [%version%]>"%usrmods%/audio.mfm"
if not exist "%usrmods%/audio.mfm" (echo Failed to install sysmodule "/%sysdir%/%modsdir%/audio.mfm". && echo. && pause && exit)
echo Installed /%sysdir%/%modsdir%/audio.mfm

echo Graphics subsystem [%version%]>"%usrmods%/graphics.mfm"
if not exist "%usrmods%/graphics.mfm" (echo Failed to install sysmodule "/%sysdir%/%modsdir%/graphics.mfm". && echo. && pause && exit)
echo Installed /%sysdir%/%modsdir%/graphics.mfm

echo All-in-one sensor package [%version%]>"%usrmods%/sensors.mfm"
if not exist "%usrmods%/sensors.mfm" (echo Failed to install sysmodule "/%sysdir%/%modsdir%/sensors.mfm". && echo. && pause && exit)
echo Installed /%sysdir%/%modsdir%/sensors.mfm

echo.
echo Registering MicroflashOS version...
echo.
cd /d "%~p0%disk0label%"
echo %version%>"version.txt"
if not exist "version.txt" (echo Failed to register MicroflashOS version. && echo. && pause && exit)

echo MicroflashOS installation complete. && echo. && pause && echo.
title Rebooting...
echo Rebooting...
goto reboot

:: User prompt

:prompt

echo.
if not exist "%disk0p1%/cmd.mcm" (echo [kernel] ERROR: could not load /%sysdir%/cmd.mcm >>"%logfile%" && echo Command line could not be loaded. Please reinstall MicroflashOS. && echo. && pause && exit)

:: Titlebar stuff

set "titlebar=MicroflashOS %version%"
title %titlebar%
if exist "%usrmods%/devtools.mfm" (title %titlebar% [DevTools])
if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (title %titlebar% [DevTools] [F145HBR34K %fbver%] && echo [flashbreak] INFO: modified titlebar >>"%logfile%")
if exist "%toggles%/showdir" (echo [cmd] DEBUG: showing current directory >>"%logfile%" && echo Current directory: %cd% && echo.)

:: Reset last run command variable

set "cmd="
echo [cmd] INFO: load user prompt >>"%logfile%"
echo [cmd] INFO: waiting for user input >>"%logfile%"
set /p "cmd=%username%@%userdomain%: "

:: thanks Gemini!

title Processing command...
echo [cmd] INFO: received command "%cmd%" >>"%logfile%"
set "cmd_found=false"
for /f "tokens=1 delims=:" %%A in ('findstr /r "^:" "%~f0"') do (
    if /i "%%A"=="%cmd%" set "cmd_found=true"
)
if "%cmd_found%"=="false" (
    echo.
    echo Invalid command.
    if not exist "%toggles%/incognito" (echo [invalid] "%cmd%" >>"%history%")
    echo [cmd] ERROR: command "%cmd%" invalid >>"%logfile%"
    goto prompt
)
echo.
goto %cmd%

:: Main help section

:help
if not exist "%disk0p1%/core.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
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
echo [help] INFO: load help section for /%sysdir%/core.mcm >>"%logfile%"
if exist "%disk0p1%/fsutils.mcm" (
echo File management:
echo.
echo mkdir: Create a directory
:: echo mkfile: Create a file
echo del: Delete a file/directory
echo list: List available files/directories
echo cd: Change to a directory
echo home: Quickly change to user directory
echo homewipe: Wipe user directory
echo [help] INFO: load help section for /%sysdir%/fsutils.mcm >>"%logfile%"
)
if exist "%usrmods%/devtools.mfm" (
echo.
echo Developer commands:
echo.
echo devtools-uninstall: DevTools uninstaller
echo mountsys: Mount system disk to modify contents
echo modules: List installed system modules "sysmodules"
echo toggles-[create/delete/enabled/list]: Manage system "toggles"
echo [help] INFO: load help section for /%sysdir%/%modsdir%/devtools.mfm >>"%logfile%"
if exist  "%usrmods%/flashbreak.mfm" (
echo.
echo F145HBR34K commands:
echo.
echo flashbreak-uninstall: Uninstall jailbreak
echo flashbreak-reboot: Force reboot regardless of core.mcm presence
echo [help] INFO: load help section for /%sysdir%/%modsdir%/flashbreak.mfm >>"%logfile%"
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
echo [help] INFO: load help section for /%sysdir%/mfpkg.mcm >>"%logfile%"
echo Commands for installed packages:
echo.
if exist "%usrdir%/%usrsysdata%/packages/nuke.mfp" (echo nuke: Nuke. && echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/nuke.mfp >>"%logfile%")
if exist "%usrdir%/%usrsysdata%/packages/dumper.mfp" (echo dumper: MicroflashOS firmware dumper by nsp && echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/dumper.mfp >>"%logfile%")
if exist "%usrdir%/%usrsysdata%/packages/winflash.mfp" (echo winflash: WinFlash compatibility layer for Windows software && echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/winflash.mfp >>"%logfile%")
if exist "%usrdir%/%usrsysdata%/packages/mountvirt.mfp" (echo mountvirt: Mount and boot to a system disk of your choice && echo [mfpkg] INFO: found package /%userdata%/%username%/%usrsysdata%/packages/mountvirt.mfp >>"%logfile%")
)
goto execdone

:: About me

:about
if not exist "%disk0p1%/core.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
echo MicroflashOS version: %version%
echo [about] INFO: mfos version is %version% >>"%logfile%"
if exist "%usrmods%/devtools.mfm" (if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (echo F145HBR34K version: %fbver% && echo [about] INFO: flashbreak version is %version% >>"%logfile%") )
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
if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (
echo Jailbreak by Team Centurion with help from Team Starburst
echo Special thanks to nsp and the GigaflashOS devs! )
goto execdone

:clock
if not exist "%disk0p1%/core.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
echo Time: %time% && echo Date: %date%
echo [clock] INFO: fetched time is %time% and date is %date% >>"%logfile%"
goto execdone

:: Clear the shell

:clear
if not exist "%disk0p1%/core.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
if not exist "%toggles%/noclear" (cls && echo [cmd] INFO: user requested shell clearance >>"%logfile%")
goto execdone

:: Power options

:shutdown
if not exist "%disk0p1%/core.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title Shutting down...
echo Shutting down...
echo [kernel] INFO: intercepted shutdown request >>"%logfile%"
exit

:: File manager

:mkdir
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title File Manager
set /p "mkd=Directory to create: "
if exist "%mkd%" (echo. && echo Directory already exists! && echo [fsutils] ERROR: attempted to create directory "%mkd%" but directory with that name already exists! >>"%logfile%" && goto prompt)
md "%mkd%"
if not exist "%mkd%" (echo. && echo Directory creation failed! && echo [fsutils] ERROR: could not create directory "%mkd%" >>"%logfile%" && goto prompt)
echo.
echo Directory created.
echo [fsutils] INFO: created directory "%mkd%" >>"%logfile%"
goto execdone

:mkfile
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
if not exist "%toggles%/allowdisabled" (echo This command has been disabled. && echo [cmd] ERROR: command "%cmd%" has been disabled >>"%logfile%" && goto prompt)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title File Manager
set /p "mkf_name=File name: "
echo.
set /p "mkf_contents=File contents: "
echo.
echo %mkf_contents%>"%mkf_name%"
if not exist "%mkf_name%" (echo File creation failed! && echo [fsutils] ERROR: could not create file "%mkf_name%" >>"%logfile%" && goto prompt)
echo File created.
echo [fsutils] INFO: created file "%mkf_name%" >>"%logfile%"
goto execdone

:del
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title File Manager
set /p "del=File/directory to delete: "
if not exist "%del%" (echo. && echo File/directory does not exist. && echo [fsutils] ERROR: specified file/directory "%del%" does not exist! >>"%logfile%" && goto prompt)
del "%del%" /f /q
if not exist "%del%" (echo. && echo Deleted file! && echo [fsutils] INFO: deleted file "%del%" >>"%logfile%" && goto execdone)
rd "%del%" /s /q
if not exist "%del%" (echo. && echo Deleted directory! && echo [fsutils] INFO: deleted folder "%del%" >>"%logfile%" && goto execdone)
echo.
echo Failed to delete file/directory "%del%"!
echo [fsutils] ERROR: failed to delete "%del%" >>"%logfile%"
goto prompt

:list
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
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
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title File Manager
set /p "chdir=Name of directory to change to: "
echo.
if not exist "%chdir%" (echo Directory invalid! && echo [fsutils] ERROR: invalid directory >>"%logfile%" && goto prompt)
cd "%chdir%"
echo Changed directory to "%chdir%"
echo [fsutils] INFO: changed directory to "%chdir%" >>"%logfile%"
echo [fsutils] DEBUG: current path is "%cd%" >>"%logfile%"
goto execdone

:: Userdata management

:home
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title File Manager
if not exist "%usrdir%" (echo. && echo Userdata for current user not found. && echo [fsutils] ERROR: could not find userdata for current user! >>"%logfile%" && goto prompt)
cd /d "%usrdir%"
echo Welcome home!
echo [fsutils] INFO: reverted current path to home directory >>"%logfile%"
echo [fsutils] DEBUG: current path is "%cd%" >>"%logfile%"
goto execdone

:homewipe
if not exist "%disk0p1%/fsutils.mcm" (goto depcheckfail)
if not exist "%disk0p2%" (echo Userdata partition not found. && echo [fsutils] ERROR: could not load userdata partition! >>"%logfile%" && goto prompt)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title File Manager
echo This command wipes userdata for all users, both logged out and logged in.
echo This effectively returns MicroflashOS to a "clean" state.
echo Back up any data before continuing!
echo.
echo [proctector] INFO: requesting user authorization >>"%logfile%"
set /p "confirmation=Type "CONFIRM" (case-sensitive) to confirm this action: "
if "%confirmation%" == "CONFIRM" (
set "confirmation=" && echo [proctector] INFO: got user authorization >>"%logfile%"
echo.
echo Found users:
dir /a:d /b "%disk0p2%"
echo.
echo Wiping userdata...
cd /d "%disk0%" && rd "%userdata%" /s /q
if exist "%disk0p2%" (echo. && echo Userdata wipe failed! && echo [fsutils] ERROR: userdata partition wipe failed! >>"%logfile%" && goto prompt)
echo [fsutils] INFO: userdata wipe successful! >>"%logfile%"
echo Wipe succeeded. The system will now reboot.
echo.
pause
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot)
goto authfail

:: DevTools

:devtools-uninstall
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title MicroflashOS DevTools Uninstaller
echo Uninstalling DevTools...
echo.
echo [proctector] INFO: requesting user authorization >>"%logfile%"
set /p "confirmation=Type "CONFIRM" (case-sensitive) to confirm this action: "
if "%confirmation%" == "CONFIRM" (
set "confirmation=" && echo [proctector] INFO: got user authorization >>"%logfile%"
echo [devtools] INFO: begin uninstallation >>"%logfile%"
echo.
cd /d "%usrmods%/" && del devtools.mfm /f
if exist "%usrmods%/devtools.mfm" (echo Failed to delete DevTools sysmodule! && echo [devtools] ERROR: could not delete devtools sysmodule! >>"%logfile%" && goto prompt)
echo [devtools] INFO: deleted sysmodule devtools.mfm >>"%logfile%"
cd /d "%usrdir%/%usrsysdata%/packages/installed/" && del 001-DevTools /f
if exist "%usrdir%/%usrsysdata%/packages/installed/001-DevTools" (echo Failed to unregister package! && echo [devtools] ERROR: could not unregister package! >>"%logfile%" && goto prompt)
echo [devtools] INFO: unregistered devtools package >>"%logfile%"
echo DevTools uninstalled.
echo You will not be able to use developer commands anymore.
echo [devtools] INFO: uninstallation complete! >>"%logfile%"
echo.
echo The system will reboot.
echo.
pause
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot)
goto authfail

:mountsys
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title MicroflashOS System Partition Mounter
if not exist "%disk0p1%/" (echo System partition not found! && echo [mountsys] ERROR: system partition not found! >>"%logfile%" && goto prompt)
echo Mounting disk0p1...
echo.
cd /d "%disk0p1%/"
echo [mountsys] INFO: mounted system partition >>"%logfile%"
echo The system partition has been made accessible to the current user.
echo.
echo Modifying the system partition directly may break your device!
echo Use with caution!
goto execdone

:modules
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
echo [modules] INFO: listing installed sysmodules... >>"%logfile%"
echo Critical sysmodules:
echo.
dir /a:-d /b "%disk0p1%/"
echo.
echo Additional sysmodules:
echo.
dir /a:-d /b "%usrmods%/"
goto execdone

:toggles-create
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
set /p "cfgadd=Name of toggle: "
echo %cfgadd%>"%toggles%/%cfgadd%"
if not exist "%toggles%/%cfgadd%" (echo. && echo Failed to write toggle. && echo [toggle-manager] ERROR: could not write toggle %cfgadd% >>"%logfile%" && echo. && goto prompt)
echo.
echo Toggle written.
echo [toggle-manager] INFO: written toggle "%cfgadd%" >>"%logfile%"
goto execdone

:toggles-delete
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
if not exist "%toggles%/allowdisabled" (echo This command has been disabled. && echo [cmd] ERROR: command "%cmd%" has been disabled >>"%logfile%" && goto prompt)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
set /p "cfgdel=Toggle to delete: "
del "%toggles%/%cfgdel%" /f /q
if exist "%toggles%/%cfgdel%" (echo. && echo Failed to delete toggle. && echo [toggle-manager] ERROR: could not delete toggle %cfgdel% >>"%logfile%" && goto prompt)
echo.
echo Toggle deleted.
echo [toggle-manager] INFO: deleted toggle "%cfgdel%" >>"%logfile%"
goto execdone

:toggles-enabled
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
echo Enabled toggles:
echo [toggle-manager] INFO: listing enabled toggles... >>"%logfile%"
echo.
dir /a:-d /b "%toggles%/"
goto execdone

:toggles-list
if not exist "%usrmods%/devtools.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
echo Toggles in MicroflashOS as of this version [%version%]:
echo [toggle-manager] INFO: listing available toggles... >>"%logfile%"
echo.
echo Tweaks:
echo.
echo showdir: Shows current directory in command line before prompt
echo incognito: Disables writing to the command history file
echo allowdisabled: Allow using disabled commands
echo novercheck: Disable mandatory version check on boot
echo.
echo Debugging tools:
echo.
echo slowboot: Add pauses during boot sequence
echo echoon: Disables echo OFF so command that generated shell output is shown
echo noclear: Disable clearing shell output (this also affects the "clear" command
echo nolog: Disables system logging functions within MicroflashOS
goto execdone

:: Jailbreak

:flashbreak-uninstall
if not exist "%usrmods%/flashbreak.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
if not exist "%usrmods%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [flashbreak] ERROR: required dependency "DevTools" is missing! >>"%logfile%" && goto prompt)
echo F145HBR34K Uninstaller
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %version%
echo.
echo Uninstalling jailbreak...
echo.
echo [proctector] INFO: requesting user authorization >>"%logfile%"
set /p "confirmation=Type "CONFIRM" (case-sensitive) to confirm this action: "
if "%confirmation%" == "CONFIRM" (
set "confirmation=" && echo [proctector] INFO: got user authorization >>"%logfile%"
echo.
cd /d "%usrmods%" && del flashbreak.mfm /f /q
if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (echo Failed to delete F145HBR34K sysmodule! && echo [flashbreak] ERROR: could not delete flashbreak sysmodule! >>"%logfile%" && goto prompt)
echo [flashbreak] INFO: deleted sysmodule flashbreak.mfm >>"%logfile%"
cd /d "%usrdir%/%usrsysdata%/packages/installed" && del 002-F145HBR34K /f /q
if exist "%usrdir%/%usrsysdata%/packages/installed/002-F145HBR34K" (echo Failed to unregister package! && echo [flashbreak] ERROR: could not unregister package! >>"%logfile%" && goto prompt)
echo.
echo Jailbreak uninstalled.
echo All F145HBR34K commands will be invalidated.
echo [flashbreak] INFO: uninstallation complete! >>"%logfile%"
echo.
echo The system will reboot.
echo.
pause
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot)
goto authfail

:flashbreak-reboot
if not exist "%usrmods%/flashbreak.mfm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
echo Forcing a reboot...
echo.
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot

:: Package manager functions

:mfpkg-install
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title MicroflashOS Package Manager
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
    echo [mfpkg] ERROR: installation pID invalid! >>"%logfile%" && goto prompt
)
goto %pkginst%

:mfpkg-uninstall
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title MicroflashOS Package Manager
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
    echo [mfpkg] ERROR: package "%pkgrm%" unavailable >>"%logfile%" && goto prompt
)
goto %pkgrm%

:mfpkg-list
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title MicroflashOS Package Manager
echo Installed packages:
echo.
dir /a:-d /b "%usrdir%/%usrsysdata%/packages/installed/"
echo [mfpkg] INFO: listed installed packages >>"%logfile%"
goto execdone

:mfpkg-repo-available
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title MicroflashOS Package Manager
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

:: Installers

:mfpkg-dl-001
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
echo Downloading DevTools (pID 001)
echo.
echo Executing installer...
echo.
title MicroflashOS DevTools Installer
if exist "%usrmods%/devtools.mfm" (echo DevTools are already installed! && goto execdone)
echo Installing DevTools...
echo.
echo DevTools commands [%version%]>"%usrmods%/devtools.mfm"
if exist "%usrmods%/devtools.mfm" (
echo Installed package from %pkgrepo%>"%usrdir%/%usrsysdata%/packages/installed/001-DevTools"
if not exist "%usrdir%/%usrsysdata%/packages/installed/001-DevTools" (echo Failed to register package. && goto prompt)
echo Installed successfully!
echo Developer commands have been added to the help section.
echo.
echo The system will now reboot.
echo.
pause
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot
)
echo DevTools failed to install.
goto execdone

:mfpkg-dl-002
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
echo Downloading F145HBR34K (pID 002)
echo.
echo Executing installer...
echo.
title F145HBR34K Installer
if not exist "%usrmods%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [mfpkg] ERROR: required dependency "DevTools" is missing! >>"%logfile%" && goto prompt)
echo F145HBR34K version: %fbver%
echo MicroflashOS version: %version%
echo.
if exist "%usrmods%/devtools.mfm" (if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (echo Error: F145HBR34K already installed! && goto prompt) )

if not exist "%disk0p1%/cmd.mcm" (echo Sysmodule /%sysdir%/cmd.mcm not found. Jailbreak unsuccessful. && goto prompt)
echo Validated /%sysdir%/cmd.mcm

if not exist "%disk0p1%/fsutils.mcm" (echo Sysmodule /%sysdir%/fsutils.mcm not found. Jailbreak unsuccessful. && goto prompt)
echo Validated /%sysdir%/fsutils.mcm

if not exist "%usrmods%/devtools.mfm" (echo Sysmodule /%sysdir%/%modsdir%/devtools.mfm not found. Jailbreak unsuccessful. && goto prompt)
echo Validated /%sysdir%/%modsdir%/devtools.mfm

echo.
echo Installing system module /%sysdir%/%modsdir%/flashbreak.mfm...
echo.
echo F145HBR34K jailbreak utility [%version%]>"%usrmods%/flashbreak.mfm"

if exist "%usrmods%/devtools.mfm" (if exist "%usrmods%/devtools.mfm" if exist "%usrmods%/flashbreak.mfm" (
echo Installed package from %pkgrepo%>"%usrdir%/%usrsysdata%/packages/installed/002-F145HBR34K"
if not exist "%usrdir%/%usrsysdata%/packages/installed/002-F145HBR34K" (echo Failed to register package. && goto prompt)
echo Installed successfully!
echo.
echo F145HBR34K commands have been added to the help section.
echo The system will now reboot.
echo.
pause
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot
) )
echo F145HBR34K failed to install.
goto prompt

:mfpkg-dl-003
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
echo Downloading WinFlash Compatibility Layer (pID 003)
echo.
echo Microsoft Windows Compatibility Layer for MicroflashOS>"%usrdir%/%usrsysdata%/packages/winflash.mfp"
if not exist "%usrdir%/%usrsysdata%/packages/winflash.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%>"%usrdir%/%usrsysdata%/packages/installed/003-WinFlash"
if not exist "%usrdir%/%usrsysdata%/packages/installed/003-WinFlash" (echo Failed to register package. && goto prompt)
echo Installed /%userdata%/%usrsysdata%/packages/winflash.mfp
goto execdone

:mfpkg-dl-004
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
echo Downloading Nuke (pID 004)
echo.
echo Self destruct tool LMAO by Kenneth White>"%usrdir%/%usrsysdata%/packages/nuke.mfp"
if not exist "%usrdir%/%usrsysdata%/packages/nuke.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%>"%usrdir%/%usrsysdata%/packages/installed/004-Nuke"
if not exist "%usrdir%/%usrsysdata%/packages/installed/004-Nuke" (echo Failed to register package. && goto prompt)
echo Installed /%userdata%/%usrsysdata%/packages/nuke.mfp
goto execdone

:mfpkg-dl-005
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
echo Downloading dumper (pID 005)
echo.
echo MicroflashOS Dumper by nsp>"%usrdir%/%usrsysdata%/packages/dumper.mfp"
if not exist "%usrdir%/%usrsysdata%/packages/dumper.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%>"%usrdir%/%usrsysdata%/packages/installed/005-dumper"
if not exist "%usrdir%/%usrsysdata%/packages/installed/005-dumper" (echo Failed to register package. && goto prompt)
echo Installed /%userdata%/%usrsysdata%/packages/dumper.mfp
goto execdone


:mfpkg-dl-006
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
echo Downloading mountvirt (pID 006)
echo.
echo Virtual System Disk Mounter by GigaflashOS Devs>"%usrdir%/%usrsysdata%/packages/mountvirt.mfp"
if not exist "%usrdir%/%usrsysdata%/packages/mountvirt.mfp" (echo Failed to install package. && goto prompt)
echo Installed package from %pkgrepo%>"%usrdir%/%usrsysdata%/packages/installed/006-mountvirt"
if not exist "%usrdir%/%usrsysdata%/packages/installed/006-mountvirt" (echo Failed to register package. && goto prompt)
echo Installed /%userdata%/%usrsysdata%/packages/mountvirt.mfp
goto execdone

:: Uninstallers

:mfpkg-rm-003
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
if not exist "%usrdir%/%usrsysdata%/packages/installed/003-WinFlash" (echo Package not installed! && goto prompt)
echo Uninstalling WinFlash Compatibility Layer (pID 003)
echo.
set "curdir=%cd%"
cd /d "%usrdir%/%usrsysdata%/packages/"
del winflash.mfp /f /q
if exist "%usrdir%/%usrsysdata%/packages/winflash.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%usrdir%/%usrsysdata%/packages/installed"
del "003-WinFlash" /f /q
if exist "%usrdir%/%usrsysdata%/packages/installed/003-WinFlash" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%userdata%/%usrsysdata%/packages/winflash.mfp
cd /d %curdir%
goto execdone

:mfpkg-rm-004
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
if not exist "%usrdir%/%usrsysdata%/packages/installed/004-Nuke" (echo Package not installed! && goto prompt)
echo Uninstalling Nuke (pID 004)
echo.
set "curdir=%cd%"
cd /d "%usrdir%/%usrsysdata%/packages/"
del nuke.mfp /f /q
if exist "%usrdir%/%usrsysdata%/packages/nuke.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%usrdir%/%usrsysdata%/packages/installed"
del "004-Nuke" /f /q
if exist "%usrdir%/%usrsysdata%/packages/installed/004-Nuke" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%userdata%/%usrsysdata%/packages/nuke.mfp
cd /d %curdir%
goto execdone

:mfpkg-rm-005
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
if not exist "%usrdir%/%usrsysdata%/packages/installed/005-dumper" (echo Package not installed! && goto prompt)
echo Uninstalling dumper (pID 006)
echo.
set "curdir=%cd%"
cd /d "%usrdir%/%usrsysdata%/packages/"
del dumper.mfp /f /q
if exist "%usrdir%/%usrsysdata%/packages/dumper.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%usrdir%/%usrsysdata%/packages/installed"
del "005-dumper" /f /q
if exist "%usrdir%/%usrsysdata%/packages/installed/005-dumper" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%userdata%/%usrsysdata%/packages/dumper.mfp
cd /d %curdir%
goto execdone

:mfpkg-rm-006
if not exist "%disk0p1%/mfpkg.mcm" (goto depcheckfail)
title MicroflashOS Package Manager
if not exist "%usrdir%/%usrsysdata%/packages/installed/006-mountvirt" (echo Package not installed! && goto prompt)
echo Uninstalling mountvirt (pID 006)
echo.
set "curdir=%cd%"
cd /d "%usrdir%/%usrsysdata%/packages/"
del mountvirt.mfp /f /q
if exist "%usrdir%/%usrsysdata%/packages/mountvirt.mfp" (echo Failed to uninstall package. && goto prompt)
cd /d "%usrdir%/%usrsysdata%/packages/installed"
del "006-mountvirt" /f /q
if exist "%usrdir%/%usrsysdata%/packages/installed/006-mountvirt" (echo Failed to unregister package. && goto prompt)
echo Uninstalled /%userdata%/%usrsysdata%/packages/mountvirt.mfp
cd /d %curdir%
goto execdone

:: Custom packages

:nuke
if not exist "%usrdir%/%usrsysdata%/packages/nuke.mfp" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
if not exist "%usrmods%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [nuke] ERROR: required dependency "DevTools" is missing! >>"%logfile%" && goto prompt)
title Nuke
echo Nuking system disk. ALL DATA WILL BE WIPED!
echo.
echo [proctector] INFO: requesting user authorization >>"%logfile%"
set /p "confirmation=Type "CONFIRM" (case-sensitive) to confirm this action: "
if "%confirmation%" == "CONFIRM" (
set "confirmation=" && echo [proctector] INFO: got user authorization >>"%logfile%"
echo.
if exist "%disk0p1%" (
rd "%disk0p1%" /s /q
echo System disk nuked.
goto execdone
)
echo System disk not found.
goto prompt
)
goto authfail

:dumper
if not exist "%usrdir%/%usrsysdata%/packages/dumper.mfp" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
if not exist "%usrmods%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [dumper] ERROR: required dependency "DevTools" is missing! >>"%logfile%" && goto prompt)
if not exist "%usrmods%/flashbreak.mfm" (echo F145HBR34K not found. Please install pID 002. && echo [dumper] ERROR: required dependency "F145HBR34K" is missing! >>"%logfile%" && goto prompt)
title MicroflashOS Dumper
echo MicroflashOS Dumper by nsp
echo.
if exist "%disk0p1%" (
  echo System disk mounted!
  echo.
  echo Dumping current MicroflashOS system disk to %~p0dump
  echo.
  xcopy "%disk0%" "%~p0dump\" /w /e /f
  goto execdone
) 
echo Could not find system disk. System may be corrupt!
echo.
echo Please enter recovery mode to repair your system.
goto prompt

:winflash
if not exist "%usrdir%/%usrsysdata%/packages/winflash.mfp" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
title WinFlash
cls
echo Type EXIT and press Enter to return to MicroflashOS.
echo.
echo [winflash] INFO: loading cmd.exe >>"%logfile%"
cmd.exe
echo [winflash] INFO: welcome back to mfos! >>"%logfile%"
goto execdone

:mountvirt
if not exist "%usrdir%/%usrsysdata%/packages/mountvirt.mfp" (goto depcheckfail)
echo [cmd] INFO: command valid! >>"%logfile%" && if not exist "%toggles%/incognito" (echo [valid] "%cmd%" >>"%history%")
if not exist "%usrmods%/devtools.mfm" (echo DevTools not found. Please install pID 001. && echo [mountvirt] ERROR: required dependency "DevTools" is missing! >>"%logfile%" && goto prompt)
if not exist "%usrmods%/flashbreak.mfm" (echo F145HBR34K not found. Please install pID 002. && echo [mountvirt] ERROR: required dependency "F145HBR34K" is missing! >>"%logfile%" && goto prompt)
title Virtual System Disk Mounter
echo Virtual system disks must be placed in the same directory as the Batch file.
echo Looking in: %~p0
echo.
echo NOTE: Don't fill in the blank with blanks!
echo.
set /p "sysvirt=Name of system disk: "
echo.
if not exist "%~p0%sysvirt%" (echo System disk not found! && goto execdone)
set "disk0label=%sysvirt%"
echo Mounted virtual disk! Rebooting...
echo.
pause
echo [cmd] INFO: rebooting... >>"%logfile%" && goto reboot

:: Some errors

:depcheckfail
echo Invalid command.
if not exist "%toggles%/incognito" (echo [invalid] "%cmd%" >>"%history%")
echo [cmd] ERROR: command "%cmd%" invalid >>"%logfile%"
goto prompt

:authfail
echo.
echo User authorization failed.
echo [proctector] ERROR: user authorization failed! >>"%logfile%"
goto prompt

:boot2fail
echo.
title Startup Failure! && echo MicroflashOS startup failed. Entering recovery... && echo. && pause
echo [kernel] INFO: booting to recovery... >>"%logfile%" && echo [kernel] INFO: booting to recovery... && goto recovery

:execdone
echo [cmd] INFO: command execution complete >> "%logfile%" && goto prompt
