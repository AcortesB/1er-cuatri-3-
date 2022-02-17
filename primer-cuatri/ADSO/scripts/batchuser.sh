#!/bin/bash

USAGE="batchuser.sh < valor >"

# Comprobacion de parametros
if [ $# -ne 1 ]
then
        echo $USAGE
        exit 1
fi

VALOR=$1
SLA5=$( uptime | awk '{ print$ 10 }' | cut -d, -f1 )
DIR="/root/batch"
echo "VALOR = $VALOR"
echo "SLA5 = $SLA5"
echo "DIRECTORIO DEL QUE COGEMOS LOS SCRIPTS = $DIR"

# Comparacion
#if [ $VALOR -lt $SLA5  ]
if [[ $( bc <<< "$VALOR < $SLA5" ) -eq 1 ]]
then
        # recorremos el directorio y si un archivo contiene "#!/bin/bash" entonces lo ejecutaremos
        for FILE in $( ls $DIR )
        do
                # Miramos si $DIR/$FILE tiene permisos de ejejcucion
                if [ -x $DIR/$FILE  ]
                then
                        # si tiene permisos de ejecucion ejecutamos el script
                        $DIR/$FILE
                fi
        done
fi
