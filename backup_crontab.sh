#|/bin/bash

#####################################################
## Script que faz backup da crontab                ##
## Remove os arquivos mais melhores que 30 dias    ##
## Data: 13/03/2019                                ##
#####################################################

data=`date '+%Y%m%d'`
log=/serv_capacidade/CRONTAB/results/

/usr/bin/crontab -l > $log/crontab_$data.txt
/usr/bin/gzip $log/crontab_$data.txt

find $log -mtime +30 -exec rm -f {} \;
