# Weekly maintenance

## Backup the storage
First check that the automatic snapshots are still being made.  
`sudo zfs list -t snapshot -o name,creation`

Then sync the backup drive using the instructions from [ZFS management.md](<./ZFS management.md>).

For convenience you can use the backup script for this.  
`sudo HomeCloud/Host/backup.sh`  
Run with `-ns` to skip scrubbing the *ZFS* pool.

## Update packages and reboot
Stop all components:  
`sudo docker stop $(sudo docker ps -q)`

Update all packages:  
`sudo apt update &&`  
`sudo apt upgrade -y`

Reboot:  
`reboot`

If the kernel is updated then also *zfs-dkms* needs to be reinstalled.  
This will recompile the *ZFS* kernel module for the new kernel.  
`sudo apt reinstall zfs-dkms -y`

For convenience you can use the update scripts for this.  
`sudo HomeCloud/Host/updatePreReboot.sh`  
`sudo HomeCloud/Host/updatePostReboot.sh`

Mount the storage and start the components:  
`sudo HomeCloud/Host/start.sh`  
Enter the storage password when asked.