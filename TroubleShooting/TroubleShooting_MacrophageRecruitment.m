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
    %% 1111111111111111 Designated Folder Names
    clear all
     !hostname
    hostname                    =   char( getHostName( java.net.InetAddress.getLocalHost ) );
    ip                          =   char( getHostAddress( java.net.InetAddress.getLocalHost ) );
    user                        =   getenv('UserName');
    %Determining Foldernames Derived from Microsoft 'OneDrive' Cloud.  
       
        
    %% 2222222222222222 Designated Folder Names    
 
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
%        str_ProcessedData_str        ='E:\AndreDParedes\Mr-Big\RAW CZI DATA'; %Black WD:MyPassport Backup (Dr.B)
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
 %% 33333333333333333333  FIND THE BASIC COMPONETS OF THE ZEBRAFISH - ti_d, plate, name  
    %Starting Point for Folder
    cd(str_Presumptious)
    if input_16bit  =='C'  
        cd('C:\Users\AndreDaniel\OneDrive\CZI DATA - ZEN')
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
            Arr_GFP{I}=GreenZ;  %{Part}{Position}{All Z in Time001} therefore to call Arr_GFP{parts}{posnum}{numfid}(znum) **note parenthesis.
            Arr_TexRed{I}=TeReZ;
        end;
        PositionName=arr_strPositionName;
        disp('End: Sorting Names into Arrays') 
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        exp_folder = uigetdir('Pick the Zebrafish for basic time and names');
        addpath(exp_folder,str_Functions_str);%add path to *.mfile folder and *.tif foldersss
        %S = LOAD(Total.mat);
        [pa, name, ext] = fileparts(exp_folder); %break up file name
        figurename=name;
        cd(exp_folder)

        %not function isempty() is useful
        d = dir('*.tif'); % '*.tif' select only tif files in directory
        dPh2 = dir('*Ph2*');
        dTexRed = dir('*TexRed*');
        dGFP = dir('*GFP*');
        GFPcheck=isempty(dGFP);
        %% Determine Number of Positions
        %---1. Determine number of Positions
        %---2. Determine length minimum to fix graph issues
        %     PH2{[]}={[]};
        %     TeRe{[]}={[]};
        %     Green{[]}={[]};
        %     PositionName={[]};
        check=0;
        posnum=0;
        %----------------  Positions
        %Stores Position Numbers into variable
        %If variable Destination ev has values for Position # it increase
        %Once Position # is high enough it stops and knows Max Position Length
        while check == 0
            posnum=posnum+1;
            ev=strcat('*-P',num2str(posnum),'-*');
            f=dir(ev);
            check=isempty(f);
        end;
        posnum=posnum-1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Updated 12/08/2014    
        znum=0;
        checkZs=0;
                    while checkZs ==0 %%Note we are assuming there are Z/if not will LOOP CONTINOUSLY
                         znum=znum+1;
                         evt=strcat('*-z100',num2str(znum),'-*');
                         f=dir(evt);
                         checkZs=isempty(f);
                         if znum>20
                             znum=1;
                             break
                         end;
                    end;
                znum=znum-1; %Total Length of Z Positions
                if isempty(dTexRed)
                    str_FluorescentName='GFP';
                else
                    str_FluorescentName='TexRed';
                end;  


                for i= 1:znum
                    i_z=1000+i; 
                    azs=0;
                    arr_zs={0};
                    it_z=0;
                    for p=1:posnum
                        str_position4dir=strcat('-P',num2str(p),'-*');
                        str_z4dir = strcat(str_FluorescentName,str_position4dir,'z',num2str(i_z),'*');
                            d_z=dir(str_z4dir);
                             ddz = [d_z(:).datenum].'; % you may want to eliminate . and .. first.
                            [ddz1,ddz2] = sort(ddz);
                            azs= {d_z(ddz2).name}; 
                            arr_zs{p}=azs;                              
                            arr_numfids(p) = max(ddz2); %number of figures per Zposition at a position
                    end;
                    Arr_Zs{i}=arr_zs;
                    nameZs=Arr_Zs;
                end;
                minfids=min(arr_numfids);
                valsZ={};
                vposZs={};
                for i=1:znum
                    for ii=1:posnum
                        Zs={};
                        for iii=1:minfids   
                            Zs{iii}=imread(Arr_Zs{i}{ii}{iii}); %{zposition}{Position}{time}
                        end;
                        vposZs{ii}=Zs;
                    end;
                    valsZ{i}=vposZs; %values by {Z}, {Pos}, {Time}
                end;
        % AI=valsZ{1}{1}{1};
        % BI=valsZ{2}{1}{1};
        % CI=valsZ{3}{1}{1};
        % I=AI+BI+CI; 
        cd(str_TemporaryData_str);
        cd('Z');
        str_cname=strcat(name,'-combine');
        mkdir(str_cname)

                 for ii=1:posnum
                     cd(Temp_str)
                     cd('Z')
                     cd(str_cname)
                     str_posnum=strcat('P',num2str(ii));
                     mkdir(str_posnum)
                     cd(str_posnum)

                    for iii=1:minfids
                        str_minfids=strcat('t',num2str(1000+iii));
                        str_I=strcat(str_posnum,'-',str_minfids,'.TIF');
                        AI=0;
                            for i=1:znum
                                AI=valsZ{i}{ii}{iii}+AI;
                            end;
                            arr_AI{iii}=AI;
                             imwrite(AI,str_I,'Compression','none','Resolution',1);%,'BitDepth',16);
        %                      imwrite(AI,nameZs{1}{1}{iii},'Compression','none','Resolution',1);%,'BitDepth',16);
                    end;
                    valsFL{ii}=arr_AI; %combined for {pos}{time}

                 end;

        %          s= struct('Andre',{'big','little'},'color','red','x',{3,4});
        %          %this is 

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%End Update for Z-Stacking                
        cd(exp_folder)
            %---------------- GFP
            %If GFPcheck is 1 if No DCF
            %GFPcheck is 0 if There is DCF a.k.a. GFP Imaged
            GFPcheck=isempty(dGFP);
            Ph2check=isempty(dPh2);
            TexRedcheck=isempty(dTexRed);
            arr_imagelen_min = (1:posnum);

            for i = 1:posnum
                abc=strcat('*-P',num2str(i),'-*');
                namePh2 =strcat('Ph2-P',num2str(i),'-*');
                nameTR = strcat('TexRed-P',num2str(i),'-*');
                nameGFP = strcat('GFP-P',num2str(i),'-*');
                arr_strPositionName{i}=abc;
                %--------Ph2---------
                ff=dir(namePh2);
                DD = [ff(:).datenum].'; % you may want to eliminate . and .. first.
                [DD,DD] = sort(DD);
                PH2{i} = {ff(DD).name}; % Cell array of names in order by datenum.
                %--------TexRed---------
                gg=dir(nameTR);
                EE = [gg(:).datenum].'; % you may want to eliminate . and .. first.
                [EE,EE] = sort(EE);
                TeRe{i} = {gg(EE).name}; % Cell array of names in order by datenum.  TeRe{Position}{TimeInterval
                %--------GFP---------
                hh=dir(nameGFP);
                HH = [hh(:).datenum].'; % you may want to eliminate . and .. first.
                [HH,HH] = sort(HH);
                Green{i} = {gg(HH).name}; % Cell array of names in order by datenum.  Green{Position}{TimeInterval

                arr_imagelen_min(i) = max(EE);
            end;

            %% -------Calculation of Loop Interval  (assumes same for all)---------------

         %%%%%%%%%%%%%%%%%%%%%%%Updated   2014-12-12   
                str_position4dir=strcat('-P',num2str(1),'-*');
                str_t1minfids=strcat('t',num2str(1000+1));
                str_t2minfids=strcat('t',num2str(1000+2));
                str_Pdir = strcat('PH2',str_position4dir,str_t1minfids,'*');
                str_t2dir = strcat('PH2',str_position4dir,str_t2minfids,'*');

                    name_t1=dir(str_Pdir);  
                    name_t2=dir(str_t2dir);
                    a_t=name_t1(1).name;
                    b_t=name_t2(1).name;
         %%%%%%%%%%%%%%%%%%%%%%%%    
           if znum > 1 
               boo_zstack=1; %yes z-stack
               display('yes z-stack')
               t_a = datenum(a_t(41:48),'HH-MM-SS');
               t_a_specific=PH2{1}{1}(34:48);
               t_b = datenum(b_t(41:48),'HH-MM-SS');
           else
               boo_zstack=0; %no z-stack
                t_a = datenum(a_t(31:38),'HH-MM-SS');
                %---time specific
                t_a_specific=PH2{1}{1}(24:38);
                t_b = datenum(b_t(31:38),'HH-MM-SS');
           end;
            td = t_b-t_a;

            ti_s = str2num(datestr(td,'SS')) / 60;  %seconds in fraction of minute
            ti_m = str2num(datestr(td,'MM')) ;      % minutes
            ti_h = str2num(datestr(td,'HH')) * 60 ; %hours in fractions of minutes
            ti_d = ti_s + ti_m + ti_h;%---Time Interval (min)

            timeinterval_string = strcat('Time Interval: ', num2str(ti_d),'(min)');
            %----------Time of Plating Folder Creation-------------
            %%---Creates Array with the Path Folder Names and Paths
            [PSTR,NAM,EXT] = fileparts(exp_folder);
            strfolder_check1 =strcmp(PSTR,str_RawData_str);
            i_nam=1;
            while strfolder_check1 ==0
                [PSTR,NAM,EXT] = fileparts(PSTR);
                Nam_ext{i_nam}=NAM;
                PSTR_ext{i_nam}=PSTR;  %save the pathnames
                strfolder_check1 =strcmp(PSTR,str_RawData_str);
                i_nam=i_nam +1;
            end;
            %%---Creates a string in which Folder Path is mimicked
            Rev_Name_ext=fliplr(Nam_ext); %fliplr flips order of array left to right
            Nam_ext_length = length(Nam_ext);
            temp_folder='';
            for i = 1:Nam_ext_length
                temp_spot=strcat(filesep,Rev_Name_ext(i));
                temp_folder=strcat(temp_folder,temp_spot);
            end;
            %%-concatenate the strings of plating and mimicked folder
            PlatingDataSave=strcat(str_Plating_str,temp_folder);
            %%-make a folder of the string
            mkdir(PlatingDataSave{:})
            %%-make it a string--unknown why---this is only way to read str
            PlatingDataSave_str=PlatingDataSave{:};

            %----------Time of Plating Check-------------
            %--Checks to see if file exists
            cd(PlatingDataSave_str);
            ok=dir(strcat(name,'*'));
            ok_boo = isempty(ok);
            %--If file exists create it, this assumes input is correct on first
            %try which is not perfect --will need to IMPROVE
            if ok_boo == 1; %--does not exist
                display(['Name: ', name,' --Postition 1 Iteration 1: ', t_a_specific])
                tplate = input(strcat('What was the time of Bead Plating "0" is default 30 min FORMAT(HH-MM)?'),'s');
                %--As a String
                %--if default "0" is selected it will assume a plating of 30
                %minutes which is not perfect--will need to IMPROVE
                if tplate =='0'
                    t_plate = 30;
                else
                    t_plate = timediff(tplate,a_t);
                end;
                save(name,'t_plate')
            else
                %--Load Current File
                ev = strcat(name,'.mat');
                load(ev)
                %If 'Plating_Password' exists then the plating is correct
                if exist('Plating_Password','var')==1
                    display('Plating time will not change')
                elseif exist('Plating_Password','var')==0
                    display(['Current t_plate: ',num2str(t_plate), ' minutes'])
                    %----Trouble shoots the current
                    tplate = input(strcat('Does current t_plate seem correct ',t_plate,' y/n?'),'s'); %--As a String
                    %--if default "0" is selected it will assume a plating of 30
                    %minutes which is not perfect--will need to IMPROVE
                    if tplate =='y'

                    else
                        display(['Name: ', name,' --Postition 1 Iteration 1: ', t_a_specific])
                        tplate = input(strcat('What was the time of Injury "0" is default 30 min FORMAT(HH-MM)?'),'s');
                        %--As a String
                        %--if default "0" is selected it will assume a plating of 30
                        %minutes which is not perfect--will need to IMPROVE
                        if tplate =='0'
                            t_plate = 30;
                        else
                            t_plate = timediff(tplate,a_t);
                        end;
                    end;
                    Plating_confident= input(strcat('Are You confident on Plating Time', t_plate,' y/n?'),'s'); %--As
                    if Plating_confident=='y'
                        Plating_Password=1;
                        save(name,'t_plate','Plating_Password')
                    else
                        save(name,'t_plate')
                    end;
                end;
            end;
            %%----Arbitary Naming -- i.e. Testing
            name_len = length(name);
            name_alt = name(12:name_len);
            name_string = genvarname(name(12:name_len)); %DO NOT DELETE USED IN CODE

            %     eval(sprintf('%s=%s',name_string,t_plate));
            %%% SAVE THIS NAME
            PlatingDataSave_str=PlatingDataSave{:};

            %%---------Read Ph2 & TexasRed Directory
            % cd(dPh2.name);
            % dPh2=dir('*.tif');
            arr_numfids = arr_imagelen_min;  %----note this is an array with respective lengths
            %numfidsPH = numel(dPh2); %number of tif files in folder
            valsPhaseContrast  = cell(1,arr_numfids);
            valsPH2 = cell(1,posnum);
            valsTR  = cell(1,posnum);
            valsTexasRed = cell(1,arr_numfids);
            %Green
            valsGFP = cell(1,posnum);
            valsGreen = cell(1,arr_numfids);
            %%--Reads the grayscale/color image from the file specified by
            %%the string FILENAME.  REteruns value in an array containing the
            %%image data
            for J = 1:posnum
                for j = 1:arr_numfids(J)
                    valsPhaseContrast{j}= imread(PH2{J}{j});
                    valsTexasRed{j} = imread(TeRe{J}{j});
                    disp([num2str(100*j/(arr_numfids(J)),'%2.1f') ' % Ph2_' num2str(j) ' / ' num2str(arr_numfids(J)) ' ' num2str(J) ' out ' num2str(posnum) ' ' num2str(100*J/(posnum),'%2.1f')]);
                end;
                valsPH2{J}= valsPhaseContrast;
                valsTR{J}=  valsTexasRed;
            end;
            %%%If there is GFP detected we wil read them and place them in an array
            if GFPcheck==0
                %Green
                valsGFP = cell(1,posnum);
                valsGreen = cell(1,arr_numfids);
                for J = 1:posnum
                    for j = 1:arr_numfids(J)
                        valsGreen{j}=imread(Green{J}{j});
                        disp([num2str(100*j/(arr_numfids(J)),'%2.1f') ' % GFP_' num2str(j) ' / ' num2str(arr_numfids(J)) ' ' num2str(J) ' out ' num2str(posnum) ' ' num2str(100*J/(posnum),'%2.1f')]);
                    end;
                end;
                valsGFP{J}= valsGreen;
            end;
            input_30minit=input('Should I only do 30 minute Iterations? y/n','s');
    end;
else
    display('You are keeping all old variables, pepare to save "-append"')
    %         cd(TemporaryData_str)
    %         load(strcat(name,'.mat'),'Values')
end;
%%  Parameter Setting
Stretchy(1)=2; %2.5, 3,3.5
Fudgy(1)=0.25;  % 0.2, 0.25,0 .3,0.35, 0.4, 0.45
cn_average=3000;
masky='compile';
display(['Number of Positions: ',num2str(posnum)])
input_Kposition=input('What position would you like to start from?');
arr_numerical=(1:100);
if input_16bit=='C'
    if parts==2
    min_arr_numfid=numfids(1);
    elseif parts==3
        min_arr_numfid=numfids(1);%+numfids(2);
    else
         min_arr_numfid=numfids(1);
    end;
    arr_numfids=ones(1,posnum)*min_arr_numfid;   
    t_plate=30;
    ti_d=1;
    valsGFP=Arr_GFP{1};
    valsPH2=Arr_Ph2{1};
    name_string=name;
else
    min_arr_numfids=min(arr_numfids);
    display(arr_numfids);
end;

arr_timeT=(t_plate:ti_d:(ti_d*arr_numfids(1)+t_plate)-ti_d); %%this is an array of all the times (1:numfids)
display(arr_timeT)        
input_kframe=input('What FRAME would you like to start processing with? ');
II=0; %This Is The K Frame Contingency Iteration Count ***

%%   
for K = input_Kposition:posnum

    ImgSum=arr_numfids(K);
    disp(arr_strPositionName{K})
    disp(strcat('There are:  ',' ',num2str(ImgSum), ' Total Frames'))
    close all
    if GFPcheck==0
        valsMask=valsGFP;
    elseif  GFPcheck==1
        valsMask=valsTR;
    else
        display('Assumed nuc-cherry')
        valsMask=valsTR;
    end;
    GREENFolder=strcat(num2str(K),' GFP');
    mkdir(GREENFolder)
    cd(GREENFolder)
    dir_GREEN=cd;
    boo_beadignore=0;
    ii=0;%this is the iteration count******************************
    boo_skipKframe=0; %--Resetting 
    for k = input_kframe:ImgSum
        %% Prepping Images and Digital Processing Fundamentals
        %PhaseContras imadjust
        ii=ii+1; %this is the iteration count******************************
        if input_16bit=='C'
            cd                    (dir_BF)
            Fish = imread(valsPH2{K}{k});
            cd                    (dir_GFP)
            Mpeg = imread(valsMask{K}{k}{3});
             cd                   (dir_GREEN)
        else
            Fish = valsPH2{K}{k};
            Mpeg = valsMask{K}{k};
        end; 
        background_sandy = imopen(Fish,strel('disk',15));
        Fish = Fish - background_sandy;        
        Sandy_Inew = imadjust(Fish, stretchlim(Fish), []);
        %Floursecent imadjust
       
        background_bloody = imopen(Mpeg,strel('disk',15));
        Bloody_background = Mpeg - background_bloody;
        %---Introduce greater Image Contrast
        InewB = imadjust(Mpeg, stretchlim(Mpeg), []);
        Bloodynew=InewB;
        InewB_background = imadjust(Bloody_background, stretchlim(Bloody_background), []);
        Bloody2=InewB_background;
        %---For Plotting
        line_img=(1:512);
                %%--- Added (09/24/2014)
        arr_timeT=(t_plate:ti_d:(ti_d*arr_numfids(K)+t_plate)-ti_d); %%this is an array of all the times (1:numfids)
        a=1;
        max_time=max(arr_timeT);
        min_time=min(arr_timeT);
        if max_time>119.99
            arr_ittle=[60,90,120];
        elseif max_time>89.99
            arr_ittle=[60,90];
        elseif max_time>59.99 && min_time<29.99
            arr_ittle=[30,60];
        elseif max_time<59.99 && min_time<29.99
            arr_ittle=[30];  %#ok<NBRAK>
        elseif max_time<59.33 && min_time>30
            arr_ittle=[35];  %#ok<NBRAK>
        else
            display('what the frackers')
            arr_ittle=[max_time-1 ];  %#ok<NBRAK>
        end;
        %%Searches for only 30 minute intervals
        for i=arr_ittle
            b=0;
            TT=0;
            while TT<=i
                b=b+1;
                TT=arr_timeT(b);
            end;
            arr_T(a)=b;
            a=a+1;
        end;
        %%Array of initial, 30 min intervals, and Final Interval
        arr_TT=[2,arr_T,arr_numfids(K)];
        clear arrayT
        %% ---Conduct Cell Outlines and Intensity outlines
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
            FudgeFactor_high=FudgeFactor_low+0.05;
            %%Overlay Image Segout                  
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
            bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;
            %%-Show some figures
            figure();whitebg('white');imshow(color_delete);title('Objects in Blue are structures selected for deletion');
%             figure();imshow(~bw_normaledges);
%             figure();imshow(bw_MPEG_low);title('Low'); 
%             figure();imshow(bw_MPEG_high);title('High');colordef black               
            bw_empty=false(size(bw_MPEG_low));
                %thicken the low threshold to see the differnce, hence bw2
                bw2_MPEG_low = bwmorph(bw_MPEG_low,'thicken');
                bw2_MPEG_high= bwmorph(bw_MPEG_high,'thicken',5);
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
                color_bw_MPEG_low=imoverlay(Sandy_Inew,bw2_MPEG_low,[0 0 1]); %turn objects blue
                color_perim_low=imoverlay(color_bw_MPEG_low,bwperim(bw2_MPEG_low),[1 1 0]);  %outline in yellow          
                color_bw_MPEG_high=imoverlay(bw_empty,bw_MPEG_high,[0 1 0]);%turn objects green
                color_perim_high=imoverlay(color_bw_MPEG_high,bwperim(bw_MPEG_high),[1 1 0]);  %outline in yellow 
            bw_color_realsegout=imoverlay(color_bw_MPEG_low,bw_MPEG_high,[1 0 0]);%high is red
%                 figure();imshow(color_bw_MPEG_low);title('color bw MPEG low')
%                 figure();imshow(color_perim_low);title('color perim low')
%                 figure();imshow(color_bw_MPEG_high);title('color bw MPEG high')
%                 figure();imshow(color_perim_high);title('color perim high')
            figure();imshow(bw_color_MPEG);title('bw color MPEG')
            figure();imshow(bw_color_segout);title('ZebraFish Caudal Fin Segout');
%             close all        
        %%  Crop into Regions  ------------------------------------------
        %10x -1 pixel = 1.55 um
        %40x -1 pixel = 0.387um
        %63x -1 pixel = 0.2444 um
            str_spine='Spine';
            str_endwoundsite='Wound Site';
            str_region1='Region 2';
            str_region2='Region 3';
            display('Select Edge of wound-boundary between fish and open water Location ')
            [x_edge,y_edge,I_edge,Rect_edge]=imcrop(Sandy_Inew); %Edge
            display('Find the spine location')
            [x_spine,y_spine,I_spine,Rect_spine]=imcrop(Sandy_Inew); %Spine
            input_axis=input('Is the tail along x, y or s (slanted axis)? ','s');
            if input_axis =='x' %horizontal
                if Rect_spine(1)>Rect_edge(1)
                    %Wound left most side (0)on x axis
                    str_wound='Wound On the Left  <--';
                    add_wound=40;
                    add_region=100; 
                    add_text=-80;                   
                    X=Rect_spine(1)+add_wound;   
                    X2=X+add_region;
                    X3=X2+add_region; %unused
                    Rect=[0,0,X,512];
                    Rect_r1=[X,0,add_region,512];
                    Rect_r2=[X2,0,add_region,512];
                    Rect_r3=[X3,0,add_region,512]; %unused
                      x_r=Rect(1);
%                     x_r1=Rect_r1(1)+add_region;
%                     x_r2=Rect_r2(1)+add_region;                                    
                else
                    %Wound right most side(512) on x axis
                    str_wound='WoundOn the Right  -->';
                    add_wound=-40;
                    add_region=-100;
                    add_text=80;
                    X=Rect_spine(1)+add_wound;   
                    X2=X+add_region;
                    X3=X2+add_region; %unused
                    X4=X3+add_region; %unused
                    Rect=[X,0,(512-X),512];
                    Rect_r1=[X2,0,abs(add_region),512];
                    Rect_r2=[X3,0,abs(add_region),512];
                    Rect_r3=[X4,0,abs(add_region),512];
                end; 
                str_figurefinalktitle=strcat(name,'| ',str_wound);
                figure();set(gcf,'Name',str_figurefinalktitle);imshow(bw_color_segout); hold on
                title(str_wound);colordef black  
                plot(Rect(1),line_img,'r--')%--Wound Region
                text(Rect(1)+10,475,str_endwoundsite,'Color','red',...
                    'FontSize',8,'FontWeight','bold');                
                plot(Rect_r1(1),line_img,'k--')%--Region 1
                text(Rect_r1(1)+10,475,str_region1,'Color','green',...
                    'FontSize',8,'FontWeight','bold');                      
                plot(Rect_r2(1),line_img,'k--')%--Region 2
                text(Rect_r2(1)+10,475,str_region2,'Color','green',...
                    'FontSize',8,'FontWeight','bold');  
                plot(Rect_r3(1),line_img,'k--')%--Region 2
            elseif input_axis =='y' %vertical
                if Rect_spine(2)>Rect_edge(2)
                   %Wound Top most side(0) on y axis
                    str_wound='Wound is on the Top  ^';
                    add_wound=40;
                    add_region=100;
                    add_text=-75;                   
                    Y=Rect_spine(2)+add_wound;   
                    Y2=Y+add_region;
                    Y3=Y2+add_region; %unused
                    Rect=[0,0,512,Y];
                    Rect_r1=[0,Y,512,add_region];
                    Rect_r2=[0,Y2,512,add_region];
                    Rect_r3=[0,Y3,512,add_region]; %unused                   
                else
                    %Wound Bottom most side(512) on y axis
                    str_wound='Wound On the Bottom V ';                    
                    add_wound=-40;
                    add_region=-100;
                    add_text=+75;
                    Y=Rect_spine(2)+add_wound;   
                    Y2=Y+add_region;
                    Y3=Y2+add_region; %unused
                    Y4=Y3+add_region; %unused
                    Rect=[0,Y,512,(512-Y)];
                    Rect_r1=[0,Y2,512,abs(add_region)];
                    Rect_r2=[0,Y3,512,abs(add_region)];
                    Rect_r3=[0,Y4,512,abs(add_region)];
                end;                
                str_figurefinalktitle=strcat(name,'| ',str_wound);
                figure(k);set(gcf,'Name',str_figurefinalktitle);imshow(bw_color_segout); hold on
                title(str_wound);
                plot(line_img,Rect(2),'r--')%--Wound Region
                text(50,Rect(2)+10,str_endwoundsite,'Color','red',...
                    'FontSize',8,'FontWeight','bold');                
                plot(line_img,Rect_r1(2),'k--')%--Region 1
                text(50,Rect_r1(2)+10,str_region1,'Color','black',...
                    'FontSize',8,'FontWeight','bold');                      
                plot(line_img,Rect_r2(2),'k--')%--Region 2
                text(50,Rect_r2(2)+10,str_region2,'Color','black',...
                    'FontSize',8,'FontWeight','bold');
                plot(line_img,Rect_r3(2),'k-')%--Region 3
            elseif input_axis =='s'
                display('Do Cropping Manually--wont make too none of a difference though')
                display('Select the end of the wound site')
                [x,y,I_woundregion,Rect]=imcrop(bw_color_realsegout); %wound region
                    Rect_r1=[0,Y,512,add_region];  %erroneous
                    Rect_r2=[0,Y2,512,add_region]; %erroneous
                    Rect_r3=[0,Y3,512,add_region]; %unused 
            else
                display('Do Cropping Manually--wont make too none of a difference though')
                display('Select the end of the wound site')
                [x,y,I_woundregion,Rect]=imcrop(bw_color_realsegout); %wound region
                    Rect_r1=[0,Y,512,add_region];  %erroneous
                    Rect_r2=[0,Y2,512,add_region]; %erroneous
                    Rect_r3=[0,Y3,512,add_region]; %unused 
            end;
        else
            %%--if k does NOT equal 1
            %%--ASSUMPTION the first value is ran%%%%%%%%%%%%%%%%%%%%%%%%
            [bw_normaledges,bw_blockimg_I,bw_blockimg_II,bw_blockimg_III]=BlockProcessing(Fish);  
            bw1_MPEG_low = im2bw(Mpeg,FudgeFactor_low);
                            bw1_MPEG_low=bwareaopen(bw1_MPEG_low,10);
            bw1_MPEG_high = im2bw(Mpeg,FudgeFactor_high);
                            bw1_MPEG_high=bwareaopen(bw1_MPEG_high,10);
            bw_MPEG_low=~dilatebw_delete & bw1_MPEG_low;
            bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;      
            bw2_MPEG_low = bwmorph(bw_MPEG_low,'thicken');
            bw2_MPEG_high= bwmorph(bw_MPEG_high,'thicken',5);
%             bw3_diff= ~bw2_MPEG_high & bw2_MPEG_low;  
            bw_diff=~bw2_MPEG_high & bw_MPEG_low; % bw_compilebead_e=bwareaopen(bw_compilebead,30);   
            bw2_diff = bwmorph(bw_diff,'thicken');
            [bw_color_MPEG,bw_color_segout,bw_color_realsegout ] = MP_ZebrafishImg( bw_MPEG_high,bw2_MPEG_low,bw_normaledges,Sandy_Inew );

        end;  %%-- k=1 end   
         %% Image Sectioning
         %%-Macrophage Counting
        I_wound_total=imcrop(bw_MPEG_low,Rect);
            cc_total=bwconncomp(I_wound_total);
            stats_t=regionprops(cc_total,'basic'); 
            area_t=[stats_t.Area];
%             centroid_t = stats_t(1).Centroid;%%Errors when "0" NumObjects
        I_wound_high=imcrop(bw_MPEG_high,Rect);
        I_wound_diff=imcrop(bw_diff,Rect);
        I2_wound_diff=imcrop(bw2_diff,Rect);%%--Note the bw2diff --unused
        I_r1_high=imcrop(bw_MPEG_high,Rect_r1);
        I_r1_diff=imcrop(bw2_diff,Rect_r1);%%--Note the bw2_diff Used*
        I_r2_high=imcrop(bw_MPEG_high,Rect_r2);
        I_r2_diff=imcrop(bw2_diff,Rect_r2);%%--Note the bw2_diff Used*
        %%test function "imfuse";
        I_fused=imfuse(I_wound_high,I_r1_high); %%boo boo only overlays over one another
        %%Macrophage counting
        count_wound= Mp_Count( I_wound_high,I_wound_diff );
        [ count_r1,count_r1diff ]= Mp_Count( I_r1_high,I_r1_diff );
        [ count_r2,count_r2diff ]= Mp_Count( I_r2_high,I_r2_diff );  
        count_totalregions=count_wound+count_r1+count_r2;
        %% SaveArrays
        var_ktime=arr_timeT(k);
        %--Time Arrays
        arr_timeframe(ii)=var_ktime;
        %--Count Arrays
        arr_mpwoundcount(ii)=count_wound;    
        arr_mpr1count(ii)=count_r1;
        arr_mpr2count(ii)=count_r2;
        %--Position Arrays
        arr_rect{ii}=Rect;
        %--Image Arrays
        arr_colorseg{ii}=bw_color_segout;
        arr_colorrealseg{ii}=bw_color_realsegout;
        arr_bwmpeghigh{ii}=bw_MPEG_high;
        arr_bwmpegdiff{ii}=bw2_diff;
        %% Contingency Variables
        ax_wound=(ones(1,512)*Rect(3)); %Rect Wound
        ax_r1=(ones(1,512)*Rect_r1(3)); %Rect Region 1
        ax_r2=(ones(1,512)*Rect_r2(3)); %Rect Region 1  
        str_woundcount=strcat('Wound Count: ',num2str(count_wound),'|@Time:',num2str(var_ktime));
        str_woundcountY=strcat('Wound Count: ',num2str(count_wound));
        str_r1count=strcat('Count: ',num2str(count_r1));
        str_r2count=strcat('Count: ',num2str(count_r2));
        str_totalcount=strcat(' Total Region Count: ',num2str(count_totalregions),'|@Time:',num2str(var_ktime));
        line_img=(1:512);
        str_figurefinalktitle=strcat(name,'Frame: ',num2str(k),'| ',str_wound);    
    %% ---------------------Contingency Count %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %This is to make every 5 checked for Contingency and also for
       %tail movement
       str_button=strcat('Should I skip This K Frame: ',num2str(K));
       arr_factorof5=(input_kframe:5:arr_numfids(K));
       boo_factorof5=ismember(5,factor(k));
       if boo_factorof5==1;
           boo_beadignore=0;
       end;
        %-Contingency Loop    
        if boo_beadignore==0
            if k~=input_kframe %if k~= first frame interation
                k_1=k-1;
                contingency_arr_mpwoundcount=arr_mpwoundcount; %
                left = contingency_arr_mpwoundcount(k_1) - (1/5)*contingency_arr_mpwoundcount(k_1); % if it deviates by 25% than it puts it in check.
                right = contingency_arr_mpwoundcount(k_1) + (1/5)*contingency_arr_mpwoundcount(k_1);
                kk=1;    
                %fliplr will flip matrix left to right
                %flipud will flip matrix up and down
                disp([num2str(k) ' / ' num2str(ImgSum) '_BW_' num2str(100*k/(ImgSum),'%2.1f') ' %...Macrophage Count:' num2str(fliplr(arr_mpwoundcount))  ]); % Latest Update Comes first
                while (left >= contingency_arr_mpwoundcount(k)) || (contingency_arr_mpwoundcount(k)>= right)  
                  
                    str_figuretitle=strcat(name_string,'Mp Wount Count Contingency');
                    figure(200+kk); whitebg('m');set(gcf,'Name',str_figuretitle);
                    imshow(bw_color_segout);title(str_woundcount,'Fontsize',14); hold on
                    if input_axis =='x'
                        plot(Rect(1),line_img,'r--')%--Wound Region 
                        plot(Rect_r1(1),line_img,'g--')%--Region 1
%                         text(Rect(1)+10,475,str_endwoundsite,'Color','red',...
%                             'FontSize',14,'FontWeight','bold');      
%                         text(Rect(1)+10,460,str_woundcount,'Color','blue',...
%                             'FontSize',14,'FontWeight','bold');   
                    elseif input_axis =='y'
                        plot(line_img,Rect(2),'r--')%--Wound Region
                        plot(line_img,Rect_r1(2),'g--')%--Region 1
%                         text(50,Rect(2)+10,str_endwoundsite,'Color','red',...
%                             'FontSize',14,'FontWeight','bold');       
%                         text(50,Rect(2)+25,str_woundcount,'Color','blue',...
%                             'FontSize',14,'FontWeight','bold'); 
                    end;
                    input_satisfied4bead=input('What do you want to do |"f" fix "m" manual, "p" previouscount, "s" new fudge factor or Satisfied (y/n)','s');
                    if input_satisfied4bead=='m'
                        input_tbc =input('What is the total bead count');
                        arr_mpwoundcount(k) =input_tbc;
                    elseif input_satisfied4bead=='p'
                        arr_mpwoundcount(k) =arr_mpwoundcount(k-1);
                    elseif input_satisfied4bead=='s'
                        input_FudgeSatisfaction='n';
                        fudgefactor=graythresh(Mpeg);
                        while_it=0;
                        arr_fudge=0; %to clear varible /not sure if it will work
                        b_fudge=0.001;
                        b_multiple=1;
                        while input_FudgeSatisfaction~='y'
                            while_it=while_it+1;
                            bw_while_segmentation = im2bw(Mpeg,fudgefactor);
                            figure(while_it+1000);whitebg('y');imshow(bw_while_segmentation);title(strcat('Frame: ',num2str(while_it),'|FudgeFactor: ',num2str(fudgefactor)));
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
                        FudgeFactor_high=FudgeFactor_low+0.001;
                        
                        bw1_MPEG_low = im2bw(Mpeg,FudgeFactor_low);
                        bw1_MPEG_high = im2bw(Mpeg,FudgeFactor_high);
                        
                        figure();whitebg('c');imshow(bw1_MPEG_low);title('Please Select the Indigenous Fluorescent structures you wish to not include in Mp Counting');
                        [x,y,bw_delete,idx,xi,yi] =bwselect();
                        color_delete=imoverlay(bw1_MPEG_low,bw_delete,[0 0 1]); %turn objects blue
                        close();
                        se=strel('line',6,0);
                        se2=strel('line',10,90);
                        dilatebw_delete=imdilate(bw_delete,[se se2]);
                        bw2_delete = bwmorph(bw_delete,'thicken');
                        bw_MPEG_low=~dilatebw_delete & bw1_MPEG_low;
                        bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;
                        bw_MPEG_low=~dilatebw_delete & bw1_MPEG_low;
                        bw_MPEG_high=~dilatebw_delete & bw1_MPEG_high;      
                        bw2_MPEG_low = bwmorph(bw_MPEG_low,'thicken');
                        bw2_MPEG_high= bwmorph(bw_MPEG_high,'thicken',5);
            %             bw3_diff= ~bw2_MPEG_high & bw2_MPEG_low;  
                        bw_diff=~bw2_MPEG_high & bw_MPEG_low; % bw_compilebead_e=bwareaopen(bw_compilebead,30);   
                        bw2_diff = bwmorph(bw_diff,'thicken');
                        I_wound_high=imcrop(bw_MPEG_high,Rect);
                        I_wound_diff=imcrop(bw_diff,Rect);        
                        input_tbc= Mp_Count( I_wound_high,I_wound_diff );
                        display(strcat('Count is changed from [',num2str(count_wound),'] to: ',num2str(input_tbc)));
                        arr_mpwoundcount(k)=input_tbc;
                    elseif input_satisfied4bead=='y'
                        disp(['content with TotalBeadCount:',num2str(arr_mpwoundcount(k))])
                        break
                    elseif input_satisfied4bead=='f'
                        input_f=input('How many postions back (1=1back');
                        input_tbc =input('What is the total bead count at that positon');
                        display(strcat('Count is changed from [',num2str(arr_mpwoundcount(k-input_f)),'] to: ',num2str(input_tbc)));
                        arr_mpwoundcount(k-input_f)=input_tbc;
                    elseif input_satisfied4bead=='i'
                        boo_beadignore=1; 
                        break
                    elseif input_satisfied4bead=='K'
                        boo_skipKframe=ButtonYorN(str_button);
                        break
                    elseif input_satisfied4bead=='rect'
                        display('Find the spine location')
                        [x_spine,y_spine,I_spine,Rect_testspine]=imcrop(Sandy_Inew); %Spine
                        if input_axis =='x' %horizontal
                            if Rect_spine(1)>Rect_edge(1)
                                %Wound left most side (0)on x axis
                                str_wound='Wound On the Left  <--';
                                add_wound=40;
                                add_region=100; 
                                add_text=-80;                   
                                X=Rect_testspine(1)+add_wound;   
                                X2=X+add_region;
                                X3=X2+add_region; %unused
                                Rect_test=[0,0,X,512];
                                Rect_testr1=[X,0,add_region,512];
                                Rect_testr2=[X2,0,add_region,512];
                                Rect_testr3=[X3,0,add_region,512]; %unused
                                  x_r=Rect(1);
            %                     x_r1=Rect_r1(1)+add_region;
            %                     x_r2=Rect_r2(1)+add_region;                                    
                            else
                                %Wound right most side(512) on x axis
                                str_wound='WoundOn the Right  -->';
                                add_wound=-40;
                                add_region=-100;
                                add_text=80;
                                X=Rect_testspine(1)+add_wound;   
                                X2=X+add_region;
                                X3=X2+add_region; %unused
                                X4=X3+add_region; %unused
                                Rect_test=[X,0,(512-X),512];
                                Rect_testr1=[X2,0,abs(add_region),512];
                                Rect_testr2=[X3,0,abs(add_region),512];
                                Rect_testr3=[X4,0,abs(add_region),512];
                            end;
                        elseif input_axis =='y'
                            if Rect_spine(2)>Rect_edge(2)
                               %Wound Top most side(0) on y axis
                                str_wound='Wound is on the Top  ^';
                                add_wound=40;
                                add_region=100;
                                add_text=-75;                   
                                Y=Rect_testspine(2)+add_wound;   
                                Y2=Y+add_region;
                                Y3=Y2+add_region; %unused
                                Rect_test=[0,0,512,Y];
                                Rect_testr1=[0,Y,512,add_region];
                                Rect_testr2=[0,Y2,512,add_region];
                                Rect_testr3=[0,Y3,512,add_region]; %unused                   
                            else
                                %Wound Bottom most side(512) on y axis
                                str_wound='Wound On the Bottom V ';                    
                                add_wound=-40;
                                add_region=-100;
                                add_text=+75;
                                Y=Rect_testspine(2)+add_wound;   
                                Y2=Y+add_region;
                                Y3=Y2+add_region; %unused
                                Y4=Y3+add_region; %unused
                                Rect_test=[0,Y,512,(512-Y)];
                                Rect_testr1=[0,Y2,512,abs(add_region)];
                                Rect_testr2=[0,Y3,512,abs(add_region)];
                                Rect_testr3=[0,Y4,512,abs(add_region)];
                            end;  
                        end;

                        figure(100+k);whitebg('w');set(gcf,'Name',str_figurefinalktitle);imshow(bw_color_realsegout);hold on
                        title('Is color Yellow more accurate','Fontsize',14);colordef black
                        plot(Rect_spine(1),Rect_spine(2),'g*',...
                            'LineWidth',5);  
                        plot(Rect_testspine(1),Rect_testspine(2),'y*',...
                            'LineWidth',5);   
                        input_newspineloc=input('Prefer new (yellow) Spine Location y/n ? ','s');
                        if input_newspineloc=='y'
                            Rect=Rect_test;
                            Rect_r1=Rect_testr1;
                            Rect_r2=Rect_testr2;
                            Rect_r3=Rect_testr3;
                            I_wound_high=imcrop(bw_MPEG_high,Rect);
                            I_wound_diff=imcrop(bw_diff,Rect);        
                            input_tbc= Mp_Count( I_wound_high,I_wound_diff );
                            display(strcat('Count is changed from [',num2str(count_wound),'] to: ',num2str(input_tbc)));
                            arr_mpwoundcount(k)=input_tbc;
                        else
                            display('Spine Location will Remain the same');
                            
                        end;
                        continue
                    else
                        disp('Did not select designated inputs')
                        continue                        
                    end;
                    kk=kk+1;                    
                end;
            else
                disp('Ignoring Contingency Count')
            end;
        elseif boo_beadignore==1;
            disp('Ignoring Contingency Count')     
        end;
        
        %% Figure
% %         plot(ax_wound,line_img,'r--')%(vertical line)
% %         plot(line_img,ax_wound,'r--')%(horizontal line)
    
%         if input_axis =='x'
% 
%                 figure(100+k);set(gcf,'Name',str_figurefinalktitle);imshow(bw_color_segout); hold on
%                 title(str_wound,'Fontsize',14);
%                 plot(Rect(1),line_img,'r--')%--Wound Region
%                 text(Rect(1)+10,475,str_endwoundsite,'Color','red',...
%                     'FontSize',14,'FontWeight','bold');      
%                 text(Rect(1)+10,460,str_woundcount,'Color','blue',...
%                     'FontSize',14,'FontWeight','bold');      
%                 plot(Rect_r1(1),line_img,'k--')%--Region 1
%                 text(Rect_r1(1)+10,475,str_region1,'Color','green',...
%                     'FontSize',14,'FontWeight','bold');  
%                 text(Rect_r1(1)+10,460,str_r1count,'Color','blue',...
%                     'FontSize',14,'FontWeight','bold');   
%                 plot(Rect_r2(1),line_img,'k--')%--Region 2
%                 text(Rect_r2(1)+10,475,str_region2,'Color','green',...
%                     'FontSize',14,'FontWeight','bold');  
%                 text(Rect_r2(1)+10,460,str_r2count,'Color','blue',...
%                     'FontSize',14,'FontWeight','bold');   
%                 plot(Rect_r3(1),line_img,'k--')%--Region 2         
%         elseif input_axis =='y'

                figure(100+k);whitebg('w');set(gcf,'Name',str_figurefinalktitle);imshow(bw_color_segout); hold on
                title(str_totalcount,'Fontsize',14);
                plot(line_img,Rect(2),'r--')%--Wound Region
                text(15,Rect(2)+10,str_endwoundsite,'Color','red',...
                    'FontSize',14,'FontWeight','bold');       
                text(15,Rect(2)+25,str_woundcountY,'Color','blue',...
                    'FontSize',14,'FontWeight','bold'); 
                plot(line_img,Rect_r1(2),'k--')%--Region 1
                text(15,Rect_r1(2)+10,str_region1,'Color','black',...
                    'FontSize',14,'FontWeight','bold');    
                text(15,Rect_r1(2)+25,str_r1count,'Color','blue',...
                    'FontSize',14,'FontWeight','bold'); 
                plot(line_img,Rect_r2(2),'k--')%--Region 2
                text(15,Rect_r2(2)+10,str_region2,'Color','black',...
                    'FontSize',14,'FontWeight','bold');
                text(15,Rect_r2(2)+25,str_r2count,'Color','blue',...
                    'FontSize',14,'FontWeight','bold'); 
                plot(line_img,Rect_r3(2),'k-')%--Region 3
%         else
%             display('Slanted, therefore, NO IMAGE...YEAA BOIII')
%         end;
     disp(strcat(arr_strPositionName{K}, num2str(k), ' / ' ,num2str(ImgSum), '_BW_' ,num2str(100*k/(ImgSum)))) % Latest Update Comes first      
     close all
     
     if boo_skipKframe==1
         break
     else
     end;
     
    end; %%--end of "k" iterations
    %% Save Full Arrays 
    %--Contingency skipKfraome
     if boo_skipKframe==1
         if K==1
             II=0;%***
         else 
         end;
         clear arr_timeframe
         clear arr_time
         clear arr_mpwoundcount
         clear arr_mpr1count
         clear arr_mpr2count
         clear arr_rect
         clear arr_colorseg
         clear arr_colorrealseg
         clear arr_bwmpeghigh
         clear arr_bwmpegdiff
     else
        II=II+1; %***
        display(strcat('Saving Position:',num2str(K),'as array space:',...
            num2str(II),'**'))
        PosName=arr_strPositionName(K);
        Arr_strPosIncludedResp(II)=PosName;
    %%--Array FOr time
        jj=1;
        for JJ=arr_TT
            arr_time(jj)=arr_timeT(JJ);%%timeT has all the times.
            jj=jj+1;
        end;
        Arr_TimeFrameIteration{II}=arr_timeframe';    
        Arr_FrameIterations(II)=ii;
        Arr_Time30MinInterval{II}=arr_time';
        %--Count Arrays
        Arr_MPCountWound{II}=arr_mpwoundcount';
        Arr_MPCountR1{II}=arr_mpr1count';
        Arr_MPCountR2{II}=arr_mpr2count';
        %--PositionArrays
        Arr_Rect{II}=arr_rect;
        %--Image Arrays
        Arr_ColorSegout{II}=arr_colorseg;
        Arr_ColorRealSegout{II}=arr_colorrealseg;
        Arr_BW_high{II}=arr_bwmpeghigh;
        Arr_BW_diff{II}=arr_bwmpegdiff;

        %%%Privy the Value of Interest
        Arr_Values{II}=[Arr_MPCountWound{II},Arr_MPCountR1{II},Arr_MPCountR2{II}];
    %     Arr_Test{1}=[Arr_MPCountWound{1};Arr_MPCountR1{1};Arr_MPCountR2{1}];
        Arr_Values_2nd{II}=[Arr_ColorSegout{II},Arr_BW_high{II},Arr_Time30MinInterval{II}];         
 
     end;    

    %% Figure 
%         str_title=strcat(name,'Total Macrophage Retention in Wound Area Count');
%         figure(100+K);set(gcf,'Name',str_title);
%         title(str_title,'FontWeight','bold');hold on
%             plot(arr_mpwoundcount);
%         hleg=legend('Cell Count','location','Northwest');        
%         str_tit1=strcat(name,'Total Macrophage Retention in Region 1');
%         figure(200+K);set(gcf,'Name',str_tit1);
%         title(str_tit1,'FontWeight','bold');hold on
%             plot(arr_mpr1count);
%         hleg=legend('Cell Count','location','Northwest');          
%         str_tit2=strcat(name,'Total Macrophage Retention in Region 2');
%         figure(300+K);set(gcf,'Name',str_tit2);
%         title(str_tit2,'FontWeight','bold');hold on
%             plot(arr_mpr2count);
%         hleg=legend('Cell Count','location','Northwest');  
    %% Clear
    clear arr_mpwoundcount
    clear arr_mpr1count
    clear arr_mpr2count
    clear arr_rect
    clear arr_colorseg
    clear arr_colorrealseg
    clear arr_bwmpeghigh
    clear arr_bwmpegdiff
    
end;%%--end of "K" iterations

Arr_Values=[Arr_MPCountWound,Arr_MPCountR1,Arr_MPCountR2];
%% End of For/ Start of Laser Parameters
% arr_timeT=(t_plate:ti_d:(ti_d*arr_numfids(K)+t_plate)-ti_d); %%this is an array of all the times (1:numfids)
timeT=(t_plate:ti_d:(ti_d*arr_numfids(K)+t_plate)-ti_d);
display(name)
y_tplate =(0:29);
x_tplate = ones(30)*t_plate;
z_y=(0:29);
z_x=zeros(30);
xmin=0;
xmax=200;
ymin=0;
ymax=200;
input_lazpam=input('Are there laser parameters: y/n','s');
if input_lazpam=='y'
    %% Start of Laser
    laser_par=40;
    it=1;
    kev=1;
    clear temp_laserName
    clear LaserSorted_arr
    clear input_laserparameter_num
    clear input_laserparameter_str
    clear arr_concat
    %%%Creates Array of 1) Str Position Name 2) Laser Parameters sorted
    for i=1:II
        PosName=arr_strPositionName(i);
        st_laserquestion=strcat('What laser parameter of ',PosName);
        disp(st_laserquestion)
        input_laserparameter_str=input('?','s');
        input_laserparameter_num=str2num(input_laserparameter_str);
        PositionName_adjusted(i)=strcat(PosName,' ',input_laserparameter_str);
        %%%New way of doing it
        temp_laserName(i)=double(input_laserparameter_num);
        if input_laserparameter_num ~= laser_par
            arr_concat=[Arr_MPCountWound{i}];
        else
        end;
        %%if conditional for arr_concat
        display('ok')
        if i==1
        else
            if input_laserparameter_num==temp_laserName(i-1)
                arr_concat=[arr_concat;Arr_MPCountWound{i}];
            else
                it=it+1;
            end;
        end;
        LaserSorted_arr_TR{it}=arr_concat;
        %%%Old way of doing it
        if input_laserparameter_num == laser_par;
        else
            av_PosName(kev)=PositionName_adjusted(i);
            kev=kev+1;
            laser_par=input_laserparameter_num;
        end;
    end;
    %%%Take Mean of Laser Arrays    
    for i=1:it
        mean_tb=mean(LaserSorted_arr_TR{i});
        mean_TR{i}=mean_tb';
        mean_tb=[arr_timeT',mean_tb'];
        graph_mean_TR{i}=mean_tb; %time first
        std_TR{i}=std(LaserSorted_arr_TR{i});
        if input_30minit == 'y'
            graph_timeT{i}=arr_time;
        else
            graph_timeT{i}=arr_timeT';
        end;
    end;    
    first = @(v) v(1);
    for i = 1:(it*2)
        if first(factor(i)) - 2
        else
            even=i/2;%---Counts 1,2,3,4
            D_TR{i}  = mean_TR{even};
            len_cn=length(Arr_Cell_Count{even});
            D_TR{i-1} = graph_timeT{even};
        end;
    end;
    str_tit=strcat(name,' Beads Per Cell with Error Bars');
    figure(1700);set(gcf,'Name',str_tit);
    title(str_tit,'FontWeight','bold'); hold on
    errorbar(graph_timeT{1},mean_TR{1},std_TR{1},'b')
    errorbar(graph_timeT{2},mean_TR{2},std_TR{2},'g')
    errorbar(graph_timeT{3},mean_TR{3},std_TR{3},'r')
    errorbar(graph_timeT{4},mean_TR{4},std_TR{4},'c.')
    hleg=legend(av_PosName,'location','Northwest');
    plot(x_tplate,y_tplate,'x','linewidth',1,'MarkerEdgeColor',[1,1,0]);
    plot(z_x,z_y,'x','MarkerEdgeColor',[0.5,0.5,0.5]);
    xlabel(timeinterval_string)
    axis([xmin xmax ymin 200])
    ylabel('Beads per Cell (abu)')
    
    str_tit=strcat(name,'Beads Per Cell Mean');
    figure(1710);set(gcf,'Name',str_tit);
    title(str_tit,'FontWeight','bold'); hold on
    plot(D_TR{:},'--.','linewidth',1.5);
    hleg=legend(av_PosName,'location','Northwest');
    plot(x_tplate,y_tplate,'x','linewidth',1,'MarkerEdgeColor',[1,1,0]);
    plot(z_x,z_y,'x','MarkerEdgeColor',[0.5,0.5,0.5]);
    xlabel(timeinterval_string)
    axis([xmin xmax ymin 200])
    ylabel('Intensity (abu)')
    
    
