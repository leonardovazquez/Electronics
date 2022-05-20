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

function [Ganancia,Fase,wx]=bode_asym(G1,fx,tipo,color1)
    // Grafica el diagrama de Bode asintótico
    // G1 es la transferencia a graficar
    // fx es el vector de valores de frecuencia [Hz] para calcular el Bode
    // tipo es l formato de gráfico
    //          0 : Diagrama de Bode en Hz con el grafico exacto
    //          1 : Diagrama de Bode en Hz solo asintótico
    //          2 : Diagrama de Bode en rad/seg solo asintótico
    //transformación de frecuenciawx=2*%pi*fx;
    wx=2*%pi*fx;
    [ceros1,polos1,K1]=tf2zp(G1);
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
        plot2d("ln",fx,Ganancia,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Ganancia")
        gainplot(G1,fx);
    case 1 then
        plot2d("ln",fx,Ganancia,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Ganancia")
    case 2 then    
        plot2d("ln",wx,Ganancia,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Ganancia")
    end    
// Cálculo de la fase
    if K0<0 then
        Fsk=-180
    else
        Fsk=0
    end
    for i=1:length(wx)
        Fase(i)=Fsk
        for j=1:length(ceros1)
            if ceros1(j)<=0 then
                Fase(i)=Fase(i)+fase_asymp(abs(ceros1(j)),wx(i));
            else
                Fase(i)=Fase(i)-fase_asymp(abs(ceros1(j)),wx(i));
            end
        end
        for k=1:length(polos1)
            if polos1(k)<=0
                Fase(i)=Fase(i)-fase_asymp(abs(polos1(k)),wx(i));
            else
                Fase(i)=Fase(i)+fase_asymp(abs(polos1(k)),wx(i));
            end
        end
    end
    fx=wx/2/%pi;
    subplot(212)
    select tipo
    case 0 then
        plot2d("ln",fx,Fase,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Fase")
        phaseplot(G1,fx);
    case 1 then
        plot2d("ln",fx,Fase,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Fase")
    case 2 then    
        plot2d("ln",wx,Fase,color(color1));
        xgrid(color("gray"))
        title("Diagrama de Bode de Fase")
    end
    f = gcf();
    f.background = 8;
endfunction;

