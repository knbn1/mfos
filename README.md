# Welcome to MicroflashOS!

---

## What is it?

Microflash Operating System (MicroflashOS or mfos) is a "fantasy operating system" made in Batch.
It is primarily centered around the [MicroflashOS lore file](https://knbn1.github.io/sitefiles/microflash/mfos-lore.txt), as a result any names mentioned are references to the lore.

Please read disclaimer.md before installing.

Code is licensed under the GPL-3.0 license, you are free to make your own derivative of MicroflashOS.

---

## Compatibility

It has been tested under Wine (Arch Linux) and Windows 10.

---

## Installation

Download the latest release and run the Batch file.

On install, the Batch file creates a "system disk" named ```MicroflashOS``` in the same location as the Batch file.
All operating system data is stored inside that folder.

After it is "installed" just run the Batch file every "startup".

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

- List available packages in repository: ```mfpkg-repo-available```. The included repository is the *GigaflashOS Unified Repository [Revision 1]*
- List installed packages: ```mfpkg-list```
- Install/uninstall package: ```mfpkg-install``` or ```mfpkg-uninstall``` respectively.
- QUICKLY install/uninstall a package: ```mfpkg-dl-[package ID]``` or ```mfpkg-rm-[package ID]``` respectively

---

## DevTools (Developer Tools)

Some packages may require DevTools to function properly.

Install package ID ```001```.

Installing DevTools also opens up some more commands that can be viewed via ```help```

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
- ```.mfm```: MicroflashOS Module, these are for non-critical sysmodules
- ```.mfp```: MicroflashOS Package, used by packages installed from ```mfpkg```

---

## Directories

The system disk consists of two "partitions": ```mfos``` and ```userdata```
- ```mfos``` contains the operating system itself. Sysmodules are stored here.
- ```userdata``` contains, well, user data.
  Inside each user folder (set by the Batch variable ```%username%```) is a folder named ```mfosdata``` that contains user-specific packages and toggles.
  If ```mfosdata``` is ever corrupted it will simply be regenerated on next boot.

Upon reinstalling MicroflashOS, only the ```mfos``` folder is modified. 
Any leftover user data in ```userdata``` is left intact. *This may cause some problems when updating.* 
If a release does break something from the older version, it will be made clear in the release notes.

If you wish to fully format the system to clear all userdata, run ```homewipe``` after installation.

---

## Toggles

Toggles are configurations that can be configured.
Note that modifying these requires DevTools.

Some noteworthy ones:
- ```slowboot```: Add pauses during boot sequence, allowing the user to see the boot process in greater detail as it automatically clears itself once the shell has been initialized.
- ```showdir```: Show the current directory above the prompt. Useful for navigating complex directory trees.

---

## Roadmap:

- More packages (maybe some games)
- MicroflashOS Updater
- Logging system for debugging
- ```robolibs``` (the current unreleased one is a mess)
- More repositories (maybe have a distinction between official packages from Kenneth and GigaflashOS CFW packages?)
- More jailbreak-y stuff (I have some handwritten lore pages that need to be released for that though)
- Bug fixes (never gets old!), mostly just looking for any weird situations

