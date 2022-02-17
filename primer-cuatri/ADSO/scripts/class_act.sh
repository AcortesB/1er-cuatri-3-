#!/bin/bash
usage="Usage: class_act.sh <n> <usr_name>"


if [ $# -ne 2 ]
then
    echo $usage; exit 1
fi
user=$(cat /etc/passwd | grep "$2" | cut -d : -f5)
home=$(cat /etc/passwd | grep "$user" | cut -d : -f6)
num_fich=$(find $home -user $user -type f -mtime -$1 2> /dev/null | wc -l)
espai=0

for x in $(find $home -type f -mtime -$1  | xargs -I{} du {} | awk '{print $1}')
do
    espai=$(echo "$espai+$x" | bc -l)
done

echo "$2 ($user) $num_fich modificats que ocupen $espai KB"
