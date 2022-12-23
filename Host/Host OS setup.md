# Host OS setup

## Building the OS image
Open a Linux terminal, this can be done using WSL2.

Clone the *Armbian build* repository:\
`git clone --depth 1 https://github.com/armbian/build `

Build the image:\
`sudo ./build/compile.sh docker BOARD=odroidhc4 BRANCH=current LIB_TAG=v22.11 RELEASE=kinetic BUILD_MINIMAL=yes BUILD_DESKTOP=no KERNEL_CONFIGURE=no COMPRESS_OUTPUTIMAGE=img INSTALL_HEADERS=yes SKIP_BOOTSPLASH=yes EXTRAWIFI=no WIREGUARD=no AUFS=no BUILD_ONLY=u-boot,kernel,armbian-firmware,armbian-bsp`\
The *BRANCH* parameter can be *current* or *edge* depending on the desired kernel.\
The *LIB_TAG* parameter should be set to the desired Armbian version.\
The *RELEASE* parameter should be set to the desired *Ubuntu* version.

After the build finishes the image will be in `./build/output/images`.

Write the image to the MicroSD card using [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/).

## Installing the OS
**These instructions apply to *Ubuntu Jammy* with the *current* kernel and may need to be updated when using different versions!**

Connecting a display is not needed.\
We can SSH into it using the root account and then run the setup script manualy.

Login as *root* with password *1234*.

Enter the new *root* password (see *KeePass*).

Choose *mainuser* as username for the "normal" user, enter it's password (see *KeePass*) and clear the real name.

Do not set the language based on your location.

Choose to not generate locales.

You are now still logged in as root, you should log out and switch to the *mainuser* account:\
`logout`

Now log in with *mainuser*.

Change the timezone to UTC:\
`sudo timedatectl set-timezone UTC`

Remove unused packages:\
`sudo apt remove -y fake-hwclock cracklib-runtime wireless-regdb wireless-tools wpasupplicant nano armbian-plymouth-theme`

Update all existing packages:\
`sudo apt update`\
`sudo apt upgrade -y`

Add packages:\
`sudo apt install -y hdparm zfs-dkms zfsutils-linux cryptsetup docker.io docker-compose vim git`
This will take a long time because it has to compile the *ZFS* kernel module from source.

Remove stale packages:\
`sudo apt autoremove -y`

Remove unused scheduled tasks:\
`sudo rm /etc/cron.hourly/fake-hwclock` (Saving time to disk.)\
`sudo rm /etc/cron.daily/apt-compat` (Automatic package updates.)\
`sudo rm /etc/cron.daily/dpkg` (Backup dpkg database.)\
`sudo rm /etc/cron.daily/sysstat` (Generates process statistics.)\
`sudo rm /etc/cron.daily/cracklib-runtime` (Maintains a database for password security checking.)\
`sudo rm /etc/cron.weekly/armbian-quotes` (Refreshes message of the day on SSH login prompt.)\
`sudo rm /etc/cron.d/zfsutils-linux` (Trims and scrubs ZFS, we do this ourself.)\
`sudo rm /etc/cron.d/sysstat` (Logs system statistics.)\
`sudo rm /etc/cron.d/armbian-updates` (Automatic package updates.)\
`sudo rm /etc/cron.d/armbian-check-battery` (Shuts down when battery is low.)

Change the scheduled times of the default cron jobs in the */etc/crontab* file.\
Use
* `0  *    * * *` for the hourly job.
* `0  2    * * *` for the daily job.
* `0  6    * * 0` for the weekly job.
* `0  5    1 * *` for the monthly job.

Change the hostname and add it to the hosts file.\
`echo 'server' | sudo tee /etc/hostname`\
`echo '127.0.0.1 server' | sudo tee -a /etc/hosts`

## Check out this repository
`git clone https://www.github.com/Stannieman/HomeCloud`

## Setting up Docker
Also create the */docker* directory and add the dummy *docker-compose.yml* file to it:\
`sudo mkdir /docker`\
`sudo cp HomeCloud/Host/docker-compose.yml /docker/`

## Make the scripts executable.
`chmod +x HomeCloud/Host/start.sh &&`\
`chmod +x HomeCloud/Host/createStorageSnapshot.sh &&`\
`chmod +x HomeCloud/Host/checkHealth.sh &&`\
`chmod +x HomeCloud/Host/backup.sh &&`\
`chmod +x HomeCloud/Host/update.sh`

## Configuring the storage drives
To make all storage drives go to sleep after a period of inactivity,\
add a task for each drive that sets the drive's power management properties at startup.\
Add this line to the */etc/crontab* file for each drive:\
`echo '@reboot root hdparm -S 120 -B 254 /dev/sda' | sudo tee -a /etc/crontab`\
120 means we let the drive spin down when it's been idle for 10 minutes,\
254 is the *APM* mode which is drive specific.\
*/dev/sda* needs to be replaced with the actual drive's path.

## Configuring bi-weekly ZFS snapshots
Add 2 lines to the */etc/crontab* file to automatically make a snapshot every Wednesday and Sunday morning.\
`echo '0  4    * * 0 root /home/mainuser/HomeCloud/Host/createStorageSnapshot.sh' | sudo tee -a /etc/crontab`\
`echo '0  4    * * 3 root /home/mainuser/HomeCloud/Host/createStorageSnapshot.sh' | sudo tee -a /etc/crontab`

## Set up the storage
Set up the storage using the instructions in [Storage management.md](<./Storage management.md>).\
If a storage pool already exists you can just import it and start using that one.

## Add the health check
Add 1 line to the */etc/crontab* file to automatically do a health check every week.\
`echo '0  5    * * 0 root /home/mainuser/HomeCloud/Host/checkHealth.sh' | sudo tee -a /etc/crontab`

## Set up the components
Set up all required components using the instructions in [../Components.md](<../Components.md>).
