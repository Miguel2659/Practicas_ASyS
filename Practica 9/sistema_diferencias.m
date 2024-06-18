function sistema_diferencias(a, b, ciy, cix, xi, n0)
    % a coeficientes de las traslaciones de la salida mayor a menor [a_n, ..., a_0]
    % b coeficientes de las traslaciones de la entrada mayor a menor [b_m, ..., b_0]
    % ciy condiciones iniciales de la salida de mayor a menor [y(n-1), y(0)]
    % cix condiciones iniciales de la entrada de mayor a menor [x(m-1), x(0)]
    % xi funcion de entrada en terminos de la variable simbolica n previamente
    % declarada en el command window
    % n0 tiempo final para graficar la solucion, y la entrada
    % ejemplo: resolver 
    % 6y[n+2]+5y[n+1]+y[n]=x[n+1]+x[n] con y[1]=2 y[0]=1
    % x[0]=0.5, x[n]=u[n], para 30 segundos, se resuleve como
    % syms n
    % zeta2016a([6 5 1],[1 1],[2 1],[0.5],heaviside(n),30)
    
    close all
    tam = size(a);
    tami = size(b);
    syms y(n) n z Y(z) x(n) X(z) Yy;
    syms edd edi
    edd = 0;
    edi = 0;

    % Construcción de la ecuación en diferencias en el dominio Z
    for i = 1:tam(2)
        yd(i) = y(n+tam(2)-i);
        edd = edd + a(i)*ztrans(yd(i));   
    end

    for i = 1:tami(2)
        xd(i) = x(n+tami(2)-i);
        edi = edi + b(i)*ztrans(xd(i));   
    end

    mensaje('APLICAMOS TRANSFORMADA ZETA ')
    edd = subs(edd, ztrans(y(n), n, z), Y(z));
    edi = subs(edi, ztrans(x(n), n, z), X(z));
    pretty(edd)
    disp('=')
    pretty(edi)
    mensaje('SUBSTITUIMOS CONDICIONES INICIALES')

    for j = 1:tami(2)-1
        edi = subs(edi, x(tami(2)-1-j), cix(j));
    end

    for j = 1:tam(2)-1
        edd = subs(edd, y(tam(2)-1-j), ciy(j));
    end

    pretty(edd)
    disp('=')
    pretty(edi)

    mensaje('SUBSTITUIMOS LA TRANSFORMADA DE LA ENTRADA')

    edi = subs(edi, X(z), ztrans(xi));
    pretty(edd)
    disp('=')
    pretty(edi)

    mensaje('DESPEJAMOS Y(z)')

    edd = collect(edd, Y(z));
    edd = subs(edd, Y(z), Yy);
    eq1 = edd == edi;
    disp('Y(z)=')
    edd = solve(eq1, Yy);
    pretty(edd)

    % Función de transferencia
    G = edd / ztrans(xi);
    disp('La función de transferencia G(z) es:')
    pretty(simplify(G))

    % Respuesta al impulso
    disp('Respuesta al impulso:')
    y_impulse = iztrans(G * kroneckerDelta(n));
    pretty(y_impulse)

    % Respuesta a entrada cero (solución homogénea)
    disp('Respuesta a entrada cero (solución homogénea):')
    y_homog = iztrans(subs(edd, X(z), 0));
    pretty(y_homog)

    % Respuesta a estado cero (solución particular)
    disp('Respuesta a estado cero (solución particular):')
    y_partic = iztrans(edd);
    pretty(y_partic)

    % Respuesta total
    disp('Respuesta total:')
    y_total = y_homog + y_partic;
    pretty(y_total)

    % Respuesta total al escalón con condiciones iniciales 0
    disp('Respuesta total al escalón con condiciones iniciales 0:')
    y_step = iztrans(G / (1 - z^(-1)));
    pretty(y_step)

    % Graficar todas las respuestas
    figure
    hFig = figure(1);
    set(hFig, 'Position', [0 0 900 900])
    tiempo = 0:1:n0;

    % Subplot 1: Respuesta al impulso
    subplot(3, 2, 1);
    stem(tiempo, subs(y_impulse, n, tiempo), 'LineWidth', 2);
    title('Respuesta al impulso');
    grid on;

    % Subplot 2: Respuesta a entrada cero (solución homogénea)
    subplot(3, 2, 2);
    stem(tiempo, subs(y_homog, n, tiempo), 'LineWidth', 2);
    title('Respuesta a entrada cero (solución homogénea)');
    grid on;

    % Subplot 3: Respuesta a estado cero (solución particular)
    subplot(3, 2, 3);
    stem(tiempo, subs(y_partic, n, tiempo), 'LineWidth', 2);
    title('Respuesta a estado cero (solución particular)');
    grid on;

    % Subplot 4: Respuesta total
    subplot(3, 2, 4);
    stem(tiempo, subs(y_total, n, tiempo), 'LineWidth', 2);
    title('Respuesta total');
    grid on;

    % Subplot 5: Respuesta total al escalón con condiciones iniciales 0
    subplot(3, 2, 5);
    stem(tiempo, subs(y_step, n, tiempo), 'LineWidth', 2);
    title('Respuesta al escalón con condiciones iniciales 0');
    grid on;
end

function mensaje(texto)
    disp(' ')
    disp(texto)
    disp(' ')
end
