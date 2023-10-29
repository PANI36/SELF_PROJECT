% Code by Adwait Panindre, Department of Ocean Engineering, IIT Madras
% CODE for catenary mooring without buoyancy module provided you have...
% (xs) horizontal projection (metres), (y) vertical projection (metres), 
% (w) unit weight(kg/m) and Length of morring (L)

%#### INPUT ########
xs=200;     % meters ; Horizontal Projection
y=100;      % meters Depth
w=10;       % kg/m submerged weight
% Criteria for length selection.
L1=sqrt(xs^2+y^2);
L2=xs+y;
fprintf('\nLength of Mooring (L) should be integer such that %.2f<L<%.2f',L1,L2)
L=input('\nLength of Mooring (L) in meters : ');      % Length in meters
% Initial Guess for Th, So
Th=600.00;
So=100.00;
xn=[So;Th];
%######################
fprintf('\n      Iteration|    xn(1)     |     xn(2)      |    xn+1(1)      | xn+1(2)      | \n')
for k=1:100
    itr(k)=k;
    al=(xs-xn(1))/(xn(2)/w);% OK
    F1=xn(1)+((xn(2)/w)*sinh(al))-L; % OK
    F2=(xn(2)/w)*(cosh(al)-1)-y;% OK
    DF1S=1-cosh(al);
    DF2S=-sinh(al);
    DF2T=((1/w)*cosh(al))-(sinh(al)*((xs-xn(1))/xn(2)))-(1/w);
    DF1T=((1/w)*sinh(al))-(cosh(al)*(xs-xn(1))/xn(2));
    xn1=xn-(inv([DF1S DF1T;DF2S DF2T])*[F1;F2]);
    % xn1=round(-(inv([DF1S DF1T;DF2S DF2T])*[F1;F2]),4);
    % xn1=-(inv([DF1S DF1T;DF2S DF2T])*[F1;F2]);
    err=xn-xn1;
    E(k,1)=err(1);
    E(k,2)=err(2);
    
    fprintf('%10d     |%10.4f     | %10.4f    | %10.4f    | %10.2f    |\n',k,xn(1),xn(2),xn1(1),xn1(2))

    if abs(err)<1e-6
        break
    else
        xn=xn1;
    end
end

so=xn(1);
th=xn(2);
a=th/w;
x=xs-so;
dydx=sinh(x/a);
tv=th*dydx;
WT=sqrt(th^2+tv^2);
fprintf('Mooring Line on Seabed, So = %.4f',so)
fprintf('\nHorizontal Component of Winch Tension, Th = %.4f\n',th)
fprintf('Winch Tension, T = %.4f\n',tv)
% plot(itr,E)

%% Catenary Profile

X=linspace(0,x,50);
for i=1:length(X)
    Y(i)=a*(cosh(X(i)/a)-1);
end
plot(X,Y,'LineWidth',4) %TDP to fairlead
hold on
apx=[-so 0];
apy=[0 0];
plot(apx,apy,'r','LineWidth',5)% anchor point to TDP
hold off
xlim([-so x])
ylim([0 y])
xlabel('Distance between Anchor point to Fairlead (m)')
ylabel('Distance between TDP and Fairlead (m)')
txt = texlabel(['So = ', num2str(so)]);
txtt= texlabel(['Th = ', num2str(th)]);
x_pos1 = -20;x_pos2 = -20;
y_pos1 = 60; y_pos2 = 55;
text(x_pos1, y_pos1, txt);
text(x_pos2, y_pos2, txtt);


