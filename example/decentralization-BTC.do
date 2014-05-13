*hay que hacer el cleaning de los paises
*tambien el de las variables con pocos datos

*______________________________________________________
set maxvar 5000
clear all
capture log close
capture drop
capture cmdlog close
capture label variable
set more off
pwd
mata: mata set matafavor speed, perm
*pwd=mi current directory es
cd "~/Dropbox/Federalism_Innovation/data/"
pwd
cd "Logs/"
log using btc_decentralization_all.log, append
cmdlog using btc_decentralization_cmds.log, append
cd ..
*---------------------------------


use "~/Dropbox/PhD/Research/productivity/Stata-Databasing/databases/KLEMS-FINAL/klems-final-march2014ppp-sectorclear.dta", clear

*use "/home/rhok/Dropbox/PhD/Research/productivity/Stata-Databasing/databases/KLEMS-FINAL/klems-final-march2014ppp-sectorclear-koreafixed.dta", clear
drop countries








*====================================================================================
*====================================================================================
*======TFP
*====================================================================================
*====================================================================================


foreach v in _high _medhigh _medlow _low    {
  gen wage`v' = oecd`v'_avg__var09/oecd`v'_avg__var11
  gen L`v' = oecd`v'_avg__var11
  gen Y`v' = oecd`v'_avg__var52
  gen K`v' = oecd`v'_avg__var08
  gen alpha`v' = (wage`v'*L`v'/Y`v')
  gen beta`v' = 1 - alpha`v'
  gen TFP_Solow_`v'=log(Y`v')-alpha`v'*(log(L`v'))-beta`v'*(log(K`v'))
}


*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*OPEN SECTORS:
  foreach v in  sec107 {
  gen wage_`v' = `v'_var09/`v'_var11
  gen L_`v' = `v'_var11
  gen Y_`v' = `v'_var52
  gen K_`v' = `v'_var08
  gen alpha_`v' = (wage_`v'*L_`v'/Y_`v')
  gen beta_`v' = 1 - alpha_`v'
  gen TFP_Solow_`v'=log(Y_`v')-alpha_`v'*(log(L_`v'))-beta_`v'*(log(K_`v'))
    }

*check by sector:
*   foreach v in  sec107 {
*    by paises, sort: tab  wage_`v'
*    by paises, sort: tab  L_`v'
*    by paises, sort: tab  Y_`v'
*    by paises, sort: tab  K_`v'
*    by paises, sort: tab  alpha_`v'
*    }
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




*TFP SOLOW GROWTH: para el ranking NO PARA EL FIXED TFP
   xtset country year
  foreach v in  sec107 {
            by paises, sort:  gen lag1_TFP_Solow_`v' = TFP_Solow_`v'[_n-1]
            by paises, sort:  gen TFP_iSolow_`v' = (TFP_Solow_`v' - lag1_TFP_Solow_`v')/lag1_TFP_Solow_`v'
           *TFP_iSolow_`v' parcialmente inservible, porque es el cambio porcentual que puede ser positivo o negativo
            *by paises, sort:  gen index_TFP_iSolow_`v' = 1+TFP_iSolow_`v'
          *este ultimo no tiene sentido
          ************************cambio % del tfp de solow en index.
          }

*graph bar TFP_iSolow_sec69 , over(time) by(country)
*graph bar index_TFP_iSolow_sec69 , over(time) by(country)


       foreach v in _high _medhigh _medlow _low    {
            by paises, sort:  gen lag1_TFP_Solow_`v' = TFP_Solow_`v'[_n-1]
            by paises, sort:  gen index_TFP_iSolow_`v' = 1+(TFP_Solow_`v' - lag1_TFP_Solow_`v')/lag1_TFP_Solow_`v'
*            by paises, sort: gen TFP_iSolow_`v' = (TFP_Solow_`v' - lag1_TFP_Solow_`v')/lag1_TFP_Solow_`v'
            ************************cambio % del tfp de solow en index.
            *by paises, sort: gen absolute_change_TFP_iSolow_`v' = (TFP_Solow_`v' - lag1_TFP_Solow_`v')
            *by paises, sort: gen absoluteTFP_iSolow_`v' = TFP_Solow_`v' - lag1_TFP_Solow_`v'
            }







*==================================================================================
*Con año base 1973: todo al mismo año base
*==================================================================================

