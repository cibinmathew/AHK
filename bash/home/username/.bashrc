#www.cibinmathew.com
#github.com/cibinmathew

# initial configuration
# to make startup faster; http://stackoverflow.com/questions/28410852/startup-is-really-slow-for-all-cygwin-applications

# for case insensitive autocompletion, in  /etc/inputrc or ~/.inputrc uncomment
# set completion-ignore-case on 

# This makes it unnecessary to press Tab twice when there is more than one match.
# set show-all-if-ambiguous on

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB: menu-complete"
bind "set blink-matching-paren on"
bind "set colored-completion-prefix on"
bind "set completion-map-case on"
bind "set mark-directories on"
# bind "set show-all-if-unmodified on"
# bind "set show-mode-in-prompt on"



# C-u=kill till beginning
# emacs bindings
# reverse-search-history (C-r)
              # Search backward starting at the current line and moving `up' through the history as necessary.  This is an incremental search.
# man bash | grep -A294 'Commands for' 
# Set Vi Mode in bash:
# set -o vi 

# Set Emacs Mode in bash:
# set -o emacs 

source $HOME/lib.sh
source $HOME/myalias.sh

function xpl() {
	#alias vl='vim $(fc -s)' # will open the output of last command in vi
	file ="$(fc -s)"
	ff=$(echo /cygdrive/f/july\ 2/ |  sed -r "s/\\/cygdrive\\/(.)\\//\1:\\\\\\\/" | sed -e "s/\\//\\\\\\\/g" | sed -r "s/(.*)\\\\\\\/\"\1\"/")
	echo "$ff"
	# explorer.exe "$ff"
	# if [ ! -f "$file" ]; then
		# echo "File exist"
    # else
		# echo "File not found!"
	# fi
}

function open() { 

# http://robertmarkbramprogrammer.blogspot.in/2007/06/cygwin-bash-script-open-windows.html
if [ $# -eq 0 -o  -n "$1" ]; then	
        if [ -n "$1" ];  then	
		# normal argument
			filepath="$1"
		else	
		# capture the piped input as an argument             
			read filepath; 		
		fi
		echo "file is $filepath"
		filepath=$(echo "$filepath" | head -1)
	 #if [ -z "$1" ]; then
		   
	   	 
	# location=.
	# case "$1" in
	 # ""                 ) location=.;;
	 # "-help"            ) usage; exit 0;;
	 # *                  ) location="${1}";;
	# esac
	 
	# if [ -e "$location" ]
	# then
	   # WIN_PATH=`cygpath -w -a "${location}"`
	   # cmd /C start "" "$WIN_PATH"
	# else
	 # echo ${location} does not exist!
	 # exit 2
	# fi

	b=$(echo $filepath | sed 's/\(.\)/\1:/' | sed -e "s/\\//\\\\/g")
	echo opening "$b"
	cmd /C start "" "$b"
	 
 
 else
 {
        echo "else $*"
	 echo "Open Windows Explorer"
	 echo "Usage: $0 [-help] [path]"
	 echo "          [path]: folder at which to open Windows Explorer, will"
	 echo "              default to current dir if not supplied."
	 echo "          [-help] Display help (this message)."
	
	}
    fi
 }
 


function myindexfolders() { 
if [ -z "$1" ]; then
    #display usage if no parameters given
    echo "Usage: cibin index all folders to $Universal_home/Downloads/all_folders.txt"
	lfind /cygdrive -type d -iname "*" > "$Universal_home/Downloads/all_folders.txt"
   cat "$Universal_home/Downloads/all_folders.txt" 
   cat "$Universal_home/Downloads/all_folders.txt" | sed -r "s/\\/cygdrive\\/(.)\\//\1:\\\\\\\/" | sed -e "s/\\//\\\\\\\/g"  > "$Universal_home/Downloads/all_folders2.txt"
fi
 }


function myindexemacs() { 
file="$Universal_home/AppData/Roaming/.file_cache"
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin index all files to $file"
	echo '(' > "$file"
#	lfind.exe /cygdrive/c/cbn_gits/AHK/LIB  -iname "*.ahk" -printf '("%P" "%h")\n'  | sed -r "s/\\/cygdrive\\/(.)\\//\1:\//" | tr -d '\n' >> "$file"
	lfind  /cygdrive/c/cbn_gits/AHK/*  $Universal_home/Downloads/* -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -printf '("%f" "%h")\n'  | sed -r "s/\\/cygdrive\\/(.)\\//\1:\//" | tr -d '\n' >> "$file"
	echo ')' >> "$file"

 fi
 }

function myindex() { 
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin index all files to $Universal_home/Downloads/all_files.txt"
	lfind /cygdrive -iname "*" > "$Universal_home/Downloads/all_files.txt"
 #else

 #grep -PrnIi "$1" --color=auto $Universal_home/Downloads/text/* $Universal_home/Desktop/Projects/python_scripts; 
 fi
 }

#switch case example
	#case $# in
	#2)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)" --color=auto $Universal_home/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///";;
	#3)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)(?=.*$3[^/]*$)" --color=auto $Universal_home/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///";;
	#4)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)(?=.*$3[^/]*$)(?=.*$4[^/]*$)" --color=auto $Universal_home/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///";;
	#*)  echo "too many arguments"  ;; 
	#esac

#extract function. This combines a lot of utilities to allow you to decompress just about any compressed file format. There are a number of variations, but this one comes from here:
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}
