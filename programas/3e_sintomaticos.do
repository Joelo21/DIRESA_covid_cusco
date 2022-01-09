
use "${datos}\output\data_series_region_2022.dta", clear

drop if fecha < d(31dec2021)

collapse (sum) sintomatico

sum sintomatico