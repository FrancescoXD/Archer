# Archer - WIP (With the new update is UEFI only)
A complete ArchLinux installer. Making installation easier than eating a pie.

### The program will format the entire disk, make sure you have backups.

> [EFI Guide](#efi-guide)

> [MBR Guide](#mbr-guide)
### Requirements
An ArchLinux live and a keyboard.
```
# pacman -Sy git
```
If you get GLIBC error you need to reinstall the ```glibc``` package.
```
# pacman -Sy glibc
```
### Download the repo
```
$ git clone https://github.com/FrancescoXD/Archer.git
$ cd Archer
# chmod +x installer.sh
$ ./installer.sh
```
## Guide
### EFI guide
When you start the script a list of disks will come up, you have to write on which disk ArchLinux will be installed (be careful because it wants the full path: ```/dev/sdX```, where *X* must be replaced by the letter of the disk).

When finished, you will be asked for your **_root_** password. _Be careful when choosing this password._
