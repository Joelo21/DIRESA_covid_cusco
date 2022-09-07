use "${datos}\output\base_vacunados_variables_practica.dta", clear
forvalues i = 1/13 {
	forvalues j=1/4 {
	preserve
	keep if provincia_residencia == `i'
	keep if dosis == `j'
	collapse (count) numero, by(grupo_edad)
	*tsset fecha_resultado, daily
	*tsfill 
	rename numero grupo_edad_`i'_`j'
	save "${datos}\temporal\vacunados_practicas_provincias_`i'_`j'.dta", replace
	restore
	}
}

forvalues i=1/13 {
		use "${datos}\temporal\vacunados_practicas_provincias_`i'_1.dta", clear
		forvalues j = 1/4 {
		merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_`i'_`j'.dta", nogen
		}
	save "${datos}\temporal\vacunados_practicas_provincias_`i'.dta", replace
}

use "${datos}\temporal\vacunados_practicas_provincias_1.dta", clear
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_2.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_3.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_4.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_5.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_6.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_7.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_8.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_9.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_10.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_11.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_12.dta", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_practicas_provincias_13.dta", nogen


* Crear los objetivos
gen objetivo_1 = .
replace objetivo_1 = 2753 if grupo_edad == 1
replace objetivo_1 = 3451 if grupo_edad == 2
replace objetivo_1 = 6662 if grupo_edad == 3
replace objetivo_1 = 3238 if grupo_edad == 4
replace objetivo_1 = 3126 if grupo_edad == 5
replace objetivo_1 = 2943 if grupo_edad == 6
replace objetivo_1 = 1933 if grupo_edad == 7
replace objetivo_1 = 1311 if grupo_edad == 8
replace objetivo_1 = 894 if grupo_edad == 9


gen objetivo_2 = .
replace objetivo_2 = 7196 if grupo_edad == 1
replace objetivo_2 = 6052 if grupo_edad == 2
replace objetivo_2 = 14650 if grupo_edad == 3
replace objetivo_2 = 10379 if grupo_edad == 4
replace objetivo_2 = 8045 if grupo_edad == 5
replace objetivo_2 = 7242 if grupo_edad == 6
replace objetivo_2 = 5074 if grupo_edad == 7
replace objetivo_2 = 3092 if grupo_edad == 8
replace objetivo_2 = 2145 if grupo_edad == 9


gen objetivo_3 = .
replace objetivo_3 = 8824 if grupo_edad == 1
replace objetivo_3 = 8191 if grupo_edad == 2
replace objetivo_3 = 17399 if grupo_edad == 3
replace objetivo_3 = 11390 if grupo_edad == 4
replace objetivo_3 = 9786 if grupo_edad == 5
replace objetivo_3 = 7722 if grupo_edad == 6
replace objetivo_3 = 5268 if grupo_edad == 7
replace objetivo_3 = 3027 if grupo_edad == 8
replace objetivo_3 = 1813 if grupo_edad == 9


gen objetivo_4 = .
replace objetivo_4 = 3963 if grupo_edad == 1
replace objetivo_4 = 4384 if grupo_edad == 2
replace objetivo_4 = 10190 if grupo_edad == 3
replace objetivo_4 = 5639 if grupo_edad == 4
replace objetivo_4 = 4930 if grupo_edad == 5
replace objetivo_4 = 4334 if grupo_edad == 6
replace objetivo_4 = 3147 if grupo_edad == 7
replace objetivo_4 = 1941 if grupo_edad == 8
replace objetivo_4 = 1098 if grupo_edad == 9


gen objetivo_5 = .
replace objetivo_5 = 12796 if grupo_edad == 1
replace objetivo_5 = 11607 if grupo_edad == 2
replace objetivo_5 = 25696 if grupo_edad == 3
replace objetivo_5 = 17006 if grupo_edad == 4
replace objetivo_5 = 13664 if grupo_edad == 5
replace objetivo_5 = 11454 if grupo_edad == 6
replace objetivo_5 = 7737 if grupo_edad == 7
replace objetivo_5 = 4503 if grupo_edad == 8
replace objetivo_5 = 2690 if grupo_edad == 9

gen objetivo_6 = .
replace objetivo_6 = 9130 if grupo_edad == 1
replace objetivo_6 = 10032 if grupo_edad == 2
replace objetivo_6 = 19878 if grupo_edad == 3
replace objetivo_6 = 10410 if grupo_edad == 4
replace objetivo_6 = 8989 if grupo_edad == 5
replace objetivo_6 = 7880 if grupo_edad == 6
replace objetivo_6 = 6207 if grupo_edad == 7
replace objetivo_6 = 3688 if grupo_edad == 8
replace objetivo_6 = 2280 if grupo_edad == 9

gen objetivo_7 = .
replace objetivo_7 = 64943 if grupo_edad == 1
replace objetivo_7 = 49224 if grupo_edad == 2
replace objetivo_7 = 101586 if grupo_edad == 3
replace objetivo_7 = 85274 if grupo_edad == 4
replace objetivo_7 = 69246 if grupo_edad == 5
replace objetivo_7 = 48101 if grupo_edad == 6
replace objetivo_7 = 31200 if grupo_edad == 7
replace objetivo_7 = 16821 if grupo_edad == 8
replace objetivo_7 = 9093 if grupo_edad == 9

