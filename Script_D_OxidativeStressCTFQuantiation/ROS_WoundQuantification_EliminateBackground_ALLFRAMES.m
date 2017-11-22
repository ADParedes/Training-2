%Calculating ROS Generation at Wound Region 
%2016-10-07 e
%STEP 1:  Loading matifiles
%STEP 2: Load Analysis (selecting Experiment and Position)
%ONCE THAT IS DONE THEN RUN THIS SCRIPT
%%%%%%%%%%%%%%%%%%%%%%SUGGESTION TO DAVID THE JOKER OF THE CENTURY
%%Take "arr_Intensity"
%%use the everyother
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%-Prelude: Determining Folders of Interest
%Select the folder again
cd(zfolder);
MaxPixelIntensity = 2^16-1;
SelectedFolder_str  = uigetdir();

[pa5, name5, ext5]  = fileparts(SelectedFolder_str); %break up file name % AS DONE IN 'B:Zebra3-LoadAnalysis'
disp(name)
disp(name5)
%--Access the Position Folder (E.g. P1 or P2..) to determine Frames used
cd(pa5)
cd(name5)
%--Save the directory and access folder names to determine Frames
dname5              = dir('*T*'); % Removes anything that is not a T0000 style folder
len_dname           = length(dname5);
tplate              = t_plate;  %stored original t_plate as tplate incase I need to refer back to it
clear arr_T
clear tfolder
for i=(1:len_dname) %for MAC is at 5.  
    tfolder = dname5(i).name;
    arr_T(i)= str2num(tfolder(2:end));
    min_t   = min(arr_T);
    max_t   = max(arr_T);
end;
adj_tplate          = (min_t-1)*ti_d+t_plate;%min to add to t_plate so that deleted frames are considered in time 
tplate              = adj_tplate;
%--max is just arr_T length
frames              = length(arr_T); 
disp(frames)
Time                = round((arr_T(1:frames)*ti_d+t_plate)-ti_d);
% frames=99;
%--determine the time points after wounding.  
GT_60               = round((60-tplate)/ti_d);
GT_90               = round((90-tplate)/ti_d);
GT_120              = round((120-tplate)/ti_d);
GT_150              = round((150-tplate)/ti_d);  %GT_150=golden(2hours and 30 minutes)
GT_180              = round((180-tplate)/ti_d);
boo_60              = 1;
boo_90              = 1;
boo_120             = 1;
boo_150             = 1;
boo_180             = 1;
boo_max             = 1;
display('_')
if GT_60>frames
    display(strcat(num2str(GT_120),'_ GT_60 exceeds ',' _', num2str(frames)))
    boo_60  = 0;
    boo_90  = 0;
    boo_120 = 0;
    boo_150 = 0;
    boo_180 = 0;
elseif GT_90>frames
    display(strcat(num2str(GT_120),'_ GT_90 exceeds ',' _', num2str(frames)))
    boo_90  = 0;
    boo_120 = 0;
    boo_150 = 0;
    boo_180 = 0;
elseif GT_120>frames
    display(strcat(num2str(GT_120),'_ GT_120 exceeds ',' _', num2str(frames)))
    boo_120 = 0;   
    boo_150 = 0;
    boo_180 = 0;
elseif GT_150>frames
    display(strcat(num2str(GT_150),'_GT_150 exceeds ',' _', num2str(frames)))
    boo_150 = 0;
    boo_180 = 0;
elseif GT_150>frames
    display(strcat(num2str(GT_150),'_GT_150 exceeds ',' _', num2str(frames)))
    boo_150 = 0;
    boo_180 = 0;
elseif GT_180>frames
    display(strcat(num2str(GT_150),'_GT_150 exceeds ',' _', num2str(frames)))
    boo_180 = 0;
else
    display('you have over 3 hours of total experiment.  Wow')
