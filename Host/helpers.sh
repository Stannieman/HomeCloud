GetExpectedSnapshotPattern() {
	if [ "$(date +'%d' -d $1)" = "$(date +'%d' -d today)" ]
	then
		date +"storage@$1 *%a %b %d" -d "$1"
	else
		date +"storage@$1 *%a %b %d" -d "last $1"
	fi
}

CheckZfsSnapshots() {
	local SNAPSHOT_LIST=$(zfs list -r -t snapshot -o name,creation storage)
	if [ $(echo "$SNAPSHOT_LIST" | grep -c "storage@") != 2 ] \
		|| [ $(echo "$SNAPSHOT_LIST" | grep -c "$(get_expected_snapshot_date wednesday)") != 1 ] \
		|| [ $(echo "$SNAPSHOT_LIST" | grep -c "$(get_expected_snapshot_date sunday)") != 1 ]
	then
		ERROR=1
	fi
}