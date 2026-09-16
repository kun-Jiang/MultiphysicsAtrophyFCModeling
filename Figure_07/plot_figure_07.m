%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
T = readtable(sourceWorkbook,'Sheet','Figure 07','Range','A7:E75', ...
    'VariableNamingRule','preserve');
V = readtable(sourceWorkbook,'Sheet','Figure 07','Range','A80:L86', ...
    'VariableNamingRule','preserve');
F = readtable(sourceWorkbook,'Sheet','Figure 07','Range','A91:K97', ...
    'VariableNamingRule','preserve');
Y = V{:,2:end};

cnColour = [0.0000 0.4471 0.7412];
adColour = [0.8510 0.3255 0.0980];

%% Figure 7a: rate correlation
x = T.rate_ad;
y = T.sim_rate;
fitLine = polyfit(x,y,1);
xx = linspace(min(x),max(x),200);
figure('Color','w','Units','centimeters','Position',[2 2 8.9 7.0]);
scatter(x,y,18,'filled'); hold on;
plot(xx,polyval(fitLine,xx),'-','Color',[0.5 0.5 0.5],'LineWidth',1.3);
hold off; box on;
xlabel('Exp rate (%/year)'); ylabel('Sim rate (%/year)');
xlim([-4 0]); ylim([-5 -0.5]); xticks(-4:1:0); yticks(-5:1:-1);
exportgraphics(gcf,fullfile(here,'figure_07a_rate_correlation.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_07a_rate_correlation.fig'));

%% Figure 7a: ROI rate profiles
figure('Color','w','Units','centimeters','Position',[2 2 8.9 7.0]);
plot(1:height(T),T.rate_ad,'Color',cnColour,'LineWidth',1.1); hold on;
plot(1:height(T),T.sim_rate,'Color',adColour,'LineWidth',1.1);
hold off; box on;
ylabel('Rate (%/year)'); xlim([0 68]); ylim([-6 0]);
xticks([0 20 40 60 68]); yticks(-6:2:0);
legend({'Exp-AD','Sim'},'Location','southeast');
exportgraphics(gcf,fullfile(here,'figure_07a_roi_rate_profiles.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_07a_roi_rate_profiles.fig'));

%% Figure 7b: protein-induced atrophy and empirical delta FC
mask = T.sim_rate_protein<0;
x = T.sim_rate_protein(mask);
y = T.diff_fc(mask);
fitLine = polyfit(x,y,1);
xx = linspace(min(x),max(x),200);
figure('Color','w');
scatter(x,y,45,'filled'); hold on;
plot(xx,polyval(fitLine,xx),'k-','LineWidth',2);
hold off; box on;
xlabel('Protein induced atrophy (%/y)'); ylabel('\Delta FC (%)');
exportgraphics(gcf,fullfile(here,'figure_07b_atrophy_fc_association.png'),'Resolution',300);

%% Figure 7c: entorhinal
rows = find(strcmp(string(F.region),'Entorhinal'));
leftRow = rows(strcmp(string(F.hemisphere(rows)),'Left'));
rightRow = rows(strcmp(string(F.hemisphere(rows)),'Right'));
leftVolumeRow = find(strcmp(string(V.roi_name),string(F.roi_name(leftRow))),1);
rightVolumeRow = find(strcmp(string(V.roi_name),string(F.roi_name(rightRow))),1);

figure('Color','w','Units','centimeters','Position',[2 2 8.9 7.0]); hold on;
xCN = linspace(F.cn_time_start_years(leftRow),F.cn_time_end_years(leftRow),200);
hCN = plot(xCN,F.cn_slope_per_year(leftRow).*xCN+F.cn_intercept(leftRow),'-','Color',cnColour);
xAD = linspace(F.ad_time_start_years(leftRow),F.ad_time_end_years(leftRow),200);
hAD = plot(xAD,F.ad_slope_per_year(leftRow).*xAD+F.ad_intercept(leftRow),'-','Color',adColour);
hSim = plot(0:6,Y(leftVolumeRow,5:end)./Y(leftVolumeRow,5),'-o','Color','k', ...
    'MarkerSize',3.5,'MarkerFaceColor','none');
xCN = linspace(F.cn_time_start_years(rightRow),F.cn_time_end_years(rightRow),200);
plot(xCN,F.cn_slope_per_year(rightRow).*xCN+F.cn_intercept(rightRow),'--','Color',cnColour);
xAD = linspace(F.ad_time_start_years(rightRow),F.ad_time_end_years(rightRow),200);
plot(xAD,F.ad_slope_per_year(rightRow).*xAD+F.ad_intercept(rightRow),'--','Color',adColour);
plot(0:6,Y(rightVolumeRow,5:end)./Y(rightVolumeRow,5),'--o','Color','k', ...
    'MarkerSize',3.5,'MarkerFaceColor','none');