end;  
disp('_')
arr_boo_GT      = [boo_60,boo_90,boo_120,boo_150,boo_180,boo_max];
arr_GT          = [GT_60,GT_90,GT_120,GT_150,GT_180,frames];
gtinwoundcount  = 0;
beat            = 0;
%-Update to only do these time points
boo_max         = 0;
arr_LoopGT      = arr_GT(1==(arr_boo_GT)); %includes only the values that arn't zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Perform Quantitation of ROS Baseline (PreInjury) at Region of Interest 
cd(pa5)
prename5            = strcat(name5,'-PreInjury');
cd(prename5)
pos_F               = cd;
dprename5           = dir('*T*');
len_dname           = length(dprename5);
Arr_Pre_Bkgd        ={0};
Arr_Pre_Ifish       ={0};
Arr_Pre_Raw{i}      ={0};
Arr_Pre_Difference  ={0};
Pre_Raw             =(0);
Pre_Bkgd            =(0);

Pre_Diff            =(0);
PreDf               = 0;
PreBg               = 0;
PreRw               = 0;
z_i                 = 1;
disp('Processing......')
disp(prename5)
for i=1:1
    %% Set Parameters
    cd(pos_F)
    tfolder     = dprename5(i).name;
    cd(tfolder)
    str_TexRed  = strcat('*ex*');
    str_BF      = strcat('*Ph2*');
    str_GFP     = strcat('*GFP*');
    f_GFP       = dir(str_GFP);
    f_TexRed    = dir(str_TexRed);
    f_BF        = dir(str_BF);
    %% Select TexRed In Focus
        disp('Determining best z_stack');
        if length(f_TexRed)>1
            for ii=1:length(f_TexRed)
                figure(ii);imagesc(imread(f_TexRed(ii).name))
            end;
            z_i = input('Whats the best z-stack');
        else
            z_i = 1;
        end;
    everyother  = i;       
    str_OgImg = f_BF(1).name;
    seeMe       = f_TexRed(1).name; %We fused all zstacks together for TexRed, so should be the one and only
    %% Find Threshold for ROS
    OgImg=imread(str_OgImg);
    Img0=imadjust(OgImg);
    Tr0=imread(seeMe); 
        Threshold=7000;
        happy='n';
        while happy ~= 'y'
            close all
            A=Tr0;
            A(A>=Threshold)=1;
            A(A>1)=0;
            imagesc(A);
            save_Threshold=Threshold;
            Threshold=input(strcat('Set the Low Threshold, [',num2str(Threshold),']'));
            if isempty(Threshold)
                Threshold=save_Threshold;
            else
            end;
            close all
            A(A>=Threshold)=1;
            A(A<1)=0;
            imagesc(A)
            happy=input('Are you happy With Threshold','s');
        end;
        B=A;
        
        seeMe=f_TexRed(z_i).name;
        I=imread(seeMe);  %read image to beMe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%ROS Region
        if i==1 || i==3  %or statement
            disp('Select ROS Wound Region')
            close all; imagesc(Img0); title('ROS REGION');
            RosRegion=roipoly();
        else
        end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Background Region
        if i==1 
            disp('Select Background Region')
            close all; imagesc(Tr0); title('BACKGROUND REGION');
            BackgroundRegion = roipoly();
            close all;
        else
            disp(strcat('Keeping Previous Background Region on frame: ',num2str(i)))
        end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    arr_Pre_Bkgd    =(0);
    arr_Pre_Raw     =(0);
    arr_Pre_Diff    =(0);
    for j=1:length(f_TexRed)
        seeMe=f_TexRed(j).name;
        Tr0=imread(seeMe);  %read image to beMe
        BW=im2bw(Tr0,0.3);
        BW_clean1 = bwareaopen(BW, 2);
