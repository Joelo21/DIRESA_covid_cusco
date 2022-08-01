use "${datos}\output\base_vacunados_uci", clear
append using "${datos}\output\base_vacunados_hospitalizados_dosis", force
append using "${datos}\output\base_vacunados_altas_medicas", force
append using "${datos}\output\base_vacunados_defunciones", force

order UCI hospitalizados Altas_Medicas defuncion 

* Grafico
graph bar uci_0 uci_1 uci_2 uci_3 , over(UCI) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
name(UCI,replace)

*Grafico
graph bar hosp_0 hosp_1 hosp_2 hosp_3, over(hospitalizados) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
name(HOSP,replace)

* Grafico
graph bar alta_medica_0 alta_medica_1 alta_medica_2 alta_medica_3 , over(Altas_Medicas) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
name(ALT_MED,replace)

* Grafico
graph bar defuncion_0 defuncion_1 defuncion_2 defuncion_3 , over(defuncion) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
bar(4, color("$mycolor6")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
name(DEF,replace)

/*
graph combine UCI HOSP ALT_MED DEF 
graphregion(color(white)) ///

