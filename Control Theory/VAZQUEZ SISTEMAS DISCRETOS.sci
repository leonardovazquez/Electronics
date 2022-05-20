// -----------------------------------------------------------------------------
// VAZQUEZ LEONARDO DAVID
// SEGUNDO PARCIAL 2022 TEORIA DE CONTROL 1C
// CÓDIGO DE SISTEMAS DISCRETOS
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// SISTEMAS DISCRETOS
z=poly(0,'z');
C_z = (z^3-z^2+z)/((z-1)*(z+1)*(z+2));
C_z1 = C_z/z;
C_z1_pfe = pfss(C_z1)

// -----------------------------------------------------------------------------
// ESTABILIDAD DISCRETA

// Se carga la librería de funciones para el diagrama de Bode sintótico.
// La librería debe estar en el directorio de operación. 
pth=pwd()
pth=pth+"\T_d_Control_lib.sci"
exec(pth)

// Transferencia de la Planta
z=%z;
Y=0.5/z+1/z^2*(z/(z-1))
U = (z/(z-1))
Gp=syslin("d",Y/U)

// Simulación
U=[zeros(1,3),ones(1,10)]
Tt=0:12;
Yt=flts(U,Gp)
figure(1)
plot2d2(Tt,U,color("red"),rect=[0,-0.2,12,1.2]);
set_my_line_styles(1,2);
xgrid(color("gray"));
//figure("BackgroundColor",[1 1 1]);
plot2d2(Tt,Yt,color("blue"),rect=[0,-0.2,12,1.2]);
set_my_line_styles(1,2);
xgrid(color("gray"))
title("Respuesta de la Planta ")


// Transferencia de lazo abierto
GH=Gp*1/(z-1)
zpk(GH)
Fraccion=pfss(GH)

// Transformación bilineal del sistema 
K=0.827;
Ts=2;
s=%s;
GHw=horner(GH,(1+s*Ts/2)/(1-s*Ts/2))
GHw=K*zpk2tf(simpl(GHw,1e-4))
zpk(GHw)

// Transformación bilineal del sistema 
//GHw=ss2tf(bilin(GH2z,[Ts/2,1,-Ts/2,1]))
//zpk(GHw)


// Método de Routh Hurwitz
routh_t(GHw,poly(0,"k"))
kpure(GHw)


// Diagrama de Bode
//xdel(winsid())
wr=logspace(-2,3,500);
fx=wr/2/%pi;
resp=repfreq(GHw,fx);       // Respuesta en frecuencia
[M1,F1]=dbphi(resp);
//[M1,F1,w]=bode_asym(GHw,wr,2,"red"); // Diagrama de Bode Asintótico
// Diagrama de Bode Asintótico de Módulo
figure(2)
subplot(211)
plot2d("ln",wr,M1,color("blue"));
set_my_line_styles(1,2);
xgrid(color("gray"))
title("Diagrama de Bode de Módulo ")
// Diagrama de Bode Asintótico de Fase
subplot(212)
plot2d("ln",wr,F1,color("red"));
set_my_line_styles(1,2);
xgrid(color("gray"))
title("Diagrama de Bode de Fase ")
[Mg,fr]=g_margin(GHw);
wc=2*%pi*fr
Mg
Kmax=10^(Mg/20)


// Respuesta transitoria
//xdel(winsid())

Tlc=Kmax*GH/(1+Kmax*GH) //GH debe ser discreta
U=[zeros(1,10),ones(1,10),zeros(1,130)]
Tt=linspace(0,length(U),150)
Yt=flts(U,Tlc)
figure(3)
plot2d2(Tt,Yt,color("red"));
plot2d2(Tt,U,color("blue"));
set_my_line_styles(1,2);
xgrid(color("gray"))
title("Respuesta a lazo cerrado ")
