#!/bin/zsh
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build

beseekfiles() {
    local suffix=$1
    shift
    echo "find -type f -name \"*$suffix\" | sort | xargs glark $*"
    find \( -type d \( -name .git -o -name .svn \) -prune \) -o -type f -name "*$suffix" -print0 | sort -z | xargs -0 glark $*[2,$#]
}

beseek() {
    echo "last argument: " $@[$#]
    if [ -f $@[$#] ]
    then
	e $@[$#] | glark $argv[0,-2]
	return
    fi
    case "$1" in
        r)  shift; beseekfiles ".rb" $* ;;
        gv) shift; beseekfiles ".groovy" $* ;;
        gr) shift; beseekfiles ".gradle" $* ;;
        j)  shift; beseekfiles ".java" $* ;;
        J)  shift; beseekfiles ".jar" $* ;;
        .)  shift; beseekfiles "" $* ;;
        *)
	    if [ -f "build.gradle" ]
	    then
		beseekfiles "java" $*
	    elif [ -f "Rakefile" ]
	    then
		beseekfiles "rb" $*
	    else
		echo "not handled: $1"
	    fi
	    ;;
    esac
}

beseek $*
