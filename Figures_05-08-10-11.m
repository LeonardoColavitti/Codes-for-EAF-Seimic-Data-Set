% CASP_PARAMETERS_STATS
% Parameters computed by CASP tool:
% Some images (also for comparison) between AFAD and UNIGE Catalog for
% Turkiye. In the box in the upper right, we show the statistical parameters.
%
% 1.  AFAD_ML_Histogram_stats.pdf          SUPP
% 2.  UNIGE_ML_Histogram_stats.pdf         FIGURE 10A
% 31. AFAD_ML_Histogram_stats_blue.pdf     FIGURE 11B
% 32. UNIGE_ML_Histogram_stats_red.pdf     FIGURE 11A
% 4.  Std_magnitude_UNIGE_stats.pdf        FIGURE 10B
% 5.  DEPTH_AFAD_GIT_ok_stats.pdf          FIGURE 8B
% 6.  DEPTH_UNIGE_GIT_ok_stats.pdf         FIGURE 8A
% 8.  Np_ok_stats.pdf                      FIGURE 5B
% 9.  Ns_ok_stats.pdf                      FIGURE 5C
%10.  Ntot_ok_stats.pdf                    SUPP
%11.  P_S_cumulative.pdf                   FIGURE 5A
%
% This script generates FIGURES 5, 8, 10, 11 (and some Supp Figures) of the DataPaper published in Earth Science System Data:
% A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
% by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa
%
% Leonardo Colavitti - 27 January 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start Clock
tic;

clf; clc; clear; close all;

% Delete PDF created images
delete AFAD_ML_Histogram_stats.pdf
delete UNIGE_ML_Histogram_stats.pdf
delete AFAD_ML_Histogram_stats_blue.pdf
delete UNIGE_ML_Histogram_stats_red.pdf
delete Std_magnitude_UNIGE_stats.pdf
delete DEPTH_AFAD_GIT_ok_stats.pdf
delete DEPTH_UNIGE_GIT_ok_stats.pdf
delete Np_ok_stats.pdf
delete Ns_ok_stats.pdf
delete Np_Ns_ok_stats.pdf

%%% FULL CATALOG %%%
load TABLE_EVENTS_OK_QC.mat         % 78728 Events

%%% GIT  CATALOG %%%
TAB = readtable('CatalFormat.txt'); % 9442 Events

[ID_event_GIT,index_event_GIT] = intersect(TAB.Id,TABLE_EVENTS_OK_QC.Id);

% %%% MAGNITUDE PARAMETERS %%%
MAG_AFAD_GIT  = TAB.Ml_Ref(index_event_GIT);         % MAG:    0 - 5.3
MAG_UNIGE_GIT = TABLE_EVENTS_OK_QC.Ml;               % MAG: 1.87 - 5.50

% See that index are coherent

%%
MAG_UNIGE_GIT_OK = TAB.Ml(index_event_GIT);        % MAG: 1.87 - 5.50

%%% MAG ERR %%%
ERR_MAG_GIT   = TAB.StdMag(index_event_GIT);         % ERR: 0.14 - 1.08

%%% DEPTH PARAMETERS %%%
DEPTH_AFAD_GIT  = TAB.Dpt1(index_event_GIT);         % DEPTH:    0 - 42.78
DEPTH_UNIGE_GIT = TABLE_EVENTS_OK_QC.Depth;          % DEPTH: 0.02 - 49.36

%%% NUMBER OF P- AND S- WAVES
P_WAVE_GIT = TABLE_EVENTS_OK_QC.Np;                        % NUMBS: 0 - 35
S_WAVE_GIT = TABLE_EVENTS_OK_QC.Ns;                        % NUMBS: 0 - 29