else
    %% Non Laser %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Region A --Updated 10/26/2014 --GOOD
    first = @(v) v(1);
    for i = 1:(II*2)
        if first(factor(i)) - 2
        else
            even=i/2;%---Counts 1,2,3,4
            D_TR{i}  = Arr_MPCountWound{even};
            %        len_cn=length(Cell_Count{even});
            if input_30minit=='y'
                D_TR{i-1}=arr_time;
            else
                D_TR{i-1} = (t_plate:ti_d:((ti_d*length(Arr_MPCountWound{even}))+t_plate-ti_d));%[1:numfids(even)]*ti_d + t_plate;
            end;
        end;
    end;
    str_tit=strcat(name,' Macrophages in Wound Region');
    figure(1700);whitebg('white');set(gcf,'Name',str_tit);
    title(str_tit,'FontSize',35,'FontWeight','bold'); hold on
    plot(D_TR{:},'linewidth',5);
    hleg=legend(Arr_strPosIncludedResp,'location','Northwest','FontSize',27);
    plot(x_tplate,y_tplate,'x','linewidth',1,'MarkerEdgeColor',[1,1,0]);
    plot(z_x,z_y,'x','MarkerEdgeColor',[0.5,0.5,0.5]);
    xlabel(timeinterval_string,'FontSize',27)
    %                axis([xmin xmax ymin ymax])
    ylabel('Intensity (abu)','FontSize',27)
    %End Region A
    %Region B----
    %%%%%%%%%%%%%%%%%%%% Export To Excell Purposes%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%Standard Deviation and Mean%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%Eventually Put P value%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if input_30minit~='y'
        display(Arr_strPosIncludedResp)
        input_bottompositionLimit=input('up to what position would you like to starty start to include? ');
        input_positionLimit=input('up to what position would you like to include? ');
            arr_data_wound=[Arr_MPCountWound{1}(1:min(Arr_FrameIterations))]; % total beads
            arr_data_region1=[Arr_MPCountR1{1}(1:min(Arr_FrameIterations))]; % total beads
