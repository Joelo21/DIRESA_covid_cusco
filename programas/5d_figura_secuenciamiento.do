use "${datos}\output\datos_variantes", clear

forvalues i=1/6{
preserve
keep if variante == `i'
collapse (count) dni, by(mes)
rename dni variante_`i'
save "${datos}\temporal\datos_variantes_`i'", replace
restore
}

use "${datos}\temporal\datos_variantes_1", clear
merge 1:1 mes using "${datos}\temporal\datos_variantes_2", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_3", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_4", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_5", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_6", nogen

*save "datos\output\datos_variante_lab_cayetano", replace
*use "datos\output\datos_variante_lab_cayetano", clear

recode * (.=0)

gen suma = variante_1 + variante_2+variante_3+variante_4+variante_5 
gen suma_total = variante_1 + variante_2+variante_3+variante_4 + variante_5


gen lambda = variante_1/suma
gen gamma = variante_2/suma
gen delta = variante_3/suma
gen omicron = variante_4/suma
gen otros = variante_5/suma
*gen ninguno = variante_6/suma

replace mes = mes + 731
format mes %tm


format lambda gamma delta omicron otros %8.2f
label var suma_total "Número de Sepas Secuenciadas"


/*
gen lambda2 = variante_1
gen gamma2 = variante_2
gen delta2 = variante_3
gen otros2 = variante_4

********************************************************

*CIRUCLO POR TERMINAR
graph pie lambda2 gamma2 delta2 otros2,
	plabel(_all percent, size(*1.5) color(White))
	legend(off)
	plotregion(lstyle(none))
	bgcolor(white)
	title("Expenditures, XYZ Corp.")
	subtitle("2002")	
	
*/
*Graficos de Barras Apiladas
twoway (bar lambda mes, barwidth(0.5) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor2")) ///
(scatter lambda mes, msize(vsmall) mcolor("$mycolor2") mlabel(lambda) mlabcolor("$mycolor2") mlabsize(vsmall) connect()) ///
(bar gamma mes, barwidth(0.5) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor3")) ///
(scatter gamma mes, msize(vsmall) mcolor("$mycolor3") mlabel(gamma) mlabcolor("$mycolor3") mlabsize(vsmall) connect()) ///
(bar delta mes, barwidth(0.5) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor6")) ///
(scatter delta mes, msize(vsmall) mcolor("$mycolor6") mlabel(delta) mlabcolor("$mycolor6") mlabsize(vsmall) connect()) ///
(bar omicron mes, barwidth(0.5) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor7")) ///
(scatter omicron mes, msize(vsmall) mcolor("$mycolor7") mlabel(omicron) mlabcolor("$mycolor7") mlabsize(vsmall) connect()) ///
(bar otros mes, barwidth(0.5) yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) color("$mycolor1") ) ///
(scatter otros mes, msize(vsmall) mcolor("$mycolor1") mlabel(otros) mlabcolor("$mycolor1") mlabsize(vsmall) connect()) ///
(line suma_total mes, color("$mycolor4") lwidth(tiny) lpattern(shortdash_dot) yaxis(2) yscale(axis(2)) ylabel(0(40)240, axis(2))) ///
(scatter suma_total mes, msize(vsmall) mcolor("$mycolor17") mlabel(suma_total) mlabposition(12) mlabcolor("$mycolor17") mlabsize(vsmall) connect() yaxis(2) yscale(axis(2)) ylabel(0(50)300, axis(2))) ///
,	xtitle("Mes", size(*0.7)) ///
 ytitle("Porcentaje de las Variantes Econtradas", size(*0.6)) ///
	graphregion(color(white)) ///
	xlabel(735 "Abr" 736 "May" 737 "Jun" 738 "Jul" 739 "Ago" 740 "Sep" 741 "Oct" 742 "Nov" 743 "Dic" 744 "Ene" 745 "Feb" 746 "Mar" 747 "Abr" 748 "May" 749 "Jun" 750 "Jul" 751 "Ago" 752 "Set" 753 "Oct" 754 "Nov" 755 "Dic") ///
	legend(cols(3) label(1 "Lambda") label(2 "") label(3 "Gamma") label(4 "") label(5 "Delta") label(6 "")  label(7 "Omicron") label(8 "") label(9 "Otros") label(11 "Total de Muestra") label(12 "") order(11 1 3 5 7 9) size(*0.65) region(col(white))) ///
	title("Variantes en la Región Cusco", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) name(variantes_barras, replace)
	
gr export "figuras\variantes.png", as(png) replace
gr export "figuras\variantes.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_variantes.csv", replace

