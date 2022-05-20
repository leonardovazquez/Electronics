//**********************************************
// ejemplo de diseño de PID para teoría año 2020
//**********************************************
//   Ejemplo PID 2020
//   Inicio
//clear
xdel(winsid());

//  Presentación
//
// Planta con retardo.  Controlador tipo PID 
//
//    "Controlar el peso de material sobre una cinta transportadora". 
// 
//  ====>  Descripción del Sistema:   =========:
//   
//  La planta a controlar está compuesta de una tolva que vierte material 
//  sobre una cinta transportadora. La cantidad de material se regula 
//  mediante una válvula proporcional. El peso es medido sobre la cinta 
//  con una celda de carga ubicada a una distancia determinada de la tolva. 
//  La velocidad de la cinta es, aproximadamente, constante. Por ello, existe 
//  un retardo, supuesto constante, en la medición de variaciones del peso 
//  debido a cambios en la vávula de la tolva. 
//  
//  Considerando las distintos elementos del conjunto y haciendo algunas 
//  aproximaciones se concluye que un modelo de la planta de cuarto orden 
//  más el retardo en la salida medida representa bastante bien al sistema.
//
//  Se supone que se quiere controlar el sistema con un PID clásico el cual 
//  provee una tensión para abrir o cerrar la válvula de la tolva en función 
//  del peso leído por la celda. 
//  ============================================== 
//
// MODELO ANALÓGICO de la Planta. (Sin retardo) :      
s=%s ;      
kpa= 0.01 ;    cpa= [-0.35];  ppa= [-0.01, -0.025, -0.4, -5];  
Gps=zpk(cpa,ppa,kpa,"c");
zpk(Gps)                // Se usa Transferencias para presentaciones. 
//
// Transferencia discreta de la Planta . (Sin retardo) :   
//
Ts= 1;                //  período de muestreo.  
Gpz= ss2tf(dscr(Gps,Ts));  
zpk(Gpz)             // Planta discreta Sin retardo.
// Agregando el retardo que posee la planta, resulta : 
Tr= 14.6*Ts;   dd= ceil(Tr/Ts); //  dd= Nro. períodos Ts que cubren Tr [s]  
z=%z;  
Gpr=Gpz/z^dd;  
zpk(Gpr)             // Planta discreta con retardo.
//
// Respuesta del sistema a Lazo Abierto
//
//clc;
//xdel(winsid());

//  Planta discreta con demora.
tiempo=[0:Ts:800];      // Vector de Tiempos
u=ones(1,length(tiempo));
Yla=dsimul(tf2ss(Gpr),u); // Simulación
figure(1)
plot2d(tiempo,Yla,color("red"))
xgrid(color("gray"))
title('Respuesta al Escalón')
//
// Respuesta a Lazo Cerrado con realimentación unitaria 
// 
//xdel(winsid());
Tlca=Gpr/(1+Gpr);
Ylc=dsimul(tf2ss(Tlca),u); // Simulación
figure(2)
plot2d(tiempo,Ylc,color("red"))
xgrid(color("gray"))
title('Respuesta al Escalón')
//
// 
//  ************************************************
//  Cálculo datos para ZIEGLER-NICHOLS 
//  usando Planta discreta con demora:
//  ************************************************
//clc;
//xdel(winsid())
//
//  1.-  Cálculo Coef. Z-N por respuesta a escalón: 
//
t1=tiempo;
y1=Yla;
figure(3)
plot2d(t1,y1,color("scilabgreen4"))
xgrid(color("gray"))
mx=0;  
dy1(1)=0;
recta(1)=0;
for i=1:length(t1)-1
    dy1(i)=y1(i+1)-y1(i);   // Cálculo del increlento entre muestras
    if dy1(i)>=mx then     // determinación del punto de máximo incremento (pendiente máxima)
        mx=dy1(i);
        imx=i;
    end
end
//
//    La recta que determina los parámetros es: y= gmax*t + yo, -->  gmax=  dy1(imx)/Ts
//    por lo tanto para determinar el corte en cero:  
//    ymx= gmax*(imx*Ts) + yo  --> yo= ymx - gmax*(imx*Ts) 
//    además,    ymx= y1(imx) ;    y,   0= gmax*R + yo --> R= - yo/gmax
// 
gmax= dy1(imx)/Ts                 // pendiente máxima
y0= y1(imx)- gmax*(imx*Ts)        // ordenada al origen
L= - y0/gmax                      // punto de corte 
recta=gmax*t1+y0;                 // recta de máxima pendiente
figure(4)
plot2d(t1,recta,color("red"));   // grafico recta de máxima pendiente
// Valor final
ylim=y1(length(t1));            // valor final de salida
ulim=u(length(tiempo));         // valor final de entrada
Klim=ylim/ulim;                 // ganancia
vfinal=ylim*ones(tiempo);       // recta de valor final
figure(5)
plot2d(tiempo,vfinal,color("blue"));
xf=find(recta>=ylim);           // cruce de rectas
tf=xf(1)*Ts;                    // tiempo del cruce de rectas
R=Klim/(tf-L)                   // Pendiente
 //
