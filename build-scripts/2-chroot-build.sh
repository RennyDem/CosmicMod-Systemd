source /etc/profile &&
export PS1="(chroot) ${PS1}" &&
mount /dev/sda1 /boot &&
rm stage3-amd64-*.tar.xz &&
emerge --sync

eselect news list

eselect news read

eselect news purge

eselect profile list &&
echo "setting selection 8 in 20 sec" &&
sleep 20 &&
eselect profile set 8

# ls /usr/share/zoneinfo/US
echo "US/Central" > /etc/timezone

emerge --config sys-libs/timezone-data

emerge --ask --verbose linux-firmware &&
echo 'emerging the kernel in 1 minute' &&
sleep 1m &&
emerge --ask --verbose gentoo-kernel

emerge --sync &&
echo 'updating the system in 1 minute' &&
sleep 1m &&
emerge --ask --verbose --update --deep --newuse --with-bdeps=y @world

emerge --ask --verbose --depclean 

eclean -d distfiles

emerge --ask --verbose vim &&
sleep 1m &&
emerge --ask --verbose --depclean &&
eselect editor list &&
sleep 1m &&
eselect editor set 2

env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1"

locale-gen &&
eselect locale list &&
sleep 1m &&
eselect locale set 6

env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1"

vim /etc/portage/package.use/circular.use

emerge --ask --verbose net-misc/ntp &&
ntpd -q -g &&
hwclock --systohc

paperconfig -p letter

emerge --ask --verbose dosfstools grub

# host-env
# cp --dereference /etc/default/grub /mnt/gentoo/etc/default/

blkid
# update root=UUID
vim /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --removable &&
grub-mkconfig -o /boot/grub/grub.cfg

emerge --sync &&
sleep 5m &&
emerge --ask --verbose --update --deep --newuse --with-bdeps=y @world

paperconfig -p letter

emerge --ask --verbose gentoolkit

emerge --ask --verbose --depclean &&
sleep 3m &&
eclean -d distfiles

emerge --ask --verbose --sync &&
sleep 1m &&
emerge --ask --verbose kde-plasma/plasma-meta

vim /etc/conf.d/display-manager
# DISPLAYMANAGER="sddm"

usermod -a -G video sddm

emerge --depclean &&
sleep 1m &&
eclean -d distfiles

# host-env
# cp --dereference /var/lib/portage/world /mnt/gentoo/var/lib/portage/ 

emerge --ask --verbose --sync &&
sleep 1m &&
emerge --ask --verbose --update --deep --newuse --with-bdeps=y @world

eselect news read &&
sleep 1m &&
eselect news purge &&
revdep-rebuild

eselect fontconfig --list

eselect fontconfig enable 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 25 26 28 29 30 31 37 38 39 40 41 42 45 46 48 50 51 52 53 54 56 57 58 61 62

env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

emerge --ask --verbose --depclean &&
sleep 1m &&
eclean -d distfiles &&

vim /etc/resolv.conf

rc-update add metalog default &&
rc-update add bluetooth default &&
rc-update add cupsd default &&
rc-update add dbus default &&
rc-update add elogind boot &&
rc-update add display-manager default &&
rc-update add lvm boot &&
rc-update add NetworkManager default

useradd -m -G users,wheel,audio,cdrom,portage,usb,video,lp,lpadmin,uucp,plugdev -s /bin/bash mod

passwd mod

passwd

history -c && sync

exit

cd

umount -l /mnt/gentoo/dev{/shm,/pts,}

umount -R /mnt/gentoo

exit

exit

exit
