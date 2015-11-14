#!/bin/zsh
# -*- sh -*-

# s: search (grep)
# f: find
# l,d: list (dir)
# e: eyeball (view)
# o: open
# b: build

grp=$((which glark >/dev/null) && echo "glark" || echo "grep")

for xx in "$@"
do
    echo xx: $xx :xx >&2
done
for final in $@; do :; done

if [[ -f $final || -d $final ]]
then
    echo "running grep, since $final found as file or directory" >&2
    grp=$((which glark >/dev/null) && echo "glark" || echo "grep")
    $grp $*
    return
else
    echo "1: '$1'" >&2
    case "$1" in
        rb|r)
            shift
            f "rb" | xargs $grp $*
            ;;

        erb)
            shift
            f "erb" | xargs $grp $*
            ;;

        groovy|gv)
            shift
            f "groovy" | xargs $grp $*
            ;;

        gradle|gr)
            shift
            f "gradle" | xargs $grp $*
            ;;

        java|j)
            shift
            f "java" | xargs $grp $*
            ;;

        jar|J)
            shift
	    # this will work with glark, but not grep:
            f "jar" | xargs $grp --binary=list $*
            ;;

        zip|Z|z)
            shift
	    # this will work with glark, but not grep:
            f "zip" | xargs $grp --binary=list $*
            ;;

        xml|x)
            shift
            f "xml" | xargs $grp $*
            ;;

        .)
            shift
            f "." | xargs $grp $*
            ;;

        -s=*) 
            sfx=$1
            shift
            sfx=`echo $sfx | sed -re 's/^\-s=\.\?//'`
            echo sfx $sfx >&2
            f -s $sfx $* | xargs $grp $*
            ;;

        -s) 
            shift
            sfx=$1
            shift
            echo sfx $sfx >&2
            sfx=`echo $sfx | sed -re 's/^\.//'`
            echo sfx: $sfx >&2
            f -s $sfx | xargs $grp $*
            ;;

        *)
            if [[ -f "build.gradle" || -f "build.xml" ]]
            then
                f "java" | xargs $grp $*
            elif [ -f "Rakefile" ]
            then
                echo "rakefile exists" >&2
                f "rb" | xargs $grp $*
            else
                echo "not handled: $1" >&2
            fi
            ;;
    esac
fi
