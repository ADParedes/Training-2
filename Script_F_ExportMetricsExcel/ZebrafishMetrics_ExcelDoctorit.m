%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%ZEBRAFISH EXCEL DOCTOR IT
%Move Excel  GTs 60, 90, 120, 150, 180 and max to excel.
%Updated 2017/11/24
disp('START: Zirmi F: Create Excel Tables')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Recognized GUI-ed Parameters
clear Str Num Dirs RawMetrics % New Structure Array
Str.name                = POI.Parameter10d;
Str.expnum             = POI.Parameter10a(3:end);
Str.MetricType          ={'Velocity(um/min)','StaticRatio', 'MeanderingRatio',...
                            'Tortuosity(abu)','ForwardRatio','ForwardtoBackwardRatio'...
                            'WoundDistance(um)','WoundScore(1-4)'};
Num.exp                 = str2num(Str.expnum); %#ok<ST2NM>
Num.micronsPerPixel     = PARAMETERS.Parameter2;
Num.SamplingFrequency   = PARAMETERS.Parameter4;
Num.MPI                 = PARAMETERS.Parameter5;

Dirs.Main            = ADP.dir_metadat;

RawMetrics.MetricType     ={SM.velocity,SM.staticratio,SM.meandering,...
                            SM.tortuosity,SM.forward,SM.FBratio,...
                            SM.WoundScoreUm,SM.WoundScore1234};


display('End: Recognize Parameters')
%% Directory Branching/Sorting For Saving .xls files


if ADP.boo2 == 1 || 0
    %-Experiment Type Descriptor
    Dirs.ExpSet           = input('0J,3J,9J,DoubleWound,NoWound ','s');
    if Num.exp<46
        Dirs.Fish           = 'mpegdendra2';
    elseif Num.exp>46
        Dirs.Fish           = 'mpxdendra2';
    else
        disp('error in Directory Sorting')
    end;
    %-Sort Directory ADP Automatically
    if checkConfocal==1
        str_tempsave        ='C:\Users\AndreDaniel\OneDrive\PhD Data\Data_Dissertation\ZebrafishMetrics';
        disp('Saving it in Onedrive Phd Data')%Saving it On Dropbox in Dr. B folder Data')
    else
        str_tempsave        ='E:\PhD Paredes Data\Dissertation Data';
        disp('E:\Phd Paredes Data\Dissertation Data')%Saving it On Dropbox in Dr. B folder Data')
    end;
else
    Dirs.ExpSet           = input(strcat('Please Input Experiment Set Descriptor',...
                                '(E.g. Set#1 or 9J'),'s');
    Dirs.Fish           = input(stcat('Please Input Tg(Fish) Descriptor',...
                                '(E.g. mpeg or mpx dendra2 '),'s'); 
    
end;

Str.DataType       ={'interval','intervalsm','cumulative',...
                            'phagosight'};

display('End: Directory Sorting')
%% THE FOR LOOP
RawMetrics  = 0; %Structure Array For all Mp of interest (the SM ones)
FishMean    = 0; %Structure Array for the entire fish mean
arr_str_GT  ={'GT_60','GT_90','GT_120','max'};
Mp          = length(handles.finalLabel); %never changes this is the numofTracks
for J=1:4 %only dooing GT 60 90 and 120

    cd(str_tempsave)
    %% Put into arrays
%-Mp ID
%-Metric#0: WoundScore1234
%-METRIC#1: Velocity 
    RawMetrics.velocity{1}              = SM.velocity.interval{J};
    RawMetrics.velocity{2}              = SM.velocity.intervalsm{J};
    RawMetrics.velocity{3}              = SM.velocity.cum{J};
    RawMetrics.velocity{4}              = SM.velocity.phagosight;
%-METRIC#2: Static Ratio
    RawMetrics.staticratio{1}           = SM.staticratio.interval{J};
    RawMetrics.staticratio{2}           = SM.staticratio.intervalsm{J};
    RawMetrics.staticratio{3}           = SM.staticratio.cum{J};
    RawMetrics.staticratio{4}           = SM.staticratio.phagosight;
%-Metric#3: Tortuosity
    RawMetrics.tortuosity{1}            = SM.tortuosity.interval{J};
    RawMetrics.tortuosity{2}            = SM.tortuosity.intervalsm{J};
    RawMetrics.tortuosity{3}            = SM.tortuosity.cum{J};
    RawMetrics.tortuosity{4}            = SM.tortuosity.phagosight;
%-Metric#4: Meandering Index 
    RawMetrics.meandering{1}            = SM.meandering.interval{J};
    RawMetrics.meandering{2}            = SM.meandering.intervalsm{J};
    RawMetrics.meandering{3}            = SM.meandering.cum{J};
    RawMetrics.meandering{4}            = SM.meandering.phagosight;
%-Metric#5: Forward Ratio
    RawMetrics.forward{1}               = SM.forward.interval{J};
    RawMetrics.forward{2}               = SM.forward.intervalsm{J};
    RawMetrics.forward{3}               = SM.forward.cum{J};
    RawMetrics.forward{4}               = SM.forward.phagosight;
%-Metric#6: ForwardtoBackward
    RawMetrics.ftob{1}                  = SM.FtoB.interval{J};
    RawMetrics.ftob{2}                  = SM.FtoB.intervalsm{J};
    RawMetrics.ftob{3}                  = SM.FtoB.cum{J};
    RawMetrics.ftob{4}                  = SM.FtoB.phagosight;   
