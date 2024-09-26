%% metrics analysis 
close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

shipInitialwaypoints
initalPoints = waypoints(ship);
R_switch = initalPoints.R_switch;
numMetrics = 10;


startExperiment = 1;
maxExperiments = 1 %startExperiment+30;
populationSize = 10; 
numGenerations = 209; %1000;

experimentPerformance = [];
totalObjectives = [];
for experimentNumber = startExperiment:maxExperiments
    
    for generation = 1:numGenerations
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
      
        Dec = Population.decs;
           
        % if generation == 1
        %     intialPath = paths('0');
        %     decs = Population.decs;
        %     intialPoints = decs(1,:);
        %     Dec = decs(1:end,:);
        %     %[initalPointsMatrix,wpt] = transformListOfPointToMatrix(intialPoints, ship);
        %     %[intialDistanceBetweenWaypoints, intialSubpathDistances, intialNumMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPointsMatrix, R_switch);
        % 
        % else
        %     Dec = Population.decs;
        % end
        Dec = Population.decs;

        generationPerformance = [];
        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullPath = individualPath('fullpath');
            transitionIndices = individualPath('transitionIndices');

            pointsMatrix  =  reshape(individual, [3, 6])';
        
            pathPerformance = evaluatePath(fullPath, transitionIndices , pointsMatrix, R_switch);
            if transitionIndices(1) == length(fullPath)
                numMissingPaths = length(pointsMatrix)-1;
                pathPerformance = ones(numMissingPaths, numMetrics);

            elseif length(transitionIndices) < (length(pointsMatrix)-1)
                %semiPathPerformance =  evaluatePath (pathSegments , pointsMatrix, R_switch);
                numMissingPaths = 5 - length(transitionIndices);
                missingPathPerformance = -ones(numMissingPaths, numMetrics);
                pathPerformance = [pathPerformance; missingPathPerformance];
            else
                pathPerformance = pathPerformance; %evaluatePath(pathSegments , pointsMatrix, R_switch);

            end
            generationPerformance = [generationPerformance; pathPerformance];
        end
        experimentPerformance =[experimentPerformance; generationPerformance];

    end
end



function pathPerformance = evaluatePath(fullPath,transitionIndices, pointsMatrix, R_switch)
    %[transitionIndices, ~] = splitDataBetweenWaypoints(pointsMatrix, R_switch,fullPath);
    curlinesResultsList = [];
    anglesResultsList = [];
    pathLengths = [];
    transitionIndices = [1; transitionIndices];
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
        curlinesResultsList= [curlinesResultsList; calculateCurvatureOfSubpath(currentPath)];
        anglesResultsList = [anglesResultsList; calculateAnglesOfSubpaths(fullPath)];
        pathLengths = [pathLengths; length(currentPath)/pdist2(startPoint,endPoint)];
        
    end
    pathPerformance = [pathLengths curlinesResultsList anglesResultsList];

end



