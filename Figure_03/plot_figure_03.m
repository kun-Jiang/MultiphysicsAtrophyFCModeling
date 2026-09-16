%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');

cnTable = readtable(sourceWorkbook,'Sheet','Figure 03','Range','A7:BQ75', ...
    'VariableNamingRule','preserve');
adTable = readtable(sourceWorkbook,'Sheet','Figure 03','Range','A80:BQ148', ...
    'VariableNamingRule','preserve');
maskTable = readtable(sourceWorkbook,'Sheet','Figure 03','Range','A153:BQ221', ...
    'VariableNamingRule','preserve');
roiChange = readtable(sourceWorkbook,'Sheet','Figure 03','Range','A226:D294', ...
    'VariableNamingRule','preserve');

cn = cnTable{:,2:end};
ad = adTable{:,2:end};
sigChange = maskTable{:,2:end};
delta = ad-cn;

base = [103 0 31; 178 24 43; 214 96 77; 244 165 130; ...
        253 219 199; 247 247 247; 209 229 240; 146 197 222; ...
        67 147 195; 33 102 172; 5 48 97]/255;
cmap = interp1(1:11,base,linspace(1,11,100),'linear');
cmap = flipud(cmap);

%% Figure 3a: CN FC matrix
figure('Color','w');
imagesc(cn); axis image;
set(gca,'XTick',[],'YTick',[]); clim([-0.3 1.2]); colorbar;
colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_03a_cn_fc.png'),'Resolution',300);

%% Figure 3a: AD FC matrix
figure('Color','w');
imagesc(ad); axis image;
set(gca,'XTick',[],'YTick',[]); clim([-0.3 1.2]); colorbar;
colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_03a_ad_fc.png'),'Resolution',300);

%% Figure 3b: ROI-wise FC change
changePct = roiChange.change_pct_of_cn;
figure('Color','w');
bar(changePct,'FaceColor',[0.2 0.5 0.8],'EdgeColor','none');
ylabel('\Delta FC'); xlim([0.5 height(roiChange)+0.5]); box on;
exportgraphics(gcf,fullfile(here,'figure_03b_roi_fc_change.png'),'Resolution',300);

%% Figure 3c: significant uncorrected difference
figure('Color','w');
imagesc(delta.*(sigChange~=0)); axis image;
set(gca,'XTick',[],'YTick',[]); clim([-0.2 0.2]); colorbar;
colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_03c_uncorrected_difference.png'),'Resolution',300);
