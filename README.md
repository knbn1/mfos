# Welcome to MicroflashOS!


Microflash Operating System (MicroflashOS or mfos) is a "fantasy operating system" made in Batch.
It is primarily centered around the [MicroflashOS lore file](https://knbn1.github.io/sitefiles/microflash/mfos-lore.txt), as a result any names mentioned are references to the lore.

Please read [disclaimer.md](https://github.com/knbn1/microflash-os/blob/main/disclaimer.md) before installing.

Code is licensed under the GPL-3.0 license, you are free to make your own derivative/fork of MicroflashOS.

---

## Compatibility Notes

I normally test under Wine (Arch Linux)

Sometimes it may crash on Windows 10 when typing a command. *I don't know why.*

---

## Installing MicroflashOS 

Download the latest release and run the Batch file.

On first install, the Batch file creates a "system disk" named ```MicroflashOS``` in the same location as the Batch file.
All operating system data is stored inside that folder. 

MicroflashOS DOES NOT attempt to modify your computer further. *Check the source code yourself if you think I'm lying.* If it makes changes outside of the system disk, your Batch file has likely been tampered with. In that case, re-download the latest official release from [GitHub Releases](https://github.com/knbn1/mfos/releases).

After it is "installed" just run the Batch file every "startup". MicroflashOS should detect the existing system disk and go straight to the prompt.

---

## Updating MicroflashOS

As of 2026.04.28, MicroflashOS updates are handled automatically on boot. Just download the latest Batch file and run it. The program should figure out the rest.

If you are on an older version, you may update manually by using the ```recovery``` command.

Upon updating MicroflashOS, only the ```mfos``` folder is modified. 
Any leftover user data in ```userdata``` is left intact. 
However, this depends on what changes are introduced in the latest version and whether or not they will affect the ```userdata``` partition.
If a release does break something, it will be made clear in the release notes.

Note that if a release makes changes to the ```mfos``` folder, a missing file is often enough to automatically reboot to recovery.

---

## Help Section

In MicroflashOS, you can type ```help``` to get a list of all available commands. Packages can choose to add their own commands to this section.

Here are some useful commands to start with:

- ```about```: Shows some system info
- ```clock```: Shows date and time
- ```mkdir [directory]```: Create directory
- ```delete [directory]```: Delete file/directory
- ```cd [directory]```: Change directory
- ```list```: List accessible files and directories *from current location* (similar to Linux ```ls``` or Windows ```dir``` commands)

---

## Command History

As of 2026.04.25, MicroflashOS now logs commands. 

The history file can be found in the home directory as ```mfos-history.txt```

This behavior can be disabled with the ```incognito``` toggle. Read about toggles and DevTools [here](https://github.com/knbn1/mfos#toggles) and [here](https://github.com/knbn1/mfos#devtools-developer-tools).

---

## MicroflashOS Package Manager

MicroflashOS includes a "package manager" called ```mfpkg```. 
It handles standalone packages in the ```.mfp``` format, otherwise it acts as a bootstrap for installers (such as the one used to install [DevTools](https://github.com/knbn1/mfos#devtools-developer-tools))

- List available packages in repository: ```mfpkg available```
  The included repository as of the latest stable release is the *GigaflashOS Unified Repository [Revision 1]*
- List installed packages: ```mfpkg list```
- Install/uninstall package: ```mfpkg install [package ID]``` or ```mfpkg uninstall [package ID]``` respectively.

---

## DevTools (Developer Tools)

Some packages may require DevTools to function properly.

Install package ID ```001```.

Installing DevTools also opens up some more commands that can be viewed via ```help```.

---

## Flashbreak

As part of the lore, MicroflashOS has a jailbreak called Flashbreak, which has been faithfully recreated here. 
Some packages may require Flashbreak to function properly.

Install package ID ```002```.

---

## Uninstalling MicroflashOS 

Simply delete the MicroflashOS Batch file, log file (if present) and the folder named ```MicroflashOS```

---

## Resetting to Defaults

Run ```homewipe``` after booting to remove ALL user content and settings. A new ```userdata``` partition will be formatted after rebooting.

Please be careful with this command to avoid unintentional data loss!

---

# Technicalities for Nerds


## File Formats

MicroflashOS utilises some proprietary file formats:

- ```.mcm```: MicroflashOS Core Module, reserved for critical system modules (sysmodules) that are required for MicroflashOS. **It is recommended you do not modify files with this extension.**
- ```.mfm```: MicroflashOS Module, these are non-critical sysmodules that don't affect the core system, however modifying these may break packages using this sysmodule format.
- ```.mfp```: MicroflashOS Package, used by packages installed from ```mfpkg```. Deleting these will leave the package in a broken/unusable state, which can only be resolved by reinstalling the package.

---

## Directories

The system disk contains two "partitions": ```mfos``` and ```userdata```

- ```mfos``` contains the operating system itself. Sysmodules are stored here.
- ```userdata``` contains, well, user data.
  Inside each user directory (set by the generic Batch variable ```%username%```) is a directory named ```mfosdata``` that contains user-specific packages and toggles.
  If ```mfosdata``` is ever corrupted it will simply be regenerated on next boot. Note that some settings and packages may be missing.

---

## Toggles

Toggles are configurations that can be configured (of course).
Note that accessing and/or modifying these requires [DevTools](https://github.com/knbn1/mfos#devtools-developer-tools).

Some noteworthy ones:

- ```slowboot```: Add pauses during boot sequence, allowing the user to see the boot process in greater detail. Normally the (verbose) boot process is cleared from the screen once the shell has been initialized, but ```slowboot``` disables this behavior.
- ```showdir```: Show the current directory above the prompt. Useful for navigating complex directory trees.
- ```nolog```: Disables the log file (more info in the next section)
- ```incognito```: Disables logging command history
- ```allowdisabled```: Enables some disabled commands

---

## Reading Log Messages (as of 2026.04.01)

By default a file named ```mfos-log.txt``` is created in the same directory as the Batch file. 

Log messages follow this format:

```[a] b: c```

where ```a``` is the running process, ```b``` is the message type (either ```INFO```, ```WARN```, ```DEBUG``` or ```ERROR```) and ```c``` is the log message.

---

## Roadmap:

- More packages (maybe some games)
- ```robolibs``` (added database manager in ```2026.03.18-rbtest```, still some more lore-specific stuff to add)
- More repositories (maybe have a distinction between official packages from Kenneth and GigaflashOS CFW packages?)
- More jailbreak-y stuff (I have some handwritten lore pages that need to be released for that though)
- Bug fixes (never gets old!), mostly just looking for any weird situations
- Future-proofing (making things more universal and easier to customize)
- Guide to Programming For MicroflashOS
- Compact and shrink code
- Recycle Bin
- Move toggles to variable-based settings
- Add command-specific help sections
- Offload packages to actual files
- Make ```homewipe``` user-specific
- Add support for creating/deleting users without reliance on Windows
- Third-party package support
- Dynamically install updates with ```curl```
