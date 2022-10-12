*-------------------------------------------------------------------------------%
* Programa: Generar Figuras a Nivel Regional 

* Primera vez creado:     03 de Marzo del 2022
* Ultima actualizaciónb:  03 de Marzo del 2022
*-------------------------------------------------------------------------------%
use "${datos}\output\serie_semanal_region.dta", replace

*Generar Poblacion y Mortalidad
gen poblacion_regional = 1357498
gen mortalidad_regional =  defuncion / poblacion_regional * 1000000
gen incidencia_regional =  positivo / poblacion_regional * 1000000

********************************************************************************
* Incidencia y Mortalidad Regional
********************************************************************************
*2020
twoway (line mortalidad_regional semana, yaxis(2) yscale(axis(2)) ylabel(0(100)500,axis(2)) lcolor("$mycolor2")) ///
(line incidencia_regional semana, lcolor("$mycolor6") ytitle(" ")) ///
if semana >=11 & semana<=53, ///
	tlabel(11(4)53) ///
	ylabel(0(1500)9000) ///
	ytitle("Mortalidad e Incidencia Regional", axis(2)) ///
	xtitle("Semanas Epidemológicas", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(label(1 "Mortalidad") label(2 "Incidencia") size(*0.75) region(col(white))) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///	
	name(mortalidad_incidencia_2020, replace)
	
*2021
twoway (line mortalidad_regional semana_2, yaxis(2) yscale(axis(2)) ylabel(0(100)500,axis(2)) lcolor("$mycolor2")) ///
(line incidencia_regional semana_2, lcolor("$mycolor6") ytitle(" ")) ///
if semana_2 >=1 & semana_2<=$semana, ///
	tlabel(11(4)$semana) ///
	ylabel(0(3000)12000) ///
	ytitle("Mortalidad e Incidencia Regional", axis(2)) ///
	xtitle("Semanas Epidemológicas", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(label(1 "Mortalidad") label(2 "Incidencia") size(*0.75) region(col(white))) ///
	title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///	
	name(mortalidad_incidencia_2021, replace)
	
*2022
twoway (line mortalidad_regional semana_3, yaxis(2) yscale(axis(2)) ylabel(0(100)500,axis(2)) lcolor("$mycolor2")) ///
(line incidencia_regional semana_3, lcolor("$mycolor6") ytitle(" ")) ///
if semana_3 >=1 & semana_3<=53, ///
	tlabel(11(4)53) ///
	ylabel(0(1500)9000) ///
	ytitle("Mortalidad e Incidencia Regional", axis(2)) ///
	xtitle("Semanas Epidemológicas 2020", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(label(1 "Mortalidad") label(2 "Incidencia") size(*0.75) region(col(white))) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///	
	name(mortalidad_incidencia_2022, replace)
*/