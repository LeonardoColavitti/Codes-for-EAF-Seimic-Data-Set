% HYPO_DIST_ML
%
% Heatmap Hypocentral Distance vs Local Magnitude.
%
% INPUT FILES:
% [Output from the script PGA_PGV_selection.m]
%
% - PGA
% - 2. FAS @0.5 Hz      X % Max 255     [SM - A]
% - 3. FAS @1 Hz        X % Max 309     [BODY TEXT]
% - 4. FAS @2 Hz        X % Max 332     [SM - B]
% - 5. FAS @5 Hz        X % Max 333     [SM - C]
% - 6. FAS @10 Hz       X % Max 327     [SM - D]
% - 7. FAS @15 Hz       X % Max 305     [SM - E]
% - 8. FAS @20 Hz       X % Max 249     [SM - F]
% - 9. FAS @25 Hz       X % Max 169     [SM - G]
%
% OUTPUT:
% - hypo_Ml_ok_0_5_QC.pdf
% - hypo_Ml_ok_1_QC.pdf
% - hypo_Ml_ok_2_QC.pdf
% - hypo_Ml_ok_5_QC.pdf
% - hypo_Ml_ok_10_QC.pdf
% - hypo_Ml_ok_15_QC.pdf
% - hypo_Ml_ok_20_QC.pdf
% - hypo_Ml_ok_25_QC.pdf
%
% This script generates FIGURE 4 (and some Supp Figures) of the DataPaper published in Earth Science System Data:
% A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
% by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa
%
% Leonardo Colavitti - 20 September 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close everything
close all; clear; clc;

% Start Clock
tic;

TABLE_FAS_0_5Hz_QC = readtable('FAS_000.50.csv');       % 76795
TABLE_FAS_1Hz_QC   = readtable('FAS_001.00.csv');       % 93638
TABLE_FAS_2Hz_QC   = readtable('FAS_001.99.csv');       % 97856
TABLE_FAS_5Hz_QC   = readtable('FAS_005.00.csv');       % 97918
TABLE_FAS_10Hz_QC  = readtable('FAS_009.98.csv');       % 97157
TABLE_FAS_15Hz_QC  = readtable('FAS_014.93.csv');       % 86156
TABLE_FAS_20Hz_QC  = readtable('FAS_019.91.csv');       % 63484

% Creation of the Grid
edgesX = 4:4:150;       % Range for Distance
edgesY = 2:0.1:5.5;     % Range for Magnitude


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 0.5 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @0.5 Hz
HYPO_DIST_0_5   = TABLE_FAS_0_5Hz_QC.Dist_Hypo;
ML_0_5          = TABLE_FAS_0_5Hz_QC.Ml;

edgesX_0_5 = edgesX;
edgesY_0_5 = edgesY;

