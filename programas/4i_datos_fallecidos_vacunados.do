*-------------------------------------------------------------------------------%

* Programa: Datos Base Defunciones y Base Vacunados

* Primera vez creado:     21 de Enero del 2022
* Ultima actualizaciónb:  22 de Julio del 2022

*-------------------------------------------------------------------------------%
********************************************************************************
*DATA FALLECIDOS VACUNADOS 2021-2022
********************************************************************************
use "${datos}\output\base_sinadef_2022.dta", clear
gen fallecidos = 1
merge m:m dni using "${datos}\output\base_vacunados_practica.dta", nogen


*Limpiando Datos Obtener datos 2022
replace dosis = 0 if dosis ==.
drop if fecha_sinadef <d(31dec2021)
drop if fallecidos !=1
drop if dni == ""
format fecha_sinadef %td

*Cantidad de Dosis por Persona
gen dosis0 = .
replace dosis0 = 1 if dosis == 0
gen dosis1 = .
replace dosis1 = 1 if dosis == 1
gen dosis2 = .
replace dosis2 = 1 if dosis == 2
gen dosis3 = .
replace dosis3 = 1 if dosis == 3

*Verificando duplicados
sort dni
duplicates report dni
duplicates tag dni, gen(dupli_dni)
quietly by dni: gen dup_dni= cond(_N==1,0,_n)

/*
*Cantidad de Fallecidos por Fecha_Sinadef
preserve
collapse (count) fallecidos, by(fecha_sinadef)
rename fecha_sinadef FECHA
gen total_fallecidos = sum(fallecidos)
*/

save "${datos}\output\base_fallecidos_vacunados.dta", replace
/*
***********************************************************************************
**Suma
use "${datos}\output\base_fallecidos_vacunados.dta", clear
drop if fecha_sinadef < d(01jul2021)
collapse (count) fallecidos, by(fecha_sinadef)
gen Total_Defunciones = sum(fallecidos)
***********************************************************************************
*Sumar cantidad de Fallecidos 1ra dosis 2021
use "${datos}\output\base_fallecidos_vacunados.dta", clear
drop if fecha_sinadef > d(31dec2021)
collapse (count) dosis1, by (fecha_sinadef)
gen Total_Defunciones1 = sum(dosis1)
save "${datos}\output\sumdosis1.dta", replace
********************************************************************************
*Sumar cantidad de Fallecidos 2da dosis 2021
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if fecha_sinadef > d(31dec2021)
collapse (count) dosis2, by (fecha_sinadef)
gen Total_Defunciones2 = sum(dosis2)
save "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\sumdosis2.dta", replace
********************************************************************************
*Sumar cantidad de Fallecidos 3ra dosis 2021
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if fecha_sinadef > d(31dec2021)
collapse (count) dosis3, by (fecha_sinadef)
gen Total_Defunciones3 = sum(dosis3)
save "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\sumdosis3.dta", replace
***********************************************************************************
*Sumar cantidad de Fallecidos 1ra dosis 2022
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if d(31dec2021) > fecha_sinadef
collapse (count) dosis1, by (fecha_sinadef)
gen Total_Defunciones5 = sum(dosis1)
save "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\sumdosis4.dta", replace
********************************************************************************
*Sumar cantidad de Fallecidos 2ra dosis 2022
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if d(31dec2021) > fecha_sinadef
collapse (count) dosis2, by (fecha_sinadef)
gen Total_Defunciones4 = sum(dosis2)
save "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\sumdosis5.dta", replace
********************************************************************************
*Sumar cantidad de Fallecidos 3ra dosis 2022
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if d(31dec2021) > fecha_sinadef
collapse (count) dosis3, by (fecha_sinadef)
gen Total_Defunciones6 = sum(dosis3)
save "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\sumdosis6.dta", replace
***********************************************************************************
*/
