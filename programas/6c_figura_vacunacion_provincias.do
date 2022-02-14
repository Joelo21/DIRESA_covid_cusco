
use "${datos}\output\base_vacunados", clear

merge m:1 ubigeo using "${datos}\output\ubigeos"

drop if EdadGE < 5
drop if missing(EdadGE)
drop if EdadGE > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if EdadGE >= 5 & EdadGE <= 11
replace grupo_edad = 2 if EdadGE >= 12 & EdadGE <= 19
replace grupo_edad = 3 if EdadGE >= 20 & EdadGE <= 29
replace grupo_edad = 4 if EdadGE >= 30 & EdadGE <= 39
replace grupo_edad = 5 if EdadGE >= 40 & EdadGE <= 49
replace grupo_edad = 6 if EdadGE >= 50 & EdadGE <= 59
replace grupo_edad = 7 if EdadGE >= 60 & EdadGE <= 69
replace grupo_edad = 8 if EdadGE >= 70 & EdadGE <= 79
replace grupo_edad = 9 if EdadGE >= 80 
label variable grupo_edad "Grupo de EdadGE"
label define grupo_edad 1 "5-11 años" 2 "12-19 años" 3 "20-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80 a más años"
label values grupo_edad grupo_edad
tab grupo_edad

* Añadir el distrito de Kimpirushiato a LC
replace provincia = "LA CONVENCION" if ubigeo == "080915"

gen provincia_residencia =.
replace provincia_residencia = 1 if provincia == "ACOMAYO"
replace provincia_residencia = 2 if provincia == "ANTA"
replace provincia_residencia = 3 if provincia == "CALCA"
replace provincia_residencia = 4 if provincia == "CANAS"
replace provincia_residencia = 5 if provincia == "CANCHIS"
replace provincia_residencia = 6 if provincia == "CHUMBIVILCAS"
replace provincia_residencia = 7 if provincia == "CUSCO"
replace provincia_residencia = 8 if provincia == "ESPINAR"
replace provincia_residencia = 9 if provincia == "LA CONVENCION"
replace provincia_residencia = 10 if provincia == "PARURO"
replace provincia_residencia = 11 if provincia == "PAUCARTAMBO"
replace provincia_residencia = 12 if provincia == "QUISPICANCHI"
replace provincia_residencia = 13 if provincia == "URUBAMBA"
label variable provincia_residencia "provincia de residencia"
label define provincia_residencia 1 "Acomayo" 2 "Anta" 3 "Calca" 4 "Canas" 5 "Canchis" 6 "Chumbivilcas" 7 "Cusco" 8 "Espinar" 9 "La Convención" 10 "Paruro" 11 "Paucartambo" 12 "Quispicanchi" 13 "Urubambda"
label values provincia_residencia provincia_residencia

gen numero = _n

replace dosis = 2 if dosis == 3

save "${datos}\output\base_vacunados_variables.dta", replace

*use "${datos}\output\base_vacunados_variables.dta", clear

forvalues i = 1/2 {

forvalues j=1/9 {
preserve
keep if dosis == `i'
keep if grupo_edad == `j'

collapse (count) numero, by(provincia_residencia)

*tsset fecha_resultado, daily
*tsfill 

rename numero numero_`i'_`j'

save "${datos}\temporal\vacunados_`i'_`j'.dta", replace

restore

}

}

forvalues i=1/2 {

	use "${datos}\temporal\vacunados_`i'_1.dta", clear

		forvalues j = 2/9 {

		merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_`i'_`j'.dta", nogen

		}

	save "${datos}\temporal\vacunados_`i'.dta", replace

}

use "${datos}\temporal\vacunados_1.dta", clear

merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_2.dta", nogen

* Crear los objetivos
gen objetivo_1 = .
replace objetivo_1 = 2759 if provincia_residencia == 1
replace objetivo_1 = 7215 if provincia_residencia == 2
replace objetivo_1 = 8850 if provincia_residencia == 3
replace objetivo_1 = 3974 if provincia_residencia == 4
replace objetivo_1 = 12823 if provincia_residencia == 5
replace objetivo_1 = 9149 if provincia_residencia == 6
replace objetivo_1 = 65117 if provincia_residencia == 7
replace objetivo_1 = 9095 if provincia_residencia == 8
replace objetivo_1 = 26342 if provincia_residencia == 9
replace objetivo_1 = 2976 if provincia_residencia == 10
replace objetivo_1 = 7313 if provincia_residencia == 11
replace objetivo_1 = 13946 if provincia_residencia == 12
replace objetivo_1 = 8879 if provincia_residencia == 13


