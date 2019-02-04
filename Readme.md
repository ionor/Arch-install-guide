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

And lastly, disable the root-user
> passwwd -l root

## Generate a ramdisk

> vi /etc/mkinitcpio.conf

And make sure it contains the following
>MODULES="i915 dm_mod dm_crypt ext4 aes_x86_64 sha256 sha512"  
>BINARIES=()  
>FILES=""  
>HOOKS="base systemd block autodetect modconf keyboard sd-vconsole sd-encrypt sd-lvm2 filesystems"  

Then generate it
> mkinitcpio -p linux

## Install bootloader
Install systemd-boot by running:
> bootctl --path=/boot install

And create a new file for the bootloader to use.
> vi /boot/loader/entries/arch.conf

And make sure it contains this with need adjustments. The first rd.luks.uuid should be the uuid for the /dev/sda2
>title	Arch  
>linux	/vmlinuz-linux  
>initrd	/intel-ucode.img  
>initrd	/initramfs-linux.img  
>options rd.luks.uuid=79ae5257-f0bb-4c3e-87de-680ed66af182 rd.lvm.lv=arch/root rd.lvm.lv=arch/swap rd.luks.options=discard root=UUID=363f799d-b080-425e-b0f8-d9011082db48 ro quiet loglevel=3 vt.global_cursor_default=0 rd.systemd.show_status=0 rd.udev.log-priority=3 i915.fastboot=1  

## Reboot
Just reboot!

## Finishing touches 
Connect to wifi
> nmcli [...]

Install git
> pacman -S git

Install yay
> git clone https://aur.archlinux.org/yay.git  
> cd yay  
> makepkg -si  

Install some extra packages
> yay -S powertop ttf-dejavu neovim







