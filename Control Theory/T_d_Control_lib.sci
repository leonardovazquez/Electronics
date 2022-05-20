// Librería de Funciones de Teoría de Control
// T_d_Control_lib.sci
// Facultad de Ingeniería - UNMDP.
// Walter Kloster
// 2022

function Gsimp=simpl(Gcomp,tol)
// Simplificación de polos y ceros de una función de transferencia
// Gcomp puede ser "zpk","rational" o "state-space"
// Tolerancia es el error relativo para simplificar un polo y cero
// Gsimp es una función de transferencia ("rational")

// Transformación de los formatos de entarda a "rational""
    if typeof(Gcomp)=="zpk" then
        Gt=zp2tf(Gcomp.Z{1},Gcomp.P{1},Gcomp.K(1))
    end
    if typeof(Gcomp)=="state-space" then
        Gt=ss2tf(Gcomp)
    end
    if typeof(Gcomp)=="rational" then
        Gt=(Gcomp)
    end
// Detección de los elementos comunes del denominador y numerador
    k=1
    [ceros,polos,ganancia]=tf2zp(Gt)
    spolo=[]        // indice del elemento común del denominador
    scero=[]        // indice del elemento común del numerador
    for i=1:length(polos)
        for j=1:length(ceros)
            if abs(polos(i)-ceros(j))<=tol*(1+abs(polos(i))) then
                spolo(k)=i;
                scero(k)=j;
                k=k+1;
            end 
        end
    end
    polos(spolo')=[]    // Se borran los elementos comunes
    ceros(scero')=[]

    Gsimp=zpk(ceros,polos,ganancia,"c")
endfunction


//Cálculo del gráfico de Bode Asintótico
//
function [fase]=fase_asymp(w,wi)
// fase asintótica
// Calcula el valor de fase por la aproximación asistótica
// para una singularidad ubicada en w [rad/seg]
// wi es la frecuencia [rad/seg] a la que se desea calcular la fase
if wi<=w/10 then
    fase=0;
end
if wi>10*w then
    fase=90;
end
if (wi>w/10 & wi<=10*w) then
    fase=45*log10(wi/w*10);
end
endfunction;
//
function [ganancia]=ganancia_asymp(w,wi)
// ganacia asintótica
// Calcula el valor de ganancia por la aproximación asistótica
// para una singularidad ubicada en w [rad/seg]
// wi es la frecuencia [rad/seg] a la que se desea calcular la fase
if w==0 then
        ganancia=20*log10(wi);
else
    if wi<=w then
        ganancia=0;
    end
    if wi>w then
        ganancia=20*log10(wi/w);
    end
end
endfunction;

function [Ganancia,Fase,wx]=bode_asym(G1,wx,tipo,color1)
    // Grafica el diagrama de Bode asintótico
    // G1 es la transferencia a graficar
    // fx es el vector de valores de frecuencia [Hz] para calcular el Bode
    // tipo es l formato de gráfico
    //          0 : Diagrama de Bode en rad/seg con el grafico exacto
    //          1 : Diagrama de Bode en rad/seg solo asintótico
    //transformación de frecuenciawx=2*%pi*fx;
    fx=wx/2/%pi;
    [ceros1,polos1,K1]=tf2zp(G1);
    ceros1=clean(ceros1);
    polos1=clean(polos1);
    [fx1,rep] =repfreq(G1,fx);// Calcula la respuesta en frecuencia
                            // en números complejos
    [db,phi]=dbphi(rep);        // Transforma los complejos en módulo y fase
    //Cálculo de la ganancia
    K0=K1;
    for j=1:length(ceros1)
        if ceros1(j)<>0 then
            K0=K0*-ceros1(j);
        end
    end
    for k=1:length(polos1)
        if polos1(k)<>0 then
            K0=K0/-polos1(k)
        end
    end
    K0
// Cálculo de Amplitud
    for i=1:length(wx)
        Ganancia(i)=20*log10(abs(K0));
        for j=1:length(ceros1)
            Ganancia(i)=Ganancia(i)+ganancia_asymp(abs(ceros1(j)),wx(i));
        end
        for k=1:length(polos1)
            Ganancia(i)=Ganancia(i)-ganancia_asymp(abs(polos1(k)),wx(i));
        end
    end
    subplot(211)
    select tipo
    case 0 then
        plot2d("ln",wx,Ganancia,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Ganancia")
        plot2d("ln",wx,db,color("blue"));
    case 1 then
        plot2d("ln",wx,Ganancia,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Ganancia")
    end    
// Cálculo de la fase
    if real(K0)<0 then
        Fsk=-180
    else
        Fsk=0
    end
    for i=1:length(wx)
        Fase(i)=Fsk;
        for j=1:length(ceros1)
            if real(ceros1(j))<=0 then
                Fase(i)=Fase(i)+fase_asymp(abs(ceros1(j)),wx(i));
            else
                Fase(i)=Fase(i)-fase_asymp(abs(ceros1(j)),wx(i));
            end
        end
        for k=1:length(polos1)
            if real(polos1(k))<=0
                Fase(i)=Fase(i)-fase_asymp(abs(polos1(k)),wx(i));
            else
                Fase(i)=Fase(i)+fase_asymp(abs(polos1(k)),wx(i));
            end
        end
    end
    fx=wx/2/%pi;
    if Fase(1)<-180 then
        F0=-360;
    else
        F0=0;
    end
    phi_0=F0*ones(1,length(wx))
    phi_r=phi_0+phi
    subplot(212)
    select tipo
    case 0 then
        plot2d("ln",wx,Fase,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Fase")
        plot2d("ln",wx,phi_r,color("blue"));
    case 1 then
        plot2d("ln",wx,Fase,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Fase")
    end
    f = gcf();
    f.background = 8;
endfunction;

function set_my_line_styles(style, thickness)
    e = gce();
    e.children.line_style = style;
    e.children.thickness = thickness;
endfunction

// Fución para el cálculo de la red de atraso.
function [Gc]=atraso(a,wc)
    // Cálculo de la red de atraso en función 
    // de la atenuación y la frecuencia de corte
    s=%s;
    w0=wc/10;
    wp=w0/a;
    Gc=syslin("c",1+s/w0,1+s/wp);
endfunction;

// Función para el cálculo de la red de adelanto
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

// Librería de Nyquist Logarítmico

// NYQUISTLOG hace un gráfico polar de la función de transferencia 
// de lazo abierto sys: 
// La amplitud M=|sys| se convierte a una escala logarítmica de acuerdo
// con la función siguiente:
//
//          | M^(log10(2))    si M < 1
// L(M)=    |
//          | 2-M^(-log10(2)) si M > 1
//

// Marzo 2022
// Walter Kloster
// Departamento de Ingeniería Electrónica y Computación
// Universidad Nacional de Mar del Plata 
// Mar del Plata, Argentina.
//
// Versión modificada de la función Closed_Logarithmic_Nyquist por
// Roberto Zanasi y Federica Grossi.
//
// Puede distribuirse libremente para uso no comercial,
// pero deje la información anterior sin cambios, por
// de crédito y propósitos de retroalimentación

// ajuste del grosor de la linea para Plot2d
function set_my_line_styles(style,thickness)
    e = gce();
    e.children.line_style = style;
    e.children.thickness = thickness;
endfunction

// Nyquist Asintótico
function LogNyquist(sys,Nd,espesor)
// Parámetros de trazado	
n=2; 		// Base de la función L
//Nd=6; 		// Número de líneas de nivel 
clf
// Base del gráfico
Circ2=2*exp(%i*(0:0.01:1)*2*%pi);    // Círculo de radio 2
plot2d(real(Circ2),imag(Circ2),color("cyan"),rect=[-2.5,-2.5,2.5,2.5])
xgrid(color("gray"));
Circ1=exp(%i*(0:0.01:1)*2*%pi);    // Círculo de radio 1
plot(real(Circ1),imag(Circ1),'r--')
xx=1*exp(%i*%pi/4);
xstring(real(xx),imag(xx),"0 dB")   // Circulo de 0dB
plot2d(-1,0,-3)         // punto -1+j0 
plot2d(1,0,-3)         // punto +1+j0 
xstring(-0.95,-0.1,"-1+j0")
xstring(1.05,-0.1,"+1+j0")
title("Grafico de Nyquist Logarítmico") // Título

for v=1:4
    Circ0=1/(n^v)*exp(%i*(0:0.01:1)*2*%pi);    // Círculo de Ganancia
    plot(real(Circ0),imag(Circ0),'c:');
    Circ0=(2-1/(n^v))*exp(%i*(0:0.01:1)*2*%pi);
    plot(real(Circ0),imag(Circ0),'c:');
        if v<3
        xx=1/(n^v)*exp(%i*%pi/4);
        xstring(real(xx),imag(xx),sprintf('-%d dB',v*20));
        xx=(2-n^(-v))*exp(%i*%pi/4);
        xstring(real(xx),imag(xx),sprintf('%d dB',v*20));
     end
end

for w=1:12 // gráfico de sectores de pi/6 
    ps=2*exp(%i*w*%pi/6);
    plot([0 real(ps)],[0 imag(ps)],'c--');
end

// Cálculo de la curva de respuesta
wx=logspace(-Nd,Nd,500);    // Rango de frecuencias
fx=wx/2/%pi;
resp=repfreq(sys,fx);       // Respuesta en frecuencia
[DB,F]=dbphi(resp);
M=10^(DB/20);
for v=1:length(fx)          // Calculo del módulo para el gráfico
      if M(v)<=1 then
        Mn(v)=M(v)^(log10(2));
    else
        Mn(v)=2-M(v)^-(log10(2));
    end
end
for v=1:length(fx)           // Puntos para graficar
    Xn(v)=Mn(v)*cos(F(v)*%pi/180);
    Yn(v)=Mn(v)*sin(F(v)*%pi/180);
end
plot2d(Xn,Yn,color("scilabgreen4")); // Curva Logarítmica
set_my_line_styles(1,espesor);
plot2d(Xn,-Yn,color("scilabblue4"));
set_my_line_styles(1,espesor);
for i=0.25:0.5:2.0         // Flechas de circulación
    for j=1:1:length(Mn)
        if Mn(j)<i
            xf=[Xn(j);Xn(j+2)];
            yf=[Yn(j);Yn(j+2)];
            xarrows(xf,yf,2,color("scilabgreen4"))  // Dibujar flechas
            xg=[Xn(j+2);Xn(j)];
            yg=[Yn(j+2);Yn(j)];            
            xarrows(xg,-yg,2,color("scilabblue4"))  // Dibujar flechas
            break
        end
    end
end
// Cierre del gráfico de Nyquist
polos=roots(sys.den);
Npo=0
for i=1:length(polos)   // Calculo de polos en el Origen
    if polos(i)==0
        Npo=Npo+1;
    else
        Npo=Npo;
    end
end
Npo                     // Polos en el Origen
xstring(1,2,sprintf('Polos en el origen=%d',Npo));
if sign(horner(sys*s^Npo,0))>0  // Ganancia negativa
   signo=0;
else
    signo=1;
end    
Ang_inic=%pi/2*Npo+signo*%pi;           // Ángulo inicial
Ang=Ang_inic:-%pi/200:Ang_inic-%pi*Npo; // Ángulo final
Arco=2*exp(%i*Ang);
plot2d(real(Arco),imag(Arco),color("scilabmagenta2"));
set_my_line_styles(1,espesor);
cant_fl=50/Npo;                         // Cantidad de flechas
for w=cant_fl:cant_fl:199
    xf=[real(Arco(w+2));real(Arco(w))];
    yf=[-imag(Arco(w+2));-imag(Arco(w))];
    xarrows(xf,yf,2,color("scilabmagenta2"))  // Dibujar flechas
end

endfunction

// Trayecto de Nyquist
function TrayectoNyq(espesor)
figure("BackgroundColor",[1 1 1]);
clf
//espesor=3;
IM=1:0.1:10;
RE=zeros(1,length(IM));
plot2d(RE,IM,color("scilabgreen4"),rect=[-2,-12,12,12]);
set_my_line_styles(1,espesor);
plot2d(RE,-IM,color("scilabblue4"));
set_my_line_styles(1,espesor);
Circ1=10*exp(%i*((0:0.01:1)*%pi-%pi/2));    // Semi-círculo de radio 10
plot2d(real(Circ1),imag(Circ1),color("red"))
set_my_line_styles(1,espesor);
Circ2=1*exp(%i*((0:0.01:1)*%pi-%pi/2));    // Semi-círculo de radio 10
plot2d(real(Circ2),imag(Circ2),color("scilabmagenta2"))
set_my_line_styles(1,espesor);
xgrid
xarrows([0,0],[3,3.2],15,color("scilabgreen4"));
xarrows([0,0],[7,7.2],15,color("scilabgreen4"));
xarrows([0,0],[-3.2,-3],15,color("scilabblue4"));
xarrows([0,0],[-7.2,-7],15,color("scilabblue4"));
for v=16:33:100
    xarrows([real(Circ1(v+5));real(Circ1(v))],[imag(Circ1(v+5));imag(Circ1(v))],15,color("red"));
end
xarrows([0,6],[0,8],10,color("red"));
xstring(4,4,sprintf('infinito'));
t = gce();   // get the handle of the newly created object
t.font_foreground=color("red"); // change font properties
t.font_size=3;
t.font_style=4;
xarrows([0,0.6],[0,-0.8],10,color("scilabmagenta2"));
xstring(0.75,-1.7,sprintf('eps'));
t = gce();   // get the handle of the newly created object
t.font_foreground=6; // change font properties
t.font_size=3;
t.font_style=4;
title("Trayecto de Nyquist");
xstring(-0.7,-1.5,sprintf('j0-'));
xstring(-0.7,0.5,sprintf('j0+'));
xstring(-0.9,9.5,sprintf('j(inf)'));
xstring(-1,-10.5,sprintf('-j(inf)'));
endfunction

// módulo inverso
function [mod_real]=Mod_inv(mod_trans)
    if mod_trans<=1 then
        mod_real=10^(log10(mod_trans)/log10(2));
    else
        mod_real=10^(-log10(2-mod_trans)/log10(2));
    end
    mod_real
endfunction
