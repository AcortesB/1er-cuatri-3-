#!/bin/bash
p=0
t=0
param=$2
usage="Usage: BadUser.sh [-p] [-t <time>]"
# detecció de opcions d'entrada: només son vàlids: sense paràmetres i -p

if [ $# -ne 0 ]; then 			#si el num. De parámetros ($#) es not equal 0 entonces
    if  [ $# -eq 1 ]; then			#si el num. de parámetros ($#) es equal 1 entonces
        if [ $1 == "-p" ]; then 			#si el primer parámetro ($1) es «-p» entonces
            p=1							#p = 1
        else						#si el primer parámetro no es «-p»
            echo $usage; exit 1				#sacamos por pantalla la var usage
        fi 	 
    elif [ $# -eq 2 ]; then 						#si el num. de parámetros ($#) no es 1
        if [ $1 == "-t" ]; then 			#si el primer parámetro ($1) es «-p» entonces
            t=1
            letra_param=${2: -1}
            num_param=${2:0: -1}
            
            if [ $letra_param != "d" ] && [ $letra_param != "m" ]; then # si no es meses o días no lo quiero
                echo $usage; exit 1
            elif [ $letra_param == "m" ]; then # meses
                num_param=$(($num_param*30))
            fi
        fi
    fi
fi

for user in $( cut -d: -f1 /etc/passwd ); do
    inact_usr=0
    home=`cat /etc/passwd | grep "^$user\>" | cut -d : -f6`
    if [ -d $home ]; then
        num_fich=`find $home -type f -user $user 2> /dev/null | wc -l`
    else
        num_fich=0
    fi
    
    if [ $t -eq 1 ]; then
        
        
        
        #si la letra que acompaña al parámetro es m o a lo dividimos para calcularlo todo con días

        
        user_proc=$(($( ps -u $user | wc -l)-1))                                # contamos el número de procesos que tiene este user 
        last_log=$(lastlog -b $num_param | grep "^$user\>" | wc -l)              # contamos el número de logins que ha tenido desde num_param2, nos quedamos el segundo campo de 
        # da 0 en caso de que hayas hecho login desde 20d hasta ahora ( usuario no existe )
        # da 1 en caso de que hayas hecho login >20d
        last_mod=$(find $home -user $user -type f -mtime -$num_param 2> /dev/null | wc -l) # contamos de todos sus archivos los que haya modificado desde hace num_param2 ( por ejemplo, desde hace 2 días )
                                                                                
        
        if [ $user_proc -eq 0 ] && [ $last_log -eq 1 ] && [ $last_mod -eq 0 ]; then     # si no tiene procesos, ni hace login desde x ni ha modificado sus archivos desde x
            inact_usr=1 # detectamos usuario inactivo
        fi
    fi 
    
    if [ $num_fich -eq 0 ] ; then
        
        if [ $p -eq 1 ]; then

            user_proc=$(($( ps -u $user | wc -l)-1))

            if [ $user_proc -eq 0 ]; then
                inact_usr=1
            fi
        else
            inact_usr=1
        fi
    fi
    
    if [ $inact_usr -eq 1 ]; then
        echo "$user"
    fi
      
done
