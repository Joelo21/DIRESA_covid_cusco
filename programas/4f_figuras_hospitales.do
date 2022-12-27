* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).
import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("BASE-UCI") clear

*********Cambios hechos con los recortes de fecha hasta la semana 32************
* Cambiamos el formato de la variable 
format disponibilidad ocupacion ocupacion_per %12.0fc

replace ocupacion_per = 100 * ocupacion_per
replace Limite1= 100 * Limite1
replace Limite2 = 100 * Limite2 

* Generamos una variable (var1) que escale y deflacte los valores en función del valor mayor de la original (/45*100).
gen var1 = disponibilidad/45*100

* Graficamos								
twoway (bar var1 semana, yaxis(1) yscale(range(0) axis(1) off)  barwidth(0.5 0.8) bcolor("$mycolor2")) ///
(line ocupacion_per semana, lcolor("$mycolor4") sort yaxis(2) yscale(range(0) axis(2))) ///
(line Limite1 semana, lcolor("$mycolor3") lpattern(dash) sort yaxis(2) yscale(range(0) axis(2) off)) ///
(line Limite2 semana , lcolor("$mycolor2") lpattern(dash) sort yaxis(2) yscale(range(0) axis(2))) ///
(scatter disponibilidad semana, msymbol(none) mlabel(disponibilidad) mlabcolor("$mycolor6") mlabsize(*0.75) mlabposition(.3)) ///
(scatter ocupacion_per semana, msymbol(none) mlabel(ocupacion_per) mlabcolor(dark) mlabsize(*0.75) mlabposition(.3)) ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 				///
  xlabel(42(1)$semana 53 "1" 54 "2" 55 "3" 56 "4" 57 "5" 58 "6" 59 "7" 60 "8" 61 "9" 62 "10" 63 "11" 64 "12" 65 "13" 66 "14" 67 "15" 68 "16" 69 "17" 70 "18" 71 "19" 72 "20" 73 "21" 74 "22" 75 "23" 76 "24" 77 "25" 78 "26" 79 "27" 80 "28" 81 "29" 82 "30" 83 "31" 84 "32" 85 "33" 86 "34" 87 "35" 88 "36" 89 "37" 90 "38" 91 "39" 92 "40" 93 "41" 94 "42" 95 "43" 96 "44" 97 "45" 98 "46" 99 "47" 100 "48" 101 "49" 102 "50" 103 "51", labsize(*0.40)) ///
  graphregion(color(white)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "Ocupación (%)") label(5 "Límte 1: 75%") 	label(6 "Límite 2: 90%") label(2 "") label(3 "") size(*0.6) order(1 4 5 6) region(lcolor("$mycolor2"))  region(col(white))) ///
  bgcolor(white) ylabel(, nogrid)  name(uci, replace)

graph export "figuras\uci.png", as(png) replace	
graph export "figuras\uci.pdf", as(pdf) replace
	
export delimited using "${datos}\output\dashboard_uci.csv", replace

* HOSPITALIZACIÓN PARA NIVEL III
*-----------------------------------------------------

* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).

import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("BASE-3") clear
* Cambiamos el formato de la variable disponibilidad, de tal forma que se redondeen los valores.

format disponibilidad %12.0fc

replace ocupacion_per = 100 * ocupacion_per
replace Limite1 = 100 * Limite1
replace Limite2 = 100 * Limite2 

* Cambiamos el formato de la variable ocupacion_per, de tal forma que se redondeen los valores.
format ocupacion_per %12.0fc

* Generamos una variable (var1) que escale y deflacte los valores en función del valor mayor de la original (/417*100).

gen var2 = disponibilidad/417*100

* Graficamos
									
