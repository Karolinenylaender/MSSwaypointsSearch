%% visualisize experiments results
close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";
searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

if searchProcess == "randomSearch"
    startExperiment = 400;
    maxExperiments = 420;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 300;
    maxExperiments = 320;
    populationSize = 100; 
    numGenerations = 10;
end
ship = "remus100";

basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";


%for experimentNumber = startExperiment:maxExperiments

experimentNumber = 403
populationSize = 100; 
numGenerations = 10;
resultsPath = append(basepath,ship,"/", "processedResults/", searchProcess,string(experimentNumber))
load(resultsPath)
experimentsResults.keys
generationResults = experimentsResults(string(experimentNumber))
performanceMatrix = []
for generationKey = 1:length(generationResults.keys)
    performance = generationResults(string(generationKey))
     
    performanceMatrix = [performanceMatrix; performance]
end


objectivesMatrix = [];
for generation = 1:numGenerations  
    %generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
    %load(generationPath)
    [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);

    objs = Population.objs;  
    objectivesMatrix = [objectivesMatrix; objs];
end

%end
searchProcess = "randomSearch";
experimentNumber = 403
populationSize = 1000;
numGenerations = 1;

RandomObjectivesMatrix = [];
generation = 1  
%generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
%load(generationPath)
[Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);

objs = Population.objs;  
RandomObjectivesMatrix = objs(2:end,:);


resultsPath = append(basepath,ship,"/", "processedResults/", searchProcess,string(experimentNumber))

load(resultsPath)
experimentsResults.keys
generationResults = experimentsResults(string(experimentNumber))
RandomPerformanceMatrix = []
for generationKey = 1:length(generationResults.keys)
    performance = generationResults(string(generationKey))
    RandomPerformanceMatrix = [RandomPerformanceMatrix; performance(2:end,:)]
end
RandomPerformanceMatrix



subplot(4,1,1)
plot(objectivesMatrix(:,1))
hold on
plot( RandomObjectivesMatrix(:,1))
title("Length of path ship takes between points")

subplot(4,1,2)
plot(objectivesMatrix(:,2))
hold on
plot(RandomObjectivesMatrix(:,2))
title("Distance between original waypoints and new waypoints")
legend("objective search", "random search")

subplot(4,1,3)
plot(performanceMatrix(:,3))
title(["objective search: number of waypoints missing is", num2str(nnz(performanceMatrix(:,3))) ] )
%ylabel("Number of missing waypoints")

subplot(4,1,4)
plot(RandomPerformanceMatrix(:,3))
title(["random search: number of waypoints missing is", num2str(nnz(RandomPerformanceMatrix(:,3))) ] )
%ylabel("Number of missing waypoints")

xlabel("Individual (Population size 100)")

