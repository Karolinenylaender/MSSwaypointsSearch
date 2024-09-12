close all
clear all

generationPath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/randomSearch-P1000-exNum200-g1";


shipInitialwaypoints

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%numExperments = 10
totalExperiements = 32;
currentPath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators";
basepath = append(currentPath)
populationSize = 10;


N = 100; % Population size
numGenerations = 1;
MaxEvaluation = numGenerations*N; %100*N; % Maximum number of evaluations

searchProcess = "randomSearch";
%searchProcess = "minDistanceMaxPath";

ship = "remus100";

initalPoints = waypoints(ship) 
R_switch = initalPoints.R_switch;
numMetrics = 3;
figureNumber = 1;
plotPath = false;


if searchProcess == "randomSearch"
    startExperiment = 400;
    maxExperiments = 425;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 401;
    maxExperiments = 420;
    populationSize = 100; 
    numGenerations = 10;
end


basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";

experimentsResults = containers.Map() ;
for experimentNumber = startExperiment:maxExperiments
    generationResults = containers.Map();
    for generation = 1:numGenerations
        
        generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
        load(generationPath)
        
        if generation == 1
            intialPath = paths('0');
            decs = Population.decs;
            intialPoints = decs(1,:);
            Dec = decs(1:end,:);
            [initalPointsMatrix,wpt] = transformListOfPointToMatrix(intialPoints, ship);
            [intialDistanceBetweenWaypoints, intialSubpathDistances, intialNumMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPointsMatrix, R_switch);
        
        else
            Dec = Population.decs;
        end
    
        populationPerformance = zeros(size(Dec,1),3);

        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));

            [pointsMatrix,wpt] = transformListOfPointToMatrix(individual, ship);
            [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, individualPath, pointsMatrix, R_switch);
            %populationPerformance(individualIndex,:) = [-totalDistanceBetweenWaypoints, totalSubpathDistances-intialSubpathDistances, numMissingWaypoints];
            %populationPerformance(individualIndex,:) = [-totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints];
            populationPerformance(individualIndex,:) = [-totalSubpathDistances totalDistanceBetweenWaypoints numMissingWaypoints];

        end
        
        generationResults(string(generation)) = populationPerformance;

    end 
    experimentsResults(string(experimentNumber)) = generationResults;
    resultsPath = append(basepath,ship,"/", "processedResults/",searchProcess ,string(experimentNumber))
    save(resultsPath, "experimentsResults")
end
experimentsResults
resultsPath = append(basepath,ship,"/", "processedResults/Full-",searchProcess, string(startExperiment), "-", string(maxExperiments))
save(resultsPath, "experimentsResults")

%scatter3(tt(:,1),tt(:,2), tt(:,3), [], c, 'filled')


function [pointsMatrix,wpt] = transformListOfPointToMatrix(Listpoints, ship)
    if ship == "mariner"
        numPoints = length(Listpoints)/2;
        wpt.pos.x = [0 Listpoints(1:numPoints)]';
        wpt.pos.y = [0 Listpoints((numPoints+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y];
    else 
        numPoints = length(Listpoints)/3;
        wpt.pos.x = [0 Listpoints(1:numPoints)]';
        wpt.pos.y = [0 Listpoints((numPoints+1):(numPoints*2))]';
        wpt.pos.z = [0 Listpoints((numPoints*2+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y wpt.pos.z];
    end
end