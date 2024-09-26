%clustering 
close all
clear all
shipInitialwaypoints

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

N = 100; % Population size
numGenerations = 1;
MaxEvaluation = numGenerations*N; %100*N; % Maximum number of evaluations

searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";
ship = "remus100";

initalPoints = waypoints(ship) 
R_switch = initalPoints.R_switch;
numMetrics = 3;
figureNumber = 1;
plotPath = false;


if searchProcess == "randomSearch"
    startExperiment = 1000;
    maxExperiments = 1000;
    populationSize = 20;
    numGenerations = 511;
else
    startExperiment = 20;
    maxExperiments = 20;
    populationSize = 10; 
    numGenerations = 1000;
end

%basepath = "/Users/karolinen/Documents/MATLAB/Simulators/ExperimentFunctions/multiobjectiveSearch/results/";


%experimentPerformance = [];
%totalObjectives = [];
experimentPopulation = [];
experimentObjecitves = [];
generationIdx = [] 
for experimentNumber = startExperiment:maxExperiments
    
    for generation = 1:numGenerations
        %generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
        %generationPath = "/Users/karolinen/Documents/MATLAB/Simulators/ExperimentFunctions/multiobjectiveSearch/results/remus100/exNum11-19/minDistanceMaxPath-P10-exNum19-g931" %append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
      
        %load(generationPath);
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
        
           
        
        Dec = Population.decs;
        Obj = Population.objs;
        experimentPopulation = [experimentPopulation; Dec];
        experimentObjecitves = [experimentObjecitves; Obj];
        generationIdx = [generationIdx; ones(length(Obj),1)*generation]

        
    end
end


[pop_idx, pop_corepts] = dbscan(experimentPopulation, 2.5, 10)
[obj_idx, obj_corepts] = dbscan(experimentObjecitves, 0.5, 10)

obj_idx