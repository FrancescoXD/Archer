#!/bin/bash
printf "
                    _               
     /\            | |              
    /  \   _ __ ___| |__   ___ _ __ 
   / /\ \ | '__/ __| '_ \ / _ \ '__|
  / ____ \| | | (__| | | |  __/ |   
 /_/    \_\_|  \___|_| |_|\___|_|   
                                    
                                    
"
echo ""
echo "Welcome to my automatic ArchLinux installer. See my github repo for more info: https://github.com/FrancescoXD/Archer"
echo "Don't use it, seriously."
echo ""

# Start

# mbr
timedatectl set-ntp true
# Partition the disks
echo "Now, we need to partition the disks."
fdisk -l
echo ""
echo "Insert the disk (like sda/sdc/sdb):"
read disk
clear
echo "Partition is not automatic, so you need to do it manually."
echo "IMPORTANT - select dos label type"
echo "cfdisk is starting..."
sleep 5
cfdisk /dev/$disk
clear
fdisk -l
echo "Insert the number of root partition: "
read root
mkfs.ext4 /dev/$disk$root
echo "Insert swap partition (enter if you don't have one):"
read swap
mkswap /dev/$disk$swap
swapon /dev/$disk$swap
mount /dev/$disk$root /mnt
clear
# Pacstrap
echo "Running: pacstrap /mnt base base-devel linux linux-firmware..."
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt > /mnt/etc/fstab
# Localization
ls /usr/share/zoneinfo/
echo ""
echo "Insert the region:"
read region
clear
ls /usr/share/zoneinfo/$region/
echo ""
echo "Insert the city:"
read city
arch-root /mnt ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime
arch-root /mnt hwclock --systohc
clear
# Locale gen
echo "Now you have to see the file /etc/locale.gen and select the right language for you. After selected type CTRL + X and write the full code, like: en_US.UTF-8"
sleep 3
arch-root /mnt vi /etc/locale.gen
echo "Now, write your language:"
read localeGenLang
arch-root /mnt sed -i -e "s/#$localeGenLang/$localGenLang/g" /etc/locale.gen
arch-root /mnt locale-gen
# Locale conf
arch-root /mnt echo "LANG=$localeGenLang" > /etc/locale.conf
# Keymap -> vconsole.conf
echo "Insert the keymap (exmaple: us)"
read keymap
arch-root /mnt echo "KEYMAP=$keymap" > /etc/vconsole.conf
# Hostname
clear
echo "Now, insert the hostname of the machine (recommended -> archlinux)"
read hostname
arch-root /mnt echo "$hostname" > /etc/hostname
# Network configuration
arch-root /mnt pacman -S networkmanager
arch-root /mnt systemctl enable NetworkManager
arch-root /mnt pacman -S grub
arch-root /mnt grub-install /dev/$disk
arch-root /mnt grub-mkconfig -o /boot/grub/grub.cfg
clear
echo "Thanks for using the script! You are really brave!"
echo "Now reboot with: reboot"