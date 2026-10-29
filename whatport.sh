#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	exec sudo "$0" "$@"
fi

if ! systemctl is-active --quiet lldpd; then
	systemctl start lldpd
fi

VALUE=$0
WERT=$(pidof -x "${VALUE##*/}" | wc -w)
ZAHL=2

if [ "$WERT" -gt "$ZAHL" ]; then
	watch -n0 cat ports.txt
else
	while true; do
		lldpctl > lldp.txt
		sleep 1

		link=$(ethtool enp3s0f0 2>/dev/null | grep "Link detected:" | awk '{$1=$1};1')
		switch=$(grep "SysName*" lldp.txt | awk '{$1=$1};1' | cut -d' ' -f 2)
		port=$(grep "PortDes*" lldp.txt | awk '{$1=$1};1')
		vlan=$(grep "VLAN*" lldp.txt | awk '{$1=$1};1' | cut -d' ' -f 2)
		trimport=${port#*net}
		trimvlan=${vlan%,}

		printf "$link\n\nSwitch: \t $switch\nSwitchport: \t $trimport\nVLAN: \t\t $trimvlan" > ports.txt
		sleep 1
	done &
	LOOP_PID=$!
	trap 'kill "$LOOP_PID" 2>/dev/null' EXIT INT TERM

	watch -n0 cat ports.txt
fi