%             arr_data_region1=[Arr_MPCountR1{1}(1:min(Arr_FrameIterations),2)]; %beads per cell**This does work**     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%Get Arrays of time points%%%%%%%%
        
        
        for i=1:input_positionLimit
            %--total beads
            one_bwound2=[Arr_MPCountWound{i}(1:min(Arr_FrameIterations))];
            arr_data_wound=[one_bwound2,arr_data_wound];
            %---beads per cell 
            one_bregion1T2=[Arr_MPCountR1{i}(1:min(Arr_FrameIterations))];% this value picks up the Cell intensity values only
            arr_data_region1=[one_bregion1T2,arr_data_region1];  
          
        end;
        %%%Need to fix 10/22/2014 ---"Index exceds matrix Dimentions"
        for i=1:length(arr_timeT)
            %--total  beads
            mean_tb=mean(arr_data_wound(i,input_bottompositionLimit:input_positionLimit));
            full_mean_Wound(i)=mean_tb;
            full_std_Wound(i)=std(arr_data_wound(i,input_bottompositionLimit:input_positionLimit));
            %---beads per cell
            mean_r1=mean(arr_data_region1(i,input_bottompositionLimit:input_positionLimit));
            full_mean_Region1(i)=mean_r1;
            full_std_Region1(i)=std(arr_data_region1(i,input_bottompositionLimit:input_positionLimit));            
        end;
        %---Macrophage in Wound
        Full_Wound_array=[arr_timeT;full_mean_Wound;full_std_Wound];
        %---Macrophage in Region 1
        Full_Region1_array=[arr_timeT;full_mean_Region1;full_std_Region1];     
        %--Cell Count
