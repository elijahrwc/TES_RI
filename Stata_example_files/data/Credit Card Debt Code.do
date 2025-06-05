clear all
cd "/Users/luke/Documents/TES Research Group/Sports Gambling Project"
import excel "area_report_by_year.xlsx", sheet("creditcard") cellrange(A4:V57) firstrow

reshape long Q4_, i(state) j(year)
rename Q4_ CC_Debt

binscatter CC_Debt year

frame create legalization_data
frame change legalization_data

import excel "Sports Gambling Legalization Tracker.xlsx", sheet("Sheet1") firstrow

rename State state
save Legalization_Data, replace

frame change default
merge m:1 state using Legalization_Data
drop if state == "PR" | state == "allUS"
drop _merge




