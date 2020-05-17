clear;
close all;

y1=loadFile('muestras-88.7'); %Cargamos nuestro archivo con las muestras tomadas por el dongle

fs = 2048000;   %Frecuencia de muestreo

[f,Sxx]=DEP(y1,fs,'la señal modulada en FM');    %Graficamos la señal muestreada modulada en fm


fc=75000;   %Frecuencia de corte del filtro pasabajo
B1=2*fc;    %Ancho de banda de la señal a filtrar

[b1,a1]  = butter(10, fc/(fs/2), 'low');    %Calculamos los indices para realizar un filtrado pasa bajo
y_B1     = filter(b1,a1,y1);                %Calculamos la nueva señal pasada por un filtro pasa bajo

title=['la señal pasada por un filtro pasabajo con frecuencia de corte igual a ',num2str(fc),'Hz'];
[f,Sxx]=DEP(y_B1,fs,title);                 %Graficamos la señal de audio modulada en fm pasada por un filtro pasabajos

N1=fs/B1;                          %N1 < fs/2*w  Se calcula la cantidad de veces a diezmar
fsN1 = fs / N1;                             %Se calcula la nueva frecuencia de muestreo

y_N1 = decimate(y_B1,floor(N1),'fir');             %Se realiza el diezmado de la señal a N1

title=['la señal modulada diezmada ',num2str(floor(N1)),' veces'];
[f,Sxx]=DEP(y_N1,fsN1,title);               %Graficamos la señal diezmada N1 veces

%El codigo a continuación representa un discriminador de fase
xd = unwrap(angle(y_N1));
xd = [0; diff(xd).*fsN1];
yd = xd-mean(xd); 

[f,Sxx]=DEP(yd,fsN1,'la señal de audio Demodulada mediante el discriminador de fase');   %Graficamos la señal demodulada en FM

fc=7500;                                       %Frecuencia de corte del filtro pasabajo
B1=2*fc;                                        %Ancho de banda de la señal a filtrar

[b2,a2]  = butter(10, fc/(fsN1/2), 'low');      %Calculamos los indices para realizar un filtrado pasa bajo
y_B2     = filter(b2,a2,yd);                    %Calculamos la nueva señal pasada por un filtro pasa bajo 

title=['la señal pasada por un filtro pasabajo con frecuencia de corte igual a ',num2str(fc),'Hz'];
[f,Sxx]=DEP(y_B2,fsN1,title);                   %Graficamos la señal de audio demodulada en fm pasada por un filtro pasabajos


fsN2 = 48000;                                               %Frecuencia de muestreo a la que una placa de sonido reproduce correctamente  
N2 = (fsN1/fsN2);                                      %N2 = fsN1 / fsN2  Se calcula la cantidad de veces a diezmar

y_N2 = decimate(y_B2,floor(N2),'fir');                             %Se realiza el diezmado de la señal a N2

z_out = y_N2./max(abs(y_N2));                               %Dividimos la señal por el maximo de la misma para su normalización

title=['la señal diezmada ',num2str(floor(N2)),' veces'];
[f,Sxx]=DEP(z_out,fsN2,title);                              %Graficamos la señal diezmada N2 veces

sound(z_out,fsN2);                                          %Reproducimos la señal de audio obtenida

