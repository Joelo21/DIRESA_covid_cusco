********************************************************************************
*TASA DE LETALIDAD AÑOS 2020 / 2021 / 2022
********************************************************************************
/*
*2020
use "${datos}\output\base_covid.dta", clear

*Generar categorias de las etapas de vida menores a 30 años
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <= 5
replace grupo_edad = 2 if edad >= 6 & edad <= 10
replace grupo_edad = 3 if edad >= 11 & edad <= 15
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "0-5 años" 2 "6-10 años" 3 "11 a 15 años"
label values grupo_edad grupo_edad

drop if fecha_resultado >= d(01jan2021)
keep if grupo_edad !=.
sort fecha_resultado grupo_edad

*Fecha Resultado
preserve
collapse (count) positivo defuncion, by (grupo_edad)
sort grupo_edad

gen letalidad = defuncion / positivo * 100
format letalidad %9.2g
save "${datos}\output\letalidad_2020.dta", replace
********************************************************************************
*2021
use "${datos}\output\base_covid.dta", clear
*Generar categorias de las etapas de vida menores a 30 años
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <= 5
replace grupo_edad = 2 if edad >= 6 & edad <= 10
replace grupo_edad = 3 if edad >= 11 & edad <= 15
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "0-5 años" 2 "6-10 años" 3 "11 a 15 años"
label values grupo_edad grupo_edad

drop if fecha_resultado < d(01jan2021) | fecha_resultado > d(01jan2022)
keep if grupo_edad !=.
sort fecha_resultado grupo_edad

*Fecha Resultado
collapse (count) positivo defuncion, by (grupo_edad)
sort grupo_edad

gen letalidad = defuncion / positivo * 100
format letalidad %9.2g
save "${datos}\output\letalidad_2021.dta", replace
********************************************************************************
*2022
use "${datos}\output\base_covid_2022.dta", clear
*Generar categorias de las etapas de vida menores a 30 años
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <= 5
replace grupo_edad = 2 if edad >= 6 & edad <= 10
replace grupo_edad = 3 if edad >= 11 & edad <= 15
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "0-5 años" 2 "6-10 años" 3 "11 a 15 años"
label values grupo_edad grupo_edad

drop if fecha_resultado < d(01jan2022)
keep if grupo_edad !=.
sort grupo_edad

*Fecha Resultado
collapse (count) positivo defuncion, by (grupo_edad)
sort grupo_edad
gen letalidad= defuncion / positivo * 100
format letalidad %9.2g
save "${datos}\output\letalidad_2022.dta", replace
*/
********************************************************************************
*Grafico Letalidad
use "${datos}\output\base_covid.dta", clear

gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <= 5
replace grupo_edad = 2 if edad >= 6 & edad <= 10
replace grupo_edad = 3 if edad >= 11 & edad <= 15
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "0-5 años" 2 "6-10 años" 3 "11 a 15 años"
label values grupo_edad grupo_edad

*Limpiando Datos
*drop if fecha_resultado < d(05jun2021)
keep if grupo_edad !=.
sort fecha_resultado grupo_edad


forvalues i=1/3{
		preserve
		keep if grupo_edad == `i'
		collapse (sum) positivo defuncion, by(fecha_resultado)
		
		tsset fecha_resultado, daily
		tsfill
		
		rename positivo positivo_`i'
		rename defuncion defuncion_`i'
		
		save "${datos}\temporal\grupo_edad_letalidad_`i'", replace
		restore
}

*Unir datos
use "${datos}\temporal\grupo_edad_letalidad_1", clear
forvalues j=2/3{
	merge 1:1 fecha_resultado using "${datos}\temporal\grupo_edad_letalidad_`j'",nogen
}
drop if fecha_resultado > d($fecha)

*Generando Semanas Epidemiologicas 
gen semana =.
replace semana = 10 if fecha_resultado >= d(02mar2020) & fecha_resultado <= d(08 mar2020) 
replace semana = 11 if fecha_resultado > d(08mar2020) & fecha_resultado <= d(15mar2020)
replace semana = semana[_n-7] + 1 if fecha_resultado > d(15mar2020)
collapse (sum) positivo_* defuncion_*, by(semana)

