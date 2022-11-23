* Programa:		  Programa para analizar toda la información sobre COVID-19 en la Región Cusco
* Creado el:	  27 de octubre del 2021
* Actualizado en: 31 de octubre del 2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
* Acción requerida --> Seleccionar el número de usuario (1 en mi caso) de acuerdo a la dirección (path) del siguiente comando
clear all
set more off

* Acción requerida --> Cambiar la dirección (path) de su folder de replicación
	****GERESA*****
	global path "C:\Users\DEI-02\Documents\GitHub\GERESA_covid_cusco"
	*****CASA******
	*global path "C:\Users\Joelo\Documents\GitHub\GERESA_covid_cusco"
	cd "$path"

* Directorio de los datos: Por ser data confidencial, se guardan los datos en otra carpeta que no este libremente disponible
    ****GERESA******
	global datos "H:\Mi unidad\Datos"
	****CASA****** 
	*global datos "H:\Mi unidad\Datos"
	
* Acción requerida: programas para realizar mapas
*ssc install spmap
*ssc install shp2dta
*ssc install palettes
*ssc install colrspace
*ssc install estout, replace

* Acción requerida: definir la fecha actual y la semana epidemiológica
global fecha 22Nov2022
global semana 98

* Tiempo de corrida: alrededor de 7 minutos
timer on 1

* Definir los colores de las gráficas
* Colores
global mycolor1 "221 165 230"
global mycolor2 "243 149 13" 
global mycolor3 "205 24 24"
global mycolor4 "164 93 93"
global mycolor5 "54 56 120"
global mycolor6 "3 83 151"
global mycolor7 "52 103 81"
global mycolor8 "217 248 196" 
global mycolor9 "249 249 197" 
global mycolor10 "250 217 161"
global mycolor11 "243 120 120"
global mycolor12 "110 133 183" 
global mycolor13 "255 210 76"
global mycolor14 "151 114 251" 
global mycolor15 "255 6 183"
global mycolor16 "196 223 170"
global mycolor17 "15 14 14"

colorpalette ///
 "$mycolor1" ///
 "$mycolor2" ///
 "$mycolor3" ///
 "$mycolor4" ///
 "$mycolor5" ///
 "$mycolor6" ///
 "$mycolor7" ///
 "$mycolor8" ///
 "$mycolor9" ///
 "$mycolor10" ///
 "$mycolor11" ///
 "$mycolor12" ///
 "$mycolor13" ///
 "$mycolor14" ///
 "$mycolor15" ///  
 "$mycolor16" ///   
 "$mycolor17" /// 
  ,n(17)
  
gr export "figuras/paleta_colores.png", as(png) replace
	
* Se analiza los casos, defunciones, ocupación de camas, vacunas, variantes de COVID-19 en la Región Cusco
* Para ello, se cuenta con distintas fuentes de información 
** 1. NOTICOVID: casos por prueba molecular
** 2. SISCOVID: casos por prueba rápida y prueba antigénica
** 3. SINADEF: defunciones por COVID-19 y por todas las causas
** 4. Referencias y Contrareferencias: ocupación de camas UCI, no-UCI, UCIN, en los hospitales de la Región
** 5. SICOVAC-HIS, MINSA: vacunación COVID-19
** 6. NETLAB, UNSAAC, UPCH: laboratorios que secuencian las variantes de COVID-19
** 7. GRAFICOS DE BOLETIN: graficos presentes en el boletin mensual.
** 8. POSTVACUNADOS: graficos post-vacunas semanales.
** 9. TABLAS: tabla curso de vida 2020 - 2022 semana.


* 1. Construir las base de datos 2020 - 2021 - 2022
	**do "programas/0a_codigo_ubigeo"
	**do "programas/0b_codigo_establecimiento"
	*do "programas/1a_base_noticovid_2020"
	*do "programas/1b_base_noticovid_2021"
	do "programas/1b_base_noticovid_2022"

	*do "programas/1c_base_siscovid_pr_2020"
	*do "programas/1d_base_siscovid_pr_2021"

	*do "programas/1e_base_siscovid_ag_2021_1"
	*do "programas/1f_base_siscovid_ag_2021_2"
	do "programas/1f_base_siscovid_ag_2022_1"

	*do "programas/1g_base_sinadef_covid_2020"
	*do "programas/1h_base_sinadef_covid_2021"
	do "programas/1h_base_sinadef_covid_2022"

	do "programas/1i_base_unir"
	*do "programas/1i_base_unir_2022"----

	*do "programas/1j_datos_mapa_calor" // semanal
	do "programas/1j_datos_mapa_calor_2022"

