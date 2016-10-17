#www.cibinmathew.com
#github.com/cibinmathew


#########
# Aliases
#########


function xpl() {
	#alias vl='vim $(fc -s)' # will open the output of last command in vi
	file ="$(fc -s)"
	 ff=$(echo /cygdrive/f/july\ 2/ |  sed -r "s/\\/cygdrive\\/(.)\\//\1:\\\\\\\/" | sed -e "s/\\//\\\\\\\/g" | sed -r "s/(.*)\
\\\\\\/\"\1\"/")
explorer.exe "$ff"
	if [ ! -f "$file" ]; then
		echo "File exist"
    else
		echo "File not found!"
	fi
}


alias grep='grep --color=auto'
alias ll="ls -lhA"

alias ..="cd .."
# We can find files in our current directory easily by setting this alias
alias fhere="lfind . -iname "

alias du="du -ach | sort -h"
#-p flag to make any necessary parent directories. We can make this the default:
alias mkdir="mkdir -p"
#Have you ever needed your public IP address from the command line when you're behind a router using NAT? Something like this could be useful:
alias myip="curl http://ipecho.net/plain; echo"

#If I then have to upload them to a server, I can use sftp to connect and automatically change to a specific directory:

alias upload="sftp username@server.com:/path/to/upload/directory"
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'

function myallgrep() { 
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin grepp for text files"
 else
lfind  /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts  /cygdrive/d/*  -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -type f -exec grep -PrnIi "$1"  --color=auto {} /dev/null \;
# By using /dev/null as an extra input file grep "thinks" it dealing with multiple files, but /dev/null is of course empty, so it will not show up in the match list

 #grep -PrnIi "$1" --color=auto /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts  /cygdrive/d/* ; 
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
 


 
function findhere() { 
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin find all files "
else
	
	lfind . -maxdepth $1 -iname "*" | grep -iP "(?=.*$2[^/]*$)(?=.*$3[^/]*$)"
	
 #else
 fi
 }

function myindex() { 
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin index all files to /cygdrive/c/Users/cibin/Downloads/all_files.txt"
	lfind /cygdrive -iname "*" > /cygdrive/c/Users/cibin/Downloads/all_files.txt
 #else

 #grep -PrnIi "$1" --color=auto /cygdrive/c/Users/cibin/Downloads/text/* /cygdrive/c/Users/cibin/Desktop/Projects/python_scripts; 
 fi
 }

function myfind() {
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin find utility"
 else
	
	search=""
	for arg in $*; do		
		search=$search\(?=.*$arg[^\\/]*$\)
		done	
	grep -PrIi "$search" --color=auto /cygdrive/c/Users/cibin/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///"  
	
fi
 }
#switch case example
	#case $# in
	#2)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)" --color=auto /cygdrive/c/Users/cibin/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///";;
	#3)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)(?=.*$3[^/]*$)" --color=auto /cygdrive/c/Users/cibin/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///";;
	#4)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)(?=.*$3[^/]*$)(?=.*$4[^/]*$)" --color=auto /cygdrive/c/Users/cibin/Downloads/all_files.txt |  sed -e "s/\\/cygdrive\\///";;
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
