#!/bin/sh

set -e

if [ $# -ne 1 ]; then
	echo "usage: $0 DEB"
	exit 2
fi

DEB="$1"
UNIT=/etc/init.d/freenetis-ssh-keys
CONFIG=/etc/freenetis/freenetis-ssh-keys.conf

export DEBIAN_FRONTEND=noninteractive

echo "Change configuration"
sed -i 's/^DEVICE_ID=.*/DEVICE_ID=1/' $CONFIG

echo "Install deb package"
apt-get update -q
if apt --version >/dev/null 1>&2; then
	apt install -q -y "$DEB"
else
	dpkg -i "$DEB" || apt-get install -q -y -f
fi

echo "Util test"
$UNIT version

$UNIT | grep "Download failed (code:"

rm $CONFIG
$UNIT | grep "Config file is missing at path $CONFIG. Terminating..."
