// -----------------------------------------------------------------------------
// VAZQUEZ LEONARDO DAVID
// SEGUNDO PARCIAL 2022 TEORIA DE CONTROL 1C
// CÓDIGO DE ESTABILIDAD
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// LUGAR DE RAÍCES
//clc;
clf;
s=%s;
T=1;
num2=(s*T+1)^2;
den2=s^3;
GH=syslin('c',num2/den2);
figure(1)
evans(GH)
xgrid;
mtlb_axis([-4 2 -2 2])
// -----------------------------------------------------------------------------
// DIAGRAMA DE NYQUIST 
figure(2)
clf();
nyquist(GH,0.1,1000);
// -----------------------------------------------------------------------------
//CRITERIO DE ROUTH-HURTWITZ
K=1;
[r,num]=routh_t(GH,K)
if num==0
   disp("El sistema es estable")
else
   mprintf("Hay %g cambios de signo en la primer columna.\n Por lo tanto, el sistema es inestable.", num)
end;
// -----------------------------------------------------------------------------
//DIAGRAMA DE BODE 1: función bode()
figure(3)
clf();
bode(GH,"rad");
//show_margins(GH,'bode')
//bode_asymp(GH)
// -----------------------------------------------------------------------------
//DIAGRAMA DE BODE 2: libreria bode()
pth=pwd()
pth=pth+"\bode_lin.sci"
exec(pth)
xdel();
//clc();
s=%s;
Gx=syslin("c",10,s*(s+4));
figure(4)
fr=logspace(-3,6,200);
bode(Gx,0.0001,1000,"rad");
//hold on
[M,F,w]=bode_asym(Gx,fr,2,"red");
// -----------------------------------------------------------------------------
//DIAGRAMA DE BODE 3: libreria asintotico()

//Aca cargar el directorio de la libreria
pth=pwd()
pth=pth+"/Desktop/FACULTAD/5TO AÑO/1C/TEORIA DE CONTROL/Unidades/3. Estabilidad/Bode asintótico/asintotico2021.sci"
exec(pth)
close(winsid());

s=%s;
T=1;
num2=(s*T+1)^2;
den2=s^3;
GH=syslin('c',num2/den2);
T = GH;
figure(5)
wx=logspace(0,5,3000);       // Vector de frecuencias logrítmicas
bode_asym(T,wx,0,"red");
figure(6)
bode_asym(T,wx,1,"scilabgreen4");
figure(7)
[M1,F1,w1]=bode_asym(T,wx,1,"blue");
subplot(211)
plot2d("ln",w1,M1,color("blue"));
set_my_line_styles(1,3);
xgrid(color("gray"));
title("Diagrama de Bode de Módulo ");
ylabel("Ganancia [dB]");
subplot(212);
plot2d("ln",w1,F1,color("red"));
set_my_line_styles(1,3);
xgrid(color("gray"));
title("Diagrama de Bode de Fase");
ylabel("Fase [º]");
xlabel("Frecuencia [rad/seg]");
// -----------------------------------------------------------------------------
// RESPUESTA AL ESCALÓN
s=%s;
T=1;
num2=(s*T+1)^2;
den2=s^3;
GH=syslin('c',num2/den2);
Vo_Vi=GH;
t=0:0.00001:0.0045; 
Y1=1*csim('step',t,Vo_Vi);
figure(8)
plot(t',Y1(1,:)')
xgrid();
title('Tension de salida');
ylabel('Volts');
// -----------------------------------------------------------------------------
// ANÁLISIS DE SISTEMA CON RETARDO

//clear;
//clc;

// -- FUNCION PADE --
// Cálculo de la función retardo por el método de Pade
function [Gr]=Pade(nd,Td)
// nd : Orden de la transferencia
// Td : Retardo
//nd=4;
//Td=1;
s=%s;
Ns=0;
Ds=0;
for j=0:nd
    Ns=Ns+(factorial(2*nd-j)*factorial(nd))/(factorial(2*nd)*factorial(j)*factorial(nd-j))*(-s*Td)^j
    Ds=Ds+(factorial(2*nd-j)*factorial(nd))/(factorial(2*nd)*factorial(j)*factorial(nd-j))*(s*Td)^j 
end
Gr=syslin("c",Ns,Ds)
endfunction;

// Respuesta a lazo Cerrado.
//xdel;

s=%s;
num2=10;
den2=s*(s+4);
G=syslin('c',num2/den2);
v=0.1;
d = 0.048*0.8;
Td=d/v;
n=5;
Gr=Pade(n,Td)           // Aproximación de Pade
G1=G*Gr;               // Transferencia de Lazo Abiero

figure(9)
H=1;
TLC2=G1/(1+G1*H);
t2= 0:0.1:10;
y2=csim('step',t2,TLC2);
plot(t2',y2');
xgrid;
//mtlb_axis([0 10 -0.2 2.2])

// Bode 
figure(10)
bode(G1,0.001,100000000,'rad');


