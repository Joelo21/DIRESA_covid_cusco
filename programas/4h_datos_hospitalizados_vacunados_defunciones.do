*-------------------------------------------------------------------------------%

* Programa: Datos Hospitalizados + Base Vacunados y Base Defunciones

* Primera vez creado:     21 de Enero del 2022
* Ultima actualizaciónb:  22 de Julio del 2022

*-------------------------------------------------------------------------------%
********************************************************************************
*HOSPITALIZADOS Y CON VACUNAS
********************************************************************************
* Importar la base de datos Hospitalizados
import excel "${datos}\raw\base_hospitalizados.xls", firstrow cellrange(A6:X500) sheet(HOSPITALIZADOS) clear

*Changes Names Columnn's
rename A N°
rename B INSTITUCIÓN
rename C REGIONES
rename D HOSPITAL
rename E NOMBRE_Y_APELLIDOS
rename F TIPODOC
rename G dni
rename H EDAD
rename I SEXO
rename J TIPO_SEGURO
rename K RESULTADO_PRUEBAS
rename U FECHA_DE_INGRESO
rename V FECHA_Y_HORA_SEGUIMIENTO
rename W AMBIENTE
rename X FECHA_DE_NACIMIENTO

gen Hospitalizados = 1

*Guardar
save "${datos}\output\base_hospitalizados.dta", replace
********************************************************************************
*Uniendo Base Hospitalizados y Base Vacunados
********************************************************************************
use "${datos}\output\base_vacunados_practica.dta", clear
merge m:m dni using "${datos}\output\base_hospitalizados.dta",nogen

drop if Hospitalizados != 1
gen ESTADOVACUNA =.
replace ESTADOVACUNA = 0 if fecha_ultima_vacuna ==. 
replace ESTADOVACUNA = 1 if fecha_ultima_vacuna !=.
keep if dosis == 1 | dosis == 2 | dosis == 3 | ESTADOVACUNA == 0

*Duplicates
sort dni fecha_ultima_vacuna
duplicates report dni
duplicates tag dni , gen(dupli_dni)
quietly by dni: gen dup= cond(_N==1,0,_n)

drop if dup == 1
save "${datos}\output\base_hospitalizados_vacunados.dta", replace

/*
*Contando Hospitalizados por Fecha de Ingreso
preserve
collapse (count) Hospitalizados, by(FECHADEINGRESO)
rename FECHADEINGRESO FECHA
gen total_Hospitalizados = sum(Hospitalizados)

*Condicional para Año = 2022
save "${datos}\output\base_hospitalizados_vacunados.dta", replace
*/
********************************************************************************
*Uniendo Base Hospitalizados, Vacunados y Defunciones
********************************************************************************
use "${datos}\output\base_sinadef_2022.dta", clear
merge m:m dni using "${datos}\output\base_hospitalizados_vacunados.dta",nogen
drop if Hospitalizados != 1
sort fecha_sinadef
keep if departamento == "CUSCO"

save "${datos}\output\base_hospitalizados_vacunados_defunciones.dta", replace