*FIXED TFP BASE 73
    foreach v in  sec107 {
        *TFP_iSolow_ base (cambia año en dos lugares!)
        by paises, sort: gen TFPsw_base`v' = TFP_Solow_`v' if year==1973
                egen TFPbase`v' = min(TFPsw_base`v'), by(paises)
        by paises, sort: gen TFP_iSolow_73_`v' = (TFP_Solow_`v' - TFPbase`v')/TFPbase`v'
        by paises, sort: gen index_TFP_iSolow_73_`v' = 1+TFP_iSolow_73_`v'
}

*FIXED TFP BASE 73: PARA TFP growth!!!
        foreach v in _high _medhigh _medlow _low    {
        *TFP_iSolow_ base (cambia año en dos lugares!)
        by paises, sort: gen TFPsw_base`v' = TFP_Solow_`v' if year==1973
                egen TFPbase`v' = min(TFPsw_base`v'), by(paises)
        by paises, sort: gen TFP_iSolow_73_`v' = (TFP_Solow_`v' - TFPbase`v')/TFPbase`v'
        by paises, sort: gen index_TFP_iSolow_73_`v' = 1+TFP_iSolow_73_`v'
}






*FIXED TFP (Total TFP) Con año base 1973
*==================================================================================

*alpha_beta base
    foreach v in  sec107 {
by paises, sort: gen alpha_1_base`v' = alpha_`v' if year==1973
egen alpha_base`v' = min(alpha_1_base`v'), by(paises)
by paises, sort: gen beta_1_base`v' = beta_`v' if year==1973
egen beta_base`v' = min(beta_1_base`v'), by(paises)
    *1t lags:
by paises, sort:  gen lag1_alpha`v' = alpha_`v'[_n-1]
by paises, sort:  gen lag1_beta`v' = beta_`v'[_n-1]
}


*alpha_beta base
        foreach v in _high _medhigh _medlow _low    {
by paises, sort: gen alpha_1_base`v' = alpha`v' if year==1973
egen alpha_base`v' = min(alpha_1_base`v'), by(paises)
by paises, sort: gen beta_1_base`v' = beta`v' if year==1973
egen beta_base`v' = min(beta_1_base`v'), by(paises)
    *1t lags:
by paises, sort:  gen lag1_alpha`v' = alpha`v'[_n-1]
by paises, sort:  gen lag1_beta`v' = beta`v'[_n-1]
}



*TRUE FIXED TFP: base 1973
    foreach v in  sec107 {
                by paises, sort:  gen FixedTFP_`v'=log(Y_`v')- alpha_base`v'*(log(L_`v'))- beta_base`v'*(log(K_`v'))
                by paises, sort: gen index_FixedTFP`v' = FixedTFP_`v' if year==1973
                        egen FixedTFPbase`v' = min(index_FixedTFP`v'), by(paises)
                by paises, sort: gen FixedTFP_73_`v' = 1+((FixedTFP_`v' - FixedTFPbase`v')/FixedTFPbase`v')
                }



foreach v in _high _medhigh _medlow _low    {
                *FixedTFP
                by paises, sort:  gen FixedTFP`v'=log(Y`v')- alpha_base`v'*(log(L`v'))- beta_base`v'*(log(K`v'))
                by paises, sort: gen index_FixedTFP`v' = FixedTFP`v' if year==1973
                        egen FixedTFPbase`v' = min(index_FixedTFP`v'), by(paises)
                by paises, sort: gen FixedTFP_73_`v' = 1+((FixedTFP`v' - FixedTFPbase`v')/FixedTFPbase`v')
                *it lag: by paises, sort: gen index_FixedTFP`v' = 1+(FixedTFP`v' - FixedTFP`v'[_n-1])/FixedTFP`v'[_n-1]
                *it lag: by paises, sort: gen change_FixedTFP`v' = (FixedTFP`v' - FixedTFP`v'[_n-1])/FixedTFP`v'[_n-1]

                *bro FixedTFP_73__*
                }


*==================================================================================

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------










*========================================================
*BTC
*========================================================

    foreach v in  sec107 {
                by paises, sort:        gen pure_BTC_`v'= (FixedTFP_73_`v'-TFP_iSolow_73_`v')-1
                by paises, sort:        gen BTC`v'= FixedTFP_73_`v'-TFP_iSolow_73_`v'
                by paises, sort:        gen iBTC`v'= FixedTFP_73_`v'/index_TFP_iSolow_73_`v'
                by paises, sort:        gen change_BTC`v' = (BTC`v' - BTC`v'[_n-1])/BTC`v'[_n-1]
        }



