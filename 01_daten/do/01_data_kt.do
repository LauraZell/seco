*-------------------------------------------------------------------------------
* importing data - kantonale daten
* 01_data_kt.do
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* program setup
clear
version 16
set more off
*set memory 50m
*capture log close //close existing log files
*log using 01_data_kt.txt, text replace // open log file

local workdir "C:\test\seco\01_daten\kantonale_daten"
cd `workdir'
/*
local files: dir "`workdir'" files "*.xlsx"
*/
*-------------------------------------------------------------------------------



//loop xlsx files of cantonal data

local ktn_list ag ai ar be bl bs fr ge gl gr ju lu ne nw ow sg sh so sz tg ti ur vd vs zg zh
foreach x of local ktn_list  {
	import excel C:\test\seco\01_daten\kantonale_daten\ktn_`x'.xlsx
	sheet("bilanz") firstrow clear
	save ktn_`x'.dta, replace
}



/*
//loop through sheets
for values i=11(-1)1 {
	import excel using ktn_ag.xlsx,
	sheet(Sheet`i') cellrange(A1:A1) clear
	
}
*/

