%% Initialize the problem
populationSize = 10; 
numGenerations = 1000;
maxEvaluation = numGenerations*PopulationSize;
startExperiment = 1;
numExperiments = 30;
endExperiment = startExperiment+numExperiments;


resultsPathInfo = what("ExperimentsResults");
resultsPath = char(resultsPathInfo.path);


searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";
%ship = "mariner"
%ship = "nspauv"
ship = "remus100";

for experiement = startExperiment:endExperiment
    [Dec,Obj,Con] = performSearch(ship, searchProcess, resultsPath, experiement, numGenerations, populationSize);
end