edges = 0:0.2:5.6;
edges_depth = 0:2:20;
edges_depth_ok = 0:1:20;
edges_std_mag = 0:0.025:2;
edges_phase = 0:1:35;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% AFAD ML %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
hold on
box on
grid on
axis on
ax1 = gca;
ax1.FontName = 'Arial';
ax1.FontSize = 12;
ax1.XTick = 0:0.5:6;
hold on
h1 = histogram(MAG_AFAD_GIT,edges,'FaceColor',[0.8 0.8 0.8]);
xlabel ('M_{L}- Local Magnitude','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')
axis([1.7 5.7 0 1600])

% Count   - Number of events
num_events      = length(MAG_AFAD_GIT);
% Mean    - Media
mean_ML_AFAD    = mean(MAG_AFAD_GIT);
% Median  - Mediana
median_ML_AFAD  = median(MAG_AFAD_GIT);
% Std     - Standard Deviation
std_dev_ML_AFAD = std(MAG_AFAD_GIT);
% Mad     - Mean Absolute Deviation
mad_ML_AFAD     = mad(MAG_AFAD_GIT);

% Insert Statistical Parameters
stats_text_ML_AFAD = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_ML_AFAD,...
                              median_ML_AFAD,...
                              std_dev_ML_AFAD,...
                              mad_ML_AFAD);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ML_AFAD, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Configurazione per il salvataggio in PDF
fig1_hz = 22;  % Larghezza in cm
fig1_vt = 15;  % Altezza in cm
% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperSize', [fig1_hz fig1_vt], ...
         'PaperPosition', [0, 0, fig1_hz, fig1_vt]);

% Salvataggio in PDF
% print(gcf, 'AFAD_ML_Histogram_stats.pdf', '-dpdf', '-r600'); % Salva il file come PDF ad alta risoluzione

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% THIS WORK ML %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
hold on
box on
grid on
axis on
ax2 = gca;
ax2.FontName = 'Arial';
ax2.FontSize = 12;
ax2.XTick = 0:0.5:6;
hold on
h2 = histogram(MAG_UNIGE_GIT,edges,'FaceColor',[0.8 0.8 0.8]);
xlabel ('M_{L}- Local Magnitude','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')
axis([1.7 5.7 0 1600])

% Mean    - Media
mean_ML_UNIGE    = mean(MAG_UNIGE_GIT);
% Median  - Mediana
median_ML_UNIGE  = median(MAG_UNIGE_GIT);
% Std     - Standard Deviation
std_dev_ML_UNIGE = std(MAG_UNIGE_GIT);
% Mad     - Mean Absolute Deviation
mad_ML_UNIGE     = mad(MAG_UNIGE_GIT);

% Insert Statistical Parameters
stats_text_ML_UNIGE = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_ML_UNIGE,...
                              median_ML_UNIGE,...
                              std_dev_ML_UNIGE,...
                              mad_ML_UNIGE);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ML_UNIGE, ...             % Testo contenuto nel box
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

% Salvataggio in PDF
% print(gcf, 'UNIGE_ML_Histogram_stats.pdf', '-dpdf', '-r600'); % Salva il file come PDF ad alta risoluzione

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(31)
hold on
box on
grid on
axis on
ax31 = gca;
ax31.FontName = 'Arial';
ax31.FontSize = 12;
ax31.XTick    = 1:0.5:5.5;
h3_1 = histogram(MAG_AFAD_GIT,edges,'FaceColor',[0 0.4470 0.7410]);
xlabel ('M_{L}- Local Magnitude','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')
axis([0.5 6 0 1600])

%%% FROM HERE ON...

% Mean    - Media
mean_ML_AFAD    = mean(MAG_AFAD_GIT);
% Median  - Mediana
median_ML_AFAD  = median(MAG_AFAD_GIT);
% Std     - Standard Deviation
std_dev_ML_AFAD = std(MAG_AFAD_GIT);
% Mad     - Mean Absolute Deviation
mad_ML_AFAD     = mad(MAG_AFAD_GIT);

% Insert Statistical Parameters
stats_text_ML_AFAD = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_ML_AFAD,...
                              median_ML_AFAD,...
                              std_dev_ML_AFAD,...
                              mad_ML_AFAD);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ML_AFAD, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Configurazione per il salvataggio in PDF
