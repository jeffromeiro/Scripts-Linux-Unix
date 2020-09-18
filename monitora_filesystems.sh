#!/bin/bash

#####################################################
## Verifica se os file systems possuem utilização  ##
## acima de determinado threshold e envia email    ##
## indicando quais estão alarmando                 ##
## necessário criar um arquivo fs.txt com          ##
## os file systems que devem ser monitorados       ## 
## Data: 12/08/2020                                ##
#####################################################


DIR=/serv_capacidade/monitoracao
FS=$DIR/fs.txt
CONT=0
HOST=`hostname`
THRSHOLD=80

while read p; do
  fs=`df -k "$p" |tail -1 |grep -o '[[:digit:]]*%' |grep -o '[[:digit:]]*'`
  if [ $fs -ge "$THRSHOLD" ]
  then
     CONT=`expr $CONT + 1`
     echo -e "<p>File System <b>$p</b> acima do threshold de $THRSHOLD% --> <b>$fs</b>%<p>" >> $DIR/saida.txt;
  fi
done <$FS

if [ $CONT -gt 0 ]
  then

cat <<EOF - $DIR/saida.txt | /usr/sbin/sendmail -t
To: nome@email.com
Subject: File system - Servidor $HOST
Content-Type: text/html
EOF
sleep 20
rm $DIR/saida.txt
fi
