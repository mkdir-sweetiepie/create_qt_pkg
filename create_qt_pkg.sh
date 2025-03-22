#! /bin/bash

function custom_echo() {
  text=$1
  color=$2

  case $color in
    "green")
      echo -e "\033[32m[RO:BIT] $text\033[0m"
      ;;
    "red")
      echo -e "\033[31m[RO:BIT] $text\033[0m"
      ;;
    "orange")
      echo -e "\033[33m[RO:BIT] $text\033[0m"
      ;;
    *)
      echo "$text"
      ;;
  esac
}

loading_animation() {
  local interval=1
  local duration=10
  local bar_length=$(tput cols)  
  local total_frames=$((duration * interval))
  local frame_chars=("█" "▉" "▊" "▋" "▌" "▍" "▎" "▏")

  for ((i = 0; i <= total_frames; i++)); do
    local frame_index=$((i % ${#frame_chars[@]}))
    local progress=$((i * bar_length / total_frames))
    local bar=""
    for ((j = 0; j < bar_length; j++)); do
      if ((j <= progress)); then
        bar+="${frame_chars[frame_index]}"
      else
        bar+=" "
      fi
    done
    printf "\r\033[32m%s\033[0m" "$bar"  
    sleep 0.$interval
  done

  printf "\n"
}

replace_text_in_file() {
    local file_path="$1"
    local search_text="$2"
    local replace_text="$3"  
    if [ ! -f "$file_path" ]; then
        return 1
    fi
    sed -i "s/$search_text/$replace_text/g" "$file_path"
}

change_pkgxml(){
  local file_path="$1"
  local search_text="$2"

  if [ ! -f "$file_path" ]; then
        return 1
  fi 
    
  sed -i "s/$search_text/$replace_text/g" "$file_path"

}

custom_echo "create_qt_pkg ROS GUI package [github.com/mkdir-sweetiepie]" "orange"
cur_path="$1"
package_name="$2"
script_path="/home/$USER/.create_qt_pkg_scripts/qt_template/"

if [[ $package_name =~ [A-Z] || $package_name =~ [^a-zA-Z0-9_] ]]; then
    custom_echo "ROS package name must not contain Uppercase or Special Characters!" "red"
    exit 1
fi

if [ -d "$script_path" ]; then
    loading_animation
else
    custom_echo "ros2_create_qt_pkg not installed correctly!!" "red"
    custom_echo "Please re-install it from github.com/mkdir-sweetiepie/ros2_create_qt_pkg" "red"
    exit 1
fi
custom_echo "Creating ROS GUI package. Package name : $package_name" "green"

if [ -z "$package_name" ]; then
  custom_echo "You Should Enter a package name!" "red"
  custom_echo "create_qt_pkg [package_name]" "red"
  exit 1
fi

cd $cur_path
mkdir $package_name
cd $package_name

mkdir -p src
mkdir -p include
mkdir -p resources
mkdir -p ui

cp $script_path/CMakeLists.txt .
replace_text_in_file "CMakeLists.txt" "%(package)s" "$package_name"

cd src
cp $script_path/src/mainwindow.cpp .
cp $script_path/src/main.cpp .

cd $cur_path/$package_name/include/
cp $script_path/include/mainwindow.h .

cd $cur_path/$package_name/resources/
cp $script_path/resources/resources.qrc . 
cp -R $script_path/resources/images .

cd $cur_path/$package_name/ui/
cp $script_path/ui/mainwindow.ui .

custom_echo "Created ROS GUI package !" "green"
custom_echo "Package Overview" "green"
cd $cur_path/$package_name
tree



