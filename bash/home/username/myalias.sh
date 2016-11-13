
#########
# Aliases
#########

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
alias ll='ls -lhA --color=auto'
alias ls='ls --color=auto'
