%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');

cnTable = readtable(sourceWorkbook,'Sheet','Figure 08','Range','A9:BQ77', ...
    'VariableNamingRule','preserve');
adTable = readtable(sourceWorkbook,'Sheet','Figure 08','Range','A82:BQ150', ...
    'VariableNamingRule','preserve');
maskTable = readtable(sourceWorkbook,'Sheet','Figure 03','Range','A153:BQ221', ...
    'VariableNamingRule','preserve');
E = readtable(sourceWorkbook,'Sheet','Figure 08','Range','A155:D223', ...
    'VariableNamingRule','preserve');
F7 = readtable(sourceWorkbook,'Sheet','Figure 07','Range','A7:E75', ...
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

%% Figure 8b: simulated CN FC
figure('Color','w','Units','pixels','Position',[100 100 450 350]);
imagesc(cn); axis image; xlabel('CN'); colorbar;
set(gca,'XTick',[],'YTick',[],'FontName','Helvetica','FontSize',16, ...
    'LineWidth',1,'Box','on');
clim([-1 1]); colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_08b_cn_fc.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08b_cn_fc.fig'));

%% Figure 8b: simulated AD FC
figure('Color','w','Units','pixels','Position',[100 100 450 350]);
imagesc(ad); axis image; xlabel('AD'); colorbar;
set(gca,'XTick',[],'YTick',[],'FontName','Helvetica','FontSize',16, ...
    'LineWidth',1,'Box','on');
clim([-1 1]); colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_08b_ad_fc.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08b_ad_fc.fig'));

%% Figure 8c: simulated AD-CN difference on empirically significant edges
significantDelta = delta;
significantDelta(sigChange==0) = NaN;
figure('Color','w','Units','pixels','Position',[100 100 450 350]);
h = imagesc(significantDelta); axis image; colorbar;
h.AlphaData = ~isnan(significantDelta);
set(gca,'XTick',[],'YTick',[],'Color','w','FontName','Helvetica', ...
    'FontSize',16,'LineWidth',1,'Box','on');
clim([-0.2 0.2]); colormap(cmap);
exportgraphics(gcf,fullfile(here,'figure_08c_simulated_dfc_matrix.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08c_simulated_dfc_matrix.fig'));

%% Figure 8d: ROI-wise simulated delta FC
fcCnMean = mean(cn,2);
fcAdMean = mean(ad,2);
simulatedDeltaFc = 100*(fcAdMean-fcCnMean)./fcCnMean;
simulatedOutlier = find(isoutlier(simulatedDeltaFc,'mean'));

figure('Color','w','Units','pixels','Position',[100 100 450 350]);
h1 = bar(simulatedDeltaFc,'FaceColor','flat','EdgeColor','none');
h1.CData = repmat([0.55 0.75 0.92],68,1);
h1.CData(simulatedOutlier,:) = repmat([0.92 0.31 0.18],numel(simulatedOutlier),1);
xlabel('ROI'); ylabel('\Delta FC (%)');
xlim([0 68]); ylim([-300 250]);
xticks([0 20 40 60 68]); yticks(-300:100:200);
set(gca,'FontName','Helvetica','FontSize',16,'LineWidth',1,'Box','on');
exportgraphics(gcf,fullfile(here,'figure_08d_simulated_roi_dfc.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08d_simulated_roi_dfc.fig'));

%% Figure 8d: empirical delta FC at the same highlighted ROIs
empiricalDeltaFc = F7.diff_fc;
figure('Color','w','Units','pixels','Position',[100 100 450 350]);
h2 = bar(empiricalDeltaFc,'FaceColor','flat','EdgeColor','none');
h2.CData = repmat([0.55 0.75 0.92],68,1);
h2.CData(simulatedOutlier,:) = repmat([0.92 0.31 0.18],numel(simulatedOutlier),1);
xlabel('ROI'); ylabel('\Delta FC (%)');
xlim([0 68]); ylim([-60 60]);
xticks([0 20 40 60 68]); yticks(-60:20:60);
set(gca,'FontName','Helvetica','FontSize',16,'LineWidth',1,'Box','on');
exportgraphics(gcf,fullfile(here,'figure_08d_empirical_masked_roi_dfc.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08d_empirical_masked_roi_dfc.fig'));

%% Figure 8e: model atrophy input
x = E.sim_rate_protein;
y = 100*E.FC_diff;
fitLine = polyfit(x,y,1);
highlightedRois = E.roi(E.isoutlier~=0);

figure('Color','w','Units','pixels','Position',[100 100 450 350]);
h3 = bar(x,'FaceColor','flat','EdgeColor','none');
h3.CData = repmat([0.55 0.75 0.92],68,1);
h3.CData(highlightedRois,:) = repmat([0.92 0.31 0.18],numel(highlightedRois),1);
xlabel('ROI'); ylabel('Atrophy (%/year)');
xlim([0 68]); ylim([-4 1]);
xticks([0 20 40 60 68]); yticks(-4:1:1);
set(gca,'FontName','Helvetica','FontSize',16,'LineWidth',1,'Box','on');
exportgraphics(gcf,fullfile(here,'figure_08e_atrophy_input.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08e_atrophy_input.fig'));

%% Figure 8e: model-internal correlation across all 68 ROIs
pointColors = repmat([0 0.4470 0.7410],68,1);
pointColors(E.isoutlier~=0,:) = repmat([0.92 0.31 0.18],numel(highlightedRois),1);
xx = linspace(-4,0.5,200);

figure('Color','w','Units','pixels','Position',[100 100 450 350]);
scatter(x,y,40,pointColors,'filled','LineWidth',2); hold on;
plot(xx,polyval(fitLine,xx),'-','Color',[0.55 0.55 0.55],'LineWidth',2);
hold off;
xlabel('Protein induced atrophy (%/year)'); ylabel('\Delta FC (%)');
xlim([-4 0.5]); ylim([-300 250]);
xticks(-4:1:0); yticks(-300:100:200);
set(gca,'FontName','Helvetica','FontSize',16,'LineWidth',1,'Box','on');
exportgraphics(gcf,fullfile(here,'figure_08e_model_internal_scatter.png'),'Resolution',300);
savefig(gcf,fullfile(here,'figure_08e_model_internal_scatter.fig'));