twoway (bar disponibilidad semana, yaxis(1) yscale(range(0) axis(1) off)  barwidth(0.5 0.8) bcolor("$mycolor6")) ///
(line ocupacion_per semana, lcolor("$mycolor4") sort yaxis(2) yscale(range(0) axis(2) off)) ///
(line Limite1 semana, lcolor("$mycolor3") lpattern(dash) sort yaxis(2) yscale(range(0) axis(2) off)) ///
(line Limite2 semana , lcolor("$mycolor2") lpattern(dash) sort yaxis(2) yscale(range(0) axis(2) off)) ///
(scatter disponibilidad semana, msymbol(none) mlabel(disponibilidad) mlabcolor("$mycolor4") mlabsize(*0.75) mlabposition(.3))				///
(scatter ocupacion_per semana, msymbol(none) mlabel(ocupacion_per) mlabcolor("$mycolor3") mlabsize(*0.75) mlabposition(0.3) sort yaxis(2) yscale(range(0) axis(2) off)) ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 				///
  xlabel(42(1)$semana 53 "1" 54 "2" 55 "3" 56 "4" 57 "5" 58 "6" 59 "7" 60 "8" 61 "9" 62 "10" 63 "11" 64 "12" 65 "13" 66 "14" 67 "15" 68 "16" 69 "17" 70 "18" 71 "19" 72 "20" 73 "21" 74 "22" 75 "23" 76 "24" 77 "25" 78 "26" 79 "27" 80 "28" 81 "29" 82 "30" 83 "31" 84 "32" 85 "33" 86 "34" 87 "35" 88 "36" 89 "37" 90 "38" 91 "39" 92 "40" 93 "41" 95 "43" 96 "44" 97 "45" 98 "46" 99 "47" 100 "48" 101 "49" 102 "50" 103 "51", labsize(*0.40)) /// 
  graphregion(color(white)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "Límite 1: 75%") label(5 "Límite 2: 90%") label(6 "") label(2 "") label(3 "Ocupación (%)") size(*0.6) order(1 4 5 3) region(lcolor("$mycolor2"))  region(col(white))) ///
  bgcolor(white) ylabel(, nogrid) name(nivel_3, replace)

graph export "figuras\nivel_3.png", as(png) replace	
graph export "figuras\nivel_3.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_nivel_3.csv", replace
* HOSPITALIZACIÓN PARA NIVEL II
*-----------------------------------------------------

* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).

import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("BASE-2") clear
* Cambiamos el formato de la variable disponibilidad, de tal forma que se redondeen los valores.

format disponibilidad %12.0fc

replace ocupacion_per = 100 * ocupacion_per
replace Limite1= 100 * Limite1
replace Limite2 = 100 * Limite2 

* Cambiamos el formato de la variable ocupacion_per, de tal forma que se redondeen los valores.

format ocupacion_per %12.0fc

* Generamos una variable (var1) que escale y deflacte los valores en función del valor mayor de la original (/1753*100).

gen var3 = disponibilidad/1753*100

* Graficamos
									
twoway (bar disponibilidad semana, yaxis(1) yscale(range(0) axis(1) off)  barwidth(0.5 0.8) bcolor("$mycolor3")) ///
(line ocupacion_per semana, lcolor("$mycolor7") sort yaxis(2) yscale(range(0) axis(2) off)) ///
(line Limite1 semana, lcolor("$mycolor3") lpattern(dash) sort yaxis(2) yscale(range(0) axis(2) off)) ///
(line Limite2 semana , lcolor("$mycolor2") lpattern(dash) sort yaxis(2) yscale(range(0) axis(2) off)) ///
(scatter disponibilidad semana, msymbol(none) mlabel(disponibilidad) mlabcolor("$mycolor7") mlabsize(*0.75) mlabposition(.3))				///
(scatter ocupacion_per semana, msymbol(none) mlabel(ocupacion_per) mlabcolor(black) mlabsize(*0.75) mlabposition(.3) sort yaxis(2) yscale(range(0) axis(2) off)) ///
if semana>=42 & semana <=$semana								///
  ,xtitle("Semanas Epidemiológicas", size(*0.7) color("`r(p1)'")) 				///
  ylabel(0(100)400, labsize(*0.6)) ///
  xlabel(42(1)$semana 53 "1" 54 "2" 55 "3" 56 "4" 57 "5" 58 "6" 59 "7" 60 "8" 61 "9" 62 "10" 63 "11" 64 "12" 65 "13" 66 "14" 67 "15" 68 "16" 69 "17" 70 "18" 71 "19" 72 "20" 73 "21" 74 "22" 75 "23" 76 "24" 77 "25" 78 "26" 79 "27" 80 "28" 81 "29" 82 "30" 83 "31" 84 "32" 85 "33" 86 "34" 87 "35" 88 "36" 89 "37" 90 "38" 91 "39" 92 "40" 93 "41" 94 "42" 95 "43" 96 "44" 97 "45" 98 "46" 99 "47" 100 "48" 101 "49" 102 "50" 103 "51", labsize(*0.40)) ///
  graphregion(color(white)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "Límte 1: 75%") label(5 "Límte 2: 90%") label(6 "") label(2 "") label(3 "Ocupación (%)") size(*0.7) order(1 4 5 3) region(lcolor(black))  region(col(white))) ///
  bgcolor(white) ylabel(, nogrid)  name(nivel_2, replace)
	  
