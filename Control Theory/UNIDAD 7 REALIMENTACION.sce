// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE REALIMENTACION DE VARIABLES DE ESTADO
clc;
clear;
close();

//---------REALIMENTACION DE ESTADOS: CASO COMPLETAMENTE CONTROLABLE SISO-----------------------------------------------

// Modelo continuo
A = [-1,5,0;0,0,-1;-3,1,-2];
B = [1;0;0];
C =[1,0,0];
D =[0];
X0 = [0;0;0];
P1=syslin("c",A,B,C,D,X0);
G1c=ss2tf(P1);

//Modelo discreto
Ts=0.1;
P2=dscr(P1,Ts);
Ad = P2.a;
Bd = P2.b;
Cd = P2.c;
Dd = P2.d;
G2=ss2tf(P2);

U=cont_mat(P2.a,P2.b)
det(U)
rank(U)
U_inv = U^(-1)

// Modelo canónico controlable
den=coeff(G2.den)
num=coeff(G2.num)
Acc=[0,1,0;0,0,1;-den(1),-den(2),-den(3)];
Bcc=[0;0;1];
Ccc=[num(1),num(2),0];
Dcc=[0];

Pcc=syslin("d",Acc,Bcc,Ccc,Dcc)
Ucc=cont_mat(Pcc)
det(Ucc)

//Matriz Transformación
Qcc_1=Ucc*U^-1
Qcc = Qcc_1^(-1)

// Modelo transformado
At=Qcc_1*Ad*Qcc
Bt=Qcc_1*Bd
Ct=C*Qcc
Dt = Dd

Pt=ss2ss(P2,Qcc)

// Dinámica deseada
SP=0.09;
Psi= sqrt((log(SP))^2/((log(SP))^2+%pi^2));
//Psi= 0.46;
tau = 2;
Wn = 1/(Psi*tau);
p1 = -Psi*Wn+%i*Wn*sqrt(1-Psi^2)
p2 = -Psi*Wn-%i*Wn*sqrt(1-Psi^2)
p3 = 10*(-Psi*Wn)

Pz=[exp(p1*Ts),exp(p2*Ts),exp(p3*Ts)]
Pcr=poly(Pz,"z","roots");    // Polinomio deseado
Pcm=poly(Ad,"z");            // Polinomio de la planta
Pcd=Pcr-Pcm;                 // Diferencia
Ktcc=coeff(Pcd)              // Vector de realimentación del Mcc
// Ktcc=ppol(Ac,Bc,Pz) // otra forma

Kt=Ktcc*Qcc_1     // Vector de realimentación deseado
//Kt=ppol(Ad,Bd,Pz)   // otra forma 

// Modelo Realimentado CON ajuste de ganancia

Ak=Ad-Bd*Kt;
Bk = Bd;
Ck=eye(3,3);
Dk=zeros(3,1);
P3=syslin("d",Ak,Bk,Ck,Dk);
[ceros1,polos1,K1]=tf2zp(ss2tf(P3))

tiempo=[0:Ts:10]; // Vector de Tiempos
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
Ck2=[1,0,0];
Dk2=[0];
P4=syslin("d",Ak2,Bk2,Ck2,Dk2);
Ki=horner(ss2tf(P4),1)          // Ganancia de Lazo Cerrado
A0=1/Ki                          // Ganancia del controlador
Kt=Kt/A0                       // Vector con ajuste de ganancia

Ak=Ad-Bd*Kt*A0;
Bk = Bd*A0;
Ck=eye(3,3);
Dk=zeros(3,1);
P5=syslin("d",Ak,Bk,Ck,Dk);
[ceros1,polos1,K1]=tf2zp(ss2tf(P5))

tiempo=[0:Ts:10]; // Vector de Tiempos
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


tiempo=[0:Ts:10]; // Vector de Tiempos
ru=1*ones(1,length(tiempo));
Y=dsimul(Pcontrol,ru);
figure(3)
plot2d2(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Señal de control')
ylabel("u(k)");


