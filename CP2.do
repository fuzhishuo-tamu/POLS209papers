* Replication Code for "Consequences of Corruption for Political System Support: Evidence from a Brazilian Scandal" 

* Authors: David De Micheli & Whitney Taylor

* Code prepared using StataNow/SE 18.5 for Windows

* Updated on 18 November 2024

* Code below reproduces all estimates presented in the main text and appendix
* Code assumes both .dta files are contained in same directory
* After modifying code to set working directory, code should run without error

clear
cd "INSERT FILE PATH" /* set to directory containing .dta files */
set more off

use "lb2015-brazil_replication.dta", clear

*******************************************************
***** Run this code before estimating models below ****
*** Generate matching weights + set global controls ***
*******************************************************

ssc install ebalance, replace
ssc install rdrobust, replace

* Generate matching weights

ebalance treat_full wealth2 wealth3 wealth4 wealth5 racialid1 racialid2 racialid3 racialid4 racialid5 victim1 region2 region3 region4 region5 educ2 educ3 educ4 religion1 religion2 religion3

* Set controls

global controls = "age female i.educ wealth i.racialid i.religion i.ideo i.partyid i.region trustpolice1 victim1 lifesatisf corrupt1"

global controls2 = "age female i.educ wealth i.racialid i.religion i.ideo partisan trustpolice1 victim1 lifesatisf corrupt1"

global controls_pid = "age female i.educ wealth i.racialid i.religion i.ideo i.region trustpolice1 victim1 lifesatisf corrupt1"

global controls_ideo = "age female i.educ wealth i.racialid i.religion i.partyid i.region trustpolice1 victim1 lifesatisf corrupt1"

global controls_educ = "age female i.partyid wealth i.racialid i.religion i.ideo i.region trustpolice1 victim1 lifesatisf corrupt1"

global rdcovs = "age female educ2 educ3 educ4 wealth2 wealth3 wealth4 wealth5 religion1 religion2 religion3 ideo2 ideo3 ideo4 partyid2 partyid3 partyid4 partyid5 partyid6 region2 region3 region4 region5 trustpolice1 victim1 lifesatisf corrupt1"


********************************************************************************
********************************** MAIN TEXT ***********************************
********************************************************************************

****************
*** Figure 6 ***
****************

*Unweighted - full sample
reg treat_full female age i.educ i.wealth i.racialid trustpolice1 victim1 lifesatisf corrupt1 corrupt2 poltalk i.region i.religion

*Weighted - full sample
reg treat_full female age i.educ i.wealth i.racialid trustpolice1 victim1 lifesatisf corrupt1 corrupt2 poltalk i.region i.religion [aweight=_webal]


****************
*** Figure 7 ***
****************

reg corruption_salience c.treat_full##c.poltalk
margins, at(treat=(0 1) poltalk=(0 1))


****************
*** Figure 8 ***
****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	local label: variable label `x'
	di ""
	di ""
	di ""
	di "Estimates for: `label'"
	quietly reg `x' c.treat_full##c.poltalk $controls [aweight=_webal]
	margins, dydx(treat_full)
	}
*


****************
*** Figure 9 ***
****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	local label: variable label `x'
	di ""
	di ""
	di ""
	di "Estimates for: `label'"
	quietly reg `x' c.treat_full##c.poltalk $controls [aweight=_webal]
	margins, dydx(treat_full) at(poltalk=(0 1))
	}
*

*****************
*** Figure 10 ***
*****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	local label: variable label `x'
	di ""
	di ""
	di ""
	di "Estimates for: `label'"
	quietly reg `x' c.treat_5##c.poltalk $controls [aweight=_webal]
	margins, dydx(treat_5) at(poltalk=(0 1))
	*
	quietly reg `x' c.treat_10##c.poltalk $controls [aweight=_webal]
	margins, dydx(treat_10) at(poltalk=(0 1))
	*
	quietly reg `x' c.treat_full##c.poltalk $controls [aweight=_webal]
	margins, dydx(treat_full) at(poltalk=(0 1))
	}
*


*****************
*** Figure 11 ***
*****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	di ""
	di ""
	di ""
	di "Estimates for: `label'"
	quietly reg `x' c.treat_full##i.partyid i.poltalk $controls_pid [aweight=_webal]
	margins, dydx(treat_full) at(partyid=(1(1)4))
	}
*


*****************
*** Figure 12 ***
*****************

local vars "trustchurch_std trustmilitary_std trusttv_std trustradio_std trustnewspapers_std trustmedia_std"
foreach x of local vars {
	reg `x' treat_full [aweight=_webal]
	reg `x' treat_full poltalk $controls [aweight=_webal]
		}
*


********************************************************************************
******************************** APPENDIX **************************************
********************************************************************************

*****************
*** Figure A1 ***
*****************

* +/- 10 Days
reg treat_10 female age i.educ i.wealth i.racialid trustpolice1 victim1 lifesatisf corrupt1 corrupt2 poltalk i.region i.religion [aweight=_webal]

* +/- 5 Days
reg treat_5 female age i.educ i.wealth i.racialid trustpolice1 victim1 lifesatisf corrupt1 corrupt2 poltalk i.region i.religion [aweight=_webal]

*****************
*** Figure A2 ***
*****************

reg scandal_salience c.treat_full##c.poltalk
margins, at(treat=(0 1) poltalk=(0 1))


****************
*** Table A1 ***
****************

local vars "trustcourt_nr presapproval_nr trustparties_nr trustgovt_nr trustcongress_nr trustelections_nr demsat_nr demval_nr dembest_nr"
foreach x of local vars {
	reg `x' treat_full poltalk $controls [aweight=_webal]
	}
