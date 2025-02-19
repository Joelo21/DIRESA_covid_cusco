*-------------------------------------------------------------------------------%

* Programa: Figura de las Etapas de Vida

* Primera vez creado:     02 de junio del 2021
* Ultima actualizaciónb:  02 de junio del 2021

*-------------------------------------------------------------------------------%

* Importar la base de datos
use "${datos}\output\base_covid.dta", clear

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <=9
replace grupo_edad = 2 if edad >= 10 & edad <= 19
replace grupo_edad = 3 if edad >= 20 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 39
replace grupo_edad = 5 if edad >= 40 & edad <= 49
replace grupo_edad = 6 if edad >= 50 & edad <= 59
replace grupo_edad = 7 if edad >= 60 & edad <= 69
replace grupo_edad = 8 if edad >= 70 & edad <= 79
replace grupo_edad = 9 if edad >= 80 
label variable grupo_edad "Decenios"
label define grupo_edad 1 "0-9 años" 2 "10-19 años" 3 "20-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "más de 80 años"
label values grupo_edad grupo_edad

* Generar los casos y defunciones por grupo de edad para cada día
forvalues i=1/9 {

preserve
keep if grupo_edad == `i'

collapse (sum) positivo defuncion, by(fecha_resultado)

tsset fecha_resultado, daily
tsfill

rename positivo positivo_`i'
rename defuncion defuncion_`i'

save "${datos}\temporal\grupo_edad_`i'", replace
restore 
}

* Unir dichos grupos de edad en una sola base
use "${datos}\temporal\grupo_edad_1", clear

forvalues j=2/9 {
merge 1:1 fecha_resultado using "${datos}\temporal\grupo_edad_`j'", nogen
}

* Eliminar datos antes del primer caso reportado de COVID-19 en Cusco
drop if fecha_resultado < d(13mar2020)
drop if fecha_resultado == .

* Eliminar posibles casos con fecha mayor a la actual
drop if fecha_resultado > d($fecha)

recode * (.=0)

* Generar datos semanales
gen semana = .
replace semana = 11 if fecha == 21987 | fecha == 21988
replace semana = 12 if fecha > 21988 & fecha <= 21995
replace semana = semana[_n-7] + 1 if fecha > 21995
collapse (sum) positivo_* defuncion_*, by(semana)

* Definir "semana" como variable de series de tiempo
tsset semana

* Generar "semana_2" como semana epidemiológica del año 2021
gen numero = _n

gen semana_2 = .
replace semana_2 = semana - 53
replace semana_2 = . if semana_2 < 0

* Generar semana epidemiológica del año 2022

gen numero2 = _n
gen semana_3 = .
replace semana_3 = semana_2 - 52
replace semana_3 = . if semana_3 < 0

* Guardar la base de datos
save "${datos}\output\serie_semanal_cas_def_gedad", replace

******************************************************************************** Análisis sólo para el 2021 - 2022
keep if semana_2 >= 1
drop if semana_2 == .

/*
* Generar las sumas acumuladas
forvalues i=1/9{
gen total_positivo_`i' = sum(positivo_`i')
gen total_defuncion_`i' = sum(defuncion_`i')
}
*/

