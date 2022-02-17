#!/bin/bash
max_usage=0
usage="Usage: ocupacio.sh [-g grup] <max_permes>" 
# detecció de opcions d'entrada: només és vàlid amb paràmetre max_permes

if [ $# -ne 1 ] && [ $# -ne 3 ]; then 			#si el num. De parámetros ($#) es not equal 0 entonces
    echo $usage; exit 1				#sacamos por pantalla la var usage
else
    max_usage=$1;
fi

# leemos el /etc/passwd y cogemos el nombre de usuario
for user in $( cut -d: -f1 /etc/passwd ); do
    total_size=0
    for size in $(find / -type f -not -path /proc -user $user | xargs -I{} du "{}" | awk '{print $1}'); do #ahora tenemos los espais de todos los ficheros de los users
        total_size=$(($total_size+$size))
        echo "$user\t $total_size KB"
    done 
done


# 
