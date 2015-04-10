#!/bin/zsh
# -*- sh-mode -*-

fyndeany() {
    local suffix=$1
    shift
    echo "finding with suffix: $suffix"
    find -name "*$**$suffix" | sort
}

fyndedirs() {
    local suffix=$1
    shift
    echo "finding with suffix: $suffix"
    find -type d -name "*$**$suffix" | sort
}

fyndefiles() {
    local suffix=$1
    shift
    echo "finding with suffix: $suffix"
    find -type f -name "*$**$suffix" | sort
}

fynde() {
    echo "\$1: $1"
    case "$1" in
        ruby|rb|r)  shift; fyndefiles ".rb" $* ;;
        groovy|gv) shift; fyndefiles ".groovy" $* ;;
        gradle|gr) shift; fyndefiles ".gradle" $* ;;
        java|j)  shift; fyndefiles ".java" $* ;;
        jar|J)  shift; fyndefiles ".jar" $* ;;
	zip|Z)  shift; fyndefiles ".zip" $* ;;
	tar|T)  shift; fyndefiles ".tar" $* ;;
	txt|t)  shift; fyndefiles ".txt" $* ;;
	file|.)  shift; fyndefiles "" $* ;;
	dir|/)  shift; fyndedirs "" $* ;;
	any|,)  shift; fyndeany "" $* ;;
	"")  find | sort ;;
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
