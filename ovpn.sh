#!/bin/sh

case "$1" in
    home)
        cd ~/.openvpn/adhoc
        sudo openvpn --config udp.conf --daemon
        ;;
    adhoc)
        cd ~/.openvpn/adhoc
        sudo openvpn --config lnageleisen.conf --auth-user-pass up --daemon
        ;;
    stop)
        sudo killall openvpn
        ;;
    *)
        echo "usage: "$(basename $0) $(ls ~/.openvpn|tr "\n" '|')"stop"
        exit 1
        ;;
esac

