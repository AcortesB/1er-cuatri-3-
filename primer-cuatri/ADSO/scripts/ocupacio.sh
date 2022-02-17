#!/bin/bash

espai_llegible (){
#  Mostra el espai per als humans
    espai=$1
    user=$2
    if [ $espai -gt $((1024*1024*1024)) ]
    then
        echo "$user $((espai/(1024*1024*1024)))GB"
    elif [ $espai -gt $((1024*1024)) ]
    then
        echo "$user $((espai/(1024*1024)))MB"
    elif [ $espai -gt 1024 ]
    then
        echo "$user $((espai/1024)) KB"
    else
        echo "$user $espai B"
    fi
}

max_usage=0
usage="Usage: ocupacio.sh [-g grup] <max_permes (B/K/M/G)>"
# detecció de opcions d'entrada: només és vàlid amb paràmetre max_permes

if [ $# -ne 1 ] && [ $# -ne 3 ]; then                   #si el num. De parámetros ($#) es not equal 0 entonces
    echo $usage; exit 1                         #sacamos por pantalla la var usage
else
    max_usage=$1;
fi

# Per defecte agafem tots els usuaris
users=$( cut -d: -f1 /etc/passwd)

g=0
if [ $# -eq 3 ]
then
    if [ $1 == "-g" ]
    then
        # Si ens pasen l'opcio  -g  llavors agaferm nomes els usuaris del grup especificat
        g=1
        grup=$2
        users=$(cat /etc/group | grep $grup | cut -d ":" -f4 | tr ',' ' ')
        max_usage=$3
    fi
fi

total_grup=0

# leemos el /etc/passwd y cogemos el nombre de usuario
for user in $users; do
    home=`cat /etc/passwd | grep "^$user\>" | cut -d : -f6`
    if [ -d $home ]
    then

        # Per cada usuari agafem el total d'espai utilitzat en el seu home
        espai=$(du -cbhsx -k $home 2> /dev/null | grep "total" | awk '{print $1}')   #espai en B
    
        # nos quedamos con la letra y el valor de max_usage
        letra_max_usage=${max_usage: -1}
        num_max_usage=${max_usage:0: -1}

        # Pasem el  parametre del usuari a Bytes
        if [ ${letra_max_usage} = "K" ]
        then
            num_max_usage=$(($num_max_usage * 1024))
        elif [ ${letra_max_usage} = "M" ]
        then
            num_max_usage=$(($num_max_usage * (1024*1024)))
        elif [ ${letra_max_usage} = "G" ]
        then
            num_max_usage=$(($num_max_usage * (1024*1024)))
        fi

        # Comparem si l'espai del home es mes gran que el especificat per parametre
        if [ $espai -gt $num_max_usage ]
        then
            echo "echo 'Estas ocupant molt de disc, elimina fichers amb la comanda rm'" 2>/dev/null >> $home/.profile
            echo "echo 'Per eliminar aquest missatge elimina les ultimes 2 lines del teu .profile'" 2>/dev/null >> $home/.profile          
        fi

        # Si el grup esta especificat sumem els valors
        if [ $g -eq 1 ]
        then
            total_grup=$((total_grup + espai))
        fi

        # Mostrem l'espai llegible (en MB/KB/MB/GB) per usuari
        espai_llegible $espai $user

    fi
done


if [ $g -eq 1 ]
then
    #  Mostrem l'espai llegible del grup
    echo
    echo "TOTAL: "
    espai_llegible $total_grup $grup
fi
