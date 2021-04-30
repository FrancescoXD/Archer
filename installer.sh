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

timedatectl set-ntp true

# Disk to use
fdisk -l
echo "Select the disk to use: "
read disk

# Partitioning
parted -s $disk mklabel gpt
parted -s $disk mkpart primary ESP fat32 0 512MiB
parted -s $disk set 1 esp on
parted -s $disk mkpart primary linux-swap 512MiB 2560MiB
parted -s $disk mkpart primary ext4 2560MiB 100%

mkfs.fat -F32 $(printf "%s1" "$disk")
mkfs.ext4 $(printf "%s3" "$disk")
mkswap $(printf "%s2" "$disk")

mount $(printf "%s3" "$disk") /mnt
swapon $(printf "%s2" "$disk")

# Installing
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt > /mnt/etc/fstab
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sed -i 's/\#it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -i 's/\#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=it_IT.UTF-8" > /mnt/etc/locale.conf
echo "KEYMAP=it" > /mnt/etc/vconsole.conf
echo "arch" > /mnt/etc/hostname
arch-chroot /mnt pacman --noconfirm -S grub efibootmgr networkmanager
arch-chroot /mnt systemctl enable NetworkManager
mkdir /mnt/efi
mount $(printf "%s1" "$disk") /mnt/efi
grub-install --target=x86_64-efi --efi-directory=/mnt/efi --bootloader-id=GRUB
grub-mkconfig -o /mnt/boot/grub/grub.cfg

# Finish
echo "Set root password"
arch-chroot /mnt passwd
echo "Thanks!"
reboot
