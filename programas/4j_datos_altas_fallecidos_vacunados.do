***KAPLAN MEIER**** NOTICVOVID - ALTAMEDICA - FALLECIDOS - CON VACUNAS
********************************************************************************
* Importar la base de datos ALTAMEDICA
import excel "${datos}\raw\base_altas_medicas.xls",firstrow cellrange(A3:P10000) sheet(ALTA MÉDICA) clear

*ELIMINANDO DATOS VACIOS
drop if N == .
rename Numerodedocumento DNI
rename TIPOALTA ESTADO
sort FECHADEALTA
 
gen Hosp_UCI = 1
drop if Condición == "con_uci_ventilador"

*collapse (sum) Hosp_UCI, by(FECHADEALTA)


*Guardar
save "${datos}\output\base_altasmedicas.dta", replace
********************************************************************************
* Importar la base de datos FALLECIDOS (RECUERDA CAMBIAR P:XXXXX con la cantidad de def que hubiera)
import excel "${datos}\raw\base_fallecidos.xls", firstrow cellrange(A2:P2397) sheet(Fallecidos) clear
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
*JUNTAR HOSP-FALL Y VACUNADOS
use "${datos}\output\base_vacunados_practica", clear
rename dni DNI
merge m:m DNI using "${datos}\output\base_altasmedicas_fallecidos.dta",nogen

save "${datos}\output\base_altas_fallecidos_vacunados.dta", replace
********************************************************************************
*JUNTAR BASES CON NOTICOVID
use "${datos}\output\base_noticovid_2022.dta", clear
rename dni DNI

*Uniendo Base NOTICVOVID
merge m:m DNI using "${datos}\output\base_altas_fallecidos_vacunados.dta", nogen

drop if ESTADO ==""
recode dosis*(.=0)
keep if dosis == 0 | dosis == 1 | dosis == 2 | dosis == 3

save "${datos}\output\base_noticovid_altas_fallecidos_vacunados.dta", replace