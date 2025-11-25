#!/bin/sh
set -e

# Prevent the partition from expanding to the full available space.
echo 4294967296B > /root/.rootfs_resize

# Set the hostname.
echo 'server' > /etc/hostname
printf "\n127.0.0.1 server\n" >> /etc/hosts
sed -i '/^$/d' /etc/hosts

# Adjust fancontrol configuration for Noctua fan.
sed -i '/^MINTEMP=.*$/d' /etc/fancontrol
sed -i '/^MAXTEMP=.*$/d' /etc/fancontrol
sed -i '/^MINSTART=.*$/d' /etc/fancontrol
sed -i '/^MINSTOP=.*$/d' /etc/fancontrol
sed -i '/^MINPWM=.*$/d' /etc/fancontrol
sed -i '/^MAXPWM=.*$/d' /etc/fancontrol
printf "\nMINTEMP=hwmon2/pwm1=65" >> /etc/fancontrol
printf "\nMAXTEMP=hwmon2/pwm1=70" >> /etc/fancontrol
printf "\nMINSTART=hwmon2/pwm1=150" >> /etc/fancontrol
printf "\nMINSTOP=hwmon2/pwm1=1" >> /etc/fancontrol
printf "\nMINPWM=hwmon2/pwm1=1" >> /etc/fancontrol
printf "\nMAXPWM=hwmon2/pwm1=180\n" >> /etc/fancontrol
sed -i '/^$/d' /etc/fancontrol

# Add and remove packages.
# This will take a long time because it has to compile the *ZFS* kernel module from source.
apt update
apt remove -y alsa-utils debsums dosfstools fake-hwclock kbd libcaca0 man-db nano wireguard-tools wpasupplicant
apt install -y hdparm zfsutils-linux cryptsetup vim git
apt autoremove -y
apt clean

# Remove unused scheduled tasks.
rm /etc/cron.*/fake-hwclock # Saving time to disk.
rm /etc/cron.*/apt-compat # Automatic package updates.
rm /etc/cron.*/dpkg # Backup dpkg database.
rm /etc/cron.*/debsums # Verifies integrity of installed packages.
rm /etc/cron.*/man-db # Updates man database.
rm /etc/cron.*/armbian-quotes # Refreshes message of the day on SSH login prompt.
rm /etc/cron.*/zfsutils-linux # Trims and scrubs ZFS, we do this ourself.
rm /etc/cron.*/armbian-updates # Automatic package updates.
rm /etc/cron.*/armbian-check-battery # Shuts down when battery is low.

# Configure ZFS snapshots to be made every Wednesday and Sunday morning.
printf "\n0  4    * * 0 root /home/mainuser/HomeCloud/Host/createStorageSnapshot.sh" >> /etc/crontab
printf "\n0  4    * * 3 root /home/mainuser/HomeCloud/Host/createStorageSnapshot.sh" >> /etc/crontab

# Configure a ZFS health check to occur every Sunday morning.
printf "\n0  5    * * 0 root /home/mainuser/HomeCloud/Host/checkHealth.sh\n" >> /etc/crontab

sed -i '/^$/d' /etc/crontab
