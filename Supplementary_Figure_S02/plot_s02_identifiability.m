%% Load source data
clear; clc; close all;
here = fileparts(mfilename('fullpath'));
sourceWorkbook = fullfile(fileparts(here),'Source_Data.xlsx');

%% Figure S2b
pf = readtable(sourceWorkbook,'Sheet','Figure S02','Range','A912:C993', ...
    'VariableNamingRule','preserve');
figure('Color','w'); hold on;
q = sortrows(pf(strcmp(pf.param,'c_crit'),:),'value');
x = (q.value-min(q.value))/(max(q.value)-min(q.value)+eps);
h1 = plot(x,q.profile_SSE-min(q.profile_SSE),'-o','Color',[0.6350 0.0780 0.1840], ...
    'MarkerFaceColor',[0.6350 0.0780 0.1840]);
q = sortrows(pf(strcmp(pf.param,'kappa'),:),'value');
x = (q.value-min(q.value))/(max(q.value)-min(q.value)+eps);
h2 = plot(x,q.profile_SSE-min(q.profile_SSE),'-o','Color',[0 0.4470 0.7410], ...
    'MarkerFaceColor',[0 0.4470 0.7410]);
q = sortrows(pf(strcmp(pf.param,'alpha'),:),'value');
x = (q.value-min(q.value))/(max(q.value)-min(q.value)+eps);
h3 = plot(x,q.profile_SSE-min(q.profile_SSE),'-o','Color',[0.4660 0.6740 0.1880], ...
    'MarkerFaceColor',[0.4660 0.6740 0.1880]);
hold off; box on;
xlabel('parameter value (normalised)'); ylabel('\Delta profile SSE');
legend([h1 h2 h3],{'c_{crit}','\kappa','\alpha'},'Location','east');
exportgraphics(gcf,fullfile(here,'s02b_profile_likelihood.png'),'Resolution',300);

%% Figure S2c
bd = readtable(sourceWorkbook,'Sheet','Figure S02','Range','A1015:B7015', ...
    'VariableNamingRule','preserve');
cn = bd.kappa(strcmp(bd.group,'CN'));
mci = bd.kappa(strcmp(bd.group,'MCI'));
ad = bd.kappa(strcmp(bd.group,'AD'));
figure('Color','w'); hold on;
boxchart(ones(size(cn)),cn,'BoxFaceColor',[0 0.4470 0.7410],'MarkerStyle','none');
boxchart(2*ones(size(mci)),mci,'BoxFaceColor',[0.8500 0.3250 0.0980],'MarkerStyle','none');
boxchart(3*ones(size(ad)),ad,'BoxFaceColor',[0.6350 0.0780 0.1840],'MarkerStyle','none');
hold off;
set(gca,'YScale','log','XTick',1:3,'XTickLabel',{'CN (18)','MCI (31)','AD (24)'});
ylabel('\kappa (2000 bootstrap fits)'); box on;
exportgraphics(gcf,fullfile(here,'s02c_kappa_bootstrap.png'),'Resolution',300);

%% Figure S2d
sk = readtable(sourceWorkbook,'Sheet','Figure S02','Range','A7020:D7043', ...
    'VariableNamingRule','preserve');
figure('Color','w'); hold on;
q = sortrows(sk(strcmp(sk.block,'scan_kappa'),:),'kappa');
x = (q.kappa-min(q.kappa))/(max(q.kappa)-min(q.kappa));
plot(x,q.r_vs_emp,'-o','Color',[0 0.4470 0.7410], ...
    'MarkerFaceColor',[0 0.4470 0.7410]);
q = sortrows(sk(strcmp(sk.block,'scan_alpha'),:),'alpha');
x = (q.alpha-min(q.alpha))/(max(q.alpha)-min(q.alpha));
plot(x,q.r_vs_emp,'-o','Color',[0.4660 0.6740 0.1880], ...
    'MarkerFaceColor',[0.4660 0.6740 0.1880]);
hold off; box on;
xlabel('parameter value (normalised)'); ylabel('r vs empirical atrophy');
legend({'\kappa varied (64\times)','\alpha varied (\times1/8 to \times4)'},'Location','best');
exportgraphics(gcf,fullfile(here,'s02d_transport_growth_sweeps.png'),'Resolution',300);

%% Figure S2e
cc = readtable(sourceWorkbook,'Sheet','Figure S02','Range','A7048:C7058', ...
    'VariableNamingRule','preserve');
cc = sortrows(cc,'c_crit');
figure('Color','w'); hold on;
plot(cc.c_crit,cc.r_vs_emp,'-o','Color',[0.6350 0.0780 0.1840], ...
    'MarkerFaceColor',[0.6350 0.0780 0.1840]);
plot(cc.c_crit,cc.r_vs_fem,'--s','Color',[0 0.4470 0.7410], ...
    'MarkerFaceColor',[0 0.4470 0.7410]);
xline(0.2,'-','literature 0.2','Color',[0.20 0.60 0.25], ...
    'LabelVerticalAlignment','bottom');
xline(0.5,'-','used 0.5','Color',[0.4 0.4 0.4], ...
    'LabelVerticalAlignment','bottom');
hold off; box on;
xlabel('damage threshold c_{crit}'); ylabel('Pearson r');
legend({'vs empirical atrophy','vs FEM atrophy'},'Location','best');
exportgraphics(gcf,fullfile(here,'s02e_damage_threshold_sweep.png'),'Resolution',300);
