# Home cloud

## Hardware and host OS
The current setup uses *Hardkernel*'s *ODROID-HC4* running the Ubuntu flavor of [Armbian](https://www.armbian.com/odroid-hc4/).\
A fixed IP is assigned through DHCP and the cloud is always accessible through that.

## Components
Apart from managing the storage all other functions of the cloud are handled by separate *Docker* containers, each responsible for a single task.\
Check out [Components.md](<./Components.md>) for instructions about adding and maintaining components.

## Storage
The storage is always available and mounted to */storage* on the host. This mountpoint is then made available to all *Docker* containers that need it through a mounted volume.

### File system
*ZFS* is used as the file system for the main data storage.\
Why?
* Data can never silently become corrupted.\
Whenever an attempt is made to read data that has become corrupted it will call you to tell you about it.
* Making backups is easy.\
We use a trick with a mirrored pool here where one drive will be offline most of the time, but there are other ways too.
* The backup drive can be brought offline and can thus be stored in a different physical location.\
This protects it from fires, burglaries and tsunamies.

The *ZFS* pool has copression is enabled to save space.\
It 2 drives that are mirrored in order to have a backup. The backup drive will be offline most of the time but when it's brought online it resilvers so that all changes from the main drive are synced to it.

The host OS is responsible for making snapshots and backups and the overall health of the storage pool.

### Encryption
When someone "takes a look" at our drives we of course don't want them to see what's on there.\
To prevent just that we use *LUKS* to encrypt the partitions on the drives that are used for our storage.

Why *LUKS*?
* It is faster than *ZFS* encryption.\
While *ZFS* supports encryption natively it does not use the crypto extensions present in our CPU. This causes the encryption to be so slow that the CPU becomes a bottleneck.\
*LUKS* does make use of these crypto extensions.
* It is more secure than *ZFS* encryption.\
*ZFS* encrypts the data blocks but bot the metadata.\
With *LUKS* the entire partition is encrypted.

Instead we use *LUKS* to encrypt

## Maintenance
Twice a week a *ZFS* snapshot will be made automatically.\
These snapshots will periodically be checked and file starting with *OK* or *ERROR* will be written to the root of the storage indicating success or failure.

Other maintenance like syncing the backup storage drive, scrubbing the storage, updating packages, … should be done manually every Sunday.\
Detailed instructions for this can be find in [Host/Weekly maintenance.md](<Host/Weekly maintenance.md>).

## Setup
Instructions for setting up the host OS can be found in [Host/Host OS setup.md](<Host/Host OS setup.md>).\
Instructions for managing the storage are in [Host/Storage management.md](<Host/Storage management.md>).