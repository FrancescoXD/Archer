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
echo "Welcome to the automatic ArchLinux installer. See my github repo for more info: https://github.com/FrancescoXD/Archer"
echo ""
echo ""
fdisk -l
echo ""
echo "First of all, what is your partition table? (gpt or mbr)"
read partitionTable

# Starting
if [ $partitionTable == mbr ]; then
	timedatectl set-ntp true
	# Partitioning
	fdisk -l
	echo ""
	echo "Insert your disk: (like sda / sdb / sdc)"
	read disk
	clear
	echo "Now, you have to partition the disk, follow the guide on github for MBR partitioning."
	echo "You need 2 partition, one for filesystem and one for swap."
	sleep 3
	cfdisk /dev/$disk
	clear
	fdisk -l
	echo ""
	echo "Insert the number of the filesystem partition: (like 1 / 2 / 3 - only number!)"
	read filesystemPart
	mkfs.ext4 /dev/$disk$filesystemPart
	clear
	fdisk -l
	echo ""
	echo "Insert the number of the swap partition: (like 1 / 2 / 3 - only number!)"
	read swapNum
	mkswap /dev/$disk$swapNum
	swapon /dev/$disk$swapNum
	clear
	# Mount the system
	mount /dev/$disk$filesystemPart /mnt
	# Downloading base and base-devel package
	pacstrap /mnt base base-devel linux linux-firmware
	# Configure the system
	genfstab -U /mnt > /mnt/etc/fstab
	# Localization
	ls /usr/share/zoneinfo/
	echo ""
	echo "Insert the localization:"
	read localZone
	clear
	ls /usr/share/zoneinfo/$localZone/
	echo ""
	echo "Insert the zone:"
	read localTimeZone
	clear
	# Locale gen
	echo "Now you have to see the file /etc/locale.gen and select the right language for you. After selected type CTRL + X and write the full code, like: en_US.UTF-8"
	nano /etc/locale.gen
	echo "Now, write your language:"
	read localeGenLang
	sed -i -e "s/#$localeGenLang/$localGenLang/g" /etc/locale.gen
	locale-gen
	# Locale conf
	echo "LANG=$localeGenLang" > /etc/locale.conf
	# Keymap -> vconsole.conf
	echo "Insert the keymap (exmaple: us)"
	read keymap
	echo "KEYMAP=$keymap" > /etc/vconsole.conf
	# Hostname
	clear
	echo "Now, insert the hostname of the machine (recommended -> archlinux)"
	read hostname
	echo "$hostname" > /etc/hostname
	# Chroot
	arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/$localZone/$localTimeZone /etc/localtime && hwclock --systohc && pacman -S networkmanager grub && systemctl enable NetworkManager'
	arch-chroot /mnt bash -c 'grub-install /dev/$disk && grub-mkconfig -o /boot/grub/grub.cfg'
	# Umount
	umount -R /mnt
	# Root password
	clear
	echo "Insert the root password:"
	passwd
	# Finish
	clear
	echo "Thanks for using this script!"
	echo "Now reboot!"
elif [ $partitionTable == gpt ]; then
	echo "Selected GPT"
	timedatectl set-ntp true
	echo ""
	fdisk -l
	echo "Now you have to partition the disk, see my guide for GPT partitioning."
	echo "You need a partition for EFI (if you are installing archlinux in dualboot with Windows, the efi partition exists), the swap partition and the filesystem partition."
	echo "Insert your disk: (like sda / sdb / sdc)"
	read disk
	cfdisk /dev/$disk
	fdisk -l
	echo ""
	echo "Insert the number of the filesystem partition: (like 1 / 2 / 3 - only number!)"
	read filesystemPart
	mkfs.ext4 /dev/$disk$filesystemPart
	clear
	fdisk -l
	echo ""
	echo "Insert the number of the swap partition: (like 1 / 2 / 3 - only number!)"
	read swapNum
	mkswap /dev/$disk$swapNum
	swapon /dev/$disk$swapNum
	echo "Insert the EFI partition: (like 1 / 2 / 3 - only number!)"
	read efiPart
	# Mount the system
	mount /dev/$disk$filesystemPart /mnt
	mkdir /mnt/boot/efi
	mount /dev/$disk$efiPart /mnt/boot/efi
	# Downloading base and base-devel package
	pacstrap /mnt base base-devel linux linux-firmware
	# Configure the system
	genfstab -U /mnt > /mnt/etc/fstab
	# Localization
	ls /usr/share/zoneinfo/
	echo ""
	echo "Insert the localization:"
	read localZone
	clear
	ls /usr/share/zoneinfo/$localZone/
	echo ""
	echo "Insert the zone:"
	read localTimeZone
	clear
	# Locale gen
	echo "Now you have to see the file /etc/locale.gen and select the right language for you. After selected type CTRL + X and write the full code, like: en_US.UTF-8"
	nano /etc/locale.gen
	echo "Now, write your language:"
	read localeGenLang
	sed -i -e "s/#$localeGenLang/$localGenLang/g" /etc/locale.gen 
	locale-gen
	# Keymap -> vconsole.conf
	echo "Insert the keymap (exmaple: us)"
	read keymap
	echo "KEYMAP=$keymap" > /etc/vconsole.conf
	# Locale conf
	echo "LANG=$localeGenLang" > /etc/locale.conf
	# Hostname
	clear
	echo "Now, insert the hostname of the machine (recommended -> archlinux)"
	read hostname
	echo "$hostname" > /etc/hostname
	# Chroot
	arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/$localZone/$localTimeZone /etc/localtime && hwclock --systohc && pacman -S networkmanager grub efibootmgr && systemctl enable NetworkManager'
	arch-chroot /mnt bash -c 'grub-install --target=x86_64-efi --efi-directory=/boot/efi && grub-mkconfig -o /boot/grub/grub.cfg'
	# Umount
	umount -R /mnt/boot/efi
	umount -R /mnt
	# Root password
	clear
	echo "Insert the root password:"
	passwd
	# Finish
	clear
	echo "Thanks for using this script!"
	echo "Now reboot!"
fi
