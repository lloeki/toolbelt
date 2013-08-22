#!/usr/bin/python
from __future__ import division, print_function, unicode_literals

from socket import socket, AF_INET, SOCK_DGRAM, SOL_SOCKET, SO_BROADCAST


def interact():
    import code
    code.InteractiveConsole(locals=globals()).interact()


def mac_to_bytes(mac):
    try:  # py2
        return b''.join(chr(int(b, 16)) for b in mac.split(':'))
    except TypeError:  # py3
        return bytes([int(b, 16) for b in mac.split(':')])


def bytes_to_mac(bytes):
    try:  # py3
        return ':'.join("%02X" % b for b in bytes).lower()
    except TypeError:  # py2
        return ':'.join("%02X" % ord(b) for b in bytes).lower()


mac = "78:2b:cb:93:fc:8e"
destination = "255.255.255.255"
port = 9

data = b'\xFF' * 6 + mac_to_bytes(mac) * 16

print("Sending magic packet to %s:%s with %s" %
        (destination, port, bytes_to_mac(mac_to_bytes(mac))))

sock = socket(AF_INET, SOCK_DGRAM)
sock.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
sock.sendto(data, (destination, port))
sock.close()
