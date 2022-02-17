#!/bin/bash

USAGE="cpudetect.sh < valor >"

if [ $# -ne 1 ]
then
        echo $USAGE
        exit 1
fi

VALOR=$1
PREGUNTA="Desea eliminar el proceso? (Yes/No)"

while true
do
        # Recorremos el resultado del comando top y miramos si hay algun %CPU > VALOR
        for PROCESS in $( top -bn 1 | tail -n +8 | awk '{print $1":"$2":"$9":"$12 }' )
        do
                CPU_P=$( echo $PROCESS | cut -d: -f3 )
                if [[ $( bc <<< "$CPU_P > $VALOR")  -eq 1 ]]
                then
                        #echo $PROCESS | cut -d: -f4
                        # conseguimos el nombre del user y el nombre y PID del proceso 
                        PID=$( echo $PROCESS | cut -d: -f1)
                        USER=$( echo $PROCESS | cut -d: -f2)
                        PROCESS_NAME=$( echo $PROCESS | cut -d: -f4)
                        echo "%CPU superado con el proceso $PROCESS_NAME"
                        echo "PID del proceso: $PID"
                        echo "Propietario del proceso: $USER"
                        echo $PREGUNTA
                        read RESPUESTA

                        if [[ "$RESPUESTA" == "Yes" ]]
                        then
                                # Eliminamos el proceso
                                kill -9 $PID
                                #exit 1
                        fi
                        exit 1
                fi
        done
done
