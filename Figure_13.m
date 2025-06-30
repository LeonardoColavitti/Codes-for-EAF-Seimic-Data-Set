% HYPO_MAGNITUDE
%
% Plot PGA-PGV in function with respect to hypocentral distance, also
% considering some range of magnitudes.
%
% 1. hypo_PGA.pdf         [Hypo distance vs log10 PGA]
% 2. hypo_PGV.pdf         [Hypo distance vs log10 PGV]
% 3. hypo_PGA_group.pdf   [Hypo distance vs log10 PGA - grouped into Ml in]
% 4. hypo_PGV_group.pdf   [Hypo distance vs log10 PGV - grouped into Ml in]
%
% This script generates FIGURE 13 of the DataPaper published in Earth Science System Data:
% A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
% by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa
%
% Leonardo Colavitti - 20 September 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

delete hypo_PGA.pdf
delete hypo_PGV.pdf
delete hypo_PGA_group.pdf
delete hypo_PGV_group.pdf

% Start Clock
tic;

load('PGA_PGV.mat');

% TABLE_PGA_PGV    = readtable('out_pgapgv.csv');             % 100220 Values

TABLE_PGA_PGV_QC = readtable('out_pgapgv_qc_ok.csv');       % 98033  Values

TABLE_EVENTS     = readtable('out_events_catal_qc.csv');    % 9442   Events

% Do Vector Composition between PGA_NS and PGA_EW
% PGA_TOT = sqrt(PGA_NS ^ 2 + PGA_EW ^ 2)

% Var3     - Hypo Dist
% Var4,5,6 - PGA N-S,E-W,Z
% Var7,8,9 - PGV N-S,E-W,Z

% Create Column with PGA_TOT
PGA_TOT = zeros(length(TABLE_PGA_PGV_QC.Var1),1);
PGV_TOT = PGA_TOT;

for i=1:length(TABLE_PGA_PGV_QC.Var1)


    PGA_TOT(i) = sqrt ( (TABLE_PGA_PGV_QC.Var4(i) .^ 2) + ...
                 (TABLE_PGA_PGV_QC.Var5(i) .^ 2) );

    PGV_TOT(i) = sqrt ( (TABLE_PGA_PGV_QC.Var7(i) .^ 2) + ...
                 (TABLE_PGA_PGV_QC.Var8(i) .^ 2) );

end

% ALL TRACES
ID_Traces = TABLE_PGA_PGV_QC.Var1;

% Extract ID Event
[ID_EV,index_ID_EV] = unique(TABLE_PGA_PGV_QC.Var1);

% Extract Magnitude
Ml = TABLE_EVENTS.Ml;

Ml_records = nan(length(PGA_TOT),1);

for i=1:length(ID_EV) % Start Loop on Ml records

    [index_recs,~] = find(ID_Traces==ID_EV(i));

    Ml_records(index_recs) = Ml(i);

end % End Loop on Ml records

% Order Data according to Magnitude
[Ml_order, index_Ml_order] = sort(Ml_records);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GRAPH RESULTANT PGA vs Hypo Distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
hold on
grid on
box on

scatter(TABLE_PGA_PGV_QC.Var3,log10(PGA_TOT),15,Ml_records,...
    'filled','o')

colormap(flipud(colormap('autumn')))

c1 = colorbar;
c1.Label.String = 'M_{L}- Local Magnitude';
c1.Label.FontWeight = 'bold';
c1.FontSize = 10;
c1.Limits = [2 5.5];

xlabel('Hypocentral Distance [km]','FontSize',12,'FontWeight','bold')
ylabel('log_{10} PGA','FontSize',12,'FontWeight','bold')
% title('Hypocentral distance vs log_{10} PGA','Color','Red','FontSize',14)
axis([0 160 -5 1.5])

