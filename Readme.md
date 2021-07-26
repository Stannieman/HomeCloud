# Home cloud

## Hardware and host OS
The current setup uses *Hardkernel*'s *ODROID-HC4* running the Ubuntu flavor of [Armbian](https://www.armbian.com/odroid-hc4/).\
A fixed IP is assigned through DHCP and the cloud is always accessible through that.

## Components
Apart from managing the storage all other functions of the cloud are handled by separate *Docker* containers, each responsible for a single task.\
Check out [Components.md](<./Components.md>) for instructions about adding and maintaining components.

## Storage
*ZFS* is used for the main data storage. The *ZFS* pool is always available and the main volume is mounted to */storage* on the host. This mountpoint is then made available to all *Docker* containers that need it through a mounted volume.

The reasons for using *ZFS* are:
* Data can never silently become corrupted.\
Whenever an attempt is made to read data that has become corrupted it will call you to tell you about it.
* Making backups is easy.\
We use a trick with a mirrored pool here where one drive will be offline most of the time, but there are other ways too.
* The backup drive can be brought offline and can thus be stored in a different physical location.\
This protects it from fires, burglaries and tsunamies.
* *ZFS* natively supports encryption.\
When a drive gets stolen nobody can access the data.

Our *ZFS* pool has compression enabled and there is a subvolume that's encrypted. The pool has 2 drives that are mirrored. The backup drive will be offline most of the time. Whenever it's brought online it resilvers and thus all changes from the main drive are synced to it.

The host OS is responsible for making snapshots and backups and the overall health of the storage pool.

## Maintenance
Twice a week a *ZFS* snapshot will be made automatically.\
Other maintenance like syncing the backup storage drive, scrubbing the storage, updating packages, … should be done manually every Sunday.\
Detailed instructions for this can be find in [Host/Weekly maintenance.md](<Host/Weekly maintenance.md>).

## Setup
Instructions for setting up the host OS can be found in [Host/Host OS setup.md](<Host/Host OS setup.md>).\
Instructions for managing the *ZFS* pool are in [Host/ZFS management.md](<Host/ZFS management.md>).