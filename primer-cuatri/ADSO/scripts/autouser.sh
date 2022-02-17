#!/bin/bash

USAGE="autouser.sh [ADD/DEL] <colectivo> <fichero usuarios>"
OPCIONES_ADD_DEL="opciones [ADD/DEL]: ADD / DEL"
OPCIONES_COLECTIVO="opciones <colectivo>: professors / becaris / estudiants"

# Comprobacion parametros
if [ $# -ne 3  ]
then
        echo $USAGE
        exit 1
else
        if [[ "$1" != "ADD" ]] && [[ "$1" != "DEL" ]] || [[ "$2" != "professors" ]] && [[ "$2" != "becaris" ]] && [[ "$2" != "estudiants" ]]
        then
                echo $USAGE
                echo ""
                echo $OPCIONES_ADD_DEL
                echo $OPCIONES_COLECTIVO
                exit 1
        fi
fi

GRUPO=$2
FILE=$3

# ADD o DEL de los usuarios del fichero

# si ADD
if [[ "$1" == "ADD" ]]
then
        echo "adding"
        # leeremos el .txt y cogeremos el nombre
        for NOMBRE in $( cut -d, -f1 $FILE )
        do
                HOME=/home/$GRUPO/$NOMBRE
                # add del usuario 
                adduser $NOMBRE --force-badname --disabled-password --gecos "" --home $HOME &>/dev/null
                chmod -R 777 $HOME
                
                if [[ "$GRUPO" ==  "professors" ]]
                then
                        chmod 700 $HOME

                        # asignamos al usuario a sus grupos, si es profesor debe estar en los 3

                        # grupo de professors
                        usermod -a -G professors $NOMBRE
                        # grupo de becaris
                        usermod -a -G becaris $NOMBRE
                        # grupo de estudiants
                        usermod -a -G estudiants $NOMBRE
                else
                        chmod 770 $HOME
                fi

                if [[ "$GRUPO" == "becaris" ]] # si es un becari su dir sera del grup professors
                then
                        chgrp -R professors $HOME
                        # asignamos el usuario a sus grupos, si es un becari debe estar en el de becarios y en el de estudiantes

                        # grupo de becarios
                        usermod -a -G becaris $NOMBRE
                        #grupo de estudiantes
                        usermod -a -G estudiants $NOMBRE
                fi

                if [[ "$GRUPO" == "estudiants" ]] # si es un estudiant su dir sera del grup becaris
                then
                        chgrp -R becaris $HOME
                        # asignamos el usuario a su grupo, si es un estudiant solo debe estar en el de estudiants

                        # grupo de estudiants
                        usermod -a -G estudiants $NOMBRE
                fi
        done
# si DEL
else
        for NOMBRE in $( cut -d, -f1 $FILE )
        do
                HOME=/home/$GRUPO/$NOMBRE

                # eliminamos el usuario
                deluser $NOMBRE &>/dev/null
                # eliminamos recursivamente su home y por ende todos sus directorios y archivos
                rm -R $HOME

        done

fi
