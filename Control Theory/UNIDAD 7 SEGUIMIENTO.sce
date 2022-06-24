// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE REALIMENTACION DE VARIABLES DE ESTADO
clc;
clear;
close();

//---------REALIMENTACION DE ESTADOS: SISTEMAS DE SEGUIMIENTO-----------------------------------------------

// Modelo continuo
A = [-0.003,0.003;0.0003,-0.0011];
B = [0.5,0;0,0.0008];
C =[0,1];
D =[0,0];
X0 = [0;0];
P1=syslin("c",A,B,C,D,X0);
G1c=ss2tf(P1);

//Modelo discreto
Ts=1;
P2=dscr(P1,Ts);
Ad = P2.a;
Bd = P2.b;
Cd = P2.c;
Dd = P2.d;
G2=ss2tf(P2);

U=cont_mat(P2.a,P2.b)
rank(U)

// Dinamica deseada
Test=600;  // Tiempo de Establecimiento
Psi=1 //Amortiguamiento
Wn=4/(Psi*Test) // Frecuencia Natural
s1=-Psi*Wn+%i*sqrt(1-Psi^2)*Wn
s2=-Psi*Wn-%i*sqrt(1-Psi^2)*Wn
s1;s2
z1=exp(Ts*s1)
z2=exp(Ts*s2)
polos=[z1,z2]

Kt1=ppol(P2.a,P2.b(:,1),polos)
K=[Kt1;[0,0]];

// Modelo realimentado sin ajuste de ganancia
Alc=P2.a-P2.b*K
P3=P2;
P3.a=Alc;
G3=ss2tf(P3)

// Modelo realimentado con ajuste de ganancia
P4=P3;
Ki=horner(G3(1,1),1)          // Ganancia de Lazo Cerrado
A0=1/Ki                          // Ganancia del controlador
B0=P2.b*[A0,0;0,1];
Kt0=Kt1/A0                       // Vector con ajuste de ganancia
P4.b=B0
G4=ss2tf(P4)

// Respuesta transitoria
T = 0:1:5000;
u1=ones(1,length(T));
U=[85*u1;35*u1];
yd=dsimul(P4,U);
figure(1)
plot2d2(T,yd,color("blue"));
plot2d2(T,85*u1,color("red"));
title("Salida del modelo realimentado");
xgrid(color("gray"));

// Modelo ampliado 

Aa=[P2.a [0; 0];-P2.c 1]
Ba=[P2.b(:,1);0]

s3=-10*Psi*Wn
z3=exp(Ts*s3)
polos=[z1,z2,z3]

Kt2=ppol(Aa,Ba,polos)
Ca=[0 1 0];
Da=[0,0];

//  modelo realimentado ampliado
Alc=Aa-Ba*Kt2;
Bf=[[0;0;1],[P2.b(:,2);0]];
P5=syslin("d",Alc,Bf,Ca,Da)

T = 0:1:5000;
u1=ones(1,length(T));
//u1=T
U=[85*u1;45*u1];
yd=dsimul(P5,U);
figure(2)
plot2d2(T,yd,color("blue"));
plot2d2(T,85*u1,color("red"));
title("Salida del modelo de seguimiento");
xgrid(color("gray"));
