
use "datos\output\data_series_region", clear

drop if fecha < d(01jan2021)

collapse (sum) sintomatico 

sum sintomatico