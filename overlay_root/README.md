This dracut module will run in pre-pivot stage. That the stage just before switching to root fs.
In Opensuse 42.3, the hdd will be mounted in /sysroot
This script will remount the hdd to /os. Create overlay fs in /sysroot instead

To install this module:
- Copy the this folder to /usr/lib/dracut/modules.d/
- Add the kernel command line to grub in /etc/default/grub
- Remake the grub file with grub2-mkconfig
- (obsolete)Add overlay fs to initramfs : create the file /etc/dracut.conf.d/overlay.conf/overlay.conf with force_drivers+="overlay"
- Remake initramfs with : dracut --force -M /boot/initrd-KERNELNUM KERNELNUM

- To generate a fat initramfs, that include almost all kernel module, (equivalent of -A in obsolete mkinitrd) : use --no-hostonly --no-hostonly-cmdline




