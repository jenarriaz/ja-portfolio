PROC IMPORT OUT= WORK.schizchina 
  /*change file name here */ DATAFILE= "/home/u41020973/sasuser.v94/data/sulforaphane matrics spwm diff rev with panss sum pos negJD diff.sav"
            DBMS=SPSS REPLACE;


RUN;

proc contents data=schizchina;
run;

data multidata ;
  set schizchina;
  keep SubNo2 groupcd W2MCCBWorking W12PANSSSUMdiff W24PANSSSUMdiff W2MCCBWorking MATRICSPATWMW12W2DIFF MATRICSPATWMW24W2DIFF ;  
  run;

proc print data=multidata (obs=133); 
run;
*univariate set-up for mixed model;
data unidata;
  set multidata;
  array A(2)MATRICSPATWMW12W2DIFF--MATRICSPATWMW24W2DIFF;
  subject +1;
  do time=1 to 2;
        spwmdiff=A(time);
	output;
  end; 
drop  MATRICSPATWMW12W2DIFF--MATRICSPATWMW24W2DIFF; 
run;

data unidata;
  set unidata;
  
run;

****** Model1 -- Unstructured matrics spwm total  diff,  **********;
proc mixed data=unidata method=ml covtest ;
  class  SubNo2 groupcd time;
  model spwmdiff = W2MCCBWorking W12PANSSSUMdiff  groupcd time  time*groupcd/solution;
  repeated time /subject=SubNo2 type=un r rcorr;
  lsmeans time*groupcd/diffs;
  ods output diffs=groupcdiffs lsmeans=groupcdlsmeans;
  title 'repeated measures  matrics  spwm diff baseline with pansssum w12 w2 diff cov '; 
run;



****** Model1 -- Unstructured matrics spwm total  diff,  **********;
proc mixed data=unidata method=ml covtest ;
  class  SubNo2 groupcd time;
  model spwmdiff = W2MCCBWorking W24PANSSSUMdiff  groupcd time  time*groupcd/solution;
  repeated time /subject=SubNo2 type=un r rcorr;
  lsmeans time*groupcd/diffs;
  ods output diffs=groupcdiffs lsmeans=groupcdlsmeans;
  title 'repeated measures  matrics  spwm diff baseline with pansssum w24 w2 diff cov '; 
run;