gen objetivo_8 = .
replace objetivo_8 = 9077 if grupo_edad == 1
replace objetivo_8 = 7710 if grupo_edad == 2
replace objetivo_8 = 15502 if grupo_edad == 3
replace objetivo_8 = 9877 if grupo_edad == 4
replace objetivo_8 = 7958 if grupo_edad == 5
replace objetivo_8 = 6476 if grupo_edad == 6
replace objetivo_8 = 4459 if grupo_edad == 7
replace objetivo_8 = 2695 if grupo_edad == 8
replace objetivo_8 = 1561 if grupo_edad == 9

gen objetivo_9 = .
replace objetivo_9 = 26267 if grupo_edad == 1
replace objetivo_9 = 22727 if grupo_edad == 2
replace objetivo_9 = 45665 if grupo_edad == 3
replace objetivo_9 = 35139 if grupo_edad == 4
replace objetivo_9 = 28733 if grupo_edad == 5
replace objetivo_9 = 22219 if grupo_edad == 6
replace objetivo_9 = 14680 if grupo_edad == 7
replace objetivo_9 = 7375 if grupo_edad == 8
replace objetivo_9 = 3752 if grupo_edad == 9

gen objetivo_10 = .
replace objetivo_10 = 2968 if grupo_edad == 1
replace objetivo_10 = 3615 if grupo_edad == 2
replace objetivo_10 = 7773 if grupo_edad == 3
replace objetivo_10 = 4607 if grupo_edad == 4
replace objetivo_10 = 4047 if grupo_edad == 5
replace objetivo_10 = 3736 if grupo_edad == 6
replace objetivo_10 = 2729 if grupo_edad == 7
replace objetivo_10 = 1790 if grupo_edad == 8
replace objetivo_10 = 1198 if grupo_edad == 9

gen objetivo_11 = .
replace objetivo_11 = 3003 if grupo_edad == 1
replace objetivo_11 = 7072 if grupo_edad == 2
replace objetivo_11 = 12891 if grupo_edad == 3
replace objetivo_11 = 7242 if grupo_edad == 4
replace objetivo_11 = 6111 if grupo_edad == 5
replace objetivo_11 = 4751 if grupo_edad == 6
replace objetivo_11 = 3019 if grupo_edad == 7
replace objetivo_11 = 1720 if grupo_edad == 8
replace objetivo_11 = 904 if grupo_edad == 9

gen objetivo_12 = .
replace objetivo_12 = 7065 if grupo_edad == 1
replace objetivo_12 = 13304 if grupo_edad == 2
replace objetivo_12 = 24113 if grupo_edad == 3
replace objetivo_12 = 15373 if grupo_edad == 4
replace objetivo_12 = 12123 if grupo_edad == 5
replace objetivo_12 = 9154 if grupo_edad == 6
replace objetivo_12 = 6120 if grupo_edad == 7
replace objetivo_12 = 3468 if grupo_edad == 8
replace objetivo_12 = 2147 if grupo_edad == 9

gen objetivo_13 = .
replace objetivo_13 = 7134 if grupo_edad == 1
replace objetivo_13 = 7433 if grupo_edad == 2
replace objetivo_13 = 16118 if grupo_edad == 3
replace objetivo_13 = 13201 if grupo_edad == 4
replace objetivo_13 = 10602 if grupo_edad == 5
replace objetivo_13 = 7680 if grupo_edad == 6
replace objetivo_13 = 4934 if grupo_edad == 7
replace objetivo_13 = 2728 if grupo_edad == 8
replace objetivo_13 = 1696 if grupo_edad == 9

* Generar los porcentajes
forvalues i=1/13 {
gen una_dosis_`i' = grupo_edad_`i'_1 /objetivo_`i'*100
gen dos_dosis_`i' = grupo_edad_`i'_2/objetivo_`i'*100
gen tres_dosis_`i' = grupo_edad_`i'_3/objetivo_`i'*100
gen cuarta_dosis_`i' = grupo_edad_`i'_4/objetivo_`i'*100
}

* Formato
format una_dosis_* dos_dosis_* tres_dosis_* cuarta_dosis_* %4.2f

save "${datos}\output\vacunacion_practica_provincias_graficos", replace
********************************************************************************
use "${datos}\output\vacunacion_practica_provincias_graficos", clear
	forvalues i=1/13 {
	graph bar una_dosis_`i' dos_dosis_`i' tres_dosis_`i', xsize(8.1) ///
	over(grupo_edad, label (angle(vertical))) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	bgcolor("$mycolor3") ///
	blabel(bar, size(8pt) position(outside) orientation(vertical) color(black) format(%4.1f)) ///
	bar(1, color("$mycolor6")) ///
	bar(2, color("$mycolor3")) ///
	bar(3, color("$mycolor7")) ///
	ytitle("Porcentaje (%)", size(4.2)) ///
	b1title("Provincias", size(4.2)) ///
	ylabel(0(50)150, nogrid) ///
	legend(cols(3) label(1 "1ra Dosis") label(2 "2da Dosis") label(3 "3ra Dosis") size(*0.8) region(col(white))) ///
	name(vacunacion__provincias_`i', replace)
	
	graph export "figuras\vacunacion__provincias_`i'.pdf", as(pdf) replace
	}

*export delimited using "${datos}\output\dashboard_vacunacion_grupos_edades.csv", replace