fig31_hz = 22;  % Larghezza in cm
fig31_vt = 15;  % Altezza in cm
% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperSize', [fig31_hz fig31_vt], ...
         'PaperPosition', [0, 0, fig31_hz, fig31_vt]);

% Salvataggio in PDF
% print(gcf, 'AFAD_ML_Histogram_stats_blue.pdf', '-dpdf', '-r600'); % Salva il file come PDF ad alta risoluzione

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(32)
hold on
box on
grid on
axis on
ax32 = gca;
ax32.FontName = 'Arial';
ax32.FontSize = 12;
ax32.XTick    = 1:0.5:5.5;
h3_2 = histogram(MAG_UNIGE_GIT,edges,'FaceColor',[0.8500 0.3250 0.0980]);
xlabel ('M_{L}- Local Magnitude','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')
axis([0.5 6 0 1600])

% Mean    - Media
mean_ML_UNIGE    = mean(MAG_UNIGE_GIT);
% Median  - Mediana
median_ML_UNIGE  = median(MAG_UNIGE_GIT);
% Std     - Standard Deviation
std_dev_ML_UNIGE = std(MAG_UNIGE_GIT);
% Mad     - Mean Absolute Deviation
mad_ML_UNIGE     = mad(MAG_UNIGE_GIT);

% Insert Statistical Parameters
stats_text_ML_UNIGE = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_ML_UNIGE,...
                              median_ML_UNIGE,...
                              std_dev_ML_UNIGE,...
                              mad_ML_UNIGE);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ML_UNIGE, ...             % Testo contenuto nel box
           'FontName', 'Arial', ...              % Font del testo
           'FontSize', 10, ...                   % Dimensione del font
           'FontWeight', 'Bold', ...             % Grassetto
           'EdgeColor', 'black', ...             % Colore del bordo (nero)
           'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Configurazione per il salvataggio in PDF
fig32_hz = 22;  % Larghezza in cm
fig32_vt = 15;  % Altezza in cm
% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperSize', [fig32_hz fig32_vt], ...
         'PaperPosition', [0, 0, fig32_hz, fig32_vt]);

% Salvataggio in PDF
% print(gcf, 'UNIGE_ML_Histogram_stats_red.pdf', '-dpdf', '-r600'); % Salva il file come PDF ad alta risoluzione

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% THIS WORK DEV ST OF Ml %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
hold on
box on
grid on
axis on
ax4 = gca;
ax4.FontName = 'Arial';
ax4.FontSize = 12;
ax4.XTick = -0.05:0.10:0.75;
hold on
h4 = histogram(TABLE_EVENTS_OK_QC.StdMl,edges_std_mag,'FaceColor',[0.8 0.8 0.8]);
xlabel ('\sigma of M_{L}- Standard Deviation of Local Magnitude','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')

axis([0 0.70 0 2000])

% Mean    - Media
mean_std_ML_UNIGE        = mean(TABLE_EVENTS_OK_QC.StdMl);
% Median  - Mediana
median_std_ML_UNIGE      = median(TABLE_EVENTS_OK_QC.StdMl);
% Std     - Standard Deviation
std_dev_std_ML_UNIGE     = std(TABLE_EVENTS_OK_QC.StdMl);
% Mad     - Mean Absolute Deviation
mad_std_dev_ML_UNIGE = mad(TABLE_EVENTS_OK_QC.StdMl);

% Insert Statistical Parameters
stats_text_ML_UNIGE = sprintf(['Events: %d\n',...
                              'Mean: %.2f\n',...
                              'Median: %.2f\n',...
                              'SD: %.2f\n',...
                              'MAD: %.2f\n'],...
                              num_events,...
                              mean_std_ML_UNIGE,...
                              median_std_ML_UNIGE,...
                              std_dev_std_ML_UNIGE,...
                              mad_std_dev_ML_UNIGE);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
           'String', stats_text_ML_UNIGE, ...             % Testo contenuto nel box
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

