
use "${datos}\output\base_vacunados", clear

drop if EdadGE < 5
drop if missing(EdadGE)
drop if EdadGE > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if EdadGE >= 5 & EdadGE <= 11
replace grupo_edad = 2 if EdadGE >= 12 & EdadGE <= 17
replace grupo_edad = 3 if EdadGE >= 18 & EdadGE <= 29
replace grupo_edad = 4 if EdadGE >= 30 & EdadGE <= 39
replace grupo_edad = 5 if EdadGE >= 40 & EdadGE <= 49
replace grupo_edad = 6 if EdadGE >= 50 & EdadGE <= 59
replace grupo_edad = 7 if EdadGE >= 60 & EdadGE <= 69
replace grupo_edad = 8 if EdadGE >= 70 & EdadGE <= 79
replace grupo_edad = 9 if EdadGE >= 80 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "5 - 11 años" 2 "12-17 años" 3 "18-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80 a más años"	
label values grupo_edad grupo_edad
tab grupo_edad

* Contar cuántos son
* IMPORTANTE: Las personas con tres dosis se cuentan en personas con dos dosis
replace dosis = 2 if dosis == 3

preserve 
gen numero = _n
collapse (count) numero if dosis == 1, by(grupo_edad)
rename numero uno
save "${datos}\temporal\vacunados_primera", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 2, by(grupo_edad)
rename numero dos
save "${datos}\temporal\vacunados_segunda", replace
restore
/*
preserve 
gen numero = _n
collapse (count) numero if dosis == 3, by(grupo_edad)
rename numero tres
save "${datos}\temporal\vacunados_tercera", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 4, by(grupo_edad)
rename numero tres
save "${datos}\temporal\vacunados_cuarta", replace
restore 
*/
use "${datos}\temporal\vacunados_primera", clear
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_segunda", nogen
*merge 1:1 grupo_edad using "${datos}\temporal\vacunados_tercera", nogen
*merge 1:1 grupo_edad using "${datos}\temporal\vacunados_cuarta", nogen


gen objetivo = .
replace objetivo = 177961 if grupo_edad == 1
replace objetivo = 154802 if grupo_edad == 2
replace objetivo = 318123 if grupo_edad == 3
replace objetivo = 228775 if grupo_edad == 4
replace objetivo = 187360 if grupo_edad == 5
replace objetivo = 143692 if grupo_edad == 6
replace objetivo = 96507 if grupo_edad == 7
replace objetivo = 54159 if grupo_edad == 8
replace objetivo = 31271 if grupo_edad == 9
	
gen una_dosis = uno	/objetivo*100
gen dos_dosis = dos/objetivo*100
gen brecha_primera_segunda = uno/objetivo*100
*gen tres_dosis = tres/objetivo*100
*gen faltante = 100 - dos_dosis - brecha_primera_segunda - tres_dosis
gen faltante = 100 - dos_dosis - brecha_primera_segunda

*format dos_dosis brecha_primera_segunda tres_dosis faltante %4.1f
format dos_dosis brecha_primera_segunda faltante %4.1f

* Gráfica
graph hbar dos_dosis brecha_primera_segunda faltante, ///
over(grupo_edad) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis") label(3 "No Vacunados") size(*0.8) region(col(white))) name(vacunacion_grupo_edad, replace)

/*
graph hbar dos_dosis brecha_primera_segunda tres_dosis faltante, ///
over(grupo_edad) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(outside) color(black)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor1")) ///
bar(4, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis") label(3 "Tres dosis") label(4 "No Vacunados") size(*0.8) region(col(white))) name(vacunacion_grupo_edad, replace)
*/
* Exportar figura
graph export "figuras\vacunacion_grupo_edad.png", as(png) replace
graph export "figuras\vacunacion_grupo_edad.pdf", as(pdf) replace
