close all
s=tf('s');
%************************************* ***********************************
% FUNCIONES DE TRANSFERENCIA DE LOS BLOQUES
FTactuador=(1100)/(s+50);

FTplanta=(23)/(s+5);

FTsensor=(0.53)/(s+52.63);

FTabierto = FTactuador * FTplanta * FTsensor;

%figure
%pzmap(FTabierto)
%title('Grafico de Polos y Ceros')

G=FTactuador*FTplanta;
H=FTsensor;

FTlazoc=feedback(G,FTsensor);

%[z, p, k] = tf2zpk([25300 25300], [1 56 305 5310]);
TFLC_zpk = zpk(FTlazoc);

%figure
%pzmap(FTlazoc)
%title('Polos y Ceros de la FT de lazo cerrado')
t = 0:0.1:10;  % the time vector
input = t;
%lsim(FTlazoc, input, t);
FTLazoc_krlocus=feedback(0.0001*G,FTsensor);

% figure
% hold on
 opt = stepDataOptions('StepAmplitude',10);
  %step(TFLC,opt)
% grid on
% title('TF lazo cerrado Rta. a escalon')
% ylabel('Lumens')
% xlabel('tiempo [seg]')

G_poloenorig = G * (1/s);
FTlazoc_poloenorig = feedback(G_poloenorig,FTsensor);

%gp=tf([25300 25300],[1 56 305 5310]);
%ft1ro=tf([6036],[1 12]);

%pzmap(FTlazoc_poloenorig);
FTlazoa_poloorig = G_poloenorig*FTsensor;


%COMPadelanto = (s+6)/(s+53.48); %para 10+i10
COMPadelanto = (s+5)/(s+134.51); %para 13.33+i13.33
G_compypolo = G_poloenorig*COMPadelanto;
FTlazoa_compypolo = G_compypolo*FTsensor;
%rlocus(FTlazoa_compypolo)
%Teniendo en cuenta la ganancia observada en el diagrama
%Compensadorfinal=89*(s+6)/(s^2+53.48*s);
Compensadorfinal=277.5*(s+5)/(s^2+134.51*s);
FTcompysistema = Compensadorfinal * G;
FTlazoc_compensado = feedback(FTcompysistema,FTsensor);

z = [0.707 1.0];
%sgrid(z,0);
comp_pid=pid(Compensadorfinal);

W=[0.01:0.01:10000];
FTlazoa=G*H;
%dibujar_Bode(FTlazoa, FTlazoa_compypolo, W)
%bode(FTlazoa,FTlazoa_compypolo);