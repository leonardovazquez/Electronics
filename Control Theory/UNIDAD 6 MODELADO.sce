// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE MODELADO DE SISTEMAS DISCRETOS

clc;
clear;
close();

//--------------------------------------SISTEMA SISO---3ER ORDEN-----------------------------------------------

// FUNCION TRANSFERENCIA 

z=%z;                                        // variable z
num1 = [-0.7,-0.5];                          // polos
den1 = [-0.1,-0.2,-0.6];                     // ceros
kG = 4.3e-4                                  // ganancia
numG = poly(num1,"z","roots");               // polinomio numerador
denG = poly(den1,"z","roots");               // polinomio denominador
G = kG*numG/denG;                            // funcion transferencia
zpk(G)

num = coeff(G.num);                          // extraccion de coeficientes del numerador 
den = coeff(G.den);                          // extraccion de coeficientes del denominador

// MODELO CANONICO CONTROLABLE

Acc=[0, 1, 0; 0, 0, 1; -den(1), -den(2), -den(3)];         // Matriz Acc
Bcc=[0;0;1];                                               // Matriz Bcc
Ccc=[num(1), num(2), num(3)];                              // Matriz Ccc
Dcc = [0];                                                 // Matriz Dcc
Pcc = syslin("d",Acc,Bcc,Ccc,Dcc);                         // Sistema lineal discreto
Pcc

Ucc=cont_mat(Pcc);                                         // Matriz Ucc
rank(Ucc);                                                 // rango de Ucc
Vcc=obsv_mat(Pcc);                                         // Matriz Vcc
rank(Vcc);                                                 // rango de Vcc

// MODELO CANONICO OBSERVABLE

Aco=[0, 0, -den(1); 1, 0, -den(2); 0, 1, -den(3)]          // Matriz Aco
Bco=[num(1); num(2); num(3)]                               // Matriz Bco
Cco=[0, 0,1]                                               // Matriz Cco
Dco = [0];                                                 // Matriz Bco
Pco = syslin("d",Aco,Bco,Cco,Dco);                         // Sistema lineal discreto
Pco

Uco=cont_mat(Pco);                                         // Matriz Uco
rank(Uco);                                                 // rango de Uco
Vco=obsv_mat(Pco);                                         // Matriz Vco
rank(Vco);                                                 // rango de Vco


//---------------------------------SISTEMA SIMO---3ER ORDEN----------------------------------------------

// FUNCION TRANSFERENCIA 
clc;
z=%z;                                                      // variable z
num1 = [-0.7,-0.5];                                        // completo numerador  y denominador de cada 
den1 = [-0.1,-0.2,-0.6];                                   // transferencia parcial con ceros y polos
kG1 = 4.3e-4                                               // ganancia de transferencia parcial
numG1 = kG1*poly(num1,"z","roots");                            // polinomio numerador
denG1 = poly(den1,"z","roots");                            // polinomio denominador
G1 = numG1/denG1;                                      // funcion transferencia 1

num2 = [-0.7,-0.6];                                        // completo numerador y denominador de cada
den2 = [-0.1,-0.2,-0.6];                                   // transferencia parcial con ceros y polos
kG2 = 1e-4                                                 // ganancia de transferencia parcial
numG2 = kG2*poly(num2,"z","roots");                            // polinomio numerador
denG2 = poly(den2,"z","roots");                            // polinomio denominador
G2 = numG2/denG2;                                      // funcion transferencia 2

zpk(G1)
zpk(G2)

num1 = coeff(numG1);                                       // extraccion de coeficientes     
num2 = coeff(numG2);                                       // de cada numerador
den = coeff(denG2);                                        // extraccion de coeficientes del denominador compartido

GT = [G1; G2];                                             // transferencia total: una sola entrada y dos salidas


// MODELO CANONICO CONTROLABLE

Acc=[0, 1, 0; 0, 0, 1; -den(1), -den(2), -den(3)];          // Matriz Acc
Bcc=[0;0;1];                                                // Matriz Bcc
Ccc=[num1(1), num1(2), num1(3); num2(1), num2(2), num2(3)]; // Matriz Ccc
Dcc = [0;0];                                                // Matriz Dcc
Pcc = syslin("d",Acc,Bcc,Ccc,Dcc);                          // sistema lineal discreto
Pcc

