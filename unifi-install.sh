#!/bin/bash

echo "-----------------------------------------"
echo "Update"
echo "-----------------------------------------"
apt-get update

echo "-----------------------------------------"
echo "Installing dependencies"
echo "-----------------------------------------"
apt-get -y --no-install-recommends install curl wget mount psmisc dpkg apt lsb-release  gnupg apt-transport-https ca-certificates dirmngr mdadm 

#  rm -rf /var/lib/apt/lists/*

echo "-----------------------------------------"
echo "Installing NodeJS 16"
echo "-----------------------------------------"
curl -sL https://deb.nodesource.com/setup_16.x |  bash -

apt-get install -y --no-install-recommends nodejs

#  rm -rf /var/lib/apt/lists/*

echo "-----------------------------------------"
echo "Removing sources"
echo "-----------------------------------------"
rm /etc/apt/sources.list

echo "-----------------------------------------"
echo "Creating sources"
echo "-----------------------------------------"
touch /etc/apt/sources.list

echo "-----------------------------------------"
echo "Update"
echo "-----------------------------------------"
apt-get update

echo "-----------------------------------------"
echo "Adding source 1"
echo "-----------------------------------------"
sh -c 'echo "deb [trusted=yes] https://deb.nodesource.com/node_16.x bullseye main" >> /etc/apt/sources.list.d/nodesource.list'

echo "-----------------------------------------"
echo "Adding source 2"
echo "-----------------------------------------"
sh -c 'echo "deb-src [trusted=yes] https://deb.nodesource.com/node_16.x bullseye main" >> /etc/apt/sources.list.d/nodesource.list'

echo "-----------------------------------------"
echo "Adding source 3"
echo "-----------------------------------------"
sh -c 'echo "deb [trusted=yes] http://archive.raspberrypi.org/debian/ bullseye main" >> /etc/apt/sources.list'

echo "-----------------------------------------"
echo "Adding source 4"
echo "-----------------------------------------"
sh -c 'echo "deb-src [trusted=yes] http://archive.raspberrypi.org/debian/ bullseye main" >> /etc/apt/sources.list'

echo "-----------------------------------------"
echo "Adding source 5"
echo "-----------------------------------------"
sh -c 'echo "deb [trusted=yes] https://apt.artifacts.ui.com stretch main release" >> /etc/apt/sources.list.d/ubiquiti.list'

echo "-----------------------------------------"
echo "Adding source 6"
echo "-----------------------------------------"
sh -c 'echo "deb [trusted=yes] http://security.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list'

echo "-----------------------------------------"
echo "Adding source 7"
echo "-----------------------------------------"
sh -c 'echo "deb [trusted=yes] http://ftp.de.debian.org/debian stretch main" >> /etc/apt/sources.list'

echo "-----------------------------------------"
echo "Adding source 8"
echo "-----------------------------------------"
sh -c 'echo "deb [trusted=yes] http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list'

echo "-----------------------------------------"
echo "Update"
echo "-----------------------------------------"
apt-get update

#  apt-get install -y ssl-cert libedit2 sysstat ucf logrotate

echo "-----------------------------------------"
echo "Installing PostgreSQL=9.6"
echo "-----------------------------------------"
apt-get -y --allow-unauthenticated install postgresql=9.6+181+deb9u3
echo "-----------------------------------------"
echo "Changing PostgreSQL auth peer to trust"
echo "-----------------------------------------"
sed -i 's/peer/trust/g' /etc/postgresql/9.6/main/pg_hba.conf

#  rm -rfv /var/lib/apt/lists/*

#  apt-get update

echo "-----------------------------------------"
echo "Copying version file"
echo "-----------------------------------------"
cp version /usr/lib/version

echo "-----------------------------------------"
echo "Installing fixes"
echo "-----------------------------------------"
apt-get install -f

echo "-----------------------------------------"
echo "Installing dependencies"
echo "-----------------------------------------"
apt-get install bind9-host cron init-system-helpers isc-dhcp-client linux-image-raspi-hwe-18.04 libdns-export162 curl

echo "-----------------------------------------"
echo "Installing libzstd"
echo "-----------------------------------------"
apt-get install -y --allow-downgrades libzstd1=1.1.2-1+deb9u1

echo "-----------------------------------------"
echo "Installing zstd"
echo "-----------------------------------------"
apt-get install zstd -y

echo "-----------------------------------------"
echo "Installing Ubiquiti Archive Keyring"
echo "-----------------------------------------"
dpkg -i ./ubnt-archive-keyring_*_arm64.deb 

chmod 666 /etc/apt/sources.list.d/ubiquiti.list 

echo "-----------------------------------------"
echo "Update"
echo "-----------------------------------------"
apt-get update 

echo "-----------------------------------------"
echo "Installing fixes"
echo "-----------------------------------------"
apt-get install -f

echo "-----------------------------------------"
echo "Installing ULP-GO"
echo "-----------------------------------------"
apt-get install -y ulp-go

echo "-----------------------------------------"
echo "Installing .deb files (ubnt-tools, unifi-core)"
echo "-----------------------------------------"
apt install -y ./*.deb

#  rm -rf /var/lib/apt/lists/*

echo "-----------------------------------------"
echo "Installing libstdc++6=6.3.0-18+deb9u1"
echo "-----------------------------------------"
apt-get install -y --allow-downgrades libstdc++6=6.3.0-18+deb9u1

echo "-----------------------------------------"
echo "Installing ubnt-opencv4-libs"
echo "-----------------------------------------"
apt-get install -y ubnt-opencv4-libs

echo "-----------------------------------------"
echo "Installing Unifi Protect"
echo "-----------------------------------------"
apt-get -y install unifi-protect

#  rm -rf /var/lib/apt/lists/*

echo "-----------------------------------------"
echo "Running postgresql.sh script"
echo "-----------------------------------------"
sh postgresql.sh


sh -c echo "exit 0" >> /usr/sbin/policy-rc.d

sed -i "s/Requires=network.target postgresql-cluster@9.6-main.service ulp-go.service/Requires=network.target postgresql-cluster@9.6-main.service/" /lib/systemd/system/unifi-core.service

sed -i 's/redirectHostname: unifi//' /usr/share/unifi-core/app/config/config.yaml

echo "-----------------------------------------"
echo "Copying ubnt-tools"
echo "-----------------------------------------"
cp ./files/ubnt-tools /sbin/ubnt-tools
