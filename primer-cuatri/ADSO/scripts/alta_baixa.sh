#!/bin/bash

USAGE="alta_baixa.sh <A/B> <user> <group>"

# comprobacion parametros
if [ $# -ne 3 ]
then
        echo $USAGE
        exit 1
fi

ADDDEL=$1
USER=$2
GROUP=$3

if [ $# -eq 3 ]
then
        if [[ "$ADDDEL" != 'A' ]] && [[ "$ADDDEL" != 'B'  ]]
        then
                echo $USAGE
                echo "Opciones de A/B: A/B"
                echo "Opciones de group: PAS/PDI/EST"
                exit 1
        fi

        if [ $( cat /etc/group | grep $GROUP | wc -l ) -eq 0 ]
        then
                echo "Grupo inexistente"
                echo ""
                echo $USAGE
                echo "Opciones de A/B: A/B"
                echo "Opciones de group: PAS/PDI/EST"
                exit 1
        fi
fi

HOME="/home/$GROUP/$USER"

# anadir o eliminar usuarios
if [[ "$ADDDEL" == 'A' ]] # si toca anadir
then
        # si no esta ya en su grupo lo anadiremos
        if [ $( cat /etc/group | grep $GROUP | cut -d: -f4 | grep $USER | wc -l ) -ge 1 ]
        then
                echo "El usuario $USER ya pertenece al grupo $GROUP"
                exit 1
        else
                # anadimos user al sistema
                adduser $USER --force-badname --disabled-password --gecos "" --home $HOME &>/dev/null
                # le damos permisos 700 a los ficheros del usuario
                chmod -R 700 $HOME
                # le damos permisos al directorio del usuario
                chmod 750 $HOME
                # asignamos el usuario a su grupo
                usermod -a -G $GROUP $USER
                #echo "usuario $USER  anadido al grupo $GROUP"
        fi

else # si toca eliminar
        if [ $( cat /etc/passwd | grep $USER | wc -l ) -eq 0 ] # Si el user no existe en el sistema
        then
                echo "Usuario inexistente"
                exit 1
        else
                if [ $( cat /etc/group | grep $GROUP | cut -d: -f4 | grep $USER| wc -l ) -ge 1 ] # Si pertenece a ese grupo
                then
                        # eliminamos el usuario y su home
                        deluser $USER --remove-home &>/dev/null
                        echo "usuario $USER eliminado"
                else
                        echo "El usuario $USER no pertenece al grupo $GROUP"
                        exit 1
                fi
        fi
fi
