%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update 2017-11-15 - ADP
%Computer hostname changed - previously LLIULM --> ADPAREDES 
%Computer hostname reflects labtop in which CODE was created

%% Close all/Clear Variables
clear all
clc
close all
clear boo_desktop
%% Computer System Identification
!hostname
hostname                    =   char( getHostName( java.net.InetAddress.getLocalHost ) );
ip                          =   char( getHostAddress( java.net.InetAddress.getLocalHost ) );
user                        =   getenv('UserName');    
if strcmp(hostname,'ADP-Chicago'); %this is the desktop
    disp('Did NOT select Labtop Directory')
    boo_desktop             =   1; %manual save logic of computer type | "1" is Yes for this is desktop
elseif strcmp(hostname,'ADPAREDES') %this is the labtop
    disp('Selected Labtop Directory')
    boo_desktop             =   0;
else
    boo_destop              =   2;
end;
disp('END: Computer Identified')
%% Directory Identifications          

if exist('input_16bit')
else
        input_16bit        ='C';
%     input_16bit         =input('C for 16bit else 'n' for not? E for external','s');
        if input_16bit=='n' %8-bit (reduced images from Matlab R2013b academic version)
            disp('Directory Supplementary 1: MatlabR2013b based codes for where you keep data')
            str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish';
        elseif input_16bit=='E'  %External Drive
            disp('Directory Supplementary 2: External Drive E:\ for where you keep data')
            str_ProcessedData_str        ='E:\';
            str_Presumptious             =str_ProcessedData_str;
            str_Experiment_str          = 'E:\'; %Experiment Folder- Starting Point to find Experiment to Analyze
            str_Functions_str           ='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'; %Functions Folder-Upload Functions Andre Created
            str_RawData_str             ='E:\';
        elseif input_16bit  =='C' 
            disp('Selected Directory 1: Main Files for where you keep data')
            str_Functions_str           =strcat('C:\Users\',user,'\OneDrive\m_Scripts\phagosight-master'); 
            str_Functions_str           = strcat('C:\Users\',user,'\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun');
            str_ExtendedFunctions_str   = strcat('C:\Users\',user,'\OneDrive\m_Scripts\phagosight-master');  
            str_ProcessedData_str       = strcat('C:\Users\',user,'\OneDrive\MrBigTest\Confocal Data\Processed Data');
            %--This is Obsolete, but may be useful for 
%                 if strcmp(hostname,'ADPAREDES'); %this is the labtop, Formally known as 'LLIULM'
%                         str_Functions_str           = strcat('C:\Users\',user,'\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'); %Functions Folder-Upload Functions Andre Created
%                 elseif strcmp(hostname,'ADP-Chicago'); %this is the desktop
%                         str_Functions_str           = strcat('C:\Users\',user,'\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun');
%                 end;   
            str_Presumptuous            = str_ProcessedData_str;
            checkConfocal               = 1;
        else
            disp('Nothing was Selected...genius')
        end;
end;
%% Find Folder with Registered input Parameters
cd(str_Presumptuous)
if input_16bit  =='C' 
else
    exp_folder      = uigetdir('*.mat*', 'Pick a MATLAB code file');
    cd(exp_folder)
end;
startingFolder  =  str_Presumptuous;
defaultFileName =  fullfile(startingFolder,'*.*');
% [baseFileName,folder] =uiputfile(defaultFileName,'Just try to specify in a different folder - I dare you') %This is to Overwrite save on a file of choosing.
% if baseFileName == 0
%     % User Clicked the cancel button.
%     return;
% end;
zfile           =  uigetfile('*.mat*', 'Pick unique Experiment ID MATLAB file with Registration Parameters');
load(zfile);
temp_zfolder    = zfile(1:5);
zfolder=strcat(cd,'\',temp_zfolder);
%-Determined ti_d risky way
posnum =length(PositionName);
% if posnum==8
%     ti_d        = 65/60;
% elseif posnum==9
%     ti_d        = 74.3/60;
% elseif posnum==10
%     ti_d        = 85/60;
% elseif posnum>10
%     ti_d        =(15*(posnum-10)+60)/60;
%     display('Positions exceed 10...sooooo I guessed frames per minute') 
% else
%     ti_d        = 60/60;
% end;
disp ('Position#/Sampling Frequency Reference Sheet: 7/1; 8/1.08; 9;1.2; 10/1.4'); %ADP specific - not necessarily compatible for other users.
display('END: Experimental Registration Parameters')
%% Parameters of Interest
POI.Parameter1              = 2^16-1;   %MaxPixelIntensity - BPP - dependent on Bits 
POI.Parameter2              = 1.64;     %Lateralpixelresolution  - micronsperpixel micronsPerPixel =1.660; %microns per pixel (512x512) BUT image is in 256x256 so reduced by 2   3.102
POI.Parameter3              = 10;       %ZstepMicrons
POI.Parameter4              = ti_d;     %SamplingFrequency
POI.Parameter5              = t_plate;  %Minutes Post Injury of Image Start (MPI)
POI.ParameterA              = 0.70;     %Trackability i.e Minum Cell Track length Thresholdper SM a.k.a MajorityTracksPercent=.70; %<--HIGH% selection - ADP
POI.Parameter_gtA           = 0.9;      %Trackability per GT
POI.ParameterB              = 1;        %StaticLimit (1 provides best result)  i.e. 0.8519um. 
POI.ParameterC              = 65;       %Distance from Wound Margin for Standardizatin of Wound Region 
POI.ParameterS              = 150;      %Leukocyte Spatial Interval (150um)
POI.ParameterZ              = znum;     %Number of Z Positions
%- ADP Specific 
ADP.adp1            = hostname;
ADP.adp2            = user; 
ADP.date            = date;
ADP.boo1            = input_16bit;         % 'C' lets me know this is main confocal directory
ADP.boo2            = boo_desktop;         % labtop or not labtop 
ADP.boo3            = NaN;                 % checkconfocal not done until S1
%-Other Parameters
POI.Parameter10a            = name;                 % str of unique Experiment name (batch imaging-set)
POI.Parameter10b            = zfile;                % metadata file by Experiment (batch imaging-set)
POI.Parameter10c            = zfolder;              % dir of Unique Experiment Processed data
POI.Parameter11a            = length(PositionName); % val number of positions of this experiment group
POI.Parameter11b            = PositionName;         % str of Position  numbers being analyzed
POI.Parameter11c            = NaN;                  % str of Position  numbers being analyzed done S1
POI.Parameter12             = get(0,'ScreenSize');  % s= [ 1 1 1920 1080]  --> Width-x-(1920) & Height-y-(1080)
POI.Parameter13             = valsPh2;              % This is complex array with all the BF images so I can easy access BF images
%% -GUI for Metadata Inputs. (Diaglog Box)
prompt                  = {'Enter Parameter1: MaxPixelIntensity:'...
                            ,'Enter Parameter2: LateralPixelResolution:'...
                            ,'Enter Parameter3: Z Pixel Resolution (um):'...
                            ,'Enter Parameter4: SamplingFrequency(min):'...
                            ,'Enter Parameter5: MPI - Image Start - Minutes post injury'...
                            ,'Enter ParameterA: Trackability Threshold(%)'...
                            ,'Enter ParameterB: StaticLimit (Pixel)'...
                            ,'Enter ParameterS: Leukocyte S# from Following Distance Interval From wound(um):'...
                            ,'Enter ParameterZ: # Z stacks:'};
dlg_title               = 'Input Parameters';
num_lines               = 1;
defaultans              = {num2str(POI.Parameter1),num2str(POI.Parameter2),num2str(POI.Parameter3),num2str(POI.Parameter4),num2str(POI.Parameter5)...
                            ,num2str(POI.ParameterA),num2str(POI.ParameterB),num2str(POI.ParameterS),num2str(POI.ParameterZ)};
answer                  = inputdlg(prompt,dlg_title,num_lines,defaultans);
PARAMETERS.Parameter1              = str2num(answer{1}); % Bits per pixel (BPP)
PARAMETERS.Parameter2              = str2num(answer{2}); % LateralPixelResolution
PARAMETERS.Parameter3              = str2num(answer{3}); % Z pixel resolution
PARAMETERS.Parameter4              = str2num(answer{4}); % Sampling Frequency
PARAMETERS.Parameter5              = str2num(answer{5}); % MPI
PARAMETERS.ParameterA              = str2num(answer{6}); % Trackability
PARAMETERS.ParameterB              = str2num(answer{7}); % Static Ratio
PARAMETERS.ParameterS              = str2num(answer{8}); % Spatial Intervals from wound
PARAMETERS.ParameterZ              = str2num(answer{9}); % # Z stacks
disp(strcat('Registered Bits per Pixel (BPP):',num2str(PARAMETERS.Parameter1)))
disp(strcat('Registered LateralPixelResolution(um/pixel):',num2str(PARAMETERS.Parameter2)))
disp(strcat('Registered ZstepMicrons(um):',num2str(PARAMETERS.Parameter3)))
disp(strcat('Registered Sampling Frequency:',num2str(PARAMETERS.Parameter4)))
disp(strcat('Registered MPI (minutes) ):',num2str(PARAMETERS.Parameter5)))
disp(strcat('Registered Trackability:',num2str(PARAMETERS.ParameterA)))
disp(strcat('Registered StaticLimit:',num2str(PARAMETERS.ParameterB)))
disp(strcat('Registered Spatial Intervals:',num2str(PARAMETERS.ParameterS)))
disp(strcat('Registered Z stacks:',num2str(PARAMETERS.ParameterZ)))
disp('Saving...')
%% append save pameters to current registered metadata
save(zfile,'PARAMETERS','POI','-append')
fullFilename    =   fullfile(str_Presumptuous,zfile);
message         =   sprintf('Your Registration Parameters have been loaded from:\n%s',fullFilename);
msgbox(message);

clearvars -except POI PARAMETERS ADP
display('FINISHED: S0_RegisteredMetadata.m ')