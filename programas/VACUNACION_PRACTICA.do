/*
import delimited "${datos}\raw\vacunacovid.csv", varnames(1) encoding(UTF-8)  clear

* DNI
rename numero dni

* Fecha de nacimiento
gen fecha_2 = fnac
split fecha_2, parse(-) destring
rename (fecha_2?) (año2 mes2 dia2)
gen fecha_nacimiento = daily(fecha_2, "YMD")
format fecha_nacimiento %td

* Edad
gen yr =year(fecha_nacimiento)
gen int yrint = round(yr)
destring yrint, replace force
gen EdadGE = 2022 - yrint

* Fecha de vacunación
gen fecha_1 = fvac
split fecha_1, parse(-) destring
rename (fecha_1?) (año1 mes1 dia1)
gen fecha_vacuna = daily(fecha_1, "YMD")
format fecha_vacuna %td

* Ordenar por fecha de vacunación y DNI para indicar primera y segunda dosis
sort dni fecha_vacuna
duplicates report dni 
duplicates tag dni, gen(dupli)
quietly by dni: gen num_dupli = cond(_N==1,0,_n)

* Número de dosis del paciente
gen dosis = .
replace dosis = 1 if num_dupli == 0	| num_dupli == 1
replace dosis = 2 if num_dupli == 2
replace dosis = 3 if num_dupli == 3
replace dosis = 4 if num_dupli > 3


* Mantener una copia de los que tienen una dosis, dos dosis, y tres dosis
*keep if dosis == 1 | dosis == 2 | dosis == 3 | dosis == 4

* Mantener las variables de interés
rename fecha_vacuna fecha_ultima_vacuna

destring EdadGE, replace force
destring edad, replace force

save "${datos}\output\base_vacunados_practica", replace

********************************************************************************

use "${datos}\output\base_vacunados_practica", clear

drop if edad < 5
drop if missing(edad)
drop if edad > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 5 & edad <= 11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 39
replace grupo_edad = 5 if edad >= 40 & edad <= 49
replace grupo_edad = 6 if edad >= 50 & edad <= 59
replace grupo_edad = 7 if edad >= 60 & edad <= 69
replace grupo_edad = 8 if edad >= 70 & edad <= 79
replace grupo_edad = 9 if edad >= 80 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "5-11 años" 2 "12-17 años" 3 "18-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80 a más años"	
label values grupo_edad grupo_edad
tab grupo_edad

preserve 
gen numero = _n
collapse (count) numero if dosis == 1, by(grupo_edad)
rename numero uno
save "${datos}\temporal\vacunados_primera_practicas", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 2, by(grupo_edad)
rename numero dos
save "${datos}\temporal\vacunados_segunda_practicas", replace
restore

preserve 
gen numero = _n
collapse (count) numero if dosis == 3, by(grupo_edad)
rename numero tres
save "${datos}\temporal\vacunados_tercera_practicas", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 4, by(grupo_edad)
rename numero tres
save "${datos}\temporal\vacunados_cuarta_practicas", replace
restore 
*/
use "${datos}\temporal\vacunados_primera_practicas", clear
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_segunda_practicas", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_tercera_practicas", nogen
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_cuarta_practicas", nogen

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

gen una_dosis = uno/objetivo*100
gen dos_dosis = dos/objetivo*100
gen tres_dosis = tres/objetivo*100

format una_dosis dos_dosis tres_dosis %4.1f

graph hbar una_dosis dos_dosis tres_dosis, over(grupo_edad) plotregion(fcolor(white)) graphregion(fcolor(white)) ///
title("COBERTURA VACUNACIÓN REGIÓN CUSCO POR GRUPO ETARIO", size(*0.7)) ///
bgcolor("$mycolor3") ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, position() color(black) format(%4.1f))