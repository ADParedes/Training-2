%Calculating ROS Generation at Wound Region 
%2016-10-07 e
%STEP 1:  Loading matifiles
%STEP 2: Load Analysis (selecting Experiment and Position)
%ONCE THAT IS DONE THEN RUN THIS SCRIPT
%%%%%%%%%%%%%%%%%%%%%%SUGGESTION TO DAVID THE JOKER OF THE CENTURY
%%Take "arr_Intensity"
%%use the everyother
disp(name)
disp(name5)
t_plate=35;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxPixelIntensity = 2^16-1;
%%
%Access the Position Folder (E.g. P1 or P2..) to determine Frames used
cd(pa5)
cd(name5)
%Save the directory and access folder names to determine Frames
dname5=dir;
len_dname=length(dname5);
tplate=t_plate;  %stored original t_plate as tplate incase I need to refer back to it
a=0;
clear arr_T
clear tfolder
for i=(3:len_dname) %for MAC is at 5.  
    a=a+1;
    tfolder=dname5(i).name;
    arr_T(a)=str2num(tfolder(2:end));
    min_t=min(arr_T);
    max_t=max(arr_T);
end;
%min to add to t_plate so that deleted frames are considered in time 
adj_tplate=(min_t-1)*ti_d+t_plate;
tplate=adj_tplate;
%max is just arr_T length
frames=length(arr_T);
% frames=99

%determine the time points after wounding.  
GT_60=round((60-tplate)/ti_d);
GT_90=round((90-tplate)/ti_d);
GT_120=round((120-tplate)/ti_d);
GT_150=round((150-tplate)/ti_d);  %GT_150=golden(2hours and 30 minutes)
GT_180=round((180-tplate)/ti_d);
boo_60=1;
boo_90=1;
boo_120=1;
boo_150=1;
boo_180=1;
boo_max=1;
display('_')

if GT_60>frames
    display(strcat(num2str(GT_120),'_ GT_60 exceeds ',' _', num2str(frames)))
    boo_60=0;
    boo_90=0;
    boo_120=0;
    boo_150=0;
    boo_180=0;
elseif GT_90>frames
    display(strcat(num2str(GT_120),'_ GT_90 exceeds ',' _', num2str(frames)))
    boo_90=0;
    boo_120=0;
    boo_150=0;
    boo_180=0;
elseif GT_120>frames
    display(strcat(num2str(GT_120),'_ GT_120 exceeds ',' _', num2str(frames)))
    boo_120=0;   
    boo_150=0;
    boo_180=0;
elseif GT_150>frames
    display(strcat(num2str(GT_150),'_GT_150 exceeds ',' _', num2str(frames)))
    boo_150=0;
    boo_180=0;
elseif GT_150>frames
    display(strcat(num2str(GT_150),'_GT_150 exceeds ',' _', num2str(frames)))
    boo_150=0;
    boo_180=0;
elseif GT_180>frames
    display(strcat(num2str(GT_150),'_GT_150 exceeds ',' _', num2str(frames)))
    boo_180=0;
else
    display('you have over 3 hours of total experiment.  Wow')
end;  
disp('_')
arr_boo_GT=[boo_60,boo_90,boo_120,boo_150,boo_180,boo_max];
arr_GT=[GT_60,GT_90,GT_120,GT_150,GT_180,frames];
gtinwoundcount=0;
beat=0;

%Update to only do these time points
boo_max=0;
arr_LoopGT=arr_GT(1==(arr_boo_GT)); %includes only the values that arn't zero


%%
pos_F=cd;
dname5=dir;
len_dname=length(dname5);
a=0;
clear arr_T
clear tfolder
Arr_Real={0};
arr_Intensity=0;
Arr_Difference={0};
for i=(2+arr_LoopGT) %for MAC is at 5. 
    cd(pos_F)
    a=a+1;
    tfolder=dname5(i).name;
    cd(tfolder)
    dt=dir;
    str_TexRed=strcat('T0*ex*');
    str_GFP=strcat('T0*GFP*');
    f_GFP=dir(str_GFP);
    f_TexRed=dir(str_TexRed);
    figure(100);imagesc(imread(f_GFP(1).name));
    arr_intensity=0;
    arr_Diff=0;
    arr_Real=0;
    %% Select TexRed In Focus
    if i>3;
        disp('Determining best z_stack');
        if length(f_TexRed)>1
            for ii=1:length(f_TexRed)
                figure(ii);imagesc(imread(f_TexRed(ii).name))
            end;
            z_i=input('Whats the best z-stack');
        else
            z_i=1;
        end;
    end;

    %% Find Ros Region and Background Region
    everyother=i;       
    seeMe=f_TexRed(z_i).name;
    %% Find Threshold for ROS
        I=imread(seeMe); 
        Threshold=7000;
        happy='n';
        while happy ~= 'y'
            close all
            A=I;
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
        if a==1 || a==3  %or statement
            disp('Select ROS Wound Region')
            close all; imagesc(I); title('ROS REGION');
            RosRegion=roipoly();
        else
        end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Background Region
        if a==1 
            disp('Select Background Region')
            close all; imagesc(I); title('BACKGROUND REGION');
            BackgroundRegion = roipoly();
            close all;
        else
            disp(strcat('Keeping Previous Background Region on frame: ',num2str(a)))
        end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    for j=1:length(f_TexRed)
        seeMe=f_TexRed(j).name;
        I=imread(seeMe);  %read image to beMe
