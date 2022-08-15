* Cargar los datos 
use "${datos}\output\defunciones_totales_2020_2021.dta", clear

merge 1:1 semana using "${datos}\output\defunciones_totales_region_2019.dta", nogen

* Importante: No graficar la SE53 del 2019 porque no la tuvo
/*
* 2020
* Graficamos
twoway (line de_19 semana, lcolor("$mycolor3")) ///
(line de_20 semana, lcolor("$mycolor2")) ///
if semana>=1 & semana <=53 ///
  ,xtitle("Semanas Epidemológicas", size(*0.9)) ///
   ytitle("Número de Defunciones por Toda Causa", size(*0.8)) 				///
  xlabel(1(4)53, labsize(*0.8)) ///
  graphregion(color(white)) ///
  name(de20, replace) ///
  legend(label(1 "2019") label(2 "2020") size(*0.8) region(col(white))) ///
  title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid)

* 2021
*drop if semana > $semana
gen exceso = de_21 - de_19
sum exceso if semana == $semana
local exceso_actual = r(mean)

* Graficamos
twoway (line de_19 semana, yaxis(1) yscale(range(0) axis(1)) lcolor("$mycolor3")) ///
(line de_21 semana, yaxis(1) yscale(range(0) axis(1)) lcolor("$mycolor2")) ///
if semana>=1 & semana <=$semana ///
  ,xtitle("Semanas Epidemológicas", size(*0.9)) ///
   ytitle("Número de Defunciones por Toda Causa", size(*0.8)) 				///
  xlabel(1(4)$semana, labsize(*0.8)) ///
  ylabel(0(100)400, labsize(*0.8)) ///
  graphregion(color(white)) ///
  legend(label(1 "2019") label(2 "2021 - 2022") size(*0.8) region(col(white))) ///
name(de21, replace) ///
title("2021 - 2022", box bexpand bcolor("$mycolor3") color(white)) ///
bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) ///
text(180 $semana "{it:Exceso:`exceso_actual'}", place(n) box just(left) margin(l+2 t+1 b+1) width(20) size(small) color(white) bcolor("$mycolor2") fcolor("$mycolor2"))
*/

*gr export "figuras\exceso_region_21_22.png", as(png) replace
*gr export "figuras\exceso_region_21_22.pdf", as(pdf) replace

********************************************************************************
* Exceso de Defunciones por todas las Causas  2022
********************************************************************************
* 2022
drop if semana > $semana
gen exceso = de_22 - de_19

*Aqui cambia el # por cada semana#"
sum exceso if semana == 31
local exceso_actual_2 = r(mean)

* Graficamos
twoway (line de_19 semana, yaxis(1) yscale(range(0) axis(1)) lcolor("$mycolor3")) ///
(line de_22 semana, yaxis(1) yscale(range(0) axis(1)) lcolor("$mycolor2")) ///
if semana>=1 & semana <=52 ///
  ,xtitle("Semanas Epidemológicas", size(*0.9)) ///
   ytitle("Número de Defunciones por Toda Causa", size(*0.8)) 				///
  xlabel(1(4)53, labsize(*0.8)) ///
  ylabel(0(100)400, labsize(*0.8)) ///
  graphregion(color(white)) ///
  legend(label(1 "2019") label(2 "2022") size(*0.8) region(col(white))) ///
name(de22, replace) ///
title("2022", box bexpand bcolor("$mycolor3") color(white)) ///
bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) ///
text(180 49 "{it:Exceso:`exceso_actual_2'}", place(n) box just(left) margin(l+2 t+1 b+1) width(20) size(small) color(white) bcolor("$mycolor2") fcolor("$mycolor2"))

gr export "figuras\exceso_region_2022.png", as(png) replace
gr export "figuras\exceso_region_2022.pdf", as(pdf) replace


/*
* Combinamos los gráficos
graph combine de20 de21, ///
graphregion(color(white)) /// 
name(exceso_region, replace)


* Guardamos en el formato requerido
gr export "figuras\exceso_region.png", as(png) replace
gr export "figuras\exceso_region.pdf", as(pdf) name(exceso_region) replace
*/

save "${datos}\output\dashboard_exc_def.dta", replace