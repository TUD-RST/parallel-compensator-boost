// Parallel Compensator: Boost Converter Example
//
// K. Röbenack, S. Palis: On the Control of Non-Minimum Phase Systems using a Parallel Compensator
// International Conference on System Theory, Control and Computing (ICSTCC), 
// October 9-11, 2019, Sinaia, Romania
clear;

// physical parameters, see S. Bacha, I. Munteanu, A. I. Bratcu:
// Power Electronic Converters Modeling and Control, Springer, 2014, Section 8.6.1
E=15;
L=0.5E-3;
C=1000E-6;
R=10;

// controller: characteristic polynomial, coeffficients
s=poly(0,'s');
CP=(s+200)*(s+300);
k0=coeff(CP,0);
k1=coeff(CP,1);

// restrictions on the control input (duty cycle)
umin=0.1;
umax=0.9;

// converter and controller model
function dx=converter_controlled(t,x),
// plant: current, voltage
x1=x(1);
x2=x(2);
// parallel compensator
q1=x(3);
q2=x(4);
// integral input: duty cycle
u0=x(5);
// restriction of the duty cycle
u=u0;
if u0>umax then
   u=umax
elseif u<umin then
   u=umin
end;
// reference voltage (from 20V to 25V)
if t<0.2 then
    w=20
else
    w=25
end;
// input udot without restriction
v=  -((C*R^2*u^2-2*C*R^2*u+C*L*R*k1-C^2*L*R^2*k0+C*R^2-L)*x2+L*R*(C*R*k1-1)*(u-1)*x1+2*C^2*L*R^2*k0*w+C*R^2*q2*u^2-R*(2*C*R*q2-C*L*R*k1*q1+L*q1-2*C*E*R)*u+(C*L*R*k1-C^2*L*R^2*k0+C*R^2-L)*q2-L*R*(C*R*k1-1)*q1-2*C*E*R^2)/(C*L*R^2*(x1-3*q1));
// anti-wind-up
udot=v-(u0-u);
// plant (boost converter)
dx1=-(1 - u)*x2/L + E/L;
dx2=(1 - u)*x1/C - x2/(R*C);
// parallel compensator
dq1=(q2*u^2+(E-2*q2)*u+q2-4*L*udot*q1-E)/(L*u-L);
dq2=-(R*q1*u+q2-R*q1)/(C*R);
// integrator on the input
du=v;
// derivative information
dx=[dx1;dx2;dq1;dq2;du];
endfunction;

// ODE solver: Euler forward
function x=euler(x0,t0,t,f),
    n=length(t),
    x=x0;
    for i=1:n-1,
        x0 = x0 + (t(i+1)-t(i))*f(t(i),x0);
        x=[x x0];
    end;
endfunction;

// simulation
N=10000;    // number of steps
T=0.4;      // sampling time in ms 
t=linspace(0,T,N);
//x0=[2.666666666666666 20]';
x0=[2 19 2.667 20 0.25]';
// solving the ODE
x=euler(x0,0,t,converter_controlled);
t=t';
x=x';

// displaying the simulation results
clf;

// current
subplot(3,1,1);
plot2d(1000*t,[x(:,1) x(:,3)]);
ylabel("$\text{Current $x_1$ in A}$");
fig1=gca();
fig1.font_size=4;
fig1.y_label.font_size=5;
fig1.children(1).children(1).thickness=2;
fig1.children(1).children(2).thickness=2;
xgrid();

legend(["Plant","Parallel compensator"]);
leg=gce();
leg.legend_location="in_lower_right";
leg.font_size=5;

// voltage
subplot(3,1,2);
plot2d(1000*t,[x(:,2) x(:,4)]);
ylabel("$\text{Voltage $x_2$ in V}$");
//xlabel("$\text{Time $t$ in ms}$");
fig1=gca();
fig1.font_size=4;
fig1.x_label.font_size=5;
fig1.y_label.font_size=5;
fig1.children(1).children(1).thickness=2;
fig1.children(1).children(2).thickness=2;
xgrid();

// duty cycle
subplot(3,1,3);
plot2d(1000*t,x(:,5));
ylabel("$\text{Duty ratio $u_\text{sat}}$");
xlabel("$\text{Time $t$ in ms}$");
fig1=gca();
fig1.font_size=4;
fig1.x_label.font_size=5;
fig1.y_label.font_size=5;
fig1.children(1).children(1).thickness=2;
fig1.children(1).children(1).foreground=3;
xgrid();

// store the graphic as bitmap file
xs2png(gcf(),"parallel-compensator-boost-converter");
