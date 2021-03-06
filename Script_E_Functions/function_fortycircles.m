

Tr0=OriginalImgTR;
subplot(2,2,1),imshow(bw);
subplot(2,2,2),imshow(Tr0);
AIDS={0};
aids=(0);
clear combo
clear noncombo
for J=1:iterations;
    % Shortcut summary goes here
    I=Tr0;
    i=1;
    [ix,iy]=size(I);
    %%%%Draw Circles 
    if i==1 || i==3  %or statement
        disp('Select right above notochord line to being CTCF')
        close all; f=figure(1);imagesc(I); title('ROS REGION');
        [x, y] = getline(f);
    else
    end;
    hold on
    plot(x,y,'LineWidth',2,'Color','r')
    plot(x(1),y(1),'c*','LineWidth',2)
    plot(x(2),y(2),'y*','LineWidth',2)
    hold on
    d=pdist([x(1),y(1);x(2),y(2)]);
%     diameter=10;
    radius=diameter/2;
    n=d/diameter;
    num=round(n)-1; %number of circle points per line
    if num>10
        num=10;
    else
    end;
    %% -figure out the line equation for the one drawn
    coefficients = polyfit([x(1), x(2)], [y(1), y(2)], 1);
    a = coefficients (1);
    b = coefficients (2);
    xmin=min(x(1:2));
    xmax=max(x(1:2));
    ymin=min(y(1:2));
    ymax=max(y(1:2));
    f=figure(1);imagesc(Tr0); hold on
      funct= linspace(xmin,xmax, num); % Adapt n for resolution of graph
      y= a*funct+b;  
      plot(funct,y); hold on
    %  funct=(y-b)/a;

    lens=length(funct);    
    Img_cmask={0};
    mmpi=(0);
        for i=1:lens
            %---showing purposes
            x_i                 = funct(i);
            y_i                 = y(i);
            [xoc yoc]           = circle([x_i y_i], 5, 1000); % outer circle
            plot(xoc, yoc, '-','linewidth',2,'color','g')%'color',0.5.*rand(1,3));
            %---masking purposes
            cx=x_i;cy=y_i;r     = radius;
            [xm,ym]             = meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
            c_mask              =((xm.^2+ym.^2)<=r^2); %circle mask
            cc_mask             = c_mask & bw; %corrected circle mask to be inside fish only
            MaskPixelNum        = sum(sum(cc_mask));        
            MaskPixelIntensity  = sum(sum(uint16(cc_mask).*Tr0))/MaskPixelNum;
            mmpi(i)             = MaskPixelIntensity;
            Img_noncmask{i} = c_mask;
            Img_cmask{i}    = cc_mask;
            if i==1
                noncombo=c_mask;
                combo=cc_mask;
            else
                noncombo=noncombo + c_mask;
                combo=combo + cc_mask;
                combo=im2bw(combo);
            end;

            hold on
        end
    Img_noncombomask{J}=noncombo;
    Img_combomask{J}=combo;

    AIDS{J}=mmpi;
    aids(J)=mean(mmpi);
        %%   
    if J==1
        canvas=Tr0;
        noncanvas=Tr0;
    else
    end;
    
    for i=1:lens
%         figure();imshow(Tr0);
        noncanvas=imoverlay(noncanvas,Img_noncmask{i},[1 0 0]);
        canvas=imoverlay(canvas,Img_cmask{i},[1 0 0]);
    end;
end;
%%
pupper=[AIDS{:}];
MMPI=nanmean(pupper);
clear mask_combo
clear mask_noncombo

for ii=1:iterations
    if ii==1
        mask_combo=Img_combomask{ii};
    else        
        mask_combo=mask_combo + Img_combomask{ii};
    end;
%mask_noncombo=Img_noncombomask{1}+Img_noncombomask{2}+Img_noncombomask{3}+Img_noncombomask{4};
%mask_combo=Img_combomask{1}+Img_combomask{2}+Img_combomask{3}+Img_combomask{4};

end;

mask_combo=im2bw(mask_combo);   
%% 
figure()
subplot(2,2,1),imshow(bw);
subplot(2,2,2),imshow(Tr0);
subplot(2,2,3),imshow(canvas);
subplot(2,2,4),imshow(mask_combo);