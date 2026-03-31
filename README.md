# Welcome to MicroflashOS!

---

## What is it?

Microflash Operating System (MicroflashOS or mfos) is a "fantasy operating system" made in Batch.
It is primarily centered around the [MicroflashOS lore file](https://knbn1.github.io/sitefiles/microflash/mfos-lore.txt), as a result any names mentioned are references to the lore.

Please read [disclaimer.md](https://github.com/knbn1/microflash-os/blob/main/disclaimer.md) before installing.

Code is licensed under the GPL-3.0 license, you are free to make your own derivative/fork of MicroflashOS.

---

## Compatibility

I normally test under Wine (Arch Linux)

Sometimes it may crash on Windows 10 when typing a command. I don't know why.

---

## Installation

Download the latest release and run the Batch file.

On install, the Batch file creates a "system disk" named ```MicroflashOS``` in the same location as the Batch file.
All operating system data is stored inside that folder.

After it is "installed" just run the Batch file every "startup".

---

## Updating MicroflashOS

Download the latest release and run the Batch file.

Then simply run ```recovery``` to boot to recovery mode to reinstall.

---

## Quick Start Guide

In MicroflashOS, you can type ```help``` to get a list of all available commands. Packages can choose to add their own commands to this section.

Here are some useful commands to start with:

- ```about```: Shows some system info
- ```mkdir```: Create directory
- ```mkfile```: Create a file
- ```del```: Delete file/directory
- ```cd```: Change directory
- ```list```: List accessible files and directories from current location (similar to Linux ```ls``` or Windows ```dir```)

---

## MicroflashOS Package Manager

MicroflashOS includes a "package manager" called ```mfpkg```. 
It handles standalone packages in the ```.mfp``` format, otherwise it acts as a bootstrap for installers (such as the one used to install DevTools)

- List available packages in repository: ```mfpkg-repo-available```.
  The included repository as of the latest stable release is the *GigaflashOS Unified Repository [Revision 1]*
- List installed packages: ```mfpkg-list```
- Install/uninstall package: ```mfpkg-install``` or ```mfpkg-uninstall``` respectively.
- QUICKLY install/uninstall a package: ```mfpkg-dl-[package ID]``` or ```mfpkg-rm-[package ID]``` respectively.

---

## DevTools (Developer Tools)

Some packages may require DevTools to function properly.

Install package ID ```001```.

Installing DevTools also opens up some more commands that can be viewed via ```help```.

---

## Jailbreak???

As part of the lore, MicroflashOS has a jailbreak called Flashbreak, which has been faithfully recreated here. 
Some packages may require Flashbreak to function properly.

Install package ID ```002```.

---

## Uninstallation

Simply delete the Batch file and the folder named ```MicroflashOS```

---

# Developer stuffs

---

## File formats

MicroflashOS utilises some proprietary file formats:
- ```.mcm```: MicroflashOS Core Module, reserved for critical system modules (sysmodules) that are required for MicroflashOS. **It is recommended you do not modify these.**
- ```.mfm```: MicroflashOS Module, these are non-critical sysmodules that don't affect the system *much* but still be careful.
- ```.mfp```: MicroflashOS Package, used by packages installed from ```mfpkg```

---

## Directories

The system disk consists of two "partitions": ```mfos``` and ```userdata```
- ```mfos``` contains the operating system itself. Sysmodules are stored here.
- ```userdata``` contains, well, user data.
  Inside each user directory (set by the Batch variable ```%username%```) is a directory named ```mfosdata``` that contains user-specific packages and toggles.
  If ```mfosdata``` is ever corrupted it will simply be regenerated on next boot.

Upon reinstalling/updating MicroflashOS, only the ```mfos``` folder is modified. 
Any leftover user data in ```userdata``` is left intact. It depends on the version and how major it is, which will be specified in the release notes.
If a release does break something from the older version, it will be made clear in the release notes.

If you wish to clear userdata, run ```homewipe``` after installation.

---

## Toggles

Toggles are configurations that can be configured.
Note that accessing and/or modifying these requires DevTools.

Some noteworthy ones:
- ```slowboot```: Add pauses during boot sequence, allowing the user to see the boot process in greater detail as it automatically clears itself once the shell has been initialized.
- ```showdir```: Show the current directory above the prompt. Useful for navigating complex directory trees.

---

## Reading log messages (as of 2026.04.01)

By default a file named ```mfos-log.txt``` is created in the same directory as the Batch file. 
(This behavior can be disabled with the ```nolog``` toggle.)

Log messages follow this format:

```[a] b: c```

where ```a``` is the running process, ```b``` is the message type (either ```INFO```, ```WARN```, ```DEBUG``` or ```ERROR```)

---

## Roadmap:

- More packages (maybe some games)
- MicroflashOS Updater
- ```robolibs``` (added database manager in ```2026.03.18-rbtest```, still some more lore-specific stuff to add)
- More repositories (maybe have a distinction between official packages from Kenneth and GigaflashOS CFW packages?)
- More jailbreak-y stuff (I have some handwritten lore pages that need to be released for that though)
- Bug fixes (never gets old!), mostly just looking for any weird situations
- Future-proofing (making things more universal and easier to modify)

