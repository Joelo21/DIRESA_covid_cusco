
/*
import excel "${datos}\raw\base_siscovid_ag_2021_1.xlsx", sheet("Hoja1") firstrow clear

save "${datos}\temporal\data_sis_ag_boletin_1.dta", replace
*/
import excel "${datos}\raw\base_siscovid_ag_2022_1.xlsx", sheet("Hoja1") firstrow clear

keep if Departamento == "Cusco"
rename NroDocumento dni

gen positivo_ag_sis=.
replace positivo_ag_sis = 1 if Resultado == "Reactivo" | ((Resultado == "Inválido" |Resultado == "Indeterminado") & ResultadoSegundaPrueba == "Reactivo")
replace positivo_ag_sis = 0 if Resultado == "No Reactivo" | ((Resultado == "Inválido" |Resultado == "Indeterminado") & ResultadoSegundaPrueba == "No Reactivo")
*tab positivo_ag_sis


*gen fecha_antigenica = FechaPrueba 
gen fecha_antigena = FechaEjecucionPrueba
split fecha_antigena, parse(-) destring
rename (fecha_antigena?) (year month day)
gen fecha_ag_sis = daily(fecha_antigena, "YMD") if positivo_ag_sis == 1 | positivo_ag_sis == 0
format fecha_ag_sis %td

********************************************************************************
* Duplicados en la base SISCOVID de AG

sort dni
duplicates report dni
duplicates tag dni, gen(repe_ag)
quietly by dni: gen repeti_ag = cond(_N==1,0,_n)
sort dni fecha_ag_sis repeti_ag
*br dni repe_ag repeti_ag fecha_ag_sis positivo_ag_sis if repe_ag != 0

* Borrar si se duplican en dni resultado de la prueba AG y su fecha de resultado
duplicates report dni positivo_ag_sis fecha_ag_sis
duplicates drop dni positivo_ag_sis fecha_ag_sis, force

keep if positivo_ag_sis == 1 | positivo_ag_sis == 0

drop if fecha_ag_sis == .
drop if positivo_ag_sis == .

********************************************************************************
* Sintomas 

gen sin_fiebre_2 = .
replace sin_fiebre_2 = 1 if fiebre == "SI"

gen sin_malestar = .
replace sin_malestar = 1 if malestar_general == "SI"

gen sin_tos = .
replace sin_tos = 1 if tos == "SI"


gen sin_garganta = .
replace sin_garganta = 1 if dolor_garganta == "SI"


gen sin_congestion = .
replace sin_congestion = 1 if congestion_nasal == "SI"

gen sin_respiratoria = .
replace sin_respiratoria = 1 if dificultad_respiratoria == "SI"

gen sin_diarrea = .
replace sin_diarrea = 1 if diarrea == "SI"

gen sin_nauseas = .
replace sin_nauseas = 1 if nausea_vomito == "SI"

gen sin_cefalea = .
replace sin_cefalea = 1 if cefalea == "SI"

gen sin_irritabilidad = .
replace sin_irritabilidad = 1 if irritabilidad_confusion == "SI"

gen sin_muscular = .
replace sin_muscular = 1 if dolor_muscular == "SI"

gen sin_abdominal = .
replace sin_abdominal = 1 if dolor_abdominal == "SI"

gen sin_pecho = .
replace sin_pecho = 1 if dolor_pecho == "SI"

gen sin_articulaciones = .
replace sin_articulaciones = 1 if dolor_articulaciones == "SI"

gen sin_otro = .
replace sin_otro = 1 if otro_sintoma == "SI"

gen sin_ninguno = .
replace sin_ninguno = 1 if (sin_fiebre_2 != 1 & sin_malestar!= 1 &  sin_tos != 1 &  sin_garganta != 1 &  sin_congestion != 1 &   sin_respiratoria != 1 &   sin_diarrea != 1 &  sin_nauseas != 1 &   sin_cefalea != 1 & sin_irritabilidad != 1 &   sin_muscular != 1 &  sin_abdominal != 1 &   sin_pecho != 1 &  sin_articulaciones != 1 &  sin_otro != 1)

********************************************************************************
*Comorbilidades
gen com_obesidad = .
replace com_obesidad = 1 if RiesgoObesidad == "SI"

gen com_pulmonar = .
replace com_pulmonar = 1 if RiesgoEnfPulmonarCronica == "SI"

gen com_diabetes = .
replace com_diabetes = 1 if RiesgoDiabetes == "SI"

gen com_cardiovasular = .
replace com_cardiovasular =1 if Riesgo_EnfCardiovascular == "SI"

gen com_inmunodeficiencia = .
replace com_inmunodeficiencia = 1 if RiesgoEnfTratinmuno == "SI"

gen com_cancer = .
replace com_cancer = 1 if RiesgoCancer == "SI"

gen com_embarazo = .
replace com_embarazo = 1 if RiesgoEmbarazo == "SI"

gen com_asma = .
replace com_asma = 1 if RiesgoAsma == "SI"

gen com_renal = .
replace com_renal = 1 if RiesgoRenalCronica == "SI"

gen com_ninguno = .
replace com_ninguno = 1 if RiesgoNinguna == "SI"

keep if fecha_ag_sis >= d(01jan2021) & fecha_ag_sis <= d($fecha) 

keep dni positivo_ag_sis fecha_ag_sis sin_* com_*  

save "${datos}\output\data_sis_ag_boletin.dta", replace
