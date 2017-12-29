%% Trouble shooting Directionality When Computing Metrics
%% Load PARAMETERS, POI, PhagoSight & ADP  Needed 
%Note: Phagosight DNE PhagoSight (two separate variables)
ParameterA              = PARAMETERS.ParameterA;   % Majority Track Percent
ParameterB              = PARAMETERS.ParameterB;   % Staticity Threshold
ParameterS              = PARAMETERS.ParameterS;   % Spatial Threshold - 150um is default

micronsPerPixel         = PARAMETERS.Parameter2;   % LateralPixelResolution  
micronsPerStack         = PARAMETERS.Parameter3;   % micronsPerStack   
SamplingFrequency       = PARAMETERS.Parameter4;   % Sampling Frequency
MPI_start               = PARAMETERS.Parameter5;   % Minutes post injury (Start of Imaging) ; old: t_plate
tplate                  = MPI_start;  %stored original t_plate as tplate incase I need to refer back to it

Parameter_gtA           = POI.Parameter_gtA;       % MTP for all each Temporal segment
dir_EOI                 = POI.Parameter10c;        % Experiment Directory (E.g. AB020 within Confocal)
str_FOI                 = POI.Parameter11c;        % ExperimentFish of Interest (E.g. P2 within AB020) 
valsPh2                 = POI.Parameter13;      

woundRegion             = PhagoSight.woundRegion;
wR1                     = PhagoSight.wR1;          % Wound Gap Epicenter
wR2                     = PhagoSight.wR2;          % Notochord Tip Epicenter
coe                     =(micronsPerPixel/SamplingFrequency); %microns per minute

disp('End: Paramters load')
%%
clear dd
dd                          =  regionprops(wR1); % This is the center of the wound gap
y_nodeW                     =  dd.Centroid(1); %note the swap of (1)=x
x_nodeW                     =  dd.Centroid(2); %note the swap of (2)=y
ee                          =  regionprops(wR2); %This is the Center of Notochord
y_nodeN                     =  ee.Centroid(1); %note the swap of (1)=x
x_nodeN                     =  ee.Centroid(2); %note the swap of (2)=y
counterTrack              =1
 %Distance in pixels between Wound Gap epicenter and Notochard marked manually
dist_notochord=(pdist([x_nodeW,y_nodeW; x_nodeN,y_nodeN],'Euclidean')*coe); 
figure(); 
imagesc(wR1);colormap(gray); hold on;
plot(dd.Centroid(1),dd.Centroid(2),'or',...
    'LineWidth',50);hold on; 
%-To get hPlotNet variable you need to run 'ZebrafishTracks_2D.m' first 
%-This plots the (1) track on the same plane as wR1
numTrack=5;
ZZ=ZZ*0+2; 
 hPlotNet.handlePlot(numTrack)=plot3(...
    YY,XX,ZZ,'LineStyle',':',... %Note the switch between YY and XX to plot on in same references, but is the same true for measuring????
    'color','y','markersize',...
    4,'linewidth',4); hold on;
txt1=strcat('\leftarrow ',num2str(numTrack));
text(YY(1),XX(1),txt1,'Color','cyan','FontSize',12)