%         B=I;
%         B(B>=Threshold)=1;
%         B(B<1)=0;B=~B;B=~B;  
        se90 = strel('line', 3, 90); se0 = strel('line', 3, 0);            
        Bdil = imdilate(B, [se90 se0]); %figure, imshow(Adil), title('dilated gradient mask');
        BWdfill = imfill(Bdil, 'holes'); %figure, imshow(BWdfill); title('binary image with filled holes')             
        bw = bwareaopen(BWdfill, 5000);%Eliminating objects fewer than 5000 Pixels
        bw2=bwmorph(bw,'clean'); %clean not sure, can't hurt
        bw2=bwmorph(bw2,'thicken'); %thickens by just a little
        bw=bw2;
        bwO=bwperim(bw);
        bwO=imdilate(bwO,[se90,se0]);
        bw_color_realsegout=imoverlay(I,bwO,[1 0 0]);%high is red
        %%%Converse is the Background
        se90bck = strel('line', 20, 90);
        se0bck = strel('line', 20, 0);
        bw_background = imdilate(BWdfill, [se90bck se0bck]);
        bw_background=~bw_background;
            
        %% To see the outline over the ROS Profile
        RR=RosRegion&bw;
        RR_outline=bwperim(RR);
        SegoutIntensity=I;
        SegoutIntensity(RR_outline) = MaxPixelIntensity;
        Fish = imadjust(I, stretchlim(I), []);
        I_fishRR=imoverlay(Fish,RR_outline,[1 0 0]);
        imshow(I_fishRR);  
        %% 
        OriginalImgBF=I;
        RosRegionMask=RR;
        RealPixelIntensity=0;
        BackgroundPixelIntensity=0;
        CellPixelNum = sum(sum(RosRegionMask));
        BackgroundPixelNum = sum(sum(BackgroundRegion));%size(OriginalImgBF,1)*size(OriginalImgBF,2)-CellPixelNum; % or sum(sum(~CellMask))02/

        RealPixelIntensity = sum(sum(uint16(RosRegionMask).*OriginalImgBF))/CellPixelNum;
        BackgroundPixelIntensity = sum(sum(uint16(BackgroundRegion).*OriginalImgBF))/BackgroundPixelNum;
        DifferenceIntensity=[RealPixelIntensity-BackgroundPixelIntensity];
        arr_Real(j)=RealPixelIntensity;
        arr_Diff(j)=DifferenceIntensity;
        %(sum(sum(OriginalImgBF))-sum(sum(uint16(CellMask).*OriginalImgBF)))/BackgroundPixelNum;
    end;
        Arr_Ifish{a}=I_fishRR;
        Arr_Real{a}=arr_Real;
        Arr_Difference{a}=arr_Diff;
        arr_Intensity(a)=arr_Diff(z_i);
        arr_Real(a)=arr_Real(z_i);
        %     copyfile(combPh2img.name,combinePh2cd_s*tr)
end;

disp(arr_Diff)
%%
woundsize=bwarea(RR)
disp(arr_LoopGT)
disp(arr_GT)
disp({'60', '90', '120', '150','180','Max'})
disp(Arr_Real)
disp(Arr_Difference)
figure(100);imagesc(imread(f_GFP(z_i).name));
disp(name)
disp(name5)

%% Test indy threshold
La=bwlabel(bw,4);
[r,c]=find(La==2); %provides the row and column postions for value "2" 

% SubarrayIdx

[B,L] = bwboundaries(bw,'noholes');
figure(100);set(gcf,'Name','Area of Objectes')
imshow(label2rgb(L,'copper',[0 0 0]))% Display the label matrix and draw each boundary
hold on
%creates * in middle of object
stats = regionprops(L,'Area','Centroid','PixelIdxList'); %Determines Area of Shapes
centroids = cat(1, stats.Centroid); 
plot(centroids(:,1), centroids(:,2), 'y*') 
hold on

for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', .5)
    area = stats(k).Area;
  area_string = sprintf('%2.2f',(area));
  
  text(boundary(1,2)-35,boundary(1,1)+13,area_string,'Color','r',...
       'FontSize',8,'FontWeight','bold');
end

%   boundary= B{k}; % obtain (X,Y) boundary coordinates corresponding to label 'k'