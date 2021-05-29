source /etc/profile &&
export PS1="(chroot) ${PS1}" &&
mount /dev/sda1 /boot &&
rm stage3-amd64-*.tar.xz &&
emerge --sync

eselect news list
eselect news read &&
sleep 2m &&
eselect news purge &&
echo 'news successfully purged'

eselect profile list &&
echo 'Setting selection 8 in 1m' &&
sleep 1m &&
eselect profile set 8 &&
echo 'Successfully set profile to 8 - 17.1 plasma stable'

# ls /usr/share/zoneinfo/US
echo "US/Central" > /etc/timezone

emerge --config sys-libs/timezone-data

emerge --ask --verbose linux-firmware &&
echo 'emerging the kernel in 1 minute' &&
sleep 1m &&
emerge --ask --verbose --quiet gentoo-kernel &&
echo 'Successfully emerged firmware and kernel'

emerge --sync &&
echo 'Updating the system in 1 minute' &&
sleep 1m &&
emerge --ask --verbose --update --deep --newuse --quiet --with-bdeps=y @world

# Host-env
# vim /mnt/gentoo/etc/portage/package.use/circular.use

emerge --ask --verbose --update --deep --newuse --quiet --with-bdeps=y @world

paperconfig -p letter

emerge --ask --verbose --quiet vim &&
sleep 1m &&
emerge --ask --depclean &&
eselect editor list &&
sleep 1m &&
echo 'Setting editor to #2 in 1m, press ctrl+c to change' &&
eselect editor set 2 &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
locale-gen &&
eselect locale list &&
sleep 1m &&
echo 'Setting locale to #6 in 1m press ctrl+c to change' &&
eselect locale set 6 &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
emerge --ask --verbose --quiet net-misc/ntp dosfstools grub

ntpd -q -g &&
hwclock --systohc

# host-env
# cp --dereference /etc/default/grub /mnt/gentoo/etc/default/
# blkid
# update root=UUID=
vim /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --removable &&
grub-mkconfig -o /boot/grub/grub.cfg

emerge --ask --verbose --quiet kde-plasma/plasma-meta

eselect news list
sleep 1m &&
eselect news read &&
sleep 1m &&
eselect news purge &&
echo 'news successfully read and purged'

# host-env
# cp --dereference /etc/conf.d/display-manager /mnt/gentoo/etc/conf.d/

usermod -a -G video sddm

# host-env
# cp --dereference /var/lib/portage/world /mnt/gentoo/var/lib/portage/

emerge --ask --sync &&
sleep 1m &&
emerge --ask --verbose --update --deep --newuse --quiet --with-bdeps=y @world

eselect news list
eselect news read &&
sleep 1m &&
eselect news purge &&
revdep-rebuild

eselect fontconfig enable 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 25 26 28 29 30 31 37 38 39 40 41 42 45 46 48 50 51 52 53 54 56 57 58 61 62 &&
eselect fontconfig list &&
sleep 1m &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
emerge --ask --depclean &&
echo 'cleaning old distfiles in 1m' &&
sleep 1m &&
eclean -d distfiles &&
echo 'script successfully completed'

vim /etc/resolv.conf

rc-update add metalog default &&
rc-update add bluetooth default &&
rc-update add cupsd default &&
rc-update add dbus default &&
rc-update add elogind boot &&
rc-update add display-manager default &&
rc-update add lvm boot &&
rc-update add NetworkManager default &&
echo 'All services sucessfully added'

useradd -m -G users,wheel,audio,cdrom,portage,usb,video,lp,lpadmin,uucp,plugdev -s /bin/bash mod

passwd mod

passwd

sync 
&& history -c && 
exit

cd

umount -l /mnt/gentoo/dev{/shm,/pts,} &&
umount -R /mnt/gentoo &&
exit

exit

exit
