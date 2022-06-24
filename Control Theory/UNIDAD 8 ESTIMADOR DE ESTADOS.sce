// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE ESTIMADORES
clc;
clear;
close();

//---------------------------ESTIMADOR DE ESTADOS     INCLUYE RUIDO!!-----------------------------------------------

/*
 CASO SIMO
 F=[1,1]
 Cf=F*Cd
 Vf=obsv_mat(Ad,Cf)
 H=H1*F
*/

// Valores
Ra=2;
La=5e-3;
J=5e-3;
B1=5e-3;
Kt=0.7;
Kw=0.8;
Ai=1;

// Modelo de estado continuo
A=[-Ra/La -Kw/La 0; Kt/J -B1/J 0; 0 1 0];
B=[Ai/La; 0; 0];
C=[1 0 0; 0 1 0; 0 0 1];
D=[0; 0; 0];

P1=syslin("c",A,B,C,D)

T = 0:0.001:0.1;
Y=csim('step',T,P1);
figure(1)
subplot(3,1,1)
plot2d(T,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado continuas a lazo abierto')
ylabel("Corriente");
subplot(3,1,2)
plot2d(T,Y(2,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("Velocidad");
subplot(3,1,3)
plot2d(T,Y(3,:),color("blue"));
xgrid(color("gray"))
ylabel("Posición");


// Modelo de estado discreto
Ts=0.001;

P2=dscr(P1,Ts)
Ad=P2.a;
Bd=P2.b;
Cd=P2.c;
Dd=P2.d;

tiempo=[0:Ts:0.1];                                                 // vector de tiempo discreto
u=1*ones(1,length(tiempo));                                       // escalon discreto
//u=(0:Ts:20);                                                    // rampa discreta
Y=dsimul(P2,u);                                                   // simulacion discreta

figure(2)
subplot(3,1,1)
plot2d2(T,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado discretas a lazo abierto')
ylabel("Corriente");
subplot(3,1,2)
plot2d2(T,Y(2,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("Velocidad");
subplot(3,1,3)
plot2d2(T,Y(3,:),color("blue"));
xgrid(color("gray"))
ylabel("Posición");

P3=P2
P3.c=[0 0 1];
P3.d=0;
V=obsv_mat(P3)
rank(V)

G3=ss2tf(P3)
autov=spec(P3.a)

// Modelo Canonico Observable

den=coeff(G3.den)
num=coeff(G3.num)
Aco=[0,0,-den(1);1,0,-den(2);0,1,-den(3)];
Cco=[0,0,1];
Bco=[num(1);num(2);num(3)];
Dco=0;
Pco=syslin("d",Aco,Bco,Cco,Dco)
Vco=obsv_mat(Pco)

// Matriz Transformación
Mco=V^-1*Vco
Mco_1=Mco^-1
Pco2=ss2ss(P3,Mco)

// Estimador
Z1=0;
Z2=0;
Z3=0;
Z1=0.94;
Z2=0.72;
Z3=0.82;
autov_d=[Z1,Z2,Z3];

H=(ppol(P3.a',P3.c',autov_d))' // Vector de realimentación H

// Matrices del estimador
Ae=P3.a-H*P3.c
autov_e=spec(Ae)
Be=[P3.b,H]
Ce=eye(3,3)
Xe0=[0.1;0.1;0.1]

// Modelo del error

Ve=zeros(3,1); 
Berror = [Ve, H]
Derror = [Ve,Ve]
Pe=syslin("d",Ae,Berror,Ce,Derror,Xe0)

T = 0:Ts:0.1;
u=zeros(1,length(T));
n=0*0.00001*sin(2*%pi*50*T)
ut = [u; n]
Y=dsimul(Pe,ut);

figure(3)
subplot(3,1,1)
plot2d2(T,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta del error de cada variables de estado discretas y estimadas')
ylabel("Corriente");
subplot(3,1,2)
plot2d2(T,Y(2,:),color("scilabgreen4"));
xgrid(color("gray"))
ylabel("Velocidad");
subplot(3,1,3)
plot2d2(T,Y(3,:),color("blue"));
xgrid(color("gray"))
ylabel("Posición");

// Respuesta del estimador
Btt= P3.b
At=[P3.a,zeros(3,3);H*P3.c,Ae]
Bt=[P3.b, [0;0;0] ;P3.b, H]
Ct=eye(6,6)
Dt=zeros(6,2)
Xt=[zeros(3,1);Xe0]
Pt=syslin("d",At,Bt,Ct,Dt,Xt)

// SIMULACIÓN
T = 0:Ts:0.1;
u=ones(1,length(T));
n=0.01*sin(2*%pi*50*T)
ut = [u; n]
Y=dsimul(Pt,ut);

figure(4)
subplot(3,1,1)
plot2d(T,Y(1,:),color("red"));
plot2d2(T,Y(4,:),color("blue"));
xgrid(color("gray"))
title('Respuesta de las variables de estado reales y estimadas')
ylabel("Corriente");
subplot(3,1,2)
plot2d(T,Y(2,:),color("red"));
plot2d2(T,Y(5,:),color("blue"));
xgrid(color("gray"))
ylabel("Velocidad");
subplot(3,1,3)
plot2d(T,Y(3,:),color("red"));
plot2d2(T,Y(6,:),color("blue"))
xgrid(color("gray"))
ylabel("Posición");


// Algoritmo para la Norma mínima
/*
Nmin=1e23;
zmin=[0 0 0];
for z1=0.5:0.02:1
    for z2=0.5:0.02:1
        for z3=0.5:0.02:1
            z=[z1,z2,z3];
            H1=(ppol(P2.a',P2.c',z))';
            N=norm(H1,2);
            if N < Nmin
                Nmin = N;
                zmin = z;
                Hmin = H1;
            end 
        end
    end
end
*/
