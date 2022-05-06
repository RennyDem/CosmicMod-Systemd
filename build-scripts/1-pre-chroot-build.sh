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
wget https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-desktop-openrc-20220501T170547Z.tar.xz &&
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

mkdir --parents /mnt/gentoo/etc/portage/repos.conf &&
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf &&
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/ &&
cp --dereference /etc/portage/make.conf /mnt/gentoo/etc/portage/ &&
cp --dereference /etc/portage/package.use/zz.use /mnt/gentoo/etc/portage/package.use/ &&
cp --dereference /etc/conf.d/hostname /mnt/gentoo/etc/conf.d/ &&
cp --dereference /etc/hosts /mnt/gentoo/etc/ &&
cp --dereference /etc/locale.gen /mnt/gentoo/etc/ &&
cp --dereference /etc/fstab /mnt/gentoo/etc/ &&
cp --dereference /etc/portage/repos.conf/gentoo.conf /mnt/gentoo/etc/portage/repos.conf/ &&
echo 'files sucessfully copied'

blkid
# from host env
vim /mnt/gentoo/etc/fstab

vim /mnt/gentoo/etc/portage/package.use/zz.use

# in chroot env

mount --types proc /proc /mnt/gentoo/proc &&
mount --rbind /sys /mnt/gentoo/sys &&
mount --make-rslave /mnt/gentoo/sys &&
mount --rbind /dev /mnt/gentoo/dev &&
mount --make-rslave /mnt/gentoo/dev &&
mount --bind /run /mnt/gentoo/run &&
mount --make-slave /mnt/gentoo/run &&
test -L /dev/shm && rm /dev/shm && mkdir /dev/shm &&
mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm &&
chmod 1777 /dev/shm &&
chroot /mnt/gentoo /bin/bash
