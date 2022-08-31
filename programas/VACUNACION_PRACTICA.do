import delimited "${datos}\raw\vacunacovid.csv", varnames(1) encoding(UTF-8)  clear

* DNI
rename numero dni

* Fecha de nacimiento
gen fecha_2 = fnac
split fecha_2, parse(-) destring
rename (fecha_2?) (año2 mes2 dia2)
gen fecha_nacimiento = daily(fecha_2, "YMD")
format fecha_nacimiento %td

* Edad
gen yr =year(fecha_nacimiento)
gen int yrint = round(yr)
destring yrint, replace force
gen EdadGE = 2022 - yrint

* Fecha de vacunación
gen fecha_1 = fvac
split fecha_1, parse(-) destring
rename (fecha_1?) (año1 mes1 dia1)
gen fecha_vacuna = daily(fecha_1, "YMD")
format fecha_vacuna %td

* Ordenar por fecha de vacunación y DNI para indicar primera y segunda dosis
sort dni fecha_vacuna
duplicates report dni 
duplicates tag dni, gen(dupli)
quietly by dni: gen num_dupli = cond(_N==1,0,_n)

* Número de dosis del paciente
gen dosis = .
replace dosis = 1 if num_dupli == 0	| num_dupli == 1
replace dosis = 2 if num_dupli == 2
replace dosis = 3 if num_dupli == 3
replace dosis = 4 if num_dupli > 3


* Mantener una copia de los que tienen una dosis, dos dosis, y tres dosis
*keep if dosis == 1 | dosis == 2 | dosis == 3 | dosis == 4

* Mantener las variables de interés
rename fecha_vacuna fecha_ultima_vacuna

destring EdadGE, replace force
destring edad, replace force

save "${datos}\output\base_vacunados_practica", replace
********************************************************************************
use "${datos}\output\base_vacunados_practica", clear

drop if edad < 5
drop if missing(edad)
drop if edad > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 5 & edad <= 11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 39
replace grupo_edad = 5 if edad >= 40 & edad <= 49
replace grupo_edad = 6 if edad >= 50 & edad <= 59
replace grupo_edad = 7 if edad >= 60 & edad <= 69
replace grupo_edad = 8 if edad >= 70 & edad <= 79
replace grupo_edad = 9 if edad >= 80 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "05-11 años" 2 "12-17 años" 3 "18-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80 a más años"	
label values grupo_edad grupo_edad
tab grupo_edad

preserve 
gen numero = _n
collapse (count) numero if dosis == 1, by(grupo_edad)
rename numero uno
save "${datos}\temporal\vacunados_primera_practicas", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 2, by(grupo_edad)
rename numero dos
save "${datos}\temporal\vacunados_segunda_practicas", replace
restore

preserve 
gen numero = _n
collapse (count) numero if dosis == 3, by(grupo_edad)
rename numero tres
save "${datos}\temporal\vacunados_tercera_practicas", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 4, by(grupo_edad)
rename numero tres
save "${datos}\temporal\vacunados_cuarta_practicas", replace
restore 

use "${datos}\temporal\vacunados_primera_practicas", clear
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_segunda_practicas", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_tercera_practicas", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_cuarta_practicas", nogen

gen objetivo = .
replace objetivo = 177961 if grupo_edad == 1
replace objetivo = 154802 if grupo_edad == 2
replace objetivo = 318123 if grupo_edad == 3
replace objetivo = 228775 if grupo_edad == 4
replace objetivo = 187360 if grupo_edad == 5
replace objetivo = 143692 if grupo_edad == 6
replace objetivo = 96507 if grupo_edad == 7
replace objetivo = 54159 if grupo_edad == 8
replace objetivo = 31271 if grupo_edad == 9

gen una_dosis = uno/objetivo*100
gen dos_dosis = dos/objetivo*100
gen tres_dosis = tres/objetivo*100

format una_dosis dos_dosis tres_dosis %4.1f

*Grafico
graph bar una_dosis dos_dosis tres_dosis, xsize(8.1) ///
over(grupo_edad) plotregion(fcolor(white)) graphregion(fcolor(white) ) ///
title("Cobertura Vacunación en la Región Cusco por Grupo Etario", box bexpand bcolor("$mycolor3") color(white)) ///
bgcolor("$mycolor3") ///
yline(83, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) ///
yline(74, lcolor("$mycolor16") lpattern(shortdash) lwidth(thick)) ///
blabel(bar, size(small) position(inside) color("$mycolor9") format(%4.1f)) ///
bar(1, color("$mycolor6")) ///
bar(2, color("$mycolor3")) ///
bar(3, color("$mycolor7")) ///
ytitle("Porcentaje (%)", size(4.2)) ///
b1title("Grupo de Edad", size(4.2)) ///
ylabel(, nogrid) ///
legend(cols(3) label(1 "1ra Dosis") label(2 "2da Dosis") label(3 "3ra Dosis") size(*0.8) region(col(white))) name(Dosis, replace) 

