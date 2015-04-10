#!/bin/bash
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build
# d: diff

diffjarfiles() {
    echo find \( -type d \( -name .git -o -name .svn \) -prune \) -o -type f -name "*$suffix" -print0
    echo xargs -0 glark $*[1,$#]
    echo find \( -type d -name .svn -prune \) -o \( -type f -name "*.jar" \) -print
    echo '{ jar tvf VeryUnlikely | glark --label=VeryUnlikely $*[1,$#]; }'
    find \( -type d -name .svn -prune \) -o \( -type f -name "p*.jar" \) -print0 | sort -z | xargs -0 -I VeryUnlikely sh -c '{ jar tvf VeryUnlikely | glark --label=VeryUnlikely XML_; }'
}

dirdiff() {
    from=$1
    to=$2
    echo diff --exclude=staging --exclude=.git --exclude=.svn -r $from $to
    diff --exclude=staging --exclude=.git --exclude=.svn -r $from $to
}

diffit() {
    local exit=$1
    local fromfd=$2
    local tofd=$3
    echo "$fromfd ... $tofd ... $ext"
    if [ -d $fromfd ]
    then
        # handle d foo/bar/Gz.txt glub, where glub is a directory containing foo/bar/Gz.txt
        fp=$fromfd/$tofd
        tp=$tofd/$fromfd
        echo "fp: $fp"
        echo "tp: $tp"
        if [ -d $tp ]
        then
            dirdiff $fromfd $tp
        elif [ -d $fp ]
        then
            dirdiff $fp $tofd
        else
            dirdiff $fromfd $tofd
        fi
    else
	diff $fromfd $tofd
    fi
}

rundiff() {
    echo "last argument: " $2
    case "$1" in
#         r)  shift; beseekfiles ".rb" $* ;;
#         gv) shift; beseekfiles ".groovy" $* ;;
#         gr) shift; beseekfiles ".gradle" $* ;;
#         j)  shift; beseekfiles ".java" $* ;;
#         J)  shift; beseekjarfiles $* ;;
#         x)  shift; beseekfiles ".xml" $* ;;
#         .)  shift; beseekfiles "" $* ;;
          *)
	    if [ -f "build.gradle" ]
	    then
                fromfd=$1
		shift
                tofd=$1
		shift
		diffit "java" $fromfd $tofd
	    elif [ -f "Rakefile" ]
	    then
		diffit "rb" $*
	    else
		echo "not handled: $1"
	    fi
	    ;;
    esac
}

rundiff $*
