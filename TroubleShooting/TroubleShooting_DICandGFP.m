%TroubleShoot_GrayLeveltoGreen
%%%%assuming handles in loaded
%%
if exist('handlesDir','var')
 [handlesDir] =  uigetdir('*.*',...
                             'Select the folder that contains the handles');
else
end;

dataDirRe = (strcat(handlesDir(1:end-2),'Re'));
dataDirLa = (strcat(handlesDir(1:end-2),'La'));
%%
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
end
%%    
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
            figure();
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
            set(hSurf,'FaceAlpha',0.8);
            [xs,ys,zs] = ndgrid( 1:25 , 1:50 , 1:4 ) ;
%%%%OKAY GOT A GFP CHANNEL NOW WHAT WILL YOU DO WITH IT!!!
%%ROI IT?
%%


pos_dir=cd;






