#!/bin/bash

USAGE="fingerinfouser.sh < user name >"

if [ $# -ne 1 ]
then
        echo $USAGE
        exit 1
fi

USER=$1

APT=$( apt list --installed | grep finger | wc -l )
# DPKG=$( dpkg -l | grep finger | wc -l )

# Si finger installed
if [ $APT -eq 1 ]
then
        # Saco la informacion que me piden
        HOME=$( finger -lmsp $USER | grep Directory | awk '{print $2}' )
        echo "Home:$HOME"
        echo "Home size: $( du -sh $HOME | awk '{print $1}' )"
        OTHER_DIRS=""
        for DIR in $( find / -type f -user aso 2> /dev/null | cut -d"/" -f2 | uniq )
        do
                OTHER_DIRS="$OTHER_DIRS /$DIR "
        done
        echo "Other dirs: $OTHER_DIRS"
        echo "Active processes: $(($( ps -u $USER | wc -l )-1 ))"
        echo "Name: $( finger -lmsp $USER | grep Name | awk '{print $4" " $5" " $6}' )"
        echo "Home Phone: $( finger -lmsp $USER | grep Phone | awk '{print $6}' ) "
        if [ $( finger -lmsp $USER | grep Last | wc -l ) -ge 1 ]
        then
                echo "$(  finger -lmsp $USER | grep Last | tail -n1 )"
        fi

        if [ $( finger -lmsp $USER | grep 'Never logged in' | wc -l ) -ge 1 ]
        then
                echo "$( finger -lmsp $USER | grep 'Never logged in' | tail -n1 )"
        fi

        if [ $( finger -lmsp $USER | grep On | wc -l ) -ge 1 ]
        then
                echo "$( finger -lmsp $USER | grep 'On' | tail -n1 )"
        fi

else
        echo "Finger pkg not installed"
        exit 1
fi
