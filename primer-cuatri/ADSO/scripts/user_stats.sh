#!/bin/bash
usage="Usage: user_stats.sh"


if [ $# -ne 0 ]
then
    echo $usage; exit 1
fi 

echo "Resum de logins:"
for user in $( cut -d: -f1 /etc/passwd )
do

    num_logins=$(last $user | awk '{print $8,$9,$10}' |  cut -d "(" -f2 | cut -d ")" -f1 | grep -v "still logged in" | head -n -2 | wc -l)
    mins=0 #mins = temps de login total d'un user
    
    for line in $(last $user 2>/dev/null | cut -d "-" -f2 | grep -v "still logged in" | cut -d "(" -f2 | cut -d ")" -f1 | head -n -2)
    do
        echo $line | grep -q "+"
        if [ $? -eq 0 ]
        then
             days=$(echo line | cut -d"+" -f1)
             mins=$(echo "$days*24*60" | bc -l)
             
             hours=$(echo $line | cut -d"+" -f2 | cut -d":" -f1)
             mins=$(echo "$mins+($hours*60)" | bc -l)
             
             minutos=$(echo $line | cut -d"+" -f2 | cut -d":" -f2)
             mins=$(echo "$mins+$minutos" | bc -l)
        else
             hours=$(echo $line | cut -d"+" -f2 | cut -d":" -f1)
             mins=$(echo "$mins+($hours*60)" | bc -l)
             
             minutos=$(echo $line | cut -d"+" -f2 | cut -d":" -f2)
             mins=$(echo "$mins+$minutos" | bc -l)
        fi
        
    done
    
    echo "Usuari $user: temps total de login $mins min, nombre total de logins: $num_logins"
done

#espais en blanc entre una cosa i l'altra
echo
echo

echo "Resum d'usuaris connectats:"
for user in $( cut -d: -f1 /etc/passwd )
do
    actiu=$(last $user | grep "still logged in" | wc -l)
    if [ $actiu -gt 0 ]
    then
        num_proc=$(($( ps -u $user | wc -l)-1))
        
        porcentage=0
        for num in $(ps axo user,%cpu | grep $user | awk '{print $2}')
        do
            porcentage=$(echo "$porcentage+$num" | bc -l)
        done
        
        echo "Usuari $user: $num_proc processos -> $porcentage % CPU"
    fi
done
