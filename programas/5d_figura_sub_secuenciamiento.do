use "${datos}\output\datos_variantes", clear

keep if variante == 4
gen linaje_omicron =.
replace linaje_omicron = 1 if linaje == "AY.119.1" |  linaje == "AY.119"
replace linaje_omicron = 2 if linaje == "BA.1" | linaje == "BA.1.1" | linaje == "BA.1.18" | linaje == "BA.1.1.1" | linaje == "BA.1.14.1" | linaje == "BA.1.15"
replace linaje_omicron = 3 if linaje == "BA.2" | linaje == "Linaje BA.2" | linaje == "BA.2.1" | linaje == "BA.2.2" | linaje == "BA.2.3" | linaje == " BA.2.4" | linaje == "BA.2.5" | linaje == "BA.2.6" | linaje == "BA.2.9" | linaje == "Linaje BA.2.9" | linaje == "BA.2.10" | linaje == "BA.2.12.1" | linaje == "BG.1" |linaje == "BG.2" | linaje == "BG.3" | linaje == "BA.2.13" | linaje == "BA.2.23" | linaje == "BA.2.36" | linaje == "BA.2.38" | linaje == "BA.2.42" | linaje == "BA.2.53"
replace linaje_omicron = 4 if linaje == "BA.4" | linaje == "BA.4.1" | linaje == "BA.4.2" | linaje == "BA.4.6"
replace linaje_omicron = 5 if linaje == "BA.5" | linaje == "BA.5.1"| linaje == "BA.5.1.8" | linaje == "BA.5.2" | linaje == "BA.5.2.1" | linaje == "BA.5.3" | linaje == "BA.5.3.1" | linaje == "BE.1"| linaje == "BA.5.3.2" | linaje == "BA.5.4" | linaje == "BA.5.5" | linaje == "BA.5.6"
replace linaje_omicron = 6 if linaje == "BC.2"
replace linaje_omicron = 7 if linaje == "BF.7"
replace linaje_omicron = 8 if linaje == "BQ.1" | linaje == "BQ.1.11"
replace linaje_omicron = 9 if linaje == "BQ.1.5"
replace linaje_omicron = 10 if linaje == "BQ.1.10"
replace linaje_omicron = 11 if linaje == "BE.1"
replace linaje_omicron = 12 if linaje == "BE.1.1"
replace linaje_omicron = 13 if linaje == "BG.3"
replace linaje_omicron = 14 if linaje == "XBB.2"
replace linaje_omicron = 15 if linaje == "CH.1.1"

