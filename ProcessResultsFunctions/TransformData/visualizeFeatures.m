%% visulaize features
close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 4;
maxExperiments = 4 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;
featureNames = ["Length of path", "mean curvature", "max curvature", "std curvature", ...
                "max angle xy", "std angle xy", "max angle xz", "std angle xz", "max angle yz", "max angle yz"];

shipPerformance = [];
% for experimentNumber = startExperiment:maxExperiments
% 
%     [experimentPerformance, totalObjectives]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
%     figure(experimentNumber)
% 
%     for i = 1:size(experimentPerformance, 2)  % Iterate over columns (features)
%         subplot(size(experimentPerformance, 2), 1, i);  % Create subplot for each feature
%         histogram(experimentPerformance(:, i), 'Normalization', 'pdf');  % Plot density
%         title(featureNames(i));
%     end
%     h = axes('visible', 'off'); % Create invisible axes
%     ylabel(h, 'Density - number of individuals', 'visible', 'on');  % Add y-label
% 
% end


for experimentNumber = startExperiment:maxExperiments

    [experimentPerformance, totalObjectives]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    figure(experimentNumber)

    % Calculate number of rows and columns for subplots
    n = size(experimentPerformance, 2);
    nRows = ceil(sqrt(n));
    nCols = nRows;
    
    % Create a new figure
    figure('units','normalized','outerposition',[0 0 1 1]);  % Full screen figure
    
    % Plotting
    for i = 1:n  % Iterate over columns (features)
        subplot(nRows, nCols, i);  % Create subplot for each feature
        histogram(experimentPerformance(:, i), 'Normalization', 'pdf', 'EdgeColor', 'none');  % Plot density with smooth lines
        title(featureNames(i));
        grid on;  % Add grid
    end
    
    % Create an invisible axis on the whole figure, and add the common y-label
    h = axes('visible', 'off'); % Create invisible axes
    h.YLabel.Visible = 'on';  % Make y-label visible
    ylabel(h, 'Density - number of individuals', 'FontSize', 16);  % Add y-label
    
    % Improve appearance
    set(gcf, 'Color', 'w');  % Set background color to white
    set(gca, 'FontSize', 12);  % Increase axes font size

end


for experimentNumber = startExperiment:maxExperiments

    [experimentPerformance, totalObjectives]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
    figure(experimentNumber+maxExperiments)

    % Calculate correlation matrix
    corrM = corr(experimentPerformance);
    
    % Create a new figure
    figure('units','normalized','outerposition',[0 0 1 1]);  % Full screen figure
    
    % Plotting
    imagesc(corrM);  % Create heatmap
    colorbar;  % Show color scale
    colormap('parula');  % Choose color map
    
    % Improve appearance
    set(gcf, 'Color', 'w');  % Set background color to white
    set(gca, 'FontSize', 12);  % Increase axes font size
    title('Correlation Matrix Heatmap', 'FontSize', 16);  % Add title

end






