# /bin/sh
set -e

scriptPath=`dirname $(realpath $0)`
. $scriptPath/helpers.sh

WaitForZfsResilver() {
	echo "\n\nWAITING FOR RESILVER TO FINISH…"
	local status="$(zpool status storage)"
	while [ $(echo "$status" | grep -c "scrub: resilver in progress for ") != 0 ]
	do
		echo "WAITING FOR RESILVER TO FINISH…"
		sleep 10
		status="$(zpool status storage)"
	done
}

CheckZfsResilverResult() {
	#Wait because zpool status does not show correct status immediately after resilver is done.
	sleep 5
	local status="$(zpool status storage)"
	if [ $(echo "$status" | grep -c "scan: resilvered .* in .* with 0 errors on ") = 0 ]
	then
		Error=1
	fi
}

WaitForZfsScrub() {
	echo "\n\nWAITING FOR SCRUB TO FINISH…"
	local status="$(zpool status storage)"
	while [ $(echo "$status" | grep -c "scan: scrub in progress since ") != 0 ]
	do
		echo "WAITING FOR SCRUB TO FINISH…"
		sleep 10
		status="$(zpool status storage)"
	done
}

CheckZfsScrubResult() {
	#Wait because zpool status does not show correct status immediately after scrub is done.
	sleep 5
	local status="$(zpool status storage)"
	if [ $(echo "$status" | grep -c "scan: scrub repaird 0B in .* with 0 errors on ") == 0 ]
	then
		Error=1
	fi
}

CheckZfsSnapshots
if [ $Error ]
then
	echo "\n\nERROR: ZFS SNAPSHOTS ARE NOT OK!"
	exit
fi
echo "\n\nZFS SNAPSHOTS ARE OK!"

echo "\n\nOPENING ENCRYPTED BACKUP DRIVE…"
cryptsetup --type luks2 open /dev/sdb encryptedsdb

echo "\n\nATTACHING BACKUP DRIVE TO ZFS POOL…"
zpool online storage encryptedsdb

WaitForZfsResilver
CheckZfsResilverResult
if [ $Error ]
then
	echo "\n\nERROR: ZFS RESILVER DID NOT COMPLETE WITHOUT ERRORS!"
	exit
fi
echo "\n\nZFS RESILVER WAS OK!"

if [ "$1" != "-ns" ]
then
	zpool scrub storage
	WaitForZfsScrub
	CheckZfsScrubResult
	if [ $Error ]
	then
		echo "\n\nERROR: ZFS SCRUB DID NOT COMPLETE WITHOUT ERRORS!"
		exit
	fi
	echo "\n\nZFS SCRUB WAS OK!"
fi

echo "\n\nDETACHING BACKUP DRIVE FROM ZFS POOL…"
zpool offline storage encryptedsdb

echo "\n\nCLOSING ENCRYPTED BACKUP DRIVE…"
cryptsetup close encryptedsdb

echo "\n\nBACKUP SUCCESSFULLY COMPLETED!"