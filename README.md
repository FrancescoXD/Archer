# Archer - WIP
A complete ArchLinux installer. Making installation easier than eating a pie.

> [EFI Guide](#efi-guide)

> [MBR Guide](#mbr-guide)
### Requirements
An ArchLinux live and a keyboard.
```
$ pacman -Sy
$ pacman -S git
```
### Download the repo
```
$ git clone https://github.com/FrancescoXD/Archer.git
$ cd Archer
$ chmod 777 installer.sh
$ ./installer.sh
```
## Guide
### Efi guide
- When you start the script, you have to enter what partition table you are using. To see it just look here:
![1](.images/efi/1.png?raw=true)

- Now you have to insert the disk name:
![2](.images/efi/2.png?raw=true)

- Now you have to partition the disk, you will find a screen like this:
![3_2](.images/efi/3_2.png?raw=true)

- First you have to create 2 partitions (the **EFI** partition exists if you installed Windows), one for **swap** and one for the **system**. LIke this:
![3](.images/efi/3.png?raw=true)

- Now set the right type.
![5](.images/efi/5.png?raw=true)

- Then you have to click _Write_, type **yes** and _Quit_.
![6_1](.images/efi/6_1.png?raw=true)

- Now inser the right number of the partition:
![6](.images/efi/6.png?raw=true)

- Now you have to set your localtime: (take attention at the capital letter!)
![7](.images/efi/7.png?raw=true)

- Now on the screen the file ```/etc/locale.gen``` will open in ```nano```. Here you will have to find your language locale. Then press CTRL + X to get out and follow the other instructions.
![8](.images/efi/8.png?raw=true)
