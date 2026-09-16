%% Load source data
clear; clc; close all;
% Spatial renderings come from the finite-element visualisation workflow.
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
data = readtable(sourceWorkbook,'Sheet','Figure 05','Range','A7:C48', ...
    'VariableNamingRule','preserve');

volumeMask = isfinite(data.brain_volume);
tVolume = data.time_years(volumeMask);
volume = data.brain_volume(volumeMask);
tProtein = data.time_years;
proteinBurden = data.protein_burden;

%% Figure 5 trajectory panel
figure('Color','w');
yyaxis left;
plot(tVolume,volume,'LineWidth',2,'Color',[0 0.447 0.741]);
ylabel('Brain volume (%)');
yyaxis right;
plot(tProtein,proteinBurden,'LineWidth',2,'Color',[0.850 0.325 0.098]);
hold on;
milestoneTimes = [1 4 7 10];
milestoneProtein = interp1(tProtein,proteinBurden,milestoneTimes);
plot(milestoneTimes,milestoneProtein,'d','LineStyle','none', ...
    'MarkerSize',7,'LineWidth',1.5,'MarkerEdgeColor',[0 0.447 0.741], ...
    'MarkerFaceColor','w');
text([0.9 3.7 6.6 9.0],[0.055 0.075 0.105 0.455],{'I','II','III','IV'}, ...
    'Color','k','FontSize',10,'HorizontalAlignment','center');
ylabel('Protein'); xlabel('Time/year'); box on; xlim([0 10]);
yyaxis left; ylim([0.85 1]);
yyaxis right; ylim([0 0.5]); yticks(0:0.1:0.5);
exportgraphics(gcf,fullfile(here,'figure_05_model_trajectories.png'),'Resolution',300);
