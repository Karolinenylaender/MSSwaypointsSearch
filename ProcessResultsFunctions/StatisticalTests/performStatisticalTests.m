%% run experiment statistical test
close all
clear all

ship = "remus100";
%ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;
searchProcess = "minDistanceMaxPath";


if ship == "nspauv"
    SearchValidExperiments = 1:4; 
    RandomValidExperiments = [1 2 3 4]; % 5 6 25 26 27 28 29 30];
else
    SearchValidExperiments = 1:30; 
    RandomValidExperiments = 1:30;
end

PopulationNSGASearch = loadAllShipPopulations(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
PopulationRandomSearch = loadAllShipPopulations(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations);
NSGAObjectives = PopulationNSGASearch.objs;
randomObjectives = PopulationRandomSearch.objs;
combinedObjectives = [NSGAObjectives; randomObjectives];
maxObjectives = [max(combinedObjectives(:,1)), max(combinedObjectives(:,2))];
minObjectives = [min(combinedObjectives(:,1)), min(combinedObjectives(:,2))];


NSGANormalizedHVScores = calculateSearchHvNormalized(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);
NSGAHVScores =  calculateSearchHV(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);

RandomNormalizedHVScores = calculateSearchHvNormalized(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);
RandomHVScores =  calculateSearchHV(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);


figure(1)
boxplot([NSGANormalizedHVScores(:,1), RandomNormalizedHVScores(:,1)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: Pableo function -  normalized")


figure(2)
boxplot([NSGANormalizedHVScores(:,2), RandomNormalizedHVScores(:,2)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: PlatEMO function - normalized")

figure(3)
boxplot([NSGAHVScores(:,1), RandomHVScores(:,1)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: PlatEMO function - not normalized")

figure(4)
boxplot([NSGAHVScores(:,2), RandomHVScores(:,2)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: PlatEMO function - not normalized")

   


function HVscores = calculateSearchHV(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues)
    HVscores = []
    referencePoint = maxValues;
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);

        scores = [hypervolume(experimentPopulation.best.objs, referencePoint, length(experimentPopulation.best.objs)) HV(experimentPopulation,referencePoint);
        HVscores = [HVscores; scores];
    end
end

function HVscores = calculateSearchHvNormalized(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues)
    HVscores = []
    referencePoint = [1 1];
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);
        experimentObjectives = experimentPopulation.objs;

        normalizedObjecitves = (experimentObjectives - minValues.*ones(length(experimentObjectives),length(minValues))) ./ (maxValues-minValues);
        experimentPopulation = SOLUTION(experimentPopulation.decs, normalizedObjecitves, experimentPopulation.cons);
        scores = [hypervolume(experimentPopulation.best.objs, referencePoint, length(experimentPopulation.best.objs)) HV(experimentPopulation,referencePoint)]

        HVscores = [HVscores; scores];
    end
end