//  *********** Se usa Z-N a lazo abierto  *********
//
// Coef. Z-N  para  PID : 
//clc;
//xdel(winsid())
kc1= 1.2/(R*L)
Ti1= 2*L
Td1= 0.5*L    
             
//  DISEÑO PID discreto.  ( PID sobre error ) : 
  
Ie1=syslin("d",(kc1*Ts/(2*Ti1))*(z+1),(z-1));  // Transferencia Integral Trapezoidal
Pe1= kc1;                                      // Transferencia Proporcional
De1= syslin("d",kc1*(Td1/Ts)*(z-1),z);          // Transferencia Derivativa
Gce1= Pe1+De1+Ie1
zpk(Gce1)
// Respuesta del sistema a lazo cerrado con controlador y  retardo
GHz=Gpr*Gce1
Glc1=GHz/(1+GHz)
zpk(Glc1)
Ylc1=dsimul(tf2ss(Glc1),u); // Simulación
figure(6)
plot2d(tiempo,Ylc1,color("red"))    // Respuesta con PID
plot2d(tiempo,Ylc,color("blue"))    // Respuesta si PID
xgrid(color("gray"))
title('Respuesta a Lazo Cerrado')
//
//   Esfuerzo de Control
//
GHz=Gpr*Gce1
Gu=Gce1/(1+GHz)
zpk(Gu)
Uk=dsimul(tf2ss(Gu),u); // Simulación
figure(7)
plot2d(tiempo,Uk,color("red"))    // Respuesta con PID
xgrid(color("gray"))
title('Esfuerzo de Control')

//  2 .-  Cálculo Coef. Z-N por oscilación lazo cerrado:   
//
// Planta discreta con demora:
// Se calcula el margen de ganancia para determinar la ganancia para la oscilación 
// con la frecuencia de fase 180º se calcula el To
//clc;
// Transformación bilineal
Gp_w=ss2tf(bilin(Gpr,[Ts/2,1,-Ts/2,1]))
Gpw=syslin("c",Gp_w)
[zw,pw,kw]=tf2zp(Gpw)
[mg_dB,fr]= g_margin(Gpw)  
show_margins(Gpw,"bode")
kmax= 10^(mg_dB/20)      //  Kmax = ganancia para hacer oscilar al sistema a lazo cerrado
To=1/fr                  //  To = Periodo de oscilación 
//
//    Coef. Z-N  para  PID : 
//
//clc;
//xdel(winsid()) 
kc2= 0.6*kmax   
Ti2= To/2   
Td2= To/8 
//
//  DISEÑO PID discreto.  ( PID sobre error ) : 
//  
Ie2=syslin("d",(kc2*Ts/(2*Ti2))*(z+1),(z-1));  // Transferencia Integral Trapezoidal
Pe2= kc2;                                      // Transferencia Proporcional
De2= syslin("d",kc2*(Td2/Ts)*(z-1),z);          // Transferencia Derivativa
Gce2= Pe2+De2+Ie2
zpk(Gce2)
// Respuesta del sistema a lazo cerrado con controlador y  retardo
GHz=Gpr*Gce2
zpk(GHz)
Glc2=GHz/(1+GHz)
zpk(Glc2)
Ylc2=dsimul(tf2ss(Glc2),u); // Simulación
figure(8)
plot2d(tiempo,Ylc1,color("red"))                // Respuesta con PID1
plot2d(tiempo,Ylc2,color("scilabgreen4"))      // Respuesta con PID2
plot2d(tiempo,Ylc,color("blue"))                // Respuesta sin PID
xgrid(color("gray"))
title('Respuesta a Lazo Cerrado')
//
// Corrección de los coeficientes
//
// Para resintonizar, se aumentan las ganancias  Td  y  Ti . 
//clc;
//xdel(winsid()) 

kc3= 0.85*kc2,  
Ti3= 2*Ti2  ,   
Td3= 1.7*Td2   

//  DISEÑO PID discreto.  ( PID sobre error ) : 
//  
Ie3=syslin("d",(kc3*Ts/(2*Ti3))*(z+1),(z-1));  // Transferencia Integral Trapezoidal
Pe3= kc3;                                      // Transferencia Proporcional
De3= syslin("d",kc3*(Td3/Ts)*(z-1),z);          // Transferencia Derivativa
Gce3= Pe3+De3+Ie3
zpk(Gce3)
// Respuesta del sistema a lazo cerrado con controlador y  retardo
GHz=Gpr*Gce3
zpk(GHz)
Glc3=GHz/(1+GHz)
zpk(Glc3)
Ylc3=dsimul(tf2ss(Glc3),u); // Simulación
figure(9)
plot2d(tiempo,Ylc3,color("red"))                // Respuesta con PID3
plot2d(tiempo,Ylc2,color("scilabgreen4"))      // Respuesta con PID2
xgrid(color("gray"))
title('Respuesta a Lazo Cerrado')

