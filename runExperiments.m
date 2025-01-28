%% Initialize the problem
populationSize = 10; 
numGenerations = 1000;
maxEvaluation = numGenerations*populationSize;
startExperiment = 1;
numExperiments = 30;
endExperiment = numExperiments;


resultsPathInfo = what("ExperimentsResults");
resultsPath = char(resultsPathInfo.path);


searchProcess = "RndSearch";
searchProcess = "WPgenSeed"; 
%searchProcess = "WPgenComb"
%searchProcess = "WPgenRnd"

ship = "mariner";
%ship = "nspauv"; 
ship = "remus100"; 


for experiement = startExperiment:endExperiment
    [Dec,Obj,Con] = performSearch(ship, searchProcess, resultsPath, experiement, numGenerations, populationSize);
end


