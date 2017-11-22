%%%% TAKES PHAGOSIGHT TRACKS AND SURFS OVER ROS-detection
%DATE: 2017-03-09
%BY: ADPAREDES

mymap = [0 0 0
    1 0 0
    0 1 0
    0 0 1
    1 1 1];

 BF=dataR(:,:,handles.ChannelDistribution(3));
 TR=dataR(:,:,6);
if checkConfocal==1;
    ch_PH2=handles.ChannelDistribution(4);
    minValue=10000;
    maxValue=40000;
else
    ch_PH2=5;
    minValue=2500;
    maxValue=5000;
end;
ch_GFP=round(median(handles.ChannelDistribution(1):handles.ChannelDistribution(3)));



    clims=[minValue maxValue];
figure(10000);set(gcf,'Name','Over PH2');  
imagesc(dataR(:,:,ch_PH2),clims);axis off; hold on;
        colormap(mymap)
%         colormap(jet) %// example colormap with 4 colors.
        shading interp 
%         colormap(summer)
        cmap=colormap;
        hcb = colorbar('southoutside');
%          title('ROS Generation','FontSize',20);
%  hplotTracks       = plotTracks(handles,11);
[XX,YY]= meshgrid((1:handles.cols),(1:handles.rows));
ZZ = 1 * ones(handles.rows,handles.cols);
surf(XX,YY,ZZ,dataR(:,:,ch_PH2),'edgecolor','none')


axis([1 handles.cols 1 handles.rows 1 handles.numFrames])
% colormap(bone)
view(40,30)
%  colorbar('off')
selectNeutrophilsM(gcf,handles,woundRegion)
% colormap(gray.^(1/2))
% colormap(gray.^2)


%         text(100,300,'Toward ROS Signal','Color','white',...
%             'Font