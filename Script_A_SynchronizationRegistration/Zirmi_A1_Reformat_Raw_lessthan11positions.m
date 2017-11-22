%%%%%%%%%%%%%%%%%%%
%%%Created 2016-11-21name
%%% Directly exported data from confocal microscope
%%% Comment 2017-02-03 %% This is THE Script.
%%% Updated 2017-06~01 %% Corrected the T0 and T1 duplications for GFP&BF

input_clearall                  =   input('Should I clear all?  y/n || need "y" if first go ','s');

if input_clearall               ==  'y' 
    %% %%%%%%%%%%%%%%% Clear all if necessary
    clear                           all
    close                           all
    disp                            ('End: Clear checkpoint')
    %% %%%%%%%%%%%%%%%% Designated Folder 
    %Gathering Hostname,IP,USER of personal computer using Windows10
    !hostname
    hostname                    =   char( getHostName( java.net.InetAddress.getLocalHost ) );
    ip                          =   char( getHostAddress( java.net.InetAddress.getLocalHost ) );
    user                        =   getenv('UserName');
    %Determining Foldernames Derived from Microsoft 'OneDrive' Cloud.  
    str_ConfocExperiment_str    =   'E:'; %Experiment Folder- Starting Point to find Experiment to Analyze
    str_Functions_str           =   strcat('C:\Users\',user,'\Documents\Dropbox\LLIULM\MATLAB\Image Processing\Fun'); %Functions Folder-Upload Functions Andre Created
    str_ProcessedData_str       =   strcat('C:\Users\',user,'\OneDrive\MrBigTest\Confocal Data\Processed Data');
    str_ExtendedFunctions_str   =   strcat('C:\Users\',user,'\OneDrive\m_Scripts\phagosight-master'); 
    
    %% Find Folder
    MaxPixelIntensity           =   2^16-1;
    %Starting Point for Folder
    cd                              (str_ConfocExperiment_str)
    exp_folder                  =   uigetdir;
    
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
                           if ti==0
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
                           if ti==0
                               nameTR1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                           elseif ti<10
                                nameTR1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           else
    %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                           end;                  
                       else
                           if ti==0
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
                       if ti==0
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
                           if ti==0
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
                           if ti==0
                               nameGFP1  = strcat(str_part,'*t0','*p',num2str(i),'*');
                           elseif ti<10
                                nameGFP1  = strcat(str_part,'*t',num2str(ti),'*p',num2str(i),'*');
                           else
    %                             nameTR1  = strcat(str_part,'*t0',num2str(ti),'*P',num2str(i),'*');
                           end;
                       else
                           if ti==0
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
                       if ti==0
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
end;


pause()
%% imreading images  
%numfidsPH = numel(dPh2); %number of tif files in folder
valsPhaseContrast       =   {};
valsPH2                 =   {};
valsTR                  =   {};
valsTexasRed            =   {};
valsGFP                 =   {};
valsGreen               =   {};
%%--Reads the grayscale/color image from the file specified by
%%the string FILENAME.  REteruns value in an array containing the image data
%% Create Folders and Save BF 
cd                    (str_ProcessedData_str);
mkdir                 (name);%---> Move to processed data folder
cd                    (name)%-----> Move to experiment folder
ProcessedTemp_str   = cd; 
valsPh2             = {};
for J = 1:posnum 
    cd                   (ProcessedTemp_str) %Directory of Processed Experiment#
    Str_Posnum         = PositionName{J};
    mkdir                (Str_Posnum)
    cd                   (Str_Posnum)
    pos_folder         = cd; %Processed data Position directory
    [pa3, name3, ext3] = fileparts(cd);
    counter            = 1000;
    cnter              = 0;
    disp                (strcat('On Position',num2str(J),'!!!!!!!!!!!!!!'))
    valsPHZ            = {};
    for K=1:parts
        if K==parts % --> This is so that we can put the PreInjury In its own folder
                Str_Posnum         = PositionName{J};
                Str_PreInjuryPosnum= strcat(Str_Posnum,'-PreInjury');
                cd                   (ProcessedTemp_str)            
                mkdir                (Str_PreInjuryPosnum)
                cd                   (Str_PreInjuryPosnum)
                pos_folder         = cd; %Processed data Position directory
        end;
        disp                   (strcat('On Part',num2str(K),'/ out of',num2str(parts))) %displaying progress
        minfids            =   numfids(K);
        for j = 1:minfids
            %Count According to Part numfids cummulatively
            counter            =  counter+1; %IMPORTANT--COUNTING MECHANISM FOR FOLDERS accumulation
            cnter              =  cnter+1;
            cd                    (pos_folder) %Directory of Processed 'P#'
            disp                  (counter)
            %Change Folder Name to T000# format
            str_Tfoldername    =  strcat('T',num2str(counter));
            str_Tfoldername(2) =  '0';
            %Create Folder with Such Name and go to Directory
            mkdir                 (str_Tfoldername)                   
            cd                    (str_Tfoldername)               
            [pa4, name4, ext4] =  fileparts(cd);
            time_folder        =  cd;           
            valsBF             =  {0};
            %Grab Name and add T000# Format to such names
            str_Ph2name        =  Arr_Ph2{K}{J}{j};
            cd                   (dir_BF)
            valsPHZ{cnter}         =  imread(str_Ph2name); 
            cd                   (time_folder);
            str_SaveName       = strcat(str_Tfoldername,'-Ph2-',str_Ph2name);
            imwrite              (valsPHZ{cnter},str_SaveName,'Compression','none','Resolution',1);
            disp                 ([num2str(100*j/(minfids),'%2.1f') ' %BF' num2str(j) ' / ' num2str(minfids) ' ' num2str(J) ' out ' num2str(posnum) ' ' num2str(100*J/(posnum),'%2.1f')]);
        end;
    end;
    valsPh2{J}=valsPHZ;
%    valsTR{J}=valsTRnumfid;
%    valsGFP{J}=valsGnumfid;
end;
%% Save Zstacks GFP
cd                    (str_ProcessedData_str);
mkdir                 (name);
cd                    (name)
ProcessedTemp_str   = cd; 
for J = 1:posnum 
    cd                   (ProcessedTemp_str) %Directory of Processed Experiment#
    Str_Posnum         = PositionName{J};
    mkdir                (Str_Posnum)
    cd                   (Str_Posnum)
    pos_folder         = cd; %Processed data Position directory
    [pa3, name3, ext3] = fileparts(cd);
    counter            = 1000;
    cnter              = 0;
    disp                (strcat('On Position',num2str(J),'!!!!!!!!!!!!!!'))
    for K=1:parts
        if K==parts % --> This is so that we can put the PreInjury In its own folder
                Str_Posnum         = PositionName{J};
                Str_PreInjuryPosnum= strcat(Str_Posnum,'-PreInjury');
                cd                   (ProcessedTemp_str)            
                mkdir                (Str_PreInjuryPosnum)
                cd                   (Str_PreInjuryPosnum)
                pos_folder         = cd; %Processed data Position directory
        end;
        disp                        (strcat('On Part',num2str(K),'/ out of',num2str(parts))) %displaying progress
        minfids                 =   numfids(K);
        for j = 1:minfids
            %Count According to Part numfids cummulatively
            counter             =  counter+1; %IMPORTANT--COUNTING MECHANISM FOR FOLDERS accumulation
            cnter               =  cnter+1;
            cd                    (pos_folder) %Directory of Processed 'P#'
            disp                  (counter)
            %Change Folder Name to T000# format
            str_Tfoldername     =  strcat('T',num2str(counter));
            str_Tfoldername(2)  =  '0';
            %Create Folder with Such Name and go to Directory
            mkdir                 (str_Tfoldername)                   
            cd                    (str_Tfoldername)               
            [pa4, name4, ext4]  =  fileparts(cd);
            time_folder         =  cd;           
            valsGFP             =  {0};
            %Grab Name and add T000# Format to such names
           if znum>1
                for z=1:znum
                    str_GFPname        =  Arr_GFP{K}{J}{j}{z};
                    cd                    (dir_GFP)
                    valsGFP{z}         =  imread(str_GFPname); 
                    cd                    (time_folder);
                    str_SaveName       =  strcat(str_Tfoldername,'-GFP-',str_GFPname);
                    imwrite               (valsGFP{z},str_SaveName,'Compression','none','Resolution',1);%,'BitDepth',16);
                end;
            else
                display('single Z for red')
                disp('no vals')
            end;
            disp                 ([num2str(100*j/(minfids),'%2.1f') ' % GFP' num2str(j) ' / ' num2str(minfids) ' ' num2str(J) ' out ' num2str(posnum) ' ' num2str(100*J/(posnum),'%2.1f')]);
        end;
    end;

end;

%% Save Zstacks TexRed Combine (Andre Transform)
cd                    (str_ProcessedData_str);
mkdir                 (name);
cd                    (name)
ProcessedTemp_str   = cd; 
for J = 1:posnum 
    cd                   (ProcessedTemp_str) %Directory of Processed Experiment#
    Str_Posnum         = PositionName{J};
    mkdir                (Str_Posnum)
    cd                   (Str_Posnum)
    pos_folder         = cd; %Processed data Position directory
    [pa3, name3, ext3] = fileparts(cd);
    counter            = 1000;
    cnter              = 0;
    disp                (strcat('On Position',num2str(J),'!!!!!!!!!!!!!!'))
    for K=1:parts
        if K==parts % --> This is so that we can put the PreInjury In its own folder
                Str_Posnum         = PositionName{J};
                Str_PreInjuryPosnum= strcat(Str_Posnum,'-PreInjury');
                cd                   (ProcessedTemp_str)            
                mkdir                (Str_PreInjuryPosnum)
                cd                   (Str_PreInjuryPosnum)
                pos_folder         = cd; %Processed data Position directory
        end;
        disp                        (strcat('On Part',num2str(K),'/ out of',num2str(parts))) %displaying progress
        minfids                 =   numfids(K);
        for j = 1:minfids
            %Count According to Part numfids cummulatively
            counter             =  counter+1; %IMPORTANT--COUNTING MECHANISM FOR FOLDERS accumulation
            cnter               =  cnter+1;
            cd                    (pos_folder) %Directory of Processed 'P#'
            disp                  (counter)
            %Change Folder Name to T000# format
            str_Tfoldername     =  strcat('T',num2str(counter));
            str_Tfoldername(2)  =  '0';
            %Create Folder with Such Name and go to Directory
            mkdir                 (str_Tfoldername)                   
            cd                    (str_Tfoldername)               
            [pa4, name4, ext4]  =  fileparts(cd);
            time_folder         =  cd;           
            valsTexRed             =  {0};
            %Grab Name and add T000# Format to such names
           if znum>1
               %PreFormat to determine dimensions
                str_TexRedname       =  Arr_TexRed{K}{J}{j}{1};
                cd                    (dir_TexRed)
                A                    =  imread(str_TexRedname); 
                [n,m]=size(A); % or [n,m]=size(tab2) because tab1 and tab2 have the same size
                E={};
                for z=1:znum
                    str_TexRedname        =  Arr_TexRed{K}{J}{j}{z};
                    cd                       (dir_TexRed)
                    valsTexRed{z}         =  imread(str_TexRedname); 
                    cd                       (time_folder);
                    str_SaveName          =  strcat(str_Tfoldername,'-TexRed-',str_TexRedname);
                    if z==1;
                        E= valsTexRed{z};
                    else
                        B= valsTexRed{z};
                        %find the maximum between tab1 and tab2 and then put the result into tab3
                        %row
                        for ii=1:n
                            %col
                            for jj=1:m
                                E(ii,jj)=max(E(ii,jj),B(ii,jj));
                            end
                %             disp(num2str(i/512))
                        end
                    end;          
                    
                end;
            else
                display('single Z for red')
                disp('no vals')
            end;
            imwrite              (E,str_SaveName,'Compression','none','Resolution',1);%,'BitDepth',16);
            disp                 ([num2str(100*j/(minfids),'%2.1f') ' % TexRed' num2str(j) ' / ' num2str(minfids) ' ' num2str(J) ' out ' num2str(posnum) ' ' num2str(100*J/(posnum),'%2.1f')]);
        end;
    end;

end;

%% Save Iteration and Time Before
disp(strcat('Experiment:',name))
disp(strcat('Positions:',num2str(posnum)))
if posnum==8
    ti_d=65/60;
elseif posnum==9
    ti_d=74.3/60;
elseif posnum==10
    ti_d=85/60;
else
    ti_d=60/60;
end
disp('ti_d')
disp(ti_d)
t_plateinput=input('What was t_plate?');
% t_plate=35;
t_plate=t_plateinput;
disp('t_plate')
disp(t_plate)


%% Save
[pa2,n2,ext2]=fileparts(pa3);
cd(pa2);
% OriginalImg=valsPH2{1}{1};
str_savename=strcat(name,'.mat');
save(name,'name','ti_d','t_plate','numfids','PositionName','valsPh2','pa2','pa3','znum','posnum');
%disp for easy t
disp(name)
cd
dir

    