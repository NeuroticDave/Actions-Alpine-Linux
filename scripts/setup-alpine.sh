#!/bin/sh
export LANG="en_GB.UTF-8"
export LANGUAGE=en_GB:en
export LC_NUMERIC="C"
export LC_CTYPE="C"
export LC_MESSAGES="C"
export LC_ALL="C"

# base packages
apk update
apk add --no-cache openrc bash
apk add --no-cache alpine-base
apk add --no-cache util-linux
apk add --no-cache chrony tzdata dhcpcd
rc-update add bootmisc boot
rc-update add sysctl boot
rc-update add syslog boot
rc-update add crond default
rc-update add chronyd default

# docker
apk add --no-cache docker docker-cli-compose
rc-update add docker default

# configure docker daemon
mkdir -p /etc/docker
cat << 'EOL' > /etc/docker/daemon.json
{
    "live-restore": true,
    "ipv6": false
}
EOL

# configure sysctl - disable IPv6 and optimize for zram
cat << 'EOL' > /etc/sysctl.conf
# content of this file will override /etc/sysctl.d/*

##Force IPv6 off
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
net.ipv6.conf.eth1.disable_ipv6 = 1

## ZRAM optimization (per Alpine docs)
# Disable swap readahead (zram is fast, no need for readahead)
vm.page-cluster = 0
# Disable memory fragmentation threshold
vm.extfrag_threshold = 0
# Aggressive swapping to zram (100 = prefer swap, good for zram)
vm.swappiness = 100
EOL

# configure zram compressed swap
apk add --no-cache zram-init
mkdir -p /etc/conf.d
cat << 'EOL' > /etc/conf.d/zram-init
# Load/unload zram module
load_on_start=yes
unload_on_stop=yes

# Number of zram devices
num_devices=1

# Device 0: Swap - 100% of system RAM (calculated at boot)
# With zstd compression
type0=swap
flag0=100
size0=`LC_ALL=C free -m | awk '/^Mem:/{print int($2)}'`
algo0=zstd
labl0=zram_swap
EOL
rc-update add zram-init default

# configure ssh server
apk add --no-cache openssh
rc-update add sshd default
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# enable serial console
echo "ttyFIQ0::respawn:/sbin/agetty -L 1500000 ttyFIQ0 vt100" >> /etc/inittab
echo "ttyFIQ0" >> /etc/securetty

# root password
echo "root:123456" | chpasswd

echo "$(date +%Y%m%d)" > /etc/rom-version
[ -e /lib/firmware ] || mkdir -p /lib/firmware
[ -e /lib/modules ] || mkdir -p /lib/modules

# Set hostname
echo "NanoPi" > /etc/hostname
cat << 'EOL' > /etc/hosts
127.0.0.1       NanoPi localhost.localdomain localhost
::1             localhost localhost.localdomain
EOL

# Clear message of the day
> /etc/motd

# Set up mirror
cat << 'EOL' > /etc/apk/repositories
https://uk.alpinelinux.org/alpine/latest-stable/main
https://uk.alpinelinux.org/alpine/latest-stable/community
https://uk.alpinelinux.org/alpine/edge/testing
EOL

# Update package cache with new mirrors
apk update

# run setup-alpine quick mode
cat << 'EOL' > /answer_file

# Set hostname to 'NanoPi'
HOSTNAMEOPTS=NanoPi

# Use GB layout with GB variant
KEYMAPOPTS="gb gb"

# Contents of /etc/network/interfaces
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname NanoPi

auto eth1
iface eth1 inet dhcp
    hostname NanoPi
"

# Set timezone to Europe/London
TIMEZONEOPTS="-z Europe/London"

# Add a random mirror
APKREPOSOPTS="-r"

# Proxy Options
PROXYOPTS="none"

# Install Openssh
SSHDOPTS="-c openssh"

# Use chrony
NTPOPTS="-c chrony"
EOL
setup-alpine -q -f /answer_file

rm -f /answer_file