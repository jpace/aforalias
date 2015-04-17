#!/bin/bash
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build

if $(which glark >/dev/null)
then
    grp="glark"
    grpbinlist="glark --binary=list"
else
    grp="grep"
    grpbinlist="grep"
fi

beseeker() {
    ext=$1
    shift
    grp=$1
    shift
    find \( -type d \( -name .git -o -name .svn -o -name staging \) -prune \) \
         -o -type f -regex ".*$ext\$" -print0 | \
         sort -z | \
         xargs -0 $grp $*
}

beseek_binary_list_files() {
    ext=$1
    shift
    beseeker $ext $grpbinlist $*
}

beseek_files() {
    local ext=$1
    shift
    find \( -type d \( -name .git -o -name .svn -o -name staging \) -prune \) \
         -o -type f -regex ".*$ext\$" -print0 | \
         sort -z | \
         xargs -0 $grp $*
}

beseek() {
    for final in $@; do :; done
    if [[ -f $final ]]
    then
	$grpbinlist $*
	return
    else
	case "$1" in
            r)   shift; beseek_files "\.rb" $* ;;
            erb) shift; beseek_files "\.erb" $* ;;
            gv)  shift; beseek_files "\.groovy" $* ;;
            gr)  shift; beseek_files "\.gradle" $* ;;
            j)   shift; beseek_files "\.java" $* ;;
            J)   shift; beseek_binary_list_files "\.jar" $* ;;
            T|tgz|tz)   shift; beseek_binary_list_files ".\(tar.gz\|tgz\)" $* ;;
            x)   shift; beseek_files "\.xml" $* ;;
            Z|z) shift; beseek_binary_list_files "\.zip" $* ;;
            .)   shift; beseek_files "" $* ;;
            *)
		if [ -f "build.gradle" ]
		then
		    beseek_files "java" $*
		elif [ -f "Rakefile" ]
		then
		    beseek_files "rb" $*
		else
		    beseek_files "" $*
		fi
		;;
	esac
    fi
}

beseek $*
