%% evaluate population
close all
clear all

shipInitialwaypoints

ship = "npsauv"
%ship = "mariner"
ship = "remus100"


%numExperments = 10
totalExperiements = 32
currentPath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators"
basepath = append(currentPath)
populationSize = 10

if ship == "mariner"
    %basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/remus100-minChangeMaxDistance"
    %basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/mariner/minDistanceMaxPath-P10-exNum"

    initalPoints = waypoints(ship) 
    initalPointsMatrix = [initalPoints.pos.x initalPoints.pos.y]
    experimentNumber  = 1
    for experimentNumber = 1:totalExperiements
        populationScores = evaluateMariner(initalPoints,initalPointsMatrix,experimentNumber, ship, populationSize)
        close all
    end

elseif ship == "remus100"
     %basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/remus100-minChangeMaxDistance"
     %path =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/remus100-minChangeMaxDistanceE1E10-P100"
     path = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/remus100/minDistanceMaxPath-P10-exNum1"
     basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/remus100/minDistanceMaxPath-P10-exNum"
     basePath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P10-exNum31"
     basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/remus100/minDistanceMaxPath-P10-exNum1"

    initalPoints = waypoints(ship)
    initalPointsMatrix = [initalPoints.pos.x initalPoints.pos.y initalPoints.pos.z]
    experimentNumber  = 32
    for experimentNumber = 32:totalExperiements
        populationScores = evaluateRemus(initalPoints,initalPointsMatrix,experimentNumber, ship, populationSize)
        close all
    end

elseif ship == "npsauv"
    
    %basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/npsauv-minChangeMaxDistance"
    initalPoints = waypoints(ship)
    initalPointsMatrix = [initalPoints.pos.x initalPoints.pos.y initalPoints.pos.z]

    ship = "nspauv"
    experimentNumber  = 1
    for experimentNumber = 1:totalExperiements
        populationScores = evaluateNspauv(initalPofigureNumberts,initalPointsMatrix,experimentNumber, ship, populationSize)
        close all
    end
end


