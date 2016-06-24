function []=plot_simulation_powers(select,pre1,pre2)
% Used to plot figure 1-8 used in tex. Run like

% total is usually 20.
% pre1 specifies the location to load data.
% pre2 specifies the location to save pictures.

%%
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-2));
p = genpath(rootDir);
gits=strfind(p,'.git');
colons=strfind(p,':');
for i=0:length(gits)-1
    endGit=find(colons>gits(end-i),1);
    p(colons(endGit-1):colons(endGit)-1)=[];
end
addpath(p);


%%
if nargin<1
    select=1;
end
if nargin<2
    pre1='../../Data/Results/'; % The folder to locate data
end
if nargin<3
    pre2='../../Figures/Fig'; % The folder to save figures
end
total=20;
%% Set colors
map1=zeros(7,3);
gr = [0,1,0];
ma = [1,0,1];
cy = [0,1,1];
cmap(1,:) = gr;
cmap(2,:) = ma;
cmap(3,:) = cy;
cmap(7,:) = [0 0 0];
dcorr = cmap(1,:);
mcorr = cmap(2,:);
mante = cmap(3,:);
HHG   = [0.5,0.5,0.5];
map1(1,:)=dcorr; map1(4,:)=dcorr; % The color for MGC{dcorr} and global dcorr.
map1(2,:)=mcorr; map1(5,:)=mcorr; % The color for MGC{mcorr} and global mcorr.
map1(3,:)=mante; map1(6,:)=mante; % The color for MGC{Mantel} and global Mantel.
map1(7,:)=HHG; % The color for HHG
if select==1
    map1(1,:)=mcorr; map1(4,:)=mcorr; % The color for MGC{dcorr} and global dcorr.
    map1(2,:)=mcorr; map1(5,:)=mante; % The color for MGC{Mantel} and global Mantel.
    map1(3,:)=HHG; % The color for HHG
end

set(groot,'defaultAxesColorOrder',map1);

ls{1}='-';
ls{2}='--';
ls{3}='.-';
ls{4}='.:';
ls{5}='.--';



%% figure1-4
figNumber='1DPower';
if select~=1
    figNumber='1DPowerAll';
end
figure('units','normalized','position',[0 0 1 1])
set(groot,'defaultAxesColorOrder',map1);
s=4;
t=5;
for j=1:total
    filename=strcat(pre1,'CorrIndTestType',num2str(j),'N100Dim1.mat');
    load(filename)
    subplot(s,t,j)
    titlechar=CorrSimuTitle(j);
    %
    if select==1
        plot(numRange,power2,ls{3},numRange,power5,ls{4},numRange,power7,ls{5},'LineWidth',3);
    else
        plot(numRange,power1,ls{3},numRange,power2,ls{3},numRange,power3,ls{3},numRange,power4,ls{4},numRange,power5,ls{4},numRange,power6,ls{4},numRange,power7,ls{5},'LineWidth',3);
    end
    xlim([numRange(1) numRange(end)]);
    ylim([0 1]);
    if j~=1 % Remove x&y axis ticks except type 16, which is at the left bottom
        set(gca,'XTick',[]); % Remove x axis ticks
        set(gca,'YTick',[]); % Remove y axis ticks
    end
    set(gca,'FontSize',14);
    title(titlechar,'FontSize',14);
end
xlabel('Sample Size','position',[-200 -0.2],'FontSize',20);
ylabel('Empirical Testing Power','position',[-515 3],'FontSize',20);
h=suptitle('Testing Powers for 20 Simulated 1-Dimensional Settings');
set(h,'FontSize',24,'FontWeight','normal');
lgdPosition = [0.03, 0.85, .05, .05]; %Legend Position
if select==1;
    h=legend('MGC','Mcorr','HHG','Location',lgdPosition);
else
    h=legend('MGC_{D}','MGC_{M}','MGC_{P}','Dcorr','Mcorr','Mantel','HHG','Location',lgdPosition);
end
legend boxoff
set(h,'FontSize',14);
%
F.fname=[strcat(pre2, figNumber)]; %, '_', num2str(cm)];
F.wh=[8 4]*2;
print_fig(gcf,F)

%% Plot 5-8
% if select==1;
% map1(1,:)=mcorr; map1(3,:)=mcorr; % The color for MGC{dcorr} and global dcorr.
% map1(2,:)=HHG; % The color for HHG
% end

figNumber='HDPower';
if select~=1
    figNumber='HDPowerAll';
end
figure('units','normalized','position',[0 0 1 1])
set(groot,'defaultAxesColorOrder',map1)
s=4;
t=5;
for j=1:total
    filename=strcat(pre1,'CorrIndTestDimType',num2str(j),'N100Dim.mat');
    load(filename)
    numRange=dimRange;
    subplot(s,t,j)
    titlechar=CorrSimuTitle(j);
    if select==1
        plot(numRange,power2,ls{3},numRange,power5,ls{4},numRange,power7,ls{5},'LineWidth',3);
    else
        plot(numRange,power1,ls{3},numRange,power2,ls{3},numRange,power3,ls{3},numRange,power4,ls{4},numRange,power5,ls{4},numRange,power6,ls{4},numRange,power7,ls{5},'LineWidth',3);
    end
    xlim([numRange(1) numRange(end)]);
    ylim([0 1]);
    if j~=1 % Remove x&y axis ticks except type 16, which is at the left bottom
        %set(gca,'XTick',[]); % Remove x axis ticks
        set(gca,'YTick',[]); % Remove y axis ticks
    end
    set(gca,'FontSize',12);
    title(titlechar,'FontSize',14);
end
xlabel('Dimension','position',[-200 -0.2],'FontSize',20);
ylabel('Empirical Testing Power','position',[-515 3],'FontSize',20);
h=suptitle('Testing Powers for 20 Simulated High-Dimensional Settings');
set(h,'FontSize',24,'FontWeight','normal');
lgdPosition = [0.03, 0.85, .05, .05]; %Legend Position
if select==1;
    h=legend('MGC','Mcorr','HHG','Location',lgdPosition);
else
    h=legend('MGC_{D}','MGC_{M}','MGC_{P}','Dcorr','Mcorr','Mantel','HHG','Location',lgdPosition);
end
set(h,'FontSize',14);
legend boxoff
%
F.fname=strcat(pre2, figNumber);
F.wh=[8 4]*2;
print_fig(gcf,F)