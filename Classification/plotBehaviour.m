%% Script for plotting behaviours in RE-I* behaviour space

%Large Scale Automated Investigation of Free-Falling Paper Shapes via
%Iterative Physical Experimentation
%Toby Howison, Josie Hughes & Fumiya Iida


Psize=15; %Set marker size

%Set marker styles, colours and other settings
ChaosColour=[0 204/255 0];
ChaosColourEdge=[0 204/255 0];
ChaosMarker='o';

SteadyColour='r';
SteadyColourEdge='r';
SteadyMarker='o';

TumblingColour='b';
TumblingColourEdge='b';
TumblingMarker='o';

Ref1Colour=[0.2 0.2 0.2]*3;
Ref1ColourEdge='k';
Ref1Marker='+';

Ref2Colour=[0.2 0.2 0.2]*3;
Ref2ColourEdge='k';
Ref2Marker='.';

Ref3Colour=[0.2 0.2 0.2]*3;
Ref3ColourEdge='k';
Ref3Marker='x';

FontSize=18;
FontName='Helvetica';


%% Disk phase plot
%Plot classified behaviours in Re-I* state space and along with previous
%data from Field (1997) study.

load dataCircleClassified %Load circle data
load field1997_data %Load previous study (Field 1997) data

%Calcualte Re and I*
gsm=70;
t=2.5/(36*1000);
rhof=1.2754 ;
rho= gsm/(1000*t);
visc=1.48*(10^(-5));
Istar=pi*rho*t./(64*rhof*2*radius);
Re=(dz.*radius./time)*2/visc;
Y=[Re,Istar];

X1=c(:,1);
Y1=c(:,2);
X2=tri(:,1);
Y2=tri(:,2);
X3=s(:,1);
Y3=s(:,2);

X4=Y(behaviourAuto==1,1);
Y4=Y(behaviourAuto==1,2);
X5=Y(behaviourAuto==2,1);
Y5=Y(behaviourAuto==2,2);
X6=Y(behaviourAuto==3,1);
Y6=Y(behaviourAuto==3,2);

%Create figure
figure(1)
set(gcf, 'Position',  [100, 100, 650, 750])
axis square
set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','XScale','log','YScale','log','box','on');
hold on

% Scatter results
scatter(X1,Y1,Psize,'DisplayName','Ref 17','Marker',Ref1Marker,'MarkerFaceColor',Ref1Colour,'MarkerEdgeColor',Ref1ColourEdge);
scatter(X2,Y2,Psize,'DisplayName','Ref 21','Marker',Ref2Marker,'MarkerFaceColor',Ref2Colour,'MarkerEdgeColor',Ref1ColourEdge);
scatter(X3,Y3,Psize,'DisplayName','Ref 22','Marker',Ref3Marker,'MarkerFaceColor',Ref3Colour,'MarkerEdgeColor',Ref1ColourEdge);

scatter(X5,Y5,Psize,'DisplayName','This Work - Chaotic','Marker',ChaosMarker,'MarkerFaceColor',ChaosColour,'MarkerEdgeColor',ChaosColourEdge);
scatter(X4,Y4,Psize,'DisplayName','This Work - Tumbling','Marker',TumblingMarker,'MarkerFaceColor',TumblingColour,'MarkerEdgeColor',TumblingColourEdge);
scatter(X6,Y6,Psize,'DisplayName','This Work - Steady and Periodic','Marker',TumblingMarker,'MarkerFaceColor',SteadyColour,'MarkerEdgeColor',SteadyColourEdge);

h=plot(l1(:,1), l1(:,2), 'k');
h.HandleVisibility='off';
h=plot(l2(:,1), l2(:,2),  'k');
h.HandleVisibility='off';
h=plot(l3(:,1), l3(:,2), 'k');
h.HandleVisibility='off';

xlabel('Re')
ylabel('I^*')
xlim([16.5 40500]);
ylim([0.00017 0.2]);
title('Circle (+ Field et al (1997))')

%% Plot other shapes on RE-I* parameter space

figure(2)

load dataCircleClassified %Circle
gsm=70;
t=2.5/(36*1000);
rhof=1.2754 ;
rho= gsm/(1000*t);
visc=1.48*(10^(-5));

Istar=pi*rho*t./(64*rhof*2*radius);
Re=(dz.*radius./time)*2/visc;
Y=[Re,Istar];

X4=Y(behaviourAuto==1,1);
Y4=Y(behaviourAuto==1,2);
X5=Y(behaviourAuto==2,1);
Y5=Y(behaviourAuto==2,2);
X6=Y(behaviourAuto==3,1);
Y6=Y(behaviourAuto==3,2);

subplot(2,2,1);
hold on

scatter(X5,Y5,Psize,'DisplayName','Circle Chaotic','Marker',ChaosMarker,'MarkerFaceColor',ChaosColour,'MarkerEdgeColor',ChaosColourEdge);
scatter(X4,Y4,Psize,'DisplayName','Circle Tumbling','Marker',TumblingMarker,'MarkerFaceColor',TumblingColour,'MarkerEdgeColor',TumblingColourEdge);
scatter(X6,Y6,Psize,'DisplayName','Circle Steady and Periodic','Marker',SteadyMarker,'MarkerFaceColor',SteadyColour,'MarkerEdgeColor',SteadyColourEdge);

