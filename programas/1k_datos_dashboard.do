
use "${datos}\output\base_covid.dta", clear

* Mantener las variables de interés
keep distrito fecha_resultado fecha_inicio sintomatico positivo_molecular positivo_antigenica positivo_rapida defuncion tipo_prueba fecha_recuperado ubigeo

sort tipo_prueba

* Eliminar datos antes del 13 de marzo del 2020
drop if fecha_resultado < 21987  

save "${datos}\output\data_dashboard.dta", replace

