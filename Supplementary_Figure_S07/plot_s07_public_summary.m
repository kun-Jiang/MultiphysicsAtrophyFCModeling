%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
clinical = readtable(sourceWorkbook,'Sheet','Figure S07','Range','A9:F13', ...
    'VariableNamingRule','preserve');
follow = readtable(sourceWorkbook,'Sheet','Figure S07','Range','A18:F21', ...
    'VariableNamingRule','preserve');
cnColour = [0 0.4470 0.7410];
mciColour = [0.8500 0.3250 0.0980];
adColour = [0.6350 0.0780 0.1840];

%% Figure S7a: MMSE quartile summary
q = clinical(strcmp(clinical.measure,'mmse'),:);
qCN = q(strcmp(q.group,'CN'),:);
qAD = q(strcmp(q.group,'AD'),:);
figure('Color','w'); hold on;
patch([0.75 1.25 1.25 0.75],[qCN.q1 qCN.q1 qCN.q3 qCN.q3],cnColour, ...
    'FaceAlpha',0.30,'EdgeColor',cnColour,'LineWidth',1.4);
plot([0.75 1.25],[qCN.median qCN.median],'-','Color',cnColour,'LineWidth',2.2);
patch([1.75 2.25 2.25 1.75],[qAD.q1 qAD.q1 qAD.q3 qAD.q3],adColour, ...
    'FaceAlpha',0.30,'EdgeColor',adColour,'LineWidth',1.4);
plot([1.75 2.25],[qAD.median qAD.median],'-','Color',adColour,'LineWidth',2.2);
hold off; box on; xlim([0.5 2.5]);
set(gca,'XTick',1:2,'XTickLabel',{sprintf('CN (%d)',qCN.n),sprintf('AD (%d)',qAD.n)});
ylabel('MMSE');
exportgraphics(gcf,fullfile(here,'s07a_mmse_summary.png'),'Resolution',300);

%% Figure S7b: CDR sum-of-boxes quartile summary
q = clinical(strcmp(clinical.measure,'cdrsb'),:);
qCN = q(strcmp(q.group,'CN'),:);
qAD = q(strcmp(q.group,'AD'),:);
figure('Color','w'); hold on;
patch([0.75 1.25 1.25 0.75],[qCN.q1 qCN.q1 qCN.q3 qCN.q3],cnColour, ...
    'FaceAlpha',0.30,'EdgeColor',cnColour,'LineWidth',1.4);
plot([0.75 1.25],[qCN.median qCN.median],'-','Color',cnColour,'LineWidth',2.2);
patch([1.75 2.25 2.25 1.75],[qAD.q1 qAD.q1 qAD.q3 qAD.q3],adColour, ...
    'FaceAlpha',0.30,'EdgeColor',adColour,'LineWidth',1.4);
plot([1.75 2.25],[qAD.median qAD.median],'-','Color',adColour,'LineWidth',2.2);
hold off; box on; xlim([0.5 2.5]);
set(gca,'XTick',1:2,'XTickLabel',{sprintf('CN (%d)',qCN.n),sprintf('AD (%d)',qAD.n)});
ylabel('CDR sum of boxes');
exportgraphics(gcf,fullfile(here,'s07b_cdrsb_summary.png'),'Resolution',300);

%% Figure S7c: follow-up summary
qCN = follow(strcmp(follow.group,'CN'),:);
qMCI = follow(strcmp(follow.group,'MCI'),:);
qAD = follow(strcmp(follow.group,'AD'),:);
figure('Color','w'); hold on;
patch([0.75 1.25 1.25 0.75],[qCN.q1 qCN.q1 qCN.q3 qCN.q3],cnColour, ...
    'FaceAlpha',0.30,'EdgeColor',cnColour,'LineWidth',1.4);
plot([0.75 1.25],[qCN.median qCN.median],'-','Color',cnColour,'LineWidth',2.2);
text(1,qCN.q3+0.12,sprintf('%d/%d',qCN.n_at_least_2yr,qCN.n), ...
    'HorizontalAlignment','center','FontSize',10);
patch([1.75 2.25 2.25 1.75],[qMCI.q1 qMCI.q1 qMCI.q3 qMCI.q3],mciColour, ...
    'FaceAlpha',0.30,'EdgeColor',mciColour,'LineWidth',1.4);
plot([1.75 2.25],[qMCI.median qMCI.median],'-','Color',mciColour,'LineWidth',2.2);
text(2,qMCI.q3+0.12,sprintf('%d/%d',qMCI.n_at_least_2yr,qMCI.n), ...
    'HorizontalAlignment','center','FontSize',10);
patch([2.75 3.25 3.25 2.75],[qAD.q1 qAD.q1 qAD.q3 qAD.q3],adColour, ...
    'FaceAlpha',0.30,'EdgeColor',adColour,'LineWidth',1.4);
plot([2.75 3.25],[qAD.median qAD.median],'-','Color',adColour,'LineWidth',2.2);
text(3,qAD.q3+0.12,sprintf('%d/%d',qAD.n_at_least_2yr,qAD.n), ...
    'HorizontalAlignment','center','FontSize',10);
yline(2,'--','2 yr criterion','Color',[0.4 0.4 0.4], ...
    'LabelHorizontalAlignment','right');
hold off; box on; xlim([0.5 3.5]);
set(gca,'XTick',1:3,'XTickLabel',{'CN','MCI','AD'});
ylabel('follow-up span (years)');
exportgraphics(gcf,fullfile(here,'s07c_followup_summary.png'),'Resolution',300);