%-Metric#7: Forward to Backward (normalized)  
    RawMetrics.fbratio{1}               = SM.FBratio.interval{J};
    RawMetrics.fbratio{2}               = SM.FBratio.intervalsm{J};
    RawMetrics.fbratio{3}               = SM.FBratio.cum{J};
    RawMetrics.fbratio{4}               = SM.FBratio.phagosight;
%-Metric#8: WoundScoreUm  - is the distance to the wound gap from initial
%point to the final point | negative(-) means closer ; positive(+) means moved farther away.
%(ADP Labnotebook pg 92)
    RawMetrics.woundscore{1}            = SM.WoundScoreUm.interval{J};
    RawMetrics.woundscore{2}            = SM.WoundScoreUm.intervalsm{J};
    RawMetrics.woundscore{3}            = SM.WoundScoreUm.cum{J};
    RawMetrics.woundscore{4}            = SM.WoundScoreUm.phagosight;
    %% Interval Sheet1  

    Str.Interval.Sheet1         ={'Sec/Frame','MPI',Str.name,'Velocity','Static Ratio,'...,
                                    'Tortuosity','Meandering Index','Forward','FtoB'...,
                                    'FBnormalized','WoundScoreUm'}; %11 Points
    for K=1:4
    %-Velocity
        FishMean.velocity{K}    = RawMetrics.velocity{K};
    %-Static Ratio
        FishMean.staticratio{K} = RawMetrics.staticratio{K};
    %-Tortuosity
        FishMean.tortuosity{K}  = RawMetrics.tortuosity{K};
    %-Mendering Index
        FishMean.meandering{K}  = RawMetrics.meandering{K};
    %-Forward
        FishMean.forward{K}     = RawMetrics.forward{K};
    %-FtoB
        FishMean.ftob{K}        = RawMetrics.ftob{K};
    %-FBnormaliized
        FishMean.fbratio{K}     = RawMetrics.fbratio{K};
    %-WoundScoreUm
        FishMean.woundscore{K}  = RawMetrics.woundscore{K};            
    end;
    %% Sheet 2
    %MpID# Is where exactly
    %Sort RawMetrics By Score
    
    Str.Interval.Sheet23456     ={Str.name,'MpID#','MpScore','Velocity','Static Ratio,'...,
                                    'Tortuosity','Meandering Index','Forward'...,
                                    'FtoB','FBnormalized','WoundScoreUm'}; %12 Points    
                                
                                
                                
                                
                                
%-tort
    FishMean.it=mean(Arr_Tort_interval);
    Mean_ct=mean(Arr_Tort_cum);
    Mean_pt=mean(Arr_Tort_phag);
%-meandering
    Mean_im=mean(Arr_Meander);
    Mean_cm=mean(Arr_Meander_cum);
    Mean_pm=mean(Arr_Meander_phag);
%-Static
    Mean_isr=mean(Arr_staticr_interval);
    Mean_csr=mean(Arr_staticr_cum);
    Mean_psr=mean(Arr_staticr_phag);
    %%------------------NOTE WE DO FRAMES BY BLOCKS NOT AVERAGE OF FRAMES
    Mean_isf=mean(Arr_staticf_interval);
    Mean_csf=mean(Arr_staticf_cum);
    %-Velocity
    Mean_iv=mean(Arr_vel_interval);
    Mean_cv=mean(Arr_vel_cum);
%     Arr_staticr_phag=SM.velocity.phagosight;
    Mean_ivf=mean(Arr_velf_interval);
    Mean_cvf=mean(Arr_veclf_cum);
                    
    Array_Mean={Mean_it,Mean_ct,Mean_pt...
                ,Mean_im,Mean_cm,Mean_pm...
                ,Mean_isr,Mean_csr,Mean_psr...
                ,Mean_iv,Mean_cv...
                ,Mean_isf,Mean_csf,...
                Mean_ivf,Mean_cvf};
    Table_Mean=[Str_Mean;Array_Mean;];
    
    %% Big Array
    STRING={s};
    STRING_WorC={inputExp};
    %Sheet 1 Alternative
    Table_1=0;
    Arr_Table1=0;
    Table_1=[Table_Mean];
    Arr_Table1=horzcat([{'Name'};STRING],Table_1,[{'Frames'};handles.numFrames],[{'ti_d'};ti_d],[{'t_plate'};t_plate]);
    Arr_Table1=Arr_Table1';

    %% Combined Excel
%     display(s) 
    file_excel='Metrics.xlsx';

    [NUM_1,TXT_1,RAW_1]=xlsread(file_excel,1);
    [NUM_2,TXT_2,RAW_2]=xlsread(file_excel,2);
    [NUM_3,TXT_3,RAW_3]=xlsread(file_excel,3);
    TXT={TXT_1,TXT_2,TXT_3};
    RAW={RAW_1,RAW_2,RAW_3};
    %%When STARTING EXCEL FOR FIRST TIME
%     pause()
    %%
    if isempty(TXT{J}) 
    %     xlswrite(file_excel,Array_1F,1,'A1')
        xlswrite(file_excel,Arr_Table1,J,'A1')

    else
    %  Append
        ARR_SHEET1=[RAW{J},Arr_Table1(:,2)];
        xlswrite(file_excel,ARR_SHEET1,J,'A1')

    end;
    %%%%
    disp(strcat('Excel End_',arr_str_GT{J}))
end;
disp(name5)
disp('FINISHED')