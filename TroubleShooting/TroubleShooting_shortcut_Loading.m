% Include External Modifications ofr saving.  

if exist('input_16bit')
else
    input_16bit='C' %automatically make Confocal- since I will be processing a grip.  2/10/2017
%     input_16bit=input('y for 16bit else for not..is it for 16bit? E for external or C for confocal','s');
    if input_16bit=='y'     %16 bit images for Matlab R2015a academic version
        str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish -16bit';
    elseif input_16bit=='n' %8-bit (reduced images from Matlab R2013b academic version)
        str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish';
    elseif input_16bit=='E'  %External Drive
       str_ProcessedData_str        ='E:\';
       str_Presumptious             =str_ProcessedData_str;
        str_Experiment_str          = 'E:\'; %Experiment Folder- Starting Point to find Experiment to Analyze
        str_Functions_str           ='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'; %Functions Folder-Upload Functions Andre Created
        str_RawData_str             ='E:\';
    elseif input_16bit=='C' 
        %Now interchangable (same for LLIULM & ADP-Chicago)
        str_ExtendedFunctions_str   =strcat('C:\Users\',user,'\OneDrive\m_Scripts\phagosight-master');  
        str_ProcessedData_str       =strcat('C:\Users\',user,'\OneDrive\MrBigTest\Confocal Data\Processed Data');
        if strcmp(hostname,'LLIULM'); %this is the desktop,'LLIULM'
            str_Functions_str           = strcat('C:\Users\',user,'\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'); %Functions Folder-Upload Functions Andre Created
        elseif strcmp(hostname,'ADP-Chicago'); %this is the desktop
            str_Functions_str='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun';
        end; 
        str_Presumptious             =str_ProcessedData_str;
        checkConfocal=1;
        disp(t_plate)
        disp('*************ADJUST t_plate**********************')
    end;

end;
cd(zfolder)


    SelectedFolder_str=uigetdir
[pa5, name5, ext5] = fileparts(SelectedFolder_str); %break up file name
% cd(name); %just added
% [pa5, name5, ext5] = fileparts(cd); %just added
cd(pa5)
cd(name5)
len_dir=length(dir);
len_dir=len_dir-2;
display('FInal position is below, please pick a value to look at')
display(len_dir)
input_v=2% input_v=input('What Frame?')
cd(pa5)
inputName=name5;
input_OorNoO='y'% input_OorNoO=input('Does it need an O or not  y/n','s');

    if input_OorNoO=='n'
        mat='_mat_';
        Or=strcat(inputName,mat,'Or/T00001.mat');%'r/T00001.mat');
        Re=strcat(inputName,mat,'Re/T00001.mat');
        La=strcat(inputName,mat,'La/T00001.mat');
        Ha=strcat(inputName,mat,'Ha/handles.mat');%'Ha/handles_ANDRE.mat'
        ha2=strcat(inputName,mat,'Ha');

    elseif input_OorNoO=='y'
        mat='_mat_O';
        if input_v>9
            Or=strcat(inputName,mat,'r/T000',num2str(input_v),'.mat');
            Re=strcat(inputName,mat,'Re/T000',num2str(input_v),'.mat');
            La=strcat(inputName,mat,'La/T000',num2str(input_v),'.mat');
        else
            Or=strcat(inputName,mat,'r/T0000',num2str(input_v),'.mat');
            Re=strcat(inputName,mat,'Re/T0000',num2str(input_v),'.mat');
            La=strcat(inputName,mat,'La/T0000',num2str(input_v),'.mat');            
        end;
        Ha=strcat(inputName,mat,'Ha/handles.mat');
        ha2=strcat(inputName,mat,'Ha');
    else
        display('neither? Fine then i say YES')
        input_OorNoO='y'
        return
    end;

load(Or)
load(Re)
load(La)

str_FolderNewHandles   =strcat(inputName,mat,'Ha-new');
Folder_newHandles      =exist(str_FolderNewHandles,'dir');

if Folder_newHandles ~= 0
    Ha_new=strcat(inputName,mat,'Ha-new/handles.mat')
    load(Ha_new)

else
    load(Ha)

end;

disp(name5)
disp(name)    
str_zpos=inputName(2:end);
if checkConfocal==1;
    num_zpos        =str2num(str_zpos);
    num_zpos        =num_zpos+1;
    micronsPerPixel =1.660; %microns per pixel (512x512) BUT image is in 256x256 so reduced by 2   3.102
    %---1. Determine number of Positions
    %---2. Determine length minimum to fix graph issues
    check                       =   0;
    posnum                      =   0;
    %--Positions-------------------------------------------------
    %Stores Position Numbers into variable
    %If variable Destination ev has values for Position # it increase
    %Once Position # is high enough it stops and knows Max Position Length
        while check == 0
                posnum      =    posnum+1;
                ev          =    strcat('P',num2str(posnum),'*'); %Problem: Preinjury and Parts have different Posnum
                f           =    dir(ev);
                check       =    isempty(f);
        end;
     %posnum   =  posnum-1;%-1; Don't minus 1 because p0 is a position. 
    if posnum==8
        ti_d        =65/60;
    elseif posnum==9
        ti_d        =74.3/60;
    elseif posnum==10
        ti_d        =85/60;
    else
        ti_d        =60/60;
    end
else
    num_zpos        =str2num(str_zpos);
    micronsPerPixel =1.550; %microns per pixel (512x512) BUT image is in 256x256 so reduced by 2   3.102 
end;

%--------------------------------------------------2016-01-29--------
% Shortcut summary goes here
s                   =get(0,'ScreenSize'); % s= [ 1 1 1920 1080]  --> Width-x-(1920) & Height-y-(1080)
%%%%%%%%%%%%%%%%
addpath             (str_Functions_str,str_ExtendedFunctions_str);%add path to *.mfile folder and *.tif foldersss
%S = LOAD(Total.mat);
ch_PH2              =handles.ChannelDistribution(4);
ch_GFP              =round(median(handles.ChannelDistribution(1):handles.ChannelDistribution(3)))
    figure(1);set(gcf,'Name','DataIn','Position',[s(3)/2 1 s(3)/2  (s(4))]); imagesc(dataIn(:,:,ch_GFP))
%     figure(2);set(gcf,'Name','DataR'); imagesc(dataR(:,:,ch_GFP))
%     figure(3);set(gcf,'Name','dataL'); imshow(dataL(:,:,ch_GFP))

if exist('ti_d','var')==1
    framesPerSec    =1/(ti_d*60);
else
    if exist('framesPerSec','var')==0
        input_time  =input('How many seconds per frame?  ')
        framesPerSec=1/input_time;
    else
    end;
end;
close all
%%Example for shifting figure into a specific location of the screen
% figure(103);set(gcf,'Name','10 = with labels (numbers) for the tracks','Position',[800 250 ((s(3)/2)+200) ((s(4)/2)+200)]);
%%End Example
 
