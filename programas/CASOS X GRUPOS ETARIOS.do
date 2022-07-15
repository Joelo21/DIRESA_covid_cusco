use "${datos}/output/base_covid.dta", clear
* Mantener sólo los datos del 2021 - 2022
drop if fecha_resultado < d(29may2022)

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <=11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 59
replace grupo_edad = 5 if edad >= 60 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "Niños" 2 "Adolescentes" 3 "Jovenes" 4 "Adultos" 5 "Adulto Mayor" 
label values grupo_edad grupo_edad

tab defuncion
tab positivo

gen semana = .
replace semana = 22 if fecha_resultado > d(28may2022) & fecha_resultado <= d(04jun2022)
replace semana = 23 if fecha_resultado > d(04jun2022) & fecha_resultado <= d(11jun2022)
replace semana = 24 if fecha_resultado > d(11jun2022) & fecha_resultado <= d(18jun2022)
replace semana = 25 if fecha_resultado > d(18jun2022) & fecha_resultado <= d(25jun2022)
replace semana = 26 if fecha_resultado > d(25jun2022) & fecha_resultado <= d(02jul2022)
replace semana = 27 if fecha_resultado > d(02jul2022) & fecha_resultado <= d(09jul2022)
replace semana = 28 if fecha_resultado > d(09jul2022) & fecha_resultado <= d(16jul2022)
*replace semana = semana[_n-7] + 1 if fecha_resultado > d(16jul2022)

sort fecha_resultado

keep positivo fecha_resultado defuncion grupo_edad semana

graph bar (count) if defuncion == 1, ysize(5) xsize(6.1) ///
over(semana) ascategory asyvar bar(1, color("$mycolor1")) bar(2, color("$mycolor11")) bar(3, color("$mycolor10")) bar(4, color("$mycolor9")) bar(5, color("$mycolor8")) bar(6, color("$mycolor4")) bar(7, color("$mycolor12")) ///
over(grupo_edad) blabel(total) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(outside) color(black) format(%4.1f)) ///
blabel(total) ///
blabel(bar, size(vsmall) format(%11.0gc)) ///
ytitle("Defunciones por COVID") ///
ylabel(0(2)10, nogrid) ///
legend(cols(3) label(1 "Semana 22") label(2 "Semana 23") label(3 "Semana 24") label(4 "Semana 25") label(5 "Semana 26") label(6 "Semana 27") label(7 "Semana 28") size(*0.8) region(col(white))) name(def_GE, replace) 

graph bar (count) if positivo == 1, ysize(5) xsize(6.1) ///
over(semana) ascategory asyvar bar(1, color("$mycolor1")) bar(2, color("$mycolor11")) bar(3, color("$mycolor10")) bar(4, color("$mycolor9")) bar(5, color("$mycolor8")) bar(6, color("$mycolor4")) bar(7, color("$mycolor12")) ///
over(grupo_edad) blabel(total) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(outside) color(black) format(%4.1f)) ///
blabel(total) ///
blabel(bar, size(vsmall) format(%11.0gc)) ///
ytitle("Casos por COVID") ///
ylabel(0(200)1000, nogrid) ///
legend(cols(3) label(1 "Semana 22") label(2 "Semana 23") label(3 "Semana 24") label(4 "Semana 25") label(5 "Semana 26") label(6 "Semana 27") label(7 "Semana 28") size(*0.8) region(col(white))) name(pos_GE, replace) 
