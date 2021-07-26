# Host OS setup

## Writing the OS to the MicroSD card
Download the latest version of [Armbian](https://www.armbian.com/odroid-hc4/).

Extract the *.img* image.

Write the image to the MicroSD card using [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/).

## Installing the OS
Enter the root password (see *KeePass*).

Select *Bash* as default shell.

Choose *mainuser* as username for the "normal" user, enter it's password (see *KeePass*) and clear the real name.

You are now still logged in as root, you should log out and switch to the *mainuser* account:\
`logout`

Now log in with *mainuser*.

Remove unused packages:\
`sudo apt remove fake-hwclock bsdmainutils cracklib-runtime`

Update all existing packages:\
`sudo apt update && sudo apt upgrade`

Add packages:\
`sudo apt install linux-headers-current-meson64 zfs-dkms zfsutils-linux docker.io docker-compose`

Remove stale packages:\
`sudo apt autoremove`

Remove unused scheduled tasks:\
`sudo rm /etc/cron.hourly/fake-hwclock` (Saving time to disk.)\
`sudo rm /etc/cron.daily/apt-compat` (Automatic package updates.)\
`sudo rm /etc/cron.daily/aptitude` (Save an overview of package states.)\
`sudo rm /etc/cron.daily/bsdmainutils` (Calendar maintenance script.)\
`sudo rm /etc/cron.daily/dpkg` (Backup dpkg database.)\
`sudo rm /etc/cron.daily/man-db` (Rebuilds man-db database.)\
`sudo rm /etc/cron.daily/sysstat` (Generates process statistics.)\
`sudo rm /etc/cron.daily/cracklib-runtime` (Maintains a database for password security checking.)\
`sudo rm /etc/cron.weekly/man-db` (Rebuilds man-db database.)\
`sudo rm /etc/cron.d/zfsutils-linux` (Trims and scrubs ZFS, we do this ourself.)\
`sudo rm /etc/cron.d/sysstat` (Logs system statistics.)\
`sudo rm /etc/cron.d/armbian-updates` (Automatic package updates.)

Change the scheduled times of the default cron jobs in the */etc/crontab* file.\
Use
* `0  *    * * *` for the hourly job.
* `0  2    * * *` for the daily job.
* `0  6    * * 0` for the weekly job.
* `0  5    1 * *` for the monthly job.

## Configuring the storage drives
To make all storage drives go to sleep after a period of inactivity,\
add a task for each drive that set the drive's power management properties at startup.\
Add this line to the */etc/crontab* file for each drive:\
`@reboot root hdparm -S 120 -B 254 /dev/sda`\
120 means we let the drive spin down when it's been idle for 10 minutes,\
254 is the *APM* mode which is drive specific.\
*/dev/sda* needs to be replaced with the actual drive's path.

## Configuring bi-weekly ZFS snapshots
Add 2 lines to the */etc/crontab* file to automatically make a snapshot every Wednesday and Sunday morning.\
`0  4    * * 0 root zfs destroy -r storage@sunday;zfs snapshot -r storage@sunday`\
`0  4    * * 3 root zfs destroy -r storage@wednesday;zfs snapshot -r storage@wednesday`

## Setting up Docker
The *Docker* containers for components that require network access connect to a network called *nat*. This network must be created:\
`sudo docker network create nat`

Also create the */docker* directory and add the dummy *docker-compose.yml* file to it.

## Add the start containers script.
Put the *start<area>.sh* script in the home directory of *mainuser*.