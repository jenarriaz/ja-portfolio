
PROC IMPORT OUT= WORK.autismchina 
 /*change file location here*/ DATAFILE= "C:\Users\jenarriaza\SAS Files\Data\OSU r6 all sub ageclass rev2.sav"
 
            DBMS=SPSS REPLACE;

RUN;
title;

proc contents data=autismchina; 
run;

data multidata ;
  set autismchina;
  keep SUBNUM DRUGCODEN communicationbarriersavdiffv1mb communicationbarriersavdiffv2mb communicationbarriersavdiffv3mb communicationbarriersBaselineave IIDscoire;  
  run;

proc print data=multidata (obs=92); 
run;
*univariate set-up for mixed model;
data unidata;
  set multidata;
  array A(3)communicationbarriersavdiffv1mb--communicationbarriersavdiffv3mb;
  subject +1;
  do time=1 to 3;
        osucommbarrtotdiff=A(time);
	output;
  end; 
drop communicationbarriersavdiffv1mb--communicationbarriersavdiffv3mb; 
run;

data unidata;
  set unidata;
  
run;


  ****** Model1 -- Unstructured osu  diff -measure model,  **********;
proc mixed data=unidata method=ml covtest;
  class SUBNUM DRUGCODEN time IIDscoire;
  model osucommbarrtotdiff= communicationbarriersBaselineave DRUGCODEN time  IIDscoire time*DRUGCODEN IIDscoire*DRUGCODEN IIDscoire*time*DRUGCODEN/solution;
  repeated time /subject=SUBNUM type=un r rcorr;
  lsmeans time*DRUGCODEN/diffs;
  lsmeans time*DRUGCODEN/diffs;
  lsmeans IIDscoire*DRUGCODEN*time/diffs;
    ods output diffs=drugdiffs lsmeans=druglsmeans;
  title 'repeated measures osu r6 communication barriers IDscore tot diff unstructured model with baseline cov'; 
run;
