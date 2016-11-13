#!/usr/bin/sh
echo==sh handler==
filename=${0###*/}
filename=$(basename "$filename") # remove windows path

# remove trailing .sh
func=$(echo $filename | sed -e "s/.sh//")

source /home/$USERNAME/lib.sh && $func $@