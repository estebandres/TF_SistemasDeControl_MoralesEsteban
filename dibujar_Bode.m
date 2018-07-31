function dibujar_Bode(sys_A,sys_B,W)
%
%
%sys1 = tf([1],[0.001386 0.15 1.149 1])
%sys2 = tf([2.59 2.72],[0.001386 0.1559 1.794 5.939 4.3 0])

formato='%0.2f';
[mag_A fase_A] = bode(sys_A,W);
[mag_B fase_B] = bode(sys_B,W);

[ceros_A,polos_A,k_A] = zpkdata(sys_A,'v')

ceros_A=abs(ceros_A)
polos_A=abs(polos_A)

val_ceros_A=zeros(size(ceros_A))
val_polos_A=zeros(size(polos_A))

[ceros_B,polos_B,k_B] = zpkdata(sys_B,'v')

ceros_B=abs(ceros_B)
polos_B=abs(polos_B)

val_ceros_B=zeros(size(ceros_B))
val_polos_B=zeros(size(polos_B))

[Mgan_A,Mfase_A,Wcg_A,Wcf_A] = margin(sys_A)
mag_A=squeeze(mag_A);
mag_A=mag2db(mag_A);
mag_cor_A=interp1(W,mag_A,Wcg_A)
fase_A=squeeze(fase_A)';
fase_cor_A=interp1(W,fase_A,Wcf_A)
[Mgan_B,Mfase_B,Wcg_B,Wcf_B] = margin(sys_B)
mag_B=squeeze(mag_B)';
mag_B=mag2db(mag_B);
mag_cor_B=interp1(W,mag_B,Wcg_B)
fase_B=squeeze(fase_B)';
fase_cor_B=interp1(W,fase_B,Wcf_B)

subplot(2,1,1)
%set(axes_handle,'YLim',[-20 Inf]);

semilogx(W,mag_A(:,:),'b--','LineWidth',2);hold on; grid on

%axis([-inf inf -20 inf])
plot(ceros_A,val_ceros_A,'bo','MarkerSize',14,'LineWidth',2);
if(any(ceros_A==0))
    plot(W(1),0,'bo','MarkerSize',14,'LineWidth',2,'MarkerFaceColor','b');
end
plot(polos_A,val_polos_A,'bx','MarkerSize',14,'LineWidth',2);
if(any(polos_A==0))
    plot(W(1),0,'bx','MarkerSize',14,'LineWidth',2,'MarkerFaceColor','b');
end
plot(Wcg_A,mag_cor_A,'co','MarkerSize',10,'LineWidth',2);

semilogx(W,mag_B(:,:),'r','LineWidth',2); grid on

plot(ceros_B,val_ceros_B,'ro','MarkerSize',10,'LineWidth',2);
if(any(ceros_B==0))
    plot(W(1),0,'ro','MarkerSize',10,'LineWidth',2,'MarkerFaceColor','r');
end
plot(polos_B,val_polos_B,'rx','MarkerSize',10,'LineWidth',2);
if(any(polos_B==0))
    plot(W(1),0,'rx','MarkerSize',10,'LineWidth',2,'MarkerFaceColor','r');
end
%plot([Wcg_B Wcg_B],get(gca,'YLim'),'g--','LineWidth',2);
plot(Wcg_B,mag_cor_B,'go','MarkerSize',10,'LineWidth',2);

x_limites=get(gca,'XLim');
y_limites=get(gca,'YLim');

plot(x_limites,[0 0],'k','LineWidth',1);

txstr(1) = {'\bf\color{blue}-- \it\color{black}No Compensado'};
txstr(2) = {'\bf\color{red}-- \it\color{black}Compensado'};
txstr(3) = {'\bf\color{cyan}o \it\color{black}Margen Ganancia no comp.'};
txstr(4) = {'\bf\color{green}o \it\color{black}Margen Ganancia comp.'};
text(x_limites(2),y_limites(2),txstr,'HorizontalAlignment','right','VerticalAlignment','Top')


hold off;
%semilogx(x,y);hold off

%################################## #######################################%

subplot(2,1,2)
semilogx(W,fase_A(:,:),'b--','LineWidth',2);hold on; grid on
plot(ceros_A,val_ceros_A,'bo','MarkerSize',14,'LineWidth',2);
if(any(ceros_A==0))
    plot(W(1),0,'bo','MarkerSize',14,'LineWidth',2,'MarkerFaceColor','b');
end
plot(polos_A,val_polos_A,'bx','MarkerSize',14,'LineWidth',2);
if(any(polos_A==0))
    plot(W(1),0,'bx','MarkerSize',14,'LineWidth',2,'MarkerFaceColor','b');
end
plot(Wcf_A,fase_cor_A,'ko','MarkerSize',10,'LineWidth',2);

semilogx(W,fase_B(:,:),'r','LineWidth',2);grid on
plot(ceros_B,val_ceros_B,'ro','MarkerSize',10,'LineWidth',2);
if(any(ceros_B==0))
    plot(W(1),0,'ro','MarkerSize',10,'LineWidth',2,'MarkerFaceColor','r');
end
plot(polos_B,val_polos_B,'rx','MarkerSize',10,'LineWidth',2);
if(any(polos_B==0))
    plot(W(1),0,'rx','MarkerSize',10,'LineWidth',2,'MarkerFaceColor','r');
end
plot(Wcf_B,fase_cor_B,'mo','MarkerSize',10,'LineWidth',2);

x_limites=get(gca,'XLim');
y_limites=get(gca,'YLim');

plot(x_limites,[0 0],'k','LineWidth',1);

hold off;
%semilogx(x,y);hold off

%tf2ss()
%z(:, [1 3]) = z(:, [3 1])%cambia la columna 1 por la columna 3
%z([1 3], :) = z([3 1],:)%cambia la fila 1 por la fila 3

