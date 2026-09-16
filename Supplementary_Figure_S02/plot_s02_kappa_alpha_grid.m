%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
T = readtable(sourceWorkbook,'Sheet','Figure S02','Range','A7:D907', ...
    'VariableNamingRule','preserve');
k = unique(T.kappa);
a = unique(T.alpha);

%% Figure S2a: correlation with experimental atrophy
zExperimental = reshape(T.r_vs_emp,numel(a),numel(k));
figure('Color','w');
pcolor(k,a,zExperimental); shading interp;
set(gca,'XScale','log','YScale','log');
xlabel('\kappa (transport rate)'); ylabel('\alpha (growth rate)'); title('vs exp.');
cb = colorbar; cb.Label.String = 'Pearson r'; clim([0 1]); colormap(parula);
exportgraphics(gcf,fullfile(here,'s02a_kappa_alpha_vs_exp.png'),'Resolution',300);

%% Figure S2a: correlation with FEM atrophy
zFem = reshape(T.r_vs_fem,numel(a),numel(k));
figure('Color','w');
pcolor(k,a,zFem); shading interp;
set(gca,'XScale','log','YScale','log');
xlabel('\kappa (transport rate)'); ylabel('\alpha (growth rate)'); title('vs FEM');
cb = colorbar; cb.Label.String = 'Pearson r'; clim([0 1]); colormap(parula);
exportgraphics(gcf,fullfile(here,'s02a_kappa_alpha_vs_fem.png'),'Resolution',300);
