// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE REALIMENTACION DE VARIABLES DE ESTADO
clc;
clear;
close();

//---------REALIMENTACION DE ESTADOS: CASO COMPLETAMENTE CONTROLABLE MIMO-----------------------------------------------

// Modelo continuo
A = [-0.0009259,0,0;0.0001852,-0.0003086,0.0003086;0,0.0009259,-0.0011481];
B = [0.0833333,0;0,0;0,0.0666667];
C =[0,1,0];
D =[0,0];
X0 = [0;0;0];
P1=syslin("c",A,B,C,D,X0);
G1c=ss2tf(P1);

//Modelo discreto
Ts=10;
P2=dscr(P1,Ts);
Ad = P2.a;
Bd = P2.b;
Cd = P2.c;
Dd = P2.d;
G2=ss2tf(P2);

U=cont_mat(P2.a,P2.b)
rank(U)


// Determinación de la Entrada Ficticia
F=[1;1]
B3=Bd*F;
D3=Dd*F;
P3=syslin("d",Ad,B3,Cd,D3)
U3=cont_mat(P3)
rank(U3)

// Dinámica deseada
SP=0.05;
Test=3000;
//Psi=1
Psi= sqrt((log(SP))^2/((log(SP))^2+%pi^2))
Wn = 4/(Psi*Test)

p1 = -Psi*Wn+%i*Wn*sqrt(1-Psi^2)
p2 = -Psi*Wn-%i*Wn*sqrt(1-Psi^2)
p3 = -10*Psi*Wn

Pz=[exp(p1*Ts),exp(p2*Ts),exp(p3*Ts)]
Kt1=ppol(P3.a,P3.b,Pz)              // Vector de realimentación del Mcc

Kt=F*Kt1


// Modelo Realimentado SIN ajuste de ganancia

Ak=Ad-Bd*Kt;
Bk = Bd(1:3,1:2);
Ck=eye(3,3);
Dk=zeros(3,2);
P4=syslin("d",Ak,Bk,Ck,Dk);

tiempo=[0:Ts:10000]; // Vector de Tiempos
u2=ones(1,length(tiempo));
u1=zeros(1,length(tiempo));
u=[u1;u2];
Y=dsimul(P4,u); // Simulación

figure(1)
subplot(3,1,1)
plot2d2(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado: sin ajuste A0')
ylabel("X1");
subplot(3,1,2)
plot2d2(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("X2");
subplot(3,1,3)
plot2d2(tiempo,Y(3,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("X3");

// Modelo Realimentado CON ajuste de ganancia

Ak2=Ad-Bd*Kt;
Bk2 = Bd(1:3,1:2);
Ck2=[0,1,0];
Dk2=[0,0];
P5=syslin("d",Ak2,Bk2,Ck2,Dk2);
//Ki=horner(ss2tf(P5),1)          // Ganancia de Lazo Cerrado
Ki = Ck2*(eye(3,3)-Ak2)^-1*Bk2(1:3,1)
A0=1/Ki                          // Ganancia del controlador
Kt=Kt/A0                       // Vector con ajuste de ganancia

Ak=Ad-Bd*Kt*A0;
Bk = Bd(1:3,1:2)*A0;
Ck=eye(3,3);
Dk=zeros(3,2);
P6=syslin("d",Ak,Bk,Ck,Dk);


tiempo=[0:Ts:10000]; // Vector de Tiempos
u2=ones(1,length(tiempo));
u1=zeros(1,length(tiempo));
u=[u1;u2];
Y=dsimul(P6,u); // Simulación

figure(2)
subplot(3,1,1)
plot2d2(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado: con ajuste A0')
ylabel("X1");
subplot(3,1,2)
plot2d2(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("X2");
subplot(3,1,3)
plot2d2(tiempo,Y(3,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("X3");


// Modelo del control

Acontrol=Ak;      // Matriz de la planta a lazo cerrado
Bcontrol=Bk;
Ccontrol=-A0*Kt;
Dcontrol=[A0,0;0,1];
Pcontrol=syslin("d",Acontrol,Bcontrol,Ccontrol,Dcontrol); // Modelo de Lazo Cerrado


tiempo=[0:Ts:20000]; // Vector de Tiempos
u2=ones(1,length(tiempo));
u1=zeros(1,length(tiempo));
u=[u1;u2];
Y=dsimul(Pcontrol,u); // Simulación

figure(3)
subplot(2,1,1)
plot2d2(tiempo,Y(1,:),color("scilabgreen4"));
xgrid(color("gray"))
title('Variables de control')
ylabel("Control 1");
subplot(2,1,2)
plot2d2(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("Control 2");



