// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE ESTIMADORES
clc;
clear;
close();

//---------------------------ESTIMADOR DE ESTADOS   NO OBSERVABLE-----------------------------------------------

// Valores

A1=12;
A2=45;
A3=15;
R1=120;
R2=360;
R3=72;
R4=300;
Kq=0.01;


// Modelo continuo

A=[-(1/R2+1/R1)/A1,0,1/(A1*R2); 1/(A2*R1),-1/(A2*R3),0; 1/(R2*A3),0,-(1/R2+1/R4)/A3];
B=[Kq/A1;0;0];
C=eye(3,3);
D=[0;0;0];

P1=syslin("c",A,B,C,D)
V1=obsv_mat(A,C(3,:))

tiempo=[0:10:20000]; // Vector de Tiempos
u=ones(1,length(tiempo));
Y=csim(u,tiempo,P1); // Simulación
figure(1)
subplot(3,1,1)
plot2d(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado continuas')
ylabel("Tanque nº 1");
subplot(3,1,2)
plot2d(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("Tanque nº 2");
subplot(3,1,3)
plot2d(tiempo,Y(3,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("Tanque nº 3");

// Modelo de estado discreto
Ts=10;
P2=dscr(P1,Ts)
Ad=P2.a;
Bd=P2.b;
Cd=P2.c(3,:);
Dd=P2.d(3,:);
V2=obsv_mat(Ad,Cd)
rank(V2)
G2=ss2tf(P2)


T=[0:Ts:20000];                                                 // vector de tiempo discreto
u=1*ones(1,length(T));                                       // escalon discreto
//u=(0:Ts:20);                                                    // rampa discreta
Y=dsimul(P2,u);                                                   // simulacion discreta

figure(2)
subplot(3,1,1)
plot2d2(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado discretas')
ylabel("Tanque nº 1");
subplot(3,1,2)
plot2d2(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("Tanque nº 2");
subplot(3,1,3)
plot2d2(tiempo,Y(3,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("Tanque nº 3");

// Matriz Transformacion
q1=[0 1 0];
T=[V2(1,:); V2(2,:); q1]
P3=syslin("d",Ad,Bd,Cd,Dd);
P4=ss2ss(P3,T^-1)
autov=spec(Ad)

// Subsistema observable
P5=syslin("d",P4.a(1:2,1:2),P4.b(1:2,1),P4.c(1,1:2),P4.d(1,1))
V5=obsv_mat(P5)

// autovalores deseados
CteT=100;
Psi= 1;
Wn = 1/(Psi*CteT);
p1 = -Psi*Wn+%i*Wn*sqrt(1-Psi^2)
p2 = -Psi*Wn-%i*Wn*sqrt(1-Psi^2)

polos=[exp(p1*Ts) exp(p2*Ts)]
// Vector del estimador observable
Ho=(ppol(P5.a',P5.c',polos))'
// Vector del estimador del modelo separado
Ht=[Ho; 0]
// Vector del estimador del modelo original
H=T^-1*Ht

//Modelo del estimador
Ae=Ad-H*Cd;
Be=[Bd,H];
Ce=eye(3,3);
De=zeros(3,2);
Xe0=[0;-0.5;-0.5];

//Respuesta del estimador
At=[Ad,zeros(3,3);H*Cd,Ae]
Bt=[Bd;Bd]
Ct=eye(6,6)
Dt=zeros(6,1)
Xt=[zeros(3,1);Xe0]
//Xt=zeros(6,1)
Pt=syslin("d",At,Bt,Ct,Dt,Xt)

// SIMULACIÓN
T = 0:Ts:20000;
u=ones(1,length(T));
Y=dsimul(Pt,u);

figure(3)
subplot(3,1,1)
plot2d2(T,Y(1,:),color("red"));
plot2d2(T,Y(4,:),color("blue"));
xgrid(color("gray"))
title('Respuesta de las variables de estado')
ylabel("Altura 1");
subplot(3,1,2)
plot2d2(T,Y(2,:),color("red"));
plot2d2(T,Y(5,:),color("blue"));
xgrid(color("gray"))
ylabel("Altura 2");
subplot(3,1,3)
plot2d2(T,Y(3,:),color("red"));
plot2d2(T,Y(6,:),color("blue"))
xgrid(color("gray"))
ylabel("Altura 3");
