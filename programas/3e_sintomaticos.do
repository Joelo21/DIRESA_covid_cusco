
use "${datos}\output\data_series_region.dta", clear

drop if fecha < d(01jan2022)

collapse (sum) sintomatico

sum sintomatico