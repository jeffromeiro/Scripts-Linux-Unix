#!/bin/bash

intervalo_seg=10
horas_em_exec=1
contador=$((horas_em_exec*3600/intervalo_seg))
export x=1
while [[ $x -le $contador ]] ; do

V_Host=`hostname`
V_Home=`pwd`

V_OUTPUT_TOP=$V_Home/top_$V_Host.csv
V_OUTPUT_PS=$V_Home/ps_.$V_Host.csv

# Execucao TOP
 echo "DATE;PID;USER;VIRT;RES;SHR;%CPU;%MEM;LOAD;PROCESSES;CPU_TOTAL;MEM_TOTAL_USED;COMMAND" >> "$V_OUTPUT_TOP"
 DATATOP=`date '+%d/%m/%Y %H:%M:%S'`
 top -b -c -H -n 1 | awk -v date="${DATATOP}" '{ { if(NR == 1) { if ($12=="average"||$12=="average:") load = substr($13,1,length($13)-1); else load = substr($12,1,length($12)-1) } } { if(NR == 2) { proc = $2 } } { if(NR == 3) { split($5,cpu,"%"); cpu_total = 100 - cpu[1]; } } { if(NR == 4) { mem_used = $4 } } { if(NR > 7) { print date";"$1";"$2";"$5";"$6";"$7";"$9";"$10";"load";"proc";"cpu_total";"mem_used";"$12 } } }' >> $V_OUTPUT_TOP &


#Execucao PS
 echo "DATE;UID;PID;PPID;%CPU;%MEM;RSS;COMMAND" >> "$V_OUTPUT_PS"
 ps -eo uid,pid,ppid,pcpu,%mem,rss,args | grep -v %CPU | awk -v "a=`date '+%d/%m/%Y %T'`" '{print a ";"$1";"$2";"$3";"$4";"$5";"$6";"$7" "$8 $9 $10" "$11" "$12 " "$13}' >> $V_OUTPUT_PS &


sleep $intervalo_seg
export x=`expr $x + 1`
done