%         full_mean_InitialCellCount=mean(Arr_CellCount);
%         std_InitialCellCount=std(Arr_CellCount);
%         Full_InitialCellCount_array=[full_mean_InitialCellCount;std_InitialCellCount];
    end;
    
        Flipped_WOUND=Full_Wound_array';
        Flipped_REGION1=Full_Region1_array';
    %%%Graph 1 for Total Bead Count of Beads Internalized%%%%
        str_tit=strcat(name,'Wound Macrophage Count w/ Error Bars');
        figure(1800);set(gcf,'Name',str_tit);
        title(str_tit,'FontWeight','bold','FontSize',32); hold on
        errorbar(arr_timeT,full_mean_Wound,full_std_Wound,'b')
        %                               errorbar(graph_timeT{2},mean_TR{2},std_TR{2},'g')
        %                                              errorbar(graph_timeT{3},mean_TR{3},std_TR{3},'r')
        %                                                             errorbar(graph_timeT{4},mean_TR{4},std_TR{4},'c.')
        hleg=legend(name,'location','Northwest','FontSize',30);
        plot(x_tplate,y_tplate,'x','linewidth',3,'MarkerEdgeColor',[1,1,0]);
        plot(z_x,z_y,'x','MarkerEdgeColor',[0.5,0.5,0.5]);
        xlabel(timeinterval_string,'Fontsize',27)
