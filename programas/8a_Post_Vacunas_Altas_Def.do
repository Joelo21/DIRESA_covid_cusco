***Base Vacunados
use "${datos}\output\base_vacunados", clear
keep dni dosis fecha_ultima_vacuna
save "${datos}\output\base_vacunados_practica_eddie", replace
********************************************************************************
***Base Hospitalizados
import excel "${datos}\raw\base_altas_medicas.xlsx", sheet("Hoja1") firstrow clear
rename Numerodedocumento dni
rename Edad edad
rename FECHADEINGRESO fecha_ingreso
gen Alta_Medica = 1

save "${datos}\output\base_vacunados_altas_medicas", replace
********************************************************************************
**Base Vacunados - Alta_Medicas
use "${datos}\output\base_vacunados_altas_medicas", clear
merge n:n dni using "${datos}\output\base_vacunados_practica_eddie"
keep if Alta_Medica == 1

recode dosis (.=0)

*Datos Temporales
tempfile no_inmunizados dosis_1 dosis_2 dosis_3 

*Sumando Totales
*Inmunizados
preserve
ge numero = _n
collapse (count) numero if dosis == 0, by (Alta_Medica)
rename numero no_inmunizados
tempfile no_inmunizados
save "`no_inmunizados'"
restore 

*1 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 1, by (Alta_Medica)
rename numero dosis_01
tempfile dosis_1
save "`dosis_1'"
restore 

*2 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 2, by (Alta_Medica)
rename numero dosis_02
tempfile dosis_2
save "`dosis_2'"
restore 

*3 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 3, by (Alta_Medica)
rename numero dosis_03
tempfile dosis_3
save "`dosis_3'"
restore
 
*Merge 
use "`no_inmunizados'", clear
merge 1:1 Alta_Medica using "`dosis_1'", nogenerate
merge 1:1 Alta_Medica using "`dosis_2'", nogenerate
merge 1:1 Alta_Medica using "`dosis_3'", nogenerate

*Recodificando tabla
recode no_inmunizados(.=0)
recode dosis_01(.=0)
recode dosis_02(.=0)
recode dosis_03(.=0)

*Porcentajes
gen objetivo = no_inmunizados+dosis_01+dosis_02+dosis_03
gen Alta_Medica_0 = no_inmunizados/objetivo*100
gen Alta_Medica_1 = dosis_01/objetivo*100
gen Alta_Medica_2 = dosis_02/objetivo*100
gen Alta_Medica_3 = dosis_03/objetivo*100

format Alta_Medica_0 Alta_Medica_1 Alta_Medica_2 Alta_Medica_3 %4.1f
tostring Alta_Medica, replace force 
replace Alta_Medica = "Alta Hospitalaria" in 1

*Guardar datos
save "${datos}\output\base_vacunados_altas_medicas", replace

********************************************************************************
***Base Vacunados
use "${datos}\output\base_vacunados", clear
keep dni dosis fecha_ultima_vacuna
save "${datos}\output\base_vacunados_practica_eddie", replace
********************************************************************************
***Base Hospitalizados
use "${datos}\output\base_sinadef_2022", clear
merge n:n dni using "${datos}\output\base_vacunados_practica_eddie"
keep if defuncion == 1

recode dosis (.=0)

*Datos Temporales
tempfile no_inmunizados dosis_1 dosis_2 dosis_3 

*Sumando Totales
*Inmunizados
preserve
ge numero = _n
collapse (count) numero if dosis == 0, by (defuncion)
rename numero no_inmunizados
tempfile no_inmunizados
save "`no_inmunizados'"
restore 

*1 Dosis
preserve

ge numero = _n
collapse (count) numero if dosis == 1, by (defuncion)
rename numero dosis_01
tempfile dosis_1
save "`dosis_1'"
restore 

*2 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 2, by (defuncion)
rename numero dosis_02
tempfile dosis_2
save "`dosis_2'"
restore 

*3 Dosis
preserve
ge numero = _n
collapse (count) numero if dosis == 3, by (defuncion)
rename numero dosis_03
tempfile dosis_3
save "`dosis_3'"
restore
 
*Merge 
use "`no_inmunizados'", clear
merge 1:1 defuncion using "`dosis_1'", nogenerate
merge 1:1 defuncion using "`dosis_2'", nogenerate
merge 1:1 defuncion using "`dosis_3'", nogenerate

*Recodificando tabla
recode no_inmunizados(.=0)
recode dosis_01(.=0)
recode dosis_02(.=0)
recode dosis_03(.=0)

*Porcentajes
gen objetivo = no_inmunizados+dosis_01+dosis_02+dosis_03
gen defuncion_0 = no_inmunizados/objetivo*100
gen defuncion_1 = dosis_01/objetivo*100
gen defuncion_2 = dosis_02/objetivo*100
gen defuncion_3 = dosis_03/objetivo*100

format defuncion_0 defuncion_1 defuncion_2 defuncion_3 %4.1f
 
tostring defuncion, replace force 
replace defuncion = "Defunción" in 1

save "${datos}\output\base_vacunados_defunciones", replace
