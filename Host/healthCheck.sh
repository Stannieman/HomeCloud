#!/bin/bash 
set -e

scriptPath=`dirname $(realpath $0)`
. $scriptPath/helpers.sh

WriteStatusFileAndExit() {
	touch "/storage/$1 $(date +'%d-%m')"
	exit
}

CheckZfsSnapshots
if [ $ERROR ]
then
	WriteStatusFileAndExit ERROR
fi

WriteStatusFileAndExit OK