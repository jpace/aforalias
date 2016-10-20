#!/bin/zsh
# -*- sh-mode -*-

if [[ -e .git ]]
then
	git $*
elif [[ -e .svn ]]
then
    svn $*
fi
