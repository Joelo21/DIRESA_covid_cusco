*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
*Program: 		Data Visualization (Positividad Diaria)
*first created: 02/06/2021
*last updated:  04/05/2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	

* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).
use "${datos}\output\data_series_region.dta", clear

* Para dias a inicios de semana
drop if fecha < d(01jan2021)

*rename fecha_resultado fecha 

gen numero = _n
*replace semana = 11 if fecha == 21987 | fecha == 21988
*replace semana = 12 if fecha > 21988 & fecha <= 21995

gen semana =.
replace semana = 1 if numero >= 1 & numero <= 7
replace semana = semana[_n-7] + 1 if numero > 7

*collapse (mean) positivo positivo_pcr positivo_pr positivo_ag prueba prueba_pcr prueba_pr prueba_ag, by(semana)
*recode positivo* (0=.)

collapse (mean) positivo_pcr positivo_ag  prueba_pcr prueba_ag, by(semana)

*drop if positivo == 0 
*save "${datos}\output\data_diaria_acumulado.dta", replace
*use "${datos}\output\data_diaria_acumulado.dta", clear

label var semana "Semana Epidemiológica"
*drop if semana < 53
*replace semana = _n 

drop if semana > $semana

* Generamos las variables pertinentes.
*gen positividad = positivo/prueba*100
gen positividad_pcr = positivo_pcr/prueba_pcr*100
*gen positividad_pr = positivo_pr/prueba_pr*100
gen positividad_ag = positivo_ag/prueba_ag*100

format positividad_pcr positividad_pcr %12.0fc
format positividad_pcr positividad_ag %12.0fc

********************************************************************************
* Tasa de Positividad
********************************************************************************
* Graficamos
twoway (line positividad_pcr semana, lcolor("$mycolor6") lwidth(medthick)) ///
(line positividad_ag semana, lcolor("$mycolor7") lwidth(medthick) lpattern(solid)) ///
(scatter positividad_pcr semana, msymbol(none) mlabel(positividad_pcr) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter positividad_ag semana, msymbol(i) mlabel(positividad_ag) mlabcolor("$mycolor7") mlabsize(*0.9) mlabposition(12)) ///
  if semana>=32 & semana <=$semana ///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  ytitle("Tasa de Positividad (%)", size(*0.6)) ///
  ylabel(0(10)80, labsize(*0.60)) ///
  xlabel(32(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.60)) ///
  plotregion(fcolor(white) lcolor(white)) ///
  graphregion(fcolor(white) lcolor(white)) ///
  bgcolor(white) ///
  ylabel(, nogrid) xlabel(, nogrid) ///
  legend(cols(2) label(1 "Positividad PCR (%)") label(2 "Positividad AG (%)") label(3 " ") label (4 " ") size(*0.6) order(1 2 3 4) region(fcolor(white) lcolor(white))) ///
  /*text(80 $semana "{it:Actualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor4") fcolor("$mycolor4")) */name(tasa_positividad, replace)

graph export "figuras\positividad_diaria_2021_2022.png", as(png) replace  

********************************************************************************
* Tasa de Incidencia
********************************************************************************

* Graficos 
gen total_positivos = positivo_pcr + positivo_ag
gen poblacion_cusco= 1357498
gen tasa_incidencia = total_positivos/poblacion_cusco*1000000
format tasa_incidencia tasa_incidencia %12.0fc
twoway ///
(line tasa_incidencia semana, lcolor("$mycolor6") lwidth() lpattern(solid)) ///
(scatter tasa_incidencia semana, msymbol(none) mlabel(tasa_incidencia) mlabcolor("$mycolor3") mlabsize(*0.6) mlabposition(12)) ///
  if semana>=31 & semana <=$semana ///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  ytitle("Tasa de Incidencia", size(*0.6)) ///
  ylabel(0(200)1600, labsize(*0.60)) ///
  xlabel(31(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.60)) ///
  /*
  xline(21471.9, lcolor("$mycolor7") lpattern(shortdash) lwidth(mthick)) ///
  */ ///
  plotregion(fcolor(white) lcolor(white)) ///
  graphregion(fcolor(white) lcolor(white)) ///
  bgcolor(white) ///
  ylabel(, nogrid) xlabel(, nogrid) ///
    legend(cols(2) label(1 " Tasa de Incidencia (casos positivos/poblacion*1000000)") label(2 "") size(*0.6) order(1 2 3 4) region(fcolor(white) lcolor(white))) ///
    /*text(1000 $semana "{it:Actualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor4") fcolor("$mycolor4"))*/ name(tasa_incidencia, replace)

graph export "figuras\tasa_incidencia_2021_2022.png", as(png) replace

export delimited using "${datos}\output\dashboard_tasa_inci_posi.csv", replace