% Print the figure as PDF
fig1_hz = 20;
fig1_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',...
    [fig1_hz fig1_vt],'PaperPosition',[0, 0, fig1_hz, fig1_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('hypo_PGA','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GRAPH RESULTANT PGV vs Hypo Distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
hold on
grid on
box on

scatter(TABLE_PGA_PGV_QC.Var3,log10(PGV_TOT),15,Ml_records,...
    'filled','o')

c2 = colorbar;
c2.Label.String = 'M_{L}- Local Magnitude';
c2.Label.FontWeight = 'bold';
c2.FontSize = 10;
c2.Limits = [2 5.5];

colormap(flipud(colormap('autumn')))

xlabel('Hypocentral Distance [km]','FontSize',12,'FontWeight','bold')
ylabel('log_{10} PGV','FontSize',12,'FontWeight','bold')
% title('Hypocentral distance vs log_{10} PGV','Color','Red','FontSize',14)
axis([0 160 -4 3.5])

% Print the figure as PDF
fig2_hz = 20;
fig2_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',...
    [fig2_hz fig2_vt],'PaperPosition',[0, 0, fig2_hz, fig2_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
print('hypo_PGV','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% close;

% Make some range of intervals
index_Ml_25    = find(Ml_records <= 2.5);                    %  7'870
index_Ml_25_30 = find(Ml_records > 2.5 & Ml_records <= 3.0); % 32'951
index_Ml_30_35 = find(Ml_records > 3.0 & Ml_records <= 3.5); % 31'201
index_Ml_35_40 = find(Ml_records > 3.5 & Ml_records <= 4.0); % 16'195
index_Ml_40    = find(Ml_records > 4.0);                     %  9'816

nbins = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GRAPH RESULTANT PGA vs Hypo Distance - MAGNITUDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
hold on
grid on
box on
ax3 = gca;
ax3.FontSize = 12;
ax3.FontName = 'Arial';
binned_plot(TABLE_PGA_PGV_QC.Var3(index_Ml_40), log10(PGA_TOT(index_Ml_40)), nbins);
hold on
binned_plot_g(TABLE_PGA_PGV_QC.Var3(index_Ml_35_40), log10(PGA_TOT(index_Ml_35_40)), nbins);
binned_plot_c(TABLE_PGA_PGV_QC.Var3(index_Ml_30_35), log10(PGA_TOT(index_Ml_30_35)), nbins);
binned_plot_m(TABLE_PGA_PGV_QC.Var3(index_Ml_25_30), log10(PGA_TOT(index_Ml_25_30)), nbins);
binned_plot_r(TABLE_PGA_PGV_QC.Var3(index_Ml_25),    log10(PGA_TOT(index_Ml_25)),    nbins);
xlabel('Hypocentral Distance [km]','FontSize',12,'FontName','Arial','FontWeight','bold')
ylabel('log_{10} PGA','FontSize',12,'FontName','Arial','FontWeight','bold')

legend('$M_L > 4$','','$3.5 < M_L \leq 4.0$','','$3.0 < M_L \leq 3.5$','','$2.5 < M_L \leq 3.0$','','$M_L \leq 2.5$', 'FontName','Arial','Interpreter', 'latex')

axis([0 160 -4 -0.5])

% Print the figure as PDF
fig3_hz = 20;
fig3_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',...
    [fig3_hz fig3_vt],'PaperPosition',[0, 0, fig3_hz, fig3_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('hypo_PGA_group','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GRAPH RESULTANT PGV vs Hypo Distance - MAGNITUDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
hold on
grid on
box on

binned_plot(TABLE_PGA_PGV_QC.Var3(index_Ml_40),log10(PGV_TOT(index_Ml_40)),nbins);
hold on
binned_plot_g(TABLE_PGA_PGV_QC.Var3(index_Ml_35_40),log10(PGV_TOT(index_Ml_35_40)),nbins)
binned_plot_c(TABLE_PGA_PGV_QC.Var3(index_Ml_30_35),log10(PGV_TOT(index_Ml_30_35)),nbins)
binned_plot_m(TABLE_PGA_PGV_QC.Var3(index_Ml_25_30),log10(PGV_TOT(index_Ml_25_30)),nbins)
binned_plot_r(TABLE_PGA_PGV_QC.Var3(index_Ml_25),log10(PGV_TOT(index_Ml_25)),nbins)

xlabel('Hypocentral Distance [km]','FontSize',12,'FontName','Arial','FontWeight','bold')
ylabel('log_{10} PGV','FontSize',12,'FontName','Arial','FontWeight','bold')

legend('$M_L > 4$','','$3.5 < M_L \leq 4.0$','','$3.0 < M_L \leq 3.5$','','$2.5 < M_L \leq 3.0$','','$M_L \leq 2.5$', 'FontName','Arial','Interpreter', 'latex')

axis([0 160 -2.5 1])

% Print the figure as PDF
fig4_hz = 20;
fig4_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',...
    [fig4_hz fig4_vt],'PaperPosition',[0, 0, fig4_hz, fig4_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('hypo_PGV_group','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% End Clock
toc;
