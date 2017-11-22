%Getting Publication Based Figures from Confocal MrBig Processed Data
%through Phagosight
%DATE: 2017-03-09
%BY: ADPAREDES
%PREREQUISITES: Load Handles with woundRegion 
%%%%Provides figures of the following sort
% 1. Green filter over macrophages over Reduced BF
% 2. BF in original resolution imadjusted
% 3. Wound Region
%% 1
 disp(name)
 disp(name5)
 OGname=name5;
if exist('expDir','var')
    
else
   
    disp('SELECT AB000 EXPERIMENT FOLDER NOT  HANDLE FOLDER')
    [expDir] =  uigetdir('*.*',...
                             'Select the folder that contains the handles');
end;
cd(expDir)

clear handlesDir
if exist('handlesDir','var')
 
else
    disp('Select the folder that contains the handles')
    [handlesDir] =  uigetdir('*.*',...
                             'Select the folder that contains the handles');
end;

dataDirRe = (strcat(handlesDir(1:end-2),'Re'));
dataDirLa = (strcat(handlesDir(1:end-2),'La'));

original_dataDirLa = dir (strcat(dataDirLa,'/*.mat'));
original_dataDirRe = dir (strcat(dataDirRe,'/*.mat'));

if handles.ChannelDistribution(1)~=0
    gFluorescentSlices = handles.ChannelDistribution(1):...
            handles.ChannelDistribution(2);
else
    gFluorescentSlices = 0;
end
if handles.ChannelDistribution(5)~=0
    rFluorescentSlices = handles.ChannelDistribution(5):...
            handles.ChannelDistribution(6);
else
    rFluorescentSlices = 0;  
end;
currentData = load(strcat(dataDirRe,'/',original_dataDirRe(1).name));
[rows,cols,levs] = size (currentData.dataR);
% This is to plot the   neutrophils LABELS only!
currentDataL = load(strcat(dataDirLa,'/',original_dataDirLa(1).name)); 

plotOption=2;

    if (handles.ChannelDistribution(3)==0)
	    switch plotOption
	        case 1
	            plotOption =1;
	        case 2
	            plotOption =1;
	        case 3
	            plotOption =3;
	        case 4
	            plotOption =3;
	        case 5
	            plotOption =5;
	        case 6
	            plotOption =5;
	        case 7
	            plotOption =7;
                
	    end
    end
    
levelP=150;
I=currentData.dataR(:,:,handles.ChannelDistribution(3));
J=imadjust(I); hJ=figure;  imagesc(J);colormap(gray)
topSlice = max(currentData.dataR(:,:,handles.ChannelDistribution(3)),[],3);%DIC or BF
	        currFish0 = repmat(255*topSlice/(max(topSlice(:))),[1 1 3]);

	        % To display them as an image, they are scaled 0-150
	        if (gFluorescentSlices(1)~=0)
	            currNeutrops = (max(currentData.dataR(:,:,gFluorescentSlices),[],3));
	            % To display them as an image, they are scaled 0-150
	            currNeutrops = (currNeutrops/max(currNeutrops(:)));
	            currFish0(:,:,2) = currFish0(:,:,2)+round(255*currNeutrops);
            end
	        
	        currFish = currFish0-min(currFish0(:));
	        currFish = round(255*currFish/max(currFish(:)));
            figure(1);
	        hSurf = imagesc(currFish/255);
                B = imresize(currFish/255,2);     
%                 hSurf= imagesc(B);
            currAxPos = get(gca,'position');
            if currAxPos(end) ==1
                set(gca,'position',[  0.1300    0.1100    0.7750    0.8150 ]);axis on
            else
                set(gca,'position',[0 0 1 1 ]);axis off
            end
            clear currAxPos
            shading interp
