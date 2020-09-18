#!/bin/bash


##########################################3###############################
## Autor: Jefferson Romeiro                                             ##
## Data: 17/09/2020                                                     ##
##                                                                      ##
## Extrai leitura e escrita do disco pelo comando dd                    ##
## Execução: nohup ./read_srite.sh &                                    ##
##                                                                      ##
## DIR= Diretório em que o arquivo será criado e testado o tempo        ##
## LOG = Saída do script em CSV                                         ##
## INTERVALO_SEG= Informar um número em segundos do intervalo de coleta ##
## QTD_HORAS_EM_EXEC= Para um dia de coletao número será 24             ##
##                                                                      ##
##########################################################################

# Alterar o DIR para a pasta que será avaliada
DIR=/u01/

#Alterar para o caminho que deve receber o arquivo de log
LOG=/home/jeffromeiro/

# Comentado o cd por conta de falha de permissão na escrita da pasta, descomentar posteriormente
cd $DIR

#Alterar o intervalo de escrita, atualmente está 300 segundos
INTERVALO_SEG=300

#Alterar a quantidade de horas em execução, atualmente está em 120 horas (5 dias)

QTD_HORAS_EM_EXEC=120

CONTADOR=$((QTD_HORAS_EM_EXEC*3600/INTERVALO_SEG))
echo "DATA;DIRETORIO;GBYTES_COPIADOS;TEMPO_LEITURA_S;LATENCIA_LEITURA_GB_S;TEMPO_ESCRITA_S;LATENCIA_ESCRITA_GB_S" >> $LOG/saida_dd.csv

while [  $CONTADOR -gt 0 ]; do


        DATA=`date +%d/%m/%Y\ %H:%M:%S`
        #Gravação
        sync;dd if=/dev/zero of=tempfile bs=1M count=1024 2>write.out;sync

        #Leitura
        dd if=tempfile of=/dev/zero bs=1M count=1024 2>read.out


        TEMPO_LEITURA=$(cat read.out |tail -1 |awk '{print $6}')
        TEMPO_ESCRITA=$(cat write.out |tail -1 |awk '{print $6}')
        LATENCIA_LEITURA=$(cat read.out |tail -1 |awk '{print $8}')
        UNIDADE_LEITURA=$(cat read.out |tail -1  |awk '{print $9}')
        LATENCIA_ESCRITA=$(cat write.out |tail -1 |awk '{print $8}')
        UNIDADE_ESCRITA=$(cat write.out |tail -1  |awk '{print $9}')
        GBYTES=$(cat write.out |tail -1  |awk '{print $1}')
        GBYTES=$(echo "scale=2; $GBYTES/1024/1024/1024" | bc)

        # Converte para GB/s para igualar a unidade de escrita
        if [ "$UNIDADE_ESCRITA" == "MB/s" ]; then
            LATENCIA_ESCRITA="0"$(echo "scale=3; $LATENCIA_ESCRITA/1024" | bc)
            UNIDADE_ESCRITA="GB/s"
        elif [ "$UNIDADE_ESCRITA" == "KB/s" ]; then
            LATENCIA_ESCRITA="0"$(echo "scale=8; $LATENCIA_ESCRITA/1024/1024" | bc)
            UNIDADE_ESCRITA="GB/s"
        else
            UNIDADE_ESCRITA="GB/s"
        fi


        # Converte para GB/s para igualar a unidade de leitura
        if [ "$UNIDADE_LEITURA" == "MB/s" ]; then
            LATENCIA_LEITURA="0"$(echo "scale=3; $LATENCIA_LEITURA/1024" | bc)
            UNIDADE_LEITURA="GB/s"
        elif [ "$UNIDADE_LEITURA" == "KB/s" ]; then
            LATENCIA_LEITURA="0"$(echo "scale=8; $LATENCIA_LEITURA/1024/1024" | bc)
            UNIDADE_LEITURA="GB/s"
        else
            UNIDADE_LEITURA="GB/s"
        fi


        echo "$DATA;$DIR;$GBYTES;$TEMPO_LEITURA;$LATENCIA_LEITURA;$TEMPO_ESCRITA;$LATENCIA_ESCRITA" >> $LOG/saida_dd.csv

        let CONTADOR=CONTADOR-1;

        /usr/bin/rm tempfile
        /usr/bin/rm read.out
        /usr/bin/rm write.out

        sleep $INTERVALO_SEG

done
cd $LOG
exit;
