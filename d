#!/bin/zsh
# -*- sh-mode -*-

# NAME

# d - diff

# SYNOPSIS

# d <from ...> <to>

# EXAMPLES

# d fromdir/foo.txt todir/foo.txt
#  % diff fromdir/foo.txt todir/foo.txt

# d -W  fromdir/foo.txt todir/foo.txt
#  - ignores all whitespace
#  % diff -bwB fromdir/foo.txt todir/foo.txt

# d -i  fromdir/foo.txt todir/foo.txt
#  - ignores case
#  % diff -i fromdir/foo.txt todir/foo.txt

# d -i  fromdir/foo.txt todir/foo.txt
#  - ignores case
#  % diff -i fromdir/foo.txt todir/foo.txt

# d fromdir/foo.txt todir
#  - if todir is a directory, this is expanded to:
#  % diff fromdir/foo.txt todir/foo.txt

# d fromdir todir
#  - if fromdir and todir are directories, this is expanded to:
#  % diff -r fromdir todir
#  actually, this uses the default excludes:
#  % diff --exclude=staging --exclude=.svn --exclude=.git --exclude=*~ -r fromdir todir
#  actually, this uses the default excludes:

dirdiff() {
    diffcmd=$1
    diffargs=$2
    from=$3
    to=$4
    echo $diffcmd $diffargs -r $from $to
}

while getopts "iW" opt
do
    echo "opt: <<<$opt>>>"
done

echo "star: $*"

# exit

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
