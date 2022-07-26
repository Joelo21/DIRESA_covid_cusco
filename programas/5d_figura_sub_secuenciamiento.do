use "${datos}\output\datos_variantes", clear

keep if variante == 4
gen linaje_omicron =.
replace linaje_omicron = 1 if linaje == "AY.119.1"
replace linaje_omicron = 2 if linaje == "BA.1" | linaje == "BA.1.1" | linaje == "BA.1.1.1" | linaje == "BA.1.14.1" | linaje == "BA.1.15"
replace linaje_omicron = 3 if linaje == "BA.2" | linaje == "Linaje BA.2" | linaje == "BA.2.3" | linaje == " BA.2.3" | linaje == "BA.2.9" | linaje == "Linaje BA.2.9" | linaje == "BA.2.10" | linaje == "BA.2.12.1" | linaje == "BA.2.13" | linaje == "BA.2.23" | linaje == "BA.2.36" | linaje == "BA.2.38" | linaje == "BA.2.42" | linaje == "BA.2.53"
replace linaje_omicron = 4 if linaje == "BA.4" | linaje == "BA.4.1" | linaje == "BA.4.2" | linaje == "BA.4.6"
replace linaje_omicron = 5 if linaje == "BA.5" | linaje == "BA.5.1" | linaje == "BA.5.2" | linaje == "BA.5.2.1" | linaje == "BA.5.5" | linaje == "BA.5.6"

forvalues i=1/5 {
preserve
keep if linaje_omicron == `i'
collapse (count) dni, by(mes)
rename dni linaje_omicron`i'
save "${datos}\temporal\datos_linaje_`i'", replace
restore
}

use "${datos}\temporal\datos_linaje_1", clear
merge 1:1 mes using "${datos}\temporal\datos_linaje_2", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_3", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_4", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_5", nogen
recode * (.=0)


gen suma_total = linaje_omicron1+linaje_omicron2+linaje_omicron3+linaje_omicron4+linaje_omicron5

gen linaje_omicron_1 = linaje_omicron1/suma
gen linaje_omicron_2 = linaje_omicron2/suma
gen linaje_omicron_3 = linaje_omicron3/suma
gen linaje_omicron_4 = linaje_omicron4/suma
gen linaje_omicron_5 = linaje_omicron5/suma


*gen ninguno = variante_6/suma

replace mes = mes + 731
format mes %tm

format linaje_omicron_1 linaje_omicron_2 linaje_omicron_3 linaje_omicron_4 linaje_omicron_5 %8.2f
label var suma_total "Número de Sepas Secuenciadas"

