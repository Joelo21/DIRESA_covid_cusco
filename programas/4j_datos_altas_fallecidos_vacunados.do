***KAPLAN MEIER**** ALTAMEDICA - FALLECIDOS - CON VACUNAS
********************************************************************************
* Importar la base de datos ALTAMEDICA
import excel "${datos}\raw\base_altas_medicas.xlsx",firstrow sheet(Hoja1) clear

rename Numerodedocumento DNI
rename TIPOALTA ESTADO

*Guardar
save "${datos}\output\base_altasmedicas.dta", replace
********************************************************************************
* Importar la base de datos FALLECIDOS
import excel "${datos}\raw\base_fallecidos.xlsx", firstrow sheet(Hoja1) clear
rename Evolución ESTADO
append using "${datos}\output\base_altasmedicas.dta", force

* Identificar los duplicados
sort DNI
duplicates report DNI
duplicates tag DNI, gen(dupli_DNI)
quietly by DNI: gen dup_noti = cond(_N==1,0,_n)
duplicates drop DNI, force

*Guardar
save "${datos}\output\base_altasmedicas_fallecidos.dta", replace
********************************************************************************
*JUNTAR VACUNADOS Y HOSP-FALL
use "${datos}\output\base_vacunados", clear
rename dni DNI
merge m:m DNI using "${datos}\output\base_altasmedicas_fallecidos.dta",nogen

drop if ESTADO ==""
keep if dosis == 1 | dosis == 2 | dosis == 3

save "${datos}\output\base_altas_fallecidos_vacunados.dta", replace
