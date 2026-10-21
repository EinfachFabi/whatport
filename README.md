# whatport

whatport listens for LLDP packets on your wired interface and shows you the switch name, port and VLAN you're connected to. Handy for network technicians and patch-panel detective work.

## Requirements

- `lldpd` (provides `lldpctl`, service must be running: `sudo systemctl enable --now lldpd`)
- `ethtool`
- `sudo`

## Setup

Open `whatport.sh` and change `enp3s0f0` to the name of your network interface:

```bash
link=$(ethtool enp3s0f0 2>/dev/null | ...)
```

You can find your interface name with:

```bash
ip link
```

## Usage

```bash
chmod +x whatport.sh
./whatport.sh
```

Output:

```
Link detected: yes

Switch:      SwitchA01
Switchport:  PortDescr: 8/0/13
VLAN:        123
```

Press `Ctrl+C` to stop.

## Files

The script creates two text files in the folder you run it from:

| File        | Content                                  |
|-------------|------------------------------------------|
| `lldp.txt`  | Raw output of `lldpctl`                  |
| `ports.txt` | Link status, switch, port and VLAN       |

Both files are updated every few seconds and are ignored by git.

## License

MIT
