ODS graphics ON;
data densities;
input density eggtype temp blockoven;
eggtypetemp = eggtype*temp;
datalines;
0.500 1 325 1
0.510 1 325 1
0.503 1 325 1
0.571 1 350 1
0.571 1 350 1
0.567 1 350 1
0.586 1 375 1
0.536 1 375 1
0.557 1 375 1
0.517 1 325 2
0.526 1 325 2
0.577 1 325 2
0.533 1 350 2
0.516 1 350 2
0.537 1 350 2
0.540 1 375 2
0.561 1 375 2
0.600 1 375 2
0.513 1 325 3
0.539 1 325 3
0.515 1 325 3
0.546 1 350 3
0.561 1 350 3
0.541 1 350 3
0.586 1 375 3
0.561 1 375 3
0.536 1 375 3
0.548 2 325 1
0.531 2 325 1
0.536 2 325 1
0.556 2 350 1
0.566 2 350 1
0.556 2 350 1
0.519 2 375 1
0.577 2 375 1
0.524 2 375 1
0.576 2 325 2
0.588 2 325 2
0.576 2 325 2
0.575 2 350 2
0.556 2 350 2
0.593 2 350 2
0.571 2 375 2
0.577 2 375 2
0.575 2 375 2
0.553 2 325 3
0.610 2 325 3
0.562 2 325 3
0.562 2 350 3
0.544 2 350 3
0.559 2 350 3
0.548 2 375 3
0.574 2 375 3
0.584 2 375 3
0.720 3 325 1
0.720 3 325 1
0.714 3 325 1
0.671 3 350 1
0.671 3 350 1
0.668 3 350 1
0.620 3 375 1
0.682 3 375 1
0.652 3 375 1
0.727 3 325 2
0.721 3 325 2
0.719 3 325 2
0.689 3 350 2
0.691 3 350 2
0.683 3 350 2
0.661 3 375 2
0.642 3 375 2
0.661 3 375 2
0.733 3 325 3
0.711 3 325 3
0.736 3 325 3
0.726 3 350 3
0.710 3 350 3
0.667 3 350 3
0.679 3 375 3
0.684 3 375 3
0.698 3 375 3
;
run;

proc GLM;
Title 'Density of Muffin ANOVA'; class eggtype temp blockoven;
model density=eggtype temp blockoven eggtype*temp; output out=density_out p=yhat r=resid;
Proc gplot;
plot resid*yhat='R' / vref=0 ;
plot resid*eggtype='R' / vref=0 ; plot resid*temp='R' / vref=0 ;
plot resid*blockoven='R' / vref=0 ; run;

proc univariate normal; var resid;
run;
proc rank normal=vw; /* Computing ranked normal scores by residuals*/ var resid;
ranks nscore; run;
proc plot ;
plot resid*nscore='R'; /*plotting ranked residual vs. normal score*/ label nscore='Normal Score'; run;
quit;
*Levene's tests;
proc glm data=densities;
Title 'Density of Muffin ANOVA';
class eggtype temp blockoven;
model density=eggtype;
means eggtype / hovtest=levene tukey; run;
proc glm data=densities;
Title 'Density of Muffin ANOVA';
class eggtype temp blockoven;
model density=temp;
means temp / hovtest=levene tukey;
run;
proc glm data=densities;
Title 'Density of Muffin ANOVA';
class eggtype temp blockoven;
model density=blockoven;
means blockoven / hovtest=levene tukey; run;

proc glm data=densities;
Title 'Density of Muffin ANOVA';
class eggtype temp blockoven eggtypetemp ; model density= eggtypetemp;
means eggtypetemp / hovtest=levene tukey; run;
/* effects plots */
symbol interpol=hilotj
value=star
color=dev;
proc gplot data=densities;
title “Main Effect plot for Egg Type”; run;
proc sgplot data=densities;
title ‘Interaction plot between Eggtype and Temperature’; vline eggtype / response=density group=temp;
run;
proc univariate data=densities;
title ‘Histogram’;
histogram; run;