graph export "figuras\vacunacion_grupo_edad_dosis.png", as(png) replace
graph export "figuras\vacunacion_grupo_edad_dosis.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_vacunacion_grupo_edad.csv", replace
********************************************************************************
use "${datos}\output\base_vacunados_practica", clear

drop if edad < 5
drop if missing(edad)
drop if edad > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 5 & edad <= 11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 39
replace grupo_edad = 5 if edad >= 40 & edad <= 49
replace grupo_edad = 6 if edad >= 50 & edad <= 59
replace grupo_edad = 7 if edad >= 60 & edad <= 69
replace grupo_edad = 8 if edad >= 70 & edad <= 79
replace grupo_edad = 9 if edad >= 80 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "05-11 años" 2 "12-17 años" 3 "18-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80 a más años"	
label values grupo_edad grupo_edad
tab grupo_edad

* Provincias
gen provincia_residencia =.
replace provincia_residencia = 1 if prov == "ACOMAYO"
replace provincia_residencia = 2 if prov == "ANTA"
replace provincia_residencia = 3 if prov == "CALCA"
replace provincia_residencia = 4 if prov == "CANAS"
replace provincia_residencia = 5 if prov == "CANCHIS"
replace provincia_residencia = 6 if prov == "CHUMBIVILCAS"
replace provincia_residencia = 7 if prov == "CUSCO"
replace provincia_residencia = 8 if prov == "ESPINAR"
replace provincia_residencia = 9 if prov == "LA CONVENCION"
replace provincia_residencia = 10 if prov == "PARURO"
replace provincia_residencia = 11 if prov == "PAUCARTAMBO"
replace provincia_residencia = 12 if prov == "QUISPICANCHIS"
replace provincia_residencia = 13 if prov == "URUBAMBA"
label variable provincia_residencia "provincia de residencia"
label define provincia_residencia 1 "Acomayo" 2 "Anta" 3 "Calca" 4 "Canas" 5 "Canchis" 6 "Chumbivilcas" 7 "Cusco" 8 "Espinar" 9 "La Convención" 10 "Paruro" 11 "Paucartambo" 12 "Quispicanchis" 13 "Urubamba"
label values provincia_residencia provincia_residencia

gen numero = _n
replace dosis = 4 if dosis > 4
save "${datos}\output\base_vacunados_variables_practica.dta", replace
********************************************************************************
use "${datos}\output\base_vacunados_variables_practica.dta", clear
forvalues i = 1/4 {
	forvalues j=1/9 {
	preserve
	keep if dosis == `i'
	keep if grupo_edad == `j'
	collapse (count) numero, by(provincia_residencia)
	*tsset fecha_resultado, daily
	*tsfill 
	rename numero numero_`i'_`j'
	save "${datos}\temporal\vacunados_practicas_`i'_`j'.dta", replace
	restore
	}
}

forvalues i=1/4 {
		use "${datos}\temporal\vacunados_practicas_`i'_1.dta", clear
		forvalues j = 2/9 {
		merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_`i'_`j'.dta", nogen
		}
	save "${datos}\temporal\vacunados_practicas_`i'.dta", replace
}

use "${datos}\temporal\vacunados_practicas_1.dta", clear
merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_2.dta", nogen
merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_3.dta", nogen
merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_4.dta", nogen

* Crear los objetivos
gen objetivo_1 = .
replace objetivo_1 = 2753 if provincia_residencia == 1
replace objetivo_1 = 7196 if provincia_residencia == 2
replace objetivo_1 = 8824 if provincia_residencia == 3
replace objetivo_1 = 3963 if provincia_residencia == 4
replace objetivo_1 = 12796 if provincia_residencia == 5
replace objetivo_1 = 9130 if provincia_residencia == 6
replace objetivo_1 = 64943 if provincia_residencia == 7
replace objetivo_1 = 9077 if provincia_residencia == 8
replace objetivo_1 = 26267 if provincia_residencia == 9
replace objetivo_1 = 2968 if provincia_residencia == 10
replace objetivo_1 = 3003 if provincia_residencia == 11
replace objetivo_1 = 7065 if provincia_residencia == 12
replace objetivo_1 = 7134 if provincia_residencia == 13


