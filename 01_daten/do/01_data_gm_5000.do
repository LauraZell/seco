*-------------------------------------------------------------------------------
* importing data - gemeindedaten_ab5000
* 01_data_gm_5000.do
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* program setup
clear
version 16
set more off
*set memory 50m
*capture log close //close existing log files
*log using 01_data_kt.txt, text replace // open log file

local workdir "C:\github\seco\01_daten\"
cd `workdir'
/*
local files: dir "`workdir'" files "*.xlsx"
*/
*-------------------------------------------------------------------------------

import delimited "C:\github\seco\01_daten\daten\gemeinde_daten\gemeinden_ab5000.csv", encoding(ISO-8859-2) 
encode gemeinde, gen(gem)

/*
*positionen konto & investition isoliert - als test
gen investition = betrag if konto == 671 & funktion == 61
gen zinsaufwand = betrag if konto == 340 & funktion == 96

drop if investition >= . & zinsaufwand >= .
drop gemeinde nr konto funktion betrag

*zusammenfügen der positionen invest und zinsaufwand
collapse (sum) investition zinsaufwand, by(jahr gemeinde1)
*/


*kantone einfügen


*variable nr mit 0 zu beginn auf 6 digits aufgefüllt
/*
gen str6 test = string(nr,"%06.0f")
replace test = "ZH" if substr(test, 1, 2) == "01" 
replace test = "BE" if substr(test, 1, 2) == "02" 
*/



*alternativer weg
gen str6 test = string(nr)
replace test = substr(test, 1, length(test) - 4)
encode test, gen(test2)




preserve 

import excel "C:\github\seco\01_daten\daten\gemeinde_daten\canton_id.xlsx", sheet("Tabelle1") firstrow clear

save "C:\github\seco\01_daten\dta\canton_id.dta", replace

restore



rename test2 id 
merge m:1 id using "C:\github\seco\01_daten\dta\canton_id.dta"

drop _merge

*oberkategorien bilden

gen arten =.
replace arten = 10 if substr(string(konto, "%6.0f"), 1, 2) == "10" 
replace arten = 20 if substr(string(konto, "%6.0f"), 1, 2) == "20" 
replace arten = 30 if substr(string(konto, "%6.0f"), 1, 2) == "30" 
replace arten = 40 if substr(string(konto, "%6.0f"), 1, 2) == "40" 
replace arten = 50 if substr(string(konto, "%6.0f"), 1, 2) == "50" 
replace arten = 60 if substr(string(konto, "%6.0f"), 1, 2) == "60" 
replace arten = 14 if substr(string(konto, "%6.0f"), 1, 2) == "14" 
replace arten = 29 if substr(string(konto, "%6.0f"), 1, 2) == "29" 
replace arten = 31 if substr(string(konto, "%6.0f"), 1, 2) == "31" 
replace arten = 41 if substr(string(konto, "%6.0f"), 1, 2) == "41" 
replace arten = 51 if substr(string(konto, "%6.0f"), 1, 2) == "51" 
replace arten = 61 if substr(string(konto, "%6.0f"), 1, 2) == "61" 
replace arten = 32 if substr(string(konto, "%6.0f"), 1, 2) == "32" 
replace arten = 42 if substr(string(konto, "%6.0f"), 1, 2) == "42" 
replace arten = 52 if substr(string(konto, "%6.0f"), 1, 2) == "52" 
replace arten = 62 if substr(string(konto, "%6.0f"), 1, 2) == "62" 
replace arten = 33 if substr(string(konto, "%6.0f"), 1, 2) == "33" 
replace arten = 43 if substr(string(konto, "%6.0f"), 1, 2) == "43"
replace arten = 53 if substr(string(konto, "%6.0f"), 1, 2) == "53"
replace arten = 63 if substr(string(konto, "%6.0f"), 1, 2) == "63"
replace arten = 34 if substr(string(konto, "%6.0f"), 1, 2) == "34"
replace arten = 44 if substr(string(konto, "%6.0f"), 1, 2) == "44"
replace arten = 54 if substr(string(konto, "%6.0f"), 1, 2) == "54"
replace arten = 64 if substr(string(konto, "%6.0f"), 1, 2) == "64"
replace arten = 35 if substr(string(konto, "%6.0f"), 1, 2) == "35"
replace arten = 45 if substr(string(konto, "%6.0f"), 1, 2) == "45"
replace arten = 55 if substr(string(konto, "%6.0f"), 1, 2) == "55"
replace arten = 65 if substr(string(konto, "%6.0f"), 1, 2) == "65"
replace arten = 36 if substr(string(konto, "%6.0f"), 1, 2) == "36"
replace arten = 46 if substr(string(konto, "%6.0f"), 1, 2) == "46"
replace arten = 56 if substr(string(konto, "%6.0f"), 1, 2) == "56"
replace arten = 66 if substr(string(konto, "%6.0f"), 1, 2) == "66"
replace arten = 37 if substr(string(konto, "%6.0f"), 1, 2) == "37"
replace arten = 47 if substr(string(konto, "%6.0f"), 1, 2) == "47"
replace arten = 57 if substr(string(konto, "%6.0f"), 1, 2) == "57"
replace arten = 67 if substr(string(konto, "%6.0f"), 1, 2) == "67"
replace arten = 38 if substr(string(konto, "%6.0f"), 1, 2) == "38"
replace arten = 48 if substr(string(konto, "%6.0f"), 1, 2) == "48"
replace arten = 58 if substr(string(konto, "%6.0f"), 1, 2) == "58"
replace arten = 68 if substr(string(konto, "%6.0f"), 1, 2) == "68"
replace arten = 39 if substr(string(konto, "%6.0f"), 1, 2) == "39"
replace arten = 49 if substr(string(konto, "%6.0f"), 1, 2) == "49"
replace arten = 59 if substr(string(konto, "%6.0f"), 1, 2) == "59"
replace arten = 69 if substr(string(konto, "%6.0f"), 1, 2) == "69"


preserve 

collapse (sum) betrag, by(arten gemeinde jahr canton nr) 

rename betrag oberkat

save "C:\github\seco\01_daten\dta\arten_oberkat.dta", replace

restore

merge m:1 jahr gemeinde konto canton using "C:\github\seco\01_daten\dta\arten_oberkat.dta"





*wichtige variablen isolieren



save data/gemeinden/gem_5000.dta, replace

clear
