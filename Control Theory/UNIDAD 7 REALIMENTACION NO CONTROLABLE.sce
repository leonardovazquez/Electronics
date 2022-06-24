// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE REALIMENTACION DE VARIABLES DE ESTADO
clc;
clear;
close();

//---------REALIMENTACION DE ESTADOS: CASO COMPLETAMENTE NO CONTROLABLE SISO-----------------------------------------------


// Modelo continuo
A = [-9.259e-4,0,0;1.852e-4,-3.086e-4,3.086e-4;0,9.259e-4,-1.148e-3];
B = [0;0;0.007*6.667e-2];
C =[0,1,0];
D =[0];
X0 = [10;0;0];
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

autovAd=spec(Ad)

U=cont_mat(P2.a,P2.b)
det(U)
rank(U)
U_inv = U^(-1)

q1=[1; 0; 0];
Q=[U(:,1) U(:,2) q1]
rank(Q)
P3=ss2ss(P2,Q);

A11 = P3.a(1:2,1:2)
A12 = P3.a(1:2,3)
A22 = P3.a(3,3)

// SubModelo controlable
P4=syslin("d",P3.a(1:2,1:2),P3.b(1:2,1),P3.c(1,1:2),P3.d(1,1))
U4=cont_mat(P4)
G4 = ss2tf(P4);

// Dinámica deseada
Pz = [0.9867+%i*0.0138,0.9867-%i*0.0138]
Kt1=ppol(P4.a,P4.b,Pz)              // Vector de realimentación del Mcc

Kt1 = [Kt1, 0] 
Kt=Kt1*Q^-1

/*
// Modelo canónico controlable
den=coeff(G4.den)
num=coeff(G4.num)
Acc=[0,1;-den(1),-den(2)];
Bcc=[0;1];
Ccc=[num(1),0];
Dcc=[0];

Pcc=syslin("d",Acc,Bcc,Ccc,Dcc)
Ucc=cont_mat(Pcc)
det(Ucc)

//Matriz Transformación
Qcc_1=Ucc*U4^-1
Qcc = Qcc_1^(-1)

//dinamica deseada
Pz = [0.9867+%i*0.0138,0.9867-%i*0.0138]
Pcr=poly(Pz,"z","roots");    // Polinomio deseado
Pcm=poly(Acc,"z");            // Polinomio de la planta
Pcd=Pcr-Pcm;                 // Diferencia
Ktcc=coeff(Pcd)              // Vector de realimentación del Mcc

Kt2=Ktcc*Qcc_1
Kt2 = [Kt2,0]
Kt = Kt2*Q^-1
*/

// Modelo Realimentado SIN ajuste de ganancia

Ak=Ad-Bd*Kt;
Bk = Bd;
Ck=eye(3,3);
Dk=zeros(3,1);
X0 = [10;0;0];
P3=syslin("d",Ak,Bk,Ck,Dk,X0);


tiempo=[0:Ts:10000]; // Vector de Tiempos
u=ones(1,length(tiempo));
Y=dsimul(P3,u); // Simulación

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
Bk2 = Bd;
Ck2=[0,1,0];
Dk2=[0];
P4=syslin("d",Ak2,Bk2,Ck2,Dk2);
Ki=horner(ss2tf(P4),1)          // Ganancia de Lazo Cerrado
// Ki = Ck2*(eye(3,3)-Ak2)^-1*Bk2
A0=1/Ki                          // Ganancia del controlador
Kt=Kt/A0                       // Vector con ajuste de ganancia

Ak=Ad-Bd*Kt*A0;
Bk = Bd*A0;
Ck=eye(3,3);
Dk=zeros(3,1);
X0 = [10;0;0];
P5=syslin("d",Ak,Bk,Ck,Dk,X0);


tiempo=[0:Ts:10000]; // Vector de Tiempos
u=ones(1,length(tiempo));
Y=dsimul(P5,u); // Simulación

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

Acontrol=Ak      // Matriz de la planta a lazo cerrado
Bcontrol=Bk
Ccontrol=-A0*Kt;
Dcontrol=A0;
Pcontrol=syslin("d",Acontrol,Bcontrol,Ccontrol,Dcontrol); // Modelo de Lazo Cerrado


tiempo=[0:Ts:10000]; // Vector de Tiempos
ru=1*ones(1,length(tiempo));
Y=dsimul(Pcontrol,ru);
figure(3)
plot2d2(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Señal de control')
ylabel("u(k)");



