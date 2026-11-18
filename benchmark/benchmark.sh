#!/bin/bash
# Benchmark de Apache con ab y datos listos para gnuplot.
# Uso: ./benchmark.sh   (desde la carpeta benchmark/)
URL="https://donis-asir.ddns.net/"   # la barra final es obligatoria para ab
N=1000                               # peticiones por prueba
CONCURRENCIAS="10 50 100"            # si cambias esto, cámbialo también en graficas.gp

: > ab_resumen.dat
for C in $CONCURRENCIAS; do
  echo "== Prueba con concurrencia $C =="
  ab -n $N -c $C -g ab_c${C}.tsv "$URL" > ab_c${C}.txt
  grep -E "Complete requests|Failed requests|Non-2xx|Requests per second|Time per request" ab_c${C}.txt

  # Columna 5 del .tsv (ttime = tiempo total en ms), ordenada de menor a mayor
  tail -n +2 ab_c${C}.tsv | cut -f5 | sort -n > ab_c${C}_ordenado.dat

  # Resumen: concurrencia, peticiones/seg, tiempo medio (ms)
  RPS=$(awk '/Requests per second/{print $4}' ab_c${C}.txt)
  TMEDIO=$(awk '/Time per request/{print $4; exit}' ab_c${C}.txt)
  echo "$C $RPS $TMEDIO" >> ab_resumen.dat
done

echo; echo "Resumen (concurrencia, peticiones/s, ms medios):"; cat ab_resumen.dat
gnuplot -e "origen='$(hostname)'" graficas.gp && echo "Gráficas generadas: grafica_tiempos.png grafica_rps.png"