*Definir Semana
tsset semana

*Generando Semana 2021
gen semana_2 =.
replace semana_2 = semana -53
replace semana_2 = . if semana_2 < 0

*Generando Semana 2022
gen semana_3 = .
replace semana_3 = semana_2 - 52
replace semana_3 = . if semana_3 < 0
order semana semana_2 semana_3

*Generar Letalidad
forvalues i=1/3{
gen letalidad_`i' = defuncion_`i'/positivo_`i'*100
format letalidad_`i' %9.2g	
}


*Grafico para Grupo de Edad
forvalues i= 1/3 {

*2020
twoway (bar positivo_`i' semana, yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5 0.8) bcolor("$mycolor1")) ///
(line defuncion_`i' semana, lcolor(black) lpattern(dash) sort yaxis(2) yscale(range(100) axis(2) off)) ///
(scatter defuncion_`i' semana, msymbol(none) mlabel(defuncion_`i') mlabcolor(black) mlabsize(*0.75) mlabposition(.3)) ///
(scatter positivo_`i' semana, msymbol(none) mlabel(positivo_`i') mlabcolor("$mycolor3") mlabsize(*0.75) mlabposition(.3)) ///
if semana>=10 & semana <=53 					///
	,xtitle("Semanas Epidemiologicas", size(*0.7))	///
	xlabel(10(1)53, labsize(*0.40))				///
	graphregion(color(white))						///
	legend(off)										///
	bgcolor(white) ylabel(, nogrid) name(graph_2020_`i', replace)

	gr export "figuras\niños_2020_`i'.pdf", as(pdf) replace	


*2021
twoway (bar positivo_`i' semana_2, yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5 0.8) bcolor("$mycolor1")) ///
(line defuncion_`i' semana_2, lcolor(black) lpattern(dash) sort yaxis(2) yscale(range(100) axis(2) off)) ///
(scatter defuncion_`i' semana_2, msymbol(none) mlabel(defuncion_`i') mlabcolor(black) mlabsize(*0.75) mlabposition(.3)) ///
(scatter positivo_`i' semana_2, msymbol(none) mlabel(positivo_`i') mlabcolor("$mycolor3") mlabsize(*0.75) mlabposition(.3)) ///
if semana_2>=1 & semana_2 <=52 					///
	,xtitle("Semanas Epidemiologicas", size(*0.7))	///
	xlabel(1(1)52, labsize(*0.40))				///
	graphregion(color(white))						///
	legend(off)										///
	bgcolor(white) ylabel(, nogrid) name(graph_2021_`i', replace)

	gr export "figuras\niños_2021_`i'.pdf", as(pdf) replace	


*2022
twoway (bar positivo_`i' semana_3, yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5 0.8) bcolor("$mycolor1")) ///
(line defuncion_`i' semana_3, lcolor(black) lpattern(dash) sort yaxis(2) yscale(range(100) axis(2) off)) ///
(scatter defuncion_`i' semana_3, msymbol(none) mlabel(defuncion_`i') mlabcolor(black) mlabsize(*0.75) mlabposition(.3)) ///
(scatter positivo_`i' semana_3, msymbol(none) mlabel(positivo_`i') mlabcolor("$mycolor3") mlabsize(*0.75) mlabposition(.3)) ///
if semana_3>=1 & semana_3 <=53 					///
	,xtitle("Semanas Epidemiologicas", size(*0.7))	///
	xlabel(1(1)15, labsize(*0.40))				///
	graphregion(color(white))						///
	legend(off)										///
	bgcolor(white) ylabel(, nogrid) name(graph_2022_`i', replace)

	gr export "figuras\niños_2022_`i'.pdf", as(pdf) replace	
}
save "${datos}\output\base_covid_letalidad.dta", replace

