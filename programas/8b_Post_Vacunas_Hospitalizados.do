***Base Vacunados
use "${datos}\output\base_vacunados", clear
keep dni dosis fecha_ultima_vacuna
save "${datos}\output\base_vacunados_practica_eddie", replace
********************************************************************************
***Base Hospitalizados
* Importar la base de datos Hospitalizados
import excel "${datos}\raw\base_hospitalizados.xls", firstrow cellrange(A6:Z500) sheet(HOSPITALIZADOS) clear

*Changes Names Columnn's
rename A N°
rename B INSTITUCIÓN
rename C REGIONES
rename D HOSPITAL
rename E NOMBRE_Y_APELLIDOS
rename F TIPODOC
rename G dni
rename Años EDAD
rename K SEXO
rename L TIPO_SEGURO
rename M RESULTADO_PRUEBAS
rename W FECHA_DE_INGRESO
rename X FECHA_Y_HORA_SEGUIMIENTO
rename Y AMBIENTE
rename Z FECHA_DE_NACIMIENTO

rename EDAD edad
rename FECHA_DE_INGRESO fecha_ingreso
gen hospitalizados = 1

save "${datos}\output\base_hospitalizados_eddie", replace
********************************************************************************
**Base Vacunados - Hospitalizados (UCI)
use "${datos}\output\base_hospitalizados_eddie", clear
merge n:n dni using "${datos}\output\base_vacunados_practica_eddie"
keep if hospitalizados == 1

*Reemplazamos valor X
replace UCICONVM = "1" if UCICONVM == "X"
replace UCISINVM = "1" if UCISINVM == "X"
recode dosis (.=0)

destring UCICONVM, replace force
destring UCISINVM, replace force

*Generando Comparadores para Fechas
gen fecha_ingreso_DMY = fecha_ingreso
split fecha_ingreso_DMY, parse(-) destring
rename (fecha_ingreso_DMY?) (FIdia FImes FIaño)

gen FVaño = year(fecha_ultima_vacuna)
gen FVmes = month(fecha_ultima_vacuna)
gen FVdia = day(fecha_ultima_vacuna)

gen Fecha_Ingreso = date(fecha_ingreso, "DMY")
format Fecha_Ingreso %td

*Generando Post_Vacuna por Fecha de Ingreso a Hospitalizacion
gen post_vacuna = .
replace post_vacuna = 0 if fecha_ultima_vacuna > Fecha_Ingreso
replace post_vacuna = 1  if fecha_ultima_vacuna < Fecha_Ingreso 
*keep if post_vacuna == 1 

*Buscando Duplicados
sort dni
duplicates report dni
duplicates tag dni, gen(dupli_dni)
quietly by dni: gen dup_dni= cond(_N==1,0,_n)

*Eliminando Duplicados
*drop if FIaño ==! FVaño
duplicates drop dni, force

*Generando Grupos Etarios
gen grupo_edad=.
replace grupo_edad = 1 if edad >= 0 & edad <=11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 59
replace grupo_edad = 5 if edad >= 60 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "Niños" 2 "Adolescentes" 3 "Jovenes" 4 "Adultos" 5 "Adulto Mayor" 
label values grupo_edad grupo_edad

*Guardar datos
save "${datos}\output\base_vacunados_hospitalizados", replace
********************************************************************************
**Reponemos datos No_imunicazados - Inmunizados
use "${datos}\output\base_vacunados_hospitalizados", clear
recode UCICONVM(.=0)
recode UCISINVM(.=0)
gen UCI=UCICONVM+UCISINVM

*Datos Temporales
tempfile no_inmunizados dosis_1 dosis_2 dosis_3 

*Sumando Totales
*Inmunizados
preserve
ge numero = _n
collapse (count) numero if dosis == 0, by (UCI)
rename numero no_inmunizados
tempfile no_inmunizados
save "`no_inmunizados'"
restore 

*1 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 1, by (UCI)
rename numero dosis_01
tempfile dosis_1
save "`dosis_1'"
restore 

*2 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 2, by (UCI)
rename numero dosis_02
tempfile dosis_2
save "`dosis_2'"
restore 

*3 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 3, by (UCI)
rename numero dosis_03
tempfile dosis_3
save "`dosis_3'"
restore
 
*Merge 
use "`no_inmunizados'", clear
merge 1:1 UCI using "`dosis_1'", nogenerate
merge 1:1 UCI using "`dosis_2'", nogenerate
merge 1:1 UCI using "`dosis_3'", nogenerate

*Recodificando tabla
recode no_inmunizados(.=0)
recode dosis_01(.=0)
recode dosis_02(.=0)
recode dosis_03(.=0)

*Porcentajes
gen objetivo = no_inmunizados+dosis_01+dosis_02+dosis_03
gen uci_0 = no_inmunizados/objetivo*100
gen uci_1 = dosis_01/objetivo*100
gen uci_2 = dosis_02/objetivo*100
gen uci_3 = dosis_03/objetivo*100

format uci_0 uci_1 uci_2 uci_3 %4.1f
tostring UCI, replace force 
replace UCI = "NO UCI" in 1
replace UCI = "UCI" in 2

*Guardar datos
save "${datos}\output\base_vacunados_uci", replace
********************************************************************************
**Reponemos datos No_imunicazados - Inmunizados
use "${datos}\output\base_vacunados_hospitalizados", clear
*Datos Temporales
tempfile no_inmunizados dosis_1 dosis_2 dosis_3 

*Sumando Totales
*Inmunizados
preserve
ge numero = _n
collapse (count) numero if dosis == 0, by (hospitalizados)
rename numero no_inmunizados
tempfile no_inmunizados
save "`no_inmunizados'"
restore 

*1 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 1, by (hospitalizados)
rename numero dosis_01
tempfile dosis_1
save "`dosis_1'"
restore 

*2 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 2, by (hospitalizados)
rename numero dosis_02
tempfile dosis_2
save "`dosis_2'"
restore 

*3 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 3, by (hospitalizados)
rename numero dosis_03
tempfile dosis_3
save "`dosis_3'"
restore
 
*Merge 
use "`no_inmunizados'", clear
merge 1:1 hospitalizados using "`dosis_1'", nogenerate
merge 1:1 hospitalizados using "`dosis_2'", nogenerate
merge 1:1 hospitalizados using "`dosis_3'", nogenerate

*Recodificando tabla
recode no_inmunizados(.=0)
recode dosis_01(.=0)
recode dosis_02(.=0)
recode dosis_03(.=0)

*Porcentajes
gen objetivo = no_inmunizados + dosis_01 + dosis_02 + dosis_03
gen vh_0 = no_inmunizados/objetivo*100
gen vh_1 = dosis_01/objetivo*100
gen vh_2 = dosis_02/objetivo*100
gen vh_3 = dosis_03/objetivo*100

format vh_0 vh_1 vh_2 vh_3 %4.1f
tostring hospitalizados, replace force 
replace hospitalizados = "Hospitalizados" in 1


*Guardar datos
save "${datos}\output\base_vacunados_hospitalizados_dosis", replace