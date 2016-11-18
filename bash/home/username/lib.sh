#!/usr/bin/sh

# path ${0}
# parent path ${0%/*}
# filename ${0##*/}

# dir=$(dirname "$BASH_SOURCE[0]$$*/}")

# echo "os: $OS"
if [ "$OS" == "Windows_NT" ]; then
	Universal_home=$(cygpath -H)
	# echo "$Universal_home"
else
	Universal_home=$HOME
	echo "linux machine"
fi

Universal_home="$Universal_home/$USERNAME"
# echo "$Universal_home"


function grephere() {

	search_term=$(make_wildcard_search_term "$@")
	cwd=$(pwd)
	echo "searching $1 in $cwd"

	echo "grep -Ein $search_term *.* --color=auto"
	grep -Ein $search_term *.* --color=auto

}
function rgrep() {

	search_term=$(make_wildcard_search_term "$@")
	cwd=$(pwd)
	echo "search  $1 in ,$cwdd"

	echo "grep -Eirn $search_term *.* --color=auto"
	grep -Eirn $search_term *.* --color=auto

}
function rrgrep() {

	cwd=$(pwd)
	echo "searching $1 in $cwd"
	search_term=$(make_wildcard_search_term "$@")
	echo "grep -Eirn $1 ../*.* --color=auto"
	grep -Eirn $search_term ../*.* --color=auto

}

function grepfind() {

	cwd=$(pwd)
	search_term=$(make_wildcard_search_term "$@")
	echo "searching $1 in $cwd"

	echo "lfind . -type f -exec grep -nH $1 {}  --color=auto\;"
	lfind . -type f -exec grep -nH $search_term {}  --color=auto\;

}

function rrfindhere() {

	if [ -z "$1" ]; then
	echo "Usage: cibin find all files "
	else
	cwd=$(pwd)
	search=""
	search_term=$(make_wildcard_search_term "$@")
	echo "lfind . -iname $search"
	lfind ../ -iname "$search_term"
	# lfind . -maxdepth $1 -iname "*" | grep -iP "(?=.*$2[^/]*$)(?=.*$3[^/]*$)"
	fi
}
function findhere() {

	if [ -z "$1" ]; then
	echo "Usage: cibin find all files "
	else
	cwd=$(pwd)
	search=""
	search_term=$(make_wildcard_search_term "$@")
	echo "lfind . -iname $search"
	lfind . -iname "$search_term"
	# lfind . -maxdepth $1 -iname "*" | grep -iP "(?=.*$2[^/]*$)(?=.*$3[^/]*$)"
	fi
}

function make_lookaround_search_term() {
	# prepare lookaround search term

	search=""
	for arg in $@; do
		search=$search\(?=.*$arg[^\\/]*$\)
	# search=$search.\*$arg
	# echo $arg
	# echo $search
	done
	# search=$search.\*
	echo "$search"
}

function make_wildcard_search_term() {
	# prepare wildcard search term

	search=""
	for arg in $@; do
		search=$search\*$arg
	done
	search=$search\*
	echo "$search"
}
function pcfind() {
	echo $# args
	echo $@ args
	if [ -z "$1" ]; then
	# display usage if no parameters given
	echo "Usage: cibin find utility"
	else
	local search_term=""
	# make_lookaround_search_term $@
	search_term=$(make_lookaround_search_term $@)
	echo "$search_term"
	grep -rPIi "$search_term" --color=auto "$Universal_home/Downloads/all_files.txt" |  sed -e "s/\\/cygdrive\\/\\(.\\)\\//\\1:\\//"
	fi
}

# advgrep all/downs txt 
# cmd all txt searchTerm
# cmd all searchTerm
# cmd searchTerm

function advgrep() { 
files="$Universal_home/Downloads/de*"

ext=".*\.\(txt\|py\|ini\|java\|ahk\)"

if [ -z "$1" ]; then
		echo "Usage: cibin grepp for text files"
else
	if [ -z "$2" ]; then
		search_term="$1"
	else
		case "$1" in
			 "all"                 ) files="$Universal_home/Desktop/l* $Universal_home/Downloads/de*";;
			 "ahk"                 ) files="/cygdrive/c/cbn_gits/AHK/*";;
			 "notes"                 ) files="$Universal_home/Downloads/de*";;
			esac
		if [ -z "$3" ]; then		
			search_term="$2"
		else
			ext=".*\.\($2\)"
			search_term="$3"
		fi	
	
	fi	
fi	
	
echo 
# echo $files
echo $ext
echo "$search_term"
search_term=$(make_lookaround_search_term $search_term)
echo "$search_term"
	lfind  $files  -iregex $ext -type f -exec grep -PrnIi $search_term --color=auto {} /dev/null \;
	# lfind  "$Universal_home"/Desktop/l* "$Universal_home"/Downloads/* /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts  /cygdrive/d/*  -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -type f -exec grep -PrnIi "$1"  --color=auto {} /dev/null \;
	
	 
 }
# advgrep marady
# advgrep all marady
# advgrep all txt marady
# advgrep ahk ahk "recently downlo"
# advgrep ahk "recently downloaded"
# By using /dev/null as an extra input file grep "thinks" it dealing with multiple files, but /dev/null is of course empty, so it will not show up in the match list
 
function myallgrep() { 
	if [ -z "$1" ]; then
		echo "Usage: cibin grepp for text files"
	 else
	lfind  "$Universal_home"/Desktop/l* "$Universal_home"/Downloads/* /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts  /cygdrive/d/*  -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -type f -exec grep -PrnIi "$1"  --color=auto {} /dev/null \;
	 fi
 }
 
function mygrep() { 
	if [ -z "$1" ]; then
		# display usage if no parameters given
		echo "Usage: cibin grepp for text files"
	 else

	 grep -PrnIi "$1" --color=auto /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts; 
	 fi
 }
