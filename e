#!/bin/zsh
# -*- sh-mode -*-

eyeball() {
    case "$1" in
        *.jar|*.war) jar tvf $1 | sort -k 6 ;;

        *.zip)       unzip -l $1 | ruby -e 'lines = STDIN.readlines; puts lines[3 .. lines.length - 3]' | sort -k 4 ;;

        *.tar.gz)    tar ztvf $1 ;;
        *.tgz)       tar ztvf $1 ;;
        *.tar)       tar tvf $1 ;;

        *.txt)       less $1 ;;
        *.xml)       less $1 ;;

        *)
            if [ ! -e $1 ]
            then
		echo "does not exist: $1"
            elif [ -d $1 ]
            then
		ls -lF --color=tty $1;
            elif file $1 | grep 'ASCII text' >/dev/null
            then
		less -XR $1
            else
		echo "not handled: $1"
            fi
            ;;
    esac
}

for i in $*
do
    eyeball $i
done
