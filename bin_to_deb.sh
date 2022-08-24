#!/bin/bash
set -e

apt-get update 

apt-get -y install binwalk dpkg-repack dpkg

wget -O UNVR_FW.bin https://fw-download.ubnt.com/data/unifi-nvr/55a6-UNVRPRO-2.5.11-e8a05eaa3f7c462ca1123f336d5a8ccc.bin

binwalk -e UNVR_FW.bin --run-as=root

dpkg-query --admindir=_UNVR_FW.bin.extracted/squashfs-root/var/lib/dpkg/ -W -f='${package} | ${Maintainer}\n' | grep -E "@ubnt.com|@ui.com" | cut -d "|" -f 1 > packages.txt

while read pkg; do

  dpkg-repack --root=_UNVR_FW.bin.extracted/squashfs-root/ --arch=arm64 ${pkg}

done < packages.txt