* 2. Generar datos a nivel regional y provincial
	do "programas/2a_series_diarias_region"
	do "programas/2b_series_diarias_provincias"
	do "programas/2c_panel_diario_provincias"

* 3. Figuras para la "Sala Situacional COVID-19" diaria 
	*do "programas/3a_figura_etapa_vida"--
	do "programas/3a_figura_etapa_vida_2022"

	*do "programas/3b_figura_inci_morta_diario"--
	do "programas/3b_figura_inci_morta_diario_2022"
	
	do "programas/3c_figura_positividad"
	do "programas/3d_figura_promedio_casos_def"
	do "programas/3e_sintomaticos"

	* Para la actualización del Dashboard COVID-19 en la página web
	do "programas/1k_datos_dashboard" 

	** Cambiar la dirección si es necesario
	*CASA
	*do "C:\Users\DEI-02\Documents\GitHub\GERESA_dashboard\data\MasterDofile"
	* Ocupación de camas (semanalmente)
	*do "C:\Users\DEI-02\Documents\GitHub\GERESA_dashboard\data\source1_camas\main"


* 4. Figuras para la "Sala Situacional COVID-19" Semanal
	do "programas/2d_series_semanales_region" // Generar datos semanales region
	do "programas/4a_figura_casos_def_region"
	do "programas/4b_figura_mort_edad_region"
	
	do "programas/2e_series_semanales_provincias" // Generar datos semanales provincias
	do "programas/4c_figura_inci_mort_positi_provincial"
/*
	** Datos para los excesos de defunciones
	*do "programas/1l_datos_defunciones_reg_prov_2019" // datos del 2019
	do "programas/1m_datos_defunciones_2020_2021_regional"
	do "programas/1n_datos_defunciones_2020_2021_provincial"

	do "programas/4d_figura_exceso_regional"
	do "programas/4e_figura_exceso_provincial"

*/
	* Graficos Hospitalización
	do "programas/4f_figuras_hospitales"

	*Data Hospitalizados diarios
	*do "programas/4g_figuras_hospitalizados"
	
	*Hospitalizados - Fallecidos - AltasMedicas - Vacunados "SOLO DATOS"
	*do "programas/4h_datos_hospitalizados_vacunados_defunciones"
	*do "programas/4i_datos_fallecidos_vacunados"
	*do "programas/4j_datos_altas_fallecidos_vacunados"
	
/*
* 5. Secuenciamiento
	do "programas\5a_base_secuenciamiento_netlab"
	do "programas\5b_base_secuenciamiento_upch"
	do "programas\5c_juntar"
	do "programas\5d_figura_secuenciamiento"
	do "programas\5d_figura_sub_secuenciamiento"
	do "programas\5e_mapas_secuenciamiento"

* 6. Vacunados
	*do "programas\6a_base_vacunados"
	*do "programas\6b_figura_vacunacion"
	*do "programas\6c_figura_vacunacion_provincias"
	do "programas\6d_vacunacion"
	do "programas\6e_vacunacion_provincias" 
*/

/*
* 7. Figuras para el "Boletin COVID-19" Mensual
	do "programas\7a_base_noticovid_2021_variables"
	*do "programas\7b_base_siscovid_pr_2021_variables"
	do "programas\7c_base_siscovid_ag_2021_variables"
	do "programas\7d_unir_bases"
	do "programas\7e_figura_sintomas_comorbilidad"
	do "programas\7f_lugar_fallecimiento"
	*do "programas\7g_figura_inci_morta_series"
	do "programas\7g_figura_inci_morta_series_2022"
*/
x
* 8. Figuras Post_Vacunas Altas, Defunciónes, UCI Y NOUCI
	do "programas/8a_Post_Vacunas_Altas_Def"
	do "programas/8b_Post_Vacunas_Hospitalizados"
	do "programas/8c_Union_Post_Vacunas_Graph"

/*
* 9. Tablas
	do "programas/9a_Tablas_Curso_Vida"
	do "programas\4z_tabla_cero_defunciones.do"
*/
	
timer off 1
timer list