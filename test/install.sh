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

# Update apt
apt-get update -q
# Install dependencies
apt-get install -q -y debconf wget ssh

echo "Change configuration"
. /usr/share/debconf/confmodule
db_set freenetis-ssh-keys/path_freenetis "http://localhost/freenetis" || true
db_set freenetis-ssh-keys/device_id "1" || true

echo "Install deb package"
dpkg -i "$DEB"

echo "Util test"
$UNIT version

$UNIT | grep "Download failed (code:"

rm $CONFIG
$UNIT | grep "Config file is missing at path $CONFIG. Terminating..."
