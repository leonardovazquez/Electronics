clear;
//Cálculo del gráfico de Bode Asintótico
//
function [fase]=fase_asymp(w,wi)
// fase asintótica
// Calcula el valor de fase por la aproximación asintótica
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
// Calcula el valor de ganancia por la aproximación asintótica
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
        ylabel("Ganancia [dB]")
        plot2d("ln",wx,db,color("black"));
    case 1 then
        plot2d("ln",wx,Ganancia,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Ganancia")
        ylabel("Ganancia [dB]")
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
            ylabel("Fase [º]")
    xlabel("Frecuencia [rad/seg]")
        plot2d("ln",wx,phi_r,color("black"));
    case 1 then
        plot2d("ln",wx,Fase,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Fase")
        ylabel("Fase [º]")
        xlabel("Frecuencia [rad/seg]")
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
