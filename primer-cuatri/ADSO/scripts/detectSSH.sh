#!/bin/bash

USAGE="detectSSH.sh"

if [ $# -ne 0  ]
then
        echo $USAGE
        exit 1
fi

while true
do
        DETECTED=$( netstat -a | grep ssh | grep tcp | wc -l )
        UUID_P="c8257aec-27b3-4cf3-ac37-53a11f2e2390"
        ESTADO=$( netstat | grep ssh | grep  ESTABLISHED| awk '{print $6}' | uniq )
        ESTADO_MOSTRAR=$( netstat -a | grep ssh | grep tcp | grep -E 'LISTEN|ESTABLISHED' | awk '{print $6}' | sort | uniq  )
        # Si hay conexiones establecidas

        if [ $DETECTED -gt 0 ]
        then
                # informar estado conexion (ESTABLISHED/LISTEN)
                echo $ESTADO_MOSTRAR

                if [[ "$ESTADO" == "ESTABLISHED" ]]
                then
                        # montamos la particion /dev/sda4 sobre /home/aso/backups
                        # mount -t ext3 $UUID_P /home/aso/backups

                        # remontar la particion con ro --> solo lectura
                        mount -o remount,ro $UUID_P /home/aso/backups
                        echo remonta con ro
                fi
        else
                # remontar la particion con rw --> lectura-escritura
                mount -o remount,rw $UUID_P /home/aso/backups
                echo remonta con rw
        fi
        sleep 5

done