%         axis([xmin xmax ymin 180])
        ylabel('Macrophages in Wound (abu)','Fontsize',27)
    %%%Graph 2 for Beads Per Cell%%%%%%%%%%%%
        str_tit=strcat(name,' Region 1 Macrophage Count w/Error Bars');
        figure(1801);set(gcf,'Name',str_tit);
        title(str_tit,'FontWeight','bold'); hold on
        errorbar(arr_timeT,full_mean_Region1,full_std_Region1,'r')
        hleg=legend(name,'location','Northwest');
        plot(x_tplate,y_tplate,'x','linewidth',1,'MarkerEdgeColor',[1,1,0]);
        plot(z_x,z_y,'x','MarkerEdgeColor',[0.5,0.5,0.5]);
        xlabel(timeinterval_string)
        %                 axis([xmin xmax ymin ymax])
        ylabel('Macrophages in Region 1 (abu)')
        axis([xmin xmax ymin 10])
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Excell Purpose%%%%%
end;

%% Save Main Values || Important Arrays-------------------

%concatenate the strings of plating and mimicked folder
SavingDataPartI=strcat(str_SavingPartI_str,temp_folder);
%make a folder of the string
mkdir(SavingDataPartI{:})
%make it a string--unknown why---this is only way to read str
str_SavingDataPartI_str=SavingDataPartI{:};

