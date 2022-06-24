// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE ESTIMADORES
clc;
clear;
close();

//---------------------------ESTIMADOR DE ESTADOS REDUCIDO---------------------------------------------------

// Modelo Continuo

Ra=2;
La=5e-3;
Jm=5e-3;
Bm=5e-3;
Kt=0.7;
Kw=0.8;
Ai=10;


A=[-Ra/La -Kw/La 0; Kt/Jm -Bm/Jm 0; 0 1 0];
B=[Ai/La; 0; 0];
C=[0 0 1; 0 1 0];
D=[0; 0];

P1=syslin("c",A,B,C,D)
autov=spec(P1.a)

// Modelo de estado discreto
Ts=0.001;
P2=dscr(P1,Ts)
Ad = P2.a
Bd = P2.b
Cd = P2.c
Dd = P2.d
autov_d=spec(P2.a);
V=obsv_mat(P2)
rank(V)

// Sustitución
T=[1 0 0;0 0 1; 0 1 0]
P3=ss2ss(P2,T)

// Submatrices del modelo
A11=P3.a(1,1)
A12=P3.a(1,2:3)
A21=P3.a(2:3,1)
A22=P3.a(2:3,2:3)
B1=P3.b(1,1)
B2=P3.b(2:3,1)

// Diseño del estimador
/*  Matriz del Estimador 
 Ae = A11 - H*A21 
 */
z1=0
Ae=z1;
// Elemento del vector del estimador
h1=1
h2= (A11-h1*A21(1,1)-Ae)/A21(2,1)
H=[h1 h2]

// Matrices del modelo
Ae=Ae
Be=B1-H*B2
He=A12-H*A22+Ae*H
Best=[Be,He];
Ce=1;
De=[0,H];
Xe0=10;
Pw = syslin("d",Ae,Best,Ce,De,Xe0)

// RESPUESTA DEL ESTIMADOR 
At=[Ad,zeros(3,1);He*Cd,Ae]
Bt=[Bd;Be]
Ct=[eye(3,3),zeros(3,1);H*Cd,eye(1,1)]
Dt=zeros(4,1)
Xe0=[0.05;0.3;0.01]
Xt=[Xe0;-1]
Pt=syslin("d",At,Bt,Ct,Dt,Xt)

// SIMULACIÓN
T = 0:Ts:2;
u=ones(1,length(T));
Y=dsimul(Pt,u);
// GRÁFICO 
figure(1)
title('Respuesta de las variables de estado')
subplot(4,1,1)
plot2d2(T,Y(1,:),color("red"));
subplot(4,1,2)
plot2d2(T,Y(2,:),color("blue"));
xgrid(color("gray"))
subplot(4,1,3)
plot2d2(T,Y(3,:),color("green"));
subplot(4,1,4)
title('Estimacion')
plot2d2(T,Y(4,:),color("black"));
xgrid(color("gray"))

figure(2)
title('Variable real(roja) y estimada(azul)')
plot2d2(T,Y(1,:),color("red"));
plot2d2(T,Y(4,:),color("blue"));
xgrid(color("gray"))



