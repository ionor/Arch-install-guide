# My install guide for arch.

## Getting started
Changing keymap to swedish
> loadkeys sv-latin1

Connect to wifi
> wifi-menu

## Partitioning
Create one 500MB EFI-partition (+500M) and allocate the rest for the root-partition.
> fdisk /dev/sda

Change type of the first partition to 1 (LVM) and the second one to 31 (LVM).

Format /dev/sda1 to vfat.
> mkfs.vfat -F32 /dev/sda1

## Encryption and LVM

Encrypt the LVM by using the following:  
>cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 luksFormat /dev/sda2

Open the crypt
> cryptsetup luksOpen /dev/sda2 arch

Then setup the partitions inside.
>pvcreate /dev/mapper/arch  
>vgcreate vol /dev/mapper/arch  
>lvcreate --size 8G vol --name swap  
>lvcreate -l +100%FREE vol --name root  

And format them
>mkfs.e2fs /dev/mapper/vol-root
>mkswap /dev/mapper/vol-swap

## Mount partitions

Mount them all
>mount /dev/mapper/vol-root /mnt  
>mkdir /mnt/boot  
>mount /dev/sda1 /mnt/boot  
>swapon /dev/mapper/vol-swap  

## Bootstrap the system, generate fstab and then chroot into it
Install the choosen packagesgroups. More can be added i.e gnome.
>pacstrap /mnt base base-devel

Generate /etc/fstab
>genfstab -U /mnt >> /mnt/etc/fstab

Chroot in to the system
>arch-chroot /mnt

Now that we are in our new environment. Lets install some extra packages
>pacman -S zsh networkmanager intel-ucode

## Set up some basic things
Setup timezone
> ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

Edit locale.gen and then generate locales
> nano /etc/locale.gen  
> locale-gen

Set hostname
> echo  myfunnycomputername > /etc/hostname

## Set up userstuff
Create a useraccount
> useradd -m -G wheel -s /bin/zsh myhaxxorusername

Set a password
> passwd samehaxxorusername

Configure sudo by opening the configration file and uncommenting the wheel-option
> visudo