graph export "figuras\nivel_2.png", as(png) replace
graph export "figuras\nivel_2.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_nivel_2.csv", replace
********************************************************************************
* Por Hospital
********************************************************************************
import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("H-REGIONAL") clear
 
 * UCI
*************************

format libres_uci %12.0fc
format ocupacion_uci %12.0fc

collapse (sum) ocupacion_uci libres_uci, by(semana)
gen bar2 = ocupacion_uci + libres_uci

format bar2 %12.0fc

* Definimos nuestra paleta
generate ocu2 = ocupacion_uci/2
format ocu2  %12.0fc

* Graficamos
  
twoway bar ocupacion_uci semana, bcolor("$mycolor7") yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5) || ///
rbar ocupacion_uci bar2 semana,  bcolor("$mycolor3") barwidth(0.5)  || ///
scatter bar2 semana, ms(none) mla(bar2) mlabpos(12) mlabcolor("$mycolor3") mlabsize(*0.65)|| ///
scatter ocu2 semana, ms(none) mla(ocupacion_uci) mlabpos(12) mlabcolor(black) mlabsize(*0.65) || ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 			///
  xlabel(42(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.55)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "") label(2 " Camas disponibles") label(3 "") size(*0.6) order(1 2 3 4) region(lcolor("$mycolor7"))) ///
  graphregion(color(white)) ///
  title("UCI", size(*.5) position(9) box bcolor("$mycolor7") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) name(h_regional_uci, replace)   ///
 
graph export "figuras\h_regional_uci.png", as(png) replace
graph export "figuras\h_regional_uci.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_h_regional_uci.csv", replace
* NO UCI
*************************
import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("H-REGIONAL") clear

 * UCI
format libres_nouci %12.0fc
format ocupacion_nouci %12.0fc

collapse (sum) ocupacion_nouci libres_nouci, by(semana)
gen bar3 = ocupacion_nouci + libres_nouci

format bar3 %12.0fc

* Definimos nuestra paleta
generate ocu3 = ocupacion_nouci/2
format ocu3  %12.0fc

* Graficamos
twoway bar ocupacion_nouci semana, bcolor("$mycolor3") yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5) || ///
rbar ocupacion_nouci bar3 semana,  bcolor("$mycolor7") barwidth(0.5)  || ///
scatter bar3 semana, ms(none) mla(bar3) mlabpos(12) mlabcolor("$mycolor7") mlabsize(*0.55)|| ///
scatter ocu3 semana, ms(none) mla(ocupacion_nouci) mlabpos(12) mlabcolor(black) mlabsize(*0.55)|| ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 			///
  xlabel(42(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.55)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "") label(2 " Camas disponibles") label(3 "") size(*0.6) order(1 2 3 4) region(lcolor(black))) ///
  graphregion(color(white)) ///
  title("NO UCI", size(*.35) position(9) box bcolor("$mycolor3") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) name(h_regional_nouci, replace) ///
  
* Combinamos las gráficas
/*
graph combine uci1 uci2, graphregion(color(white)) name(h_regional, replace)
graph combine h_regional_uci h_regional_nouci, graphregion(color(white)) name(h_regional, replace)
graph export "figuras\h_regional.png", as(png) replace
graph export "figuras\h_regional.pdf", as(pdf) replace
*/
  
