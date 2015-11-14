#!/bin/zsh
# -*- sh-mode -*-

x=1

if [[ $# == 0 ]]
then
    ls -lF --color=tty $1;
fi

for i in $*
do
    case "$1" in
        *.jar|*.war)
            jar tvf $1 | sort -k 6
            ;;

        *.zip)
            # the tail and head commands snip off the zip header and summary:
            unzip -l $1 | tail -n +4 | head --lines=-2 | sort -k 4
            ;;

        *.tar.gz)
            tar ztvf $1
            ;;

        *.tgz)
            tar ztvf $1
            ;;
        
        *.tar)
            tar tvf $1
            ;;

        *.txt)
            less $1
            ;;

        *.xml)
            less $1
            ;;

        *)
            if [ ! -e $1 ]
            then 
                echo "does not exist: $1"
            elif [ -d $1 ]
            then
                ls -lF --color=tty $1;
            elif file $1 | grep 'ASCII text' >/dev/null
            then
                # -X prevents the console from being cleared when less exits:
                less -XR $1
            else
                echo "not handled: $1"
            fi
            ;;
    esac
done
