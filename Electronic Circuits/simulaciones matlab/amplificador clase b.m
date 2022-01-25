%%%%%circuitos electronicos 1
%%%amplificador clase b basico de fuente simple
clc
clear all
close all



t=0:0.01:25;
V02=funcion2(t);
V01=funcion1(t);
Vx=(2/3)*V01+(1/3)*V02;
figure (1)
hold on
plot(t,V02,'r')
plot(t,V01,'b')
plot(t,Vx,'g')
ylim([-13 13])
xlabel('t(ms)')
ylabel('Volts')
legend({'V02(t)','V01(t)','Vx(t)'},'Location','southwest');
hold off
%%SEÑALES DE ENTRADA

function V02=funcion2(x)
V02=12.*(x<0.28)-12.*((x>=0.28)&(x<=10.28))+12.*((x>=10.28)&(x<=10.84))-12.*((x>=10.84)&(x<=20.84)) +12.*((x>=20.84)&(x<=21.4))-12.*((x>=21.4)&(x<=30));
end

function V01=funcion1(x)
C=0.1e-6;
m1=0.12e-6*(1/C);
m2=-2.14e-6*(1/C); 

V01=(m2*x).*(x<=0.28)+(-6+m1*(x-0.28)).*((x>0.28)&(x<=10.28))+(6+m2*(x-10.28)).*((x>10.28)&(x<=10.84))+(-6+m1*(x-10.84)).*((x>10.84)&(x<=20.84))+(6+m2*(x-20.84)).*((x>20.84)&(x<=21.4))+(-6+m1*(x-21.4)).*((x>21.4)&(x<=30));
end

