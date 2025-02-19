
use "${datos}\output\data_series_region.dta", clear

* Mantener las variables de interés
keep fecha positivo defuncion 

* Borrar fechas irrelevantes
drop if fecha <= d(13mar2020)
drop if fecha > d($fecha)

* Generar los promedios de casos y defunciones
gen promedio_casos = (positivo[_n-3] + positivo[_n-2] + positivo[_n-1] + positivo[_n] + positivo[_n+1] + positivo[_n+2] + positivo[_n+3])/7

gen promedio_defunciones = (defuncion[_n-3] + defuncion[_n-2] + defuncion[_n-1] + defuncion[_n] + defuncion[_n+1] + defuncion[_n+2] + defuncion[_n+3])/7

* Identificar la fecha mínima de casos y cuántos casos en promedio 
******************************************************************************** PROMEDIO DE CASOS
* Primera ola
* Identificar los cuántos casos en el mínimo y máximo
sum promedio_casos if fecha >= d(01jul2020) & fecha <= d(31jan2021)
gen casos_min_1 = r(min)
gen casos_max_1 = r(max)

* Identificar la fecha de esos casos
sum fecha if (promedio_casos == casos_min_1) & (fecha >= d(01jul2020) & fecha <= d(31jan2021))
gen fecha_casos_min_1 = r(mean)

sum fecha if (promedio_casos == casos_max_1) & (fecha >= d(01jul2020) & fecha <= d(31jan2021))
gen fecha_casos_max_1 = r(mean)

********************************************************************************
* Segunda ola
sum promedio_casos if fecha > d(31jan2021) & fecha <= d(31dec2021)
gen casos_min_2 = r(min)
gen casos_max_2 = r(max)
*
sum fecha if (promedio_casos == casos_max_2) & (fecha > d(31jan2021) & fecha <= d(31dec2021))
gen fecha_casos_min_2 = r(mean)

sum fecha if (promedio_casos == casos_max_2) & (fecha > d(31jan2021) & fecha <= d(31dec2021))
gen fecha_casos_max_2 = r(mean)

********************************************************************************
* Tercera ola
sum promedio_casos if fecha > d(31jan2021) 
gen casos_min_3 = r(min)
gen casos_max_3 = r(max)
*
sum fecha if (promedio_casos == casos_max_3) & fecha > d(31jan2021)
gen fecha_casos_min_3 = r(mean)

sum fecha if (promedio_casos == casos_max_3) & fecha > d(31jan2021)
gen fecha_casos_max_3 = r(mean)

********************************************************************************
* Identificar el último datos en la base: tres días antes del actual (por el promedio de 7 días)
gen numero = _n 
gen fecha_actual = _N -3

sum fecha if numero == fecha_actual
gen fecha_casos_actual = r(mean)

sum promedio_casos if numero == fecha_actual
gen casos_actual = r(mean)

* Poner en formato con un decimal
format promedio* %9.2g
format casos* %9.2g

/*
* Generar gráfico
twoway ///
(line promedio_casos fecha, lcolor("$mycolor7") lpattern(solid) lpattern(solid) xline(22426, lcolor("$mycolor5") lpattern(shortdash) lwidth(mthick)) xline(22149, lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick))) ///
(scatter casos_max_1 fecha if fecha == fecha_casos_max_1, mlabel(casos_max_1) msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7")) ///
(line casos_max_1 fecha, lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick)) ///
(line casos_min_1 fecha, lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick)) ///
(line casos_min_2 fecha, lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick)) ///
(line casos_max_2 fecha, lcolor("$mycolor5") lpattern(shortdash) lwidth(mthick)) ///
(scatter casos_max_2 fecha if fecha == fecha_casos_max_2, mlabel(casos_max_2) msize(vsmall) mcolor("$mycolor2") mlabcolor("$mycolor2")) ///
(line casos_actual fecha, lcolor("$mycolor7") lpattern(shortdash) lwidth(mthick)) ///
(scatter casos_actual fecha if fecha == fecha_casos_actual, mlabel(casos_actual) msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7")) ///
if fecha>=d(20mar2020) & fecha <=d($fecha) ///
, 	ylabel(0(200)2500, labsize(*0.6)) ///
	tlabel(20mar2020(90)$fecha) ///
	ylabel(, nogrid) xlabel(, nogrid) ///
	xtitle("") ///
	ytitle("Promedio Móvil de Casos") ///
	scale(.70) ///
	graphregion(color(white)) ///
	title("Promedio de Casos por COVID-19 Confirmados", box bexpand bcolor("$mycolor3") color(white)) ///
	text(1500 21994 "{it:Acualizado al}" "{it:$fecha}", place(ne) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor7") fcolor("$mycolor7")) ///
	legend(off) name(casos_p, replace)

gr export "figuras\promedio_casos_2020_2021_2022.png", as(png) replace
*/
*------------------------------------------------------------------------------------- PROMEDIO DE DEFUNCIONES

