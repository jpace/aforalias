#!/bin/bash
# -*- sh-mode -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build

beseeker() {
    ext=$1
    shift
    grp=$1
    shift
    find \( -type d \( -name .git -o -name .svn -o -name staging \) -prune \) \
         -o -type f -name "*$ext" -print0 | \
         sort -z | \
         xargs -0 $grp $*
}
    
beseekjarfiles() {
    beseeker ".jar" "glark --binary=list" $*
}
    
beseekzipfiles() {
    beseeker ".zip" "glark --binary=list" $*
}

beseekfiles() {
    local suffix=$1
    shift
    grp=$((which glark >/dev/null) && echo "glark" || echo "grep")
    find \( -type d \( -name .git -o -name .svn -o -name staging \) -prune \) \
         -o -type f -name "*$suffix" -print0 | \
         sort -z | \
         xargs -0 $grp $*
}

beseek() {
    for final in $@; do :; done
    if [[ -f $final || -d $final ]]
    then
	grp=$((which glark >/dev/null) && echo "glark" || echo "grep")
	$grp $*
	return
    else
	case "$1" in
            r)   shift; beseekfiles ".rb" $* ;;
            erb) shift; beseekfiles ".erb" $* ;;
            gv)  shift; beseekfiles ".groovy" $* ;;
            gr)  shift; beseekfiles ".gradle" $* ;;
            j)   shift; beseekfiles ".java" $* ;;
            J)   shift; beseekjarfiles $* ;;
            x)   shift; beseekfiles ".xml" $* ;;
            Z|z) shift; beseekzipfiles $* ;;
            .)   shift; beseekfiles "" $* ;;
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
    fi
}

beseek $*
