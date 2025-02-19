	
use "${datos}\output\serie_semanal_region.dta", clear

********************************************************************************
* Defunciones Semanales por COVID-19
********************************************************************************

* 2020 2021
twoway (line defuncion semana, lcolor("$mycolor2") lwidth(medthick)) ///
(scatter defuncion semana, msize(vsmall) mcolor("$mycolor2") mlabel(defuncion) mlabcolor("$mycolor3") mlabsize(tiny) connect() xline(54, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana >=11 & semana<=105, ///
	ylabel(0(50)200, labsize(*0.6)) ///
	tlabel(1(4)105 57 "4" 61 "8" 65 "12" 69 "16" 73 "20" 77 "24" 81 "29" 85 "33" 89 "37" 93 "41" 97 "45" 101 "49" 105 "53", labsize (*0.5)) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Defunciones") ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2020 - 2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(defunciones_20, replace)
 
* 2022
twoway (line defuncion semana_3, lcolor("$mycolor2") lwidth(medthick)) ///
(scatter defuncion semana_3, msize(vsmall) mcolor("$mycolor2") mlabel(defuncion) mlabcolor("$mycolor3") mlabsize(tiny) connect() xline(1, lcolor("$mycolor5") lpattern(shortdash) lwidth(thick))) ///
 if semana_2 >=53 & semana_2<=$semana, ///
	ylabel(0(50)200, labsize(*0.6)) ///
	tlabel(1(4)52, labsize(*0.5)) ///
	ytitle("") ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2022", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(defunciones_21_22, replace)

*Conbine
graph combine defunciones_20 defunciones_21_22, ///
graphregion(color(white)) ///
name(defunciones_semanales_20_21_22, replace)

gr export "figuras\defunciones_semanales_20_21_22.png", as(png) replace
gr export "figuras\defunciones_semanales_20_21_22.pdf", as(pdf) name("defunciones_semanales_20_21_22") replace


********************************************************************************
* Tasas de Crecimiento Semanal 2021
********************************************************************************

*2021
twoway (line defuncion_d semana_2, lcolor("$mycolor6") lwidth(medthick) lpattern(longdash)) ///
(scatter defuncion_d semana_2, msize(vsmall) mcolor("$mycolor6") mlabel(defuncion_d) mlabcolor("$mycolor2") mlabsize(tiny) connect() xline(1, lcolor("$mycolor1") lpattern(shortdash) lwidth(thick)) xline(13, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) xline(15, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
 if semana_2 >=1 & semana_2<=$semana, ///
	ylabel(-500(100)200, labsize(*0.6)) ///
	tlabel(1(4)$semana 53 "1" 57 "5" 61 "9" 65 "13" 69 "17" 73 "21" 77 "25" 81 "29" 85 "33" 89 "37" 93 "41" 97 "45" 101 "49") ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("% Crecimiento de Defunciones") ///
	graphregion(color(white)) ///
	title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	legend(off) ///
	name(defunciones_tasa_21_22, replace)

gr export "figuras\defunciones_tasa_crecimiento_21_22.png", as(png) replace
gr export "figuras\defunciones_tasa_crecimiento_21_22.pdf", as(pdf) name("defunciones_tasa_21_22") replace


********************************************************************************
* Tasa de Crecimiento Total de Casos por Semana
********************************************************************************

*2021
twoway (line positivo_d semana_2, lcolor("$mycolor6") lwidth(medthick) lpattern(longdash)) ///
(scatter positivo_d semana_2, msize(vsmall) mcolor("$mycolor6") mlabel(positivo_d) mlabcolor("$mycolor6") mlabsize(tiny) connect() xline(1, lcolor("$mycolor1") lpattern(shortdash) lwidth(thick)) xline(13, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) xline(15, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(53, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
 if semana_2 >=1 & semana_2<=$semana, ///
	ylabel(-300(50)100, labsize(*0.6)) ///
	tlabel(1(4)$semana 53 "1" 57 "5" 61 "9" 65 "13" 69 "17" 73 "21" 77 "25" 81 "29" 85 "33" 89 "37" 93 "41" 97 "45" 101 "49" 105 "53") ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("% Crecimiento de Casos") ///
	graphregion(color(white)) ///
	title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(off) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positivos_2020_21_22, replace)

gr export "figuras\positivos_crecimiento_2021_2022.png", as(png) replace
gr export "figuras\positivos_crecimiento_2021_2022.pdf", as(pdf) name("positivos_2020_21_22") replace


********************************************************************************
* Curva Total de Casos Positivos Semanales ::  +PR
********************************************************************************

* 2020
twoway (line positivo semana, lcolor("$mycolor6") lwidth(medthick)) ///
(scatter positivo semana, msize(vsmall) mcolor("$mycolor6") mlabel(positivo) mlabcolor("$mycolor6") mlabsize(tiny) connect() xline(54, lcolor("$mycolor7") lpattern(shortdash) lwidth(thick))) ///
if semana >=11 & semana<=105, ///
	ylabel(0(2000)16000, labsize(*0.6)) ///
	tlabel(1(4)105 57 "4" 61 "8" 65 "12" 69 "16" 73 "20" 77 "24" 81 "29" 85 "33" 89 "37" 93 "41" 97 "45" 101 "49" 105 "53", labsize(*0.5)) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Casos") ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2020 - 2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positivos_semanales_2020, replace)

* 2021
twoway (line positivo semana_3, lcolor("$mycolor6") lwidth(medthick)) ///
(scatter positivo semana_3, msize(vsmall) mcolor("$mycolor6") mlabel(positivo) mlabcolor("$mycolor6") mlabsize(tiny) connect() xline(1, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick))) ///
if semana_2 >=53 & semana_2<=$semana, ///
	ylabel(0(2000)16000, labsize(*0.6)) ///
	tlabel(1(4)52, labsize(*0.5)) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("") ///
	graphregion(color(white)) ///
	legend(off)  ///
	title("2022", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positivos_semanales_2021_2022, replace)


* 2020 y 2021
graph combine positivos_semanales_2020 positivos_semanales_2021_2022, ///
graphregion(color(white)) ///
name(positivos_semanales_2021_2022	, replace)

gr export "figuras\positivos_semanales_20_21_22.png", as(png) replace
gr export "figuras\positivos_semanales_20_21_22.pdf", as(pdf) name("positivos_semanales_2021_2022") replace

********************************************************************************
* Curva de Sintomaticos y Asintomaticos Semanales : +PR
********************************************************************************

* 2020
twoway (line sintomatico semana, lcolor("$mycolor4") lwidth(medthick) lpattern(dot)) ///
(scatter sintomatico semana, msymbol(Th) msize(vsmall) mcolor("$mycolor4") mlabcolor("$mycolor2") mlabsize(tiny) connect() xline(54, lcolor("$mycolor16") lpattern(shortdash) lwidth(thick))) ///
(line asintomatico semana, lcolor("$mycolor7") lwidth(medthick) lpattern(dot)) ///
(scatter asintomatico semana, msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7") mlabsize(tiny)  msymbol(Sh) connect()) ///
if semana >=11 & semana<=105, ///
	ylabel(0(2000)10000, labsize(*0.6)) ///
	tlabel(1(4)105 57 "4" 61 "8" 65 "12" 69 "16" 73 "20" 77 "24" 81 "29" 85 "33" 89 "37" 93 "41" 97 "45" 101 "49" 105 "53", labsize (*0.5)) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Casos") ///
	graphregion(color(white)) ///
	legend(label(1 "Sintomáticos") label(2 "Sintomáticos") label(3 "Asintomáticos") label(4 "Asintomaticos") size(*0.75) region(col(white)))   ///
	title("2020 - 2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sintomaticos_2020, replace)

* 2021
twoway (line sintomatico semana_3, lcolor("$mycolor4") lwidth(medthick) lpattern(dot)) ///
(scatter sintomatico semana_3, msymbol(Th) msize(vsmall) mcolor("$mycolor4") mlabcolor("$mycolor4") mlabsize(tiny) connect() xline(1, lcolor("$mycolor11") lpattern(shortdash) lwidth(thick))) ///
(line asintomatico semana_3, lcolor("$mycolor7") lwidth(medthick) lpattern(dot)) ///
(scatter asintomatico semana_3, msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7") mlabsize(tiny) msymbol(Sh) connect()) ///
if semana_2 >=53 & semana_2 <=$semana, ///
	ylabel(0(2000)10000, labsize(*0.6)) ///
	tlabel(1(4)52, labsize (*0.5)) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("") ///
	graphregion(color(white)) ///
	legend(label(1 "Sintomáticos") label(2 "Sintomáticos") label(3 "Asintomáticos") label(4 "Asintomaticos") size(*0.75) region(col(white)))   ///
	title("2022", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sintomaticos_2021, replace)


* 2020 y 2021
graph combine sintomaticos_2020 sintomaticos_2021, ///
graphregion(color(white)) ///
name(sintomaticos_20_21_22, replace)

gr export "figuras\sintomaticos_20_21_22.png", as(png) replace
gr export "figuras\sintomaticos_20_21_22.pdf", as(pdf) name("sintomaticos_20_21_22") replace


********************************************************************************
* Curva Epidemica de Sintomaticos por tipo de prueba  +PR
********************************************************************************

* 2020
twoway (scatter sintomatico_pcr semana, msize(vsmall) mcolor("$mycolor5") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor5")) ///
(scatter sintomatico_pr_sis semana, msize(vsmall) mcolor("$mycolor6") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor1")) ///
(scatter sintomatico_ag semana, msize(vsmall) mcolor("$mycolor3") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor3") ) ///
if semana>=1 & semana<=105, ///
	ylabel(0(200)2000, labsize(*0.6)) ///
	tlabel(1(4)105 57 "4" 61 "8" 65 "12" 69 "16" 73 "20" 77 "24" 81 "29" 85 "33" 89 "37" 93 "41" 97 "45" 101 "49" 105 "53", labsize (*0.5)) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Casos sintomáticos", margin(0 4 0 0)) ///
	graphregion(color(white)) ///
	title("2020 - 2021", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "Sintomáticos PCR") label(2 "Sintomáticos PR") label(3 "Sintomaticos AG") size(*0.75) region(col(white))) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sinto_prueba_2020, replace)

* 2021  
twoway (scatter sintomatico_pcr semana_3, msize(vsmall) mcolor("$mycolor5") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor5")) ///
(scatter sintomatico_pr_sis semana_3, msize(vsmall) mcolor("$mycolor6") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor1")) ///
(scatter sintomatico_ag semana_3, msize(vsmall) mcolor("$mycolor3") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor3") ) ///
if semana_2>=53 & semana_2<=$semana, ///
	ylabel(0(1000)10000, labsize(*0.6)) ///
	tlabel(1(4)52) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("") ///
	graphregion(color(white)) ///
	title("2022", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "Sintomáticos PCR") label(2 "Sintomáticos PR") label(3 "Sintomaticos AG") size(*0.75) region(col(white))) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sinto_prueba_2021, replace)

* 2020 y 2021
graph combine sinto_prueba_2020 sinto_prueba_2021, ///
graphregion(color(white)) ///
name(sinto_prueba_20_21_22, replace)

gr export "figuras\sinto_prueba_20_21_22.png", as(png) replace
gr export "figuras\sinto_prueba_20_21_22.pdf", as(pdf) name("sinto_prueba_20_21_22") replace

********************************************************************************
* Tasa de Positividad Semanal por Tipo de Prueba PCR y AG: 2021 - 2022
********************************************************************************

* PCR
twoway (bar positivo_pcr semana_2, yaxis(1) ylabel(0(600)600) yscale(range(0(600)600) axis(1) off) bcolor("$mycolor5") /*bfcolor(white) blcolor(black)*/ /*fintensity(inten60)*/  barwidth(0.5 0.8)) ///
(line positividad_pcr semana_2, lcolor(black) sort yaxis(2) ylabel(0(10)100, axis(2))) ///
(scatter positivo_pcr semana_2, msymbol(none) mlabel() mlabcolor("$mycolor5") mlabsize(*0.65) mlabposition(12))	/// 
(scatter positividad_pcr semana_2, msymbol(i) mlabel(positividad_pcr) mlabcolor("$mycolor2") mlabsize(*0.65) mlabposition(12)	sort yaxis(2) yscale(range(0) axis(2) off)) ///
if semana_2>=49 & semana_2 <=$semana ///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  xlabel(49(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
  graphregion(color(white)) ///
  legend(cols(1) label(1 "Positivos en pruebas moleculares") label(2 " ") label(3 "Tasa de positividad en pruebas moleculares (%)") label (4 " ") size(*0.8) order(1 3) region(lcolor("$mycolor6"))) ///
  title("Pruebas Moleculares", size(*.7) box bcolor("$mycolor6") color(white)) ///
  bgcolor(white) ylabel(, nogrid) ///
  name(pcr, replace)

graph export "figuras\positividad_pcr.pdf", as(pdf) replace

* AG
twoway (bar positivo_ag semana_2, yaxis(1) ylabel(0(600)2200) yscale(range(0(600)2200) axis(1) off) bcolor("$mycolor3") /*bfcolor(white) blcolor(black)*/ /*fintensity(inten60)*/  barwidth(0.5 0.8)) ///
(line positividad_ag semana_2, lcolor(black) sort yaxis(2) ylabel(0(10)100, axis(2))) ///
(scatter positivo_ag semana_2, msymbol(none) mlabel() mlabcolor("$mycolor4") mlabsize(*0.65) mlabposition(12)) ///
(scatter positividad_ag semana_2, msymbol(i) mlabel(positividad_ag) mlabcolor("$mycolor7") mlabsize(*0.65) mlabposition(12)	sort yaxis(2) yscale(range(0) axis(2) off)) ///
if semana_2>=49 & semana_2 <=$semana ///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  xlabel(49(2)$semana 53 "1" 55 "3" 57 "5" 59 "7" 61 "9" 63 "11" 65 "13" 67 "15" 69 "17" 71 "19" 73 "21" 75 "23" 77 "25" 79 "27" 81 "29" 83 "31" 85 "33" 87 "35" 89 "37" 91 "39" 93 "41" 95 "43" 97 "45" 99 "47" 101 "49" 103 "51", labsize(*0.6)) ///
  graphregion(color(white)) ///
  legend(cols(1) label(1 "Positivos en pruebas antigénicas") label(2 " ") label(3 "Tasa de positividad en pruebas antigénicas (%)") label (4 " ") size(*0.8) order(1 3) region(lcolor("$mycolor4"))) ///
  title("Pruebas Antigénicas", size(*.7) box bcolor("$mycolor3") color(white)) ///
  bgcolor(white) ylabel(, nogrid) ///
  name(ag, replace)

graph export "figuras\positividad_ag.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_sintomaticos_20_21_22.csv", replace