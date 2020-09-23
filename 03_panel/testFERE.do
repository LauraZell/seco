clear
import delimited "C:\github\seco\daten\gemeinde_daten\gemeinden_ab5000.csv", encoding(ISO-8859-2) 
encode gemeinde, gen(gemeinde1)

*positionen konto & investition isoliert - als test
gen investition = betrag if konto == 671 & funktion == 61
gen zinsaufwand = betrag if konto == 340 & funktion == 96

drop if investition >= . & zinsaufwand >= .
drop gemeinde nr konto funktion betrag

*zusammenfügen der positionen invest und zinsaufwand
collapse (sum) investition zinsaufwand, by(jahr gemeinde1)


/*test
xtset gemeinde1 jahr

//Graphs - zu viele Gemeinden
xtline betrag 
xtline betrag, overlay
*/

/*
//Fixed effects: heterogeneity across entities
bysort gemeinde1: egen y_mean=mean(betrag)
twoway scatter betrag gemeinde1, msymbol(circle_hollow) || connected y_mean gemeinde1, msymbol(diamond)

bysort jahr: egen y_mean1=mean(betrag)
twoway scatter betrag jahr, msymbol(circle_hollow) || connected y_mean1 jahr, msymbol(diamond) || , xlabel(2008(1)2018)
*/


//OLS 
regress investition zinsaufwand jahr gemeinde1
twoway scatter investition zinsaufwand, mlabel(jahr) || lfit investition zinsaufwand, clstyle(p2) 

//FE
xi: regress investition zinsaufwand i.gemeinde1
predict yhat

separate investition, by(gemeinde1)
separate yhat, by(gemeinde1)

/*
twoway connected yhat1-yhat9 zinsaufwand, msymbol(none diamond_hollow triangle_hollow square_hollow + circle_hollow x) msize(medium) mcolor(black black black black black black black) || lfit investition zinsaufwand, clwidth(thick) clcolor(black)
*/

//LSDV
regress investition zinsaufwand jahr gemeinde1
estimates store ols
xi: regress investition zinsaufwand i.gemeinde1
estimates store ols_dum
estimates table ols ols_dum, star stats(N)


//FE using xtreg
xtset gemeinde1 jahr
xtreg investition zinsaufwand, fe