hold off; box on;
xlabel('Time/year'); ylabel('Volume'); xlim([0 9]); ylim([0.68 1.005]);
xticks(0:2:8); yticks(0.7:0.1:1.0);
legend([hCN hAD hSim],{'Exp-CN','Exp-AD','Sim'},'Location','southwest');
exportgraphics(gcf,fullfile(here,'figure_07c_entorhinal.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_07c_entorhinal.fig'));

%% Figure 7c: hippocampus
rows = find(strcmp(string(F.region),'Hippocampus'));
leftRow = rows(strcmp(string(F.hemisphere(rows)),'Left'));
rightRow = rows(strcmp(string(F.hemisphere(rows)),'Right'));
leftVolumeRow = find(strcmp(string(V.roi_name),string(F.roi_name(leftRow))),1);
rightVolumeRow = find(strcmp(string(V.roi_name),string(F.roi_name(rightRow))),1);

figure('Color','w','Units','centimeters','Position',[2 2 8.9 7.0]); hold on;
xCN = linspace(F.cn_time_start_years(leftRow),F.cn_time_end_years(leftRow),200);
hCN = plot(xCN,F.cn_slope_per_year(leftRow).*xCN+F.cn_intercept(leftRow),'-','Color',cnColour);
xAD = linspace(F.ad_time_start_years(leftRow),F.ad_time_end_years(leftRow),200);
hAD = plot(xAD,F.ad_slope_per_year(leftRow).*xAD+F.ad_intercept(leftRow),'-','Color',adColour);
hSim = plot(0:6,Y(leftVolumeRow,5:end)./Y(leftVolumeRow,5),'-o','Color','k', ...
    'MarkerSize',3.5,'MarkerFaceColor','none');
xCN = linspace(F.cn_time_start_years(rightRow),F.cn_time_end_years(rightRow),200);
plot(xCN,F.cn_slope_per_year(rightRow).*xCN+F.cn_intercept(rightRow),'--','Color',cnColour);
xAD = linspace(F.ad_time_start_years(rightRow),F.ad_time_end_years(rightRow),200);
plot(xAD,F.ad_slope_per_year(rightRow).*xAD+F.ad_intercept(rightRow),'--','Color',adColour);
plot(0:6,Y(rightVolumeRow,5:end)./Y(rightVolumeRow,5),'--o','Color','k', ...
    'MarkerSize',3.5,'MarkerFaceColor','none');
hold off; box on;
xlabel('Time/year'); ylabel('Volume'); xlim([0 9]); ylim([0.68 1.005]);
xticks(0:2:8); yticks(0.7:0.1:1.0);
legend([hCN hAD hSim],{'Exp-CN','Exp-AD','Sim'},'Location','southwest');
exportgraphics(gcf,fullfile(here,'figure_07c_hippocampus.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_07c_hippocampus.fig'));

%% Figure 7c: amygdala
rows = find(strcmp(string(F.region),'Amygdala'));
leftRow = rows(strcmp(string(F.hemisphere(rows)),'Left'));
rightRow = rows(strcmp(string(F.hemisphere(rows)),'Right'));
leftVolumeRow = find(strcmp(string(V.roi_name),string(F.roi_name(leftRow))),1);
rightVolumeRow = find(strcmp(string(V.roi_name),string(F.roi_name(rightRow))),1);

figure('Color','w','Units','centimeters','Position',[2 2 8.9 7.0]); hold on;
xCN = linspace(F.cn_time_start_years(leftRow),F.cn_time_end_years(leftRow),200);
hCN = plot(xCN,F.cn_slope_per_year(leftRow).*xCN+F.cn_intercept(leftRow),'-','Color',cnColour);
xAD = linspace(F.ad_time_start_years(leftRow),F.ad_time_end_years(leftRow),200);
hAD = plot(xAD,F.ad_slope_per_year(leftRow).*xAD+F.ad_intercept(leftRow),'-','Color',adColour);
hSim = plot(0:6,Y(leftVolumeRow,5:end)./Y(leftVolumeRow,5),'-o','Color','k', ...
    'MarkerSize',3.5,'MarkerFaceColor','none');
xCN = linspace(F.cn_time_start_years(rightRow),F.cn_time_end_years(rightRow),200);
plot(xCN,F.cn_slope_per_year(rightRow).*xCN+F.cn_intercept(rightRow),'--','Color',cnColour);
xAD = linspace(F.ad_time_start_years(rightRow),F.ad_time_end_years(rightRow),200);
plot(xAD,F.ad_slope_per_year(rightRow).*xAD+F.ad_intercept(rightRow),'--','Color',adColour);
plot(0:6,Y(rightVolumeRow,5:end)./Y(rightVolumeRow,5),'--o','Color','k', ...
    'MarkerSize',3.5,'MarkerFaceColor','none');
hold off; box on;
xlabel('Time/year'); ylabel('Volume'); xlim([0 9]); ylim([0.68 1.005]);
xticks(0:2:8); yticks(0.7:0.1:1.0);
legend([hCN hAD hSim],{'Exp-CN','Exp-AD','Sim'},'Location','southwest');
exportgraphics(gcf,fullfile(here,'figure_07c_amygdala.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_07c_amygdala.fig'));
