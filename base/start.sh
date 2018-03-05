#!/bin/sh
# Pocetna verzija idemo


nxpanelstop() {
  sudo pkill -F p.id
  echo "Killed"
  sudo rm p.id myip
  echo "Done! Bye!"
  exit 1
}


nxpanelrun() {
MyIpAdress="$(who am i --ips|awk '{print $5}')"
echo $MyIpAdress
echo $MyIpAdress >> nxPanel/myip

sudo nxPanel/phpcli -S 192.168.1.7:8080 nxPanel/corePanel.php 1>&- 2>&-  &
echo $bldyel"Started! Enjoy configuring! \033[0m \n"$txtrst
echo "Have fun!"
}
nxpanelinstall() {
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldyel=${txtbld}$(tput setaf 3) #  zuta
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
echo $bldyel"Getting some enviroment data. This may take couple of moments...\033[0m \n"$txtrst
LINUXCODENAME="$(lsb_release -c | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" #ODKOMENTIRAJ
PHPINSTALLVERSION="$(wget -qO- https://raw.githubusercontent.com/ivanpeso/test/master/$LINUXCODENAME/package)" #ODKOMENTIRAJ
if [ -z "$PHPINSTALLVERSION" ]
then
      echo $bldred"Your system is not supported yet! \033[0m \n"$txtrst
      exit 1
else
      echo $bldblu"Detected Linux [ $LINUXCODENAME ] witch is supported!\033[0m \n"$txtrst
fi
PHPREPO="$(wget -qO- https://raw.githubusercontent.com/ivanpeso/test/master/$LINUXCODENAME/repo)"

echo $bldred"# This script needs to install $PHPINSTALLVERSION package from repository!"$txtrst
echo $bldred"# Since there is chance that it is not yet in default repository let us make apt update to check.\n"$txtrst

read -p "Continue (y/n)?" dozvola1
case "$dozvola1" in
  y|Y )
  sudo apt-get -qy update > /dev/null
  PHPAlreadyInRepository="$(sudo apt-cache search $PHPINSTALLVERSION)"
  ;;
  n|N )
  echo $bldred"[!!!] You revoked permission! Exiting! \033[0m \n\n"$txtrst
  exit 1
  ;;
  * )
  echo $bldred"Invalid input!\033[0m \n\n"$txtrst
  exit 1
  ;;
esac

if [ -z "$PHPAlreadyInRepository" ]
then
echo $bldred"$PHPINSTALLVERSION not in your repository! Adding additional repository, please confirm!"$txtrst
sudo add-apt-repository $PHPREPO
echo $bldblu"$PHPREPO Repository added! Running apt update..."$txtrst
sudo apt-get update > /dev/null
echo $bldyel"$PHPREPO Package list update done ..."$txtrst
echo $bldblu"$PHPREPO Installing $PHPINSTALLVERSION ..."$txtrst
sudo apt-get install $PHPINSTALLVERSION
else
echo $bldblu"$PHPINSTALLVERSION alrady in repository! Installing now! "$txtrst
sudo apt-get install $PHPINSTALLVERSION
fi
# INSTALIRAN PHP7.2 NASTAVLJAMO
echo $bldblu"$PHPINSTALLVERSION INSTALLED! Just few more steps..."$txtrst
# GENERATE SCRIPT STRUCTURE
echo $bldyel"$PHPREPO Creating directory nxPanel/ ..."$txtrst
mkdir nxPanel
echo $bldyel"$PHPREPO Generating symbolic link to php7.2-cli  ..."$txtrst
ln -s /usr/bin/php7.2 phpcli
echo $bldyel"$PHPREPO Downloading core files in directory ..."$txtrst
wget https://raw.githubusercontent.com/ivanpeso/test/master/base/corePanel.php
}

case "$1" in
        start)
            nxpanelrun
            ;;

        stop)
            echo "Stopping instances!"
            nxpanelstop
            ;;

        status)
            echo "status"
            ;;
        install)
            nxpanelinstall
            ;;

        *)
            echo $"Usage: $0 {start|stop|status|install}"
            exit 1
esac
