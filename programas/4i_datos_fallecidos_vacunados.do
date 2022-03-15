*Fallecidos y vacunados
**********************DATA FALLECIDOS VACUNADOS 2021-2022***********************
use "${datos}\output\base_sinadef_2022.dta", clear
gen fallecidos = 1
merge m:m dni using "${datos}\output\base_vacunados.dta", nogen

gen ESTADOVACUNA=.
replace ESTADOVACUNA= 1 if fecha_ultima_vacuna == .
replace ESTADOVACUNA= 2 if fecha_ultima_vacuna !=.
replace dosis = 0 if dosis ==.

**Obtener datos 2022
*drop if fecha_sinadef <d(01jul2021)
drop if fallecidos !=1
drop if dni == ""


**Cantidad de Dosis
gen dosis0 = .
replace dosis0 = 1 if dosis == 0
gen dosis1 = .
replace dosis1 = 1 if dosis == 1
gen dosis2 = .
replace dosis2 = 1 if dosis == 2
gen dosis3 = .
replace dosis3 = 1 if dosis == 3

/*
*Fecha de Ingreso
preserve
collapse (count) fallecidos, by(fecha_sinadef)
rename fecha_sinadef FECHA
gen total_fallecidos = sum(fallecidos)
*/

save "${datos}\output\base_fallecidos_vacunados.dta", replace

/*
***********************************************************************************
**TOTAL** 2021 - 2022**
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if fecha_sinadef < d(01jul2021)
collapse (count) fallecidos, by(fecha_sinadef)
gen Total_Defunciones = sum(fallecidos)
***********************************************************************************
*Sumar cantidad de Fallecidos 1ra dosis 2021
use "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\base_vacunados_fallecidos.dta", clear
drop if fecha_sinadef > d(31dec2021)
collapse (count) dosis1, by (fecha_sinadef)
gen Total_Defunciones1 = sum(dosis1)
save "C:\Users\PC\Documents\PROGRAMAS GERESA 2022\2022 HOSPITALIZADOS - VARIANTES  PROGRAMAS\output\sumdosis1.dta", replace
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
