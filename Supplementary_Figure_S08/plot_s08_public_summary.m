%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
S = readtable(sourceWorkbook,'Sheet','Figure S08','Range','A9:F13', ...
    'VariableNamingRule','preserve');
V = readtable(sourceWorkbook,'Sheet','Figure S08','Range','A18:C86', ...
    'VariableNamingRule','preserve');
cnColour = [0 0.4470 0.7410];
adColour = [0.6350 0.0780 0.1840];

%% Figure S8a: aggregate follow-up summaries
cnFull = S(strcmp(S.group,'CN') & strcmp(S.window,'full'),:);
cnMatched = S(strcmp(S.group,'CN') & strcmp(S.window,'matched'),:);
adFull = S(strcmp(S.group,'AD') & strcmp(S.window,'full'),:);
adMatched = S(strcmp(S.group,'AD') & strcmp(S.window,'matched'),:);

figure('Color','w'); hold on;
patch([-0.25 0.25 0.25 -0.25],[cnFull.q1 cnFull.q1 cnFull.q3 cnFull.q3],cnColour, ...
    'FaceAlpha',0.30,'EdgeColor',cnColour,'LineWidth',1.4);
plot([-0.25 0.25],[cnFull.median cnFull.median],'-','Color',cnColour,'LineWidth',2.2);
text(0,cnFull.q3+0.08,sprintf('%.2f',cnFull.mean), ...
    'HorizontalAlignment','center','FontSize',10);
patch([0.75 1.25 1.25 0.75],[cnMatched.q1 cnMatched.q1 cnMatched.q3 cnMatched.q3],cnColour, ...
    'FaceAlpha',0.30,'EdgeColor',cnColour,'LineWidth',1.4);
plot([0.75 1.25],[cnMatched.median cnMatched.median],'-','Color',cnColour,'LineWidth',2.2);
text(1,cnMatched.q3+0.08,sprintf('%.2f',cnMatched.mean), ...
    'HorizontalAlignment','center','FontSize',10);
patch([2.35 2.85 2.85 2.35],[adFull.q1 adFull.q1 adFull.q3 adFull.q3],adColour, ...
    'FaceAlpha',0.30,'EdgeColor',adColour,'LineWidth',1.4);
plot([2.35 2.85],[adFull.median adFull.median],'-','Color',adColour,'LineWidth',2.2);
text(2.6,adFull.q3+0.08,sprintf('%.2f',adFull.mean), ...
    'HorizontalAlignment','center','FontSize',10);
patch([3.35 3.85 3.85 3.35],[adMatched.q1 adMatched.q1 adMatched.q3 adMatched.q3],adColour, ...
    'FaceAlpha',0.30,'EdgeColor',adColour,'LineWidth',1.4);
plot([3.35 3.85],[adMatched.median adMatched.median],'-','Color',adColour,'LineWidth',2.2);
text(3.6,adMatched.q3+0.08,sprintf('%.2f',adMatched.mean), ...
    'HorizontalAlignment','center','FontSize',10);
set(gca,'Position',[0.13 0.22 0.775 0.70]);
text(0.23,-0.16,'cognitively normal','Units','normalized','Color',cnColour, ...
    'HorizontalAlignment','center','VerticalAlignment','top');
text(0.77,-0.16,'Alzheimer','Units','normalized','Color',adColour, ...
    'HorizontalAlignment','center','VerticalAlignment','top');
hold off; box on; xlim([-0.6 4.2]);
set(gca,'XTick',[0 1 2.6 3.6],'XTickLabel',{'full','matched','full','matched'});
ylabel('follow-up (years)');
exportgraphics(gcf,fullfile(here,'s08a_followup_window_summary.png'),'Resolution',300);

%% Figure S8b: regional agreement
x = V.d_full;
y = V.d_matched;
lo = min([x;y]);
hi = max([x;y]);
figure('Color','w');
plot([lo hi],[lo hi],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5); hold on;
scatter(x,y,50,[0 0.4470 0.7410],'filled');
hold off; axis square; box on;
xlabel('full window (%/yr)'); ylabel('window matched (%/yr)');
exportgraphics(gcf,fullfile(here,'s08b_regional_agreement.png'),'Resolution',300);
