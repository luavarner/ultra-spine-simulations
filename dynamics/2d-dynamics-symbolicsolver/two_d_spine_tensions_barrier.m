function tensions_sub_barrier = two_d_spine_tensions_barrier(in1,in2)
%TWO_D_SPINE_TENSIONS_BARRIER
%    TENSIONS_SUB_BARRIER = TWO_D_SPINE_TENSIONS_BARRIER(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    19-Jun-2017 11:41:47

u1 = in2(1,:);
u2 = in2(2,:);
u3 = in2(3,:);
u4 = in2(4,:);
xi1 = in1(1,:);
xi2 = in1(2,:);
xi3 = in1(3,:);
xi4 = in1(4,:);
xi5 = in1(5,:);
xi6 = in1(6,:);
t4 = xi1.*4.0e1;
t5 = pi.*(1.0./6.0);
t6 = t5+xi3;
t7 = cos(t6);
t8 = t7.*6.0;
t9 = sqrt(3.0);
t10 = t9.*3.0;
t2 = t4-t8+t10;
t12 = xi2.*4.0e1;
t13 = pi.*(1.0./3.0);
t14 = -t13+xi3;
t15 = cos(t14);
t16 = t15.*6.0;
t3 = t12-t16+3.0;
t11 = t2.^2;
t17 = t3.^2;
t18 = t11+t17;
t19 = sin(xi3);
t20 = cos(xi3);
t21 = sqrt(t18);
t22 = 1.0./sqrt(t18);
t23 = xi5.*3.0e1;
t24 = t9.*xi4.*3.0e1;
t25 = xi1.*xi4.*4.0e2;
t26 = xi2.*xi5.*4.0e2;
t27 = t19.*xi4.*3.0e1;
t28 = t19.*xi6.*9.0;
t29 = t20.*xi1.*xi6.*3.0e1;
t30 = t19.*xi2.*xi6.*3.0e1;
t31 = t9.*t19.*xi1.*xi6.*3.0e1;
t43 = t20.*xi5.*3.0e1;
t44 = t9.*t20.*xi4.*3.0e1;
t45 = t9.*t19.*xi5.*3.0e1;
t46 = t9.*t20.*xi2.*xi6.*3.0e1;
t32 = t23+t24+t25+t26+t27+t28+t29+t30+t31-t43-t44-t45-t46;
t34 = t13+xi3;
t36 = sin(t34);
t37 = t36.*6.0;
t33 = t4-t10+t37;
t39 = cos(t34);
t40 = t39.*6.0;
t35 = t12-t40+3.0;
t38 = t33.^2;
t41 = t35.^2;
t42 = t38+t41;
t47 = sqrt(t42);
t48 = 1.0./sqrt(t42);
t49 = t23-t24+t25+t26+t27+t28+t29+t30-t31-t43+t44+t45+t46;
t52 = xi1.*2.0e1;
t53 = t7.*3.0;
t50 = -t52+t53;
t51 = -t12+t16+3.0;
t54 = t52-t53;
t55 = t51.^2;
t56 = t54.^2;
t57 = t56.*4.0;
t58 = t55+t57;
t59 = xi1.*xi4.*8.0e2;
t60 = xi2.*xi5.*8.0e2;
t61 = t19.*xi4.*6.0e1;
t62 = t9.*t20.*xi6.*(9.0./2.0);
t63 = t20.*xi1.*xi6.*6.0e1;
t64 = t19.*xi2.*xi6.*6.0e1;
t65 = t9.*t19.*xi1.*xi6.*6.0e1;
t70 = xi5.*6.0e1;
t66 = t59+t60+t61+t62+t63+t64+t65-t70-t19.*xi6.*(9.0./2.0)-t20.*xi5.*6.0e1-t9.*t19.*xi5.*6.0e1-t9.*t20.*xi4.*6.0e1-t9.*t20.*xi2.*xi6.*6.0e1;
t67 = sqrt(t58);
t68 = -t12+t40+3.0;
t72 = t36.*3.0;
t69 = t52+t72;
t71 = t68.^2;
t73 = t69.^2;
t74 = t73.*4.0;
t75 = t71+t74;
t76 = 1.0./sqrt(t75);
t77 = t36.*xi4.*1.2e2;
t78 = t39.*xi1.*xi6.*1.2e2;
t79 = t36.*xi2.*xi6.*1.2e2;
t80 = t59+t60-t70+t77+t78+t79-t36.*xi6.*9.0-t39.*xi5.*1.2e2;
t81 = sqrt(t75);
tensions_sub_barrier = [(t21.*5.0e1-u1.*2.0e3+t22.*t32.*5.0)./(exp(t21.*-2.5e4+u1.*1.0e6-t22.*t32.*2.5e3+5.0)+1.0);(t47.*5.0e1-u2.*2.0e3+t48.*t49.*5.0)./(exp(t47.*-2.5e4+u2.*1.0e6-t48.*t49.*2.5e3+5.0)+1.0);(t67.*5.0e1-u3.*2.0e3+1.0./sqrt(t58).*t66.*(5.0./2.0))./(exp(t67.*-2.5e4+u3.*1.0e6-t66.*1.0./sqrt(t55+t50.^2.*4.0).*1.25e3+5.0)+1.0);(t81.*5.0e1-u4.*2.0e3+t76.*t80.*(5.0./2.0))./(exp(t81.*-2.5e4+u4.*1.0e6-t76.*t80.*1.25e3+5.0)+1.0)];
