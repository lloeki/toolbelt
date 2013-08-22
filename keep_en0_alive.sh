#!/bin/bash

[ "$UID" == 0 ] || exec sudo $0

TARGET='10.0.100.254'
TIMEOUT='5'

kext='/System/Library/Extensions/BCM5722D.kext'

std_date() {
    echo -n $(date +'%Y-%m-%d %H:%M:%S')
}

is_up() {
    ping -q -t $TIMEOUT -o -r $TARGET > /dev/null
}

wait_for_up() {
    ping -q -o -r $TARGET > /dev/null
}

restart_iface() {
    echo "syncing"
    sync
    echo "unloading kext"
    kextunload $kext
    echo "loading kext"
    kextload $kext
}

while wait_for_up; do
    while is_up; do
        sleep 1
    done

    echo "en0 down @ `std_date`"
    restart_iface
done
