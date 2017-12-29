%%
framesPerSec_OG=framesPerSec;
% clear framesPerSec;
framesPerSec=60*ti_d;
%------ no input data is received, error -------------------------
%------ at least 2 parameters are required
if nargin <1 ;
    help plotTrackStats;
    hPlotNet        = [];
    return;
else
    nodeNetwork     = handles.nodeNetwork(:,[1 2 5]);
    finalNetwork    = handles.finalNetwork;
end
numTracks           = size(finalNetwork,2);
%%
%------ arguments received revision   ----------------------------
if ~exist('typeOfPlot','var')
    typeOfPlot      =1;
end
if (typeOfPlot<-1)||(typeOfPlot>15)
    help plotTrackStats;
    hPlotNet        =[];
    return;
end

if ~exist('currentTrack','var')
    currentTrack=1;
end
if (exist('micronsPerPixel','var'))&(isempty(micronsPerPixel))
    clear micronsPerPixel;
end
if (exist('framesPerSec','var'))&(isempty(framesPerSec))
    clear framesPerSec;
end


%define all the labels according to the input arguments
if (~exist('micronsPerPixel','var'))||(~exist('framesPerSec','var'))
    lab_Velo_mm_s  = 'Velocity [pix/frame]';
else
    lab_Velo_mm_s  = 'Velocity [\mum /s]';
end

if ~exist('micronsPerPixel','var') ;
    micronsPerPixel = 1;
    lab_Cols_dist = 'Columns [pixels]';
    lab_Rows_dist = 'Rows [pixels]';
    yLabUnits =' [pixels]';
else
    lab_Rows_dist = 'Rows [ \mum ]';
    lab_Cols_dist = 'Columns [ \mum ]';
    yLabUnits = ' [\mu m]';
end

if ~exist('framesPerSec','var') ;
    framesPerSec = 1;
    lab_Time_fps = 'Time [frames]'  ;
else
    lab_Time_fps = 'Time [sec]';
end

%------ regular size check ---------------------------------------
[numNodes,numCols]          = size(handles.nodeNetwork);
[maxDepthTrack,numTracks]   = size(handles.finalNetwork);
%%
% Get axis ready
h0                          = gcf;
h1                          = gca;
hChild                      = allchild(h0);
hColP                       = findobj(hChild,'tag','colorBarPlot');
hColB                       = findobj(hChild,'tag','colorbarLabel');
set(hColP,'visible','off');
set(hColB,'visible','off');
hold on;
set(h1,'Color',[1 1 1]);


%------- colour codes for the plot
colorID2 = {'o', 'x', 's', '+', 'v',  '*', '^', '<', '>','h','p','o'};
colorID3=0.9*[ [0 0 1];[0 1 0];[1 0 0];...
    [0 0 0.75]; [0 0 0.25]; [0 0 0];...
    [0 1 0];    [0 0.75 0]; [0 0.5 0];...
    [1 0 0];    [0.75 0 0]; [0.35 0 0];...
    [0 1 1];    [1 0 1];    [1 1 0 ];...
    [0.5 0.5 0];[0.5 0 0.5];[0 0.5 0.5];...
    [0.25 0.25 0.25];[0.25 1 0];[0.25 0 0.25];[0 0.25 0.25]];

colorID6                            = interp1(jet,linspace(1,64,numTracks));

if ~isfield(handles,'meanderingRatio')
    handles=effectiveDistance(handles);
end
%-------- The structure of nodeNetwork will be [X Y z] each column
%-------- is separately transformed int
%-------- a matrix [depthB x numTracks] which will be used as X,Y,Z
%for the plot3 function
%-------- how to plot some nets that DO NOT have same number of nodes????
nodeNetworkX = (handles.nodeNetwork(:,2));
nodeNetworkY = (handles.nodeNetwork(:,1));
nodeNetworkZ = (handles.nodeNetwork(:,5));

%----- a neighbourhood for the group of tracks has been received
neighNetwork = handles.finalNetwork;
%----- finalNetwork will keep a vector with the lengths of the branches
hPlotNet.finalNetwork = sum(neighNetwork>0);
hPlotNet.numTracks = numTracks;
hPlotNet.relDistPrevHop = [];
hPlotNet.relAnglPrevHop = [];
 

