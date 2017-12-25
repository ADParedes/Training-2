%% Plot Track by Metric Figure 3,4,5 Manuscript 2
% Metrics include Velocity, Static Meander, Tortusoity, F:B ratio, & WD
% Performing this For Cumulativie T3 temporal domain tracks.  
close all
% clear all
clc

%%
micronsPerPixel             = PARAMETERS.Parameter2;   % LateralPixelResolution 
SamplingFrequency           = PARAMETERS.Parameter4;   % Sampling Frequency
user                        = getenv('UserName');  
hostname                    = char( getHostName( java.net.InetAddress.getLocalHost ) );
ti_d                        = PARAMETERS.Parameter4;   % Sampling Frequency
ch_PH2                      = PhagoSight.ch_Ph2;
ch_GFP                      = PhagoSight.ch_GFP;    
coe                         =(micronsPerPixel/SamplingFrequency); %microns per minute
I                           = dataR(:,:,ch_PH2);
str_MasterFunctions_str     = strcat('C:\Users\',user,'\OneDrive - University of Illinois at Chicago\',...
                                'PhD Work\PhD matlab\m_Scripts\CarlosPhagosight\phagosight-master');
switch hostname
    case{'ADP-Chicago'}
        disp('Desktop')
        str_Functions_str           = strcat('C:\Users\',user,'\Dropbox\LLIULM\MATLAB\Image Processing\Fun'); 
    case{'ADPAREDES'}
        disp('Labtop')
        str_Functions_str           = 'C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun';
end;
s                           = get(0,'ScreenSize'); % s= [ 1 1 1920 1080]  --> Width-x-(1920) & Height-y-(1080)
%% Add Function Directories
addpath(str_MasterFunctions_str,str_Functions_str);
%% Distance
figure();set(gcf,'Name','Distance Traveled')%'Position',[1 1 s(3)/3 (s(4)/3)]);
hplotTracks       = plotTracks(handles,2); 
%  plotTracks(handles,1,handles.distanceNetwork.numHops>20);
%  plotTracks(handles,2,:,micronsPerPixel,framesPerSec);

[XX,YY]= meshgrid((1:handles.cols),(1:handles.rows));
ZZ = 1 * ones(handles.rows,handles.cols);
surf(XX,YY,ZZ,dataR(:,:,ch_PH2),'edgecolor','none')
axis([1 handles.cols 1 handles.rows 1 handles.numFrames])
view(2)
% view(40,30)55
colormap(gray.^1) 
%--Remove shit
currAxPos = get(gca,'position');
if currAxPos(end) ==1
    set(gca,'position',[  0.1300    0.1100    0.7750    0.8150 ]);axis on
else
    set(gca,'position',[0 0 1 1 ]);axis off
end
clear currAxPos

%% Variable Metric

figure();set(gcf,'Name','Variable Metric')%'Position',[s(3)/2 s(4)/2 s(3)/4 s(4)/4]);
hplotTracks       = plotTracks_Andre(handles,3,handles.distanceNetwork.numHops>40); %open this and change metric number to change what you want to do
% plotTracks(handles,2,Worthy.ID.cum); 
[XX,YY]= meshgrid((1:handles.cols),(1:handles.rows));
ZZ = 1 * ones(handles.rows,handles.cols);
surf(XX,YY,ZZ,I,'edgecolor','none')
axis([1 handles.cols 1 handles.rows 1 handles.numFrames])
view(2)
 colormap(gray.^1)  
% view(40,30)
    
currAxPos = get(gca,'position');
if currAxPos(end) ==1
    set(gca,'position',[  0.1300    0.1100    0.7750    0.8150 ]);axis on
else
    set(gca,'position',[0 0 1 1 ]);axis off
end
clear currAxPos      
% %% Slow Velocity - use for static ratio
% figure();set(gcf,'Name','Static Ratio')%'Position',[s(3)/2 s(4)/2 s(3)/4 s(4)/4]);
% hplotTracks       = plotTracks(handles,5); 
% %  plotTracks(handles,2,:,micronsPerPixel,framesPerSec);
% [XX,YY]= meshgrid((1:handles.cols),(1:handles.rows));
% ZZ = 1 * ones(handles.rows,handles.cols);
% surf(XX,YY,ZZ,dataR(:,:,ch_PH2),'edgecolor','none')
% axis([1 handles.cols 1 handles.rows 1 handles.numFrames])
% view(2)
% % view(40,30)
%  colormap(gray.^1)      
% currAxPos = get(gca,'position');
% if currAxPos(end) ==1
%     set(gca,'position',[  0.1300    0.1100    0.7750    0.8150 ]);axis on
% else
%     set(gca,'position',[0 0 1 1 ]);axis off
% end
% clear currAxPos      
% %% Meandering Ratio
% figure();set(gcf,'Name','Meandering Index')%'Position',[s(3)/2 s(4)/2 s(3)/4 s(4)/4]);
% hplotTracks       = plotTracks_Andre(handles,2);
%  %  plotTracks(handles,2,:,micronsPerPixel,framesPerSec);
% [XX,YY]= meshgrid((1:handles.cols),(1:handles.rows));
% ZZ = 1 * ones(handles.rows,handles.cols);
% surf(XX,YY,ZZ,dataR(:,:,ch_PH2),'edgecolor','none')
% axis([1 handles.cols 1 handles.rows 1 handles.numFrames])
% view(2)
% % view(40,30)
%  colormap(gray.^1)      
% currAxPos = get(gca,'position');
% if currAxPos(end) ==1
%     set(gca,'position',[  0.1300    0.1100    0.7750    0.8150 ]);axis on
% else
%     set(gca,'position',[0 0 1 1 ]);axis off
% end
% clear currAxPos      
        


 %%
% figure(5);set(gcf,'Name','2  = highlights faster branches','Position',[s(3)/2 1 s(3)/2  (s(4)-100)]);
%         plotTracks_byMetric(handles,2);   
%%

% [-14:-1]    Will be the same options as the positive ones but with X,Y,Z
% [1:14]      Will plot the tracks with the following options for X,Y,T
%       1  = highlights longer (in distance) branches
%       2  = highlights faster branches
%       3  = highlights longer (in number of frames) branches
%       4  = highlights shorter branches
%       5  = highlights slower branches
%       6  = highlights smaller branches
%       7  = discard branches with small total distance, i.e. 30% of upper half average distance
%       8  = discard branches with less than 3 nodes
%       9  = plot ONLY those branches crossing the present Frame
%       10 = with labels (numbers) for the tracks
%       11 = all tracks in green
%       12 = all tracks in red
%       13 = top in red, bottom in green
%       14 = top in green, bottom in red
%       15 = plot [x,volume,time] as type 1
%       16 = plot [y,volume,time] as type 1
%       17 = Merge into plot [x,volume,time] one colour per handle
%       18 = Merge into plot [y,volume,time] one colour per handle
%       19 = Merge several separate handles, p