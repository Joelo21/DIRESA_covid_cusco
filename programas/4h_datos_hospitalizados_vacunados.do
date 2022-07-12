*HOSPITALIZADOS Y CON VACUNAS
********************************************************************************
* Importar la base de datos Hospitalizados
import excel "${datos}\raw\base_hospitalizados.xlsx",firstrow sheet(Hoja1) clear
rename DNI dni
gen Hospitalizados = 1

*Guardar
save "${datos}\output\base_hospitalizados.dta", replace
********************************************************************************

*Uniendo Base Hospitalizados y Base Vacunados
use "${datos}\output\base_vacunados.dta", clear
merge m:1 dni using "${datos}\output\base_hospitalizados.dta",nogen

drop if Hospitalizados != 1
replace ESTADOVACUNA =.
replace ESTADOVACUNA = 0 if fecha_ultima_vacuna ==. 
replace ESTADOVACUNA = 1 if fecha_ultima_vacuna !=.
keep if dosis == 1 | dosis == 2 | dosis == 3 | ESTADOVACUNA == 0

save "${datos}\output\hospitalizados_vacunados.dta", replace

*Fecha de Ingreso
preserve
collapse (count) Hospitalizados, by(FECHADEINGRESO)
rename FECHADEINGRESO FECHA
gen total_Hospitalizados = sum(Hospitalizados)


*save "${datos}\output\hospitalizados_vacunados.dta", replace
/*
********************************************************************************
*Uniendo Base Hospitalizados y Defunciones
use "${datos}\output\base_sinadef_2022.dta", clear
merge m:m dni using "${datos}\output\base_hospitalizados.dta",nogen
drop if Hospitalizados != 1
sort fecha_sinadef
keep if departamento == "CUSCO"
