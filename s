#!/bin/zsh
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build

beseekjarfiles() {
    echo find \( -type d \( -name .git -o -name .svn \) -prune \) -o -type f -name "*$suffix" -print0
    echo xargs -0 glark $*[1,$#]
    echo find \( -type d -name .svn -prune \) -o \( -type f -name "*.jar" \) -print
    echo '{ jar tvf VeryUnlikely | glark --label=VeryUnlikely $*[1,$#]; }'
    find \( -type d -name .svn -prune \) -o \( -type f -name "p*.jar" \) -print0 | sort -z | xargs -0 -I VeryUnlikely sh -c '{ jar tvf VeryUnlikely | glark --label=VeryUnlikely XML_; }'
}

beseekfiles() {
    local suffix=$1
    shift
    echo "find -type f -name \"*$suffix\" | sort | xargs glark $*"
    echo "command: find \( -type d \( -name .git -o -name .svn \) -prune \) -o -type f -name \"*$suffix\" -print0 |"
    echo "           sort -z |"
    echo "           xargs -0 glark $*[1,$#]"
    find \( -type d \( -name .git -o -name .svn -o -name staging \) -prune \) -o -type f -name "*$suffix" -print0 | sort -z | xargs -0 glark $*[1,$#]
}

beseek() {
    echo "last argument: " $@[$#]
    if [ -f $@[$#] ]
    then
	e $@[$#] | glark $argv[0,-2]
	return
    fi
    echo "\$1: $1"
    case "$1" in
        r)  shift; beseekfiles ".rb" $* ;;
        erb)  shift; beseekfiles ".erb" $* ;;
        gv) shift; beseekfiles ".groovy" $* ;;
        gr) shift; beseekfiles ".gradle" $* ;;
        j)  shift; beseekfiles ".java" $* ;;
        J)  shift; beseekjarfiles $* ;;
        x)  shift; beseekfiles ".xml" $* ;;
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
