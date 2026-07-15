*******************************************************************************
* test_latinobarometro.do
* Pre-submission certification script for the latinobarometro package.
* Run in Stata from the folder containing latinobarometro.ado (or after
* installing it to the adopath). Best run on the OLDEST Stata you can access
* (target: Stata 14) as well as your current version.
*******************************************************************************

clear all
set more off

* --- 1. SSC name-collision check (SSC submission requirement) ----------------
* All three should come back "not found" EXCEPT the first if you've installed
* your own copy locally (in that case it must point to YOUR latinobarometro.ado).
capture program drop latinobarometro
which latinobarometro
cap noi which latinobarometro.class
cap noi ssc type latinobarometro.ado
* (Verified 14jul2026: no "latinobarometro" in the SSC bocode /l/ archive.)

* --- 2. varabbrev off (SSC requirement) ---------------------------------------
set varabbrev off

* --- 3. Sanity: c(sysdir_personal) ends with a path separator -----------------
* The default cache path is built as `c(sysdir_personal)'latinobarometro_cache with no
* separator inserted; confirm homedir supplies one on this OS/version.
local last = substr(c(sysdir_personal), -1, 1)
assert "`last'" == "/" | "`last'" == "\"
di as result "c(sysdir_personal) = `c(sysdir_personal)'  (trailing separator OK)"

* --- 4. Error handling: bad year ----------------------------------------------
cap noi latinobarometro, year(1999)
assert _rc != 0
cap noi latinobarometro, year(banana)
assert _rc != 0

* --- 5. Basic load, one early and one late year -------------------------------
latinobarometro, year(1995)
assert _N > 0
latinobarometro, year(2020)
assert _N > 0

* --- 6. The two pattern-breaking years (2016/2017 use latinobarometro<yr>-dta.zip)
latinobarometro, year(2016)
assert _N > 0
latinobarometro, year(2017)
assert _N > 0

* --- 7. rename option ----------------------------------------------------------
latinobarometro, year(2020) rename
confirm variable X_001
confirm variable X_020

* --- 8. addpopulation (requires wbopendata) -------------------------------------
* First without rename: must fail with the friendly error.
cap noi latinobarometro, year(2020) addpopulation
assert _rc != 0
* Then the real thing:
latinobarometro, year(2020) rename addpopulation
confirm variable wt_lac
confirm variable total_sample
assert wt_lac >= 0 if wt_lac < .

* --- 9. Cache behavior ----------------------------------------------------------
* Second call for a cached year should NOT hit the network (watch the output:
* it must say "Using cached data file").
latinobarometro, year(2020) rename addpopulation local

* --- 10. Version floor ----------------------------------------------------------
* On the Stata 14 machine only: the full run above passing IS the version test.
* Pay attention to (a) copy over https (TLS negotiation can fail on very old
* OS installs) and (b) import excel of the crosswalk.

di as result "ALL TESTS PASSED on Stata `c(stata_version)'"
