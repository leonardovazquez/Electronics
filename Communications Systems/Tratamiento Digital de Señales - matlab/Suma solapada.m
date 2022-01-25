%%%GUIA 7 EJERCICIO 5

clear
clc 

%%DEFINICION DE ENTRADA Y RESPUESTA AL IMPULSO

xn = [1 3 2 -3 0 2 -1 0 -2 3 -2 1]

hn = [1 0 1]

yn = conv(hn,xn)

L = 6;
%%SUMA SOLAPADA

for l=4:1:L
   hn(l)=0; 
end

hnz=hn

x1 = xn(1:L)

x2= xn((L+1):(2*L))

y1 = conv(hnz,x1)

y2 = conv(hnz,x2)

yz =  y1 ;

for i=0:1:1
   
   yz(8-i)=y1(8-i)+y2(2-i); 
    
end
yz

for i=1:1:(8-2)
    yz(8+i) = y2(2+i);
end

yz