* Nuevo Grafico Barras Apiladas
twoway (bar linaje_omicron_5 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor10")) ///
(bar linaje_omicron_2 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor11")) ///
(bar linaje_omicron_3 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor16")) ///
(bar linaje_omicron_4 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor13")) ///
(bar linaje_omicron_1 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor12")) ///
(scatter linaje_omicron_1 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_1) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_2 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_2) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_3 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_3) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_4 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_4) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_5 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_5) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(line suma_total mes, lcolor("$mycolor4") lpattern(shortdash_dot) lwidth(thick) yaxis(2) yscale(axis(2)) ylabel(0(20)140, axis(2))) ///
(scatter suma_total mes, msize(vsmall) mcolor("$mycolor17") mlabel(suma_total) mlabposition(12) mlabcolor("$mycolor17") mlabsize(vsmall) connect() yaxis(2) yscale(axis(2)) ylabel(0(20)180, axis(2))) ///
 ,	xtitle("Mes", size(*0.7)) ///
 ytitle("Porcentaje de las Variantes Encontradas", size(*0.5)) ///
	graphregion(color(white)) ///
	xlabel(743 "Dic" 744 "Ene" 745 "Feb" 746 "Mar" 747 "Abr" 748 "May" 749 "Jun" 750 "Jul") ///
legend(cols(3) label(5 "AY.119.1") label(2 "BA.1") label(3 "BA.2") label(4 "BA.4") label(1 "BA.5") label (6 "Total de Muestra") order(5 2 3 4 1 6) size(*0.45) region(col(white))) ///
	title("Subvariantes en la Región Cusco", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) name(subvariantes, replace)
	
gr export "figuras\subvariantes.png", as(png) replace
gr export "figuras\subvariantes.pdf", as(pdf) replace	
/*
* Definimos nuestra paleta 
twoway (line linaje_omicron_1 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor2")) ///
(scatter linaje_omicron_1 mes, msize(vsmall) mcolor("$mycolor2") mlabel(linaje_omicron_1) mlabcolor("$mycolor2") mlabsize(vsmall) connect()) ///
(line linaje_omicron_2 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor3")) ///
(scatter linaje_omicron_2 mes, msize(vsmall) mcolor("$mycolor3") mlabel(linaje_omicron_2) mlabcolor("$mycolor3") mlabsize(vsmall) connect()) ///
(line linaje_omicron_3 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor1")) ///
(scatter linaje_omicron_3 mes, msize(vsmall) mcolor("$mycolor1") mlabel(linaje_omicron_3) mlabcolor("$mycolor1") mlabsize(vsmall) connect()) ///
(line linaje_omicron_4 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor4")) ///
(scatter linaje_omicron_4 mes, msize(vsmall) mcolor("$mycolor4") mlabel(linaje_omicron_4) mlabcolor("$mycolor4") mlabsize(vsmall) connect()) ///
(line linaje_omicron_5 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor11")) ///
(scatter linaje_omicron_5 mes, msize(vsmall) mcolor("$mycolor11") mlabel(linaje_omicron_5) mlabcolor("$mycolor11") mlabsize(vsmall) connect()) ///
(line linaje_omicron_6 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor12")) ///
(scatter linaje_omicron_6 mes, msize(vsmall) mcolor("$mycolor12") mlabel(linaje_omicron_6) mlabcolor("$mycolor12") mlabsize(vsmall) connect()) ///
(line linaje_omicron_7 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor13")) ///
(scatter linaje_omicron_7 mes, msize(vsmall) mcolor("$mycolor13") mlabel(linaje_omicron_7) mlabcolor("$mycolor13") mlabsize(vsmall) connect()) ///
(line linaje_omicron_8 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor14")) ///
(scatter linaje_omicron_8 mes, msize(vsmall) mcolor("$mycolor14") mlabel(linaje_omicron_8) mlabcolor("$mycolor14") mlabsize(vsmall) connect()) ///
(line linaje_omicron_9 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor8")) ///
(scatter linaje_omicron_9 mes, msize(vsmall) mcolor("$mycolor8") mlabel(linaje_omicron_9) mlabcolor("$mycolor8") mlabsize(vsmall) connect()) ///
(line linaje_omicron_10 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor8")) ///
(scatter linaje_omicron_10 mes, msize(vsmall) mcolor("$mycolor8") mlabel(linaje_omicron_10) mlabcolor("$mycolor8") mlabsize(vsmall) connect()) ///
(line linaje_omicron_11 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor8")) ///
(scatter linaje_omicron_11 mes, msize(vsmall) mcolor("$mycolor8") mlabel(linaje_omicron_11) mlabcolor("$mycolor8") mlabsize(vsmall) connect()) ///
(line linaje_omicron_12 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor8")) ///
(scatter linaje_omicron_12 mes, msize(vsmall) mcolor("$mycolor8") mlabel(linaje_omicron_12) mlabcolor("$mycolor8") mlabsize(vsmall) connect()) ///
(line linaje_omicron_13 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor7")) ///
(scatter linaje_omicron_13 mes, msize(vsmall) mcolor("$mycolor7") mlabel(linaje_omicron_13) mlabcolor("$mycolor7") mlabsize(vsmall) connect()) ///
(line linaje_omicron_14 mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor6")) ///
(scatter linaje_omicron_14 mes, msize(vsmall) mcolor("$mycolor6") mlabel(linaje_omicron_14) mlabcolor("$mycolor6") mlabsize(vsmall) connect()) ///
(line suma_total mes, lcolor("$mycolor7") lwidth(thick) yaxis(2) yscale(axis(2)) ylabel(0(40)120, axis(2))) ///
(scatter suma_total mes, msize(vsmall) mcolor("$mycolor7") mlabel(suma_total) mlabposition(12) mlabcolor("$mycolor7") mlabsize(vsmall) connect() yaxis(2) yscale(axis(2)) ylabel(0(40)120, axis(2))) ///
 ,	xtitle("Mes", size(*0.7)) ///
 ytitle("Porcentaje de las Variantes Econtradas", size(*0.7)) ///
	graphregion(color(white)) ///
	xlabel(743 "Dic" 744 "Ene" 745 "Feb" 746 "Mar" 747 "Abr" 748 "May" 749 "Jun") ///
legend(cols(5) label(1 "BA.1") label(3 "BA.1.1") label(5 "BA.1.1.1") label(7 "BA.2") label(9 "BA.2.3") label(11 "BA.2.9") label(13 "BA.2.10") label(15 "BA.2.12.1") label(17 "BA.2.13") label(19 "BA.2.23") label(21 "BA.2.36") label(23 "BA.2.38") label(25 "BA.4") label(27 "BA.5") label(29 "Total de Muestra") order(1 3 5 7 9 11 13 15 17 19 21 23 25 27 29) size(*0.45) region(col(white))) ///
	title("Variantes en la Región Cusco", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) name(variantes, replace)
	
gr export "figuras\subvariantes.png", as(png) replace
gr export "figuras\subvariantes.pdf", as(pdf) replace
