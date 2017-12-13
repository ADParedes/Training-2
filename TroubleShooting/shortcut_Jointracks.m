% Break apart Track
s               = POI.Parameter12; %s=get(0,'ScreenSize'); % s= [ 1 1 1920 1080]  --> Width-x-(1920) & Height-y-(1080)
micronsPerPixel = POI.Parameter2; %LateralPixelResolution %old % micronsPerPixel=1.550 %microns per pixel (512x512) BUT image is in 256x256 so reduced by 2   3.102 
framesPerSec    = POI.Parameter4; %ti_d SamplingFrequency
woundRegion     = PhagoSight.woundRegion;
close all
% Shortcut summary goes here
close all
s=get(0,'ScreenSize'); % s= [ 1 1 1920 1080]  --> Width-x-(1920) & Height-y-(1080)
% figure('Position',[950 250 ((s(3)/2)) ((s(4)/2)+200)]); %[ x y Width Height]
figure(103);set(gcf,'Name','10 = with labels (numbers) for the tracks','Position',[400 50 ((s(3)/2)+300) ((s(4)/2)+300)]);
plotTracks(handles,2); view(-10,25);
selectNeutrophilsM(gcf,handles,woundRegion)

trackA=input('FirstTrack? ');
trackB=input('SecondTrack? ');

handles = joinTwoTracks(handles,trackA,trackB);


close all