* Identificar los cuántos casos en el mínimo y máximo
sum promedio_defunciones if fecha >= d(01jul2020) & fecha <= d(31jan2021)
gen defunciones_min_1 = r(min)
gen defunciones_max_1 = r(max)

* Identificar la fecha de esos casos
sum fecha if (promedio_defunciones == defunciones_min_1) & (fecha >= d(01jul2020) & fecha <= d(31jan2021))
gen fecha_defunciones_min_1 = r(mean)

sum fecha if (promedio_defunciones == defunciones_max_1) & (fecha >= d(01jul2020) & fecha <= d(31jan2021))
gen fecha_defunciones_max_1 = r(mean)
local fecha_m_1 = r(mean)

********************************************************************************
* Segunda ola
sum promedio_defunciones if fecha > d(31jan2021) 
gen defunciones_min_2 = r(min)
gen defunciones_max_2 = r(max)

sum fecha if (promedio_defunciones == defunciones_max_2) & (fecha > d(31jan2021) & fecha <= d(31dec2021))
gen fecha_defunciones_min_2 = r(mean)

sum fecha if (promedio_defunciones == defunciones_max_2) & (fecha > d(31jan2021) & fecha <= d(31dec2021))
gen fecha_defunciones_max_2 = r(mean)
local fecha_m_2 = r(mean)

********************************************************************************
* Tercera ola
sum promedio_defunciones if fecha > d(31dec2021)
gen defunciones_min_3 = r(min)
gen defunciones_max_3 = r(max)

sum fecha if (promedio_defunciones == defunciones_max_3) & fecha > d(31dec2021)
gen fecha_defunciones_min_3 = r(mean)

sum fecha if (promedio_defunciones == defunciones_max_3) & fecha > d(31dec2021)
gen fecha_defunciones_max_3 = r(mean)
local fecha_m_3 = r(mean)

********************************************************************************
* Identificar el último datos en la base: tres días antes del actual (por el promedio de 7 días)
*gen numero = _n 
*gen fecha_actual = _N -3

sum fecha if numero == fecha_actual
gen fecha_defunciones_actual = r(mean)

sum promedio_defunciones if numero == fecha_actual
gen defunciones_actual = r(mean)

* Poner en formato con un decimal
*format promedio* %8.0f
format defunciones* %9.2g
/*
* Generar gráfico
twoway ///
(scatter defuncion fecha,  mcolor("$mycolor1") msize(vsmall) connect(l) lcolor("$mycolor1")) ///
(line promedio_defunciones fecha, lcolor("$mycolor2") lpattern(solid) lpattern(solid) xline(`fecha_m_1', lcolor("$mycolor1") lpattern(shortdash) lwidth(mthick)) xline(`fecha_m_2', lcolor("$mycolor1") lpattern(shortdash) lwidth(mthick)) xline(`fecha_m_3', lcolor("$mycolor1") lpattern(shortdash) lwidth(mthick))) ///
(scatter defunciones_max_1 fecha if fecha == fecha_defunciones_max_1, mlabel(defunciones_max_1) msize(vsmall) mcolor("$mycolor6") mlabcolor("$mycolor6")) ///
(scatter defunciones_max_2 fecha if fecha == fecha_defunciones_max_2, mlabel(defunciones_max_2) msize(vsmall) mcolor("$mycolor5") mlabcolor("$mycolor5")) ///
(scatter defunciones_max_3 fecha if fecha == fecha_defunciones_max_3, mlabel(defunciones_max_3) msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7")) ///
(scatter defunciones_actual fecha if fecha == fecha_defunciones_actual, mlabel(defunciones_actual) msize(vsmall) mcolor("$mycolor5") mlabcolor("$mycolor5")) ///
(line defunciones_max_1 fecha, lcolor("$mycolor6") lpattern(shortdash) lwidth(mthick)) ///
(line defunciones_min_1 fecha, lcolor("$mycolor6") lpattern(shortdash) lwidth(mthick)) ///
(line defunciones_max_2 fecha, lcolor("$mycolor5") lpattern(shortdash) lwidth(mthick)) ///
(line defunciones_min_2 fecha, lcolor("$mycolor5") lpattern(shortdash) lwidth(mthick)) ///
if fecha>=d(20mar2020) & fecha <=d($fecha) ///
, 	ylabel(0(5)33, labsize(*0.6)) ///
	tlabel(20mar2020(80)$fecha) ///
	ylabel(, nogrid) xlabel(, nogrid) ///
	xtitle("") ///
	ytitle("Promedio Móvil de Defunciones") ///
	scale (.60) ///
	graphregion(color(white)) ///
	title("Promedio de Muertes por COVID-19 Confirmados", box bexpand bcolor("$mycolor3") color(white)) ///
	text(30 21994 "{it:Acualizado al}" "{it:$fecha}", place(ne) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor2") fcolor("$mycolor2")) ///
	legend(off) name(defun_p, replace)
	
gr export "figuras\promedio_defunciones_2020_2021_2022.png", as(png) replace
*/
********************************************************************************
*GRAFICO COMBINADO PROMEDIO DE CASOS Y MUERTE COVID-19
format promedio_defunciones %12.0f
format promedio_casos %12.0f
format casos_max_1 %12.0f
format casos_max_2 %12.0f
format casos_max_3 %12.0f
format defunciones_max_1 %12.0f
format defunciones_max_2 %12.0f
format defunciones_max_3 %12.0f
format defunciones_actual %12.0f
format casos_actual %12.0f

