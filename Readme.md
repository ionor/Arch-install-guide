# Getting started

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