% Salvataggio in PDF
% print(gcf, 'Std_magnitude_UNIGE_stats', '-dpdf', '-r600'); % Salva il file come PDF ad alta risoluzione

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFAD CATALOG DEPTH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5)
hold on
box on
grid on
axis on
ax5 = gca;
ax5.XTick = 0:1:26;
d_AFAD = histogram(DEPTH_AFAD_GIT,edges_depth_ok,'FaceColor',[0 0.4470 0.7410]);
hold on
xlabel('Depth [km]','FontName','Arial','FontWeight','Bold')
ylabel('# Events','FontName','Arial','FontWeight','Bold')
axis([-1 21 0 5100])

% Print the figure as PDF
fig5_hz = 22;
fig5_vt = 15;

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig5_hz fig5_vt],'PaperPosition',[0, 0, fig5_hz, fig5_vt])

% Mean    - Media
mean_DEPTH_AFAD_GIT    = mean(DEPTH_AFAD_GIT);
% Median  - Mediana
median_DEPTH_AFAD_GIT  = median(DEPTH_AFAD_GIT);
% Std     - Standard Deviation
std_dev_DEPTH_AFAD_GIT = std(DEPTH_AFAD_GIT);
% Mad     - Mean Absolute Deviation
mad_dev_ML_DEPTH_AFAD_GIT = mad(DEPTH_AFAD_GIT);

% Insert Statistical Parameters
stats_text_DEPTH_AFAD = sprintf(['Events: %d\n',...
                               'Mean: %.2f\n',...
                               'Median: %.2f\n',...
                               'SD: %.2f\n',...
                               'MAD: %.2f\n'],...
                               num_events,...
                               mean_DEPTH_AFAD_GIT,...
                               median_DEPTH_AFAD_GIT,...
                               std_dev_DEPTH_AFAD_GIT,...
                               mad_dev_ML_DEPTH_AFAD_GIT);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
            'String', stats_text_DEPTH_AFAD, ...             % Testo contenuto nel box
            'FontName', 'Arial', ...              % Font del testo
            'FontSize', 10, ...                   % Dimensione del font
            'FontWeight', 'Bold', ...             % Grassetto
            'EdgeColor', 'black', ...             % Colore del bordo (nero)
            'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
          'PaperSize', [fig5_hz fig5_vt], ...
          'PaperPosition', [0, 0, fig5_hz, fig5_vt]);

% Salvataggio in PDF
% print(gcf, 'DEPTH_AFAD_GIT_ok_stats', '-dpdf', '-r600'); % Salva il file come PDF ad alta risoluzione

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% THIS WORK DEPTH %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6)
hold on
box on
grid on
axis on
ax6 = gca;
ax6.XTick = 0:1:26;
d_UNIGE = histogram(DEPTH_UNIGE_GIT,edges_depth_ok,'FaceColor',[0.8500 0.3250 0.0980]);
hold on
xlabel ('Depth [km]','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')
axis([-1 21 0 5100])

% Print the figure as PDF
fig6_hz = 22;
fig6_vt = 15;

% Mean    - Media
mean_DEPTH_UNIGE_GIT    = mean(DEPTH_UNIGE_GIT);
% Median  - Mediana
median_DEPTH_UNIGE_GIT  = median(DEPTH_UNIGE_GIT);
% Std     - Standard Deviation
std_dev_DEPTH_UNIGE_GIT = std(DEPTH_UNIGE_GIT);
% Mad     - Mean Absolute Deviation
mad_dev_ML_DEPTH_UNIGE_GIT = mad(DEPTH_UNIGE_GIT);

% Insert Statistical Parameters
stats_text_DEPTH_UNIGE = sprintf(['Events: %d\n',...
                               'Mean: %.2f\n',...
                               'Median: %.2f\n',...
                               'SD: %.2f\n',...
                               'MAD: %.2f\n'],...
                               num_events,...
                               mean_DEPTH_UNIGE_GIT,...
                               median_DEPTH_UNIGE_GIT,...
                               std_dev_DEPTH_UNIGE_GIT,...
                               mad_dev_ML_DEPTH_UNIGE_GIT);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
            'String', stats_text_DEPTH_UNIGE, ...             % Testo contenuto nel box
            'FontName', 'Arial', ...              % Font del testo
            'FontSize', 10, ...                   % Dimensione del font
            'FontWeight', 'Bold', ...             % Grassetto
            'EdgeColor', 'black', ...             % Colore del bordo (nero)
            'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Fit Figure to the page
