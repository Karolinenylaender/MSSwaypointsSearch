%% evaluate 

% for each ship


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


N = 100; % Population size
numGenerations = 10;
MaxEvaluation = numGenerations*N; %100*N; % Maximum number of evaluations
run = 1; % Number of runs
numPopSaved = 0; % Save the result to files (0 - No, 1 - Yes)
num_experiments = 130;
searchProcess = "random"
%searchProcess = "minMax"
startExperiment = 200;
maxExperiments = 220;
ship = "remus100"
resultsPath  = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results"

initalPoints = waypoints(ship) 
R_switch = initalPoints.R_switch;
numMetrics = 3
figureNumber = 1;
plotPath = false;

if ship == "mariner"
    Delta_h = 500;
    initalPointsMatrix = [initalPoints.pos.x initalPoints.pos.y]
    [simdata , state] = marinerPath(initalPoints,Delta_h, initalPoints.R_switch);
    x     = simdata(:,5);
    y     = simdata(:,6);
    intialPath = [x y];
elseif ship == "remus100"
    initalPointsMatrix = [initalPoints.pos.x initalPoints.pos.y initalPoints.pos.z];
    [simdata , ALOSdata, state] = remus100path(initalPoints, initalPoints.R_switch);
    eta_mutated = simdata(:,18:23);
    x = eta_mutated(:,1);
    y = eta_mutated(:,2);
    z = eta_mutated(:,3);
    intialPath = [x y z];
elseif ship == "nspauv"
    initalPointsMatrix = [initalPoints.pos.x initalPoints.pos.y initalPoints.pos.z];
    [simdata , ALOSdata, state] = npsauvPath(initalPoints, initalPoints.R_switch);
    eta_mutated = simdata(:,17:22);
    x = eta_mutated(:,1);
    y = eta_mutated(:,2);
    z = eta_mutated(:,3);
    intialPath = [x y z];
end
[intialDistanceBetweenWaypoints, intialSubpathDistances, intialNumMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPointsMatrix, R_switch);


experimentsResults = containers.Map()
for experiement = startExperiment:maxExperiments
    if searchProcess == "minMax"
       shipResultsPath = append(resultsPath, "/", ship, "/", "minDistanceMaxPath", "-P", string(N), "-exNum", string(experiement));
       plotsPath = append(resultsPath, "/", ship, "/plots/", "minDistanceMaxPath", "-P", string(N), "-exNum", string(experiement));
    elseif searchProcess == "random"
       shipResultsPath = append(resultsPath, "/", ship, "/", "randomSearch", "-P", string(N), "-exNum", string(experiement));
       plotsPath = append(resultsPath, "/", ship, "/plots/", "randomSearch", "-P", string(N), "-exNum", string(experiement));
    end

    generationResults = containers.Map();
    for gen = 1:numGenerations
        generationPath = append(shipResultsPath, "-g", string(gen));
        load(generationPath,"Population");
        
        if searchProcess == "minMax"
            Dec = Population.decs;
        elseif searchProcess == "random"
            if gen >= 2
                Dec = Population
            else
                Dec = Population.decs;
            end
            numIndiviuals = size(Dec,2);
            
        end
        
        populationScores = zeros(size(Dec,1),numMetrics);
        for individualIndex = 1:size(Dec,1)
            
            individual = Dec(individualIndex,:);
            if ship == "mariner"
               performance = evaluateMarinerWaypoints(intialPath,intialDistanceBetweenWaypoints, intialSubpathDistances, initalPointsMatrix, R_switch, individual, figureNumber, plotsPath, plotPath);

            elseif ship == "remus100"
                [performance, figureNumber] = evaluateRemus100Waypoints(intialPath,intialDistanceBetweenWaypoints, intialSubpathDistances, initalPointsMatrix, R_switch, individual, figureNumber, plotsPath, plotPath);
            elseif ship == "nspauv"
            end
            populationScores(individualIndex,:) = performance;
        end
        generationResultsPath = append(generationPath,"-objectiveResults");
        save(generationResultsPath, "populationScores")
        generationResults(string(gen)) = populationScores;
    end

    experimentsResults(string(experiement)) = generationResults;
    experimentsResultsPath = append(shipResultsPath,"-experimentResults-",string(experiement));
    save(experimentsResultsPath, "generationResults");
    
    %populationScores
    populationS2cores

end

fullResults = append(shipResultsPath,"-fullResults")
save(fullResults, "experimentsResults");