gen objetivo_2 = .
replace objetivo_2 = 4770 if provincia_residencia == 1
replace objetivo_2 = 8602 if provincia_residencia == 2
replace objetivo_2 = 11586 if provincia_residencia == 3
replace objetivo_2 = 6522 if provincia_residencia == 4
replace objetivo_2 = 16145 if provincia_residencia == 5
replace objetivo_2 = 13949 if provincia_residencia == 6
replace objetivo_2 = 64064 if provincia_residencia == 7
replace objetivo_2 = 10614 if provincia_residencia == 8
replace objetivo_2 = 30434 if provincia_residencia == 9
replace objetivo_2 = 5107 if provincia_residencia == 10
replace objetivo_2 = 9593 if provincia_residencia == 11
replace objetivo_2 = 17355 if provincia_residencia == 12
replace objetivo_2 = 10162 if provincia_residencia == 13

gen objetivo_3 = .
replace objetivo_3 = 5201 if provincia_residencia == 1
replace objetivo_3 = 12302 if provincia_residencia == 2
replace objetivo_3 = 13991 if provincia_residencia == 3
replace objetivo_3 = 8071 if provincia_residencia == 4
replace objetivo_3 = 21354 if provincia_residencia == 5
replace objetivo_3 = 15703 if provincia_residencia == 6
replace objetivo_3 = 87175 if provincia_residencia == 7
replace objetivo_3 = 12381 if provincia_residencia == 8
replace objetivo_3 = 38183 if provincia_residencia == 9
replace objetivo_3 = 6301 if provincia_residencia == 10
replace objetivo_3 = 10012 if provincia_residencia == 11
replace objetivo_3 = 19577 if provincia_residencia == 12
replace objetivo_3 = 13550 if provincia_residencia == 13

gen objetivo_4 = .
replace objetivo_4 = 3164 if provincia_residencia == 1
replace objetivo_4 = 10045 if provincia_residencia == 2
replace objetivo_4 = 11177 if provincia_residencia == 3
replace objetivo_4 = 5534 if provincia_residencia == 4
replace objetivo_4 = 16458 if provincia_residencia == 5
replace objetivo_4 = 10136 if provincia_residencia == 6
replace objetivo_4 = 83726 if provincia_residencia == 7
replace objetivo_4 = 9734 if provincia_residencia == 8
replace objetivo_4 = 34195 if provincia_residencia == 9
replace objetivo_4 = 4479 if provincia_residencia == 10
replace objetivo_4 = 7104 if provincia_residencia == 11
replace objetivo_4 = 15000 if provincia_residencia == 12
replace objetivo_4 = 13028 if provincia_residencia == 13

gen objetivo_5 = .
replace objetivo_5 = 3108 if provincia_residencia == 1
replace objetivo_5 = 7869 if provincia_residencia == 2
replace objetivo_5 = 9502 if provincia_residencia == 3
replace objetivo_5 = 4811 if provincia_residencia == 4
replace objetivo_5 = 13339 if provincia_residencia == 5
replace objetivo_5 = 8770 if provincia_residencia == 6
replace objetivo_5 = 66716 if provincia_residencia == 7
replace objetivo_5 = 7722 if provincia_residencia == 8
replace objetivo_5 = 28035 if provincia_residencia == 9
replace objetivo_5 = 3965 if provincia_residencia == 10
replace objetivo_5 = 5990 if provincia_residencia == 11
replace objetivo_5 = 11785 if provincia_residencia == 12
replace objetivo_5 = 10212 if provincia_residencia == 13

