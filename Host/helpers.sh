GetExpectedSnapshotPattern() {
	if [ "$(date +'%e' -d $1)" = "$(date +'%e' -d today)" ]
	then
		date +"storage@$1 *%a %b %e" -d "$1"
	else
		date +"storage@$1 *%a %b %e" -d "last $1"
	fi
}

CheckZfsSnapshots() {
	local snapshotList="$(zfs list -r -t snapshot -o name,creation storage)"
	if [ $(echo "$snapshotList" | grep -c "storage@") != 2 ] \
		|| [ $(echo "$snapshotList" | grep -c "$(GetExpectedSnapshotPattern wednesday)") != 1 ] \
		|| [ $(echo "$snapshotList" | grep -c "$(GetExpectedSnapshotPattern sunday)") != 1 ]
	then
		Error=1
	fi
}
