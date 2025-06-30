% CUMULATIVE_CURVE_EVENTS_OK
%
% Draw Cumulative Events and Stations.
%
% OUTPUT:
% 1. CDF_event.pdf
% 2. CDF_station.png
% 3. CDF_event_station.png - This is the Figure 3 of the manuscript
% 4. nrecs_event.png
% 5. nrecs_station.png
%
% This script generates FIGURE 6 (and some Supp Figures) of the DataPaper published in Earth Science System Data:
% A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
% by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa
%
% Leonardo Colavitti - 19 September 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close everything
close all; clear; clc;

% Delete previous Images
delete CDF_event.pdf
delete CDF_station.pdf
delete CDF_station_event.pdf
delete hist_records_event.pdf
delete hist_records_station.pdf

% Start Clock
tic;

% Read Out PGA-PGV File [98,033 values]
TABLE_PGA_PGV = readtable('out_pgapgv_qc_ok.csv');

% Read Out Events File
TABLE_EV = readtable('out_events_catal_qc.csv');

% Allocate number of records per event
nrecs_event = zeros(length(TABLE_EV.Id),1);

% Loop on events number
for i=1:length(TABLE_EV.Id_Ref)
    nrecs_event(i,:) = length(find(TABLE_EV.Id_Ref(i) == TABLE_PGA_PGV.Var1));
end

% Give me the station
Sta =  unique(string(TABLE_PGA_PGV.Var2));

% Allocate number of records per station
nrecs_station = zeros(length(Sta),1);

for i=1:length(Sta) % START LOOP ON STATIONS

    nrecs_station(i,:) = sum(strcmp(Sta(i),string(TABLE_PGA_PGV.Var2)));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CDF per EVENT [9442 Events]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
hold on
grid on
box on

h2(1,2) = cdfplot(nrecs_event');
h2(:,2).Color = [0, 0, 1, 0.9];
% Increase line thickness
h2(1,2).LineWidth = 2;

xlabel('Number of recordings','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('Empirical Cumulative Distribution','FontName','Arial','FontSize',12,'FontWeight','bold')
title('')
% title('CDF per event','FontWeight','bold','Color','Red')

axis([5 35 -0.01 1.01])

% Figure Properties
ax1 = gca;
ax1.FontSize = 12;
set(figure(1), 'Units', 'centimeters', 'Position', [0, 0, 20, 15]);
set(gca, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('CDF_event','-dpdf','-r600'); % Save as PDF with resolution (dpi)
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CDF per STATION [174 STATIONS]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
hold on
grid on
box on

ax2 = gca;

h1(1,2) = cdfplot(nrecs_station');
h1(:,2).Color = [1, 0, 0, 0.9];
% Increase line thickness
h1(1,2).LineWidth = 2;

xlabel('Number of recordings','FontWeight','bold')
ylabel('Empirical Cumulative Distribution','FontWeight','bold')
title('')

xscale(ax2,'log')
axis([5 10000 0 1]);

% Figure Properties
ax2.FontSize = 12;
set(figure(2), 'Units', 'centimeters', 'Position', [0, 0, 20, 15]);
set(gca, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('CDF_station','-dpdf','-r600'); % Save as PDF with resolution (dpi)
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % CDF per STATION + EVENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
hold on
grid on
box on

ax3 = gca;
clear h3
h3(1,2) = cdfplot(nrecs_event');
h3(:,2).Color = [1, 0, 0, 0.9];
% Increase line thickness
h3(1,2).LineWidth = 2;

clear h4
h4(1,2) = cdfplot(nrecs_station');
h4(:,2).Color = [0, 0, 1, 0.9];
% Increase line thickness
h4(1,2).LineWidth = 2;
xscale(ax3,'log')

xlabel('Number of recordings','FontWeight','bold')
ylabel('Empirical Cumulative Distribution','FontWeight','bold')

% title('CDF per event and per station','FontWeight','bold','Color','Red')

title('')

legend('CDF per event','CDF per station','Location','SouthEast')

axis([5.5 10000 -0.01 1.01])

% Figure Properties
ax3.FontSize = 12;
set(figure(3), 'Units', 'centimeters', 'Position', [0, 0, 20, 15]);
set(gca, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura

% %%% SAVE PDF IMAGE %%%
% Print in PDF
% print('CDF_station_event','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NRECS per EVENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
hold on
grid on
box on

ax4 = gca;
h4 = histogram(sort(nrecs_event),25);
h4.FaceColor = [0.8 0.8 0.8];
h4.EdgeColor = 'k';
xlabel('Number of records','FontWeight','bold')
ylabel('# Events','FontWeight','bold')
% axis([4 40 0 2000])

% Figure Properties
ax4.FontSize = 12;
set(figure(4), 'Units', 'centimeters', 'Position', [0, 0, 20, 15]);
set(gca, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('hist_records_event','-dpdf','-r600'); % Save as PDF with resolution (dpi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NRECS per STATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5)
hold on
grid on
box on

ax5 = gca;
h5 = histogram(sort(nrecs_station),20);
h5.FaceColor = [0.8 0.8 0.8];
h5.EdgeColor = 'k';
xlabel('Number of records','FontWeight','bold')
ylabel('# Stations','FontWeight','bold')
axis([-200 5800 0 120])

% Figure Properties
ax5.FontSize = 12;
set(figure(5), 'Units', 'centimeters', 'Position', [0, 0, 20, 15]);
set(gca, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura

%%% SAVE PDF IMAGE %%%
% Print in PDF
% print('hist_records_station','-dpdf','-r600'); % Save as PDF with resolution (dpi)

% End Clock
toc;
