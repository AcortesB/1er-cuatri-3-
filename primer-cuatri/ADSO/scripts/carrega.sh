#!/bin/bash

USAGE="carrega.sh < valor B >"

if [ $# -ne 1  ]
then
        echo $USAGE
        exit 1
fi

VALOR=$1
CARGA_DIR=$( du -shb /var/log/ | awk '{ print $1 }' | cut -dM -f1 )

# si carga >= VALOR
if [ $CARGA_DIR -ge $VALOR ]
then
        # programo backup snapshot para cada primer lunes del mes a las 8:00 h
        echo "00 8 * * 1 [ "$(date '+%u')" = "1" ] && backup-rsync-snapshot.sh" >> /var/spool/cron/crontabs/root         
else
        #borramos la entrada de la crontab que tiene programados los backups snapshot
        sed -i '/backup-rsync-snapshot.sh/d' /var/spool/cron/crontabs/root >> /var/spool/cron/crontabs/root
        # programo backups snapshot at now+5min
        backup-rsync-snapshot.sh | at now+5min
fi