forvalues i=1/15 {
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
merge 1:1 mes using "${datos}\temporal\datos_linaje_6", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_7", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_8", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_9", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_10", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_11", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_12", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_13", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_14", nogen
merge 1:1 mes using "${datos}\temporal\datos_linaje_15", nogen

recode * (.=0)


gen suma_total = linaje_omicron1+linaje_omicron2+linaje_omicron3+linaje_omicron4+linaje_omicron5+linaje_omicron6+linaje_omicron7+linaje_omicron8+linaje_omicron9+linaje_omicron10+linaje_omicron11+linaje_omicron12+linaje_omicron13+linaje_omicron14+linaje_omicron15

gen linaje_omicron_1 = linaje_omicron1/suma
gen linaje_omicron_2 = linaje_omicron2/suma
gen linaje_omicron_3 = linaje_omicron3/suma
gen linaje_omicron_4 = linaje_omicron4/suma
gen linaje_omicron_5 = linaje_omicron5/suma
gen linaje_omicron_6 = linaje_omicron6/suma
gen linaje_omicron_7 = linaje_omicron7/suma
gen linaje_omicron_8 = linaje_omicron8/suma
gen linaje_omicron_9 = linaje_omicron9/suma
gen linaje_omicron_10 = linaje_omicron10/suma
gen linaje_omicron_11 = linaje_omicron11/suma
gen linaje_omicron_12 = linaje_omicron12/suma
gen linaje_omicron_13 = linaje_omicron13/suma
gen linaje_omicron_14 = linaje_omicron14/suma
gen linaje_omicron_15 = linaje_omicron15/suma


*gen ninguno = variante_6/suma

replace mes = mes + 731
format mes %tm

format linaje_omicron_1 linaje_omicron_2 linaje_omicron_3 linaje_omicron_4 linaje_omicron_5 linaje_omicron_6 linaje_omicron_7 linaje_omicron_8 linaje_omicron_9 linaje_omicron_10 linaje_omicron_11 linaje_omicron_12 linaje_omicron_13 linaje_omicron_14 linaje_omicron_15 %8.2f
label var suma_total "Número de Sepas Secuenciadas"

* Nuevo Grafico Barras Apiladas
twoway (bar linaje_omicron_5 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor15")) ///
(bar linaje_omicron_4 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor2")) ///
(bar linaje_omicron_9 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor8")) ///
(bar linaje_omicron_8 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor7")) ///
(bar linaje_omicron_14 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor13")) ///
(bar linaje_omicron_10 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor9")) ///
(bar linaje_omicron_15 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor14")) ///
(bar linaje_omicron_13 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor12")) ///
(bar linaje_omicron_12 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor11")) ///
(bar linaje_omicron_11 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor10")) ///
(bar linaje_omicron_7 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor6")) ///
(bar linaje_omicron_6 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor5")) ///
(bar linaje_omicron_2 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor4")) ///
(bar linaje_omicron_3 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor3")) ///
(bar linaje_omicron_1 mes, barwidth(0.6) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor1")) ///
(scatter linaje_omicron_1 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_2) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_2 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_2) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_3 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_3) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_4 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_4) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_5 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_5) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_6 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_6) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_7 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_7) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_8 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_8) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_9 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_9) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_10 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_10) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_11 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_11) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_12 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_12) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_13 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_13) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_14 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_14) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(scatter linaje_omicron_15 mes, msize(vsmall) mcolor("$mycolor17") mlabel(linaje_omicron_15) mlabcolor("$mycolor17") mlabsize(vsmall) connect()) ///
(line suma_total mes, lcolor("$mycolor4") lpattern(shortdash_dot) lwidth(thick) yaxis(2) yscale(axis(2)) ylabel(0(20)140, axis(2))) ///
(scatter suma_total mes, msize(vsmall) mcolor("$mycolor17") mlabel(suma_total) mlabposition(12) mlabcolor("$mycolor17") mlabsize(vsmall) connect() yaxis(2) yscale(axis(2)) ylabel(0(50)300, axis(2))) ///
 ,	xtitle("Mes", size(*0.7)) ///
 ytitle("Porcentaje de las Variantes Encontradas", size(*0.5)) ///
	graphregion(color(white)) ///
	xlabel(743 "Dic" 744 "Ene" 745 "Feb" 746 "Mar" 747 "Abr" 748 "May" 749 "Jun" 750 "Jul" 751 "Ago" 752 "Set" 753 "Oct" 754 "Nov" 755 "Dic") ///
legend(cols(5) label(1 "BA.5") label(2 "BA.4") label(3 "BQ.1.5") label(4 "BQ.1") label(5 "XBB.2") label(6 "BQ.1.10") label(7 "CH.1.1") label(8 "BG.3") label(9 "BE.1.1") label(10 "BE.1") label(11 "BF.7") label(12 "BC.2") label(13 "BA.1") label(14 "BA.2") label(15 "AY.119.1") label (16 "Total de Muestra") order(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) size(*0.45) region(col(white))) ///
	title("Subvariantes en la Región Cusco", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) name(subvariantes, replace)
	
gr export "figuras\subvariantes.png", as(png) replace
gr export "figuras\subvariantes.pdf", as(pdf) replace	

export delimited using "${datos}\output\dashboard_subvariantes.csv", replace