%% Andre Daniel Paredes
%ZEBRAFISH_MacrophageRecruitment 
%  The purpose of this script is to image process the caudal fin of the zebrafish
% at the location of injury between 30-130 minute period after induced wound
% This function will to perform edge detection of macrophages/neutrophils traveling
% to injury site.  Once Isolated we will calculate he amount of macrophages at the wound site
% and peripheral regions. at specific times after injur.  
%too large to proce
%%%ASSUMPTIONS ---ZEBRAFISH DOES NOT MOVE!!  Will affect the MP COUNT in
%%%wound region
input_clearall=input('Should I clear all?  y/n || need "y" if first go ','s');

%% DETERMINE CONFOCAL OR EPIFLUORESCENT MICRSCOPE TIFF INPUT FORMAT
if input_clearall=='y'
    %% 1 Designated Folder Names
    clc
    close all
    clear all
     !hostname
    hostname                    =   char( getHostName( java.net.InetAddress.getLocalHost ) );
    ip                          =   char( getHostAddress( java.net.InetAddress.getLocalHost ) );
    user                        =   getenv('UserName');
    disp('END1: Identified Hostname,ip,user')        
    %% 2 Designated Folder Names    
    if strcmp(hostname,'ADP-Chicago'); %this is the desktop
        str_Experiment_str      = 'C:\Users\AndreDaniel\SkyDrive\PHD\RawData'; %Experiment Folder- Starting Point to find Experiment to Analyze
        str_Functions_str       ='C:\Users\AndreDaniel\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'; %Functions Folder-Upload Functions Andre Created
        str_Plating_str         = 'C:\Users\AndreDaniel\Documents\SkyDrive\PHD\MAT Files\Plating'; %Save the plating
        str_PHD_str             ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD'; %Save the Tresors \\Core for saving
        str_RawData_str         ='C:\Users\AndreDaniel\SkyDrive\PHD\RawData';
        str_TemporaryData_str   ='C:\Users\AndreDaniel\SkyDrive\PHD\MAT Files\Temporary';%Save in case error or what to redo a postion
        str_SavingPartI_str     ='C:\Users\AndreDaniel\SkyDrive\PHD\MAT Files\PartI_Summary\VisualBasic';
        boo_desktop=1; %manual save logic of computer type
        str_MrBig               ='C:\Users\AndreDaniel\OneDrive\CZI DATA - ZEN';
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
        str_MrBig              =strcat('C:\Users\',user,'\OneDrive\MrBigTest\Confocal Data\Processed Data');
    end;

    Temp_str                ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Temp';
    if exist('input_16bit')
    else
    %      input_16bit        ='C';
         input_16bit        ='E';
         disp(strcat('input_16bit =',input_16bit))
    %     input_16bit         =input('y for 16bit else for not..is it for 16bit? E for external','s');
        if input_16bit      =='y'
            str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish -16bit';
        elseif input_16bit  =='n'
            str_Presumptious            ='C:\Users\AndreDaniel\Documents\SkyDrive\PHD\Prelim\VisualBasic\Z-Stack\Zebrafish';
        elseif input_16bit  =='E'
    %        str_ProcessedData_str        ='E:\PhD Paredes Data\Dr. Cheng\Zebrafish\Processed Data';
           str_ProcessedData_str        ='E:\AndreDParedes\Mr-Big\RAW CZI DATA'; %Black WD:MyPassport Backup (Dr.B)
           str_Presumptious             =str_ProcessedData_str;
           str_MrBig                    ='E:';
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
    disp('END2: Determining Foldernames Derived from Microsoft OneDrive Cloud')
 %% 3 FIND THE BASIC COMPONETS OF THE ZEBRAFISH - ti_d, plate, name  
    %Starting Point for Folder
    cd(str_Presumptious)
    if input_16bit  =='C' || 'E'    
        cd(str_MrBig)
        exp_folder=uigetdir;
        addpath                         (exp_folder,str_Functions_str,str_ExtendedFunctions_str);%add path to *.mfile folder and *.tif foldersss
        %S = LOAD(Total.mat);
        [pa, name, ext]             =   fileparts(exp_folder); %break up file name
        figurename                  =   name;
        cd                              (exp_folder);%change the current folder
        disp('End: Found Experiment Folder')
       %% BF Folder
        cd                              (exp_folder);%change the current folder
        cd                              ('BF');
        dir_BF                      =    cd;
        dBF                         =    dir('*.tif'); % '*.tif' select only tif files in directory
        % Determine Number of Parts, Positions, and Zstacks
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
                    ev          =    strcat('Part*_p',num2str(posnum),'*'); %Problem: Preinjury and Parts have different Posnum
                    f           =    dir(ev);
                    check       =    isempty(f);
            end;
         %posnum   =  posnum-1;%-1; Don't minus 1 because p0 is a position.
        %--Parts------------------------------------------------------
        check                       =  0;
        parts                       =  0;
            while check ==0
                    parts       =    parts+1;
                    evp         =    strcat('*Part',num2str(parts),'*');
                    f           =    dir(evp);
                    check       =    isempty(f);
            end;
        % parts=parts-1;%%%We don't substract because we assume the extra will
        % be preinjury
        %--BF/PhaseContrast Z-stack Check---------------------------------
        zPh2num                     =  0;
        Ph2_checkZs                 =  0;
            while Ph2_checkZs ==0 %%Note we are assuming there are Z/if not will LOOP CONTINOUSLY
                     zPh2num     =   zPh2num+1;
                     evt         =   strcat('*_z',num2str(zPh2num),'*');
                     f           =   dir(evt);
                     Ph2_checkZs =   isempty(f);
                     if zPh2num>20
                         zPh2num    =   1;
                         break
                     end;
             end;
        %zPh2num    =  zPh2num-1;%No Minus because z0 is a count. %Total Length of Z Positions  
        %--Diplays---------------------------------------------------------
        disp('End: Locating BF Directory')
        disp('End: Determining #Positions,#Parts,#Zstacks, and #Frames')
        cd                              (exp_folder) 
        %% Determining Color Filter Number of Parts, Positions, and Zstacks
        cd                   ('TexRed');
        dir_TexRed       =    cd;
        dTexRed          =    dir('*.tif'); % '*.tif' select only tif files in directory
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Updated 12/08/2014  
        %--TEXRED Z-stack Check 
        znum=0;
        checkZs=0;
        while checkZs ==0 %%Note we are assuming there are Z/if not will LOOP CONTINOUSLY
                 znum        = znum+1;
                 evt         = strcat('*_z',num2str(znum),'*');
                 f           = dir(evt);
                 checkZs     = isempty(f);
        end;
        TRznum     =  znum; %Incorporate in the Future?
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cd          (exp_folder)    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cd                   ('GFP');
        dir_GFP       =    cd;
        dGFP          =    dir('*.tif'); % '*.tif' select only tif files in directory
        %--GFP Z-stack Check
        zGFPnum=0;
        GFP_checkZs=0;
        while GFP_checkZs ==0 %%Note we are assuming there are Z/if not will LOOP CONTINOUSLY
                 zGFPnum     = zGFPnum + 1;
                 evt_GFP     = strcat('*_z',num2str(zGFPnum),'*');
                 f_GFP       = dir(evt_GFP);
                 GFP_checkZs = isempty(f_GFP);
                 if zGFPnum>20
                     zGFPnum    = 1;
                     break
                 end;
        end;
        Zname=1; %To ensure it still takes into account the name spacing
        PH2check   =  0;
        GFPcheck   =  0;
        TRcheck    =  0;%isempty(dTexRed); %If empty will be 1;   
        %--Diplays---------------------------------------------------------
        disp('End: Filtered Determining #Parts & #Positions & #Zstacks')
        cd          (exp_folder) 
    %% Separate into Arrays
        cds={dir_BF,dir_GFP,dir_TexRed};
        prev_folder=fileparts(exp_folder);
        cd(prev_folder);               
        cd(exp_folder);
        Arr_Ph2={};
        Arr_GFP={};  %{Part}{Position}{All in Time001}
        Arr_TexRed={};
        for I=1:parts
            cd(dir_BF)
            numfid=0;
            if I==parts;
                str_shmidt='*njury';
                str_part=strcat(str_shmidt);
            else
                str_shmidt='Part';
                str_part=strcat(str_shmidt,num2str(I));
            end;
            allfids=length(dGFP);
            allfids(I)=allfids;
            Green={}; TeRe={};
            Green2={};
            GreenZ={};
            TeRe1={};
            TeReZ={};
            disp(str_part)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    %         pause()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for j = 1:posnum
                i=j-1;

                namePh2         = strcat(str_part,'*_z4*','p',num2str(i),'*');
                nameTR          = strcat(str_part,'*p',num2str(i),'*');
                nameGFP         = strcat(str_part,'*p',num2str(i),'*');
                arr_strPositionName{j}=strcat('P',num2str(i));
                %--------Ph2---------
                cd(dir_BF)
                    ff          = dir(namePh2);
                    numfids(I)  = length(ff);
    %      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                 if I==1;
    %                     numfids(I) = 99;
    %                 else
    %                 end;
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                     DD         = [ff(:).datenum].'; % you may want to eliminate . and .. first.
                    [DD,DD]     = sort(DD);
                    PH2{j}      = {ff(DD).name}; % Cell array of names in order by datenum.
                    %Note PH2 is arrayed {str} by Positions and then (str) frames.  No Z's
                    %chose middle z~4 since we don't care about the stack at
                    %this point.
                cd(exp_folder);
                %--------BF with Zstack ---------
                cd            (dir_BF);
                if I~=parts 
                    gg      = dir(namePh2);
                    EE      = [gg(:).datenum].'; % you may want to eliminate . and .. first.
                    [EE,EE] = sort(EE);
                    BF{j} = {gg(EE).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval
                    if znum>1
                        for bi = 1:numfids(I)
                            ti=bi-1;
                           %--------Z---------
                           if numfids(I)>99
                               if ti==1
                                   nameTR1  = strcat(str_part,'*t000','*p',num2str(i),'*');
                               elseif ti<10
                                    nameTR1  = strcat(str_part,'*t00',num2str(ti),'*p',num2str(i),'*');
                               elseif ti<100
                                    nameTR1  = strcat(str_part,'*t0',num2str(ti),'*p',num2str(i),'*');
                               else
                                    nameTR1  = strcat(str_part,'*t',num2str(ti),'*P',num2str(i),'*');
                               end;
                           elseif numfids(I)==10
                               nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           elseif numfids(I)<10
                               if ti==1
                                   nameTR1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                               elseif ti<10
                                    nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                               else
        %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                               end;                  
                           else
                               if ti==1
                                   nameTR1  = strcat(str_part,'*t00','*p',num2str(i),'*');
                               elseif ti<10
                                    nameTR1  = strcat(str_part,'*t0',num2str(ti),'*p',num2str(i),'*');
                               elseif ti<100
                                    nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                               else
        %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                               end;
                           end;
                            gg1       = dir(nameTR1);
                            EE1       = [gg1(:).datenum].'; % you may want to eliminate . and .. first.
                            [EE1,EE1] = sort(EE1);
                            BF1{bi} = {gg1(EE1).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval               
                         end;
                        BFZ{j}    = BF1;   % %TeReZ{Position}{Z}{frame}
                    else            
                    display('No BF')
                    end;
                else
                    %%%%%%%PRE INJURY%%%%%%%%%%%%%%%%%%
                    %Preinjury has to be less than 10 frames or this won't work
                    gg      = dir(nameTR);
                    EE      = [gg(:).datenum].'; % you may want to eliminate . and .. first.
                    [EE,EE] = sort(EE);
                    BF{j} = {gg(EE).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval
                    if znum>1
                        for bi = 1:numfids(I)
                            ti=bi-1;
                           %--------Z---------
                           if ti==1
                               nameTR1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                           elseif ti<10
                                nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           else
    %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                           end;
                            gg1       = dir(nameTR1);
                            EE1       = [gg1(:).datenum].'; % you may want to eliminate . and .. first.
                            [EE1,EE1] = sort(EE1);
                            BF1{bi} = {gg1(EE1).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval               
                         end;
                        BFZ{j}    = BF1;   % %TeReZ{Position}{Z}{frame}
                    else
                    end;
                 end;
                 cd(exp_folder);
                
                %--------TexRed---------
                cd            (dir_TexRed);
                if I~=parts 
                    gg      = dir(nameTR);
                    EE      = [gg(:).datenum].'; % you may want to eliminate . and .. first.
                    [EE,EE] = sort(EE);
                    TeRe{j} = {gg(EE).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval
                    if znum>1
                        for bi = 1:numfids(I)
                            ti=bi-1;
                           %--------Z---------
                           if numfids(I)>99
                               if ti==1
                                   nameTR1  = strcat(str_part,'*t000','*p',num2str(i),'*');
                               elseif ti<10
                                    nameTR1  = strcat(str_part,'*t00',num2str(ti),'*p',num2str(i),'*');
                               elseif ti<100
                                    nameTR1  = strcat(str_part,'*t0',num2str(ti),'*p',num2str(i),'*');
                               else
                                    nameTR1  = strcat(str_part,'*t',num2str(ti),'*P',num2str(i),'*');
                               end;
                           elseif numfids(I)==10
                               nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           elseif numfids(I)<10
                               if ti==1
                                   nameTR1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                               elseif ti<10
                                    nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                               else
        %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                               end;                  
                           else
                               if ti==1
                                   nameTR1  = strcat(str_part,'*t00','*p',num2str(i),'*');
                               elseif ti<10
                                    nameTR1  = strcat(str_part,'*t0',num2str(ti),'*p',num2str(i),'*');
                               elseif ti<100
                                    nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                               else
        %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                               end;
                           end;
                            gg1       = dir(nameTR1);
                            EE1       = [gg1(:).datenum].'; % you may want to eliminate . and .. first.
                            [EE1,EE1] = sort(EE1);
                            TeRe1{bi} = {gg1(EE1).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval               
                         end;
                        TeReZ{j}    = TeRe1;   % %TeReZ{Position}{Z}{frame}
                    else            
                    display('No TexRed')
                    end;
                else
                    %%%%%%%PRE INJURY%%%%%%%%%%%%%%%%%%
                    %Preinjury has to be less than 10 frames or this won't work
                    gg      = dir(nameTR);
                    EE      = [gg(:).datenum].'; % you may want to eliminate . and .. first.
                    [EE,EE] = sort(EE);
                    TeRe{j} = {gg(EE).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval
                    if znum>1
                        for bi = 1:numfids(I)
                            ti=bi-1;
                           %--------Z---------
                           if ti==1
                               nameTR1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                           elseif ti<10
                                nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           else
    %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                           end;
                            gg1       = dir(nameTR1);
                            EE1       = [gg1(:).datenum].'; % you may want to eliminate . and .. first.
                            [EE1,EE1] = sort(EE1);
                            TeRe1{bi} = {gg1(EE1).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval               
                         end;
                        TeReZ{j}    = TeRe1;   % %TeReZ{Position}{Z}{frame}
                    else
                    end;
                 end;
                 cd(exp_folder);
                %--------GFP---------

                cd(dir_GFP);
                if I~=parts
                    hh=dir(nameGFP);
                    HH = [hh(:).datenum].'; % you may want to eliminate . and .. first.
                    [HH,HH] = sort(HH);
                    Green{j} = {hh(HH).name}; % Cell array of names in order by datenum.  Green{Position}{TimeInterval
                %%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if zGFPnum>1
                        for bi=1:numfids(I)
                           ti=bi-1;
                           %--------Z---------
                           if numfids(I)>99
                               if ti==1
                                   nameGFP1  = strcat(str_part,'*t000','*p',num2str(i),'*');
                               elseif ti<10
                                    nameGFP1  = strcat(str_part,'*t00',num2str(ti),'*p',num2str(i),'*');
                               elseif ti<100
                                    nameGFP1  = strcat(str_part,'*t0',num2str(ti),'*p',num2str(i),'*');
                               else
                                    nameGFP1  = strcat(str_part,'*t',num2str(ti),'*P',num2str(i),'*');
                               end;
                          elseif numfids(I)==10
                               nameGFP1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           elseif numfids(I)<10
                               if ti==1
                                   nameGFP1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                               elseif ti<10
                                    nameGFP1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                               else
        %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                               end;
                           else
                               if ti==1
                                   nameGFP1  = strcat(str_part,'*t00','*p',num2str(i),'*');
                               elseif ti<10
                                    nameGFP1  = strcat(str_part,'*t0',num2str(ti),'*p',num2str(i),'*');
                               elseif ti<100
                                    nameGFP1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                               else
        %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                               end;
                           end;
                            mn=dir(nameGFP1);
                            MN = [mn(:).datenum].'; % you may want to eliminate . and .. first.
                            [MN,MN] = sort(MN);
                            Green2{bi} = {mn(MN).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval                
                        end;
                        GreenZ{j}=Green2; %{Position}{all Z in time 1}       
                    else
                    end; 

                else
                    hh=dir(nameGFP);
                    HH = [hh(:).datenum].'; % you may want to eliminate . and .. first.
                    [HH,HH] = sort(HH);
                    Green{j} = {hh(HH).name}; % Cell array of names in order by datenum.  Green{Position}{TimeInterval
                %%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if zGFPnum>1
                        for bi=1:numfids(I)
                           ti=bi-1;
                           %--------Z---------
                           if ti==1
                               nameGFP1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                           elseif ti<10
                                nameGFP1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           else
    %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                           end;
                            mn=dir(nameGFP1);
                            MN = [mn(:).datenum].'; % you may want to eliminate . and .. first.
                            [MN,MN] = sort(MN);
                            Green2{bi} = {mn(MN).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval                
                        end;
                        GreenZ{j}=Green2; %{Position}{all Z in time 1}       
                    else
                    end;
                end;
                cd(exp_folder);
            end;
            Arr_Ph2{I}=PH2;
            Arr_BF{I}=BFZ;
            Arr_GFP{I}=GreenZ;  %{Part}{Position}{All Z in Time001} therefore to call Arr_GFP{parts}{posnum}{numfid}(znum) **note parenthesis.
            Arr_TexRed{I}=TeReZ;
        end;
        PositionName=arr_strPositionName;
        disp('Arr_Ph2    FINISHED')
        disp('Arr_BF     FINISHED')
        disp('Arr_GFP    FINISHED')
        disp('Arr_TexRed FINISHED')
    else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end;
else
    display('You are keeping all old variables, pepare to save "-append"')
end;
disp('END3: Getting TIFF NAMES')
pause();
%% 4 IMREAD PH2 GFP and TexRed
%NOTE: Arr_Channel{a}{b}{c} - a=parts, b=posnum, c=numfids(), d=znum;
a               =  parts;
b               =  posnum;
c               =  numfids; %alter to 2nd Frame/Middle Frame/Last Frame
d               =  znum;

%%%%only for AB020  
if name=='AB020'
    a=1;
else
end;
%%%%only for AB020
valsBF={0};
valsGFP={0};
valsTR={0};
clear vals_k_BF vals_k_GFP vals_k_TR
for i=1:a
    disp(strcat('Part',num2str(i)))
    for j=1:b
        disp(strcat('Position',num2str(j)))
        aa=0;
        for k=[1,round(c(i)/2),c(i)]  %k=1:c(i)
            aa=aa+1;
            disp(strcat('Frame',num2str((aa/3*100)),'%'))           
            vals_ii_BF={0};
            vals_ii_GFP={0};
            vals_ii_TR={0};
            
            for ii=1:d
                cd(dir_BF);    % BF
                vals_ii_BF{ii}=imread(Arr_BF{i}{j}{k}{ii});
                cd(dir_GFP);   % GFP
                vals_ii_GFP{ii}=imread(Arr_GFP{i}{j}{k}{ii});
                cd(dir_TexRed);% TexRed
                vals_ii_TR{ii}=imread(Arr_TexRed{i}{j}{k}{ii});
            end;
            vals_k_BF{aa}  = vals_ii_BF;
            vals_k_GFP{aa} = vals_ii_GFP;
            vals_k_TR{aa}  = vals_ii_TR;
        end;
        vals_j_BF{j}  = vals_k_BF;
        vals_j_GFP{j} = vals_k_GFP;
        vals_j_TR{j}  = vals_k_TR;
    end;
    valsBF{i}  = vals_j_BF;
    valsGFP{i} = vals_j_GFP;
    valsTR{i}  = vals_j_TR;
end;
        disp('valsBF     FINISHED')
        disp('valsGFP    FINISHED')
        disp('valsTexRed FINISHED')
cd              (exp_folder)
disp            ('END4: Reading TIFFs {First,Middle,Last}')
pause           ()
%% 5 2D-3D Rendering  
mymap = [0 0 0
    1 0 0
    0 1 0
    0 0 1
    1 1 1];

M=0;
vals2bitGFP={};
vals18bitGFP={};
valsBFBF={};
for i=1:znum
    I               = valsGFP{1}{1}{1}{i};% parts,position,frame,znum
    I_BF            = valsBF{1}{1}{1}{i};
    I2              = im2uint8(I);
        background_sandy = imopen(I2,strel('disk',15));
        I2 = I2 - background_sandy;        
        I2 = imadjust(I2, stretchlim(I2), []);
    vals2bitGFP{i}  = I2;
    vals18bitGFP{i} = I;
        %%%REGULAT ADJUSTMENT
        background_sandy = imopen(I_BF,strel('disk',15));
        I3 = I_BF - background_sandy;        
        Sandy_Inew = imadjust(I3, stretchlim(I3), []);
        Shandi     = imadjust(I_BF);
       %%%GUASSIAN BASED ADJUSTMENT 
        n = 2;
        Idouble = im2double(I_BF);
        avg = mean2(Idouble);
        sigma = std2(Idouble);
        imBF = imadjust(I_BF,[avg-n*sigma avg+n*sigma],[]);
    valsBFBF{i}        =imBF;
    valsShandi{i}       =Shandi;
end;
n=7;
M=cat(n,vals2bitGFP{1},vals2bitGFP{2},vals2bitGFP{3},vals2bitGFP{4},vals2bitGFP{5},vals2bitGFP{6},vals2bitGFP{7}); %Creates 512x512xn, n=zstack
Dimage=cat(n,vals18bitGFP{1},vals18bitGFP{2},vals18bitGFP{3},vals18bitGFP{4},vals18bitGFP{5},vals18bitGFP{6},vals18bitGFP{7}); %Creates 512x512xn, n=zstack
Dbf=cat(n,valsBFBF{1},valsBFBF{2},valsBFBF{3},valsBFBF{4},valsBFBF{5},valsBFBF{6},valsBFBF{7}); %Creates 512x512xn, n=zstack
size(M);

hf1=figure();
    for i=1:n
        [rows,cols]=size(I2);
        [XX,YY]= meshgrid((1:cols),(1:rows));
        ZZ = i * ones(rows,cols);
        hf1=surf(XX,YY,ZZ,Dbf(:,:,1),'edgecolor','none');
        colormap(gray)
        hold on;
        set(hf1,'FaceAlpha',0.8);
        [xs,ys,zs] = ndgrid( 1:512 , 1:512 , 1:n ) ;
    end;

disp('END: Display 2D Stack in 3D structuring')
%% 6 Binary Image Thresholding

        boo_beadignore=0;
        ii=0;%this is the iteration count******************************
        boo_skipKframe=0; %--Resetting 
        input_kframe=3;
        arr_numerical=(1:100);
for k=1:n
        %%Prepping Images and Digital Processing Fundamentals
        %PhaseContras imadjust
        ii=ii+1; %this is the iteration count******************************
        Fish = valsBFBF{k};
        Mpeg = vals2bitGFP{k};
        
        background_sandy = imopen(Fish,strel('disk',15));
        Fish2 = Fish - background_sandy;        
        Sandy_Inew = imadjust(Fish2, stretchlim(Fish2), []);
        %Floursecent imadjust
       
        background_bloody = imopen(Mpeg,strel('disk',15));
        Bloody_background = Mpeg - background_bloody;
        %---Introduce greater Image Contrast
        InewB = imadjust(Mpeg, stretchlim(Mpeg), []);
        Bloodynew=InewB;
        InewB_background = imadjust(Bloody_background, stretchlim(Bloody_background), []);
        Bloody2=InewB_background;
        %%---Conduct Cell Outlines and Intensity outlines
        [bw,bw4,BWFINAL,I_mod] = Mpeg_segmentation(Mpeg); %%SO far---Useless!!!       
        if k==input_kframe
            input_FudgeSatisfaction='n';
            fudgefactor=graythresh(Mpeg);
            while_it=0;
            arr_fudge=0; %to clear varible /not sure if it will work
            b_fudge=0.001;
            b_multiple=1;
            while input_FudgeSatisfaction~='y'
                while_it=while_it+1;
                bw_while_segmentation = im2bw(Mpeg,fudgefactor);
                figure(while_it+1000); whitebg('w');imshow(bw_while_segmentation);title(strcat('Frame: ',num2str(while_it),'|FudgeFactor: ',num2str(fudgefactor)));
                arr_fudge(while_it)=fudgefactor;
                input_FudgeSatisfaction=input('Are you satisfied with this fudgefactor y/n?,manual (m)(f+),(f-) reverse (r) multiple fudge(x) ','s');
                if input_FudgeSatisfaction=='n'
                    fudgefactor= fudgefactor +b_fudge;
                elseif input_FudgeSatisfaction=='r'
                    b_fudge=-b_fudge;
                    fudgefactor= fudgefactor +b_fudge;
                elseif input_FudgeSatisfaction=='f+'
                    b_fudge=b_fudge*10;
                elseif input_FudgeSatisfaction=='f-'
                    b_fudge=b_fudge/10;
                elseif input_FudgeSatisfaction=='x'
                    input_bmultiple=input('By a mutliple of what (0.001) do you want to advance (scalar)?');
                    fudgefactor=fudgefactor+ b_fudge*input_bmultiple;
                elseif input_FudgeSatisfaction=='m'
                    input_FudgeManual=input('Manual number?');
                    fudgefactor=input_FudgeManual;
                else
                    fudgefactor= fudgefactor +b_fudge;
                    disp('Did not select designated inputs, thus will serve as "n"')
                    continue
                end;
            end;
            %%Selecting and Creating a High and Low FudgeFactr
            display(num2str(arr_numerical(1:length(arr_fudge))))
            display(arr_fudge)
            input_FudgeSelection=input('which fudgefactor do you prefer?');
            FudgeFactor_low=arr_fudge(input_FudgeSelection);
            FudgeFactor_high=FudgeFactor_low+0.1;         
            %% Overlay Image Segout                  
            [bw_normaledges,bw_blockimg_I,bw_blockimg_II,bw_blockimg_III]=BlockProcessing(Fish);         
            bw1_MPEG_low = im2bw(Mpeg,FudgeFactor_low);
                bw1_MPEG_low=bwareaopen(bw1_MPEG_low,10);
            bw1_MPEG_high = im2bw(Mpeg,FudgeFactor_high); 
                bw1_MPEG_high=bwareaopen(bw1_MPEG_high,10);
            %%Use bwselect to delete specific values
            %%ASSUMPTION:  Objects  will not shift significantly...
            %%..i.e. Fish tail will remain relatively in the same place
            bw_overlay=imoverlay(Bloody2,bwperim(bw1_MPEG_low),[1 0 0]);
            figure();whitebg('b');imshow(bw1_MPEG_low);title('Please Select the Indigenous Fluorescent structures you wish to not include in Mp Counting');
            [x,y,bw_delete,idx,xi,yi] =bwselect();           
            color_delete=imoverlay(bw1_MPEG_low,bw_delete,[0 0 1]); %turn objects blue
            close();
            se=strel('line',3,0);
            se2=strel('line',5,90);
            dilatebw_delete=imdilate(bw_delete,[se se2]);
            bw2_delete = bwmorph(bw_delete,'thicken');
            bw_MPEG_low=~dilatebw_delete & bw1_MPEG_low;
       %%%Update
           bw_MPEG_low=bwmorph(bw_MPEG_low,'fill');
           bw_MPEG_low=bwmorph(bw_MPEG_low,'diag');

       %%%
            bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;
%             bw_MPEG_high=bwmorph(bw_MPEG_high,'thicken');
                bw_MPEG_high=bwmorph(bw_MPEG_high,'fill');
                bw_MPEG_high=bwmorph(bw_MPEG_high,'diag');
            %%-Show some figures
            figure();whitebg('white');imshow(color_delete);title('Objects in Blue are structures selected for deletion');
            figure();imshow(bw_MPEG_low);title('Low'); 
            figure();imshow(bw_MPEG_high);title('High');colordef black               
            bw_empty=false(size(bw_MPEG_low));
        %%%%%DELETE ALL OUT OF FISH PERIMITER
            figure();whitebg('r');imshow(~bw_normaledges);title('ROI poly outline Fish border');
            bw_F=roipoly();
%             bw_F=~bw_F;
            bw_Fish=bw_F & bw_normaledges;
            
        %%%%%thicken the low threshold to see the differnce, hence bw2
                bw2_MPEG_low = bwmorph(bw_MPEG_low,'thicken',2);
                    bw2_MPEG_low=bwmorph(bw2_MPEG_low,'fill');
                    bw2_MPEG_low=bwmorph(bw2_MPEG_low,'diag');
%                 bw2_MPEG_high= bwmorph(bw_MPEG_high,'thicken');
                    bw2_MPEG_high=bwmorph(bw2_MPEG_high,'fill');
%                 bw2_MPEG_high= bwmorph(bw2_MPEG_high,'thicken',5);
        %%%%%
%                 bw3_diff= ~bw2_MPEG_high & bw2_MPEG_low;  
                bw_diff=~bw2_MPEG_high & bw_MPEG_low; % bw_compilebead_e=bwareaopen(bw_compilebead,30);   
            bw2_diff = bwmorph(bw_diff,'thicken');
                color_bw_MPEG_low=imoverlay(bw_empty,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_MPEG=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red
                color_background=imoverlay(~bw_empty,bw_normaledges,[0 1 0]);%turn objects green
                color_bw_MPEG_low=imoverlay(color_background,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_segout=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red
                color_bw_MPEG_low=imoverlay(Fish,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_realsegout=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red
            

%                 figure();imshow(color_perim_low);title('color perim low')
%                 figure();imshow(color_bw_MPEG_high);title('color bw MPEG high')
%                 figure();imshow(color_perim_high);title('color perim high')
            figure();whitebg('w');imshow(bw_color_MPEG);%title('bw color MPEG')
            figure();imshow(bw_color_segout);title('ZebraFish Caudal Fin Segout');
            pause()
        elseif k==4;
            [bw_normaledges,bw_blockimg_I,bw_blockimg_II,bw_blockimg_III]=BlockProcessing(Fish);         
            bw1_MPEG_low = im2bw(Mpeg,FudgeFactor_low);
            bw1_MPEG_low=bwareaopen(bw1_MPEG_low,10);
            bw1_MPEG_high = im2bw(Mpeg,FudgeFactor_high); 
            bw1_MPEG_high=bwareaopen(bw1_MPEG_high,10);
                       color_delete=imoverlay(bw1_MPEG_low,bw_delete,[0 0 1]); %turn objects blue
            close();
            se=strel('line',3,0);
            se2=strel('line',5,90);
            dilatebw_delete=imdilate(bw_delete,[se se2]);
            bw2_delete = bwmorph(bw_delete,'thicken');
            bw_MPEG_low=~dilatebw_delete & bw1_MPEG_low;
       %%%Update
           bw_MPEG_low=bwmorph(bw_MPEG_low,'fill');
           bw_MPEG_low=bwmorph(bw_MPEG_low,'diag');

       %%%
            bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;
%             bw_MPEG_high=bwmorph(bw_MPEG_high,'thicken');
                bw_MPEG_high=bwmorph(bw_MPEG_high,'fill');
                bw_MPEG_high=bwmorph(bw_MPEG_high,'diag');
            %%-Show some figures
%             figure();whitebg('white');imshow(color_delete);title('Objects in Blue are structures selected for deletion');
%             figure();imshow(~bw_normaledges);
%             figure();imshow(bw_MPEG_low);title('Low'); 
%             figure();imshow(bw_MPEG_high);title('High');colordef black               
            bw_empty=false(size(bw_MPEG_low));
        %%%%%thicken the low threshold to see the differnce, hence bw2
                bw2_MPEG_low = bwmorph(bw_MPEG_low,'thicken',2);
                    bw2_MPEG_low=bwmorph(bw2_MPEG_low,'fill');
                    bw2_MPEG_low=bwmorph(bw2_MPEG_low,'diag');
%                 bw2_MPEG_high= bwmorph(bw_MPEG_high,'thicken');
                    bw2_MPEG_high=bwmorph(bw2_MPEG_high,'fill');
%                 bw2_MPEG_high= bwmorph(bw2_MPEG_high,'thicken',5);
        %%%%%
%                 bw3_diff= ~bw2_MPEG_high & bw2_MPEG_low;  
                bw_diff=~bw2_MPEG_high & bw_MPEG_low; % bw_compilebead_e=bwareaopen(bw_compilebead,30);   
            bw2_diff = bwmorph(bw_diff,'thicken');
                color_bw_MPEG_low=imoverlay(bw_empty,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_MPEG=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red
                color_background=imoverlay(~bw_empty,bw_normaledges,[0 1 0]);%turn objects green
                color_bw_MPEG_low=imoverlay(color_background,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_segout=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red
                color_bw_MPEG_low=imoverlay(Fish,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_realsegout=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red            
        else
            [bw_normaledges,bw_blockimg_I,bw_blockimg_II,bw_blockimg_III]=BlockProcessing(Fish);         
            bw1_MPEG_low = im2bw(Mpeg,FudgeFactor_low);
            bw1_MPEG_low=bwareaopen(bw1_MPEG_low,10);
            bw1_MPEG_high = im2bw(Mpeg,FudgeFactor_high); 
            bw1_MPEG_high=bwareaopen(bw1_MPEG_high,10);
                       color_delete=imoverlay(bw1_MPEG_low,bw_delete,[0 0 1]); %turn objects blue
            close();
            se=strel('line',3,0);
            se2=strel('line',5,90);
            dilatebw_delete=imdilate(bw_delete,[se se2]);
            bw2_delete = bwmorph(bw_delete,'thicken');
            bw_MPEG_low=~dilatebw_delete & bw1_MPEG_low;
       %%%Update
           bw_MPEG_low=bwmorph(bw_MPEG_low,'fill');
           bw_MPEG_low=bwmorph(bw_MPEG_low,'diag');

       %%%
            bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;
            bw_MPEG_high=bwmorph(bw_MPEG_high,'thicken');
                bw_MPEG_high=bwmorph(bw_MPEG_high,'fill');
                bw_MPEG_high=bwmorph(bw_MPEG_high,'diag');
            
        end;
        Arr_bw_high{k}=bw_MPEG_high;
        Arr_L_high{k}=bwlabel(bw_MPEG_high);
        Arr_Mpeg{k}=Mpeg;
        Arr_bw_Fish{k}=bw_Fish;
        if k==1;
            L=bwlabel(bw_MPEG_high);
            dataMpeg=Mpeg;
            bwImage=bw_MPEG_high;
            bwFish=bw_Fish;
        else
            L=cat(3,L,bwlabel(bw_MPEG_high));
            dataMpeg=cat(3,dataMpeg,Mpeg);
            bwImage=cat(3,bwImage,bw_MPEG_high);
            bwFish=cat(3,bwFish,bw_Fish);
        end;

        
end;
%%
% bwImage=cat(3,bw_color_MPEG,bw_color_MPEG,bw_color_MPEG,bw_color_MPEG,bw_color_MPEG,bw_color_MPEG,bw_color_MPEG); %Creates 512x512xn, n=zstack
           bw_perim=bwperim(bw_MPEG_high);
           bw_blot=bwmorph(bw_perim,'fill');
            bw_color=imoverlay(bwFish(:,:,4),bw_MPEG_high,[0 1 0]);
            bw_color_Fish=imoverlay(bw_color,bwperim(bw_MPEG_high),[1 1 0]);
                 figure();imshow(bw_color_Fish);%title('color bw MPEG high')
                 
            Fish_MPEG=imoverlay(valsBFBF{4},bw_MPEG_high,[0 1 0]);     
                 
hf2=figure();
% hs=figure();
    for i=1:n
        [rows,cols]=size(I2);
        [XX,YY]= meshgrid((1:cols),(1:rows));
        ZZ = i * ones(rows,cols);
        hf2=surf(XX,YY,ZZ,dataMpeg(:,:,i),'edgecolor','none');
%         hs = slice(bwImage,[],[],1:4) ;
        colormap('gray')
        hold on;
        shading interp
        set(hf2,'FaceAlpha',0.5);
        [xs,ys,zs] = ndgrid( 1:512 , 1:512 , 1:n ) ;
    end;


disp('End: Binary Image Thresholding'); 
%%
    h236=figure(236);%set(h236,'position',[ 0.64 0.045    0.320    0.45000]);
    cla
    p1 = patch(isosurface(dataR(indexR,indexC,indexL), handles.thresLevel(1)),'FaceColor','c','EdgeColor','none');
    p2 = patch(isosurface(dataR(indexR,indexC,indexL), handles.thresLevel(2)),'FaceColor','m','EdgeColor','none');
        q1=camlight('right');
    set(q1,'Position',[-320,-260,0])
    q2=camlight('right');
    set(q2,'Position',[540,-100,60])
    camlight left; camlight; 

    axis ij
    view(10,70)
    alpha (0.5)
    lighting gouraud
    rotate3d on
    grid on
    title('(f)','fontsize',18)




%% %% %%%%%%%%%%%PREVIOUS WORKS - cell tracking * Unfinished
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             GOLD=22;
%             %%-- Area
%             area_high=stats_h(GOLD).Area;
%             str_area_high = sprintf('%2.2f',area_high);
%                 area_diff=stats_d(GOLD).Area;
%                 str_area_low = sprintf('%2.2f',area_low);
%             %%--Centroids
%             centriods_high = cat(1,stats_h.Centroid);
%             centroid_h = stats_h(GOLD).Centroid;
%                 centriods_low = cat(1,stats_h.Centroid);
%                 centroid_h = stats_h(GOLD).Centroid;
%             
%             %%--Boundaries
%             [B,L]=bwboundaries(bw_MPEG_high);
%             boundary_glock=B{GOLD};
%             %%--Plot
%             figure;imshow(Sandy_Inew); hold on
%             %%---Get Perfect Score by Selecting Place
%             str_endwoundsite='Wound Site';
%             str_region2='Far Point';
%             [X,Y,I2,RECT]=imcrop(Sandy_Inew);
%             close
%             figure;imshow(Sandy_Inew); hold on
%             plot(RECT(1),RECT(2),'y*')%--Perfect Score
%             text(RECT(1)+35,RECT(2)+13,str_endwoundsite,'Color','yellow',...
%                 'FontSize',8,'FontWeight','bold');
%             [Q,W,I3,RECTF]=imcrop;
%             plot(RECTF(1),RECTF(2),'r*')%--Failing Score
%             text(RECTF(1)-35,RECTF(2)-13,str_region2,'Color','red',...
%                 'FontSize',8,'FontWeight','bold');
%             %%line
%             xline=[RECT(1),RECTF(1)];
%             yline=[RECT(2),RECTF(2)];
%             DistanceGold=sqrt(diff(xline)^2 +diff(yline)^2) ;%pythagorean theorem
%             for j = 1:length(B)
%                 boundary = B{j};
%                 if j==GOLD
%                     plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 0.7)
%                     plot(centroid_h(1),centroid_h(2),'b*');
%                     text(boundary(1,2)-35,boundary(1,1)+13,str_area_high,'Color','yellow',...
%                         'FontSize',8,'FontWeight','bold');
%                     Bounds{k}=[boundary(:,2),boundary(:,1)];
%                 else
%                     plot(boundary(:,2), boundary(:,1), 'c', 'LineWidth', 0.5)
%                 end;
%             end;
%             %Determine the Score of the First Macrophage point
%             xline=[centroid_h(1),RECT(1)];
%             yline=[centroid_h(2),RECT(2)];
%             Dist=sqrt(diff(xline)^2 +diff(yline)^2);
%             goalie=(Dist/DistanceGold)*100;
%             speed=0;
%             Cents(1,1)=centroid_h(1);
%             Cents(1,2)=centroid_h(2);
% 
%             bw_MPEG_high = im2bw(Mpeg,FudgeFactor_low);
%             Mpeg_1 = valsMask{K}{k+1};
%             bw_segmentation_1 = im2bw(Mpeg_1,FudgeFactor_low);
%             %%--This Image
%             cc_high = bwconncomp(bw_MPEG_high);
%             stats_h = regionprops(cc_high, 'basic');
%             grain_areas = [stats_h.Area];
%             [max_area,idx_min] = max(grain_areas);
%             [min_area,idx_max] = min(grain_areas);
%             %%--Max
%             grain_max = false(size(bw_MPEG_high));
%             grain_max(cc_high.PixelIdxList{idx_max}) = true;
%             %%--Create 512 x 512  Max with Selected Pixel
%             fff=false(cc_high.ImageSize);
%             glock = fff;
%             %                 glock(cc.PixelIdxList{Gold}) = true;
%             %%--Centroids
%             centriods_high = cat(1,stats_h.Centroid);
%             %%--Boundaries
%             [B,L]=bwboundaries(bw_MPEG_high);
%             for i=1:cc_high.NumObjects
%                 point=[centriods_high(i,1),centriods_high(i,2)];
%                 xl=[point(1),Cents(k-1,1)];
%                 yl=[point(2),Cents(1,2)];
%                 Distances(i)=sqrt(diff(xl)^2 +diff(yl)^2) ;%pythagorean theorem
%                 glock = false(cc_high.ImageSize);
%                 glock(cc_high.PixelIdxList{i}) = true;
%             end;
%             
%             %%Currently minimum distance is the dictator for this,
%             %%however,expect to need conditional statements for size an
%             %%other crazy situations.
%             [min_dist,idx_dist]=min(Distances); %idx_dist is the position of the object that is "closest"
%             centroid_h=[centriods_high(idx_dist,1),centriods_high(idx_dist,2)];%new point of macrophage
%             xline=[centroid_h(1),RECT(1)];
%             yline=[centroid_h(2),RECT(2)];
%             Dist=sqrt(diff(xline)^2 +diff(yline)^2);
%             goalie=(Dist/DistanceGold)*100;
%             speed=(min_dist*1.5)/(ti_d*60); %velocity:microns per second
%             %%-- Area
%             area_high=stats_h(idx_dist).Area;
%             str_area_high = sprintf('%2.2f',area_high);
%             %%TRYING TO DO SMALLEST DIFFERENCE IN CENTROID
%             GOLD=idx_dist;
%             clear Distances
%       
%         figure(100+k);imshow(Fish); hold on
%         plot(RECT(1),RECT(2),'y*')%--Perfect Score
%         text(RECT(1)+35,RECT(2)+13,str_endwoundsite,'Color','yellow',...
%             'FontSize',8,'FontWeight','bold');
%         plot(RECTF(1),RECTF(2),'r*')%--Failing Score
%         text(RECTF(1)-35,RECTF(2)-13,str_region2,'Color','red',...
%             'FontSize',8,'FontWeight','bold');
%         for j = 1:length(B)
%             boundary = B{j};
%             if j==GOLD
%                 plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 0.7)
%                 plot(centroid_h(1),centroid_h(2),'b*');
%                 text(boundary(1,2)-35,boundary(1,1)+13,str_area_high,'Color','yellow',...
%                     'FontSize',8,'FontWeight','bold');
%             else
%                 plot(boundary(:,2), boundary(:,1), 'c', 'LineWidth', 0.5)
%             end;
%         end;
%         
%         pause()
%         plot(Cents(:,1),Cents(:,2),':rs','MarkerEdgeColor','b')
%         %             plot(Cents(:,1),Cents(:,2),'r-*','MarkerEdgeColor','b')
%         pause()
%         Veloc(k)=speed;
%         Score(k)=goalie;
%         Cents(k,1)=centroid_h(1);
%         Cents(k,2)=centroid_h(2);
%         Plata(k)=GOLD;
%         
%         %           will need a way to save Boundary box and position of target object in another array outside of loop
%         clear Cents
%         %% --- Digital Image Adjusting
%         %             figure(K*200+k)
%         %             imshow(bw_segmentation)
%         % %             figure(K*100+k);imshow(Sandy);
%         %             [AreaFull,SingleBeadAreas,count,TotalBeads ] = idobject(bw_segmentation,Sandy);
%         
%         %% saving image created
%         ImgName=strcat('CellTracking',PH2{K}{k});
%         saveas(gcf, ImgName, 'tif')
%         display('Saved')
%         
%     %% Might not be fixed yet
%     %%%%%%%%%%%%--Plot
%     figure;imshow(Fish); hold on
%     plot(RECT(1),RECT(2),'y*')%--Perfect Score
%     text(RECT(1)+35,RECT(2)+13,str_endwoundsite,'Color','yellow',...
%         'FontSize',8,'FontWeight','bold');
%     plot(RECTF(1),RECTF(2),'r*')%--Failing Score
%     text(RECTF(1)-35,RECTF(2)-13,str_region2,'Color','red',...
%         'FontSize',8,'FontWeight','bold');
%     for j = 1:length(B)
%         boundary = B{j};
%         if j==GOLD
%             plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 0.7)
%             plot(centroid_h(1),centroid_h(2),'b*');
%             text(boundary(1,2)-35,boundary(1,1)+13,str_area_high,'Color','yellow',...
%                 'FontSize',8,'FontWeight','bold');
%         else
%             plot(boundary(:,2), boundary(:,1), 'c', 'LineWidth', 0.5)
%         end;
%     end;
%     
% 
