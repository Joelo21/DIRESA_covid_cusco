*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
*Program: 		Data Visualization (Positividad Diaria)
*first created: 02/06/2021
*last updated:  04/05/2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	

* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).
use "${datos}\output\data_series_region.dta", clear

recode positivo(.= 0)
recode positivo_pcr(.= 0)
recode positivo_ag(.= 0)
recode positivo_pr(.= 0)
recode prueba(.= 0)
recode prueba_ag(.= 0)
recode prueba_pcr(.= 0)
recode prueba_pr(.= 0)
recode sintomatico(.= 0)
recode sintomatico_pcr(.= 0)
recode sintomatico_ag(.= 0)
recode sintomatico_pr_sis(.= 0)
recode sintomatico_pr_sis(.= 0)
recode defuncion(.= 0)

* Para dias a inicios de semana
drop if fecha < d(01jan2022)

gen numero = _n
*replace semana = 11 if fecha == 21987 | fecha == 21988
*replace semana = 12 if fecha > 21988 & fecha <= 21995

gen semana =.
replace semana = 1 if numero >= 1 & numero <= 7
replace semana = semana[_n-7] + 1 if numero > 7

collapse (mean) positivo_pcr positivo_ag  prueba_pcr prueba_ag, by(semana)
save "${datos}\output\data_positividad", replace
*****************************************************************
use "${datos}\output\data_series_region.dta", clear 

* Para dias a inicios de semana
drop if fecha < d(01jan2022)

*rename fecha_resultado fecha 

gen numero = _n
*replace semana = 11 if fecha == 21987 | fecha == 21988
*replace semana = 12 if fecha > 21988 & fecha <= 21995

gen semana =.
replace semana = 1 if numero >= 1 & numero <= 7
replace semana = semana[_n-7] + 1 if numero > 7


collapse (sum) positivo prueba, by (semana)
save "${datos}\output\data_casos_positivos", replace

********
use "${datos}\output\data_casos_positivos", clear
merge 1:1 semana using "${datos}\output\data_positividad", nogenerate


label var semana "Semana Epidemiológica"

drop if semana > 25
label define semana 53 "1" 54 "2" 55 "3" 56 "4" 57 "5" 58 "6" 59 "7" 60 "8" 61 "9" 62 "10" 63 "11" 64 "12" 65 "13" 66"14" 67 "15" 68 "16" 69 "17" 70 "18" 71 "19" 72 "20" 73 "21" 74 "22", replace
label values semana semana

* Generamos las variables pertinentes.
*gen positividad = positivo/prueba*100
gen positividad_pcr = positivo_pcr/prueba_pcr*100
*gen positividad_pr = positivo_pr/prueba_pr*100
gen positividad_ag = positivo_ag/prueba_ag*100

format positividad_pcr positividad_pcr %12.0fc
format positividad_pcr positividad_ag %12.0fc

***********Positividad de Casos********
gen positividad_casos = positivo/prueba*100
format positividad_casos positividad_casos %12.0fc

*Grafico Casos y Positividad
twoway (line positividad_casos semana, yaxis(2) yscale(axis(2)) ylabel(0(20)100, axis(2)) lcolor("$mycolor6") lwidth(medthick)) ///
(line positivo semana, lcolor("$mycolor7") lwidth(medthick) lpattern(solid)) ///
(scatter positividad_casos semana, msymbol(none) mlabel(positividad_casos) mlabcolor("$mycolor6") mlabsize(*0.6) mlabposition(12) yaxis(2)) ///
(scatter positivo semana, msymbol(i) mlabel(positivo) mlabcolor("$mycolor7") mlabsize(*0.6) mlabposition(12)) ///
  if semana>=1 & semana <=52 ///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  ytitle("Casos Positivos ", size(*0.6)) ///
  ytitle("Tasa de Positividad (%)", size(*0.6) axis(2)) ///
  ylabel(0(20)100, labsize(*0.60)) ///
  xlabel(1(3)52, labsize(*0.60)) ///
  plotregion(fcolor(white) lcolor(white)) ///
  graphregion(fcolor(white) lcolor(white)) ///
  bgcolor(white) ///
  ylabel(, nogrid) xlabel(, nogrid) ///
  legend(cols(3) label(1 "Positividad Casos Covid (%)") label(2 "Casos") label(3 " ") label (4 " ") size(*0.6) order(1 2 3 4) region(fcolor(white) lcolor(white))) ///
  /*text(80 $semana "{it:Actualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor4") fcolor("$mycolor4")) */name(Casos_Positividad, replace)