%----------Time of Plating Check-------------
%--Checks to see if file exists

%% Save Main Values || Important Arrays-------------------
%concatenate the strings of plating and mimicked folder
% input_save=input('Would you like to save? y/n','s');
if input_30minit~='y'
    %----------Time of Plating Check-------------
    %--Checks to see if file exists
    cd(str_SavingDataPartI_str);
    Values_str={'WoundCount','Region1Count','Region2Count'};
    second_Values_str={'Color_Segout','BW_high','Time'};
    save(name,'Values_str','Arr_Values','Arr_Values_2nd','second_Values_str','timeT','name') %saves the variables Values and Values_str only with folder replicated in raw data and name
    %remember to save
    save(name,'ti_d','-append')%time interval Number
%     save(name,'Arr_CellCount','-append')%beginnig cell count (empirical)
    %%%%
    if boo_desktop==1; %this is the desktop
        save(name,'str_SavingDataPartI_str','-append')
        save(name,'str_Plating_str','-append')
        SavingDataPartI_str=str_SavingDataPartI_str;
        Plating_str=str_Plating_str;
        save(name,'str_SavingDataPartI_str','-append')
        save(name,'Plating_str','-append')
    else
        save(name,'str_SavingDataPartI_str','-append')
        save(name,'str_Plating_str','-append')
    end;
    
    %%--NEED TO UPDATE!!!%%%%%%%%%%%
    if input_lazpam=='y'
        save(name,'graph_mean_TR','-append')%beginnig cell count (empirical)
        save(name,'std_TR','-append')%beginnig cell count (empirical)
        save(name,'PositionName_adjusted','-append')%beginnig cell count (empirical)
        save(name,'av_PosName','-append')%beginnig cell count (empirical)
    else
        display('Full')
        save(name,'Full_Wound_array','-append')%beginnig cell count (empirical)
        save(name,'Full_Region1_array','-append')%beginnig cell count (empirical)