%%  Plot 14 in plotTrackStats

    if numel(currentTrack) ~= numTracks
        selectSomeTracks = ones(numTracks,1);
    else
        selectSomeTracks = currentTrack;
    end
    
    for counterTrack=1:numTracks
        if selectSomeTracks(counterTrack)==1
            %---- determine WHICH nodes (points) correspond to the current Track
            plottingPoints = ...
                neighNetwork(1:hPlotNet.finalNetwork(counterTrack),...
                counterTrack);
            XX = nodeNetworkX(plottingPoints);
            YY = nodeNetworkY(plottingPoints);
            ZZ = nodeNetworkZ(plottingPoints);
            diffBetPoints = diff([XX YY]);
            diffBetStart = [XX(1)-XX(2:end) YY(1)-YY(2:end)];
            distPerHop = sqrt((sum(diffBetPoints.^2,2)));
            %distPerHop_smooth  = conv(distPerHop,gaussF(9,1,1),'same');
            anglPerHop = acos(diffBetPoints(:,1)./(distPerHop+1e-30));
            distFromStart = sqrt(sum(diffBetStart.^2,2));
            
            hPlotNet.anglFromStart(counterTrack) = ...
                atan2( (YY(end)-YY(1)) , ( (XX(end)-XX(1))+1e-30));
            hPlotNet.avDistPerTrack(counterTrack) = mean(distPerHop);
            hPlotNet.totDistPerTrack(counterTrack) = sum(distPerHop);
            hPlotNet.maxDistPerTrack(counterTrack) = max(distPerHop);
            hPlotNet.startFrame(counterTrack) = ZZ(1);
            hPlotNet.stopFrame(counterTrack) = ZZ(end);
            hPlotNet.avX(counterTrack) = mean(XX);
            hPlotNet.avY(counterTrack) = mean(YY);
            hPlotNet.anglPerHop(counterTrack) = mean(anglPerHop);
            distV=distPerHop;
            anglV=anglPerHop;
            relDistP=distV(2:end)./(distV(1:end-1)+1e-30);
            relAnglP=anglV(2:end)-anglV(1:end-1);
            relAnglP(relDistP>1000)=[];
            relDistP(relDistP>1000)=[];
            hPlotNet.relDistPrevHop = [hPlotNet.relDistPrevHop;relDistP];
            hPlotNet.relAnglPrevHop = [hPlotNet.relAnglPrevHop;relAnglP];
            
            hPlotNet.tempVelocity(counterTrack,round([framesPerSec*...
                hPlotNet.startFrame(end):framesPerSec*...
                hPlotNet.stopFrame(end)]))=...
                framesPerSec*hPlotNet.avDistPerTrack(end);
            line([hPlotNet.startFrame(end) hPlotNet.stopFrame(end)],...
                framesPerSec*hPlotNet.avDistPerTrack(end)*[1 1],...
                'marker','s','linewidth',1);
        end
    end
    
    tempAxis = [framesPerSec*min(hPlotNet.startFrame):...
        framesPerSec*max(hPlotNet.stopFrame)];
    hPlotNet.tempVelocity(isnan(hPlotNet.tempVelocity))=0;
    tempVelocityPerFrame = sum(hPlotNet.tempVelocity);
    tempEventPerFrame = sum(hPlotNet.tempVelocity>0);
    tempEventPerFrame(tempEventPerFrame==0) =   inf;
    numEventsNoZero = sum(tempEventPerFrame==inf)+1;
    temporalVelocity =  tempVelocityPerFrame./tempEventPerFrame;
    q1=cumsum(temporalVelocity);
    breakPoints=find(tempEventPerFrame==inf);
    if numel(breakPoints)>0
        temporalVelocity2=temporalVelocity;
        temporalVelocity2(breakPoints)=...
            -[q1(breakPoints(1)) diff(q1(breakPoints))];
        q3=cumsum(temporalVelocity2);
        breakPoints2=[breakPoints-1 size(q3,2)];
        breakPoints3=[breakPoints2(1) -1+diff(breakPoints2)];
        
        hPlotNet.avVelPerEvent=q3(breakPoints2)./(breakPoints3+1e-100);
        timeSlots=[1 breakPoints+1;breakPoints2];
        
        timeSlots(:,(hPlotNet.avVelPerEvent==0)|...
            (hPlotNet.avVelPerEvent>1e87)|...
            (hPlotNet.avVelPerEvent<-1e87))=[];
        
        hPlotNet.avVelPerEvent(hPlotNet.avVelPerEvent==0)=[];
        hPlotNet.avVelPerEvent((hPlotNet.avVelPerEvent>1e87))=[];
        hPlotNet.avVelPerEvent((hPlotNet.avVelPerEvent<-1e87))=[];
        
        plot(timeSlots/framesPerSec,(hPlotNet.avVelPerEvent'*[1 1])',...
            'linewidth',2,'color','m','marker','.')
        if exist('micronsPerPixel','var')
            plot(tempAxis(tempEventPerFrame~=inf)/framesPerSec,...
                temporalVelocity(tempEventPerFrame~=inf),'r-','linewidth',2);
            %,tempAxis(tempEventPerFrame==inf)/framesPerSec,...
            % temporalVelocity(tempEventPerFrame==inf),'bx')
            if size(hPlotNet.avVelPerEvent,2)>1
                if size(hPlotNet.avVelPerEvent,2)<6
                    title(...
                        strcat('[t_{i}, t_{f}, v] = [',...
                        (num2str([timeSlots'/framesPerSec ...
                        round(hPlotNet.avVelPerEvent')],5)),']'));
                else
                    title(...
                        strcat('[t_{i}, t_{f}, v] = [',...
                        (num2str([timeSlots(:,1:5)'/framesPerSec ...
                        round(hPlotNet.avVelPerEvent(1:5)')],5)),']'));
                end
            end
        else
            plot(tempAxis(tempEventPerFrame~=inf),...
                temporalVelocity(tempEventPerFrame~=inf),'r-o')
            title(strcat('v = [',num2str(hPlotNet.avVelPerEvent',5),']'));
        end
        
        xlabel(lab_Time_fps,'fontsize',18);
        ylabel(lab_Velo_mm_s,'fontsize',18)
    else
        plot(tempAxis(tempEventPerFrame~=inf)/framesPerSec,...
            temporalVelocity(tempEventPerFrame~=inf),'r-', ...
            'linewidth',2);
        %,tempAxis(tempEventPerFrame==inf)/framesPerSec,...
        % temporalVelocity(tempEventPerFrame==inf),'bx')
        xlabel(lab_Time_fps,'fontsize',18);
        ylabel(lab_Velo_mm_s,'fontsize',18);
        hPlotNet.avVelPerEvent=[];
    end
    axis([[0.8*min(hPlotNet.startFrame) 1.05*max(hPlotNet.stopFrame)] ...
        framesPerSec*[0.8*min(hPlotNet.avDistPerTrack) ...
        1.05*max(hPlotNet.avDistPerTrack)]]);%axis tight;
    grid on;
    
    %% 
    
    framesPerSec=framesPerSec_OG;
    