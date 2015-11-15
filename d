#!/bin/zsh
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build
# d: diff

dirdiff() {
    diffcmd=$1
    diffargs=$2
    from=$3
    to=$4
    echo $diffcmd $diffargs -r $from $to
}

diffcmd=diff
diffargs=

if [[ $1 == '-W' ||  $1 == '--ignore-whitepace' ]]
then
    echo "whitespace considered harmless"
    shift
    diffargs="$diffargs -bwB"
fi
if [[ $1 == '-i' ||  $1 == '--ignore-case' ]]
then
    echo "case considered harmless"
    shift
    diffargs="$diffargs -i"
fi

echo "diffargs: $diffargs"
fromfd=$1
shift
tofd=$1
shift

if [[ -d $fromfd || -d $tofd ]]
then
    echo fromdir: $fromfd >&2
    echo todir: $tofd >&2

    # handle d foo/bar/Gz.txt glub, where glub is a directory containing foo/bar/Gz.txt
    fp=$fromfd/$tofd
    tp=$tofd/$fromfd

    if [[ -d $tp ]]
    then
        dirdiff $diffcmd $diffargs $fromfd $tp
    elif [[ -d $fp ]]
    then
        dirdiff $diffcmd $diffargs $fp $tofd
    elif [[ -f $tp ]]
    then
        diff $fromfd $tp
    elif [[ -f $fp ]]
    then
        diff $fp $tofd
    else
        dirdiff $diffcmd $diffargs $fromfd $tofd
    fi
else
    echo plain old diff
    diff $fromfd $tofd
fi