Ucc=cont_mat(Pcc);                                          // Matriz Ucc
rank(Ucc);                                                  // rango de Ucc

Vcc=obsv_mat(Pcc);                                          // Matriz Vcc
rank(Vcc);                                                  // rango Vcc
V1=obsv_mat(Pcc.a,Pcc.c(1,:))                               // Observabilidad desde cada salida
V2=obsv_mat(Pcc.a,Pcc.c(2,:))                               // V1 y V2


//-------------------------------------SISTEMA MISO---3ER ORDEN----------------------------------------------

// FUNCION TRANSFERENCIA 
clc;
z=%z;                                                       // variable z
num1 = [-0.7,-0.5];                                         // completo numerador  y denominador de cada
den1 = [-0.1,-0.2,-0.6];                                    // transferencia parcial con ceros y polos
kG1 = 4.3e-4                                                // ganancia de la transferencia parcial
numG1 = poly(num1,"z","roots");                             // polinomio numerador
denG1 = poly(den1,"z","roots");                             // polinomio denominador
G1 = kG1*numG1/denG1;                                       // funcion transferencia 1


num2 = [-0.7,-0.6];                                         // completo numerador  y denominador de cada
den2 = [-0.1,-0.2,-0.6];                                    // transferencia parcial con ceros y polos
kG2 = 1e-4                                                  // ganancia de la transferencia parcial
numG2 = poly(num2,"z","roots");                             // polinomio numerador
denG2 = poly(den2,"z","roots");                             // polinomio denominador
G2 = kG2*numG2/denG2;                                       // funcion transferencia 2

zpk(G1)
zpk(G2)

num1 = coeff(numG1);                                        // extraccion de coeficientes de cada
num2 = coeff(numG2);                                        // numerador de transferencia parcial        
den = coeff(denG2);                                         // extraccion de coeficientes del denominador comun

GT = [G1, G2];                                              // transferencia total: una sola salida y dos entradas

// MODELO CANONICO OBSERVABLE

Aco=[0, 0, -den(1); 1, 0, -den(2); 0, 1, -den(3)]              // Matriz Aco
Bco=[[num1(1); num1(2); num1(3)],[num2(1); num2(2); num2(3)]]  // Matriz Bco
Cco=[0, 0,1]                                                   // Matriz Cco
Dco = [0, 0];                                                  // Matriz Dco
Pco = syslin("d",Aco,Bco,Cco,Dco);                             // sistema lineal discreto
Pco

Uco=cont_mat(Pco);                                             // Matriz Uco
rank(Uco);                                                     // rango de Uco
U1=cont_mat(Pco.a,Pco.b(:,1))                                  // controlabilidad desde cada una 
U2=cont_mat(Pco.a,Pco.b(:,2))                                  // de las entradas

Vco=obsv_mat(Pco);                                             // Matriz Vco
rank(Vco);                                                     // rango de Vco


//------------------------------MODELO DE ESTADO DISCRETO Y CONTINUO---------------------------------------------

// Modelo continuo
clc;
A = [0,1;-4,0];                                                 // Matriz A
B = [0;2];                                                      // Matriz B
C =[1, 0;0,1];                                                  // Matriz C
D =[0;0];                                                       // Matriz D
X0 = [1;-1];                                                    // Vector de estados iniciales
P1=syslin("c",A,B,C,D,X0);                                      // sistema lineal continuo
G1c=ss2tf(P1);                                                  // Transferencia a lazo abierto

s = poly(0,"s");                                                // Variable de Laplace
I_2 = eye(2,2);                                                 // Matriz identidad de 2x2
sia = s*I_2-A                                                   // sI-A
adj_sia = coffg(sia);                                           // Adj(sI-A)
det_sia = det(sia);                                             // Det(sI-A)
inv_sia = adj_sia/det_sia;                                      // (sI-A)^-1

tiempo=[0:0.02:20];                                             // vector de tiempo
u=ones(1,length(tiempo));                                       // escalon continuo
//u=(0:0.02:20);                                                // rampa continua
Y=csim(u,tiempo,P1);                                            // simulacion continua

