use "${datos}\output\base_vacunados_uci", clear
append using "${datos}\output\base_vacunados_hospitalizados_dosis", force
append using "${datos}\output\base_vacunados_altas_medicas", force
append using "${datos}\output\base_vacunados_defunciones", force

order UCI hospitalizados Alta_Medica defuncion 

* Grafico
graph bar uci_0 uci_1 uci_2 uci_3, over(UCI) stack ///
title("Proporción de pacientes post-vacunas en servicios de salud", box bexpand bcolor("$mycolor3") color(white) size(4.1)) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(center) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)")  ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "No Inmunizados") label(2 "1ra Dosis") label(3 "2da Dosis") label(4 "3ra Dosis")size(*0.8) region(col(white))) name(UCI,replace)

*Grafico
graph bar vh_0 vh_1 vh_2 vh_3, over(hospitalizados) stack ///
title("Proporción de pacientes post-vacunas en servicios de salud", box bexpand bcolor("$mycolor3") color(white) size(4.1)) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(center) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "No Inmunizados") label(2 "1ra Dosis") label(3 "2da Dosis") label(4 "3ra Dosis")size(*0.8) region(col(white))) name(HOSP,replace)

* Grafico
graph bar Alta_Medica_0 Alta_Medica_1 Alta_Medica_2 Alta_Medica_3 , over(Alta_Medica) stack ///
title("Proporción de pacientes post-vacunas en servicios de salud", box bexpand bcolor("$mycolor3") color(white) size(4.1)) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(center) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "No Inmunizados") label(2 "1ra Dosis") label(3 "2da Dosis") label(4 "3ra Dosis")size(*0.8) region(col(white))) name(ALT_MED,replace)

* Grafico
graph bar defuncion_0 defuncion_1 defuncion_2 defuncion_3 , over(defuncion) stack ///
title("Proporción de pacientes post-vacunas en servicios de salud", box bexpand bcolor("$mycolor3") color(white) size(4.1)) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(center) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "No Inmunizados") label(2 "1ra Dosis") label(3 "2da Dosis") label(4 "3ra Dosis")size(*0.8) region(col(white))) name(DEF,replace)

/*
graph combine UCI HOSP ALT_MED DEF 
graphregion(color(white)) ///