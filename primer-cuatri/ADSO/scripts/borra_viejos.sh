#!/bin/bash

USAGE="borra_viejos.sh < user >"

# Comprobacion de parametros
if [ $# -ne 1 ]
then
        echo $USAGE
        exit 1
fi

USER=$1
# comprobacion de usuario existente
if [ $( cat /etc/passwd | grep $USER | wc -l ) -eq 0 ]
then
        echo "Usuario inexistente"
        exit 1
fi
# 100 Mb --> Bytes
VALUE=$(( (100*1000*1000)/8 ))
DIR="/backup/backup_tmp"
BACKUPS_SIZE=$( du -sb $DIR | awk '{print $1}')

# Comprobacion de size
while [ $BACKUPS_SIZE -gt $VALUE ]
do
        #echo "backup size: $BACKUPS_SIZE"
        #echo "value: $VALUE"
        #echo "bucle"
        VIEJO=$( ls $DIR | sort | grep backup | grep '.tar' | head -n1 )
        #echo "Se va a borrar el $VIEJO"
        rm -r /$DIR/$VIEJO
        echo "Se ha reducido el espacio de ocupacion de backups" | mail -s "reduccion espacio backups" $USER@localhost
        BACKUPS_SIZE=$( du -sb $DIR | awk '{print $1}')
done