set(gcf, 'PaperUnits', 'centimeters', ...
          'PaperSize', [fig6_hz fig6_vt], ...
          'PaperPosition', [0, 0, fig6_hz, fig6_vt]);

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('DEPTH_UNIGE_GIT_ok_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NUMBER OF P-PHASES USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(8)
hold on
box on
grid on
axis on
ax8 = gca;
ax8.FontSize = 12;

h_p = histogram(TABLE_EVENTS_OK_QC.Np,edges_phase,'FaceColor',[0.9290 0.6940 0.1250]);

xlabel ('# P-phases','FontName','Arial','FontSize',12,'FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontSize',12,'FontWeight','Bold')
axis([-1 36 0 1100]);

% Print the figure as PDF
fig8_hz = 22;
fig8_vt = 15;

% Mean    - Media
mean_Np    = round(mean(TABLE_EVENTS_OK_QC.Np));
% Median  - Mediana
median_Np  = median(TABLE_EVENTS_OK_QC.Np);
% Std     - Standard Deviatio
std_dev_Np = std(TABLE_EVENTS_OK_QC.Np);
% Mad     - Mean Absolute Deviation
mad_dev_Np = mad(TABLE_EVENTS_OK_QC.Np);

% Insert Statistical Parameters
stats_text_Np = sprintf(['Events: %d\n',...
                               'Mean: %.2f\n',...
                               'Median: %.2f\n',...
                               'SD: %.2f\n',...
                               'MAD: %.2f\n'],...
                                num_events,...
                                mean_Np,...
                                median_Np,...
                                std_dev_Np,...
                                mad_dev_Np);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
            'String', stats_text_Np, ...             % Testo contenuto nel box
            'FontName', 'Arial', ...              % Font del testo
            'FontSize', 9.15, ...                   % Dimensione del font
            'FontWeight', 'Bold', ...             % Grassetto
            'EdgeColor', 'black', ...             % Colore del bordo (nero)
            'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig8_hz fig8_vt],'PaperPosition',[0, 0, fig8_hz, fig8_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('Np_ok_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NUMBER OF S-PHASES USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(9)
hold on
box on
grid on
axis on
ax9 = gca;
ax9.FontSize = 12;

h_s = histogram(TABLE_EVENTS_OK_QC.Ns,edges_phase,'FaceColor',[0.4660 0.6740 0.1880]);

xlabel ('# S-phases','FontName','Arial','FontSize',12,'FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontSize',12,'FontWeight','Bold')
axis([-1 36 0 1100]);

% Print the figure as PDF
fig9_hz = 22;
fig9_vt = 15;

% Mean    - Media
mean_Ns    = round(mean(TABLE_EVENTS_OK_QC.Ns));
% Median  - Mediana
median_Ns  = median(TABLE_EVENTS_OK_QC.Ns);
% Std     - Standard Deviatio
std_dev_Ns = std(TABLE_EVENTS_OK_QC.Ns);
% Mad     - Mean Absolute Deviation
mad_dev_Ns = mad(TABLE_EVENTS_OK_QC.Ns);

% Insert Statistical Parameters
stats_text_Ns = sprintf(['Events: %d\n',...
                               'Mean: %.2f\n',...
                               'Median: %.2f\n',...
                               'SD: %.2f\n',...
                               'MAD: %.2f\n'],...
                                num_events,...
                                mean_Ns,...
                                median_Ns,...
                                std_dev_Ns,...
                                mad_dev_Ns);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
            'String', stats_text_Ns, ...             % Testo contenuto nel box
            'FontName', 'Arial', ...              % Font del testo
            'FontSize', 9.15, ...                   % Dimensione del font
            'FontWeight', 'Bold', ...             % Grassetto
            'EdgeColor', 'black', ...             % Colore del bordo (nero)
            'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig9_hz fig9_vt],'PaperPosition',[0, 0, fig9_hz, fig9_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('Ns_ok_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NUMBER OF TOTAL PHASES USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10)