********************************************************************************
/*
*Casos Positivos Niños
*2021 - 0 a 9 años
twoway (line positivo_1 semana_2, lcolor("$mycolor1") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(line defuncion_1 semana_2, lcolor("$mycolor3") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(scatter positivo_1 semana_2, msymbol(none) mlabel(positivo_1) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter defuncion_1 semana_2, msymbol(none) mlabel(defuncion_1) mlabcolor("$mycolor3") mlabsize(*0.9) mlabposition(12)) ///
if semana_2 >=1 & semana_2 <=52, ///
	ylabel(0(10)50, labsize(*0.6)) ///
	tlabel(1(3)52) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Casos Semanales") ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	name(positivo_1, replace) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white))
	
	gr export "figuras\pos_def_0_9años_2021.png", as (png) replace

*2022 - 0 a 9 años
twoway (line positivo_1 semana_3, lcolor("$mycolor1") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(line defuncion_1 semana_3, lcolor("$mycolor3") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(scatter positivo_1 semana_3, msymbol(none) mlabel(positivo_1) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter defuncion_1 semana_3, msymbol(none) mlabel(defuncion_1) mlabcolor("$mycolor3") mlabsize(*0.9) mlabposition(12)) ///
if semana_3 >=1, ///
	ylabel(0(25)350, labsize(*0.6)) ///
	tlabel(1(3)52) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Casos Semanales") ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	name(positivo_1_2, replace) ///
	title("2022", box bexpand bcolor("$mycolor3") color(white))

	gr export "figuras\pos_def_0_9años_2022.png", as (png) replace

*2021 - 10 a 19 años
twoway (line positivo_2 semana_2, lcolor("$mycolor1") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(line defuncion_2 semana_2, lcolor("$mycolor3") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(scatter positivo_2 semana_2, msymbol(none) mlabel(positivo_2) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter defuncion_2 semana_2, msymbol(none) mlabel(defuncion_2) mlabcolor("$mycolor3") mlabsize(*0.9) mlabposition(12)) ///
if semana_2 >=1 & semana_2 <=52, ///
	ylabel(0(150)1350, labsize(*0.6)) ///
	tlabel(1(3)$semana) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Casos Semanales") ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	name(positivo_2_1, replace) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white))

	gr export "figuras\pos_def_10_19años_2021.png", replace

*2022 - 10 a 19 años
twoway (line positivo_2 semana_3, lcolor("$mycolor1") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(line defuncion_2 semana_3, lcolor("$mycolor3") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(scatter positivo_2 semana_3, msymbol(none) mlabel(positivo_2) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter defuncion_2 semana_3, msymbol(none) mlabel(defuncion_2) mlabcolor("$mycolor3") mlabsize(*0.9) mlabposition(12)) ///
if semana_3 >=1, ///
	ylabel(0(150)1200, labsize(*0.6)) ///
	tlabel(1(3)52) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Casos Semanales") ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	name(positivo_2_2, replace) ///
	title("2022", box bexpand bcolor("$mycolor3") color(white))

	gr export "figuras\pos_def_10_19años_2022.png", as (png) replace

*Defunciones Niños
*0 a 9 años
twoway (line defuncion_1 semana_2, lcolor("$mycolor3") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(scatter defuncion_1 semana_2, msymbol(none) mlabel(defuncion_1) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
if semana_2 >=1 & semana_2 <=52, ///
	ylabel(0(1)5, labsize(*0.6)) ///
	tlabel(1(3)$semana) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Casos Semanales") ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	name(defuncion_1, replace) ///
	title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white))

*10 a 19 años
twoway (line defuncion_2 semana_2, lcolor("$mycolor3") lwidth(medthick) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(vthin))) ///
(scatter defuncion_2 semana_2, msymbol(none) mlabel(defuncion_2) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
if semana_2 >=1, ///
	ylabel(0(1)5, labsize(*0.6)) ///
	tlabel(1(3)$semana) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Casos Semanales") ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	bgcolor(white) ///
	legend(off) ///
	name(defuncion_2, replace) ///
	title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white))
*/
********************************************************************************
* Mortalidad
gen mortalidad_1 = defuncion_1/239193*10000
gen mortalidad_2 = defuncion_2/248402*10000
gen mortalidad_3 = defuncion_3/232266*10000
gen mortalidad_4 = defuncion_4/220318*10000
gen mortalidad_5 = defuncion_5/157503*10000
gen mortalidad_6 = defuncion_6/118566*10000
gen mortalidad_7 = defuncion_7/81263*10000
gen mortalidad_8 = defuncion_8/42520*10000
gen mortalidad_9 = defuncion_9/19982*10000

* Incidencia
gen incidencia_1 = positivo_1/239193*10000
gen incidencia_2 = positivo_2/248402*10000
gen incidencia_3 = positivo_3/232266*10000
gen incidencia_4 = positivo_4/220318*10000
gen incidencia_5 = positivo_5/157503*10000
gen incidencia_6 = positivo_6/118566*10000
gen incidencia_7 = positivo_7/81263*10000
gen incidencia_8 = positivo_8/42520*10000
gen incidencia_9 = positivo_9/19982*10000

