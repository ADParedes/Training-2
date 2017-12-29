% 12/14/2017 Non Parameteric Statistics 
% meandering index, velocity, static ratio, directionality and persistence
clear all
close all;
str_int_timepoints  =['60 ';'120'];
str_cum_timepoints  =['60 ';'120'];

%3J
A{1}={-4	-14	-10	3	-33	-14	-1	-23};
A{2}={-10	-12	-11	-5	-31	-19	-2	-26};
A{3}={1  1 1 1 1 1 1 1};
%Control
B{1}={-1	-9	-21	1	5	-16};
B{2}={6	0	-26	0	4	-6};
B{3}={1 1 1 1 1 1 1};

C{1}={56	16	-3	-7	15	8};
C{2}={32	30	2	25	10	11};
C{3}={ 1 1 1 1 1 1};

%--metrics of interest
yy                  =[C{1}{:}];
yy1                 =[C{2}{:}];
yy2                 =[C{3}{:}];
z                   =[B{1}{:}];
xx=[B{1}{:}];
xx1=[B{2}{:}];
xx2=[B{3}{:}];
x                   = 1;
[N,~]                   = size(str_int_timepoints);
ymax    = max(yy2);
ymin    = 0;


%% -Cummulative%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str_cumZ_timepoints  =['30- 60';'30- 90';'30-120';'Others'];
    figure('Color',[1 1 1]);ylim([ymin ymax])

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
    ylabel('Non Parametric Distribution','fontsize',18,'fontweight','bold')
    xlabel('Time(minutes post injury)','fontsize',18,'fontweight','bold')
%   title('Meandering Index')


%% Wilcoxon signed rank test.  - two sided nonparametric paired -p value
npstat=(0);
pstat=(0);
%NOTE: h is only a logic signal to whether it hit the %5 statistical
%significance, it has nothing to do with parametric vs non parametric
%distribution
% [p,h,stats]    =signtest(yy1,z); %needs to be the same number of elements?!! what
% disp(p)
[p,h,stats]    =signrank(yy,yy1); %needs to be the same number of elements?!! what    
disp([h p]); npstat(1)=p;
[p,h,stats]    =signrank(yy,yy2); %needs to be the same number of elements?!! what    
disp([h p]); npstat(2)=p;
[p,h,stats]    =signrank(yy1,yy2); %needs to be the same number of elements?!! what 
disp([h p]); npstat(3)=p;

%% tttest is for two sided parametric paired p value
%cum
[h,p,stats]    =ttest(yy,yy1); %needs to be the same number of elements?!! what    
disp([h p]); pstat(1)=p;
[h,p,stats]    =ttest(yy,yy2); %needs to be the same number of elements?!! what    
disp([h p]); pstat(2)=p;
[h,p,stats]    =ttest(yy1,yy2); %needs to be the same number of elements?!! what    
disp([h p]); pstat(3)=p;

%% Non parametric Unpaired Statistic Test 
%E.G. Does not need to be the same number of elements
% X1=[181 183 170 173 174 179 172 175 178 ];
% X2=[168 165 163 175 176 166 163 174 175 173 179 180 176 167 176];
% STATS=mwwtest(X1,X2);
STATS1=mwwtest(yy,xx);
STATS2=mwwtest(yy1,xx1);
STATS3=mwwtest(yy2,xx2);
%% 
% disp([h p])
zstat=[npstat;pstat];
yys=[yy;yy1;yy2];


%% One Way Anova1
% tig=[yy',yy1',yy2'];
% anova1(tig)
% 
% tig=[yyy',yyy1',yyy2'];
% anova1(tig)
