% 12/14/2017 Non Parameteric Statistics 
% meandering index, velocity, static ratio, directionality and persistence
close all;
str_int_timepoints  =['30- 59';'60- 89';'90-120'];
str_cum_timepoints  =['30- 60';'30- 90';'30-120'];
%% 3J
%F:B Index
A{1}={0.4862485368	0.6126373626	0.3712505479	0.285054607	0.4909340659	0.4935309288	0.5984104437	0.3848958915	0.433692928	0.65625	0.1666666667	0.64};
A{2}={0.4724082933	0.5184113491	0.4510202276	0.2700418449	0.5077882408	0.6455415402	0.5918251712	0.4468493809	0.4242556596	0.3234117647	0.3237053177	0.499537037};
A{3}={0.4795962627	0.5106995325	0.4338832066	0.2675378936	0.506120768	0.6295247186	0.5336932205	0.4108562274	0.3923838159	0.3525372794	0.3772048892	0.401405634};
%Wound Distance
A{1}={45.6074	64.51203	41.26531	24.42195	34.15205	46.70834	28.93829	32.83941	33.12064	17.29175	1.476105	9.926496};
A{2}={105.312	102.4361	85.88958	45.96456	90.57649	149.6243	105.252	76.41799	60.85088	58.47228	21.62739	45.6651};
A{3}={153.0526	148.601	146.0181	78.92312	142.7806	231.4741	168.2826	103.8266	77.78569	127.2029	69.14058	54.90005};
%% other
%F:B Index

A{1}={0.222222222	0.282352941	0.5	-0.452380952	0.629734849	0.386109446	0.456597222		0.4
};
A{2}={0.103787879	0.337777778	0.488574272	-0.019927571	0.443013536	0.302252687	0.540542054		0.399934319
};
A{3}={0.148163453	0.288804483	0.351507469	0.122949698	0.432630394	0.281630818	0.516545131		0.415552195
};
% A{1}={};
% A{2}={};
% A{3}={};
% A{1}={};5
% A{2}={};
% A{3}={};
% A{1}={};
% A{2}={};
% A{3}={};
%% Control
%F:B Index
B{1}={0.292297046	0.245498483	0.612962963	0.235564757	0.19743804	0.201282051	0.258064516	0.128888889	0	0.321694319	0.533333333	0.34965035	0.6875	0.347750787	0.369369449	0.28282967	0.108199493	0.453379382	0.603261719	
};
B{2}={0.344223057	0.235192944	0.493712317	0.239168556	0.33500115	0.295279471	0.154590164	0.193763821	0.36947497	0.435385852	0.460952381	-0.002164502	0.181436211	0.520011947	0.480032284	0.521081675	0.451020228	0.320854058	0.475970697	0.585323187
};
B{3}={0.344223057	0.235192944	0.493712317	0.239168556	0.33500115	0.295279471	0.154590164	0.193763821	0.36947497	0.435385852	0.460952381	-0.002164502	0.181436211	0.520011947	0.480032284	0.521081675	0.451020228	0.320854058	0.475970697	0.585323187
};
% %Wound Distance
% B{1}={18.77513	30.52907	57.51956	28.46499	11.50841	6.191554	23.02721	1.112205	2.278802	15.6679	8.619583	15.57895	17.02315	41.89283	25.37196	22.36279	10.05708	22.9021	31.73669	
% };
% B{2}={47.91576	62.82222	84.91347	57.2342	45.93699	40.95458	70.17765	18.08855	29.16038	55.54814	32.38794	-2.53709	27.38802	68.52617	102.4251	86.91459	85.95015	63.11048	75.63418	81.83282
% };
% B{3}={83.55117	73.55034	107.1324	74.17035	69.85463	75.82525	68.28815	31.15386	61.26386	78.4048	63.59445	17.57436	62.88757	116.9378	169.4172	143.7566	138.3388	128.7397	98.27822	126.1317
% };
%--metrics of interest
yy                  =[A{1}{:}];
yy1                 =[A{2}{:}];
yy2                 =[A{3}{:}];
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

disp([STATS1.p(1);STATS2.p(1);STATS3.p(1)])
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
