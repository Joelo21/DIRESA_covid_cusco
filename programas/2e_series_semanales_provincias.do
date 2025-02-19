* Cargar los datos
use "${datos}\output\data_series_provincias_2020_2021_2022", clear

* Genera datos semanales de todas las provincias
forvalues i=1/13 {

preserve

* Mantener las variables de interés
*keep fecha positivo_`i' positivo_pcr_`i' positivo_ag_`i' prueba_pcr_`i' prueba_ag_`i' positivo_prueba_pcr_`i' positivo_prueba_pr_`i' positivo_prueba_ag_`i' defuncion_`i' 
keep fecha positivo_`i' positivo_pcr_`i' positivo_ag_`i' prueba_pcr_`i' prueba_ag_`i' positivo_prueba_pcr_`i' positivo_prueba_ag_`i' defuncion_`i' 

* Generar las semanas epidemiológicas del 2020
gen semana = .
replace semana = 11 if fecha_resultado == 21987 | fecha_resultado == 21988
replace semana = 12 if fecha_resultado > 21988 & fecha_resultado <= 21995
replace semana = semana[_n-7] + 1 if fecha_resultado > 21995

*collapse (sum) positivo_`i' positivo_pcr_`i' positivo_ag_`i' prueba_pcr_`i' prueba_ag_`i' positivo_prueba_pcr_`i' positivo_prueba_pr_`i' positivo_prueba_ag_`i' defuncion_`i', by(semana)
collapse (sum) positivo_`i' positivo_pcr_`i' positivo_ag_`i' prueba_pcr_`i' prueba_ag_`i' positivo_prueba_pcr_`i' positivo_prueba_ag_`i' defuncion_`i', by(semana)

gen positividad_pcr_`i' = positivo_pcr_`i'/prueba_pcr_`i'*100
gen positividad_ag_`i' = positivo_ag_`i'/prueba_ag_`i'*100

tsset semana

* Generar las semanas epidemiológicas del 2021
gen numero = _n
gen semana_2 = .
replace semana_2 = semana - 53
replace semana_2 = . if semana_2 < 0

label var semana_2 "Semana"

*Generar las semanas epidemiologicas del 2022
gen semana_3 = .
replace semana_3 = semana_2 - 53
replace semana_3 = . if semana_3 < 0

*save "datos/temporal/data_semanal_`i'.dta", replace

* Mortalidad e Incidencia
gen poblacion_1 = 28477
gen poblacion_2 = 57731
gen poblacion_3 = 76462
gen poblacion_4 = 40420
gen poblacion_5 = 105049
gen poblacion_6 = 84925
gen poblacion_7 = 463656
gen poblacion_8 = 71304
gen poblacion_9 = 185793
gen poblacion_10 = 31264
gen poblacion_11 = 52989
gen poblacion_12 = 92989
gen poblacion_13 = 66439

*drop poblacion_1 if poblacion_`i' == poblacion_1

gen mortalidad_`i' = defuncion_`i'/poblacion_`i'*10000
gen incidencia_`i' = positivo_`i'/poblacion_`i'*10000

label var mortalidad_`i' "Mortalidad (defunciones/pob.*10,000)"
label var incidencia_`i' "Incidencia (casos/pob.*10,000)"

label var positivo_prueba_pcr_`i' "Sintomaticos PCR"
label var positivo_prueba_ag_`i' "Sintomatico AG"

format mortalidad_`i' %8.1f
format incidencia_`i' %8.1f

format positivo_prueba_pcr_`i' 
format positivo_prueba_ag_`i' 


save "${datos}/temporal/data_semanal_`i'.dta", replace

restore
}

use "${datos}/temporal/data_semanal_1.dta", clear

forvalues j=2/13 {

merge 1:1 semana using "${datos}/temporal/data_semanal_`j'.dta", nogen

}

*keep semana_2 semana_3 defuncion_1 defuncion_2 defuncion_3 defuncion_4 defuncion_5 defuncion_6 defuncion_7 defuncion_8 defuncion_9 defuncion_10 defuncion_11 defuncion_12 defuncion_13

save "${datos}/output/serie_semanal_provincias.dta", replace
