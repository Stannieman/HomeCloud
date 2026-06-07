# Host OS setup

## Building the OS image
Open a Linux terminal, this can be done using WSL2.

Install the required tools:  
`sudo apt install docker.io qemu-user-static binfmt-support &&`  
`sudo usermod -aG docker $USER &&`  
`sudo systemctl restart systemd-binfmt`

Clone the this repository:  
`git clone --depth 1 https://github.com/Stannieman/HomeCloud`

Clone the *Armbian build* repository:  
`git clone --depth 1 --branch v25.8.1 https://github.com/armbian/build`  
The *--branch* parameter should be set to the branch of the desired *Armbian* version.

Add the image customization files to the build framework:  
`mkdir -p ./build/userpatches && cp ./HomeCloud/Host/customize-image.sh ./build/userpatches && cp ./HomeCloud/Host/config-homecloud.conf.sh ./build/userpatches`

Build the image:  
`docker run --rm --privileged multiarch/qemu-user-static --reset -p yes &&`  
`./build/compile.sh homecloud REVISION=25.11.1 RELEASE=plucky`  
The *REVISION* parameter should be set to the desired *Armbian* version.  
The *RELEASE* parameter should be set to the desired *Ubuntu* version.

After the build finishes the image will be in `./build/output/images`.

Write the image to the MicroSD card using [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/).

## Installing the OS
**These instructions apply to *Ubuntu Plucky* with the *current* kernel and may need to be updated when using different versions!**

Connecting a display is not needed.  
We can SSH into it using the root account and then run the setup script manualy.

Login as *root* with password *1234*.

Enter the new *root* password (see *KeePass*).

Choose *mainuser* as username for the "normal" user, enter it's password (see *KeePass*) and clear the real name.

Do not set the language based on your location.

Choose to not generate locales.

You are now still logged in as root, you should log out and switch to the *mainuser* account:  
`exit`

Now log in with *mainuser*.

Update, remove and add packages:  
`sudo apt update &&`  
`sudo apt remove armbian-config &&`  
`sudo apt upgrade -y &&`  
`sudo apt install zfs-dkms &&`  
`sudo apt autoremove -y`

Change the scheduled times of the default cron jobs in the */etc/crontab* file.  
Use
* `0  *    * * *` for the hourly job.
* `0  2    * * *` for the daily job.
* `0  6    * * 0` for the weekly job.
* `0  5    1 * *` for the monthly job.

## Check out this repository
`git clone https://www.github.com/Stannieman/HomeCloud`

## Configuring the storage drives
To make all storage drives go to sleep after a period of inactivity,  
add a task for each drive that sets the drive's power management properties at startup.  
Add this line to the */etc/crontab* file for each drive:  
`echo '@reboot root hdparm -S 120 -B 254 /dev/sda' | sudo tee -a /etc/crontab`  
120 means we let the drive spin down when it's been idle for 10 minutes,  
254 is the *APM* mode which is drive specific.  
*/dev/sda* needs to be replaced with the actual drive's path.

## Set up the storage
Set up the storage using the instructions in [Storage management.md](<./Storage management.md>).  
If a storage pool already exists you can just import it and start using that one.

## Set up the components
Set up all required components using the instructions in [../Components.md](<../Components.md>).