%        %--Going to threshold for Notochord
%         Threshold=7000;
%         happy='n';
%         a=0;      
%         while (isempty(happy)) || (happy ~= 'y'
%             close all
%             a=a+1;
%             NC=Tr0;
%             NC(NC>=Threshold)=1;
%             NC(NC>1)=0;   
%             imagesc(NC)
%             happy=input('Are you happy With Threshold','s');  
%             if happy=='y'
%             else                
%                 save_Threshold=Threshold;
%                 Threshold=input(strcat('Set the Low Threshold, [',num2str(Threshold),']'));
%                 if isempty(Threshold)
%                     Threshold=save_Threshold;
%                 else
%                 end;
%             end;                               
%         end;
     
        %--Threshold for Notochord
        se90 = strel('line', 3, 90); se0 = strel('line', 3, 0);            
        Bdil = imdilate(B, [se90 se0]); %figure, imshow(Adil), title('dilated gradient mask');
        BWdfill = imfill(Bdil, 'holes'); %figure, imshow(BWdfill); title('binary image with filled holes')             
        bw = bwareaopen(BWdfill, 5000);%Eliminating objects fewer than 5000 Pixels
        bw2=bwmorph(bw,'clean'); %clean not sure, can't hurt
        bw2=bwmorph(bw2,'thicken'); %thickens by just a little
        bw=bw2;
        bwO=bwperim(bw);
        bwO=imdilate(bwO,[se90,se0]);
        bw_color_realsegout=imoverlay(Tr0,bwO,[1 0 0]);%high is red
        %%%Converse is the Background
        se90bck = strel('line', 20, 90);
        se0bck = strel('line', 20, 0);
        bw_background = imdilate(BWdfill, [se90bck se0bck]);
        bw_background=~bw_background;
            
        %% To see the outline over the ROS Profile
        RR=RosRegion&bw;
        RR_outline=bwperim(RR);
        SegoutIntensity=Tr0;
        SegoutIntensity(RR_outline) = MaxPixelIntensity;
        Fish = imadjust(Tr0, stretchlim(Tr0), []);
        I_fishRR=imoverlay(Fish,RR_outline,[1 0 0]);
        imshow(I_fishRR);  
        %% 
        RosRegionMask=RR;
        RawPixelIntensity=0;
        BackgroundPixelIntensity=0;
        CellPixelNum = sum(sum(RosRegionMask));
        BackgroundPixelNum = sum(sum(BackgroundRegion));%size(OriginalImgBF,1)*size(OriginalImgBF,2)-CellPixelNum; % or sum(sum(~CellMask))02/

        RawPixelIntensity = sum(sum(uint16(RosRegionMask).*Tr0))/CellPixelNum;
        BackgroundPixelIntensity = sum(sum(uint16(BackgroundRegion).*Tr0))/BackgroundPixelNum;
        DifferenceIntensity=[RawPixelIntensity-BackgroundPixelIntensity];
        arr_Pre_Bkgd(j)=BackgroundPixelIntensity;
        arr_Pre_Raw(j)=RawPixelIntensity;
        arr_Pre_Diff(j)=DifferenceIntensity;
        %(sum(sum(OriginalImgBF))-sum(sum(uint16(CellMask).*OriginalImgBF)))/BackgroundPixelNum;
    end;
        Arr_Pre_Bkgd{i}         = arr_Pre_Bkgd;
        Arr_Pre_Ifish{i}        = I_fishRR;
        Arr_Pre_Raw{i}          = arr_Pre_Raw;
        Arr_Pre_Difference{i}   = arr_Pre_Diff;
        Pre_Raw(i)              = arr_Pre_Raw(z_i);
        Pre_Bkgd(i)             = arr_Pre_Bkgd(z_i);
        Pre_Diff(i)             = arr_Pre_Diff(z_i);
        %     copyfile(combPh2img.name,combinePh2cd_s*tr)
end;   
%-Finalized Values 
PreDf = Pre_Diff;
PreBg = Pre_Bkgd;
PreRw = Pre_Raw;
Prex  =[PreDf,PreRw,PreBg];
%-Displaying
disp(strcat('Background: ',num2str(PreBg)))
disp(strcat('Raw: ',num2str(PreRw)))
disp(strcat('Difference: ',num2str(PreDf)))
disp('END: PreInjury ROS Calculation')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
%% Quantitate ROS in Region of Injury after Injury
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
cd(SelectedFolder_str)
pos_F           = cd;
dname5          = dir('*T*');
len_dname       = length(dname5);
Arr_Bkgd        = {0};
Arr_Ifish       = {0};
Arr_Raw         = {0};
Arr_Difference  = {0};
z_i             = 1;
I_wr            ={0};
I_br            ={0};
I_brs           ={0};
MeanBgs         =(0);
IntDen          =(0);
CTCF            =(0);
RoiArea         =(0);
I_fish          ={0};
disp('Processing...')
disp(name5)
%--
Time                = round((arr_T(1:frames)*ti_d+t_plate)-ti_d);
timepoints      =[60,90,120];
len_n=length(timepoints);
for j=1:len_n
    val             = timepoints(j); % value to find
    tmp             = abs(Time-val);
    [idx idx]       = min(tmp); % idex of closest value
    closest         = Time(idx); %closest value
    tp(j)           = idx;
end;
T_p=cat(2,(1),tp);
%-
iteration       = 200;
everyframe      = (1:frames);
everyiteration  = (1:iteration:frames);
golditeration   = cat(2,T_p,everyiteration);
Threshold       = 7000;
%for i=(arr_LoopGT) %This was the do the 30 minute interations
for i=everyframe % This is to do every single frame 
    %% Set Parameters
    cd(pos_F) %Go back to experiment folder
    tfolder         = dname5(i).name; %select Frame folder 
    cd(tfolder) %move to this directory
    str_TexRed      = strcat('T0*ex*'); 
    str_GFP         = strcat('T0*GFP*');
    str_BF          = strcat('T0*Ph2*');
    f_GFP           = dir(str_GFP); %select only GFP named files (tiffs assuming nothing else saved in this folder)
    f_TexRed        = dir(str_TexRed); %select only TexRed named files (TIFFS assuming nothing else saved in this folder)
    f_BF            = dir(str_BF);
    arr_Diff        = 0;
    arr_Raw         = 0;
    %% Select TexRed In Focus  
    if length(f_TexRed)>1
        disp('Determining best z_stack');
        for ii=1:length(f_TexRed)
            figure(ii);imagesc(imread(f_TexRed(ii).name))
        end;
        z_i = input('Whats the best z-stack');
    else
        z_i = 1;
    end;
    everyother  = i;       
    seeMeTR       = f_TexRed(z_i).name;
    seeMeBF     = f_BF(z_i).name;
    I_TR          = imread(seeMeTR); 
    I_BF        = imread(seeMeBF);
    I_BF        = imadjust(I_BF);
    happy       = 'n';
    %% Qualitative
    OriginalImgTR            = I_TR; 
    if ~isempty(find(i==golditeration))%i==1
        disp(T_p)
        disp(i)
        %-Very first iteration to set all the presets
           %%-Thresholding %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            while happy ~= 'y'
                close all
                A               = I_TR;
                A(A>=Threshold) = 1;
                A(A>1)          = 0;
                imagesc(A);
                save_Threshold  = Threshold;
                Threshold       = input(strcat('Set the Low Threshold, [',num2str(Threshold),']'));
                if isempty(Threshold)
                    Threshold = save_Threshold;
                else
                end;
                close all
                A(A>=Threshold) = 1;
                A(A<1)          = 0;
                imagesc(A)
                happy           = input('Are you happy With Threshold','s');
            end;
            %%-REGION Selection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if i==1            
                Img1=I_BF;
                disp('Select ROS Wound Region')
                close all; imagesc(I_BF); colormap('gray');title('ROS REGION');
                RosRegion       = roipoly();
                %------------Background----------------------------------
                disp('Select Background Region')
                boo_bg     = 'y';
                a          = 0;
                temp_Bgs     =(0);
                [x,y]      = size(A);   
                blankimage = zeros(x,y);
                while (isempty(boo_bg)) ||  boo_bg=='y'  
                    a=a+1;
                    if a==1
                        BgRegions           = blankimage;
                    else
                        boo_bg=input('Another Background Region?','s');
                        if boo_bg=='n'
                            break
                        elseif isempty(boo_bg)
                            break
                        end;
                    end;
                    disp('Select Background Region')
                    close all; imagesc(I_BF); title('BACKGROUND REGION');
                    BackgroundRegion         = roipoly();
                    OriginalImgTR            = I_TR; 
                    BgRegions                = BgRegions & BackgroundRegion;
                    BackgroundPixelNum       = sum(sum(BackgroundRegion));%size(OriginalImgBF,1)*size(OriginalImgBF,2)-CellPixelNum; % or sum(sum(~CellMask))02/
                    BackgroundPixelIntensity = sum(sum(uint16(BackgroundRegion).*I_TR))/BackgroundPixelNum;
                    temp_Bgs(a)=BackgroundPixelIntensity;
                    disp(temp_Bgs)
                    close all;


                end;
                close all;
            else
                disp(strcat('Keeping Previous Background Region on frame: ',num2str(i)))
                close all; 
                temp_outlinebg  = bwperim(I_brs{i-1});
                temp_outline    = bwperim(I_rr{i-1});
                temp_segout     = imoverlay(I_TR,temp_outline,[1 0 0]);
                temp_segouts    = imoverlay(temp_segout,temp_outline,[1 1 0]);
                temp_segout_BF  = imoverlay(I_BF,temp_outline,[1 0 0]);
                close all;
                figure();imagesc(temp_segout);
                figure();imagesc(temp_segout_BF);colormap('gray'); title('ROS REGION');
                rr_input=input('Do ROS again?','s');
                if rr_input=='y'
                    RosRegion       = roipoly();
                else
                end;             
            end;
%     elseif ~isempty(find(i==everyiteration))
        %-Will need to check to see if everything is in order       
    else
        %-These are automated processing.
            %-Thresholding
                A               = I_TR;
                A(A>=Threshold) = 1;
                A(A>1)          = 0;
            %- Region Selection
                RosRegion       = I_rr{i-1};
                BackgroundRegion= I_br{i-1};
                BgRegions       = I_brs{i-1};
                temp_Bgs        = MeanBgs(i-1);
                
    end;
    RawPixelIntensity           = sum(sum(uint16(RosRegionMask).*OriginalImgTR))/CellPixelNum;
    B         = A;
    I_fish{i} = I_TR;
    I_rr{i}   = RosRegion;
    I_br{i}   = BackgroundRegion;
    I_brs{i}   = BgRegions;
    MeanBgs(i)= mean(temp_Bgs);        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  %% Quantitation
    arr_Bkgd  =(0);
    arr_Raw   =(0);
    arr_Diff  =(0);
    for j=1:length(f_TexRed)
        seeMe_TR1               = f_TexRed(j).name;
        I_TR1                   = imread(seeMe_TR1);  %read image to beMe
%         B=I;
%         B(B>=Threshold)=1;
%         B(B<1)=0;B=~B;B=~B;  
        se90                = strel('line', 3, 90); se0 = strel('line', 3, 0);            
        Bdil                = imdilate(B, [se90 se0]); %figure, imshow(Adil), title('dilated gradient mask');
        BWdfill             = imfill(Bdil, 'holes'); %figure, imshow(BWdfill); title('binary image with filled holes')             
        bw                  = bwareaopen(BWdfill, 5000);%Eliminating objects fewer than 5000 Pixels
        bw2                 = bwmorph(bw,'clean'); %clean not sure, can't hurt
        bw2                 = bwmorph(bw2,'thicken'); %thickens by just a little
        bw                  = bw2;
        bwO                 = bwperim(bw);
        bwO                 = imdilate(bwO,[se90,se0]);
        bw_color_realsegout = imoverlay(I_TR1,bwO,[1 0 0]);%high is red
        %%%Converse is the Background
        se90bck             = strel('line', 20, 90);
        se0bck              = strel('line', 20, 0);
        bw_background       = imdilate(BWdfill, [se90bck se0bck]);
        bw_background       =~bw_background;
            
        %% To see the outline over the ROS Profile
        RR                          = RosRegion&bw;
        RR_outline                  = bwperim(RR);
        RBg_outline                 = bwperim(BackgroundRegion);
        SegoutIntensity             = I_TR1;
        SegoutIntensity(RR_outline) = MaxPixelIntensity;
        Fish                        = imadjust(I_TR1, stretchlim(I_TR1), []);
        I_fishRR                    = imoverlay(Fish,RR_outline,[1 0 0]);
        I_fishROIs                  = imoverlay(I_fishRR,RBg_outline,[1 1 0]);
        imshow(I_fishROIs);  
        text( 5, 5, 'Wound Region','Color','red')
        text( 5,15,'Background Region','Color','yellow')
        %% CTCF Calculation
        cc_rr     = regionprops(RR);
        temp_area = [cc_rr.Area];
        RoiArea(i)= sum(temp_area);
        IntDen(i) = RoiArea(i) * RawPixelIntensity; %Integrated Density
        CTCF(i)   = IntDen(i) - (RoiArea(i) *MeanBgs(i));%Corrected Total Cell Fluorescence 


        %% 
        %-PreSet
        OriginalImgTR               = I_TR1;
        RosRegionMask               = RR;
        RawPixelIntensity           = 0;
        BackgroundPixelIntensity    = 0;
        CellPixelNum                = sum(sum(RosRegionMask));
        BackgroundPixelNum          = sum(sum(BackgroundRegion));%size(OriginalImgBF,1)*size(OriginalImgBF,2)-CellPixelNum; % or sum(sum(~CellMask))02/
        %-Calculate Pixel Intensity Aveage
        RawPixelIntensity           = sum(sum(uint16(RosRegionMask).*OriginalImgTR))/CellPixelNum;
        BackgroundPixelIntensity    = sum(sum(uint16(BackgroundRegion).*OriginalImgTR))/BackgroundPixelNum;
        DifferenceIntensity         = [RawPixelIntensity-BackgroundPixelIntensity];
        %-Save in arrays
        arr_Bkgd(j)                 = BackgroundPixelIntensity;
        arr_Raw(j)                  = RawPixelIntensity;
        arr_Diff(j)                 = DifferenceIntensity;
        %(sum(sum(OriginalImgBF))-sum(sum(uint16(CellMask).*OriginalImgBF)))/BackgroundPixelNum;
    end;
    %-Finalize Array Savings
        Arr_Ifish{i}             = I_fishROIs;
        Arr_Raw{i}               = arr_Raw;
        Arr_Bkgd{i}              = arr_Bkgd;
        Arr_Difference{i}        = arr_Diff;
        Bg(i,1)                   = arr_Bkgd(z_i);
        Df(i,1)                   = arr_Diff(z_i);
        Rw(i,1)                   = arr_Raw(z_i);
        disp(strcat('Completed: ',num2str((i/frames)*100),'% [',num2str(i),'] out of [',num2str(frames),']'))
        %     copyfile(combPh2img.name,combinePh2cd_s*tr)
      
end;
disp('END: ROS Detection Injury Loop')
%% --Save Values
disp(strcat('Background: ',num2str(Bg)))
disp(strcat('Raw: ',num2str(Rw)))
disp(strcat('Difference: ',num2str(Df)))
PixValues           = 0;
str_PixValues       = ['Background','Raw','Difference'];
PixValues           = [Df,Rw,Bg];
Time                = round((arr_T(1:frames)*ti_d+t_plate)-ti_d);
% Adjust Values
adjBg=Bg;
idx=find(Bg>(std(Bg)+mean(Bg)));
adjBg(idx)=mean(Bg);
len_Bgnoise=length(idx);
if len_Bgnoise>6
    disp('Lenghth of Bg noise higher than SD is more than 5%')
elseif len_Bgnoise>12
    disp('Lenghth of Bg noise higher than SD is more than 10%')
end;
%-
adjDf=Df;
adjRw=Rw;
adjDf=adjRw-adjBg;
adjPixValues=[adjDf,adjRw,adjBg];
%-
dBaseline=((adjDf-PreDf)/PreDf)*100; %percent change from baseline
%Remember arr_T is the 1:frames
disp('END: After Injury ROS Calculation')
%%
disp('Want to save???????')
pause()
cd('C:\Users\AndreDaniel\OneDrive\PhD Data\m_ROS');
namename        =strcat(name,name5);
save(namename,'dBaseline','adjPixValues','str_PixValues','PixValues','Time','frames','Prex','name5','name','t_plate','ti_d','golditeration','Img1');
disp('END:Saved m_Ros Values')
%%
disp('Load the MeanFlourescence of Non Wound')
cd('C:\Users\AndreDaniel\OneDrive\PhD Data\m_ROS');
%% Moving Average &&& Create Moving
%check shortcut %
% cd('C:\Users\AndreDaniel\OneDrive\PhD Data\ROS Movie')
% axis tight manual
% ax = gca;
% ax.NextPlot = 'replaceChildren';
% 
% loops = frames;
% clear F
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     figure(j);set(gcf,'name',strcat(name,'-',name5));
%     imshow(Arr_Ifish{j})
%     
%     txt1=strcat(num2str((i+tplate)-(ti_d*(60/60))),' min');
%     text(100,100,txt1);
%     drawnow
%     F(j) = getframe(gcf);
%     close();
% end
%- Playback the movie two times (works but not useful.    
% fig = figure;
% movie(fig,F,2)
%% save as movie 
%- save as avi 
% mkdir(strcat(name,'-',name5))
%     try
%         movie2avi(F,strcat(name,'-',name5),'compression','none');%strcat(name,'-',name5,'VI/video_1.avi'),'compression','none')
%     catch
% %         %an error was detected whilst saving the movie, 
% %         [numRows,numCols,numChannels]= size(F(1).cdata);
% %         for counterFrame = 1:size(F,2)
% %             % iterate over frames and crop if necessary to the first one
% %             F(counterFrame).cdata(numRows+1:end,:,:)=[];
% %             F(counterFrame).cdata(:,numCols+1:end,:)=[];
% %             % to guarantee the same size, add a zero in the last pixel
% %             F(counterFrame).cdata(numRows,numCols,3)=0;
% %         end
% %         movie2avi(F,strcat(name,'-',name5,'VI/video_1.avi'),'compression','none')
%     end
%%     


    %% save the movie as a GIF
%     [imGif,mapGif] = rgb2ind(F(1).cdata,256,'nodither');
%     numFrames = size(F,2);
% 
%     imGif(1,1,1,numFrames) = 0;
%     for k = 2:numFrames 
%       imGif(:,:,1,k) = rgb2ind(F(k).cdata,mapGif,'nodither');
%     end
    %%

%     imwrite(imGif,mapGif,strcat(name,name5),...
%             'DelayTime',0,'LoopCount',inf) %g443800




%% Test indy threshold
% La=bwlabel(bw,4);
% [r,c]=find(La==2); %provides the row and column postions for value "2" 
% 
% % SubarrayIdx
% 
% [B,L] = bwboundaries(bw,'noholes');
% figure(100);set(gcf,'Name','Area of Objectes')
% imshow(label2rgb(L,'copper',[0 0 0]))% Display the label matrix and draw each boundary
% hold on
% %creates * in middle of object
% stats = regionprops(L,'Area','Centroid','PixelIdxList'); %Determines Area of Shapes
% centroids = cat(1, stats.Centroid); 
% plot(centroids(:,1), centroids(:,2), 'y*') 
% hold on
% 
% for k = 1:length(B)
%   boundary = B{k};
%   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', .5)
%     area = stats(k).Area;
%   area_string = sprintf('%2.2f',(area));
%   
%   text(boundary(1,2)-35,boundary(1,1)+13,area_string,'Color','r',...
%        'FontSize',8,'FontWeight','bold');
% end
% 
% %   boundary= B{k}; % obtain (X,Y) boundary coordinates corresponding to label 'k'