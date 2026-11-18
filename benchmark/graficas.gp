# Gráficas de los resultados de ab (lo llama benchmark.sh, o: gnuplot graficas.gp)
set terminal pngcairo size 1000,600 font "Sans,11"
set grid
C = "10 50 100"

# 1) Tiempo de respuesta de cada petición, ordenadas de más rápida a más lenta
set output "grafica_tiempos.png"
if (!exists("origen")) origen = "?"
set title "ab: 1000 peticiones a https://donis-asir.ddns.net/ (lanzado desde ".origen.")"
set xlabel "Peticiones (ordenadas de más rápida a más lenta)"
set ylabel "Tiempo total de respuesta (ms)"
set key left top
plot for [c in C] "ab_c".c."_ordenado.dat" using 0:1 with lines lw 2 title "concurrencia ".c

# 2) Peticiones por segundo según la concurrencia
set output "grafica_rps.png"
set title "Rendimiento de Apache según la concurrencia (lanzado desde ".origen.")"
set xlabel "Peticiones simultáneas (ab -c)"
set ylabel "Peticiones por segundo"
set style fill solid 0.6
set boxwidth 0.5
stats "ab_resumen.dat" using 2 nooutput
set yrange [0:STATS_max*1.15]
unset key
plot "ab_resumen.dat" using 0:2:xtic(1) with boxes, \
     ""               using 0:2:(sprintf("%.1f", $2)) with labels offset 0,1
