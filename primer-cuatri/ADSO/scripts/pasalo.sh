#!/bin/bash
usage="Usage: pasalo.sh <valor(KB)>"

if [ $# -ne 1 ]
then
    echo $usage; exit 1
else
    valor=$1
fi

#miramos si el valor es menor a 1024, si es así no hace falta pasarlo, lo sacamos con K
if [ echo "$valor<=1024" | bc ]
then
    echo "$div_decimal K"
#si es mayor o igual a 1024 será que como mínimo supera el Mega
else 
    div_decimal=$( echo "scale=1; $valor/1024" | bc -l )        #lo pasamos a Megas
    echo $div_decimal
    #miramos si el valor es menor a 1024, no hace falta pasarlo, lo sacamos con M
    if [ echo "$div_decimal<=1024" | bc ] 
    then
        echo "$div_decimal M"
    #si es mayor o igual a 1024 será que como mínimo supera el Giga
    else 
        div_decimal=$( echo "scale=1; $valor/(1024*1024)" | bc -l ) #lo pasamos a Gigas
        echo "$div_decimal G"
    fi
fi 


























#~ div_decimal=$( echo "scale=1; $valor/(1024*1024)" | bc -l )
#~ #miramos si pasandolo a GB nos queda con decimales
#~ echo "$div_decimal"
#~ echo $div_decimal | grep -q "\."
#~ echo "$?"
#~ if [ $? -ne 0 ] #si no tiene decimales
#~ echo "no tiene decimales, next"
#~ then
    #~ echo "$div_decimal G"
#~ else #si nos queda con decimales lo pasamos solamente a MB
    #~ div_decimal=$( echo "scale=1; $valor/1024" | bc -l )
    #~ if [ $? -ne 0 ] #si no tiene decimales
        #~ then
            #~ echo "$valor_decimal M"
        #~ else
            #~ echo "$valor K"
        #~ fi
#~ fi

#~ B=$valor

#~ if [ $KB -lt 1024 ]
#~ then
    #~ echo ${KB} kilobytes
    #~ MB=$(((KB+512)/1024))
#~ fi

#~ if [ $MB -lt 1024 ]
#~ then
    #~ echo ${MB} megabytes
    #~ GB=$(((MB+512)/1024))
#~ fi

#~ if [ $GB -lt 1024 ]
#~ then
    #~ echo ${GB} gigabytes
    #~ echo $(((GB+512)/1024)) terabytes
#~ fi

#~ B=$valor
#~ echo $B

#~ human_print(){
    #~ while read B dummy; do
    #~ echo "IN"
      #~ [ $B -lt 1024 ] && echo ${B} bytes && break
      #~ KB=$(((B+512)/1024))
      #~ echo $KB
      #~ [ $KB -lt 1024 ] && echo ${KB} kilobytes && break
      #~ MB=$(((KB+512)/1024))
      #~ echo $MB
      #~ [ $MB -lt 1024 ] && echo ${MB} megabytes && break
      #~ GB=$(((MB+512)/1024))
      #~ echo $GB
      #~ [ $GB -lt 1024 ] && echo ${GB} gigabytes && break
      #~ echo $(((GB+512)/1024)) terabytes
    #~ done
#~ }

#~ echo 120928312 http://blah.com | human_print
