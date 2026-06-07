# Weekly maintenance

## Backup the storage
First check that the automatic snapshots are still being made:\
`sudo zfs list -t snapshot -o name,creation`


Then sync the backup drive using the instructions from [ZFS management.md](<./ZFS management.md>).\
In short:

Attach the drive to the computer.

Run the commands to sync the backup drive:\
`sudo zpool online /dev/sdb && sudo zpool scrub storage && sudo zpool status storage && sudo zpool offline storage /dev/sdb`

Verify that the status command did not report any problems\
and detach the drive from the computer.

## Update packages and reboot
Stop all components:\
`sudo docker stop $(sudo docker ps -q)`

Update all packages:\
`sudo apt update && sudo apt upgrade -y`

Reboot the computer:\
`reboot`

Mount the storage and start the components:\
`sudo ~/start.sh`\
Enter the storage password when asked.