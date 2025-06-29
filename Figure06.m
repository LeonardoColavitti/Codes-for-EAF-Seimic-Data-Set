% ERR_QC_CATAL_STATS
%
% Plot errors on the earthquake catalog.
%
% 1. Err_cumulative.pdf - Empirical Cumulative Distribution of the Errors in Seismic Location
% 2. Hist_Err_H.pdf - Histogram of horizontal error in Seismic Location
% 3. Hist_Err_Z.pdf - Histogram of vertical error in Seismic Location
%
% Supplement Material
% 4. RMS_ok.pdf - Histogram of the RMS Error in Seismic Location
% 5. GAP_ok.pdf - Histogram of the GAP in Seismic Location
%
% % This script generates FIGURE 6 (and some Supp Figures) of the DataPaper published in Earth Science System Data:
% A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
% by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa
%
% Leonardo Colavitti - 03 March 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start Clock
tic;

clf; clc; clear; close all;

% Delete saved variables
delete Hist_Err_H_stats.pdf
delete Hist_Err_Z_stats.pdf
delete RMS_ok_stats.pdf
delete GAP_ok_stats.pdf

% Variables
edges_phase = 0:1:35;
bins = 20;

TABLE_EVENTS = readtable('out_events_catal_qc.csv'); % 9442 Events

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPIRICAL CUMULATIVE DISTRIBUTION ErrH and ErrZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
hold on
grid on
box on
axis on
ax12 = gca;
ax12.FontSize = 12;
ax12.XTick = 0:0.5:5;  % tick x ogni 0.5 km
ax12.YTick = 0:0.1:1;               % tick y ogni 0.1 (CDF)

h1(1,2) = cdfplot(TABLE_EVENTS.Erh);
h1(:,2).Color = [0.4940, 0.1840, 0.5560];
h1(1,2).LineWidth = 2;

h2(1,2) = cdfplot(TABLE_EVENTS.Erz);
h2(:,2).Color = [0.3010, 0.7450, 0.9330];
h2(1,2).LineWidth = 2;

xlabel('Location Error [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('Empirical Cumulative Distribution','FontName','Arial','FontSize',12,'FontWeight','bold')
title('')
legend('Err H','Err Z','Location','northwest')

% Print the figure as PDF
fig1_hz = 22;
fig1_vt = 15;
% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig1_hz fig1_vt],'PaperPosition',[0, 0, fig1_hz, fig1_vt])

% %%% SAVE PDF IMAGE %%%
% Print in PDF
% print('Err_cumulative','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HISTOGRAM OF HORIZONTAL ERROR %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
ax2 = gca;
ax2.FontSize = 12;
ax2.FontName = 'Arial';

hold on
grid on
box on
hist_err_h = histogram(TABLE_EVENTS.Erh,0:0.25:4,'FaceColor',[0.4940, 0.1840, 0.5560]);
xlabel('Horizontal Error [km]','FontWeight','bold')
ylabel('# Events','FontWeight','bold')

axis([-0.1 4.1 0 3650])

% Print the figure as PDF
fig2_hz = 22;
fig2_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig2_hz fig2_vt],'PaperPosition',[0, 0, fig2_hz, fig2_vt])

% Count   - Number of events
num_events  = length(TABLE_EVENTS.Erh);
% Mean    - Media
mean_ErH    = mean(TABLE_EVENTS.Erh);
% Median  - Mediana
median_ErH  = median(TABLE_EVENTS.Erh);
% Std     - Standard Deviation
std_dev_ErH = std(TABLE_EVENTS.Erh);
% Mad     - Mean Absolute Deviation
mad_ErH     = mad(TABLE_EVENTS.Erh);

% Insert Statistical Parameters
stats_text_ErH = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_ErH,...
                              median_ErH,...
                              std_dev_ErH,...
                              mad_ErH);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ErH, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Configurazione per il salvataggio in PDF
fig2_hz = 22;  % Larghezza in cm
fig2_vt = 15;  % Altezza in cm
% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperSize', [fig2_hz fig2_vt], ...
         'PaperPosition', [0, 0, fig2_hz, fig2_vt]);

