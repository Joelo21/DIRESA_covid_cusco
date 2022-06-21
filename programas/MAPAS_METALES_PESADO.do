shp2dta using "mapas\datos_distritales.shp", database("mapas\distrital_db") coordinates("mapas\distrital_co") genid(id) genc(c)  replace

use "mapas\distrital_db", clear
keep if CCDD == "08"
rename UBIGEO ubigeo
sort ubigeo
save "mapas\mapa_cusco_distrital", replace

import excel "${datos}\raw\mapas_espinar.xlsx", sheet(Hoja1) firstrow clear 
destring id, replace force

merge m:m id using "mapas\mapa_cusco_distrital"
keep if _merge == 3


*recode  Cadmio* (.=0)
destring Cadmio2, replace force
destring Mercurio, replace force
*sort Distrito

spmap Arsenico using "mapas\distrital_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5" "$mycolor1" "$mycolor6" "$mycolor7") label(xcoord( x_c ) ycoord( y_c ) label(NOMBDIST)) name(Arsenico, replace)

gr export "figuras\Arsenico_Chumbilvicas.png", as(png) replace

spmap Plomo using "mapas\distrital_co", id(id) fcolor("$mycolor8" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(NOMBDIST)) name(Plomo, replace)

gr export "figuras\Plomo_Chumbilvicas.png", as(png) replace

spmap Cadmio2 using "mapas\distrital_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(NOMBDIST)) name(Cadmio, replace)

gr export "figuras\Cadmio_Chumbilvicas.png", as(png) replace


spmap Mercurio using "mapas\distrital_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(NOMBDIST)) name(Mercurio, replace)

gr export "figuras\Mercurio_Chumbilvicas.png", as(png) replace

spmap Total using "mapas\distrital_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(NOMBDIST)) name(Totales, replace)

gr export "figuras\Totales_Chumbilvicas.png", as(png) replace