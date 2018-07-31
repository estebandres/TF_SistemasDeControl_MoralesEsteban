close all
s=tf('s');

%************************************* ***********************************
% FUNCIONES DE TRANSFERENCIA DE LOS BLOQUES
TFactuador=(5/10)/(1);

TFdriver=(220/5)/(0.1386*s+1);

TFsistema=(1000/220)/(0.01*s+1);

TFsensor=(10/1000)/(s+1);
% *********************************** ************************************

G=TFactuador*TFdriver*TFsistema;
H=TFsensor;

% ************************************ ***********************************
% FUNCION DE TRANSFERENCIA DE LAZO ABIERTO
TFLA=TFactuador*TFdriver*TFsistema*TFsensor;

[z, p, k] = tf2zpk([1], [0.001386 0.15 1.149 1]);

% figure
% pzmap(TFLA)
% title('Grafico de Polos y Ceros')


% figure
% hold on
% step(10*TFLA)
% grid on
% title('TF lazo abierto Rta. a escalon')
% ylabel('Lumens')
% xlabel('tiempo [seg]')

% ************************************* **********************************
% FUNCION DE TRANSFERENCIA DE LAZO CERRADO

TFLC=feedback(G,TFsensor);

[z, p, k] = tf2zpk([100 100], [0.001386 0.15 1.149 2]);

% figure
% pzmap(TFLC)
% title('Grafico de Polos y Ceros')

% % Lugar de Raices 
% figure
% rlocus(TFLC)
% % grid
% title('Lugar de Raices')

% ************************************** *********************************
% FUNCION DE TRANSFERENCIA DE LAZO CERRADO

disp('Funcion de transferencia a lazo directo')
TFLD=TFactuador*TFdriver*TFsistema;


% *************************************** ********************************
% COMPENSACION CON EL INTEGRADOR

int = tf([0.1],[1 0]);

disp('FT de lazo abierto con integrador')
TFLA_int = TFactuador*TFdriver*TFsistema*TFsensor*int;
% pole(TFLA_int)
% disp('FT de lazo abierto con integrador en zpk')
% [x, y, w]=tf2zpk ([0.1],[0.001386 0.15 1.149 1 0])
% % Lugar de Raices 
% figure
% rlocus(TFLA_int)
% % grid
% title('Lugar de Raices LA con el integrador')

TFLC_int = feedback(G*int,TFsensor);

% % Lugar de Raices 
% figure
% rlocus(TFLC_int)
% % grid
% title('Lugar de Raices LC')
% 
% figure
% hold on
% step(10*TFLA_int)
% grid on
% title('TF lazo abierto int Rta. a escalon')
% ylabel('Lumens')
% xlabel('tiempo [seg]')
% 
% figure
% hold on
% step(10*TFLC_int)
% grid on
% title('TF lazo cerrado int Rta. a escalon')
% ylabel('Lumens')
% xlabel('tiempo [seg]')

% figure
% hold on
% step(10*TFLC)
% grid on
% title('TF lazo cerrado Rta. a escalon')
% ylabel('Lumens')
% xlabel('tiempo [seg]')


% **************************************** *******************************
% CALCULO DE GANANCIA DEL COMPENSADOR (Kc)

% x=-1.5+1.5i;
% kc=1/((x+1.05/x+4.5)*(0.1/x*(x+1)*(x+7.22)*(x+100)))
disp('FT del compensador')
PID = (2.59*(s+1.05))/(s*(s+4.3));
disp('FT del sistema compensado de lazo abierto')
SIST_COM_LA = PID*TFLA;
[z,p,k] = tf2zpk([2.59 2.72],[0.001386 0.1559 1.794 5.939 4.3 0]);
disp('FT del sistema compensado de lazo cerrado')
SIST_COM_LC = feedback(G*PID,TFsensor);
% [z,p,k] = tf2zpk([259 531 272],[0.001386 0.1559 1.794 5.939 6.89 2.72])

% % Lugar de Raices 
% figure
% rlocus(SIST_COM_LA)
% % grid
% title('Lugar de Raices del sistema compensado')
 
% figure
% hold on
% step(10*SIST_COM_LC)
% grid on
% title('Entrada escalon. Rta con compensador')
% ylabel('Lumens')
% xlabel('tiempo [seg]')


% ***************************************** ******************************
% BODE: RESPUESTA EN FRECUENCIA

disp('dibujar Bode')
W=[0.01:0.01:100];
% dibujar_Bode(TFLA, SIST_COM_LA, W)

% Respuesta En Frecuencia 
% figure
% hold on
% margin(TFLA)
% margin(SIST_COM_LA)
% % grid
% title('Respuesta en Frecuencia')

% ****************************************** *****************************
% VARIABLES DE ESTADO

disp('Descomposicion de sistema NO compensado a lazo abierto')
b=[100];
a=[0.001386 0.1486 1];
[A,B,C,D]=tf2ss(b,a)

disp('Descomposicion de sistema compensado a lazo abierto')
c=[2.59 2.72];
d=[0.001386 0.1559 1.794 5.939 4.3 0];
[E,F,G,H]=tf2ss(c,d)

disp('Matriz de controlabilidad del sistema compensado')
Co = ctrb(E,F);
rank(Co);

disp('Matriz de observabilidad del sistema compensado')
Ob = obsv(E,G)
rank(Ob)
