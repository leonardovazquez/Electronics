%***********COMUNICACIONES ANALÓGICAS*******************+

%MODULACION EXPONENCIAL: PRACTICA 5


clc
clear all
close all
%% Generación del mensaje (forma de onda modulante)
t_max            = 3e-3;              % Elección de máximo de eje de tiempo
puntos_eje       = 2000;% Eje de tiempo de 2000 puntos
delta_t          = t_max/puntos_eje;
 

t                = 0:delta_t:(t_max-delta_t); 

% % Modulante Cosenoidal
% Am               = 1;
% f_m              = 3/t_max;           % 3 períodos de modulante en eje t
% omega_m          = 2*pi*f_m;
% x                = Am*sin(omega_m*t);

%    Modulante pulso triangular

x = triangularPulse(0,(t_max-delta_t)/2,(t_max-delta_t),t) ;


% Modulante Rampa
% x_max            = 1;
% v_t              = x_max/t_max;
% x                = v_t*t;

% Modulante Multitono (genérica)
% Am               = 1;
% Am_1             = 0.5*Am;          % 50%
% Am_2             = 0.3*Am;          % 30%
% Am_3             = Am-Am_1-Am_2;    % 20%
% % Recordar que para mantener la normalización, la sumatoria de los módulos
% % de las amplitudes debe dar menor o igual a 1.
% f_m              = 3/t_max;                      
% omega_m          = 2*pi*f_m;
% x                = Am_1*cos(omega_m*t) ...
%                    + Am_2*cos(omega_m*2/3*t)...
%                    + Am_3*cos(omega_m*1/3*t);

%% Generación de Portadora
f_c              = 100/t_max;                   % 100 períodos de portadora en eje t
omega_c          = 2*pi*f_c;

%% Señal de AM
mu               = 1;
Ac               = 10;
x_c_am           = Ac*(1 + mu*x).*sin(omega_c*t);

%% Señal de PM
fi_delta         = pi;    % Valor en radian, menor o igual a pi.
Ac               = 10;
x_c_pm           = Ac*sin(omega_c*t + fi_delta*x);

%% Señal de FM

f_delta          = 20e3;            
% En general, f_delta es muy pequeño al compararse con f_c e incluso con
% f_m; se eligió un f_delta considerable en este caso para que sea
% apreciable en el gráfico de FM. Este no suele ser el caso real.
omega_delta      = 2*pi*f_delta;
% La fase es afectada por la integral del mensaje en FM.
x_int            = cumsum(x)*delta_t;   % Área bajo curva por rectángulos.
x_int            = x_int-mean(x_int);   % Eliminación de la continua
Ac               = 10;
x_c_fm           = Ac*sin(omega_c*t + omega_delta*x_int);

%% Figuras
figure(1)
subplot(4,1,1)
plot(t,x),xlabel('t'),ylabel('x(t)')
subplot(4,1,2)
plot(t,x_c_am),xlabel('t'),ylabel('AM')
subplot(4,1,3)
plot(t,x_c_pm),xlabel('t'),ylabel('PM')
subplot(4,1,4)
plot(t,x_c_fm),xlabel('t'),ylabel('FM')


figure (2)

phi = omega_delta*x_int ; 
fHz = f_c + fi_delta*x ;

subplot(2,1,1)
plot(t,phi),xlabel('t'),ylabel('phi(t)')
title('MODULACION FM');
subplot(2,1,2)
plot(t,fHz),xlabel('t'),ylabel('f(t)')


figure (3)
x_der = diff(x)/delta_t; 
phi = omega_delta*x ; 
fHz = f_c + (fi_delta)/(2*pi)*x_der ;

subplot(2,1,1)
plot(t,phi),xlabel('t'),ylabel('phi(t)')
title('MODULACION PM');
subplot(2,1,2)
plot(t(:,1:length(fHz)),fHz),xlabel('t'),ylabel('f(t)')

