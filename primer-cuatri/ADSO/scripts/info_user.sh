#!/bin/bash
usage="Usage: info_user.sh <usr_name>"


if [ $# -ne 1 ]
then
    echo $usage; exit 1
else
    user=$1
fi

home=$(cat /etc/passwd | grep "^$user\>" | cut -d : -f6)

if [ -d $home ]
then
    espai=$(du -chsx $home 2> /dev/null | grep "total" | awk '{print $1}')
    altres_directoris=$( find / -type f -user $user 2> /dev/null | cut -d"/" -f2 | uniq | grep -v home | xargs echo )
    num_proc_act=$(($( ps -u $user | wc -l)-1))
    
    echo "Home: $home"
    echo "Home size: $espai"
    echo "Other dirs: $altres_directoris"
    echo "Active processes: $num_proc_act"
fi
