# Storage management

Note that all drive names are purely an example!  
Check the real names of your drives before running any of the commands in these instructions!

## Preparing a drive
Before we use the drive we clear it entirely and initialize it as *GPT*.  
`sudo fdisk /dev/sda << EOF`  
`g`  
`w`  
`EOF`

Next we create a slingle encrypted partition using LUKS.  
`sudo cryptsetup --type luks2 luksFormat --use-random --sector-size 4096 --key-size 512 --pbkdf argon2id --hash sha512 --iter-time 2000 /dev/sda`  
Seting the sector size to 4096 is important for performance as it aligns with the physical sectors of the disk and it is not the default.

## Opening an encrypted partition
Open the encrypted drive */dev/sda* and make it available at *encryptedsda*.  
`sudo cryptsetup --type luks2 open /dev/sda encryptedsda`  
Enter the password when it asks for it, it can be found in KeePass.

## Closing an encrypted partition
Whenever we are done using an encrypted partition it has to be closed before we can disconnect it from the computer.  
`sudo cryptsetup close encryptedsda`

## Importing an existing ZFS pool
To import an existing ZFS pool that belonged to a different computer we have to forcefully import it the first time.
`sudo zpool import -f storage`

## Creating the ZFS pool
ZFS keeps a history of all modifications made to the pool. We don't care about this history so we want it to take up the least possible space. The maximum space the history can occupy is fixed when the pool is initially created and is relative to the initial pool size.

To achieve the smallest history size possible we need to create the smallest possible initial pool. The minimum pool size is 64MiB so that is what we'll use.

A pool can never shrink and it's initial size is the size of the smalest drive that's initially included in the pool.  
Apart from some museums nobody in the universe has a 64MiB drive, so we'll use a trick to create a pool this small.

Create a 64MiB temp file full of 0s which we will use as fake drive.  
`sudo dd if=/dev/zero of=/dev/temp bs=64MiB count=1`

Next create a pool with only this fake drive.  
`sudo zpool create storage /dev/temp -o ashift=12 -o autotrim=on -O compression=lz4`  
An ashift of 12 is the default for modern harddisks, but for a file based pool it needs to be set explicitly. It creates a volume by default that will be mounted to */storage*.

Now we are going to add the first real drive to the pool. After that we will expand the pool to the size of that new drive.  
Remember that a pool cannot be shrunk so it's very important to add the smallest drive first. If you don't you can directly go to start, receive no money and start over.

Connect the smallest real drive to the computer and prepare and open it according to the instructions in the previous chapters.

Attach the drive to the pool.  
`sudo zpool attach storage /dev/temp encryptedsda`

Detach the temp drive.  
`sudo zpool detach storage /dev/temp`

Expand the pool size to fill size of the new disk.  
`sudo zpool online -e storage encryptedsda`

Finally set the permissions right so *mainuser* can access it.  
`sudo chown mainuser:mainuser --recursive /storage`

The pool can now be used to store data!

## Adding the backup drive to the pool
First ttach the backup drive (*/dev/sdb*) to the computer and prepare and open it accurding to the instructions above.

Next add the drive to the pool.  
`sudo zpool attach storage encryptedsda encryptedsdb`

When the drive is added it will automatically resilver, this can take some time.

After the resilvering is done it can be brought offline.

The last thing to do is closing the LUKS partition using the instructions above.

Now the drive can be unplugged to store it in a safe location.

## Syncing the backup drive
First attach the backup drive to the computer.

Now open the LUKS partition and bring the drive online.  
`sudo cryptsetup --type luks2 open /dev/sdb encryptedsdb && sudo zpool online storage encryptedsdb`

Now the backup drive should resilver.
Resilvering happens in the background so we need to manually check  
when it's done using `sudo zpool status`.

After the resilvering finished the pool should be scrubbed.  
`sudo zpool scrub storage`

Then check if the pool is healty.  
`sudo zpool status storage`

Bring the backup drive back offline and close the LUKS partition.  
`sudo zpool offline storage encryptedsdb && sudo cryptsetup close encryptedsdb`

Finally power off the drive.  
`echo 1 | sudo tee /sys/block/sdb/device/delete`

The backup drive can now be detached from the computer.