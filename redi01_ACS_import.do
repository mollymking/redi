capture log close redi01_ACS_import
log using $redi/redi01_ACS_import.log, name(redi01_ACS_import) replace text

//	project:	REDI Methodology Paper

//  task:     	Import data and save to extracted folder
//  data: 		ACS, available: https://usa.ipums.org/

//  github:		redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King

display "$S_DATE  $S_TIME"

***--------------------------***
//  PROGRAM SETUP
***--------------------------***

version 16 // keeps program consistent for future replications
set linesize 80
clear all
set more off

***--------------------------***
// IMPORT DATA
***--------------------------***

// Code to extract is from IPUMS ACS do file for importing data - 
// just have to change working directory to redirect to where store original data
// and change name of .do file to match below

cd $source/80_ACS/
do $redi/usa_00008.do // this is code provided by IPUMS - ACS to import data

*survey weighting according to documentation: https://usa.ipums.org/usa/repwt.shtml
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

***--------------------------***
// CLEAN UP A BIT
***--------------------------***

// RENAME to avoid confusion with CPS ASEC
rename hhincome hhincome_acs

keep if year  == 2016 | year == 2017

***--------------------------***
// SAVE DATA
***--------------------------***

label data "Imported original ACS data"
compress
datasignature set, reset

save $deriv/redi01_ACS.dta, replace

***--------------------------***

log close  redi01_ACS_import
exit
