use "${datos}\output\base_vacunados_variables_practica.dta", clear
forvalues i = 1/4 {
	forvalues j=1/9 {
	preserve
	keep if dosis == `i'
	keep if grupo_edad == `j'
	collapse (count) numero, by(provincia_residencia)
	*tsset fecha_resultado, daily
	*tsfill 
	rename numero grupo_edad_`i'_`j'
	save "${datos}\temporal\vacunados_practicas_provincias_`i'_`j'.dta", replace
	restore
	}
}

forvalues i=1/4 {
		use "${datos}\temporal\vacunados_practicas_provincias_`i'_1.dta", clear
		forvalues j = 2/9 {
		merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_provincias_`i'_`j'.dta", nogen
		}
	save "${datos}\temporal\vacunados_practicas_provincias_`i'.dta", replace
}

use "${datos}\temporal\vacunados_practicas_provincias_1.dta", clear
merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_provincias_2.dta", nogen
merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_provincias_3.dta", nogen
merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_practicas_provincias_4.dta", nogen


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
gen una_dosis_`i' = grupo_edad_1_`i' /objetivo_`i'*100
gen dos_dosis_`i' = grupo_edad_2_`i'/objetivo_`i'*100
gen tres_dosis_`i' = grupo_edad_3_`i'/objetivo_`i'*100
gen cuarta_dosis_`i' = grupo_edad_4_`i'/objetivo_`i'*100
}

* Formato
format una_dosis_* dos_dosis_* tres_dosis_* cuarta_dosis_* %4.2f

save "${datos}\output\vacunacion_practica_provincias_graficos", replace
********************************************************************************
use "${datos}\output\vacunacion_practica_provincias_graficos", clear
	forvalues i=1/1 {
	graph bar una_dosis_`i' dos_dosis_`i' tres_dosis_`i', xsize(8.1) ///
	over(provincia_residencia, label (angle(vertical))) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	bgcolor("$mycolor3") ///
	blabel(bar, size(8pt) position(outside) orientation(vertical) color(black) format(%4.1f)) ///
	bar(1, color("$mycolor6")) ///
	bar(2, color("$mycolor3")) ///
	bar(3, color("$mycolor7")) ///
	ytitle("Porcentaje (%)", size(4.2)) ///
	b1title("Provincias", size(4.2)) ///
	ylabel(0(50)150, nogrid) ///
	legend(cols(3) label(1 "1ra Dosis") label(2 "2da Dosis") label(3 "3ra Dosis") size(*0.8) region(col(white))) name(vacunacion_practica_provincias_`i', replace) 
	}

*export delimited using "${datos}\output\dashboard_vacunacion_grupos_edades.csv", replace