%         save(name,'Full_Region2_array','-append')
    end;
    
elseif input_30minit=='y'
    display('****NOT Saving*********************')
    arr_data_wound=[arr_time'];
    
    for i=1:II
        if GFPcheck ==0
            one_bwound2=[Arr_Values{i}(:,2)];
            arr_data_region1=[one_bwound2,arr_data_region1];
        else
        end;
        one_bwound2=[Arr_Values{i}(:,1)];
        arr_data_wound=[one_bwound2,arr_data_wound];
    end;
    
    for i=1:length(arr_time)
        if GFPcheck ==0
            mean_mugG=mean(arr_data_region1(i,1:II));
            mean_GFP(i)=mean_mugG;
            std_GFP(i)=std(arr_data_region1(i,1:II));
        else
        end;
        mean_tb=mean(arr_data_wound(i,1:II));
        mean_TR(i)=mean_tb;
        std_TR(i)=std(arr_data_wound(i,1:II));
    end;
    
    if GFPcheck ==0
        BigGFP_array=[arr_time;mean_GFP;std_GFP];
    else
    end;
    BigTR_array=[arr_time;mean_TR;std_TR];
else
    display('Neither Y nor N...ERROR CHECK THIS SHIT')
end;
       
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%PREVIOUS WORKS - cell tracking * Unfinished
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%         elseif k==ImgSum
%             display('Last Image')
%         else
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
%         end;
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
%     end;
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
% end;
