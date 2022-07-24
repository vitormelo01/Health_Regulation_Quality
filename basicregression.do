*********data processing
*change state name
gen providerstate = "AL" if state == "alabama"
replace providerstate = "AK" if state == "alaska"
replace providerstate = "AZ" if state == "arizona"
replace providerstate = "CA" if state == "california"
replace providerstate = "CO" if state == "colorado"
replace providerstate = "CT" if state == "connecticut"
replace providerstate = "DC" if state == "dc"
replace providerstate = "DE" if state == "delaware"
replace providerstate = "FL" if state == "florida"
replace providerstate = "GA" if state == "georgia"
replace providerstate = "HI" if state == "hawaii"
replace providerstate = "ID" if state == "idaho"
replace providerstate = "IL" if state == "illinois"
replace providerstate = "IN" if state == "indiana"
replace providerstate = "IA" if state == "iowa"
replace providerstate = "KS" if state == "kansas"
replace providerstate = "KY" if state == "kentucky"
replace providerstate = "LA" if state == "louisiana"
replace providerstate = "ME" if state == "maine"
replace providerstate = "MD" if state == "maryland"
replace providerstate = "MA" if state == "massachusetts"
replace providerstate = "MI" if state == "michigan"
replace providerstate = "MN" if state == "minnesota"
replace providerstate = "MS" if state == "mississippi"
replace providerstate = "MO" if state == "missouri"
replace providerstate = "MT" if state == "montana"
replace providerstate = "NE" if state == "nebraska"
replace providerstate = "NV" if state == "nevada"
replace providerstate = "NH" if state == "new_hampshire"
replace providerstate = "NJ" if state == "new_jersey"
replace providerstate = "NM" if state == "new_mexico"
replace providerstate = "NY" if state == "new_york"
replace providerstate = "NC" if state == "north_carolina"
replace providerstate = "ND" if state == "north_dakota"
replace providerstate = "OH" if state == "ohio"
replace providerstate = "OK" if state == "oklahoma"
replace providerstate = "OR" if state == "oregon"
replace providerstate = "PA" if state == "pennsylvania"
replace providerstate = "RI" if state == "rhode_island"
replace providerstate = "SC" if state == "south_carolina"
replace providerstate = "SD" if state == "south_dakota"
replace providerstate = "TN" if state == "tennessee"
replace providerstate = "TX" if state == "texas"
replace providerstate = "UT" if state == "utah"
replace providerstate = "VT" if state == "vermont"
replace providerstate = "VA" if state == "virginia"
replace providerstate = "WA" if state == "washington"
replace providerstate = "WV" if state == "west_virginia"
replace providerstate = "WI" if state == "wisconsin"
replace providerstate = "WY" if state == "wyoming"

***base on nursing_homes17-22 folder
*intgrate dta files vertically
clear
cd D:\HUIYUYANG\PhD_in_Economics_at_Clemson\PhDcoursematerials\summerproject_resource\stataversion_data\nursing_homes17-22
use empty.dta
local s: dir "`d'" files "*.dta"
foreach filename of local s{
     append using `"`filename'"',force
}
save nursing17-22.dta
***base on hospitals17-22 folder
*intgrate dta files vertically
clear
cd D:\HUIYUYANG\PhD_in_Economics_at_Clemson\PhDcoursematerials\summerproject_resource\stataversion_data\hospitals17-22
use empty.dta
local s: dir "`d'" files "*.dta"
foreach filename of local s{
     append using `"`filename'"',force
}
save hospital17-22.dta

**based on mergefolder
*merge hospitals
cd D:\HUIYUYANG\PhD_in_Economics_at_Clemson\PhDcoursematerials\summerproject_resource\stataversion_data\mergefolder
use hospital17-22.dta, clear
merge n:1 year providerstate using hospital_healthcare_index.dta
keep if _merge==3
drop _merge
save mergedhospitals.dta
*merge nursinghomes
cd D:\HUIYUYANG\PhD_in_Economics_at_Clemson\PhDcoursematerials\summerproject_resource\stataversion_data\mergefolder
use nursing17-22.dta, clear
merge n:1 year providerstate using nursinghome_healthcare_index.dta
keep if _merge==3
drop _merge
save mergednursinghomes.dta


**************basic regression
*hospitals
cd D:\HUIYUYANG\PhD_in_Economics_at_Clemson\PhDcoursematerials\summerproject_resource\stataversion_data\mergefolder
use mergedhospitals.dta, clear
destring hospitaloverallrating, replace force
sum index
tab hospitaloverallrating
*ordered logit model
ologit hospitaloverallrating index
ologit hospitaloverallrating index i.year
*ordered logit marginal effects
mfx, predict(outcome(1))
mfx, predict(outcome(2))
mfx, predict(outcome(3))
mfx, predict(outcome(4))
mfx, predict(outcome(5))

*nursing homes
cd D:\HUIYUYANG\PhD_in_Economics_at_Clemson\PhDcoursematerials\summerproject_resource\stataversion_data\mergefolder
use mergednursinghomes, clear
sum index
tab overallrating
*ordered logit model
ologit overallrating index
ologit overallrating index i.year
*ordered logit marginal effects
mfx, predict(outcome(1))
mfx, predict(outcome(2))
mfx, predict(outcome(3))
mfx, predict(outcome(4))
mfx, predict(outcome(5))




