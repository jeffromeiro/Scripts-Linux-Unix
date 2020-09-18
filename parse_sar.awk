#!/usr/bin/gawk

####################################################################
# Script: parse_sar_cpu.awk
# Autor: Jefferson Romeiro
# Data: 24/07/2018
# v=1.0
# Descrição: Fazer o parse de um arquivo sar
# var numero: Alterar a linha para o valor encontrado no cabeçalho
# Modo de Execução: gawk -f parse_sar_cpu.awk arquivo_sar
#####################################################################
{ 
    if (NR==1) { 
      data=$4;
 }
 numero=1; #linha do sar em que se encontra a primeira linha de dados
   if (NR >= numero){ 
      dia=substr(data,1,2);
      mes=substr(data,4,2); 
      ano=substr(data,7,4); 
      if (metrica == "u") {
          print dia"/"mes"/"ano,$1";"$2";"$3";"$4";"$5";"$6";"$7";"$8
      } else if (metrica == "r") {
          print dia"/"mes"/"ano,$1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9";"$10";"$11
      } else if (metrica == "d" || metrica == "n" || metrica == "B") {
          print dia"/"mes"/"ano,$1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9";"$10
      } else if (metrica == "b" || metrica == "S") {
          print dia"/"mes"/"ano,$1";"$2";"$3";"$4";"$5";"$6
      } else if (metrica == "q") {
          print dia"/"mes"/"ano,$1";"$2";"$3";"$4";"$5";"$6";"$7
      } else if (metrica == "w" || metrica == "W") {
          print dia"/"mes"/"ano,$1";"$2";"$3
      }
   }
}

