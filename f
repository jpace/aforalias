#!/bin/sh
# -*- sh-mode -*-

fyndeany() {
    local suffix=$1
    shift
    find -name "*$**$suffix" | sort
}

fyndedirs() {
    local suffix=$1
    shift
    find -type d -name "*$**$suffix" | sort
}

fyndefiles() {
    local suffix=$1
    shift
    find -type f -name "*$**$suffix" | sort
}

fynde() {
    case "$1" in
        ruby|rb|r)  shift; fyndefiles ".rb" $* ;;
        erb)        shift; fyndefiles ".erb" $* ;;
        groovy|gv)  shift; fyndefiles ".groovy" $* ;;
        gradle|gr)  shift; fyndefiles ".gradle" $* ;;
        java|j)     shift; fyndefiles ".java" $* ;;
        jar|J)      shift; fyndefiles ".jar" $* ;;
        zip|Z)      shift; fyndefiles ".zip" $* ;;
        tar|T)      shift; fyndefiles ".tar" $* ;;
        txt|t)      shift; fyndefiles ".txt" $* ;;
        xml|x)      shift; fyndefiles ".xml" $* ;;
        html|h)     shift; fyndefiles ".html" $* ;;

        dir|/)      shift; fyndedirs "" $* ;;
        file|.)     shift; fyndefiles "" $* ;;
        any|,)      shift; fyndeany "" $* ;;
        -s=*)       sfx=$1; shift; sfx=`echo $sfx | sed -e 's/^\-s=\.\?/./'`; echo f: $sfx >&2; fyndefiles $sfx $* ;;
        -s)         shift; sfx=$1; shift; sfx=`echo $sfx | sed -e 's/^\-s=\.\?/./'`; echo f: $sfx >&2; fyndefiles $sfx $* ;;
        -w)         shift; fyndefiles "" $* ;;
        "")         find | sort ;;
        *.*)        find . -name $* | sort ;;
        *)
            if [ -f "build.gradle" ]
            then
                fyndefiles "java" $*
            elif [ -f "Rakefile" ]
            then
                fyndefiles "rb" $*
            else
                echo "not handled: $1"
            fi
            ;;
    esac
}

fynde $*
