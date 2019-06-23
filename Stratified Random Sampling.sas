data elina.birth1;/*Success- to make a new recoded_area column with t area and com area*/
set elina.birth;
length recoded_area $15;
if area= 5 then recoded_area="comparison area";
else recoded_area="treatment area";
run;
/*......success-another way of creating above prog..........*/
proc format;
value rc
1-4="treatment area"
5="comparison area";
run;
proc print data=elina.birth;
format area rc.;
run;
/*.....................................................*/

proc format;
value sex
1="male"
2="female";
run;
proc print data=elina.birth;
format area rc. sex sex.;
run;
data elina.birth1; /*Success- to make a new gender column with Male and female, birth1 shows 2 new addition recoded area and gender*/
set elina.birth1;
length gender $9;
if sex = 1 then gender ="male";
else gender = "female";
run;

proc freq data=elina.birth1; /*Success...chi sq test betn recoded area and gender*/
tables gender*recoded_area/chisq;
run;

data elina.birthdeath1;	/*Success..created birthdeath file */
merge elina.birth1 elina.death;
by crid;
run;
data elina.birthdeath1;	/*Success..aadm colmn created in birthdeath file */
set elina.birthdeath1;
aadm=(DOD-DOB)/30.46;
format aadm 5.2;
run;
proc format;
value aadm
0-<5="under age"
5-<30="middle age"
30-high="over age";
run;
proc print data=elina.birthdeath1;
format aadm aadm.;
run; 
data elina.birthdeath1;	/* unsuccess- recreated the birthdeath1 file with age column but shows only over age, 0-<10 way doesnt work at all*/
set elina.birthdeath1;
length age $16;
if aadm = 0-10 then age="under_age";
else if aadm = 10-30 then age="middle_age";
else age="over_age";
run;
data elina.birthdeath1;	/* PERFECT Success- recreated the birthdeath1 file with age column shows all UG, MG, OG*/
set elina.birthdeath1;
length age $16;
if aadm = <10 then age="under_age";
else if aadm = <30 then age="middle_age";
else age="over_age";
run;
/* Success. Independent sample TTest on aadm by reco area*/
proc ttest data=elina.birthdeath1;
class recoded_area;
var aadm;
run;
proc gchart data=elina.birthdeath1;
pie recoded_area/discrete;
run;
proc gchart data=elina.birthdeath1;
pie recoded_area/discrete value=inside percent=inside slice=inside;
run;

/*Success. pie chart of reco area(TA and CA)*/
proc gchart data=elina.birthdeath1;
pie recoded_area/discrete value=inside percent=inside slice=outside;
run;
/* success- not part of project*/
proc gchart data=elina.birthdeath1;
hbar area/discrete;
run;
/*Success. cross tab of reco area aand gender*/
proc freq data=elina.birthdeath1;
tables recoded_area*gender;
run;
/*Success freq table of recoded area*/
proc freq data=elina.birthdeath1;
tables recoded_area;
run;
/* success- shows result in area 1 2 3 4  */
proc freq data=elina.birthdeath1;
tables area;
where area<=4;
run;
/* success - diff way works same as below*/
proc freq data=elina.birthdeath1;
tables area;
format area rc.;
where area<=4;
run;
/*Success freq table of area without comparison area */
proc freq data=elina.birthdeath1;
tables area;
where area<=4;
format area rc.; 
run;
........................proj done.....................



