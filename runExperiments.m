%% Initialize the problem
populationSize = 10; 
numGenerations = 2 %000;
maxEvaluation = numGenerations*PopulationSize;
startExperiment = 1000;
numExperiments = 1;
endExperiment = startExperiment+numExperiments;


resultsPathInfo = what("ExperimentsResults");
resultsPath = char(resultsPathInfo.path);


searchProcess = "minDistanceMaxPath"
searchProcess = "minDistanceMaxPath";
%ship = "mariner"
%ship = "nspauv"
ship = "remus100"

for experiement = startExperiment:endExperiment
    [Dec,Obj,Con] = performSearch(ship, searchProcess, resultsPath, experiement, numGenerations, populationSize);
end
