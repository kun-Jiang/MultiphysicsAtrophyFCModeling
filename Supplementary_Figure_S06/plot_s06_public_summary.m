%% Load source data
clear; clc; close all;
% Figure S6a is based on one participant and is not included here.
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
den = readtable(sourceWorkbook,'Sheet','Figure S06','Range','A20:D1556', ...
    'VariableNamingRule','preserve');
sumry = readtable(sourceWorkbook,'Sheet','Figure S06','Range','A9:C15', ...
    'VariableNamingRule','preserve');

settings = unique(den.setting,'stable');
modelColour = [0.6350 0.0780 0.1840];
lightModelColour = modelColour+0.60*(1-modelColour);
halfWidth = 0.16;

%% Figure S6b
figure('Color','w'); hold on;

q = den(strcmp(den.setting,settings{1}) & strcmp(den.contrast,'individualised_seeding'),:);
yCentre = 3+0.18; width = halfWidth*q.density_scaled;
h1 = patch([q.delta_r;flipud(q.delta_r)],[yCentre+width;flipud(yCentre-width)], ...
    modelColour,'FaceAlpha',0.62,'EdgeColor','w');
s = sumry(strcmp(sumry.setting,settings{1}) & strcmp(sumry.contrast,'individualised_seeding'),:);
plot([s.median_delta_r s.median_delta_r],[yCentre-halfWidth yCentre+halfWidth], ...
    '-','Color',modelColour,'LineWidth',3);

q = den(strcmp(den.setting,settings{1}) & strcmp(den.contrast,'propagation_operator'),:);
yCentre = 2+0.18; width = halfWidth*q.density_scaled;
patch([q.delta_r;flipud(q.delta_r)],[yCentre+width;flipud(yCentre-width)], ...
    modelColour,'FaceAlpha',0.62,'EdgeColor','w');
s = sumry(strcmp(sumry.setting,settings{1}) & strcmp(sumry.contrast,'propagation_operator'),:);
plot([s.median_delta_r s.median_delta_r],[yCentre-halfWidth yCentre+halfWidth], ...
    '-','Color',modelColour,'LineWidth',3);

q = den(strcmp(den.setting,settings{1}) & strcmp(den.contrast,'model_vs_group_pattern'),:);
yCentre = 1+0.18; width = halfWidth*q.density_scaled;
patch([q.delta_r;flipud(q.delta_r)],[yCentre+width;flipud(yCentre-width)], ...
    modelColour,'FaceAlpha',0.62,'EdgeColor','w');
s = sumry(strcmp(sumry.setting,settings{1}) & strcmp(sumry.contrast,'model_vs_group_pattern'),:);
plot([s.median_delta_r s.median_delta_r],[yCentre-halfWidth yCentre+halfWidth], ...
    '-','Color',modelColour,'LineWidth',3);

q = den(strcmp(den.setting,settings{2}) & strcmp(den.contrast,'individualised_seeding'),:);
yCentre = 3-0.18; width = halfWidth*q.density_scaled;
h2 = patch([q.delta_r;flipud(q.delta_r)],[yCentre+width;flipud(yCentre-width)], ...
    lightModelColour,'FaceAlpha',0.62,'EdgeColor','w');
s = sumry(strcmp(sumry.setting,settings{2}) & strcmp(sumry.contrast,'individualised_seeding'),:);
plot([s.median_delta_r s.median_delta_r],[yCentre-halfWidth yCentre+halfWidth], ...
    '-','Color',lightModelColour,'LineWidth',3);

q = den(strcmp(den.setting,settings{2}) & strcmp(den.contrast,'propagation_operator'),:);
yCentre = 2-0.18; width = halfWidth*q.density_scaled;
patch([q.delta_r;flipud(q.delta_r)],[yCentre+width;flipud(yCentre-width)], ...
    lightModelColour,'FaceAlpha',0.62,'EdgeColor','w');
s = sumry(strcmp(sumry.setting,settings{2}) & strcmp(sumry.contrast,'propagation_operator'),:);
plot([s.median_delta_r s.median_delta_r],[yCentre-halfWidth yCentre+halfWidth], ...
    '-','Color',lightModelColour,'LineWidth',3);

q = den(strcmp(den.setting,settings{2}) & strcmp(den.contrast,'model_vs_group_pattern'),:);
yCentre = 1-0.18; width = halfWidth*q.density_scaled;
patch([q.delta_r;flipud(q.delta_r)],[yCentre+width;flipud(yCentre-width)], ...
    lightModelColour,'FaceAlpha',0.62,'EdgeColor','w');
s = sumry(strcmp(sumry.setting,settings{2}) & strcmp(sumry.contrast,'model_vs_group_pattern'),:);
plot([s.median_delta_r s.median_delta_r],[yCentre-halfWidth yCentre+halfWidth], ...
    '-','Color',lightModelColour,'LineWidth',3);

xline(0,'k-'); hold off; box on;
set(gca,'YTick',1:3,'YTickLabel',{'the model as a whole', ...
    'propagation operator','individualised seeding'});
xlabel('\Delta r (model - comparator), one value per participant');
legend([h1 h2],{'manuscript (\kappa=0.2, \alpha=0.9)', ...
    'Schäfer 2020 fit (\kappa=0.34, \alpha=0.21)'},'Location','southoutside');
exportgraphics(gcf,fullfile(here,'s06b_tau_ablation_aggregate_density.png'),'Resolution',300);
