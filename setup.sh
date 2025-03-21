#! /bin/bash

function custom_echo()
{
  text=$1
  color=$2

  case $color in
    "green")
      echo -e "\033[32m[RO:BIT] $text\033[0m"
      ;;
    "red")
      echo -e "\033[31m[RO:BIT] $text\033[0m"
      ;;
    *)
      echo "$text"
      ;;
  esac
}

custom_echo "create_qt_pkg setup running ! " "green"
custom_echo "Moving scrips to ~/" "green"
cd ..
mv create_qt_pkg ~/.create_qt_pkg_scripts

echo 'create_qt_pkg() {
    local package_name="$1"
    shift 
    local current_directory="$PWD"
    /home/"$USER"/.create_qt_pkg_scripts/create_qt_pkg.sh "$current_directory" "$package_name"
}' >> ~/.bashrc
source ~/.bashrc

sudo apt-get -y install tree