% Save Image Printing it in PDF
% print('Hist_Err_H_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HISTOGRAM OF VERTICAL ERROR %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
ax3 = gca;
ax3.FontSize = 12;
ax3.FontName = 'Arial';

hold on
grid on
box on
hist_err_z = histogram(TABLE_EVENTS.Erz,0:0.3:5,'FaceColor',[0.3010, 0.7450, 0.9330]);
xlabel('Depth Error [km]','FontWeight','bold')
ylabel('# Events','FontWeight','bold')

% axis([-0.05 5.05 0 2000])

axis([-0.2 5 0 1900])

% Print the figure as PDF
fig3_hz = 22;
fig3_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig3_hz fig3_vt],'PaperPosition',[0, 0, fig3_hz, fig3_vt])

% Save Image Printing it in PDF
print('Hist_Err_Z','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% Count   - Number of events
num_events  = length(TABLE_EVENTS.Erz);
% Mean    - Media
mean_ErZ    = mean(TABLE_EVENTS.Erz);
% Median  - Mediana
median_ErZ  = median(TABLE_EVENTS.Erz);
% Std     - Standard Deviation
std_dev_ErZ = std(TABLE_EVENTS.Erz);
% Mad     - Mean Absolute Deviation
mad_ErZ     = mad(TABLE_EVENTS.Erz);

% Insert Statistical Parameters
stats_text_ErZ = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_ErZ,...
                              median_ErZ,...
                              std_dev_ErZ,...
                              mad_ErZ);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ErZ, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Configurazione per il salvataggio in PDF
fig3_hz = 22;  % Larghezza in cm
fig3_vt = 15;  % Altezza in cm
% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperSize', [fig3_hz fig3_vt], ...
         'PaperPosition', [0, 0, fig3_hz, fig3_vt]);

% Save Image Printing it in PDF
% print('Hist_Err_Z_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HISTOGRAM OF ROOT MEAN SQUARE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
hold on
grid on
box on
axis on
ax4 = gca;
ax4.FontSize = 12;

histogram(TABLE_EVENTS.Rms,'FaceColor','Red');
xlabel ('Root Mean Square [s]','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')

axis([0 0.95 0 1100])

% Print the figure as PDF
fig4_hz = 22;
fig4_vt = 15;
% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig4_hz fig4_vt],'PaperPosition',[0, 0, fig4_hz, fig4_vt])

% Save Image Printing it in PDF
% print('Hist_Err_Z','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% Count   - Number of events
num_events  = length(TABLE_EVENTS.Rms);
% Mean    - Media
mean_RMS    = mean(TABLE_EVENTS.Rms);
% Median  - Mediana
median_RMS  = median(TABLE_EVENTS.Rms);
% Std     - Standard Deviation
std_dev_RMS = std(TABLE_EVENTS.Rms);
% Mad     - Mean Absolute Deviation
mad_RMS     = mad(TABLE_EVENTS.Rms);

% Insert Statistical Parameters
stats_text_RMS = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_RMS,...
                              median_RMS,...
                              std_dev_RMS,...
                              mad_RMS);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_RMS, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Configurazione per il salvataggio in PDF
fig4_hz = 22;  % Larghezza in cm
fig4_vt = 15;  % Altezza in cm
% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperSize', [fig4_hz fig4_vt], ...
         'PaperPosition', [0, 0, fig4_hz, fig4_vt]);

% %%% SAVE PDF IMAGE %%%
% Print in PDF
% print('RMS_ok_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HISTOGRAM OF GAP %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5)
hold on
grid on
box on
axis on
ax5 = gca;
ax5.FontSize = 12;
ax5.XTick = 0:60:360;

histogram(TABLE_EVENTS.Gap,'FaceColor','Green');
xlabel('Azimuthal Gap [°]', 'FontName', 'Arial', 'FontWeight', 'Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')

axis([0 360 0 1100])

% Count   - Number of events
num_events  = length(TABLE_EVENTS.Gap);
% Mean    - Media
mean_Gap    = mean(TABLE_EVENTS.Gap);
% Median  - Mediana
median_Gap  = median(TABLE_EVENTS.Gap);
% Std     - Standard Deviation
std_dev_Gap = std(TABLE_EVENTS.Gap);
% Mad     - Mean Absolute Deviation
mad_Gap     = mad(TABLE_EVENTS.Gap);

% Insert Statistical Parameters
stats_text_Gap = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_Gap,...
                              median_Gap,...
                              std_dev_Gap,...
                              mad_Gap);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.145, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_Gap, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Print the figure as PDF
fig5_hz = 22;
fig5_vt = 15;
% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig5_hz fig5_vt],'PaperPosition',[0, 0, fig5_hz, fig5_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('GAP_ok_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)
