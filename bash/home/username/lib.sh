#!/usr/bin/sh

# path ${0}
# parent path ${0%/*}
# filename ${0##*/}

# dir=$(dirname "$BASH_SOURCE[0]$$*/}")

echo "os: $OS"
if [ "$OS" == "Windows_NT" ]; then
	Universal_home=$(cygpath -H)
	# echo "$Universal_home"
else
	Universal_home=$HOME
	echo "linux machine"
fi

Universal_home="$Universal_home/$USERNAME"
echo "$Universal_home"


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
