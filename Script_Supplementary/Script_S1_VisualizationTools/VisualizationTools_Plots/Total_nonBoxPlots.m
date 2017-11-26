% 5/06/17 Evaluation of 5 metrics of interest 
% meandering index, velocity, static ratio, directionality and persistence
close all;

micronsPerPixel             = PARAMETERS.Parameter2;   % LateralPixelResolution  
str_int_timepoints          =['30- 59 min';'60- 89 min';'90-120 min'];
str_cum_timepoints          =['30- 60 min';'30- 90 min';'30-120 min'];
N                           = length(str_int_timepoints);
str_MetricType              ={'Velocity(um/min)','StaticRatio', 'MeanderingRatio',...
                                'Tortuosity(abu)','ForwardRatio','ForwardtoBackwardRatio'...
                                'WoundDistance(um)','WoundScore(1-4)'};
rawMetrics_MetricType       ={SM.velocity,SM.staticratio,SM.meandering,...
                                SM.tortuosity,SM.forward,SM.FBratio,...
                                SM.WoundScoreUm,SM.WoundScore1234};                        
input_metric                =input(strcat('Please Write Selected Metric e.g "SM.velocity" or ', ...
                                '"SM.staticratio" or "SM.meandering" or "SM.tortuosity" or ',...
                                '"SM.Forward'));
%--metrics of interest
    y                   =input_metric.interval{1};
    y1                  =input_metric.interval{2};
    y2                  =input_metric.interval{3};
    yy                  =input_metric.cum{1};
    yy1                 =input_metric.cum{2};
    yy2                 =input_metric.cum{3};
    yyy                   =input_metric.intervalsm{1}*micronsPerPixel;
    yyy1                  =input_metric.intervalsm{2}*micronsPerPixel;
    yyy2                  =input_metric.intervalsm{3}*micronsPerPixel;
    z                   =input_metric.phagosight;
    z                   =input_metric.phagosight;
    x                   = 1;
    %%%--for velocity
            y                   =input_metric.interval{1}*micronsPerPixel;
            y1                  =input_metric.interval{2}*micronsPerPixel;
            y2                  =input_metric.interval{3}*micronsPerPixel;
            yy                  =input_metric.cum{1}*micronsPerPixel;
            yy1                 =input_metric.cum{2}*micronsPerPixel;
            yy2                 =input_metric.cum{3}*micronsPerPixel;
            z                   =input_metric.phagosight*micronsPerPixel;
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
     title('Interval')
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
     title('Cumulative')
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
     title('Phagosight')
%   title('Meandering Index')
ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')
%% Statistics
npstat=(0);
pstat=(0);
%NOTE: h is only a logic signal to whether it hit the %5 statistical
%significance, it has nothing to do with parametric vs non parametric
%distribution
%     y                   =input_metric.interval{1};
%     y1                  =input_metric.interval{2};
%     y2                  =input_metric.interval{3};
%     yy                  =input_metric.cum{1};
%     yy1                 =input_metric.cum{2};
%     yy2                 =input_metric.cum{3};
%     z                   =input_metric.phagosight;
%Wilcoxon signed rank test.  - two sided nonparametric paired -p value
% [p,h,stats]    =signtest(yy1,z); %needs to be the same number of elements?!! what
% disp(p)
[p,h,stats]    =signrank(yy,yy1); %needs to be the same number of elements?!! what    
disp([h p]); npstat(1)=p;
[p,h,stats]    =signrank(yy,yy2); %needs to be the same number of elements?!! what    
disp([h p]); npstat(2)=p;
[p,h,stats]    =signrank(yy1,yy2); %needs to be the same number of elements?!! what 
disp([h p]); npstat(3)=p;

[p,h,stats]    =signrank(yyy,yyy1); %needs to be the same number of elements?!! what    
disp([h p]); npstat(4)=p;
[p,h,stats]    =signrank(yyy,yyy2); %needs to be the same number of elements?!! what    
disp([h p]); npstat(5)=p;
[p,h,stats]    =signrank(yyy1,yyy2); %needs to be the same number of elements?!! what 
disp([h p]); npstat(6)=p;

