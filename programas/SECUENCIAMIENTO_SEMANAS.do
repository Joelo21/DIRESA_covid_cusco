*************************************************************************************
import excel "${datos}\raw\base_netlab_mayo_2022.xlsx", sheet(Hoja1) firstrow clear
rename DNI dni
rename LINAJE linaje
rename FECHADEENVIO fecha
gen mes = 05
gen muestra = "netlab"

save "${datos}\temporal\practica_secuenciamiento_mayo", replace
*************************************************************************************
import excel "${datos}\raw\base_netlab_junio_2022.xlsx", sheet(Hoja1) firstrow clear
rename DNI dni
rename LINAJE linaje
rename FECHADEENVIO fecha
gen mes = 06
gen muestra = "netlab"

save "${datos}\temporal\practica_secuenciamiento_junio", replace
*************************************************************************************
import excel "${datos}\raw\base_netlab_julio_2022.xlsx", sheet(Hoja1) firstrow clear
rename DNI dni
rename LINAJE linaje
rename FECHADEENVIO fecha
gen mes = 07
gen muestra = "netlab"

save "${datos}\temporal\practica_secuenciamiento_julio", replace
*************************************************************************************
import excel "${datos}\raw\base_netlab_agosto_2022.xlsx", sheet(Hoja1) firstrow clear
rename DNI dni
rename LINAJE linaje
rename FECHADEENVIO fecha
gen mes = 07
gen muestra = "netlab"
tostring dni, replace force

save "${datos}\temporal\practica_secuenciamiento_agosto", replace
*************************************************************************************
append using "${datos}\temporal\practica_secuenciamiento_mayo"
append using "${datos}\temporal\practica_secuenciamiento_junio"
append using "${datos}\temporal\practica_secuenciamiento_julio"
append using "${datos}\temporal\practica_secuenciamiento_agosto"
*************************************************************************************
replace muestra = "netlab" if muestra == ""
destring dni, replace force
sort dni
duplicates report dni
duplicates tag dni, gen(dupli_noti)
quietly by dni: gen dup_noti = cond(_N==1,0,_n)
duplicates drop dni,force
*************************************************************************************
format fecha %tddd/nn/CCYY
drop if fecha < d(01jan2022)

gen semana = .
replace semana = 18 if fecha <= d(07may2022)
replace semana = 19 if fecha > d(07may2022) & fecha <= d(14may2022)
replace semana = 20 if fecha > d(14may2022) & fecha <= d(21may2022)
replace semana = 21 if fecha > d(21may2022) & fecha <= d(28may2022)
replace semana = 22 if fecha > d(28may2022) & fecha <= d(04jun2022)
replace semana = 23 if fecha > d(04jun2022) & fecha <= d(11jun2022)
replace semana = 24 if fecha > d(11jun2022) & fecha <= d(18jun2022)
replace semana = 25 if fecha > d(18jun2022) & fecha <= d(25jun2022)
replace semana = 26 if fecha > d(26jun2022) & fecha <= d(02jul2022)
replace semana = 27 if fecha > d(02jul2022) & fecha <= d(09jul2022)
replace semana = 28 if fecha > d(09jul2022) & fecha <= d(16jul2022)
replace semana = semana[_n-7] + 1 if fecha > d(16jul2022)

drop if linaje != "BA.5.1" &  linaje != "BA.5.2" & linaje != "BA.5.2.1" & linaje != "BA.5.3" & linaje != "BA.5.3.1" & linaje != "BE.1" & linaje != "BA.5.3.2" & linaje != "BA.5.4" & linaje != "BA.5" & linaje != "BA.6" & linaje != "BA.5"

gen linaje_omicron_B5 =.
replace linaje_omicron_B5 = 1 if linaje == "BA.5.1" 
replace linaje_omicron_B5 = 2 if linaje == "BA.5.2" | linaje == "BA.5.2.1"
replace linaje_omicron_B5 = 3 if linaje == "BA.5.3" | linaje == "BA.5.3.1" | linaje == "BE.1"| linaje == "BA.5.3.2"
*replace linaje_omicron_B5 = 4 if linaje == "BA.5.4"
*replace linaje_omicron_B5 = 5 if linaje == "BA.5.5"
*replace linaje_omicron_B5 = 6 if linaje == "BA.5.6"
replace linaje_omicron_B5 = 4 if linaje == "BA.5"


label define linaje_omicron_B5 1 "BA.5.1" 2 "BA.5.2" 3 "BA.5.3" 4 "BA.5"
sort fecha

forvalues i =1/4{
    preserve 
	keep if linaje_omicron_B5 == `i'
	collapse (count) dni, by(semana)
	rename dni linaje_omicron_B5_`i', replace
	save "${datos}\temporal\datos_linaje_B5_`i'",replace
	restore
}

use "${datos}\temporal\datos_linaje_B5_1",clear
merge 1:1 semana using "${datos}\temporal\datos_linaje_B5_2", nogen
merge 1:1 semana using "${datos}\temporal\datos_linaje_B5_3", nogen
merge 1:1 semana using "${datos}\temporal\datos_linaje_B5_4", nogen

recode * (.=0)
sort semana

* Graficamos
graph bar linaje_omicron_B5_1 linaje_omicron_B5_2 linaje_omicron_B5_3 linaje_omicron_B5_4, ysize(5) xsize(6.1) ///
over(semana) bar(1, color("$mycolor11")) bar(2, color("$mycolor10")) bar(3, color("$mycolor12")) bar(4, color("$mycolor8")) bar(5, color("$mycolor4")) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(outside) color(black) format(%4.1f)) ///
blabel(bar, size(vsmall) format(%11.0gc)) ///
ytitle("Defunciones por COVID") ///
ylabel(0(3)30, nogrid) ///
legend(cols(2) label(1 "BA.5") label(3 "BA.5.1") label(5 "BA.5.2") label(7 "BA.5.2.1") label(9 "BA.5.5") size(*0.8) region(col(white))) name(Sub_v_omicron_b5, replace) 

