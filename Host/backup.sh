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
	if [ $(echo "$status" | grep -c "scan: resilvered .* in .* with 0 errors on ") = 0 ]
	then
		Error=1
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
	local status="$(zpool status storage)"
	if [ $(echo "$status" | grep -c "scan: scrub repaird 0B in .* with 0 errors on ") == 0 ]
	then
		Error=1
	fi
}

CheckZfsSnapshots
if [ $Error ]
then
	echo -e "\n\nERROR: ZFS SNAPSHOTS ARE NOT OK!"
	exit
fi
echo -e "\n\nZFS SNAPSHOTS ARE OK!"

echo -e "\n\nOPENING ENCRYPTED BACKUP DRIVE…"
cryptsetup --type luks2 open /dev/sdb encryptedsdb

echo -e "\n\nATTACHING BACKUP DRIVE TO ZFS POOL…"
zpool online storage encryptedsdb

WaitForZfsResilver
CheckZfsResilverResult
if [ $Error ]
then
	echo -e "\n\nERROR: ZFS RESILVER DID NOT COMPLETE WITHOUT ERRORS!"
	exit
fi
echo -e "\n\nZFS RESILVER WAS OK!"

if [ "$1" != "-ns" ]
then
	zpool scrub storage
	WaitForZfsScrub
	CheckZfsScrubResult
	if [ $Error ]
	then
		echo -e "\n\nERROR: ZFS SCRUB DID NOT COMPLETE WITHOUT ERRORS!"
		exit
	fi
	echo -e "\n\nZFS SCRUB WAS OK!"
fi

echo -e "\n\nDETACHING BACKUP DRIVE FROM ZFS POOL…"
zpool offline storage encryptedsdb

echo -e "\n\nCLOSING ENCRYPTED BACKUP DRIVE…"
cryptsetup close encryptedsdb

echo -e "\n\nBACKUP SUCCESSFULLY COMPLETED!"