twoway ///
(line promedio_defunciones fecha, yaxis(2) yscale(axis(2)) ylabel(0(20)100, axis(2)) lcolor("$mycolor2") lpattern(solid) lpattern(solid) xline(`fecha_m_1', lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick)) xline(`fecha_m_2', lcolor("$mycolor3") lpattern(shortdash) lwidth(mthick))) ///
(line promedio_casos fecha, lcolor("$mycolor5") lpattern(solid) lpattern(solid) xline(22426, lcolor("$mycolor5") lpattern(shortdash) lwidth(mthick)) xline(22149, lcolor("$mycolor5") lpattern(shortdash) lwidth(mthick))) ///
(scatter casos_max_1 fecha if fecha == fecha_casos_max_1, mlabel(casos_max_1) msize(vsmall) mcolor("$mycolor2") mlabcolor("$mycolor6")) ///
(scatter casos_max_2 fecha if fecha == fecha_casos_max_2, mlabel(casos_max_2) msize(vsmall) mcolor("$mycolor3") mlabcolor("$mycolor6")) ///
(scatter casos_max_3 fecha if fecha == fecha_casos_max_3, mlabel(casos_max_3) msize(vsmall) mcolor("$mycolor6") mlabcolor("$mycolor6")) ///
(scatter defunciones_max_1 fecha if fecha == fecha_defunciones_max_1, mlabel(defunciones_max_1) msize(vsmall) mcolor("$mycolor2") mlabcolor("$mycolor2") yaxis(2)) ///
(scatter defunciones_max_2 fecha if fecha == fecha_defunciones_max_2, mlabel(defunciones_max_2) msize(vsmall) mcolor("$mycolor2") mlabcolor("$mycolor2") yaxis(2)) ///
(scatter defunciones_max_3 fecha if fecha == fecha_defunciones_max_3, mlabel(defunciones_max_3) msize(vsmall) mcolor("$mycolor2") mlabcolor("$mycolor2") yaxis(2)) ///
(line casos_max_1 fecha, lcolor("$mycolor6") lpattern(shortdash) lwidth(mthick)) ///
(line casos_max_2 fecha, lcolor("$mycolor6") lpattern(shortdash) lwidth(mthick)) ///
(line casos_max_3 fecha, lcolor("$mycolor6") lpattern(shortdash) lwidth(mthick)) ///
(scatter casos_actual fecha if fecha == fecha_casos_actual, mlabel(casos_actual) msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7")) ///
(scatter defunciones_actual fecha if fecha == fecha_defunciones_actual, mlabel(defunciones_actual) msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7") yaxis(2)) ///
if fecha>=d(20mar2020) & fecha <=d($fecha) ///
	,ylabel(0(200)2500, labsize(*0.6)) ///
	tlabel(20mar2020(200)$fecha) ///
	ylabel(, nogrid) xlabel(, nogrid) ///
	xtitle("") ///
	scale(.60) ///
	graphregion(color(white)) ///
	title("Promedio de Casos y Muertes por COVID-19", box bexpand bcolor("$mycolor3") color(white)) ///
	text(1500 21994 "{it:Actualizado al}" "{it:$fecha}", place(ne) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor7") fcolor("$mycolor7")) ///
	legend(cols(4)) name(Promedio_Casos_Defuncion, replace)

gr export "figuras\promedio_casos_defuncion_2020_2021_2022.png", as(png) replace
gr export "figuras\promedio_casos_defuncion_2020_2021_2022.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_promedio_cas_def.csv", replace