function populationScores = evaluateMariner(initalPoints,initalPointsMatrix,experimentNumber, ship, populationSize, basepath)
    if nargin < 6
        currentPath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators"
        resultsPath = append(currentPath, "/multiobjectiveSearch/results/", ship)
        path = append(resultsPath, "/minDistanceMaxPath-P", string(populationSize),"-exNum", string(experimentNumber))
    else
        path = basepath
        resultsPath = basepath
    end
    %path = append(basepath,"E",string(experimentNumber))
    %path =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/nspauv/minDistanceMaxPath-P10-exNum1"
    %path = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/mariner/minDistanceMaxPath-P10-exNum7"
    


    load(path,'Dec')
    numMetrics = 3;
    figureNumber = 1;
    Delta_h = 400;
    [intialPath , state] = marinerPath(initalPoints,Delta_h, initalPoints.R_switch);
    intialScores = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPoints, initalPoints.R_switch);
    
    populationScores = zeros(size(Dec,1),numMetrics)
    
     for individualIndex = 1:size(Dec,1)
            %individ_wayPoint = Dec(individ_index,:)
        R_switch = initalPoints.R_switch;
        individual = Dec(individualIndex,:);
        numPoints = length(individual)/2;
        wpt.pos.x = [0 individual(1:numPoints)]';
        wpt.pos.y = [0 individual((numPoints+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y];
        [simdata, state] = marinerPath(wpt, Delta_h, R_switch);

        
        time = simdata(:,1);        
        x_mutated = simdata(:,5);
        y_mutated = simdata(:,6);
        generatedPath = [x_mutated y_mutated];
    
        [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, generatedPath, pointsMatrix, R_switch);
        performance = [totalDistanceBetweenWaypoints, totalSubpathDistances-intialScores(2), numMissingWaypoints];
        populationScores(individualIndex,:) = performance;
        
    
        if true % individualIndex < 10 &&  individualIndex > 2
            %figureNumber = individualIndex
            %figurePath = append(path,"-",string(figureNumber))
            figurePath = append(resultsPath,"/plots/","exNum", string(experimentNumber), "-figNum",string(figureNumber))
            figureNumber = plot2Dpostion(wpt, simdata, R_switch, figureNumber, figurePath)

        end
     end
    
    populationScores
end



function populationScores = evaluateNspauv(initalPoints,initalPointsMatrix,experimentNumber, ship, populationSize, basepath)
    if nargin < 6
        currentPath = pwd
        resultsPath = append(currentPath, "/multiobjectiveSearch/results/", ship)
        path = append(resultsPath, "/minDistanceMaxPath-P", string(populationSize),"-exNum", string(experimentNumber))
    else
        path = basepath
        resultsPath = basepath
    end
    %path = append(basepath,"E",string(experimentNumber))
    %path =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/nspauv/minDistanceMaxPath-P10-exNum1"
    %path = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/nspauv/minDistanceMaxPath-P10-exNum7"

    %path = append(basepath, string(experimentNumber))
    load(path,'Dec')
    numMetrics = 3;
    figureNumber = 1;
    
    [intialPath , ALOSdata, state] = npsauvPath(initalPoints, initalPoints.R_switch);
    
    populationScores = zeros(size(Dec,1),numMetrics)
  
     for individualIndex = 1:size(Dec,1)
            %individ_wayPoint = Dec(individ_index,:)
        R_switch = initalPoints.R_switch;
        individual = Dec(individualIndex,:);
        numPoints = length(individual)/3;
        wpt.pos.x = [0 individual(1:numPoints)]';
        wpt.pos.y = [0 individual((numPoints+1):(numPoints*2))]';
        wpt.pos.z = [0 individual((numPoints*2+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y wpt.pos.z];
        [simdata , ALOSdata, state] = npsauvPath(wpt, R_switch);
        
        time = simdata(:,1);        
        eta_mutated = simdata(:,17:22);
        x_mutated = eta_mutated(:,1);
        y_mutated = eta_mutated(:,2);
        z_mutated = eta_mutated(:,3);
        generatedPath = [x_mutated y_mutated z_mutated];
    
        [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, generatedPath, pointsMatrix, R_switch);
        performance = [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints];
        populationScores(individualIndex,:) = performance;
        
    
        if false %individualIndex < 10 &&  individualIndex > 2
            figureNumber = individualIndex
            %figurePath = append(path,"-",string(figureNumber))
            %figureNumber = plotNspauv100(simdata, ALOSdata, wpt, figureNumber, figurePath)
            figurePath = append(resultsPath,"/plots/","exNum", string(experimentNumber), "-figNum",string(figureNumber))

            figureNumber = plotnpsauv(simdata, ALOSdata, wpt, figureNumber,figurePath);
            %break
        end
     end
    
    populationScores
end

function populationScores = evaluateRemus(initalPoints,initalPointsMatrix,experimentNumber, ship, populationSize, basepath)
     if nargin < 6
        currentPath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments"
        resultsPath = append(currentPath, "/multiobjectiveSearch/results/", ship)
        path = append(resultsPath, "/minDistanceMaxPath-P", string(populationSize),"-exNum", string(experimentNumber))
    else
        path = basepath
        resultsPath = basepath
    end
    
    %path = append(basepath,"E",string(experimentNumber))
    %path =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/nspauv/minDistanceMaxPath-P10-exNum1"
    %path = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/remus100/minDistanceMaxPath-P10-exNum7"


    load(path,'Dec')
    numMetrics = 3;
    figureNumber = 1;
    
    [intialPath , ALOSdata, state] = remus100path(initalPoints, initalPoints.R_switch);
    
    populationScores = zeros(size(Dec,1),numMetrics)
  
     for individualIndex = 1:size(Dec,1)
            %individ_wayPoint = Dec(individ_index,:)
        R_switch = initalPoints.R_switch;
        individual = Dec(individualIndex,:);
        numPoints = length(individual)/3;
        wpt.pos.x = [0 individual(1:numPoints)]';
        wpt.pos.y = [0 individual((numPoints+1):(numPoints*2))]';
        wpt.pos.z = [0 individual((numPoints*2+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y wpt.pos.z];
        [simdata , ALOSdata, state] = remus100path(wpt, R_switch);
        
        time = simdata(:,1);        
        eta_mutated = simdata(:,18:23);
        x_mutated = eta_mutated(:,1);
        y_mutated = eta_mutated(:,2);
        z_mutated = eta_mutated(:,3);
        generatedPath = [x_mutated y_mutated z_mutated];
    
        [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, generatedPath, pointsMatrix, R_switch);
        performance = [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints];
        populationScores(individualIndex,:) = performance;
        
    
        if true % individualIndex < 10 &&  individualIndex > 2
            figureNumber = individualIndex
            figurePath = append(path,"-",string(figureNumber))
            figurePath = append(resultsPath,"/plots/","exNum", string(experimentNumber), "-figNum",string(figureNumber))
            figureNumber = plotRemus100(simdata, ALOSdata, wpt, figureNumber, figurePath)
            %break
        end
     end
    
    populationScores
end


 function [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, generatedPath, pointsMatrix, R_switch)
    [transitionIndices, subPaths] = splitDataBetweenWaypoints(pointsMatrix, R_switch,generatedPath);

    % distance between initial and new waypoints 
    distanceBetweenWaypoints  = zeros(size(pointsMatrix,1),1);
    for pointIndex = 1:size(pointsMatrix,1)
        distanceBetweenWaypoints(pointIndex) = pdist2(initalPointsMatrix(pointIndex,:), pointsMatrix(pointIndex,:),'euclidean');
    end
    totalDistanceBetweenWaypoints = sum(distanceBetweenWaypoints);

    transitionIndices = [1; transitionIndices]; 
    subPathDistances = zeros(length(transitionIndices)-1,1);
    for pointIndex = 1:length(transitionIndices)-1
        startPoint = generatedPath(transitionIndices(pointIndex),:);
        endPoint = generatedPath(transitionIndices(pointIndex+1),:);
        subpathLength = transitionIndices(pointIndex+1) - transitionIndices(pointIndex);
        pointDistance = pdist2(startPoint,endPoint);

        subPathDistances(pointIndex) = subpathLength/pointDistance;
    end
    totalSubpathDistances = sum(subPathDistances);


    % missing waypoints
    numMissingWaypoints = size(pointsMatrix,1) - length(transitionIndices)
    

    
 end

function figureNumber = plotRemus100(simdata, ALOSdata, wpt, figureNumber, filelocation)
    ControlFlag = 3;
    R_switch = 5;

    %% PLOTS
    scrSz = get(0, 'ScreenSize'); % Returns [left bottom width height]
    legendLocation = 'best'; legendSize = 12;
    if isoctave; legendLocation = 'northeast'; end
    
    % simdata = [t z_d theta_d psi_d r_d Vc betaVc wc ui' x']
    t       = simdata(:,1);
    z_d     = simdata(:,2);
    theta_d = simdata(:,3);
    psi_d   = simdata(:,4);
    r_d     = simdata(:,5);
    Vc      = simdata(:,6);
    betaVc  = simdata(:,7);
    wc      = simdata(:,8);
    u       = simdata(:,9:11);
    nu      = simdata(:,12:17);
    
    eta = simdata(:,18:23);

    figureNumber = plot2DpostionRemus(eta, wpt, legendLocation, legendSize,scrSz, R_switch, figureNumber, filelocation);
    figureNumber = plot3Dposition(eta, wpt,legendLocation,legendSize,scrSz, R_switch, figureNumber, filelocation)

end


function figureNumber = plotnpsauv(simdata, ALOSdata, wpt, figureNumber, filelocation)
    ControlFlag = 3;
    R_switch = 5;

    %% PLOTS
    scrSz = get(0, 'ScreenSize'); % Returns [left bottom width height]
    legendLocation = 'best'; legendSize = 12;
    if isoctave; legendLocation = 'northeast'; end
    
    eta = simdata(:,17:22);

    figureNumber = plot2DpostionRemus(eta, wpt, legendLocation, legendSize,scrSz, R_switch, figureNumber, filelocation);
    figureNumber = plot3Dposition(eta, wpt,legendLocation,legendSize,scrSz, R_switch, figureNumber, filelocation);

end


function figureNumber = plot3Dposition(eta, wpt,legendLocation,legendSize, scrSz, R_switch, figureNumber, filelocation)
    %% 3-D position plot with waypoints
    if ~isoctave;set(gcf,'Position',[300,200,scrSz(3)/3,scrSz(4)/2]);end
    figure(figureNumber)
    plot3(eta(:,2),eta(:,1),eta(:,3))
    hold on;
    %plot3(wpt.pos.y, wpt.pos.x, wpt.pos.z, 'ro', 'MarkerSize', 15);
    plot3(wpt.pos.y, wpt.pos.x, wpt.pos.z, 'ro', 'MarkerSize', R_switch);
    hold off
    title('North-East-Down plot (m)')
    xlabel('East'); ylabel('North'); zlabel('Down');
    legend('Actual path','Waypoints','Location',legendLocation),grid
    set(gca, 'ZDir', 'reverse');
    set(findall(gcf,'type','line'),'linewidth',2)
    set(findall(gcf,'type','text'),'FontSize',14)
    set(findall(gcf,'type','legend'),'FontSize',legendSize)
    view(-25, 30);  % view(AZ,EL)
    saveas(gcf, append(filelocation, "-3Dposition.png"))
    figureNumber = figureNumber + 1;
end


function figureNumber = plot2DpostionRemus(eta, wpt, legendLocation, legendSize, scrSz, R_switch, figureNumber, filelocation)
    %% 2-D position plots with waypoints
    figure(figureNumber)
    if ~isoctave;set(gcf,'Position',[300,200,scrSz(3)/3,scrSz(4)/2]);end
    subplot(211);
    plot(eta(:,2), eta(:,1));
    hold on;
    %plot(wpt.pos.y, wpt.pos.x, 'rx', 'MarkerSize', 10);
    plot(wpt.pos.y, wpt.pos.x, 'rx', 'MarkerSize', R_switch);
    hold off;
    xlabel('East');
    ylabel('North');
    title('North-East plot (m)');
    xlim([0, 2500]);
    axis('equal');
    grid on;
    subplot(212);
    plot(eta(:,2), eta(:,3));
    hold on;
    plot(wpt.pos.y, wpt.pos.z, 'rx', 'MarkerSize', 10);
    hold off;
    xlim([0, 2500]);
    ylim([0, 150]);
    xlabel('East');
    ylabel('Down');
    title('Down-East plot (m)');
    grid on;
    legend('Actual path', 'Waypoints', 'Location', legendLocation);
    set(findall(gcf, 'type', 'line'), 'LineWidth', 2);
    set(findall(gcf, 'type', 'text'), 'FontSize', 14);
    set(findall(gcf, 'type', 'legend'), 'FontSize', legendSize);
    saveas(gcf, append(filelocation, "-2Dposition.png"))
    figureNumber = figureNumber + 1
end


function figureNumber = plot2Dpostion(wpt, simdata, R_switch, figureNumber, filelocation)
    scrSz = get(0, 'ScreenSize'); % Returns [left bottom width height]
    wayPoints = [wpt.pos.x wpt.pos.y];
    x     = simdata(:,5);
    y     = simdata(:,6);
    %% 2-D position plots with waypoints
    figure(figureNumber)
    set(gcf,'Position',[1,1, 1.0*scrSz(4),1.0*scrSz(4)],'Visible','off');
    hold on;
    plot(y,x,'b');  % Plot vehicle position
    plotStraightLinesAndCircles(wayPoints, R_switch);
    xlabel('East (m)', 'FontSize', 14);
    ylabel('North (m)', 'FontSize', 14);
    title('North-East Positions (m)', 'FontSize', 14);
    axis equal;
    grid on;
    set(findall(gcf,'type','line'),'linewidth',2);
    set(findall(gcf,'type','legend'),'FontSize',12);
    set(figureNumber,'Visible', 'on'); 
    saveas(gcf, append(filelocation, "-2Dposition.png"))
    figureNumber = figureNumber + 1
end


function plotStraightLinesAndCircles(wayPoints, R_switch)%, filelocation)
    legendLocation = 'northeast';
    
    % Plot straight lines and circles for straight-line path following
    for idx = 1:length(wayPoints(:,1))-1
        if idx == 1
            plot([wayPoints(idx,2),wayPoints(idx+1,2)],[wayPoints(idx,1),...
                wayPoints(idx+1,1)], 'r--', 'DisplayName', 'Line');
        else
            plot([wayPoints(idx,2),wayPoints(idx+1,2)],[wayPoints(idx,1),...
                wayPoints(idx+1,1)], 'r--','HandleVisibility', 'off');
        end
    end

    theta = linspace(0, 2*pi, 100);
    for idx = 1:length(wayPoints(:,1))
        xCircle = R_switch * cos(theta) + wayPoints(idx,1);
        yCircle = R_switch * sin(theta) + wayPoints(idx,2);
        plot(yCircle, xCircle, 'k');
    end

    legend('Vessel position','Straight-line path','Circle of acceptance',...
        'Location',legendLocation);
    %saveas(gcf, append(filelocation, "-NorthEastPosition.png"))
end



