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

In MicroflashOS, you can type ```help``` to get a list of all available commands.
The more you do (usually just install packages) the more commands will be shown.

Here are some useful commands to start with:

- ```about```: Shows some system info
- ```mkdir```: Create directory
- ```mkfile```: Create a file
- ```del```: Delete file/directory
- ```cd```: Change directory
- ```list```: List accessible files and directories from current location (similar to Linux ```ls``` or Windows ```dir```)

---

## MicroflashOS Package Manager

MicroflashOS includes a "package manager" (mfpkg)

- To list available packages in repository type ```mfpkg-repo-available```
  The included repository is the *GigaflashOS Unified Repository [Revision 1]*
- To install/uninstall a package type ```mfpkg-install``` or ```mfpkg-uninstall``` respectively
  Alternatively you can quickly install/uninstall a package with ```mfpkg-dl-[package ID]``` or ```mfpkg-rm-[package ID]``` respectively
- To list installed packages type ```mfpkg-list```

---

## DevTools

Some packages may require DevTools to function.

Install package ID ```001```.

Installing DevTools also opens up some more commands that can be viewed via ```help```

---

## Jailbreak???

As part of the lore, MicroflashOS has a jailbreak called Flashbreak, which has been faithfully recreated here.
Some packages may require Flashbreak to function.

Install package ID ```002```.

---

## Uninstallation

Simply delete the Batch file and the folder named ```MicroflashOS```

---

# Developer stuffs

---

## File formats

MicroflashOS utilises some file formats for system files:
- ```.mcm```: MicroflashOS Core Module, reserved for critical system modules (sysmodules) that are required for MicroflashOS.
  **It is recommended you do not modify these.**
- ```.mfm```: MicroflashOS Module, these are for non-critical sysmodules
- ```.mfp```: MicroflashOS Package, used by packages installed from mfpkg

---

## Directories

The system disk consists of two "partitions": ```system``` and ```userdata```
- ```system``` contains the operating system itself.
- ```users``` contains, well, user data.
  Inside each user folder (set by the Batch variable %username%) is a folder named ```mfosdata``` that contains user-specific packages and toggles.
  If ```mfosdata``` is ever corrupted it will simply be regenerated on next boot.

Upon reinstalling MicroflashOS, only the ```system``` folder is modified.
Any leftover user data in ```users``` is left intact. *This may cause some problems when updating.*

If you wish to fully format the system it's advised you run ```homewipe``` after installation.

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