set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','box','on');
grid off
axis square
set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','XScale','log','YScale','log','box','on');
xlim([10^2 10^4])
ylim([10^-3 0.2])
xlabel('Re')
ylabel('I^*')
grid off
title('Circle')


load dataHexagonClassified %Hexagon
gsm=70;
t=2.5/(36*1000);
rhof=1.2754 ;
rho= gsm/(1000*t);
visc=1.48*(10^(-5));
Sl=2*radius/sqrt(3);
M=3*sqrt(3)*Sl.^2*gsm/2000;
I=((M.*radius.^2)/6)*(2+cos(2*pi/6));
Istar=I./(rhof.*(2*radius).^5);
Re=(dz.*radius./time)*2/visc;
Y=[Re,Istar];

X4=Y(behaviourAuto==1,1);
Y4=Y(behaviourAuto==1,2);
X5=Y(behaviourAuto==2,1);
Y5=Y(behaviourAuto==2,2);
X6=Y(behaviourAuto==3,1);
Y6=Y(behaviourAuto==3,2);

subplot(2,2,2); 
hold on

scatter(X5,Y5,Psize,'DisplayName','Hexagon Chaotic','Marker',ChaosMarker,'MarkerFaceColor',ChaosColour,'MarkerEdgeColor',ChaosColourEdge);
scatter(X4,Y4,Psize,'DisplayName','Hexagon Tumbling','Marker',TumblingMarker,'MarkerFaceColor',TumblingColour,'MarkerEdgeColor',TumblingColourEdge);
scatter(X6,Y6,Psize,'DisplayName','Hexagon Steady and Periodic','Marker',SteadyMarker,'MarkerFaceColor',SteadyColour,'MarkerEdgeColor',SteadyColourEdge);

set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','box','on');
grid off
axis square
set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','XScale','log','YScale','log','box','on');
xlim([10^2 10^4])
ylim([10^-3 0.2])
xlabel('Re')
ylabel('I^*')
grid off
title('Hexagon')

load dataSquareClassified %Square
gsm=70;
t=2.5/(36*1000);
rhof=1.2754 ;
rho= gsm/(1000*t);
visc=1.48*(10^(-5));

M=(2*radius).^2*(gsm/1000);
Ii= (1/12)*M.*((2*radius).^2);
Istar=Ii./(rhof.*(2*radius).^5);
Re=(dz.*radius./time)*2/visc;
Y=[Re,Istar];

X4=Y(behaviourAuto==1,1);
Y4=Y(behaviourAuto==1,2);
X5=Y(behaviourAuto==2,1);
Y5=Y(behaviourAuto==2,2);
X6=Y(behaviourAuto==3,1);
Y6=Y(behaviourAuto==3,2);

subplot(2,2,3);
hold on

scatter(X5,Y5,Psize,'DisplayName','Square Chaotic','Marker',ChaosMarker,'MarkerFaceColor',ChaosColour,'MarkerEdgeColor',ChaosColourEdge);
scatter(X4,Y4,Psize,'DisplayName','Square Tumbling','Marker',TumblingMarker,'MarkerFaceColor',TumblingColour,'MarkerEdgeColor',TumblingColourEdge);
scatter(X6,Y6,Psize,'DisplayName','Square Steady and Periodic','Marker',SteadyMarker,'MarkerFaceColor',SteadyColour,'MarkerEdgeColor',SteadyColourEdge);

set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','box','on');
grid off
axis square
set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','XScale','log','YScale','log','box','on');
xlim([10^2 10^4])
ylim([10^-3 0.2])
xlabel('Re')
ylabel('I^*')
grid off
title('Square')

load dataCrossClassified %Cross
gsm=70;
t=2.5/(36*1000);
rhof=1.2754 ;
rho= gsm/(1000*t);
visc=1.48*(10^(-5));

M=gsm*(2*radius).*width/1000; 
Ii= (1/12)*M.*((2*radius).^2 + width.^2);
Istar=Ii./(rhof.*(2*radius).^5);
Re=(dz.*radius./time)*2/visc;
Y=[Re,Istar];

X4=Y(behaviourAuto==1,1);
Y4=Y(behaviourAuto==1,2);
X5=Y(behaviourAuto==2,1);
Y5=Y(behaviourAuto==2,2);
X6=Y(behaviourAuto==3,1);
Y6=Y(behaviourAuto==3,2);

subplot(2,2,4);
hold on

scatter(X5,Y5,Psize,'DisplayName','Cross Chaotic','Marker',ChaosMarker,'MarkerFaceColor',ChaosColour,'MarkerEdgeColor',ChaosColourEdge);
scatter(X4,Y4,Psize,'DisplayName','Cross Tumbling','Marker',TumblingMarker,'MarkerFaceColor',TumblingColour,'MarkerEdgeColor',TumblingColourEdge);
scatter(X6,Y6,Psize,'DisplayName','Cross Steady and Periodic','Marker',SteadyMarker,'MarkerFaceColor',SteadyColour,'MarkerEdgeColor',SteadyColourEdge);

set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','box','on');
grid off
axis square
set(gca,'FontName',FontName,'FontSize',FontSize,'XMinorTick','on',...
    'YMinorTick','on','XScale','log','YScale','log','box','on');
xlim([10^2 10^4])
ylim([10^-3 0.2])
xlabel('Re')
ylabel('I^*')
grid off
title('Cross')