%             set(hSurf,'FaceAlpha',0.8);
%             [xs,ys,zs] = ndgrid( 1:25 , 1:50 , 1:4 ) ;
%%%%OKAY GOT A GFP CHANNEL NOW WHAT WILL YOU DO WITH IT!!!
%%ROI IT?
%%  Lets look at non reduced Image
[expDir, handlesFolder, ext] = fileparts(handlesDir); %break up file name
PosFolder=handlesFolder(1:2);
cd(expDir)
cd(PosFolder)
positionDir=cd;
FrameofInterest='T0001';
disp(FrameofInterest);
cd(FrameofInterest) % selectively chose frame 1
frameDir=cd;
tifdir=dir('*tif');
n=length(tifdir);
Arr_OG={0};
close all
for i=1:n
    Arr_OG{i}=imread(tifdir(i).name);
%     figure();imagesc(Arr_OG{i});
    
end;
dataOG=0;
dataOG=cat(3,Arr_OG{1},Arr_OG{2},Arr_OG{3},...
    Arr_OG{4},Arr_OG{5},Arr_OG{6},...
    Arr_OG{7},Arr_OG{8},Arr_OG{9});
% size(dataOG);
im1=dataOG(:,:,1);
im2=dataOG(:,:,2);
im3=dataOG(:,:,3);
im4=dataOG(:,:,4);%will go up to handles.ChannelDistribution(2) ~typically 7
ch_GFP=round(median(handles.ChannelDistribution(1):handles.ChannelDistribution(2)));
imGFP=dataOG(:,:,ch_GFP);
imBF=dataOG(:,:,handles.ChannelDistribution(3));
imTR=dataOG(:,:,handles.ChannelDistribution(4));
background = imopen(imBF,strel('disk',15));
I2=imBF-background;
I3=imadjust(I2);
n = 2;
Idouble = im2double(imBF);
avg = mean2(Idouble);
sigma = std2(Idouble);
I_BF = imadjust(imBF,[avg-n*sigma avg+n*sigma],[]);
J = histeq(imBF);
Iblur = imgaussfilt(I, 2);
% pause()
% close all
figure(1);imshow(imBF);shading interp;
figure(2);imagesc(I2);shading interp ;colormap(gray)
figure(3);imshow(I3); shading interp;
figure(4);imshow(J);
figure(8);imshow(I_BF);
figure(5);imagesc(imTR); colormap default; shading interp
figure(6);imagesc(Iblur); colormap(pink);shading interp
figure(7);imagesc(imGFP); colormap default;

disp(strcat('Just Finished_',name,':',handlesFolder))
disp(strcat('Original Handles Position_:_',name5))


%% wound Region
%  wR2  = roipoly(); % for tracing a boundry
wR3=woundRegion;
% woundRegion=wR1|wR2;
I_temp=bwperim(wR3);
% I_temp = im2bw(I_temp);
I_perim=bwmorph(I_temp,'thicken');
%%%%%%%%%%%%%%%%%%%%%%%%en%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end
close all
color_bw_wR=imoverlay(I_BF,I_perim,[1,1,0]);%currently Yellow % [1 0 0] red
figure(9);imshow(color_bw_wR); shading interp
color_TR_wR=imoverlay(imTR,I_perim,[1,1,0]);%currently Yellow % [1 0 0] red
figure(10);imshow(color_TR_wR); shading interp

%I2 = imcrop(I,[75 68 130 112]); %for cropping
close all
 figure();imshow(imTR);
 [I_TR,RECT]=imcrop();
%[I_TR]=imcrop(imTR,AndreRECT);
%%
I_blurTR=imguidedfilter(I_TR);
minValue=5000;
maxValue=20000;
mymap = [0 0 0
    1 0 0
    0 1 0
    0 0 1
    1 1 1];
clims=[minValue maxValue];
figure(10000);set(gcf,'Name','Over PH2');  
imagesc(I_blurTR,clims);axis off; hold on;
        colormap(jet)
%         colormap(jet) %// example colormap with 4 colors.
        shading interp
          shading interp
%         colormap(summer)
        cmap=colormap;
        hcb = colorbar('EastOutside');
