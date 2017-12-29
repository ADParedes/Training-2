% http://www.phagosight.org/NF/trackingManual4.php
ch_PH2=handles.ChannelDistribution(4);
ch_GFP=round(median(handles.ChannelDistribution(1):handles.ChannelDistribution(3)));
handles.distMaps=0;
pause(2)
if exist('valsPh2')
    OriginalImg = valsPh2{1}{2};
    checkConfocal=1;
    valsPH2=valsPh2;
else
    OriginalImg = valsPH2{num_zpos}{2};
    checkConfocal=0;
end;
%ch_PH2=4;
I=imadjust(OriginalImg);
PH2_8bit = im2uint8(I);
PH2_re = imresize(PH2_8bit, [256 256]); 
close all
figure(1)
if handles.rows>300
%  imagesc(dataR(:,:,ch_GFP))
    imagesc(dataR(:,:,ch_PH2))
    I=OriginalImg;
else
    imshow(PH2_re)
    I=PH2_re;
end;

% woundRegion  = roipoly();
%%%%%%%%%%%%%update 2016/09/27

wR1  = roipoly();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
OriginalImg2 = valsPH2{num_zpos}{(handles.numFrames-2)};
ch_PH2=4;
I2=imadjust(OriginalImg2);
PH2_8bit = im2uint8(I2);
PH2_re = imresize(PH2_8bit, [256 256]); 
close all
figure(2)
if handles.rows>300
%  imagesc(dataR(:,:,ch_GFP))
%     imagesc(dataR(:,:,ch_PH2))
    I2=OriginalImg2;
    disp('here')
else
%     imshow(PH2_re)
    I2=PH2_re;
    disp('there')
end;
imagesc(I2);

wR2  = roipoly();

woundRegion=wR1|wR2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end
pause();
close all
color_bw_wR=imoverlay(I2,bwperim(woundRegion),[ 1 0 0]);
figure(3);imagesc(color_bw_wR);
%% Once this wound region has been selected it is passed as a variable
%% to the following functions
figure(4);
handles       = effectiveDistance(handles,woundRegion);
% % % % % % % % % % % % % % % % % % % % % % % disp (handles)

%% To calculate the maps
handles      = effectiveTracks(handles,woundRegion);
% % % % % % % % % % % % % % % % % % % % % % % disp (handles)
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % disp (handles.distMaps)

%% Viualised with the command "mesh"
 mesh(handles.distMaps.oriDistMap)

% displayActivationPoint(handles,dataR(:,:,2),woundRegion);
%  displayActivationPoint(handles,PH2_re,woundRegion);
% 
% displayActivationPoint(handles,wounRegion);
displayActivationPoint(handles,dataR(:,:,ch_PH2));

dataR_WR = dataR(:,:,ch_GFP).*(1-imdilate(zerocross(woundRegion),ones(3)));
figure(5);
% imagesc(dataR_WR) 
imshow(I2)

 
