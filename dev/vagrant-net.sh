#/usr/bin/bash
ip addr add 192.168.50.1/24 dev vboxnet0
ip link set vboxnet0 up
