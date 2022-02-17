#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 <username>"
    exit 1
fi 

USER=$1
TAIL_SHELL=/usr/local/lib/no-login
USER_SHELL=$(cat /etc/passwd | grep "^$USER\>" | cut -d ":" -f7)

if [ "${USER_SHELL}" == "${TAIL_SHELL}" ]; then
    echo "The user '$USER' has been already disabled"
    exit 2
fi 

echo "We are going to disable the user '$USER'"

# 1. Fer backup del directory home
HOME=$(cat /etc/passwd | grep "^$USER\>" | cut -d ":" -f6)
BACKUP_FILE="/backup/$USER.tar"

# Creem carpeta backups per si no existia
mkdir -p /backup
if [ -d $HOME ]; then
    echo "Backing up $HOME on $BACKUP_FILE"
    find $HOME -type f -user $USER 2>/dev/null -exec tar -rvf $BACKUP_FILE {} \;
fi 
# 2. Esborrar tots els fitxers
find / -type f -user $USER 2>/dev/null -exec rm  {} \;

# 3. cambiar el shell per un tailscript
chsh $USER -s $TAIL_SHELL 
