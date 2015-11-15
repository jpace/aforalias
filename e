#!/bin/zsh
# -*- sh-mode -*-

debug=

if [[ $1 == "--debug" ]]
then
    echo entering debug mode ...
    echo showing instead of executing commands ...
    shift
    debug=echo
fi


if [[ $# == 0 ]]
then
    $debug ls -lF --color=tty $1;
fi

for i in $*
do
    case "$1" in
        *.jar|*.war)
            $debug jar tvf $1 | sort -k 6
            ;;

        *.zip)
            # the tail and head commands snip off the zip header and summary:
            $debug unzip -l $1 | tail -n +4 | head --lines=-2 | sort -k 4
            ;;

        *.tar.gz)
            $debug tar ztvf $1
            ;;

        *.tgz)
            $debug tar ztvf $1
            ;;
        
        *.tar)
            $debug tar tvf $1
            ;;

        *.txt)
            $debug less $1
            ;;

        *.xml)
            $debug less $1
            ;;

        *)
            if [ ! -e $1 ]
            then 
                echo "does not exist: $1"
            elif [ -d $1 ]
            then
                $debug ls -lF --color=tty $1;
            elif file $1 | grep 'ASCII text' >/dev/null
            then
                # -X prevents the console from being cleared when less exits:
                $debug less -XR $1
            else
                echo "not handled: $1"
            fi
            ;;
    esac
done
