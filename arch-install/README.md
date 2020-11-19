# Arch Installation Notes

```
timedatectl set-ntp true

reflector -c "United States" -a 12 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syy

lsblk
```

Choose the correct disk (example /dev/sda)
```
gdisk /dev/sda
```
Options are:
+ n - new parition
+ w - write partions
+ q - quit

```
mkfs.fat -F32 /dev/sda1

mkswap /dev/sda2
swapon /dev/sda2

mkfs.ext4 /dev/sda3
```

Mount drives
```
mount /dev/sda3 /mnt

mkdir -vp /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```

pacstrap
```
pacstrap /mnt base base-devel linux linux-firmware vim intel-ucode

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

hwclock --systohc
```

Uncomment en_US.UTF-8
```
vim /etc/locale.gen
```

```
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

Create hostname
```
vim /etc/hostname
```

Edit hosts file
```
vim /etc/hosts
```

Add to hosts
```
127.0.0.1	localhost
::1		localhost
127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME
```

Create Root password
```
passwd
```

Install Packages
```
pacman -S grub efibootmgr networkmanager network-manager-applet dialog mtools dosfstools linux-headers cups hplip alsa-utils pulseaudio ufw git reflector xdg-utils xdg-user-dirs gdisk
```

Configure Grub
```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg
```

Enable Service with Systemd
```
systemctl enable NetworkManager

systemctl enable ufw

systemctl org.cups.cupsd
```

Exit, umount, reboot
```
exit

umount -a

reboot
```