gen objetivo_2 = .
replace objetivo_2 = 3451 if provincia_residencia == 1
replace objetivo_2 = 6052 if provincia_residencia == 2
replace objetivo_2 = 8191 if provincia_residencia == 3
replace objetivo_2 = 4384 if provincia_residencia == 4
replace objetivo_2 = 11607 if provincia_residencia == 5
replace objetivo_2 = 10032 if provincia_residencia == 6
replace objetivo_2 = 49224 if provincia_residencia == 7
replace objetivo_2 = 7710 if provincia_residencia == 8
replace objetivo_2 = 22727 if provincia_residencia == 9
replace objetivo_2 = 3615 if provincia_residencia == 10
replace objetivo_2 = 7072 if provincia_residencia == 11
replace objetivo_2 = 13304 if provincia_residencia == 12
replace objetivo_2 = 7433 if provincia_residencia == 13

gen objetivo_3 = .
replace objetivo_3 = 6662 if provincia_residencia == 1
replace objetivo_3 = 14650 if provincia_residencia == 2
replace objetivo_3 = 17399 if provincia_residencia == 3
replace objetivo_3 = 10190 if provincia_residencia == 4
replace objetivo_3 = 25696 if provincia_residencia == 5
replace objetivo_3 = 19878 if provincia_residencia == 6
replace objetivo_3 = 101586 if provincia_residencia == 7
replace objetivo_3 = 15502 if provincia_residencia == 8
replace objetivo_3 = 45665 if provincia_residencia == 9
replace objetivo_3 = 7773 if provincia_residencia == 10
replace objetivo_3 = 12891 if provincia_residencia == 11
replace objetivo_3 = 24113 if provincia_residencia == 12
replace objetivo_3 = 16118 if provincia_residencia == 13

gen objetivo_4 = .
replace objetivo_4 = 3238 if provincia_residencia == 1
replace objetivo_4 = 10379 if provincia_residencia == 2
replace objetivo_4 = 11390 if provincia_residencia == 3
replace objetivo_4 = 5639 if provincia_residencia == 4
replace objetivo_4 = 17006 if provincia_residencia == 5
replace objetivo_4 = 10410 if provincia_residencia == 6
replace objetivo_4 = 85274 if provincia_residencia == 7
replace objetivo_4 = 9877 if provincia_residencia == 8
replace objetivo_4 = 35139 if provincia_residencia == 9
replace objetivo_4 = 4607 if provincia_residencia == 10
replace objetivo_4 = 7242 if provincia_residencia == 11
replace objetivo_4 = 15373 if provincia_residencia == 12
replace objetivo_4 = 13201 if provincia_residencia == 13

gen objetivo_5 = .
replace objetivo_5 = 3126 if provincia_residencia == 1
replace objetivo_5 = 8045 if provincia_residencia == 2
replace objetivo_5 = 9786 if provincia_residencia == 3
replace objetivo_5 = 4930 if provincia_residencia == 4
replace objetivo_5 = 13664 if provincia_residencia == 5
replace objetivo_5 = 8989 if provincia_residencia == 6
replace objetivo_5 = 69246 if provincia_residencia == 7
replace objetivo_5 = 7958 if provincia_residencia == 8
replace objetivo_5 = 28733 if provincia_residencia == 9
replace objetivo_5 = 4047 if provincia_residencia == 10
replace objetivo_5 = 6111 if provincia_residencia == 11
replace objetivo_5 = 12123 if provincia_residencia == 12
replace objetivo_5 = 10602 if provincia_residencia == 13

gen objetivo_6 = .
replace objetivo_6 = 2943 if provincia_residencia == 1
replace objetivo_6 = 7242 if provincia_residencia == 2
replace objetivo_6 = 7722 if provincia_residencia == 3
replace objetivo_6 = 4334 if provincia_residencia == 4
replace objetivo_6 = 11454 if provincia_residencia == 5
replace objetivo_6 = 7880 if provincia_residencia == 6
replace objetivo_6 = 48101 if provincia_residencia == 7
replace objetivo_6 = 6476 if provincia_residencia == 8
replace objetivo_6 = 22219 if provincia_residencia == 9
replace objetivo_6 = 3736 if provincia_residencia == 10
replace objetivo_6 = 4751 if provincia_residencia == 11
replace objetivo_6 = 9154 if provincia_residencia == 12
replace objetivo_6 = 7680 if provincia_residencia == 13