[p,h,stats]    =signrank(yy,z); %needs to be the same number of elements?!! what    
disp([h p]); npstat(7)=p;
[p,h,stats]    =signrank(yy1,z); %needs to be the same number of elements?!! what    
disp([h p]); npstat(8)=p;
[p,h,stats]    =signrank(yy2,z); %needs to be the same number of elements?!! what    
disp([h p]); npstat(9)=p;
[p,h,stats]    =signrank(yyy,z); %needs to be the same number of elements?!! what    
disp([h p]); npstat(10)=p;
[p,h,stats]    =signrank(yyy1,z); %needs to be the same number of elements?!! what    
disp([h p]); npstat(11)=p;
[p,h,stats]    =signrank(yyy2,z); %needs to be the same number of elements?!! what    
disp([h p]); npstat(12)=p;


% tttest is for two sided parametric paired p value
%cum
[h,p,stats]    =ttest(yy,yy1); %needs to be the same number of elements?!! what    
disp([h p]); pstat(1)=p;
[h,p,stats]    =ttest(yy,yy2); %needs to be the same number of elements?!! what    
disp([h p]); pstat(2)=p;
[h,p,stats]    =ttest(yy1,yy2); %needs to be the same number of elements?!! what    
disp([h p]); pstat(3)=p;
%intervalSM
[h,p,stats]    =ttest(yyy,yyy1); %needs to be the same number of elements?!! what    
disp([h p]); pstat(4)=p;
[h,p,stats]    =ttest(yyy,yyy2); %needs to be the same number of elements?!! what    
disp([h p]); pstat(5)=p;
[h,p,stats]    =ttest(yyy1,yyy2); %needs to be the same number of elements?!! what    
disp([h p]); pstat(6)=p;
%phago
[h,p,stats]    =ttest(yy,z); %needs to be the same number of elements?!! what    
disp([h p]); pstat(7)=p;
[h,p,stats]    =ttest(yy1,z); %needs to be the same number of elements?!! what    
disp([h p]); pstat(8)=p;
[h,p,stats]    =ttest(yy2,z); %needs to be the same number of elements?!! what    
disp([h p]); pstat(9)=p;
[h,p,stats]    =ttest(yyy,z); %needs to be the same number of elements?!! what    
disp([h p]); pstat(10)=p;
[h,p,stats]    =ttest(yyy1,z); %needs to be the same number of elements?!! what    
disp([h p]); pstat(11)=p;
[h,p,stats]    =ttest(yyy2,z); %needs to be the same number of elements?!! what    
disp([h p]); pstat(12)=p;
% ttest2 is for two sided parametric unpaired p value
% [h,p,stats]    =ttest2(y,y2); %needs to be the same number of elements?!! what    
% disp([h p])
% [h,p,stats]    =ttest2(yy1,z); %needs to be the same number of elements?!! what    
% disp([h p])
% [h,p,stats]    =ttest2(yy2,z); %needs to be the same number of elements?!! what    
% disp([h p])
% [h,p,stats]    =ttest2(yyy,z); %needs to be the same number of elements?!! what    
% disp([h p])
% [h,p,stats]    =ttest2(yyy1,z); %needs to be the same number of elements?!! what    
% disp([h p])
% [h,p,stats]    =ttest2(yyy2,z); %needs to be the same number of elements?!! what    
% disp([h p])
zstat       =[npstat;pstat];
yyys        =[yyy;yyy1;yyy2;z];     %intervalsm -- 70% per total track as defined by that interval (therefore needs to be in ALL intervals)
yys         =[yy;yy1;yy2];          %cum
ys          =[y;y1;y2];             %interval  -- 90% per that interval
zzz         = vertcat(yys,yyys);
% ys=[y;y1;y2];

%% Clear Variables
 clearvars -except Worthy SM Frame POI PARAMETERS ADP PhagoSight handles dataIn dataL dataR ch_GFP ch_Ph2

