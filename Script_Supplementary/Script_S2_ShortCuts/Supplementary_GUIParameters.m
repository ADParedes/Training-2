%% Default Parameters
Parameter1              = 2^16-1;   %MaxPixelIntensity - BPP - dependent on Bits 
Parameter2              = 1.64;     %Lateralpixelresolution  - micronsperpixel
Parameter3              = 10;       %ZstepMicrons
Parameter4              = ti_d;     %SamplingFrequency
Parameter5              = t_plate;  %Minutes Post Injury of Image Start (MPI)
ParameterA              = 0.70;     %Trackability i.e Minum Cell Track length Thresholdper SM a.k.a MajorityTracksPercent=.70; %<--HIGH% selection - ADP
Parameter_gtA           = 0.9;      %Trackability per GT
ParameterB              = 1;        %StaticLimit (1 provides best result)  i.e. 0.8519um. 
ParameterS              = 150;      %Leukocyte Spatial Interval (150um)
%% Other Parameters
Parameter10             = name;                 % str of Experiment name
Parameter11a            = posnum;               % val number of positions of this experiment group
Parameter11b            = name5;                % str of Position number being analyzed
Parameter12             = get(0,'ScreenSize');  % s= [ 1 1 1920 1080]  --> Width-x-(1920) & Height-y-(1080)
%% User Specific Parameters (Diaglog Box)

prompt                  = {'Enter Parameter1: MaxPixelIntensity:'...
                            ,'Enter Parameter2: LateralPixelResolution:'...
                            ,'Enter Parameter3: ZstepMicrons:'...
                            ,'Enter Parameter4: SamplingFrequency(min):'...
                            ,'Enter Parameter5: MPI - Image Start - Minutes post injury'...
                            ,'Enter ParameterA: Trackability Threshold(%)'...
                            ,'Enter ParameterB: StaticLimit (Pixel)'...
                            ,'Enter ParameterS: Leukocyte S# from Following Distance Interval From wound(150um):'};

dlg_title               = 'Input Parameters';
num_lines               = 1;
defaultans              = {num2str(Parameter1),num2str(Parameter2),num2str(Parameter3),num2str(Parameter4),num2str(Parameter5)...
                            ,num2str(ParameterA),num2str(ParameterB),num2str(ParameterS)};
answer                  = inputdlg(prompt,dlg_title,num_lines,defaultans);
Parameter1              = str2num(answer{1});
Parameter2              = str2num(answer{2});
Parameter3              = str2num(answer{3});
Parameter4              = str2num(answer{4});
Parameter5              = str2num(answer{5});t_plate=Parameter5;
ParameterA              = str2num(answer{6});
ParameterB              = str2num(answer{7});
ParameterS              = str2num(answer{8});
disp(strcat('Default MaxPixelIntensity:',num2str(Parameter1)))
disp(strcat('Default LateralPixelResolution(um/pixel):',num2str(Parameter2)))
disp(strcat('Default ZstepMicrons(um):',num2str(Parameter3)))
disp(strcat('Default SamplingFrequency(minutes):',num2str(Parameter4)))
disp(strcat('Default MinutesPosterInjury:',num2str(Parameter5)))