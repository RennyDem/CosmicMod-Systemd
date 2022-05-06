## The bash block scripts below will be updated to a more fully automated script once it has been further refined. 

source /etc/profile &&
export PS1="(chroot) ${PS1}" &&
mount /dev/sda1 /boot &&
rm stage3-amd64-*.tar.xz &&
echo 'Sync in progress. Please be patient...' &&
emerge --ask --quiet --sync

eselect news list
eselect news read &&
echo 'News will be purged in 2m press ctrl+c to stop if you need to smell the roses' &&
sleep 2m &&
eselect news purge &&
echo 'News successfully purged.'

eselect profile list &&
echo 'Setting selection 8 in 1m, press ctrl+c to cancel and choose differently' &&
sleep 1m &&
eselect profile set 8 &&
echo 'Successfully set profile to 8 - 17.1 plasma stable'

# ls /usr/share/zoneinfo/US
echo 'US/Central' > /etc/timezone

emerge --config sys-libs/timezone-data

emerge --ask --verbose --quiet linux-firmware &&
echo 'Emerging the kernel in 1 minute...' &&
sleep 1m &&
emerge --ask --verbose --quiet gentoo-kernel &&
echo 'Successfully emerged firmware and kernel.'

emerge --ask --verbose --update --deep --newuse --quiet --with-bdeps=y @world

emerge --ask --verbose --quiet vim &&
sleep 1m &&
emerge --ask --depclean &&
eselect editor list &&
echo 'Setting editor to #2 in 1m, press ctrl+c to change' &&
sleep 1m &&
eselect editor set 2 &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
locale-gen &&
eselect locale list &&
echo 'Setting locale to #6 in 1m. Press ctrl+c to change/stop.' &&
sleep 1m &&
eselect locale set 6 &&
eselect locale list &&
env-update &&
source /etc/profile &&
export PS1="(chroot) $PS1" &&
emerge --ask --verbose --quiet net-misc/ntp dosfstools grub

ntpd -q -g &&
hwclock --systohc

# switch to host-env

cp --dereference /etc/default/grub /mnt/gentoo/etc/default/

blkid

# update root=UUID=
vim /etc/default/grub

# back to chroot env

grub-install --target=x86_64-efi --efi-directory=/boot --removable &&
grub-mkconfig -o /boot/grub/grub.cfg &&
emerge --ask --quiet --sync &&
emerge --ask --verbose --quiet kde-plasma/plasma-meta

vim /etc/portage/package.use/circular.use
# add if needed
media-libs/libsndfile minimal
media-sound/mpgChange -pulseaudio

# re-emerge if needed
emerge --verbose --quiet kde-plasma/plasma-meta

eselect news list
eselect news read &&
sleep 1m &&
eselect news purge &&
echo 'News successfully read and purged :D'

# edit circular if needed and clear out file
vim /etc/portage/package.use/circular.use

# from host-env
cp --dereference /etc/conf.d/display-manager /mnt/gentoo/etc/conf.d/ &&
cp --dereference /var/lib/portage/world /mnt/gentoo/var/lib/portage/

# in chroot env
usermod -a -G video sddm &&
emerge --ask --sync --quiet &&
echo 'Updating system in 1m.  Press ctrl+c to stop.' &&
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

rc-update add metalog default &&
rc-update add bluetooth default &&
rc-update add cupsd default &&
rc-update add dbus default &&
rc-update add elogind boot &&
rc-update add display-manager default &&
rc-update add lvm boot &&
rc-update add NetworkManager default &&
rc-update add lm_sensors default &&
echo 'All services sucessfully added'

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

# host-env
poweroff
