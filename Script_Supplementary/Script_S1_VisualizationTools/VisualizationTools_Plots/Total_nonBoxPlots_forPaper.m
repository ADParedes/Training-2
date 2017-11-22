% 5/06/17 Evaluation of 5 metrics of interest 
% meandering index, velocity, static ratio, directionality and persistence
close all;
str_int_timepoints  =['30- 59 min';'60- 89 min';'90-120 min'];
str_cum_timepoints  =['30- 60 min';'30- 90 min';'30-120 min'];
N                   =length(str_int_timepoints);
input_metric        =input('What metric SM. velocity , tortuosity,meandering, staticratio, directionality and persistence ...');
%--metrics of interest
    y                   =input_metric.interval{1};
    y1                  =input_metric.interval{2};
    y2                  =input_metric.interval{3};
    yy                  =input_metric.cum{1};
    yy1                 =input_metric.cum{2};
    yy2                 =input_metric.cum{3};
    z                   =input_metric.phagosight;
    x                   = 1;
    N                   = 3;
    %--for velocity
            y                   =input_metric.interval{1}*coe;
            y1                  =input_metric.interval{2}*coe;
            y2                  =input_metric.interval{3}*coe;
            yy                  =input_metric.cum{1}*coe;
            yy1                 =input_metric.cum{2}*coe;
            yy2                 =input_metric.cum{3}*coe;
            z                   =input_metric.phagosight*coe;
ymax    = 9;
ymin    = 2;
%% -Interval%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color',[1 1 1]);ylim([ymin ymax])
%  plot(x,y,'x') 
%   hold on
%  plot(x+1,y1,'o')
%  plot(x+2,y2,'d')
%  plot(x+3,y3,'v')
 notBoxPlot(y,1,'style','sdline')
  hold on

 notBoxPlot(y1,2,'style','sdline')
  hold on

 notBoxPlot(y2,3,'style','sdline')
    set(gca,'XLim',[0 N+1],'XTick',1:N,'XTickLabel',str_int_timepoints,'fontweight','bold','fontsize',14);
%     title('Interval')
    ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')
%   title('Meandering Index')
%   set(gca,'fontweight','bold','fontsize',18)

%% -Cummulative%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure('Color',[1 1 1]);ylim([ymin ymax])
%  plot(x,y,'x') 
%   hold on
%  plot(x+1,y1,'o')
%  plot(x+2,y2,'d')
%  plot(x+3,y3,'v')
 notBoxPlot(yy,1,'style','sdline')
  hold on

 notBoxPlot(yy1,2,'style','sdline')
  hold on
 notBoxPlot(yy2,3,'style','sdline')
    set(gca,'XLim',[0 N+1],'XTick',1:N,'XTickLabel',str_cum_timepoints,'fontweight','bold','fontsize',14);
%     title('Cummulative')
    ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')
%   title('Meandering Index')

%% -Phagosight%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure('Color',[1 1 1]);ylim([ymin ymax]) 
  %  xlim([0 2])
%  plot(x,y,'x') 
%   hold on
%  plot(x+1,y1,'o')
%  plot(x+2,y2,'d')
%  plot(x+3,y3,'v')
 notBoxPlot(z,1,'style','sdline')
    set(gca,'XLim',[0 2],'XTick',1,'XTickLabel','30-120min','fontweight','bold','fontsize',14);
%     title('Phagosight')
%   title('Meandering Index')
ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')

