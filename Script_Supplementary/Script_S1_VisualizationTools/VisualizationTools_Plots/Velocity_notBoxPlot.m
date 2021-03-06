% 5/06/17 Evaluation of 5 metrics of interest 
% meandering index, velocity, static ratio, directionality and persistence
close all;
str_int_timepoints  =['30- 59 min';'60- 89 min';'90-120 min'];
str_cum_timepoints  =['30- 60 min';'30- 90 min';'30-120 min'];
micronsPerPixel     = PARAMETERS.Parameter2;   % LateralPixelResolution  
N                   =length(str_int_timepoints);
% input_metric        =input('What metric SM. velocity , tortuosity,meandering, staticratio, directionality and persistence ...');
input_metric = SM.velocity;
%--metrics of interest
    zy                   =input_metric.interval{1};
    zy1                  =input_metric.interval{2};
    zy2                  =input_metric.interval{3};
    yy                  =input_metric.cum{1};
    yy1                 =input_metric.cum{2};
    yy2                 =input_metric.cum{3};
    yyy                   =input_metric.intervalsm{1}*micronsPerPixel;
    yyy1                  =input_metric.intervalsm{2}*micronsPerPixel;
    yyy2                  =input_metric.intervalsm{3}*micronsPerPixel;
    z                   =input_metric.phagosight;
    x                   = 1;
    N                   = 3;
    %--for velocity
            zy                   =input_metric.interval{1}*micronsPerPixel;
            zy1                  =input_metric.interval{2}*micronsPerPixel;
            zy2                  =input_metric.interval{3}*micronsPerPixel;
            yy                  =input_metric.cum{1}*micronsPerPixel;
            yy1                 =input_metric.cum{2}*micronsPerPixel;
            yy2                 =input_metric.cum{3}*micronsPerPixel;
            z                   =input_metric.phagosight*micronsPerPixel;
ymax    = 10;
ymin    = 0;
%% -Interval%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color',[1 1 1]);ylim([ymin ymax])
%  plot(x,y,'x') 
%   hold on
%  plot(x+1,y1,'o')
%  plot(x+2,y2,'d')
%  plot(x+3,y3,'v')
 notBoxPlot(zy,1,'style','sdline')
  hold on

 notBoxPlot(zy1,2,'style','sdline')
  hold on

 notBoxPlot(zy2,3,'style','sdline')
    set(gca,'XLim',[0 N+1],'XTick',1:N,'XTickLabel',str_int_timepoints,'fontweight','bold','fontsize',14);
    title('Interval gtSM')
    ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')
%   title('Meandering Index')
%   set(gca,'fontweight','bold','fontsize',18)
%% -IntervalSM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Color',[1 1 1]);ylim([ymin ymax])
%  plot(x,y,'x') 
%   hold on
%  plot(x+1,y1,'o')
%  plot(x+2,y2,'d')
%  plot(x+3,y3,'v')
 notBoxPlot(yyy,1,'style','sdline')
  hold on

 notBoxPlot(yyy1,2,'style','sdline')
  hold on

 notBoxPlot(yyy2,3,'style','sdline')
    set(gca,'XLim',[0 N+1],'XTick',1:N,'XTickLabel',str_int_timepoints,'fontweight','bold','fontsize',14);
%     title('Interval')
    ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')
%   title('Meandering Index')
%   set(gca,'fontweight','bold','fontsize',18)

%% -Cummulative%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str_cumZ_timepoints  =['30- 60 min';'30- 90 min';'30-120 min';'Phagosight'];
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
   hold on
 notBoxPlot(z,4,'style','sdline')
  hold on
    set(gca,'XLim',[0 4+1],'XTick',1:4,'XTickLabel',str_cumZ_timepoints,'fontweight','bold','fontsize',14);
%     title('Cummulative')
    ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')
%   title('Meandering Index')
 %% -Phagosight%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     figure('Color',[1 1 1]);ylim([ymin ymax]) 
%   %  xlim([0 2])
% %  plot(x,y,'x') 
% %   hold on
% %  plot(x+1,y1,'o')
% %  plot(x+2,y2,'d')
% %  plot(x+3,y3,'v')
%  notBoxPlot(z,1,'style','sdline')
%     set(gca,'XLim',[0 2],'XTick',1,'XTickLabel','30-120min','fontweight','bold','fontsize',14);
% %     title('Phagosight')
% %   title('Meandering Index')
% ylabel('Absolute Velocity(um/min) ','fontsize',18,'fontweight','bold')

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
zstat=[npstat;pstat];
yyys=[yyy;yyy1;yyy2;z];
yys=[yy;yy1;yy2];
zzz=vertcat(yys,yyys);
% ys=[y;y1;y2];
%% Mann-Whitney-Wilcoxon non parametric test for two unpaired groups
% Stats = mwwtest(y,z); % good
% Stats = mwwtest(y1,z); % good
% Stats = mwwtest(y2,z); % good
% Stats = mwwtest(yy,z); % good
% Stats = mwwtest(yy1,z); % good
% Stats = mwwtest(yy2,z); % good
% %---
% Stats = mwwtest(y,yy); % good
% Stats = mwwtest(y,yy1); % good
% Stats = mwwtest(y,yy2); % good
% %--
% Stats = mwwtest(y1,yy); % good
% Stats = mwwtest(y1,yy1); % good
% Stats = mwwtest(y1,yy2); % good
% %--
% Stats = mwwtest(y2,yy); % good
% Stats = mwwtest(y2,yy1); % good
% Stats = mwwtest(y2,yy2); % good

%% One Way Anova1
% tig=[yy',yy1',yy2'];
% anova1(tig)
% 
% tig=[yyy',yyy1',yyy2'];
% anova1(tig)