figure(1)
subplot(211)
plot2d(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado continuas')
ylabel("X1");
subplot(212)
plot2d(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("X2");

//Modelo discreto
Ts=0.1;                                                           // Periodo de muestreo
P2=dscr(P1,Ts);                                                   // sistema lineal discreto
G1d=ss2tf(P2);                                                    // transferencia a lazo abierto

tiempo=[0:Ts:20];                                                 // vector de tiempo discreto
u=1*ones(1,length(tiempo));                                       // escalon discreto
//u=(0:Ts:20);                                                    // rampa discreta
Y=dsimul(P2,u);                                                   // simulacion discreta

figure(2)
subplot(211)
plot2d2(tiempo,Y(1,:),color("red"));
xgrid(color("gray"))
title('Respuesta de las variables de estado discretas')
ylabel("X1");
subplot(212)
plot2d2(tiempo,Y(2,:),color("blue"));
xgrid(color("gray"))
ylabel("X2");

////--------------------------------------SIMULACION DE TLC--------------------------------------------- 
// Modelo continuo
clear;
clc;
A = [0,1;-4,0];                                                   // Matriz A
B = [0;2];                                                        // Matriz B
C =[1, 0];                                                        // Matriz C
D =[0];                                                           // Matriz D
X0 = [0;0];                                                       // vector de estados iniciales
P1=syslin("c",A,B,C,D,X0);                                        // sistema lineal continuo

//Modelo discreto
Ts=0.1;                                                           // periodo de muestreo
P2=dscr(P1,Ts);                                                   // sistema lineal discreto
G1d=ss2tf(P2);                                                    // transferencia a lazo abierto

//Transferencia a lazo cerrado
H = 1;                                                            // realimentacion H
Tlc=G1d/(1+G1d*H);                                                // transferencia a lazo cerrado
tiempo=[0:Ts:20];                                                 // vector de tiempo discreto
u=ones(1,length(tiempo));                                         // escalon discreto
Ylc1=dsimul(tf2ss(Tlc),u);                                        // simulación discreta 

figure(3)
plot2d2(tiempo,Ylc1,color("red"));
xgrid(color("gray"))
title('Respuesta al escalón de la TLC')


////--------------------------------------ANALISIS DE ESTABILIDAD--------------------------------------------- 
clc;
A = [0,1;-4,0];                                                   // Matriz A
B = [0;2];                                                        // Matriz B
C =[1, 0];                                                        // Matriz C
D =[0];                                                           // Matriz D
X0 = [0;0];                                                       // vector de estados iniciales
P1=syslin("c",A,B,C,D,X0);                                        // sistema lineal continuo

//Modelo discreto
Ts=1;                                                            // periodo de muestreo
P5=dscr(P1,Ts);                                                  // sistema lineal discreto
GHz=ss2tf(P5);                                                   // transferencia a lazo abierto

// Lugar de Raíces
figure(4) 
evans(GHz,10)                                                    // lugar de raices de GH
xgrid(color("gray"))

// Transformación bilineal del sistema 
K=1;
s=%s;                                                            // transformación bilineal 
GHw=horner(GHz,(1+s*Ts/2)/(1-s*Ts/2))
GHw=K*GHw                                                        // coloco una ganancia K
GHw=zpk2tf(simpl(GHw,1e-4))
zpk(GHw)
GHw=ss2tf(bilin(GHz,[Ts/2,1,-Ts/2,1]))

// Librerías
//pth=pwd()
//pth=pth+"\T_d_Control_lib.sci"
//exec(pth)


// Diagrama de Bode
wr=logspace(-2,3,500);                                          // vector de frecuencias en rad/s
fx=wr/2/%pi;                                                    // vector de frecuencias en Hz
resp=repfreq(GHw,fx);                                           // respuesta en frecuencia
[M1,F1]=dbphi(resp);                                            // separacion de magnitud y fase
//[M1,F1,w]=bode_asym(GHw,wr,2,"red");                          // diagrama de Bode Asintótico

figure(5)
subplot(211)
plot2d("ln",wr,M1,color("blue"));                               // Diagrama de Bode Asintótico de Módulo
set_my_line_styles(1,2);
xgrid(color("gray"))
title("Diagrama de Bode de Módulo ")
subplot(212)
plot2d("ln",wr,F1,color("red"));                               // Diagrama de Bode Asintótico de Fase
set_my_line_styles(1,2);
xgrid(color("gray"))
title("Diagrama de Bode de Fase ")