gen objetivo_6 = .
replace objetivo_6 = 2896 if provincia_residencia == 1
replace objetivo_6 = 7110 if provincia_residencia == 2
replace objetivo_6 = 7518 if provincia_residencia == 3
replace objetivo_6 = 4261 if provincia_residencia == 4
replace objetivo_6 = 11201 if provincia_residencia == 5
replace objetivo_6 = 7805 if provincia_residencia == 6
replace objetivo_6 = 46143 if provincia_residencia == 7
replace objetivo_6 = 6291 if provincia_residencia == 8
replace objetivo_6 = 21612 if provincia_residencia == 9
replace objetivo_6 = 3739 if provincia_residencia == 10
replace objetivo_6 = 4555 if provincia_residencia == 11
replace objetivo_6 = 8841 if provincia_residencia == 12
replace objetivo_6 = 7465 if provincia_residencia == 13

gen objetivo_7 = .
replace objetivo_7 = 1785 if provincia_residencia == 1
replace objetivo_7 = 4848 if provincia_residencia == 2
replace objetivo_7 = 4984 if provincia_residencia == 3
replace objetivo_7 = 3010 if provincia_residencia == 4
replace objetivo_7 = 7290 if provincia_residencia == 5
replace objetivo_7 = 5986 if provincia_residencia == 6
replace objetivo_7 = 29662 if provincia_residencia == 7
replace objetivo_7 = 4337 if provincia_residencia == 8
replace objetivo_7 = 13754 if provincia_residencia == 9
replace objetivo_7 = 2613 if provincia_residencia == 10
replace objetivo_7 = 2909 if provincia_residencia == 11
replace objetivo_7 = 5811 if provincia_residencia == 12
replace objetivo_7 = 4665 if provincia_residencia == 13

gen objetivo_8 = .
replace objetivo_8 = 1315 if provincia_residencia == 1
replace objetivo_8 = 2960 if provincia_residencia == 2
replace objetivo_8 = 2889 if provincia_residencia == 3
replace objetivo_8 = 1872 if provincia_residencia == 4
replace objetivo_8 = 4338 if provincia_residencia == 5
replace objetivo_8 = 3538 if provincia_residencia == 6
replace objetivo_8 = 15705 if provincia_residencia == 7
replace objetivo_8 = 2518 if provincia_residencia == 8
replace objetivo_8 = 6827 if provincia_residencia == 9
replace objetivo_8 = 1707 if provincia_residencia == 10
replace objetivo_8 = 1614 if provincia_residencia == 11
replace objetivo_8 = 3319 if provincia_residencia == 12
replace objetivo_8 = 2564 if provincia_residencia == 13

gen objetivo_9 = .
replace objetivo_9 = 788 if provincia_residencia == 1
replace objetivo_9 = 1903 if provincia_residencia == 2
replace objetivo_9 = 1599 if provincia_residencia == 3
replace objetivo_9 = 967 if provincia_residencia == 4
replace objetivo_9 = 2351 if provincia_residencia == 5
replace objetivo_9 = 1958 if provincia_residencia == 6
replace objetivo_9 = 7989 if provincia_residencia == 7
replace objetivo_9 = 1367 if provincia_residencia == 8
replace objetivo_9 = 3270 if provincia_residencia == 9
replace objetivo_9 = 1054 if provincia_residencia == 10
replace objetivo_9 = 785 if provincia_residencia == 11
replace objetivo_9 = 1882 if provincia_residencia == 12
replace objetivo_9 = 1491 if provincia_residencia == 13

* Generar los porcentajes

forvalues i=1/9 {

gen dos_dosis_`i' = numero_2_`i' /objetivo_`i'*100
gen brecha_`i' = numero_1_`i'/objetivo_`i'*100
gen faltante_`i' = 100 - dos_dosis_`i' - brecha_`i'
}

* Formato
format dos_dosis_* brecha_* faltante_* %4.2f


forvalues i=1/9 {
graph hbar dos_dosis_`i' brecha_`i' faltante_`i', ///
over(provincia_residencia) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor7")) ///
bar(2, color("$mycolor6")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis")  label(3 "Faltante") size(*0.8) region(col(white))) name(provincia_`i', replace)

graph export "figuras\vacunacion_provincial_edad_`i'.png", as(png) replace
graph export "figuras\vacunacion_provincial_edad_`i'.pdf", as(pdf) replace
}
