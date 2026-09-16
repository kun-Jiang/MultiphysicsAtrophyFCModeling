%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
E = readtable(sourceWorkbook,'Sheet','Figure S03','Range','A7:B15', ...
    'VariableNamingRule','preserve');
S = readtable(sourceWorkbook,'Sheet','Figure S03','Range','A22:A34', ...
    'VariableNamingRule','preserve');
P = readtable(sourceWorkbook,'Sheet','Figure S03','Range','A39:I48', ...
    'VariableNamingRule','preserve');

%% Figure S3d: seed definitions
schemeOrder = {'ento_left','PET_earliest_top2','hippocampus','paper_ento_bilateral', ...
    'ento_plus_PET_top2','amygdala','PET_earliest_top6','PET_earliest_top10'};
[~,order] = ismember(schemeOrder,string(E.scheme));
E = E(order,:);
schemeLabels = {'ento (left)','PET top-2','hippocampus','bilateral ento (paper)', ...
    'ento + PET-2','amygdala','PET top-6','PET top-10'};
S = S(isfinite(S.r_vs_empirical),:);
lo = min(S.r_vs_empirical);
hi = max(S.r_vs_empirical);
paper = find(strcmp(E.scheme,'paper_ento_bilateral'));

figure('Color','w'); hold on;
patch([lo hi hi lo],[0.65 0.65 1.35 1.35],[0.6 0.6 0.6], ...
    'FaceAlpha',0.25,'EdgeColor','none');
hbar = barh(2:height(E)+1,E.r_vs_empirical,'FaceColor','flat','EdgeColor','none');
hbar.CData = repmat([0 0.4470 0.7410],height(E),1);
hbar.CData(paper,:) = [0.6350 0.0780 0.1840];
hold off; box on;
xlim([min(0,lo)-0.02 max(E.r_vs_empirical)+0.04]);
xlabel('r vs empirical atrophy rate');
set(gca,'YTick',1:height(E)+1,'YTickLabel',[{'12 single-ROI seeds'},schemeLabels]);
exportgraphics(gcf,fullfile(here,'s03d_seed_definitions.png'),'Resolution',300);

%% Figure S3e: parameter robustness
seedCols = {'r_PET_top10','r_PET_top6','r_ento+PET_top2','r_paper_ento', ...
    'r_amygdala','r_hippocampus','r_PET_top2','r_ento_left'};
seedLabels = {'PET-10','PET-6','ento+PET-2','paper ento','amygdala','hippoc.','PET-2','ento (L)'};
M = P{:,seedCols};
paperRow = find(contains(string(P.tag),'paper'));
otherRows = setdiff(1:height(P),paperRow);

figure('Color','w'); hold on;
hOther = plot(1:numel(seedCols),M(otherRows,:)','-o','Color',[0.6 0.6 0.6], ...
    'LineWidth',1,'MarkerFaceColor',[0.6 0.6 0.6]);
hPaper = plot(1:numel(seedCols),M(paperRow,:),'-o','Color',[0.6350 0.0780 0.1840], ...
    'LineWidth',2,'MarkerFaceColor',[0.6350 0.0780 0.1840]);
hMean = plot(1:numel(seedCols),mean(M,1),'-s','Color',[0.15 0.15 0.15], ...
    'LineWidth',2.5,'MarkerFaceColor',[0.15 0.15 0.15]);
hold off; box on; ylabel('r vs empirical atrophy rate');
set(gca,'XTick',1:numel(seedCols),'XTickLabel',seedLabels,'XTickLabelRotation',45);
legend([hPaper hOther(1) hMean],{'the value used here (\kappa, \alpha, T)', ...
    '8 other (\kappa, \alpha, T) settings','mean over settings'},'Location','southoutside');
exportgraphics(gcf,fullfile(here,'s03e_parameter_robustness.png'),'Resolution',300);
