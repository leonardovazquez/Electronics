// 3ER PARCIAL
// VAZQUEZ LEONARDO DAVID
// 2022
// CÓDIGO DE ESPECIFICACIONES
clc;
clear;
close();

//----------------------------------ESPECIFICACIONES---------------------------------------------------------

// Caso sobreamortiguado
tau = 0.2;                                  // constante de tiempo
Ts_2 = 3*tau;                               // Tiempo de establecimiento del 2%
Ts_5 = 4*tau;                               // Tiempo de establecimiento del 5%

// Caso subamortiguado
SP=0.09;                                    // sobrepico exponencial
Psi= sqrt((log(SP))^2/((log(SP))^2+%pi^2)); // calculo del coeficiente de amortiguamiento
Wn = 1/(Psi*tau);                           // frecuencia natural del sistema
Tr = (7.04*Psi^2+0.2)/(2*Psi*Wn);           // tiempo de crecimiento
Tp = %pi/(Wn*sqrt(1-Psi^2));                // tiempo del primer máximo
Td = (1+0.7*Psi)/Wn;                        // tiempo de demora
 

// polos continuos
p1 = -Psi*Wn+%i*Wn*sqrt(1-Psi^2)
p2 = -Psi*Wn-%i*Wn*sqrt(1-Psi^2)
p3 = 10*(-Psi*Wn)

// polos discretos
Ts = 0.01;                                  // periodo de muestreo
Pz=[exp(p1*Ts),exp(p2*Ts),exp(p3*Ts)]       // polos discretizados
Pcr=poly(Pz,"z","roots");                   // polinomio deseado


// Errores en regimen permanente

z=%z
GHz=(z-0.1)/((z^2+1-z)*(z-1)^2)


Kp = horner(GHz,1)
erp = 1/(1+Kp)
Kv = (1/Ts)*horner(GHz*(z-1),1)
erp2 =1/Kv
Ka = (1/Ts^2)*horner(GHz*(z-1)^2,1)
erp3 = 1/Ka
