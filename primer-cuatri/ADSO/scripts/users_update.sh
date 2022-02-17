#!/bin/bash

usage="Usage: users_update.sh <file>"

if [ $# -ne 1  ]
then
        echo $usage
        exit 1
fi

FILE=$1

#ANADIR USUARIOS Y CREAR GRUPOS Y SUS DIRECTORIOS SI NO EXISTEN
for user in $( cut -d, -f1 $FILE ) #miramos nombre por nombre del .txt
do
    grupo=$( cat $FILE | grep $user |  cut -d, -f3 ) 
    #echo "usuario $user"
    #echo "grupo $grupo" 
    home=/home/$grupo/$user

    if [ ! -d /home/$grupo ] #si el directorio $home no existe
    then
        #creamos el grupo
        addgroup $grupo --force-badname &>/dev/null
        echo "group $grupo added"
        #creamos el directorio
        mkdir /home/$grupo
        echo "creando directorio /home/$grupo"
        #se dan permisos al dir del grupo
        chmod 777 /home/$grupo
        echo "perms of /home/$grupo gave it"
        #se crean los directorios compartidos
        mkdir /home/$grupo/grup
        mkdir /home/$grupo/public
        echo "creando directorios /home/$grupo/grup and /home/$grupo/public"
        #se dan permisos a los directorios publicos (grup 770, public 777)
        chmod 770 /home/$grupo/grup
        chmod 777 /home/$grupo/public
        echo "perms gave to grup nd public"
        #cambiamos grupo a los dir de los equipos
        chgrp $grupo /home/$grupo/
        echo "cambiando grupo a /home/$grupo/"
        #cambiamos grupo a los dir public y grup
        chgrp $grupo /home/$grupo/grup
        chgrp $grupo /home/$grupo/public
        echo "grupo cambiado a los dirs grup y public"
    fi

    presente=$( cat /etc/group | grep $user | wc -l ) #miramos si encontramos ese nombre en el /etc/group en us mismo group
    if [ $presente -eq 0  ] # si el numero de lineas es 0
    then
        #anadimos el user al sistema
        #echo "home $home"
        adduser $user --force-badname --disabled-password --gecos "" --home $home &>/dev/null # con este comando se añade el usuario y se creasu dir
        echo "user $user added"
        chmod -R 700 $home # permisos rwx --- ---
        #ls -la /home/$grupo
        echo "permisos dados"
        usermod -a -G $grupo $user #asignamos el usuario a su grupo
        echo "user $user added to group $grupo"
    fi
done
 ---------------------------------------------------------------------------
#ELIMINAR USUARIOS
for grupo in $( ls /home )
do 
    if [ -d /home/$grupo/grup ] && [ -d /home/$grupo/public ]
    then
        echo "mirando miembros de $grupo"
        usuarios_grupo_sistema=$(cat /etc/group | grep $grupo | cut -d: -f4 |sed 's/,/ /g' )
        #recorro usuarios_grupo_sistema y hagi un grep en el .txt de cada nombre de usuario
        for nombre in $usuarios_grupo_sistema
        do
            #si no esta puedo eliminar a dicho usuario del sistema
            presente=$( cat $FILE | grep $nombre | wc -l )
            if [ $presente -eq 0  ]
            then
                #eliminamos usuario con deluser
                deluser $nombre --remove-home &>/dev/null
                echo "deleted $nombre"
                #ls -la /home/$grupo
            fi
        done
    fi
done
----------------------------------------------------------------------------
#CUANDO ACABE DE ANADIR O ELIMINAR USUARIOS
#MIRARA SI HAY ALGUN EQUIPO SIN USUARIOS
for folder in $( ls /home  )
do
    if [ -d /home/$folder/grup ] && [ -d /home/$folder/public ] && [ $( ls /home/$folder | wc -l ) -eq 2 ]
    then
        #si una carpeta del /home tiene estas 2 carpetas y encima solo las tiene a ellas
        #quiere decir que es un equipo sin usuarios, por tanto se eliminará su directorio
        rm -R /home/$folder
        echo "deleted /home/$folder directory"
        #ls /home
        delgroup $folder &>/dev/null
        echo "deleted $folder group "
    fi
done

