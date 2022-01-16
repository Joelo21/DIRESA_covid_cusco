*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
*Program: 		Data Visualization (Positividad Diaria)
*first created: 02/06/2021
*last updated:  04/05/2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	

* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).
	
use "${datos}\output\data_series_region_2022.dta", clear

*use "D:\covid_cusco\datos\output\data_series_region.dta", clear

* Para dias a inicios de semana
drop if fecha < d(01jan2021)


gen numero = _n
gen semana =.
replace semana = 1 if numero >= 1 & numero <= 7
replace semana = semana[_n-7] + 1 if numero > 7

collapse (mean) positivo_pcr positivo_ag  prueba_pcr prueba_ag, by(semana)
label var semana "Semana Epidemiológica"

drop if semana > $semana

* Generamos las variables pertinentes.

gen positividad_pcr = positivo_pcr/prueba_pcr*100
gen positividad_ag = positivo_ag/prueba_ag*100

format positividad_pcr positividad_pcr %12.0fc
format positividad_pcr positividad_ag %12.0fc

save "${datos}\output\data_positividad_diario_2022.dta", replace

* Graficamos
twoway (line positividad_pcr semana, lcolor("$mycolor6") lwidth(medthick)) ///
(line positividad_ag semana, lcolor("$mycolor7") lwidth(medthick) lpattern(solid) xline(20426.5, lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick))) ///
(scatter positividad_pcr semana, msymbol(none) mlabel(positividad_pcr) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter positividad_ag semana, msymbol(i) mlabel(positividad_ag) mlabcolor("$mycolor7") mlabsize(*0.9) mlabposition(12)) ///
  ,  ysize(5) xsize(6.1) ///
  xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  ytitle("Tasa de Positividad (%)", size(*0.6)) ///
  ylabel(0(10)80, labsize(*0.60)) ///
  xlabel(1(2)$semana, labsize(*0.60)) ///
  plotregion(fcolor(white) lcolor(white)) ///
  graphregion(fcolor(white) lcolor(white)) ///
  bgcolor(white) ///
  ylabel(, nogrid) xlabel(, nogrid) ///
  legend(cols(2) label(1 "Positividad PCR (%)") label(2 "Positividad AG (%)") label(3 " ") label (4 " ") size(*0.6) order(1 2 3 4) region(fcolor(white) lcolor(white))) ///
  text(70 $semana "{it:Actualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor4") fcolor("$mycolor4")) name(tasa_posi, replace)
  
graph export "figuras\positividad_diaria_2022.png", as(png) replace  

********************************************************************************
* Tasa de Incidencia
********************************************************************************

* Graficos 
gen total_positivos = positivo_pcr + positivo_ag
gen poblacion_cusco= 1357498
gen tasa_incidencia = total_positivos/poblacion_cusco*1000000
format tasa_incidencia tasa_incidencia %12.0fc

twoway (line tasa_incidencia semana, lcolor("$mycolor6") lwidth()) ///
(line tasa_incidencia semana, lcolor("$mycolor6") lwidth() lpattern(solid) xline(20426.5, lcolor("$mycolor2") lpattern(shortdash) lwidth(mthick))) ///
(scatter tasa_incidencia semana, msymbol(none) mlabel(tasa_incidencia) mlabcolor("$mycolor3") mlabsize(*0.6) mlabposition(12)) ///
  , ysize(5) xsize(6.1) ///
  xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  ytitle("Tasa de Incidencia", size(*0.6)) ///
  ylabel(0(50)400, labsize(*0.60)) ///
  xlabel(1(2)$semana, labsize(*0.60)) ///
  plotregion(fcolor(white) lcolor(white)) ///
  graphregion(fcolor(white) lcolor(white)) ///
  bgcolor(white) ///
  ylabel(, nogrid) xlabel(, nogrid) ///
    legend(cols(2) label(1 "  Tasa de Incidencia (casos positivos/poblacion*1000000)") label(2 " ") label(3 " ") label (4 " ") size(*0.6) order(1 2 3 4) region(fcolor(white) lcolor(white))) ///
	name(tasa_incidencia, replace)
graph export "figuras\tasa_incidencia_2022.png", as(png) replace
*graph export "figuras\tasa_incidencia_2022.pdf", as(pdf) replace   