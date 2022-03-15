*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
* Programa:		  Programa para los casos de hospitalizados 2021 - 2022 por semana
* Creado el:	  02 de febrero del 2022
* Actualizado en: 10 de febrero del 2022
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
import excel "${datos}\raw\base_hospitalizados.xlsx", sheet(Hoja1) firstrow clear

gen hospitalizados = 1
rename EDAD edad
gen fecha_ingreso = date(FECHADEINGRESO, "DMY")
format fecha_ingreso %td

gen grupo_edad_hospitalizados = .
replace grupo_edad_hospitalizados = 1 if edad >=  0 & edad <= 9
replace grupo_edad_hospitalizados = 2 if edad >= 10 & edad <= 19
replace grupo_edad_hospitalizados = 3 if edad >= 20 & edad <= 29
replace grupo_edad_hospitalizados = 4 if edad >= 30 & edad <= 39
replace grupo_edad_hospitalizados = 5 if edad >= 40 & edad <= 49
replace grupo_edad_hospitalizados = 6 if edad >= 50 & edad <= 59
replace grupo_edad_hospitalizados = 7 if edad >= 60 & edad <= 69
replace grupo_edad_hospitalizados = 8 if edad >= 70 & edad <= 79
replace grupo_edad_hospitalizados = 9 if edad >= 80
label define grupo_edad 1 "0-9 años" 2 "10-19 años" 3 "20-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "más de 80 años"
label values grupo_edad_hospitalizados grupo_edad_hospitalizados

*Cambiar el grupo_edad para añadir mas edades
forvalues i=1/9{
	preserve
	keep if grupo_edad_hospitalizados == `i'
	collapse (sum) hospitalizados, by(fecha_ingreso)

	tsset fecha_ingreso, daily
	tsfill
	
	rename hospitalizados hospitalizados_`i'
	
	save "${datos}\temporal\grupo_edad_hospitalizados_`i'", replace
	restore
}

*Unir dichos grupos de edades
use "${datos}\temporal\grupo_edad_hospitalizados_1", clear
forvalues j=2/9{
merge 1:1 fecha_ingreso using "${datos}\temporal\grupo_edad_hospitalizados_`j'",nogen
}

drop if fecha_ingreso > d($fecha)

****************************** GENERANDO SEMANAS *******************************
*Generando datos semanales 2020
gen semana =.
replace semana = 34 if fecha == d(21aug2020) | fecha == d(22aug2020) | fecha == d(23aug2020)
replace semana = 35 if fecha > d(23aug2020) & fecha <= d(30aug2020)
replace semana = semana[_n-7] + 1 if fecha > d(30aug2020)
collapse (sum) hospitalizados_*, by(semana)

*Definimos semana como variable de sertie del tiempo
tsset semana

*Generamos Semanas Epidemiologica 2021
gen semana_2 = .
replace semana_2 = semana - 53
replace semana_2 = . if semana_2 < 0

*Generamos Semanas Epidemiologica 2022
gen numero =_n
gen semana_3 =.
replace semana_3 = semana_2 - 52
replace semana_3 = . if semana_3 < 0

save "${datos}\output\base_hospitalizados.dta", replace
********************************************************************************
*Graficamos Hospitalizacion 0 < 9 & 10 < 19
forvalues i=1/9 {
twoway (line hospitalizados_`i' semana_2, lcolor(red) lwidth(medthick)) ///
(scatter hospitalizados_`i' semana_2, msymbol(none) mlabel(hospitalizados_`i') lcolor(white) lstyle(white) mlabcolor(black) mlabsize(*0.9) mlabposition(12)) ///
if semana_2 >=1 & semana_2 <=52, ///
	ylabel(0(1)5, labsize(*0.6)) ///
	tlabel(1(5)52) ///
	xtitle("Semana Epidemológicas", size(*0.8)) ///
	ytitle("Cantidad de Pacientes Hospitalizados", size(*0.7)) ///
	graphregion(fcolor(white)) ///
	legend(off) ///
	title("2021", box bexpand bcolor(red) color(white)) ///
	name(hosp_2021_`i', replace) 

twoway (line hospitalizados_`i' semana_3, lcolor(red) lwidth(medthick)) ///
(scatter hospitalizados_`i' semana_3, msymbol(none) mlabel(hospitalizados_`i') mlabcolor(black) mlabsize(*0.9) mlabposition(12)) ///
if semana_3 >=1 & semana_3 <=52, ///
	ylabel(0(1)15, labsize(*0.6)) ///
	tlabel(1(5)52) ///
	xtitle("Semana Epidemológicas", size(*0.8)) ///
	ytitle("Cantidad de Pacientes Hospitalizados", size(*0.7)) ///
	graphregion(fcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	title("2022", box bexpand bcolor(red) color(white)) ///
	name(hosp_2022_`i', replace)

	*Combinando Graficos
	graph combine hosp_2021_`i' hosp_2022_`i', ///
	graphregion (color(white)) ///
	name(hospilizados_21_22_`i', replace)
	
	gr export "figuras\hospilizados_21_22_`i'.png", as(png) replace
	
}