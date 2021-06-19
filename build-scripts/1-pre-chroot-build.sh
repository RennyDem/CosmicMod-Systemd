fdisk -l

dd if=/dev/zero of=/dev/sda bs=1M

sync

reboot

screen -S CosmicMod-2022

fdisk -l

parted -a optimal /dev/sda
mklabel gpt
unit MiB
mkpart primary 3 10000
name 1 boot
mkpart primary 10000 26000
name 2 swap
mkpart primary 26000 -1000
name 3 rootfs
set 1 boot on
quit

sync &&
mkfs.fat -F 32 /dev/sda1 &&
mkfs.ext4 /dev/sda3 &&
mkswap /dev/sda2 &&
swapon /dev/sda2

# create if needed
# mkdir /mnt/gentoo

mount /dev/sda3 /mnt/gentoo &&
cd /mnt/gentoo &&
wget https://mirrors.rit.edu/gentoo/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-20210616T214502Z.tar.xz &&
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

mkdir --parents /mnt/gentoo/etc/portage/repos.conf &&
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf &&
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/ &&
cp --dereference /etc/portage/make.conf /mnt/gentoo/etc/portage/ &&
cp --dereference /etc/portage/package.use/zz.use /mnt/gentoo/etc/portage/package.use/ &&
cp --dereference /etc/conf.d/hostname /mnt/gentoo/etc/conf.d/ &&
cp --dereference /etc/hosts /mnt/gentoo/etc/ &&
cp --dereference /etc/locale.gen /mnt/gentoo/etc/ &&
cp --dereference /etc/fstab /mnt/gentoo/etc/

# In new terminal
# blkid

vim /mnt/gentoo/etc/fstab

vim /mnt/gentoo/etc/portage/package.use/zz.use

mount --types proc /proc /mnt/gentoo/proc &&
mount --rbind /sys /mnt/gentoo/sys &&
mount --rbind /dev /mnt/gentoo/dev &&
chroot /mnt/gentoo /bin/bash
