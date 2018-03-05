#!/usr/bin/env sh
# bash <(curl -Ss https://raw.githubusercontent.com/ivanpeso/test/master/install.sh)
#
mkdir ~/nxPanel/
wget https://raw.githubusercontent.com/ivanpeso/test/master/base/start.sh -O ~/nxPanel/start.sh
chmod +x ~/nxPanel -R
echo "Files copied in your home dir! Just go to ~/nxPanel/ "
echo "and execute ./start.sh install"
