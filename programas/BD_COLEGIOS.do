import excel "${datos}\data extra\BD_Colegios.xlsx", sheet(Hoja1) firstrow clear
gen bd_colegios = 1
rename DNI dni
 
save "$	t{datos}\data extra\BD_Colegios.dta", replace
********************************************************************************
use "${datos}\output\base_vacunados_practica", clear
merge n:n dni using "${datos}\data extra\BD_Colegios", nogen


keep if bd_colegios == 1
drop fecha_2 año2 mes2 dia2 fecha_nacimiento yr yrint fecha_1 año1 mes1 dia1 dupli num_ dupli

export excel using "${datos}\data extra\BD_Colegios_procesada.xlsx"