graph export "figuras\h_regional_nouci.png", as(png) replace
graph export "figuras\h_regional_nouci.pdf", as(pdf) replace


export delimited using "${datos}\output\dashboard_h_regional_nouci.csv", replace

********************************************************************************
import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("H-LORENA") clear

format libres_uci %12.0fc
format ocupacion_uci %12.0fc

collapse (sum) ocupacion_uci libres_uci, by(semana)
gen bar2 = ocupacion_uci + libres_uci

format bar2 %12.0fc

* Definimos nuestra paleta
generate ocu2 = ocupacion_uci/2
format ocu2  %12.0fc

* Graficamos
  
twoway bar ocupacion_uci semana, bcolor("$mycolor6") yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5) || ///
rbar ocupacion_uci bar2 semana,  bcolor("$mycolor7") barwidth(0.5)  || ///
scatter bar2 semana, ms(none) mla(bar2) mlabpos(12) mlabcolor("$mycolor3") mlabsize(*0.65)|| ///
scatter ocu2 semana, ms(none) mla(ocupacion_uci) mlabpos(12) mlabcolor("$mycolor3") mlabsize(*0.65) || ///
if semana>=42 & semana <=$semana ///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 			///
  xlabel(42(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.55)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "") label(2 " Camas disponibles") label(3 "") size(*0.6) order(1 2 3 4) region(lcolor(black))) ///
  graphregion(color(white)) ///
  title("UCI", size(*.5) position(9) box bcolor("$mycolor6") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) name(h_lorena_uci, replace) ///
/* 
  graph export "figuras\h_lorena_uci.png", as(png) replace
  graph export "figuras\h_lorena_uci.pdf", as(pdf) replace
*/
 
graph export "figuras\h_lorena_uci.png", as(png) replace
graph export "figuras\h_lorena_uci.pdf", as(pdf) replace


export delimited using "${datos}\output\dashboard_h_lorena_uci.csv", replace
* NO UCI
*************************
import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("H-LORENA") clear

format libres_nouci %12.0fc
format ocupacion_nouci %12.0fc

collapse (sum) ocupacion_nouci libres_nouci, by(semana)
gen bar3 = ocupacion_nouci + libres_nouci

format bar3 %12.0fc

* Definimos nuestra paleta
generate ocu3 = ocupacion_nouci/2
format ocu3  %12.0fc

* Graficamos
  
twoway bar ocupacion_nouci semana, bcolor("$mycolor6") yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5) || ///
rbar ocupacion_nouci bar3 semana,  bcolor("$mycolor7") barwidth(0.5)  || ///
scatter bar3 semana, ms(none) mla(bar3) mlabpos(12) mlabcolor("$mycolor3") mlabsize(*0.6)|| ///
scatter ocu3 semana, ms(none) mla(ocupacion_nouci) mlabpos(12) mlabcolor(black) mlabsize(*0.6)|| ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 			///
  xlabel(42(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.55)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "") label(2 " Camas disponibles") label(3 "") size(*0.6) order(1 2 3 4) region(lcolor(black))) ///
  graphregion(color(white)) ///
  title("NO UCI", size(*.35) position(9) box bcolor("$mycolor5") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) name(h_lorena_nouci, replace)  ///
  
/* 
* Combinamos las gráficas
*graph combine uci1 uci2, graphregion(color(white)) name(h_lorena, replace)
graph export "figuras\h_lorena_nouci.png", as(png) replace
graph export "figuras\h_lorena_nouci.pdf", as(pdf) replace
graph combine h_lorena_uci h_lorena_nouci, graphregion(color(white)) name(h_lorena, replace)
graph export "figuras\h_lorena.png", as(png) replace
graph export "figuras\h_lorena.pdf", as(pdf) replace
*/

graph export "figuras\h_lorena_nouci.png", as(png) replace
graph export "figuras\h_lorena_nouci.pdf", as(pdf) replace

export delimited using "${datos}\output\dashboard_h_lorena_nouci.csv", replace
********************************************************************************

