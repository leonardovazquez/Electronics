
// -----------------------------------------------------------------------------
// VAZQUEZ LEONARDO DAVID
// SEGUNDO PARCIAL 2022 TEORIA DE CONTROL 1C
// CÓDIGO DE SISTEMAS DISCRETOS
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// TRANSFERENCIA DE LA PLANTA
s=%s;
Gp=syslin("c",3000/((1+s/500)*(1+s/1000)*(1+s/1e5)))
zpk(Gp)
// Descomposición en fracciones simples.
Gp_s=Gp
Dfs=pfss(Gp_s)
// discretización
Ts=0.002;
Gp_z=ss2tf(dscr(tf2ss(Gp),Ts))
zpk(Gp_z)
// Transformación bilineal
Gp_w=ss2tf(bilin(Gp_z,[Ts/2,1,-Ts/2,1]))
zpk(Gp_w)
//cargar libreria
pth=pwd()
pth=pth+"\bode_lin.sci"
exec(pth)
//Bode
w=logspace(1,5,500);
frec=w/2/%pi;
figure(1)
[M,F,w]=bode_asym(Gp_w,w,0,"red");
// Corrección para error nulo 
Gp2=Gp_w/s // escalón 
// Gp2 =Gp_w/(s^2) rampa
figure(2)
[M,F,w]=bode_asym(Gp2,w,0,"red");
// -----------------------------------------------------------------------------
// REDES DE COMPENSACIÓN ANALÓGICAS

// Función red de atraso.
function [Gc]=atraso(a,wc)
    // Cálculo de la red de atraso en función 
    // de la atenuación y la frecuencia de corte
    s=%s;
    w0=wc/10;
    wp=w0/a;
    Gc=syslin("c",1+s/w0,1+s/wp);
endfunction;

// Función  red de adelanto
function [Gc]=adelanto(phi_max,w0)
    // Cálculo de la red de atraso en función 
    // de la atenuación y la frecuencia de corte
    s=%s;
    s_pm=sin(phi_max*%pi/180);
    a=(1+s_pm)/(1-s_pm)
    wp=w0*sqrt(a);
    wc=wp/a;
    Gc=syslin("c",1+s/wc,1+s/wp);
endfunction;

// Ejemplo de compensación
Gc2=atraso(29,100)
GH1=Gp2*Gc2
w=logspace(-2,5,500);
frec=w/2/%pi;
figure(3)
[M,F,w]=bode_asym(GH1,w,0,"red");    
Gc=Gc2/s;
z=%z;
Gc_z=ss2tf(bilin(Gc,[2/Ts,-2/Ts,1,1]))
zpk(Gc_z)
//

//Respuesta transitoria
Tlc1=GH1/(1+GH1);
tiempo=0:0.0005:0.3; // Vector de Tiempos
Y=csim('step',tiempo,Tlc1); // Simulación
figure(4)
plot2d(tiempo,Y,color("blue"))
xgrid(color("gray"))
title('Respuesta a lazo cerrado')
//
// -----------------------------------------------------------------------------
// COMPENSADORES DISCRETOS

// Modelado de la planta discreta
s=%s;
num2=23;
den2=(s)*(s+114);
GH=syslin('c',num2/den2);
Ts=0.01;

GHD=dscr(GH,Ts);
z=%z;              // Agrego el retardo de una muestra
GHD=(1/z)*GHD;
zpk(GHD)
GHZ=ss2tf(GHD);
[z,p,k]=ss2zp(GHD);

// DEAD BEAT

NUMTZ=[1];
DENTZ=[%z^2];
TZ=syslin("d",NUMTZ,DENTZ);
zpk(TZ)

DZ=(1/GHZ)*(TZ/(1-TZ));
zpk(DZ);
[zd,pd,kd]=tf2zp(DZ);

// DAHLIN

tau=0.05; //constante de tiempo
landa=1/tau; //lambda
q=exp(-landa*Ts);

NUMTZ2=[1-q];
//DENTZ2=[%z-q] //sin retardo
DENTZ2=[%z^2-q*%z]; // con 1 retardo
TZ2=syslin("d",NUMTZ2,DENTZ2);

DZ2=(1/GHZ)*(TZ2/(1-TZ2));
zpk(DZ2)
[zd2,pd2,kd2]=tf2zp(DZ2);

// Respuesta transitoria

//xdel(winsid())

Tlc=TZ2 //GH debe ser discreta
U=[zeros(1,10),ones(1,10),ones(1,130)]
Tt=linspace(0,length(U),150)
Yt=flts(U,Tlc)
figure(5)
plot2d2(Tt,Yt,color("red"));
plot2d2(Tt,U,color("blue"));
//set_my_line_styles(1,2);
xgrid(color("gray"))
title("Respuesta a lazo cerrado ")


// TIEMPO FINITO

// Calculo transferencia de la planta discreta
s=%s;
numGP=1;
denGP=(s)*(s^2 +2);
GP=syslin('c',numGP/denGP);

[Ds,numGPD,denGPD]=ss2tf(dscr(GP,Ts));
GPD=syslin('d',numGPD/denGPD+Ds);
zpk(GPD)

// Resolucion sistema de ecuaciones 

// a1 + b1 = 2
// Z0 a1 + a2 - 2 b1 = -2
// Z0 a2 + a3 + b1 = 2
// Z0 a3 = -1

// Calculo de coeficientes
// Existe un grado de libertad
// Asumimos un valor para b2
Z0=2;
b2=1;
//b2=2;  // Para probar otra alternativa
M=[1,0,0,1;Z0,1,0,-2;0,Z0,1,1;0,0,Z0,0]; // Matriz del sistema
Sol=inv(M)*[2;-b2-1;2*b2;-b2];

a1=Sol(1)
a2=Sol(2)
a3=Sol(3)
b1=Sol(4)

// Calculo del compensador
z=%z;
numDZ=(a1*z^2+a2*z+a3)*(z+Z0)*denGPD;
denDZ=((z-1)^2)*(z^2+b1*z+b2)*numGPD;
DZ=syslin('d',numDZ/denDZ);
zpk(DZ)

// Analizo respuesta a lazo cerrado
TLC=DZ*GPD/(1+DZ*GPD);

//-------Salida --------
u=0:Ts:0.2;
t=0:Ts:0.2;
y=flts(u,TLC);
figure(6)
plot2d2(t',y')
//hold on
plot(t',y');
plot(t',u','--r')
//hold off;

//-------Error --------
//clf
er=u-y;
figure(7)
plot2d2(t',er')

//-------Control --------
//clf
u=0:Ts:0.12;
t=0:Ts:0.12;
TLControl=DZ/(1+DZ*GPD);
ucontrol=flts(u,TLControl);
figure(8)
plot2d2(t',ucontrol')

//----------------------------------------------------------
// Analisis de Lugar de Raices de GH
//clf
GH=DZ*GPD;
zpk(GH)
figure(9)
evans(GH,150)