********************************************************************************
* Mortalidad 2022
twoway (line mortalidad_1 semana_2, lcolor("$mycolor1") lwidth(medthick)) ///
(line mortalidad_2 semana_2, lcolor("$mycolor2") lwidth(medthick)) ///
(line mortalidad_3 semana_2, lcolor("$mycolor3") lwidth(medthick)) ///
(line mortalidad_4 semana_2, lcolor("$mycolor4") lwidth(medthick)) ///
(line mortalidad_5 semana_2, lcolor("$mycolor1") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_6 semana_2, lcolor("$mycolor2") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_7 semana_2, lcolor("$mycolor3") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_8 semana_2, lcolor("$mycolor4") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_9 semana_2, lcolor("$mycolor5") lwidth(medthick) lpattern(dash_dot)) ///
if semana_2 >=1, ///
	ylabel(0(3)24, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.5)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(2 "10 a 19 años") label(3 "20 a 29 años")  label(4 "30 a 39 años")  label(5 "40 a 49 años") label(6 "50 a 59 años")  label(7 "60 a 69 años")  label(8 "70 a 79 años") label(9 "Más de 80 años") size(*0.65) ring(0) position(0.75) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_2022, replace)

* Guardar
gr export "figuras\mortalidad_edad_2021_2022.png", as(png) replace
gr export "figuras\mortalidad_edad_2021_2022.pdf", as(pdf) replace

**************************************2021**************************************
* Más de 80  
twoway (line mortalidad_9 semana_2, lcolor("$mycolor5") lwidth(medthick) lpattern(dash_dot) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(1)24, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población con más de 80 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_80, replace)
	
gr export "figuras\mortalidad_edad_80.png", as(png) replace
gr export "figuras\mortalidad_edad_80.pdf", as(pdf) replace


* Grupo de edad: 70 a 79 años
twoway (line mortalidad_8 semana_2, lcolor("$mycolor11") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(1)12, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 70 y 79 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_70, replace)
	
gr export "figuras\mortalidad_edad_70.png", as(png) replace
gr export "figuras\mortalidad_edad_70.pdf", as(pdf) replace


* Grupo de edad: 60 a 69 años: 31 mayo (SE22) y 21 de junio (SE25)
twoway (line mortalidad_7 semana_2, lcolor("$mycolor12") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(1)6, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 60 y 69 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_60, replace)

gr export "figuras\mortalidad_edad_60.png", as(png) replace
gr export "figuras\mortalidad_edad_60.pdf", as(pdf) replace


* Grupo de edad: 50 a 59 años: 8 de julio (SE27) y 29 de julio (SE30)
twoway (line mortalidad_6 semana_2, lcolor("$mycolor2") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(1)4, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 50 y 59 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_50, replace)

gr export "figuras\mortalidad_edad_50.png", as(png) replace
gr export "figuras\mortalidad_edad_50.pdf", as(pdf) replace


* Grupo de edad: 40 a 49 años
twoway (line mortalidad_5 semana_2, lcolor("$mycolor16") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(1)2, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 40 y 49 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_40, replace)

gr export "figuras\mortalidad_edad_40.png", as(png) replace
gr export "figuras\mortalidad_edad_40.pdf", as(pdf) replace


* Grupo de edad: 30 a 39 años
twoway (line mortalidad_4 semana_2, lcolor("$mycolor7") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(1)1, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 30 y 39 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_30, replace)

gr export "figuras\mortalidad_edad_30.png", as(png) replace
gr export "figuras\mortalidad_edad_30.pdf", as(pdf) replace


* Grupo de edad: 20 a 29 años
twoway (line mortalidad_3 semana_2, lcolor("$mycolor14") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(.1).5, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 20 y 29 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_20, replace)

gr export "figuras\mortalidad_edad_20.png", as(png) replace
gr export "figuras\mortalidad_edad_20.pdf", as(pdf) replace


* Grupo de edad: 10 a 19 años
twoway (line mortalidad_2 semana_2, lcolor("$mycolor15") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(.1).5, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 10 y 19 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_10, replace)

gr export "figuras\mortalidad_edad_10.png", as(png) replace
gr export "figuras\mortalidad_edad_10.pdf", as(pdf) replace


* Grupo de edad: 0 a 9 años
twoway (line mortalidad_1 semana_2, lcolor("$mycolor2") lwidth(medthick) lpattern(dash) xline(17, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick)) xline(80, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=1, ///
	ylabel(0(.1).5, labsize(*0.6)) ///
	tlabel(1(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("Mortalidad en población entre 0 y 9 años, 2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "0 a 9 años") label(1 "0 a 9 años") size(*0.65) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(gedad_0, replace)

gr export "figuras\mortalidad_edad_0.png", as(png) replace
gr export "figuras\mortalidad_edad_0.pdf", as(pdf) replace

save "${datos}\output\dashboard_mort_inci.dta", replace

export delimited using "${datos}\output\dashboard_mortalidad_region.csv", replace