foreach v in _high _medhigh _medlow _low    {
                by paises, sort:  gen pure_BTC`v'= (FixedTFP_73_`v'-TFP_iSolow_73_`v')-1
                by paises, sort:  gen BTC`v'= FixedTFP_73_`v'-TFP_iSolow_73_`v'
                by paises, sort:  gen iBTC`v'= FixedTFP_73_`v'/index_TFP_iSolow_73_`v'
                by paises, sort:  gen change_BTC`v' = (BTC`v' - BTC`v'[_n-1])/BTC`v'[_n-1]
        }

*====================================================================



















*================================================================================
*indicators
*================================================================================

*====================================================================


foreach v in _high _medhigh _medlow _low  sec107  {

by paises, sort: gen dual_positive_BTC`v'=.
by paises, sort: replace dual_positive_BTC`v'=1 if BTC`v'>=1
by paises, sort: replace dual_positive_BTC`v'=0 if BTC`v'<1
by paises, sort:  gen netperc_BTC`v'= BTC`v' -1


*pure_BTC: es para los indicadores, -1 porque le sacamos el indexing.
egen tot_positive_BTC`v'=rowtotal(BTC`v') if BTC`v' >=1
egen mean_positive_BTC`v'=rowmean(BTC`v') if BTC`v' >=1
egen mean_negative_BTC`v'=rowmean(BTC`v') if BTC`v'<1
egen tot_negative_BTC`v'=rowtotal(BTC`v') if BTC`v'<1
by year, sort: egen mean_BTC`v'=mean(BTC`v')
}


foreach v in _high _medhigh _medlow _low   sec107  {
by paises (year), sort: gen cum_positive_BTC`v'= sum(BTC`v') if BTC`v'>=1
by paises (year), sort: gen cum_negative_BTC`v'= sum(BTC`v') if BTC`v'<1
by paises (year), sort: gen cum_net_BTC`v'= sum(BTC`v')
gen log_cum_net_BTC`v'= log(cum_net_BTC`v')

}





















*______________________________________________________
*LAGS
*______________________________________________________


*Other LAGS for the regression (dentro del loop)
*-------------------------------------------------------------------------

foreach v in _high _medhigh _medlow _low _sec107   {
*wage
by paises, sort: gen wage`v'_lag1 = wage`v'[_n-1]
by paises, sort: gen wage`v'_lag2 = wage`v'[_n-2]
by paises, sort: gen log_wage`v' = log(wage`v')
by paises, sort: gen log_wage`v'_lag1 = log(wage`v'_lag1)
by paises, sort: gen log_wage`v'_lag2 = log(wage`v'_lag2)
*tfp: FixedTFP
by paises, sort:  gen FixedTFP`v'_lag1=FixedTFP`v'[_n-1]
by paises, sort:  gen FixedTFP`v'_lag2=FixedTFP`v'[_n-2]
}


foreach v in _high _medhigh _medlow _low sec107   {

*tfp: BTC
by paises, sort:  gen BTC`v'_lag1=BTC`v'[_n-1]
by paises, sort:  gen BTC`v'_lag2=BTC`v'[_n-2]
*tfp: Solow
by paises, sort:  gen TFP_iSolow_73_`v'_lag1=TFP_iSolow_73_`v'[_n-1]
by paises, sort:  gen TFP_iSolow_73_`v'_lag2=TFP_iSolow_73_`v'[_n-2]

*cumulated BTC dual: Solow
by paises, sort:  gen dual_positive_BTC`v'_lag1=dual_positive_BTC`v'[_n-1]
by paises, sort:  gen dual_positive_BTC`v'_lag2=dual_positive_BTC`v'[_n-2]

*cumulated BTC dual: Solow
by paises, sort:  gen cum_net_BTC`v'_lag1=cum_net_BTC`v'[_n-1]
by paises, sort:  gen cum_net_BTC`v'_lag2=cum_net_BTC`v'[_n-2]
by paises, sort:  gen log_cum_net_BTC`v'_lag1=log_cum_net_BTC`v'[_n-1]
by paises, sort:  gen log_cum_net_BTC`v'_lag2=(log_cum_net_BTC`v'[_n-2])

}


