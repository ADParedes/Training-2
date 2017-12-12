%% Plots ROS
IntDen(1)=IntDen(2);
CTFF=IntDen - (RoiArea.*Andre);

vs      = CTFF';%mfi'; %dBaseline;
Time    = round((arr_T(1:frames)*ti_d+t_plate)-ti_d);

ymax    = max(vs)+1000000;%max(Rw);
ymin    = min(vs)-1000000;%min(Bg);
xmax    = Time(end)+5;
xmin    = t_plate;
%%---------------------
figure(1);plot((Time(1:frames)),vs); % Advanced box plot
    ylim([ymin ymax])
    xlim([xmin xmax])
    xlabel(' Minutes after Injury'); % Set the X-axis label
    ylabel(' Pixel Intensity abu'); % Set the X-axis label
% hold on;    
%     plot((arr_T(1:frames)+30),Df); % Advanced box plot
%     ylim([ymin ymax])
%     xlim([30 frames+35])
%     xlabel(' Minutes after Injury'); % Set the X-axis label
%     ylabel(' Pixel Intensity abu'); % Set the X-axis label
    
%% Moving Average 

FigHandle = figure
set(FigHandle, 'Position', [400, 100, 800, 650]); %[x1, y1, x2, y2]
plot((Time(1:frames)),vs,'--'); % Advanced box plot
    axis([xmin xmax ymin ymax]) 
hold on 
    %-- moving average plot addition
window_size = 4;
simple=tsmovavg(vs,'s',window_size,1); %note sample needs to be vertical**
semi_gaussian = [0.026 0.045 0.071 0.1 0.12 0.138];
semi_gaussian = [semi_gaussian fliplr(semi_gaussian)];
weighted      = tsmovavg(vs,'w',semi_gaussian,1); 
holder        = weighted(6:end)';
wholder       = cat(2,holder,nan(1,5));

plot((Time(1:frames)),simple,'color','r')

hold on
   %-- moving average plot addition
plot((Time(1:frames)),wholder', 'color','b')
    legend('Raw ','Simple Moving Average','Weighted Moving Average',...
    'Location','NorthWest')
    title('ROS Generation in Wound','fontsize',12)
    xlabel(' Minutes after Injury'); % Set the X-axis label
    ylabel('CTCF') %\Delta % from Baseline'); % Set the X-axis label
    grid on
 
for i=1:length(T_p)
    txt1=strcat(num2str(round(vs(T_p(i)))));
    txt2='\uparrow';
    text(Time(T_p(i))-1,(vs(T_p(i))-10),txt2)
    text(Time(T_p(i)),(vs(T_p(i))-11),txt1)
end;
    
    
figure()    
ch_PH2=8;
 imagesc(Img1); colormap('gray')   
    currAxPos = get(gca,'position');
if currAxPos(end) ==1
    set(gca,'position',[  0.1300    0.1150    0.7800    0.8100 ]);axis on
else
    set(gca,'position',[0 0 1 1 ]);axis off
end
clear currAxPos
text(10,10,strcat(name,name5),'Color','red','FontSize',20)