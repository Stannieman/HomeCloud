# Weekly maintenance

## Backup the storage
First check that the automatic snapshots are still being made:\
`sudo zfs list -t snapshot -o name,creation`

Then sync the backup drive using the instructions from [ZFS management.md](<./ZFS management.md>).

## Update packages and reboot
Stop all components:\
`sudo docker stop $(sudo docker ps -q)`

Update all packages:\
`sudo apt update && sudo apt upgrade -y`

Reboot the computer:\
`reboot`

Mount the storage and start the components:\
`sudo HomeCloud/Host/start.sh`\
Enter the storage password when asked.