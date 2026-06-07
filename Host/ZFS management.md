# ZFS management

Note that all drive names are purely an example!\
Check the real names of your drives before running any of the commands in these instructions!

## Mounting
Mounting is handled by the host os. We don't need to worry about it here.

## Creating the pool
ZFS keeps a history of all modifications made to the pool. We don't care about this history so we want it to take up the least possible space. The maximum space the history can occupy is fixed when the pool is initially created and is relative to the initial pool size.

To achieve the smallest history size possible we need to create the smallest possible initial pool. The minimum pool size is 64MiB so that is what we'll use.

A pool can never shrink and it's initial size is the size of the smalest drive that's initially included in the pool.\
Apart from some museums nobody in the universe has a 64MiB drive, so we'll use a trick to create a pool this small.

Create a 64MiB temp file full of 0s which we will use as fake drive:\
`sudo dd if=/dev/zero of=/dev/temp bs=64MiB count=1`

Next create a pool with only this fake drive:\
`sudo zpool create storage /dev/temp -o ashift=12 -o autotrim=on -O compression=lz4 -O mountpoint=none`\
An ashift of 12 is the default for modern harddisks, but for a file based pool it needs to be set explicitly.

Now we are going to add the first real drive to the pool. After that we will expand the pool to the size of that new drive.\
Remember that a pool cannot be shrunk so it's very important to add the smallest drive first. If you don't you can directly go to start, receive no money and start over.

Connect the smallest real drive to the computer.

Attach the drive to the pool:\
`sudo zpool attach storage /dev/temp /dev/sda`

Detach the temp drive:\
`sudo zpool detach storage /dev/temp`

Expand the pool size to fill size of the new disk:\
`sudo zpool online -e storage /dev/sda`

Create the encrypted volume where all data will be stored in:\
`sudo zfs create -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt -o mountpoint=/storage storage/encrypted`\
The password can be found in KeePass.

Finally set the permissions right so *mainuser* can access it:\
`sudo chown mainuser:mainuser --recursive /storage`

The pool can now be used to store data!

## Adding the backup drive to the pool
First attach the backup drive to the computer.

Next add the drive to the pool:\
`sudo zpool attach storage /dev/sda /dev/sdb`

When the drive is added it will automatically resilver, this can take some time.

After the resilvering is done it can be brought offline:\
`sudo zpool offline storage /dev/sdb`

Now the drive can be unplugged to store it in a safe location.

## Syncing the backup drive
First attach the backup drive to the computer.

Then bring the drive offline:\
`sudo zpool online /dev/sdb`

Now the backup drive should resilver.

After the resilvering finished the pool should be scrubbed:\
`sudo zpool scrub storage`

Then check if the pool is healty:\
`sudo zpool status storage`

Finally bring the backup drive back offline:\
`sudo zpool offline storage /dev/sdb`

The backup drive can now be detached from the computer.