*Lag L
foreach v in _high _medhigh _medlow _low _sec107   {
*logs knowledge stock in human capital
by paises (year), sort: gen log_L`v'_sum=log(sum(L`v'))
*Lags
by paises, sort:  gen L`v'_lag1=L`v'[_n-1]
by paises, sort:  gen L`v'_lag2=L`v'[_n-2]
by paises, sort:  gen L`v'_lag3=L`v'[_n-3]
by paises, sort:  gen L`v'_lag4=L`v'[_n-4]
by paises, sort:  gen L`v'_lag5=L`v'[_n-5]
}


drop sec10* sec14* sec18* sec20* sec24* sec26* sec29* sec30* sec32* sec34* sec36* sec49* sec55* sec69* sec75* sec88* sec92* sec93* sec95*  *var90

save "~/Dropbox/Federalism_Innovation/data/BTC-Klems-cleaned.dta", replace





***************merge decentralization data

egen merge_country_year = concat(country year)
sort merge_country_year
drop _merge
*"~/Dropbox/Federalism_Innovation/data/RawDATA/decentralization-data-to-merge.dta"
merge 1:1 merge_country_year  using "~/Dropbox/Federalism_Innovation/data/RawDATA/decentralization-data-to-merge.dta"
*        merge 1:1 varlist using filename [, options]
drop if _merge == 1
drop _merge paises_string merge_country_year

**********************************************



**********indicators:
*************************************************************+

*std dev
by paises, sort: sum BTCsec107


        *sd(exp)
            *creates a constant (within varlist) containing the standard deviation of exp.  Also see
            *mean().
*
        *mdev(exp)
            *returns the mean absolute deviation from the mean (within varlist) of exp.
*
*
        *mad(exp)
            *returns the median absolute deviation from the median (within varlist) of exp.


egen BTCsec107_sd = sd(BTCsec107), by(paises)
egen BTCsec107_ad = mdev(BTCsec107), by(paises)
egen BTCsec107_adm = mad(BTCsec107), by(paises)

gen BTCsec107_mod = BTCsec107
if BTCsec107 < 0 replace BTCsec107_mod == BTCsec107*(-1)
gen BTCsec107_log_mod = log(BTCsec107_mod)


gen period2 = .
replace period2 = 1 if year < 1996
replace period2 = 2 if year >= 1996

gen period3 = .
replace period3 = 1 if year < 1992
replace period3 = 2 if year >= 1992
replace period3 = 3 if year > 1998

egen BTCsec107_sd_pdual = sd(BTCsec107), by(paises), if period2 == 1
egen BTCsec107_sd_pdual_temp = sd(BTCsec107), by(paises), if period2 == 2
replace BTCsec107_sd_pdual = BTCsec107_sd_pdual_temp if period2 == 2
drop BTCsec107_sd_pdual_temp



egen BTCsec107_sd_ptriple = sd(BTCsec107), by(paises), if period3 == 1
egen BTCsec107_sd_ptriple_temp = sd(BTCsec107), by(paises), if period3 == 2
replace BTCsec107_sd_ptriple = BTCsec107_sd_ptriple_temp if period3 == 2
drop BTCsec107_sd_ptriple_temp
egen BTCsec107_sd_ptriple_temp = sd(BTCsec107), by(paises), if period3 == 3
replace BTCsec107_sd_ptriple = BTCsec107_sd_ptriple_temp if period3 == 3
drop BTCsec107_sd_ptriple_temp

egen tax_statepluslocal = rowtotal(tax_rev_prop_gdp_state tax_rev_prop_gdp_local)
gen tax_ratio = tax_rev_prop_gdp_central / (tax_statepluslocal)

egen tax_total = rowtotal(tax_rev_prop_gdp_state tax_rev_prop_gdp_local tax_rev_prop_gdp_central)
gen tax_centrality = tax_rev_prop_gdp_central / (tax_total)



*BTCsec107_sd
*BTCsec107_ad
*BTCsec107_adm
*BTCsec107_mod

stop before regressions



*Regressions:
*************

