#!/bin/bash
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build
# d: diff

dirdiff() {
    from=$1
    to=$2
    diff --exclude=staging --exclude=.git --exclude=.svn -r $from $to
}

diffit() {
    local ext=$1
    local fromfd=$2
    local tofd=$3
    if [[ -d $fromfd || -d $tofd ]]
    then
        # handle d foo/bar/Gz.txt glub, where glub is a directory containing foo/bar/Gz.txt
        fp=$fromfd/$tofd
        tp=$tofd/$fromfd
        if [[ -d $tp ]]
        then
            dirdiff $fromfd $tp
        elif [[ -d $fp ]]
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
    if [[ -f "build.gradle" ]]
    then
	diffit "java" $*
    elif [[ -f "Rakefile" ]]
    then
	diffit "rb" $*
    else
	diffit "" $*
    fi
}

rundiff $*
