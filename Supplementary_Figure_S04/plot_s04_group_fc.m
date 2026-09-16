%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
v = readtable(sourceWorkbook,'Sheet','Figure S04','Range','A7:D75', ...
    'VariableNamingRule','preserve');
k = readtable(sourceWorkbook,'Sheet','Figure S04','Range','A80:B148', ...
    'VariableNamingRule','preserve');
fcTable = readtable(sourceWorkbook,'Sheet','Figure S04','Range','A153:BQ221', ...
    'VariableNamingRule','preserve');

cn = v.fc_cn_mean;
ad = v.fc_ad_mean;

%% Figure S4b
lo = min([cn;ad]);
hi = max([cn;ad]);
figure('Color','w');
hline = plot([lo hi],[lo hi],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5); hold on;
scatter(cn,ad,50,[0.4660 0.6740 0.1880],'filled');
hold off; axis square; box on;
xlabel('empirical CN connectivity'); ylabel('empirical AD connectivity');
legend(hline,{'identity (y = x)'},'Location','northwest');
exportgraphics(gcf,fullfile(here,'s04b_empirical_cn_vs_ad.png'),'Resolution',300);

%% Figure S4a
FCcn = fcTable{:,2:end};
FCcn(1:size(FCcn,1)+1:end) = 0;
simBaseline = mean(sum(FCcn,2)/(size(FCcn,1)-1));
simPct = 100*k.dFC_atr/simBaseline;
figure('Color','w');
scatter(v.diff_fc,simPct,50,[0 0.4470 0.7410],'filled');
xline(0,'-','Color',[0.6 0.6 0.6]); yline(0,'-','Color',[0.6 0.6 0.6]); box on;
xlabel('empirical \DeltaFC (AD - CN, % of CN)');
ylabel('simulated \DeltaFC (% of sim. CN)');
exportgraphics(gcf,fullfile(here,'s04a_simulated_vs_empirical_dfc.png'),'Resolution',300);
