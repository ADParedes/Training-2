% Shortcut summary goes here
display('clear all')
pause()
%         clear all
close all

    !hostname
    hostname                    =   char( getHostName( java.net.InetAddress.getLocalHost ) );
    ip                          =   char( getHostAddress( java.net.InetAddress.getLocalHost ) );
    user                        =   getenv('UserName');
    %Determining Foldernames Derived from Microsoft 'OneDrive' Cloud.  
       
        
    %% %%%%%%%%%%%%%%%% Designated Folder Names    
 
    if strcmp(hostname,'ADP-Chicago'); %this is the desktop
        str_Experiment_str      = 'C:\Users\AndreDaniel\SkyDrive\PHD\RawData'; %Experiment Folder- Starting Point to find Experiment to Analyze
        str_Functions_str       ='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'; %Functions Folder-Upload Functions Andre Created
        str_Plating_str         = 'C:\Users\AndreDaniel\Documents\SkyDrive\PHD\MAT Files\Plating'; %Save the plating
        str_PHD_str             ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD'; %Save the Tresors \\Core for saving
        str_RawData_str         ='C:\Users\AndreDaniel\SkyDrive\PHD\RawData';
        str_TemporaryData_str   ='C:\Users\AndreDaniel\SkyDrive\PHD\MAT Files\Temporary';%Save in case error or what to redo a postion
        str_SavingPartI_str     ='C:\Users\AndreDaniel\SkyDrive\PHD\MAT Files\PartI_Summary\VisualBasic';
        boo_desktop=1; %manual save logic of computer type
    elseif strcmp(hostname,'LLIULM') %this is the labtop
        str_Experiment_str      = 'C:\Users\AndreDaniel\Documents\SkyDrive\PHD\RawData'; %Experiment Folder- Starting Point to find Experiment to Analyze
        str_Functions_str       ='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'; %Functions Folder-Upload Functions Andre Created
        str_Plating_str         = 'C:\Users\AndreDaniel\Documents\SkyDrive\PHD\MAT Files\Plating'; %Save the plating
        str_PHD_str             ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD'; %Save the Tresors \\Core for saving
        str_RawData_str         ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\RawData';
        str_TemporaryData_str   ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\MAT Files\Temporary';%Save in case error or what to redo a postion
        str_SavingPartI_str     ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\MAT Files\PartI_Summary\VisualBasic';           
        str_Beautiful_str       ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Beautiful';%%%%%%%%%%%%%%%
        str_ExtendedFunctions_str   ='E:\Andre\Paredes_Phagosight\phagosight-master';
    end;


Temp_str                ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Temp';
 if exist('input_16bit')
 else
     input_16bit        ='C';
%     input_16bit         =input('y for 16bit else for not..is it for 16bit? E for external','s');
    if input_16bit      =='y'
        str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish -16bit';
    elseif input_16bit  =='n'
        str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish';
    elseif input_16bit  =='E'
       str_ProcessedData_str        ='E:\PhD Paredes Data\Dr. Cheng\Zebrafish\Processed Data';
       str_Presumptious             =str_ProcessedData_str;
    elseif input_16bit  =='C' 
        %Now interchangable (same for LLIULM & ADP-Chicago)
        str_ExtendedFunctions_str   =strcat('C:\Users\',user,'\OneDrive\m_Scripts\phagosight-master');  
        str_ProcessedData_str       =strcat('C:\Users\',user,'\OneDrive\MrBigTest\Confocal Data\Processed Data');
        if strcmp(hostname,'LLIULM'); %this is the desktop,'LLIULM'
            str_Functions_str           = strcat('C:\Users\',user,'\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'); %Functions Folder-Upload Functions Andre Created
        elseif strcmp(hostname,'ADP-Chicago'); %this is the desktop
            str_Functions_str='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun';
        end;   
        str_Presumptious             =str_ProcessedData_str;
                checkConfocal                = 1;
    else
        disp('Nothing was Selected...idiot')
    end;
 end;
        %%--------Find Folder
    MaxPixelIntensity = 2^16-1;
  %%FIND THE BASIC COMPONETS OF THE ZEBRAFISH - ti_d, plate, name  
    %Starting Point for Folder
    cd(str_Presumptious)
    if input_16bit  =='C' 
    else
        exp_folder = uigetdir('Pick the Zebrafish for basic time and names');
        cd(exp_folder)
    end;
   

    zfile=uigetfile('*.m*', 'Pick a MATLAB code file');
    load(zfile)
    display(zfile)
    
    temp_zfolder=zfile(1:5);
    zfolder=strcat(cd,'\',temp_zfolder);
 
%--------Find Any saved values of Positions you may want to reinvestigate.     
%    input_Process2=input('Do you want look at Saved Velocity values?','s')
%    if input_Process2=='y'
% 
%        cd(str_Prelim)
%         exp_folder = uigetdir('THis is to reinvestigate velocity and/or retention array values');
%         cd(exp_folder)
% 
%         zfile=uigetfile('*.m*', 'Pick a MATLAB code file');
%         load(zfile)
%    else
%    end;