hold on
box on
grid on
axis on
ax10 = gca;
ax10.FontSize = 12;

histogram(TABLE_EVENTS_OK_QC.Ntot,'FaceColor',[0.4940 0.1840 0.5560]);
xlabel ('# P- and S- phases','FontName','Arial','FontWeight','Bold')
ylabel ('# Events','FontName','Arial','FontWeight','Bold')
axis([-1 65 0 600])

% Print the figure as PDF
fig10_hz = 22;
fig10_vt = 15;

% Mean    - Media
mean_Ntot    = round(mean(TABLE_EVENTS_OK_QC.Ntot));
% Median  - Mediana
median_Ntot  = median(TABLE_EVENTS_OK_QC.Ntot);
% Std     - Standard Deviatio
std_dev_Ntot = std(TABLE_EVENTS_OK_QC.Ntot);
% Mad     - Mean Absolute Deviation
mad_dev_Ntot = mad(TABLE_EVENTS_OK_QC.Ntot);

% Insert Statistical Parameters
stats_text_Ntot = sprintf(['Events: %d\n',...
                               'Mean: %.2f\n',...
                               'Median: %.2f\n',...
                               'SD: %.2f\n',...
                               'MAD: %.2f\n'],...
                                num_events,...
                                mean_Ntot,...
                                median_Ntot,...
                                std_dev_Ntot,...
                                mad_dev_Ntot);

% Aggiunta del box con i parametri statistici
annotation('textbox', [0.73, 0.73, 0.134, 0.16], ...  % Posizione e dimensioni del box (in coordinate normalizzate)
            'String', stats_text_Ntot, ...             % Testo contenuto nel box
            'FontName', 'Arial', ...              % Font del testo
            'FontSize', 9.15, ...                   % Dimensione del font
            'FontWeight', 'Bold', ...             % Grassetto
            'EdgeColor', 'black', ...             % Colore del bordo (nero)
            'BackgroundColor', [1, 1, 1]);  % Colore di sfondo (grigio chiaro)

% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig10_hz fig10_vt],'PaperPosition',[0, 0, fig10_hz, fig10_vt])

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('Ntot_ok_stats','-dpdf','-r600'); % Save as PDF with resolution (dpi)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPIRICAL CUMULATIVE DISTRIBUTION P AND S PHASES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(11)
hold on
grid on
box on
axis on
ax12 = gca;
ax12.FontSize = 12;

h1(1,2) = cdfplot(TABLE_EVENTS_OK_QC.Np);
h1(:,2).Color = [0.9290 0.6940 0.1250 0.9];
% Increase line thickness
h1(1,2).LineWidth = 2;

h2(1,2) = cdfplot(TABLE_EVENTS_OK_QC.Ns);
h2(:,2).Color = [0.4660 0.6740 0.1880 0.9];
% Increase line thickness
h2(1,2).LineWidth = 2;

xlabel('Number of phases','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('Empirical Cumulative Distribution','FontName','Arial','FontSize',12,'FontWeight','bold')
title('')

axis([-0.1 35.1 -0.01 1.01])

legend('P phases','S phases','Location','northwest')

% Print the figure as PDF
fig11_hz = 22;
fig11_vt = 15;
% Fit figure to the page
set(gcf,'PaperUnits','centimeters','PaperSize',[fig11_hz fig11_vt],'PaperPosition',[0, 0, fig11_hz, fig11_vt])

% %%% SAVE PDF IMAGE %%%
% Print in PDF
% print('P_S_cumulative','-dpdf','-r600'); % Save as PDF with resolution (dpi)

toc;
