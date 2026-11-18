# Comparativa PC vs servidor (gnuplot comparativa.gp, desde la carpeta benchmark/)
set terminal pngcairo size 1000,600 font "Sans,11"
set grid
set key left top
PC  = "pc/ab_resumen.dat"
SRV = "servidor/ab_resumen.dat"

# 1) Peticiones por segundo: barras agrupadas
set output "comparativa_rps.png"
set title "Peticiones por segundo: ab desde el PC vs desde el propio servidor"
set xlabel "Peticiones simultáneas (ab -c)"
set ylabel "Peticiones por segundo"
set style fill solid 0.7
set boxwidth 0.35
stats SRV using 2 nooutput
set yrange [0:STATS_max*1.15]
set xrange [-0.6:2.6]
plot SRV using ($0-0.18):2:xtic(1) with boxes lc rgb "#2a9d8f" title "desde el servidor (sin red)", \
     PC  using ($0+0.18):2 with boxes lc rgb "#e76f51" title "desde el PC (Internet hasta EE. UU.)", \
     SRV using ($0-0.18):2:(sprintf("%.0f",$2)) with labels offset 0,1 notitle, \
     PC  using ($0+0.18):2:(sprintf("%.0f",$2)) with labels offset 0,1 notitle

# 2) Tiempo medio por petición
set output "comparativa_tiempos.png"
set title "Tiempo medio por petición: ab desde el PC vs desde el propio servidor"
set ylabel "Tiempo medio por petición (ms)"
stats PC using 3 nooutput
set yrange [0:STATS_max*1.15]
plot SRV using 0:3:xtic(1) with linespoints lw 2 pt 7 ps 1.5 lc rgb "#2a9d8f" title "desde el servidor (sin red)", \
     PC  using 0:3 with linespoints lw 2 pt 7 ps 1.5 lc rgb "#e76f51" title "desde el PC (Internet hasta EE. UU.)", \
     SRV using 0:3:(sprintf("%.0f ms",$3)) with labels offset 0,1.2 notitle, \
     PC  using 0:3:(sprintf("%.0f ms",$3)) with labels offset 0,1.2 notitle
