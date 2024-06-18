%% Practica 9: SISTEMAS DIFERENCIALES Y EN DIFERENCIAS
% 
%% Integrantes
%%
% 
% * Barrera Martinez Paola Angelica
% * Espino Chavez Brandon Daniel
% * Gonzalez Lopez Dani
% * Villavicencio Salinas Miguel Angel
% * Zetina Arellano Luis Enrique
% 
%% Objetivo
% Para sistemas diferenciales realiza un programa con las siguientes
% características:
% 1- Muestra la función de transferencia del sistema 2- Muestra la respuesta al impulso (simbólico, gráfica) 3- Muestra la respuesta a entrada cero (simbólico, gráfica) 4- Muestra la respuesta a estado cero (simbólico, gráfica) 5- Muestra la respuesta total (simbólico, gráfica) 6- La respuesta total al escalón con condiciones iniciales 0 (simbólico, gráfica) 7- Usando subplot, depliega una figura con 5 gráficas 
% 
% Entregables sistemas en diferencias Para sistemas diferenciales realiza
% un programa con las siguientes características:
% 1- Muestra la función de transferencia del sistema 2- Muestra la respuesta al impulso (simbólico, gráfica, ver KroneckerDelta) 3- Muestra la respuesta a entrada cero (simbólico, gráfica) 4- Muestra la respuesta a estado cero (simbólico, gráfica) 5- Muestra la respuesta total (simbólico, gráfica) 6- La respuesta total al escalón con condiciones iniciales 0 (simbólico, gráfica) 7- Usando subplot, depliega una figura con 5 gráficas
%
% 
%% Desarrollo
% Para el desarrollo se tienen que resolver cada uno de los siguientes problemas comenzando una nueva sección para cada uno de ellos. Para cada problema se tendrán que hacer las modíficaciones necesarias al código de ejemplo, convendría entonces pensar en realizar una modificación general de tal manera que el programa funcione para la mayoria.
%%
% 
% <<Ejercicios.jpeg>>
% 
%% Tiempo continuo Problema 1 Laplace
% Respuesta del sistema
%
syms t
sympref('HeavisideAtOrigin',1);
laplace2016a([3 3 1],[1 -1],[1 1],cos(2*t)*heaviside(t),10)

%% Problema 1 Fourier
% Respuesta a condiciones iniciales igual a 0
%
syms t
sympref('HeavisideAtOrigin',1)
fourier2016a([3 3 1],[1 -1],cos(2*t)*heaviside(t),10)
%% Tiempo discreto problema 2 Fourier
%
syms t
sympref('HeavisideAtOrigin',1)
fourier2016a([2 1],[0 2],heaviside(t),5)
%% Problema 2 Transformada Z
%
syms n
sympref('HeavisideAtOrigin',1)
zeta2016a([1 2 0],2,[-12 -6],[1 1],heaviside(n),5)
%% Tiempo discreto Problema 3 Fourier
%
syms t
sympref('HeavisideAtOrigin',1)
fourier2016a([1 -3 2],[0 -3 4],exp(-2*t)*heaviside(t),10)

syms n
sympref('HeavisideAtOrigin', 1);
fourier2016a([1 -3 2],[0 -3 4],((1/4)^n)*heaviside(n),10)

%% Problema 3 Transformada z
%
syms n
sympref('HeavisideAtOrigin', 1);
zeta2016a([2 -3 1],[4 -3 0],[0 0],[1 1],((1/4)^4)*heaviside(n),10)

%% Sistemas diferenciales (Transformada de Fourier)
%
% Se utiliza por medio de herramientas matemáticas símbolicas, con el fin
% de generar un programa que soluciona sistemas diferenciales de orden
% nmediante la Transformada de Fourier, dicho programa proporciona: paso a
% paso la metodología de resolución, y la gráfica tanto de la señal de
% entrada como la señal de salida. El codigo programado se ve de la
% siguiente forma: 
% 
%   function fourier2016a(a,b,xi,t0)
% %a coeficientes de las derivadas de la salida menor a mayor [a_0, ..., a_n]
% %b coeficientes de las derivadas de la entrada menor a mayor [b_0, ..., b_m]
% %xi función de entrada en terminos de la variable simbolica t previamente
% %declarada en el command window
% %t0 tiempo final para graficar la solucion, la derivada, y la segunda 
% %derivada 
% %ejemplo: resolver y^(2)+2y^(1)+2y=x^(1)+2x con y^(1)(0)=0
% %y(0)=0, x(0)=0, x(t)=exp(-t)u(t), para 5 segundos, se resuleve como
% %syms t
% %fourier2016a([2 2 1],[2 1],exp(-t)*heaviside(t),5)
% close all
% tam=size(a);
% tami=size(b);
% syms y(t) Y(w) x(t) X(w) Yy fp;
% syms edd edi 
% edd=0;
% edi=0;
% for i=1:tam(2)
%        edd=edd+a(i)*(j*w)^(i-1)*Y(w);
% end
% for i=1:tami(2)
%       edi=edi+b(i)*(j*w)^(i-1)*X(w);  
% end
% mensaje('APLICAMOS TRANSFORMADA DE FOURIER')
% pretty(edd)
% disp('=')
% pretty(edi)
% mensaje('SUBSTITUIMOS LA TRANSFORMADA DE LA ENTRADA')
% edi=subs(edi,X(w), fourier(xi));
% pretty(edd)
% disp('=')
% pretty(edi)
% mensaje('DESPEJAMOS Y(w)')
% edd=collect(edd,Y(w));
% edd=subs(edd,Y(w),Yy);
% eq1=edd==edi;
% disp('Y(w)=')
% edd=solve(eq1, Yy);
% pretty(edd)
% %Para versiones superiores a 2016
% mensaje('DESARROLLAMOS LAS FRACCIONES PARCIALES DE Y(w)')
% disp('Y(w)=')
% pretty(partfrac(edd))
% %Si se ejecuta en 2015 o menor comentar las 3 lineas anteriores
% mensaje('Aplicamos transformada inversa, asi la solución es')
% disp('y(t)=')
% y(t)=ifourier(edd,t);
% pretty(y(t))
% figure (1)
% hFig = figure(1);
% set(hFig, 'Position', [0 0 900 900])
% axes1 = axes('Parent',hFig,'FontWeight','bold','FontSize',16);
% tiempo=0:0.01:t0;
% fplot(xi,[0, t0],'b','LineWidth',2)
% hold on
% fplot(y,[0,t0],'r','LineWidth',2)
% legend('Entrada x(t)','Salida y(t)','Location','Best')
% xlabel('tiempo','FontWeight','bold','FontSize',16)
% title('Entrada y Respuesta del sistema','FontWeight','bold','FontSize',16)
% grid on
% end
% function mensaje(texto)
% disp( ' ')
% disp(texto)
% disp( ' ')
% end
% 
 