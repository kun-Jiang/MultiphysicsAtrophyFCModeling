%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
V = readtable(sourceWorkbook,'Sheet','Figure 06','Range','A7:K75', ...
    'VariableNamingRule','preserve');
L = readtable(sourceWorkbook,'Sheet','Figure 06','Range','A80:A148', ...
    'VariableNamingRule','preserve');

Y = V{:,:};
names = string(L.roi);
left = startsWith(names,'Left-') | startsWith(names,'ctx-lh-');
right = startsWith(names,'Right-') | startsWith(names,'ctx-rh-');
leftNames = regexprep(names(left),'^(Left-|Right-|ctx-lh-|ctx-rh-)','');
leftNames = strrep(leftNames,'_',' ');

base = [103 0 31; 178 24 43; 214 96 77; 244 165 130; ...
        253 219 199; 247 247 247; 209 229 240; 146 197 222; ...
        67 147 195; 33 102 172; 5 48 97]/255;
cmap = interp1(1:11,base,linspace(1,11,100),'linear');

%% Figure 6a: left hemisphere
figure('Color','w');
imagesc(0:10,1:sum(left),Y(left,:));
set(gca,'XTick',2:2:10,'YTick',1:sum(left),'YTickLabel',leftNames);
clim([min(Y(:)) 1]); colorbar; colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_06a_left_roi_volume_heatmap.png'),'Resolution',300);

%% Figure 6a: right hemisphere
figure('Color','w');
imagesc(0:10,1:sum(right),Y(right,:));
set(gca,'XTick',2:2:10,'YTick',[]);
clim([min(Y(:)) 1]); colorbar; colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_06a_right_roi_volume_heatmap.png'),'Resolution',300);