import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("H-ADOLFO") clear

format libres_uci %12.0fc
format ocupacion_uci %12.0fc

collapse (sum) ocupacion_uci libres_uci, by(semana)
gen bar2 = ocupacion_uci + libres_uci

format bar2 %12.0fc

* Definimos nuestra paleta
generate ocu2 = ocupacion_uci/2
format ocu2  %12.0fc

* Graficamos
  
twoway bar ocupacion_uci semana, bcolor("$mycolor4") yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5) || ///
rbar ocupacion_uci bar2 semana,  bcolor("$mycolor2") barwidth(0.5)  || ///
scatter bar2 semana, ms(none) mla(bar2) mlabpos(12) mlabcolor("$mycolor2") mlabsize(*0.65)|| ///
scatter ocu2 semana, ms(none) mla(ocupacion_uci) mlabpos(12) mlabcolor(black) mlabsize(*0.65) || ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 			///
  xlabel(42(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.55)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "") label(2 " Camas disponibles") label(3 "") size(*0.6) order(1 2 3 4) region(lcolor(black))) ///
  graphregion(color(white)) ///
  title("UCI", size(*.5) position(9) box bcolor("$mycolor4") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) name(h_adolfo_uci, replace) ///
  
graph export "figuras\h_adolfo_uci.png", as(png) replace
graph export "figuras\h_adolfo_uci.pdf", as(pdf) replace

 
export delimited using "${datos}\output\dashboard_h_adolfo_uci.csv", replace
* NO UCI
*************************
import excel "${datos}\raw\base_sistema_referencias.xlsx", firstrow sheet("H-ADOLFO") clear

format libres_nouci %12.0fc
format ocupacion_nouci %12.0fc
**#

collapse (sum) ocupacion_nouci libres_nouci, by(semana)
gen bar3 = ocupacion_nouci + libres_nouci

format bar3 %12.0fc

* Definimos nuestra paleta
generate ocu3 = ocupacion_nouci/2
format ocu3  %12.0fc

* Graficamos
twoway bar ocupacion_nouci semana, bcolor("$mycolor2") yaxis(1) yscale(range(0) axis(1) off) barwidth(0.5) || ///
rbar ocupacion_nouci bar3 semana,  bcolor("$mycolor4") barwidth(0.5)  || ///
scatter bar3 semana, ms(none) mla(bar3) mlabpos(12) mlabcolor("$mycolor4") mlabsize(*0.6)|| ///
scatter ocu3 semana, ms(none) mla(ocupacion_nouci) mlabpos(12) mlabcolor(black) mlabsize(*0.6)|| ///
if semana>=42 & semana <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.7)) 			///
  xlabel(42(2)$semana 54 "2" 56 "4" 58 "6" 60 "8" 62 "10" 64 "12" 66 "14" 68 "16" 70 "18" 72 "20" 74 "22" 76 "24" 78 "26" 80 "28" 82 "30" 84 "32" 86 "34" 88 "36" 90 "38" 92 "40" 94 "42" 96 "44" 98 "46" 100 "48" 102 "50", labsize(*0.55)) ///
  legend(cols(4) label(1 "Total de camas") label (4 "") label(2 " Camas disponibles") label(3 "") size(*0.6) order(1 2 3 4) region(lcolor(black))) ///
  graphregion(color(white)) ///
  title("NO UCI", size(*.35) position(9) box bcolor("$mycolor2") color(white)) ///  
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) name(h_adolfo_nouci, replace)  ///
  
 /* 
* Combinamos las gráficas
* Graficamos
graph combine h_adolfo_uci h_adolfo_nouci, graphregion(color(white)) name(h_alfonso, replace)
graph export "figuras\h_alfonso.png", as(png) replace
graph export "figuras\h_alfonso.pdf", as(pdf) replace
*/
graph export "figuras\h_adolfo_nouci.pdf", as(pdf) replace
graph export "figuras\h_adolfo_nouci.png", as(png) replace

export delimited using "${datos}\output\dashboard_h_adolfo_nouci.csv", replace