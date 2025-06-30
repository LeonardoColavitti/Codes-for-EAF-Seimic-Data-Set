% DISTANCE_EMP_CUM_DISTRIBUTION
% Plot Graph Haversine Distance vs Empirical Cumulative Distribution.
%
% This script generates FIGURE 7 of the DataPaper published in Earth Science System Data:
% A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
% by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa
%
% Leonardo Colavitti - 13 January 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close everything
close; clear; clc;

% Start Clock
tic;

% Load Events we distribute on Zenodo
load TABLE_EVENTS_OK_QC.mat

% Events After Quality Control
TABLE_EVENTS = readtable('CatalFormat.txt'); % 9442 Events

Earth_Radius = 6371;

ID_UNIGE = TABLE_EVENTS.Id;

[index_absolute_log,index_absolute] = ismember(ID_UNIGE,TABLE_EVENTS_OK_QC.Id);

% UNIGE Coordinates
CATAL_UNIGE = [TABLE_EVENTS_OK_QC.Lon, TABLE_EVENTS_OK_QC.Lat];

% Retrieve AFAD Coordinates
CATAL_AFAD = [TABLE_EVENTS.Lon1(index_absolute_log,:), TABLE_EVENTS.Lat1(index_absolute_log,:)];

% Compute Distance in km using the Haversine Formula

distances = zeros(size(TABLE_EVENTS_OK_QC, 1), 1); % Preallocation Vector of Distances

for i = 1:size(CATAL_UNIGE, 1)
    lat1 = deg2rad(CATAL_UNIGE(i, 1));
    lon1 = deg2rad(CATAL_UNIGE(i, 2));
    lat2 = deg2rad(CATAL_AFAD(i, 1));
    lon2 = deg2rad(CATAL_AFAD(i, 2));

    deltaLat = lat2 - lat1;
    deltaLon = lon2 - lon1;

    a = sin(deltaLat / 2)^2 + cos(lat1) * cos(lat2) * sin(deltaLon / 2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distances(i) = Earth_Radius * c;
end


% Preallocate Vector of Distances
% distances = zeros(size());

% Consideration:
% Distance <= 20 - 96.74 %
% Distance <= 15 - 95.58 %
% Distance <= 10 - 92.70 %
% Distance <=  5 - 79.22 %

figure(1)
hold on
grid on
box on

ax1 = gca;

h2(1,2) = cdfplot(distances');
h2(:,2).Color = [0, 0, 1, 0.9];
% Increase line thickness
h2(1,2).LineWidth = 2;

% Plot dashed lines
plot([10 10], [0        0.927028], '--k', 'LineWidth', 1.5);
plot([0  10], [0.927028 0.927028], '--k', 'LineWidth', 1.5);

% Plot the point
plot(10,0.927028,'o','MarkerEdgeColor','k','MarkerFaceColor','r')

% Disegna linea tratteggiata
% line([x_value x_value], [0 y_value], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

% Aggiungi un cerchio sulla curva
% plot(x_value, y_value, 'ko', 'MarkerFaceColor', 'r');

xlabel('Haversine Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('Empirical Cumulative Distribution','FontName','Arial','FontSize',12,'FontWeight','bold')
title('')

xticks(0:2:20);  % Set horizontal axes every 2 km
axis([0 20 0 1]) % Limita gli assi

% Set figure size in centimeters (15 cm x 20 cm)
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [22,15]);
set(gcf, 'PaperPosition', [0, 0, 22, 15]);

% Save Figure as PDF
% print('CDF_Distance.pdf', '-dpdf', '-r600');

% End Clock
toc;
