dd if=/dev/zero of=/dev/sda bs=1M
&& sync
&& sleep 1m
&& reboot

screen -S CosmicMod-2021-r1

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
swapon /dev/sda2 &&
mkdir /mnt/gentoo &&
mount /dev/sda3 /mnt/gentoo &&
cd /mnt/gentoo &&
wget http://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-20210414T214503Z.tar.xz &&
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

mkdir --parents /mnt/gentoo/etc/portage/repos.conf &&
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf &&
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/ &&
mount --types proc /proc /mnt/gentoo/proc &&
mount --rbind /sys /mnt/gentoo/sys &&
mount --rbind /dev /mnt/gentoo/dev &&
chroot /mnt/gentoo /bin/bash
