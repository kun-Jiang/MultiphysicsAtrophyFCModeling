%% Load source data
clear; clc; close all;
% Panel a is omitted because its plotting points are participant scans.
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');
T = readtable(sourceWorkbook,'Sheet','Figure 04','Range','A9:E77', ...
    'VariableNamingRule','preserve');

% The submitted box plot displays fractional rate values while retaining the
% original %/year label.
cn = T.rate_cn/100;
ad = T.rate_ad/100;

%% Figure 4b
figure('Color','w'); hold on;
boxchart(ones(size(cn)),cn,'BoxFaceColor',[0 0.447 0.741]);
boxchart(2*ones(size(ad)),ad,'BoxFaceColor',[0.635 0.078 0.184]);
plot([1 1 2 2],[0.0069 0.0075 0.0075 0.0069],'k-','LineWidth',1.5);
text(1.5,0.00775,'***','HorizontalAlignment','center', ...
    'VerticalAlignment','bottom','FontWeight','bold','FontSize',13);
hold off; xlim([0.5 2.5]); ylim([-0.033 0.010]);
set(gca,'XTick',[1 2],'XTickLabel',{'CN','AD'});
ylabel('Atrophy rate (%/year)'); box on;
exportgraphics(gcf,fullfile(here,'figure_04b_regional_rate_distributions.png'),'Resolution',300);

%% Figure 4c
x = T.diff_atrophy_rate;
y = T.diff_fc;
p = polyfit(x,y,1);
xx = linspace(min(x),max(x),200);
red = [0.85 0.10 0.10];

figure('Color','w');
scatter(x,y,45,[0 0.447 0.741],'filled'); hold on;
plot(xx,polyval(p,xx),'-','Color',[0.45 0.45 0.45],'LineWidth',2);
scatter(x([11 43 8 40 2 4 9 41]),y([11 43 8 40 2 4 9 41]),45,red,'filled');

plot([x(11) -1.60],[y(11) -49.0],'-','Color',red,'LineWidth',0.75);
text(-1.60,-49.0,'L InfTemp','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(43) -2.68],[y(43) -32.0],'-','Color',red,'LineWidth',0.75);
text(-2.68,-32.0,'R InfTemp','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(8) -2.88],[y(8) -4.0],'-','Color',red,'LineWidth',0.75);
text(-2.88,-4.0,'L Ent','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(40) -2.62],[y(40) -48.0],'-','Color',red,'LineWidth',0.75);
text(-2.62,-48.0,'R Ent','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(2) -2.78],[y(2) -18.0],'-','Color',red,'LineWidth',0.75);
text(-2.78,-18.0,'L Amyg','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(4) -2.10],[y(4) -7.0],'-','Color',red,'LineWidth',0.75);
text(-2.10,-7.0,'R Amyg','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(9) -1.00],[y(9) -25.0],'-','Color',red,'LineWidth',0.75);
text(-1.00,-25.0,'L Fus','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');
plot([x(41) -0.92],[y(41) -40.0],'-','Color',red,'LineWidth',0.75);
text(-0.92,-40.0,'R Fus','Color',red,'BackgroundColor','white','Margin',0.4, ...
    'FontSize',9,'HorizontalAlignment','left','VerticalAlignment','middle','Interpreter','none');

hold off; box on; xlim([-3 0]); ylim([-55 50]);
xlabel('Protein induced atrophy (%/y)'); ylabel('\Delta FC (%)');
exportgraphics(gcf,fullfile(here,'figure_04c_atrophy_fc_association.png'),'Resolution',300);
