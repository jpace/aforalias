#!/bin/zsh
# -*- sh-mode -*-

# NAME

# d - diff

# SYNOPSIS

# d <from ...> <to>

# EXAMPLES

# d fromdir/foo.txt todir/foo.txt
#  % diff fromdir/foo.txt todir/foo.txt

# d -W fromdir/foo.txt todir/foo.txt
#  - ignores all whitespace
#  % diff -bwB fromdir/foo.txt todir/foo.txt

# d -i fromdir/foo.txt todir/foo.txt
#  - ignores case
#  % diff -i fromdir/foo.txt todir/foo.txt

# d -i fromdir/foo.txt todir/foo.txt
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

dirdiff() {
    diffcmd=$1
    diffargs=$2
    from=$3
    to=$4
    echo $diffcmd $diffargs -r $from $to
}

diffargs=""

ignore_whitespace=""
ignore_case=""

while getopts "iW" opt
do
    echo "opt: <<<$opt>>>"
    case $opt in
        i) echo "case"; diffargs="${diffargs} -i" ;;
        W) echo "whitespace"; diffargs="${diffargs} -bwB" ;;
        *) echo "huh?" ;;
    esac
done

shift $((OPTIND - 1))

echo "star: $*"

# exit

diffcmd=diff

echo "diffargs: ${diffargs}"

fromfd=$1
shift
tofd=$1
shift

if [[ -d $fromfd || -d $tofd ]]
then
    echo fromdir: $fromfd >&2
    echo todir: $tofd >&2

    # handle d foo/bar/Gz.txt glub, where glub is a directory containing foo/bar/Gz.txt
    frompath=$fromfd/$tofd
    topath=$tofd/$fromfd

    if [[ -d $topath ]]
    then
        dirdiff $diffcmd $diffargs $fromfd $topath
    elif [[ -d $frompath ]]
    then
        dirdiff $diffcmd $diffargs $frompath $tofd
    elif [[ -f $topath ]]
    then
        diff $fromfd $topath
    elif [[ -f $frompath ]]
    then
        diff $frompath $tofd
    else
        dirdiff $diffcmd $diffargs $fromfd $tofd
    fi
else
    echo plain old diff
    diff $fromfd $tofd
fi
