# Comparativa Apache solo vs HAProxy + 2 Apache (gnuplot comparativa_haproxy.gp, desde benchmark/)
set terminal pngcairo size 1200,600 font "Sans,11"
set grid
set key bmargin center horizontal
set style fill solid 0.7
set boxwidth 0.35
set xrange [-0.6:2.6]
set xlabel "Peticiones simultáneas (ab -c)"

do for [graf in "rps tiempos"] {
  col = (graf eq "rps") ? 2 : 3
  set output "comparativa_haproxy_".graf.".png"
  set multiplot layout 1,2 title (graf eq "rps" ? "Peticiones por segundo" : "Tiempo medio por petición (ms)").": Apache solo vs HAProxy + 2 Apache" font "Sans,13"
  do for [origen in "servidor pc"] {
    ANTES   = origen."/ab_resumen.dat"
    DESPUES = origen."-haproxy/ab_resumen.dat"
    set title (origen eq "servidor" ? "ab desde el propio servidor" : "ab desde el PC (Internet hasta EE. UU.)")
    set ylabel (graf eq "rps" ? "Peticiones por segundo" : "ms por petición")
    set autoscale y
    stats ANTES using col nooutput
    M1 = STATS_max
    stats DESPUES using col nooutput
    set yrange [0:(M1 > STATS_max ? M1 : STATS_max)*1.18]
    plot ANTES   using ($0-0.18):col:xtic(1) with boxes lc rgb "#8d99ae" title "Apache solo", \
         DESPUES using ($0+0.18):col with boxes lc rgb "#2a9d8f" title "HAProxy + 2 Apache", \
         ANTES   using ($0-0.18):col:(sprintf("%.0f",column(col))) with labels offset 0,0.8 notitle, \
         DESPUES using ($0+0.18):col:(sprintf("%.0f",column(col))) with labels offset 0,0.8 notitle
  }
  unset multiplot
}
