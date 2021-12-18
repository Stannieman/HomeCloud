# /bin/sh
set -e

scriptPath=`dirname $(realpath $0)`
. $scriptPath/helpers.sh

WaitForZfsResilver() {
	local status="$(zpool status storage)"
	while [ $(echo "$status" | grep -c "scrub: resilver in progress for ") != 0 ]
	do
		echo Waiting for resilver to finish…
		sleep 10
		$status=$(zpool status storage)
	done
}

CheckZfsResilverResult() {
	local status="$(zpool status storage)"
	if [ $(echo "$status" | grep -c "scan: resilvered .* in .* with 0 errors on ") == 0 ]
	then
		ERROR=1
	fi
}

WaitForZfsScrub() {
	local status="$(zpool status storage)"
	while [ $(echo "$status" | grep -c "scan: scrub in progress since ") != 0 ]
	do
		echo Waiting for scrub to finish…
		sleep 10
		$status=$(zpool status storage)
	done
}

CheckZfsScrubResult() {
	local STATUS="$(zpool status storage)"
	if [ $(echo "$status" | grep -c "scan: scrub repaird 0B in .* with 0 errors on ") == 0 ]
	then
		ERROR=1
	fi
}

CheckZfsSnapshots
if [ $ERROR ]
then
	echo Error: ZFS snapshots are not OK!
	exit
fi
echo ZFS snapshots are OK!

echo Opening encrypted backup drive…
cryptsetup --type luks2 open /dev/sdb encryptedsdb

echo Attaching backup drive to ZFS pool…
zpool online storage encryptedsdb

WaitForZfsResilver
CheckZfsResilverResult
if [ $ERROR ]
then
	echo Error: ZFS resilver did not complete without errors!
	exit
fi
echo ZFS resilver was OK!

if [ "$@" != "-ns" ]
then
	zpool scrub storage
	WaitForZfsScrub
	CheckZfsScrubResult
	if [ $ERROR ]
	then
		echo Error: ZFS scrub did not complete without errors!
		exit
	fi
	echo ZFS scrub was OK!
fi

echo Detaching backup drive from ZFS pool…
zpool offline storage encryptedsdb

echo Closing encrypted backup drive…
cryptsetup close encryptedsdb

echo Backup successfully completed!