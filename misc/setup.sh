#!/bin/sh

# This script install various mesh routing protocols on Debian (tested with Debian Buster/10.4)

set -xe

apt-get update
apt-get install -y sudo time git-core subversion build-essential g++ bash make libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk flex gettext wget unzip xz-utils python python-distutils-extra python3 python3-distutils-extra rsync linux-headers-amd64 pkg-config libnl-3-dev libnl-genl-3-dev libiw-dev bison cmake


WD="/tmp/work/"
mkdir $WD

# install batman-adv
cd $WD
wget https://downloads.open-mesh.org/batman/releases/batman-adv-2020.1/batctl-2020.1.tar.gz -O batctl.tar.gz
tar -xvf batctl.tar.gz
cd batctl-*
make
make install

cd $WD
wget https://downloads.open-mesh.org/batman/releases/batman-adv-2020.1/batman-adv-2020.1.tar.gz -O batman-adv.tar.gz
tar -xvf batman-adv.tar.gz
cd batman-adv-*
make
make install

# install babel
cd $WD
wget https://github.com/jech/babeld/archive/babeld-1.9.2.tar.gz -O babeld.tar.gz
tar -xvf babeld.tar.gz
cd babeld-*
make
make install

# install bmx6
cd $WD
wget https://github.com/bmx-routing/bmx6/archive/v1.0.tar.gz -O bmx6.tar.gz
tar -xvf bmx6.tar.gz
cd bmx6-*
make
cp bmx6 /usr/bin/

# install olsr1/olsrd
cd $WD
wget https://github.com/OLSR/olsrd/archive/v0.9.8.tar.gz -O olsrd.tar.gz
tar -xvf olsrd.tar.gz
cd olsrd-*
make
make install

# install olsr2/OONF
cd $WD
wget https://github.com/OLSR/OONF/archive/v0.15.1.tar.gz -O oonf.tar.gz
tar -xvf oonf.tar.gz
cd OONF-*
cmake .
make
make install
ln -s /usr/local/sbin/olsrd2_static /usr/local/sbin/olsrd2

# install OSPF/bird
apt install bird

# install cjdns
cd $WD
wget https://github.com/cjdelisle/cjdns/archive/cjdns-v20.6.tar.gz -O cjdns.tar.gz
tar -xvf cjdns.tar.gz
cd cjdns-*
./do
cp cjdroute /usr/bin/

# install yggdrasil
cd $WD
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz -O go.tar.gz
tar -xvf go.tar.gz
export PATH=$WD/go/bin:$PATH
export GOPATH=$WD/go
cd $WD
wget https://github.com/yggdrasil-network/yggdrasil-go/archive/v0.3.14.tar.gz -O yggdrasil.tar.gz
tar -xvf yggdrasil.tar.gz
cd yggdrasil-*
./build
cp yggdrasil yggdrasilctl /usr/bin/

#rm -rf "$WD"
