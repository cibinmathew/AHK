# create files from csv list 

files="pcfind,rgrep,findhere,myallgrep,mygrep,advgrep"

while [ "$files" ] ; do
	iter=${files%%,*}
	echo "$iter"
cat > $iter.sh<<EOF
# !/usr/bin/sh
source shell_handler.sh $@
EOF
	
cat > $iter.cmd<<EOF
@echo off
REM call cmd_handler.cmd %*
REM call cmd_handler.cmd %~n0 %*
set _CYGBIN=c:\cygwin64\bin
REM set _CYGBIN=/cygdrive/c/cygwin6/bin
set _CYGSCRIPT=/usr/bin/$iter.sh
set _CYGPATH="/usr/bin"

REM endlocal & bash --login && cd "/usr/bin" && pwd && "/usr/bin/$iter.sh" %*
REM endlocal & echo cd /cygdrive/c/cbn_gitsﾍｾ "%_CYGSCRIPT%" %* | bash --login -s
REM echo "/usr/bin/$iter.sh" %* |

REM endlocal & echo "%_CYGSCRIPT%" %*| %_CYGBIN%\bash --login -s
echo pwd; cd "/usr/bin/"; pwd ; "/usr/bin/$iter.sh" %*| "c:\cygwin64\bin\bash" --login -s
EOF

[ "$files" = "$iter" ] && \
	files='' || \
	files="${files#*,}"
done