% Count the number of events in each cell of the grid
[counts_0_5, edgesX_0_5, edgesY_0_5,binX_0_5,binY_0_5] = histcounts2(HYPO_DIST_0_5, ML_0_5, edgesX_0_5, edgesY_0_5);
% Creation of the Matrix to Visualize
heatmapMatrix_0_5 = zeros(length(edgesY_0_5)-1, length(edgesX_0_5)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_0_5)
    if binX_0_5(i) > 0 && binY_0_5(i) > 0
        heatmapMatrix_0_5(binY_0_5(i), binX_0_5(i)) = heatmapMatrix_0_5(binY_0_5(i), binX_0_5(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @0.5 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(2)
box on
imagesc(edgesX_0_5(1:end-1), edgesY_0_5(1:end-1), heatmapMatrix_0_5);
axis xy;
ax2 = gca;
ax2.FontSize = 12;
set(figure(2), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax2, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c2 = colorbar;
clim([0 335])
%c2.Limits = [0 255];
c2.FontName = 'Arial';
c2.FontSize = 10;
c2.Label.String = '# Counts';
c2.Label.FontWeight = 'bold';
figure(2)
ax2.XTick = 0:30:150;
ax2.XTickLabel = {'0';'30';'60';'90';'120';'150'};
axis([-2 150 1.9 5.5])
title('FAS at 0.5 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
% print('hypo_Ml_ok_0_5_QC','-dpdf','-r600');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 1 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @1 Hz
HYPO_DIST_1   = TABLE_FAS_1Hz_QC.Dist_Hypo;
ML_1          = TABLE_FAS_1Hz_QC.Ml;

edgesX_1 = edgesX;
edgesY_1 = edgesY;

% Count the number of events in each cell of the grid
[counts_1, edgesX_1, edgesY_1,binX_1,binY_1] = histcounts2(HYPO_DIST_1, ML_1, edgesX_1, edgesY_1);
% Creation of the Matrix to Visualize
heatmapMatrix_1 = zeros(length(edgesY_1)-1, length(edgesX_1)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_1)
    if binX_1(i) > 0 && binY_1(i) > 0
        heatmapMatrix_1(binY_1(i), binX_1(i)) = heatmapMatrix_1(binY_1(i), binX_1(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @1 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(3)
box on
imagesc(edgesX_1(1:end-1), edgesY_1(1:end-1), heatmapMatrix_1);
axis xy;
ax3 = gca;
ax3.FontSize = 12;
set(figure(3), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax3, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c3 = colorbar;
clim([0 335])
%c3.Limits = [0 309];
c3.FontName = 'Arial';
c3.FontSize = 10;
c3.Label.String = '# Counts';
c3.Label.FontWeight = 'bold';
figure(3)
ax3.XTick = 0:30:150;
ax3.XTickLabel = {'0';'30';'60';'90';'120';'150'};
title('FAS at 1 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
axis([-2 150 1.9 5.5])
% print('hypo_Ml_ok_1_QC','-dpdf','-r600');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 2 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @2 Hz
HYPO_DIST_2   = TABLE_FAS_2Hz_QC.Dist_Hypo;
ML_2          = TABLE_FAS_2Hz_QC.Ml;

edgesX_2 = edgesX;
edgesY_2 = edgesY;

% Count the number of events in each cell of the grid
[counts_2, edgesX_2, edgesY_2,binX_2,binY_2] = histcounts2(HYPO_DIST_2, ML_2, edgesX_2, edgesY_2);
% Creation of the Matrix to Visualize
heatmapMatrix_2 = zeros(length(edgesY_2)-1, length(edgesX_2)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_2)
    if binX_2(i) > 0 && binY_2(i) > 0
        heatmapMatrix_2(binY_2(i), binX_2(i)) = heatmapMatrix_2(binY_2(i), binX_2(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @2 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(4)
box on
imagesc(edgesX_2(1:end-1), edgesY_2(1:end-1), heatmapMatrix_2);
axis xy;
ax4 = gca;
ax4.FontSize = 12;
set(figure(4), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax4, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c4 = colorbar;
clim([0 335])
%c4.Limits = [0 332];
c4.FontName = 'Arial';
c4.FontSize = 10;
c4.Label.String = '# Counts';
c4.Label.FontWeight = 'bold';
figure(4)
ax4.XTick = 0:30:150;
ax4.XTickLabel = {'0';'30';'60';'90';'120';'150'};
title('FAS at 2 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
axis([-2 150 1.9 5.5])
% print('hypo_Ml_ok_2_QC','-dpdf','-r600');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 5 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @5 Hz
HYPO_DIST_5   = TABLE_FAS_5Hz_QC.Dist_Hypo;
ML_5          = TABLE_FAS_5Hz_QC.Ml;

edgesX_5 = edgesX;
edgesY_5 = edgesY;

% Count the number of events in each cell of the grid
[counts_5, edgesX_5, edgesY_5,binX_5,binY_5] = histcounts2(HYPO_DIST_5, ML_5, edgesX_5, edgesY_5);
% Creation of the Matrix to Visualize
heatmapMatrix_5 = zeros(length(edgesY_5)-1, length(edgesX_5)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_5)
    if binX_5(i) > 0 && binY_5(i) > 0
        heatmapMatrix_5(binY_5(i), binX_5(i)) = heatmapMatrix_5(binY_5(i), binX_5(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @5 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(5)
box on
imagesc(edgesX_5(1:end-1), edgesY_5(1:end-1), heatmapMatrix_5);
axis xy;
ax5 = gca;
ax5.FontSize = 12;
set(figure(5), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax5, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c5 = colorbar;
clim([0 335])
%c5.Limits = [0 333];
c5.FontName = 'Arial';
c5.FontSize = 10;
c5.Label.String = '# Counts';
c5.Label.FontWeight = 'bold';
figure(5)
ax5.XTick = 0:30:150;
ax5.XTickLabel = {'0';'30';'60';'90';'120';'150'};
title('FAS at 5 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
axis([-2 150 1.9 5.5])
% print('hypo_Ml_ok_5_QC','-dpdf','-r600');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 10 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @10 Hz
HYPO_DIST_10   = TABLE_FAS_10Hz_QC.Dist_Hypo;
ML_10          = TABLE_FAS_10Hz_QC.Ml;

edgesX_10 = edgesX;
edgesY_10 = edgesY;

% Count the number of events in each cell of the grid
[counts_10, edgesX_10, edgesY_10,binX_10,binY_10] = histcounts2(HYPO_DIST_10, ML_10, edgesX_10, edgesY_10);
% Creation of the Matrix to Visualize
heatmapMatrix_10 = zeros(length(edgesY_10)-1, length(edgesX_10)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_10)
    if binX_10(i) > 0 && binY_10(i) > 0
        heatmapMatrix_10(binY_10(i), binX_10(i)) = heatmapMatrix_10(binY_10(i), binX_10(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @10 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(6)
box on
imagesc(edgesX_10(1:end-1), edgesY_10(1:end-1), heatmapMatrix_10);
axis xy;
ax6 = gca;
ax6.FontSize = 12;
set(figure(6), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax6, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c6 = colorbar;
%c6.Limits = [0 327];
clim([0 335])
c6.FontName = 'Arial';
c6.FontSize = 10;
c6.Label.String = '# Counts';
c6.Label.FontWeight = 'bold';
figure(6)
ax6.XTick = 0:30:150;
ax6.XTickLabel = {'0';'30';'60';'90';'120';'150'};
title('FAS at 10 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
axis([-2 150 1.9 5.5])
% print('hypo_Ml_ok_10_QC','-dpdf','-r600');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 15 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @15 Hz
HYPO_DIST_15   = TABLE_FAS_15Hz_QC.Dist_Hypo;
ML_15          = TABLE_FAS_15Hz_QC.Ml;

edgesX_15= edgesX;
edgesY_15 = edgesY;

% Count the number of events in each cell of the grid
[counts_15, edgesX_15, edgesY_15,binX_15,binY_15] = histcounts2(HYPO_DIST_15, ML_15, edgesX_15, edgesY_15);
% Creation of the Matrix to Visualize
heatmapMatrix_15 = zeros(length(edgesY_15)-1, length(edgesX_15)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_15)
    if binX_15(i) > 0 && binY_15(i) > 0
        heatmapMatrix_15(binY_15(i), binX_15(i)) = heatmapMatrix_15(binY_15(i), binX_15(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @15 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(7)
box on
imagesc(edgesX_15(1:end-1), edgesY_15(1:end-1), heatmapMatrix_15);
axis xy;
ax7 = gca;
ax7.FontSize = 12;
set(figure(7), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax7, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c7 = colorbar;
clim([0 335])
%c7.Limits = [0 305];
c7.FontName = 'Arial';
c7.FontSize = 10;
c7.Label.String = '# Counts';
c7.Label.FontWeight = 'bold';
figure(7)
ax7.XTick = 0:30:150;
ax7.XTickLabel = {'0';'30';'60';'90';'120';'150'};
title('FAS at 15 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
axis([-2 150 1.9 5.5])
% print('hypo_Ml_ok_15_QC','-dpdf','-r600');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 20 Hz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Out FAS @20 Hz
HYPO_DIST_20   = TABLE_FAS_20Hz_QC.Dist_Hypo;
ML_20          = TABLE_FAS_20Hz_QC.Ml;

edgesX_20 = edgesX;
edgesY_20 = edgesY;

% Count the number of events in each cell of the grid
[counts_20, edgesX_20, edgesY_20,binX_20,binY_20] = histcounts2(HYPO_DIST_20, ML_20, edgesX_20, edgesY_20);
% Creation of the Matrix to Visualize
heatmapMatrix_20 = zeros(length(edgesY_20)-1, length(edgesX_20)-1);

% Populate matrix with the counts
for i = 1:length(HYPO_DIST_20)
    if binX_20(i) > 0 && binY_20(i) > 0
        heatmapMatrix_20(binY_20(i), binX_20(i)) = heatmapMatrix_20(binY_20(i), binX_20(i)) + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% HEATMAP @20 Hz %%%
%%%%%%%%%%%%%%%%%%%%%
figure(8)
box on
imagesc(edgesX_20(1:end-1), edgesY_20(1:end-1), heatmapMatrix_20);
axis xy;
ax8 = gca;
ax8.FontSize = 12;
set(figure(8), 'Units', 'centimeters', 'Position', [0, 0, 20, 16]);
set(ax8, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85]); % Imposta l'area degli assi all'interno della figura
colorbar;
hold on
grid on
box on
xlabel('Hypocentral Distance [km]','FontName','Arial','FontSize',12,'FontWeight','bold')
ylabel('M_{L}- Local Magnitude','FontName','Arial','FontSize',12,'FontWeight','bold')
colormap(redblue);
c8 = colorbar;
clim([0 335])
%c8.Limits = [0 249];
c8.FontName = 'Arial';
c8.FontSize = 10;
c8.Label.String = '# Counts';
c8.Label.FontWeight = 'bold';
figure(8)
ax8.XTick = 0:30:150;
ax8.XTickLabel = {'0';'30';'60';'90';'120';'150'};
title('FAS at 20 Hz','FontName','Arial','FontSize',12,'FontWeight','bold')
axis([-2 150 1.9 5.5])
% print('hypo_Ml_ok_20_QC','-dpdf','-r600');

% End Clock
toc;
