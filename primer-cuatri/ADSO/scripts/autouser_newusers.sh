#!/bin/bash

USAGE="autouser_newusers.sh < file >"

# Comprobacion de parametros
if [ $# -ne 1 ]
then
        echo $USAGE
        exit 1
fi

FILE=$1
NEW_FILE=/home/new_file.txt

# Generacion del new_file con formato para newusers

# Si no existe lo creo
if [ ! -f $NEW_FILE ]
then
        touch $NEW_FILE
# Si existe lo pongo en blanco
else
        cp /dev/null $NEW_FILE
fi

# Generacion nuevo file con formato adecuado
for LINE in $( cat  $FILE | tr ' ' ':' )
do
        # <Username>:<Password>:<UID>:<GID>:<User Info>:<Home Dir>:<Default Shell>
        NAME=$( echo $LINE | cut -d: -f1 | cut -d, -f2 )
        surname=$( echo $LINE | cut -d: -f1 | cut -d, -f1  )
        info_name="$NAME $surname"
        PASSWORD="$NAME"
        UUID=""
        GID=""
        PHONE=$( echo $LINE | cut -d: -f3 )
        UMAIL=$( echo $LINE | cut -d: -f4 )
        INFO="$info_name, $PHONE, $UMAIL"
        UHOME="/home/estudiants/$NAME"
        USHELL="/bin/bash"

        NEW_LINE="$NAME:$PASSWORD:$UUID:$GID:$INFO:$UHOME:$USHELL"

        # Se anade la linea con formato al new_file
        echo "$NEW_LINE" >> $NEW_FILE 
done

# Se anaden los usuarios con el comando newusers
newusers --badname $NEW_FILE
