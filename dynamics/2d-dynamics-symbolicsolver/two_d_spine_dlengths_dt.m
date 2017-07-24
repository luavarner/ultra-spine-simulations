function dlengths_dt_sub = two_d_spine_dlengths_dt(in1)
%TWO_D_SPINE_DLENGTHS_DT
%    DLENGTHS_DT_SUB = TWO_D_SPINE_DLENGTHS_DT(IN1)

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    30-Jun-2017 18:39:39

xi1 = in1(1,:);
xi2 = in1(2,:);
xi3 = in1(3,:);
xi4 = in1(4,:);
xi5 = in1(5,:);
xi6 = in1(6,:);
t4 = sqrt(3.0);
t7 = xi1.*4.0e1;
t9 = t4.*3.0;
t23 = pi.*(1.0./6.0);
t24 = t23+xi3;
t25 = cos(t24);
t2 = t7+t9-t25.*6.0;
t8 = pi.*(1.0./3.0);
t11 = xi2.*4.0e1;
t27 = -t8+xi3;
t28 = cos(t27);
t29 = t28.*6.0;
t3 = t11-t29+3.0;
t5 = sin(xi3);
t6 = cos(xi3);
t12 = t8+xi3;
t35 = sin(t12);
t10 = t7-t9+t35.*6.0;
t31 = cos(t12);
t32 = t31.*6.0;
t13 = t11-t32+3.0;
t14 = xi5.*3.0e1;
t15 = t4.*xi4.*3.0e1;
t16 = xi1.*xi4.*4.0e2;
t17 = xi2.*xi5.*4.0e2;
t18 = t5.*xi4.*3.0e1;
t19 = t5.*xi6.*9.0;
t20 = t6.*xi1.*xi6.*3.0e1;
t21 = t5.*xi2.*xi6.*3.0e1;
t22 = t4.*t5.*xi1.*xi6.*3.0e1;
t34 = xi1.*2.0e1;
t26 = t25.*3.0-t34;
t30 = -t11+t29+3.0;
t33 = -t11+t32+3.0;
t36 = t34+t35.*3.0;
t37 = xi1.*xi4.*8.0e2;
t38 = xi2.*xi5.*8.0e2;
dlengths_dt_sub = [1.0./sqrt(t2.^2+t3.^2).*(t14+t15+t16+t17+t18+t19+t20+t21+t22-t6.*xi5.*3.0e1-t4.*t5.*xi5.*3.0e1-t4.*t6.*xi4.*3.0e1-t4.*t6.*xi2.*xi6.*3.0e1).*(1.0./1.0e1);1.0./sqrt(t10.^2+t13.^2).*(t14-t15+t16+t17+t18+t19+t20+t21-t22-t6.*xi5.*3.0e1+t4.*t5.*xi5.*3.0e1+t4.*t6.*xi4.*3.0e1+t4.*t6.*xi2.*xi6.*3.0e1).*(1.0./1.0e1);1.0./sqrt(t26.^2.*4.0+t30.^2).*(t37+t38-xi5.*6.0e1+t5.*xi4.*6.0e1-t5.*xi6.*(9.0./2.0)-t6.*xi5.*6.0e1-t4.*t5.*xi5.*6.0e1-t4.*t6.*xi4.*6.0e1+t4.*t6.*xi6.*(9.0./2.0)+t5.*xi2.*xi6.*6.0e1+t6.*xi1.*xi6.*6.0e1+t4.*t5.*xi1.*xi6.*6.0e1-t4.*t6.*xi2.*xi6.*6.0e1).*(1.0./2.0e1);1.0./sqrt(t33.^2+t36.^2.*4.0).*(t37+t38-xi5.*6.0e1-t31.*xi5.*1.2e2+t35.*xi4.*1.2e2-t35.*xi6.*9.0+t31.*xi1.*xi6.*1.2e2+t35.*xi2.*xi6.*1.2e2).*(1.0./2.0e1)];