*wage_sec107
*alpha_1_basesec107
*alpha_basesec107
*alpha_sec107
*beta_1_basesec107
*beta_basesec107
*beta_sec107
*BTCsec107
*BTCsec107_lag1
*BTCsec107_lag2
*change_BTCsec107
*cum_negative_BTCsec107
*cum_net_BTCsec107
*cum_net_BTCsec107_lag1
*cum_net_BTCsec107_lag2
*cum_positive_BTCsec107
*dual_positive_BTCsec107
*dual_positive_BTCsec107_lag1
*dual_positive_BTCsec107_lag2
*FixedTFP_73_sec107
*FixedTFP_sec107
*FixedTFP_sec107_lag1
*FixedTFP_sec107_lag2
*FixedTFPbasesec107
*iBTCsec107
*index_FixedTFPsec107
*index_TFP_iSolow_73_sec107
*K_sec107
*L_sec107
*L_sec107_lag1
*L_sec107_lag2
*L_sec107_lag3
*L_sec107_lag4
*L_sec107_lag5
*lag1_alphasec107
*lag1_betasec107
*lag1_TFP_Solow_sec107
*log_cum_net_BTCsec107
*log_cum_net_BTCsec107_lag1
*log_cum_net_BTCsec107_lag2
*log_L_sec107_sum
*log_wage_sec107
*log_wage_sec107_lag1
*log_wage_sec107_lag2
*mean_BTCsec107
*mean_negative_BTCsec107
*mean_positive_BTCsec107
*netperc_BTCsec107
*pure_BTC_sec107

*TFP_iSolow_73_sec107
*TFP_iSolow_73_sec107_lag1
*TFP_iSolow_73_sec107_lag2
*TFP_iSolow_sec107
*TFP_Solow_sec107
*TFPbasesec107
*TFPsw_basesec107

*tot_negative_BTCsec107
*tot_positive_BTCsec107
*wage_sec107_lag1
*wage_sec107_lag2
*Y_sec107


*BTCsec107_sd
*BTCsec107_ad
*BTCsec107_adm
*BTCsec107_mod



*basic no taxes
xtset country year
*xtreg BTCsec107 l1.Y_sec107 l1.BTCsec107 l1.wage_sec107 l1.TFP_iSolow_73_sec107, fe
*xtreg BTCsec107 l1.Y_sec107 l1.wage_sec107 l2.TFP_iSolow_73_sec107, fe
xtreg BTCsec107 l1.Y_sec107 l1.wage_sec107, fe


*taxes all
*foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_gdp_state tax_rev_prop_gdp_local tax_rev_prop_ttaxes_central tax_rev_prop_ttaxes_state tax_rev_prop_ttaxes_local {
*xtreg BTCsec107_mod l1.Y_sec107 wage_sec107 `var', fe
*}


*taxes polite
foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtreg BTCsec107_mod l1.Y_sec107 l1.wage_sec107 `var', fe
}

foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_mod l1.Y_sec107 l1.wage_sec107 l1.`var' i.year, fe
}

foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_mod l(1).wage_sec107 l(0/4).`var' , fe
}


foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_sd_pdual l(1).wage_sec107 l(0/4).`var' , fe
}

foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_sd_pdual l(0/5).`var' i.year, fe
}


foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_sd_ptriple l(0/5).`var' l1.Y_sec107 l(1).wage_sec107 i.year, fe
}


foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_mod l(0/5).`var' l1.Y_sec107 l(1).wage_sec107 i.year, fe
}



foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_log_mod l(0/5).`var' l(1).wage_sec107 i.year, fe
}


foreach var of varlist tax_rev_prop_gdp_central tax_rev_prop_ttaxes_central {
xtset country year
xtreg BTCsec107_log_mod l(5).`var' l(1).wage_sec107 i.year, fe
}



*belli
xtreg BTCsec107_log_mod l(1/5).tax_ratio l(1).wage_sec107 i.year, fe
xtreg BTCsec107_log_mod l(1/5).tax_ratio l(1).wage_sec107 l1.Y_sec107 i.year, fe

xtreg BTCsec107_mod l(1/5).tax_ratio l(1).wage_sec107 l1.Y_sec107 i.year, fe
xtreg BTCsec107_mod l(1/5).tax_ratio l(1).wage_sec107 l1.TFP_iSolow_73_sec107 i.year, fe

xtreg BTCsec107_sd_ptriple l(1/5).tax_ratio l1.Y_sec107 l(1).wage_sec107 i.year, fe
xtreg BTCsec107_sd_pdual l(1/5).tax_ratio l1.Y_sec107 l(1).wage_sec107 i.year, fe





*double check con contrality
xtreg BTCsec107_log_mod l(1/5).tax_centrality l(1).wage_sec107 i.year, fe
xtreg BTCsec107_mod l(1/5).tax_centrality l(1).wage_sec107 i.year, fe
xtreg BTCsec107_sd_ptriple l(1/5).tax_centrality l(1).wage_sec107 i.year, fe
xtreg BTCsec107_sd_pdual l(1/5).tax_centrality l(1).wage_sec107 i.year, fe
