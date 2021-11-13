

import excel "datos\raw\base_referencias_altas.xls", firstrow cellrange(A3:P8409) clear

rename Numerodedocumento DNI

keep DNI FECHADEINGRESO FECHADEALTA

save "datos\temporal\base_referencias_altas", replace

import excel "datos\raw\base_referencias_defunciones.xls", firstrow cellrange(A2:P2269) clear

keep DNI FECHADEINGRESO FECHADEDEFUNCION 

save "datos\temporal\base_referencias_defunciones", replace


append using "datos\temporal\base_referencias_altas"

* Generar las fechas

* Fecha de ingreso
gen fecha_ing1 = FECHADEINGRESO
split fecha_ing1, parse(-) destring
rename (fecha_ing1?) (dayl monthl yearl)
gen fecha_ingreso = daily(fecha_ing1, "DMY")
format fecha_ingreso %td

* Fecha de alta
gen fecha_al1 = FECHADEALTA
split fecha_al1, parse(-) destring
rename (fecha_al1?) (day2 month2 year2)
gen fecha_alta = daily(fecha_al1, "DMY")
format fecha_alta %td

* Fecha de defuncion
gen fecha_def1 = FECHADEDEFUNCION
split fecha_def1, parse(-) destring
rename (fecha_def1?) (day3 month3 year3)
gen fecha_defuncion = daily(fecha_def1, "DMY")
format fecha_defuncion %td

rename DNI dni

keep dni fecha_ingreso fecha_alta fecha_defuncion

sort dni
duplicates report dni
duplicates tag dni, gen(dupli_noti)
quietly by dni: gen dup_noti = cond(_N==1,0,_n)
*br dni dup_noti dupli_noti if dup_noti != 0

save "datos\output\base_referencias", replace
