#!/bin/bash

USAGE="temp_protection.sh <value>"

if [ $# -ne 1  ]
then
        echo $USAGE
        exit 1
fi

VALUE=$1
TEMP_GEO=$( inxi -w 2>/dev/null | grep temperature | awk '{print $4}' )

if [[ $(bc <<< "$TEMP_GEO > $VALUE") -eq 1 ]]
then
        NUM_PROC=$(($( ps aux | wc -l)-1))
        PERC_USED_MEM=$( df --total | tail -n1 | awk '{print $5}' )
        MSG="Temperatura de punto de geologalizacion supera los $VALUE grados\nTemperatura exterior: $TEMP_GEO\nTotal memoria utilizada: $PERC_USED_MEM\nNumero de procesos en ejecucion: $NUM_PROC"

        #se envía mensaje a la terminal de users conectados remota y localmete
        echo -e $MSG | wall
fi
