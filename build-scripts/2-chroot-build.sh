##  This code section is not relevant for most people it just has scripts for building/compiling the disk image. 
##  The fully built disk image is already provided in the releases section of the Wiki.

source /etc/profile &&
export PS1="(chroot) ${PS1}" &&
mount /dev/sda1 /boot &&
rm stage3-amd64-*.tar.xz &&
echo 'Sync in progress. Please be patient...' &&
emerge --ask --quiet --sync

eselect news purge &&
eselect profile list &&
echo 'Setting selection 8 in 1m, press ctrl+c to cancel and choose differently' &&
sleep 1m &&
eselect profile set 8 &&
echo 'Successfully set profile to 8 - 17.1 plasma stable'

# ls /usr/share/zoneinfo/US
echo 'US/Central' > /etc/timezone

emerge --config sys-libs/timezone-data

emerge --ask --verbose --quiet linux-firmware &&
echo 'Emerging the kernel in 1 minute... Get ready baby!' &&
sleep 1m &&
emerge --ask --verbose --quiet gentoo-kernel &&
echo 'Successfully emerged firmware and kernel. Oh yeah!'

emerge --ask --verbose --update --deep --newuse --quiet --with-bdeps=y @world

emerge --ask --verbose --quiet vim &&
sleep 1m &&
emerge --ask --depclean &&
eselect editor list &&
echo 'Setting editor to #2 in 1m. Press ctrl+c to change, hmph!' &&
sleep 1m &&
eselect editor set 2 &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
locale-gen &&
eselect locale list &&
echo 'Setting locale to #6 in 1m. Press ctrl+c to change/stop, okay?' &&
sleep 1m &&
eselect locale set 6 &&
eselect locale list &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
emerge --ask --verbose --quiet net-misc/ntp dosfstools grub

ntpd -q -g &&
hwclock --systohc

# from host-env

cp --dereference /etc/default/grub /mnt/gentoo/etc/default/

blkid

# in chroot env

# update root=UUID=
vim /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --removable &&
grub-mkconfig -o /boot/grub/grub.cfg

emerge --ask --quiet --sync &&
emerge --ask --verbose --quiet kde-plasma/plasma-meta &&
emerge --ask sys-apps/flatpak &&
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &&
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

vim /etc/portage/package.use/circular.use
# add if needed
media-libs/libsndfile minimal
media-sound/mpg123 -sdl
media-libs/libsdl2 -pulseaudio

# re-emerge if needed
emerge --verbose --quiet kde-plasma/plasma-meta

eselect news read &&
eselect news purge

# edit circular if needed and clear out file
vim /etc/portage/package.use/circular.use

# from host-env
cp --dereference /etc/conf.d/display-manager /mnt/gentoo/etc/conf.d/ &&
cp --dereference /var/lib/portage/world /mnt/gentoo/var/lib/portage/

# in chroot env
usermod -a -G video sddm &&
emerge --sync --quiet &&
echo 'Shhh... Updating system in 1m.  Press ctrl+c to stop.' &&
sleep 1m &&
emerge --ask --verbose --quiet --update --deep --newuse --with-bdeps=y @world

eselect news list
eselect news read &&
sleep 1m &&
eselect news purge &&
revdep-rebuild

eselect fontconfig enable \
1 2 3 4 5 6 7 8 9 10 \
11 12 13 14 15 16 17 18 19 20 \
21 22 23 24 25 26 27 28 29 30 \
31 32 33 34 35 36 37 38 39 40 \
41 42 43 44 45 46 47 48 49 50 \
51 52 53 54 55 56 57 58 59 60 \
61 62 63 64 65 66 67 68 69 70
eselect fontconfig list

env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
emerge --ask --depclean &&
echo 'Cleaning old distfiles in 1m...' &&
sleep 1m &&
eclean -d distfiles &&
echo 'Script successfully completed :P'

vim /etc/resolv.conf

systemctl enable bluetooth.service && #used https://askubuntu.com/questions/744640/best-way-to-deactivate-bluetooth-on-system-startup-with-systemd-and-not-upstar as a guide
systemctl enable cups.service && #used https://wiki.archlinux.org/title/CUPS as a source (source as in material of information, not source code)
systemctl enable systemd-logind.service &&
systemctl enable sddm.service && # forgot the source for this thingmajig, this looks good though: https://wiki.gentoo.org/wiki/SDDM#systemd
systemctl enable lvm2-monitor.service && #from https://wiki.gentoo.org/wiki/LVM#systemd
systemctl enable NetworkManager && #from https://wiki.gentoo.org/wiki/NetworkManager#systemd
systemctl enable lm_sensors && #from https://wiki.gentoo.org/wiki/Lm_sensors#systemd
echo 'All services sucessfully enabled, my man!'

useradd -m -G users,wheel,audio,cdrom,portage,usb,video,lp,lpadmin,uucp,plugdev -s /bin/bash mod

passwd mod

passwd

sync &&
history -c && 
exit

cd

umount -l /mnt/gentoo/dev{/shm,/pts,} &&
umount -R /mnt/gentoo &&
exit

exit

exit

# from host-env
poweroff
