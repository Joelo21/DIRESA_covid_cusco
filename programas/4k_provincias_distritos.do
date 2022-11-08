*Path\
import excel "${datos}\raw\dashboard_provincias_datos_basicos.xlsx", sheet(Hoja1) firstrow clear

**Generamos Distritos
export delimited using "${datos}\output\dashboard_provincias_datos_basicos.csv", replace