gen objetivo_7 = .
replace objetivo_7 = 1933 if provincia_residencia == 1
replace objetivo_7 = 5074 if provincia_residencia == 2
replace objetivo_7 = 5268 if provincia_residencia == 3
replace objetivo_7 = 3147 if provincia_residencia == 4
replace objetivo_7 = 7737 if provincia_residencia == 5
replace objetivo_7 = 6207 if provincia_residencia == 6
replace objetivo_7 = 31200 if provincia_residencia == 7
replace objetivo_7 = 4459 if provincia_residencia == 8
replace objetivo_7 = 14680 if provincia_residencia == 9
replace objetivo_7 = 2729 if provincia_residencia == 10
replace objetivo_7 = 3019 if provincia_residencia == 11
replace objetivo_7 = 6120 if provincia_residencia == 12
replace objetivo_7 = 4934 if provincia_residencia == 13

gen objetivo_8 = .
replace objetivo_8 = 1311 if provincia_residencia == 1
replace objetivo_8 = 3092 if provincia_residencia == 2
replace objetivo_8 = 3037 if provincia_residencia == 3
replace objetivo_8 = 1941 if provincia_residencia == 4
replace objetivo_8 = 4503 if provincia_residencia == 5
replace objetivo_8 = 3688 if provincia_residencia == 6
replace objetivo_8 = 16821 if provincia_residencia == 7
replace objetivo_8 = 2695 if provincia_residencia == 8
replace objetivo_8 = 7375 if provincia_residencia == 9
replace objetivo_8 = 1790 if provincia_residencia == 10
replace objetivo_8 = 1720 if provincia_residencia == 11
replace objetivo_8 = 3468 if provincia_residencia == 12
replace objetivo_8 = 2728 if provincia_residencia == 13

gen objetivo_9 = .
replace objetivo_9 = 894 if provincia_residencia == 1
replace objetivo_9 = 2145 if provincia_residencia == 2
replace objetivo_9 = 1813 if provincia_residencia == 3
replace objetivo_9 = 1098 if provincia_residencia == 4
replace objetivo_9 = 2690 if provincia_residencia == 5
replace objetivo_9 = 2280 if provincia_residencia == 6
replace objetivo_9 = 9093 if provincia_residencia == 7
replace objetivo_9 = 1561 if provincia_residencia == 8
replace objetivo_9 = 3752 if provincia_residencia == 9
replace objetivo_9 = 1198 if provincia_residencia == 10
replace objetivo_9 = 904 if provincia_residencia == 11
replace objetivo_9 = 2147 if provincia_residencia == 12
replace objetivo_9 = 1696 if provincia_residencia == 13

* Generar los porcentajes

forvalues i=1/9 {
gen una_dosis_`i' = numero_1_`i' /objetivo_`i'*100
gen dos_dosis_`i' = numero_2_`i'/objetivo_`i'*100
gen tres_dosis_`i' = numero_3_`i'/objetivo_`i'*100
gen cuarta_dosis_`i' = numero_4_`i'/objetivo_`i'*100
}

* Formato
format una_dosis_* dos_dosis_* tres_dosis_* cuarta_dosis_* %4.2f

save "${datos}\output\vacunacion_practica_graficos", replace
********************************************************************************
	use "${datos}\output\vacunacion_practica_graficos", clear
	forvalues i=1/9 {
	graph bar una_dosis_`i' dos_dosis_`i' tres_dosis_`i', xsize(8.1) ///
	over(provincia_residencia, label (angle(vertical))) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	bgcolor("$mycolor3") ///
	blabel(bar, size(8pt) position(outside) orientation(vertical) color(black) format(%4.1f)) ///
	bar(1, color("$mycolor6")) ///
	bar(2, color("$mycolor3")) ///
	bar(3, color("$mycolor7")) ///
	ytitle("Porcentaje (%)", size(4.2)) ///
	b1title("Grupo de Edad", size(4.2)) ///
	ylabel(0(50)150, nogrid) ///
	legend(cols(3) label(1 "1ra Dosis") label(2 "2da Dosis") label(3 "3ra Dosis") size(*0.8) region(col(white))) name(vacunacion_practica_`i', replace) 
	graph export "figuras\vacunacion_provincial_edad_practica_`i'.png", as(png) replace
	graph export "figuras\vacunacion_provincial_edad_practica_`i'.pdf", as(pdf) replace
	}

export delimited using "${datos}\output\dashboard_vacunacion_grupos_edades.csv", replace