*

*****************
*** Figure A3 ***
*****************

local vars "trustparties dembest"
foreach x of local vars {
	reg `x'_nr poltalk $controls [aweight=_webal] if treat_full == 0
	reg `x'_nr poltalk $controls [aweight=_webal] if treat_full == 1
	}

****************
*** Table A2 ***
****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	reg `x' placebo poltalk $controls
	}
*

*****************
*** Figure A4 ***
*****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	reg `x' i.edate poltalk $controls if runvar < 0 
	margins, at(edate=(20110(1)20123)) post
	}
*

*********************************************
*** See End of Code for Figures A5 and A6 ***
*********************************************


****************
*** Table A3 ***
****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	reg `x' c.treat_full##c.poltalk $controls [aweight=_webal]
	}
*

*****************
*** Figure A7 ***
*****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	quietly reg `x' c.treat_full##i.ideo i.poltalk $controls_ideo [aweight=_webal]
	margins, dydx(treat_full) at(ideo=(1(1)4))
	}
*

*****************
*** Figure A8 ***
*****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	quietly reg `x' c.treat_full##i.educ i.poltalk $controls_educ [aweight=_webal]
	margins, dydx(treat_full) at(educ=(1(1)4))
	}
*

*****************
*** Figure A9 ***
*****************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	quietly reg `x' c.treat_full##i.poltalk##i.partyid $controls_pid [aweight=_webal]
	margins, dydx(treat_full) at(partyid=(1(1)4) poltalk=(0 1))
	}
*

******************
*** Figure A10 ***
******************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	quietly reg `x' c.treat_full##i.poltalk##i.educ $controls_educ [aweight=_webal]
	margins, dydx(treat_full) at(educ=(1(1)4) poltalk=(0 1))
	}
*

******************
*** Figure A11 ***
******************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	quietly reg `x' c.treat_full##i.poltalk##i.ideo $controls_ideo [aweight=_webal]
	margins, dydx(treat_full) at(ideo=(1(1)4) poltalk=(0 1))
	}
*

******************
*** Figure A12 ***
******************

local vars "trustcourt_std trustparties_std  trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	reg `x' c.treat_full##c.poltalk $controls [aweight=_webal] if corruption_salience == 0
	margins, dydx(treat_full) at(poltalk=(0 1)) 
	*
	reg `x' c.treat_full##c.poltalk $controls [aweight=_webal] if corruption_salience == 1
	margins, dydx(treat_full) at(poltalk=(0 1))
	}
*

****************
*** Table A4 ***
****************

local vars "partyid1 partyid2 partyid3 partyid4 partyid5 partyid6"
foreach x of local vars {
	reg `x' c.treat_full##c.poltalk $controls_pid [aweight=_webal]
	margins, dydx(treat_full) at(poltalk=(0 1)) 
	}
*

****************
*** Table A5 ***
****************

reg poltalk c.treat_full [aweight=_webal]
reg poltalk c.treat_10 [aweight=_webal]
reg poltalk c.treat_5 [aweight=_webal]
reg poltalk c.treat_full $controls_pid [aweight=_webal]
reg poltalk c.treat_10 $controls_pid [aweight=_webal]
reg poltalk c.treat_5 $controls_pid [aweight=_webal]

****************
*** Table A6 ***
****************

local vars "trustcourt_std trustparties_std trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	rdrobust `x' runvar if poltalk == 0, kernel(uniform) covs($rdcovs) masspoints(adjust) all weights(_webal) c(0) p(1) bwselect(msetwo)
	}
*

****************
*** Table A7 ***
****************

local vars "trustcourt_std trustparties_std trustgovt_std  trustcongress_std  trustelections_std  presapproval_std demsat1_std demval3_std dembest1_std"
foreach x of local vars {
	rdrobust `x' runvar if poltalk == 1, kernel(uniform) covs($rdcovs) masspoints(adjust) all weights(_webal) c(0) p(1) bwselect(msetwo)
	}
*

**************************************************************
*** Robustness Checks with Expanded Latinobarometer Sample ***
**************************************************************

use "lb2015-expanded_replication.dta", clear

*****************
*** Figure A5 ***
*****************

local vars "trustcourt1 trustparties1 trustgovt1 trustcongress1 trustelections1 presapproval demsat1 demval3 dembest1"
foreach x of local vars {
	local pais "1 2 5 6 15 17 18"
	foreach c of local pais {
		di ""
		di ""
		di ""
		di "COUNTRY: `c' "
		quietly reg `x' c.treat_full##c.poltalk $controls2 if country == `c'
		margins, dydx(treat_full) 
		}
	}
*

*****************
*** Figure A6 ***
*****************

reg trustcourt1 runvar if country == 6
margins, at(runvar=(-17(1)4))

reg trustelections1 runvar if country == 6
margins, at(runvar=(-17(1)4))

reg trustcongress1 runvar if country == 6
margins, at(runvar=(-17(1)4))

reg presapproval runvar if country == 5
margins, at(runvar=(-17(1)4))