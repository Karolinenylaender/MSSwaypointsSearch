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
% 
% combinedRanges = [];
% for experimentNumber = SearchValidExperiments
%     experimentPopulation = loadExperimentsPopulations(ship, "minDistanceMaxPath",experimentNumber, populationSize, numGenerations);
%     experimentObjectives = experimentPopulation.objs;
%     ranges = [max(experimentObjectives(:,1)) max(experimentObjectives(:,2)) min(experimentObjectives(:,1)) min(experimentObjectives(:,2))];
%     combinedRanges = [combinedRanges; ranges];
% end
% for experimentNumber = RandomValidExperiments
%     experimentPopulation = loadExperimentsPopulations(ship, "randomSearch",experimentNumber, populationSize, numGenerations);
%     experimentObjectives = experimentPopulation.objs;
%     ranges = [max(experimentObjectives(:,1)) max(experimentObjectives(:,2)) min(experimentObjectives(:,1)) min(experimentObjectives(:,2))];
%     combinedRanges = [combinedRanges; ranges];
% end
% 
% smallestMaxValues = [min(combinedRanges(:,1)) min(combinedRanges(:,2))];
% largestMinValues = [max(combinedRanges(:,3)) max(combinedRanges(:,4))];


%maxObjectives = smallestMaxValues;
%minObjectives = largestMinValues;

NSGANormalizedHVScores = calculateSearchHvNormalized(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);
NSGAHVScores =  calculateSearchHV(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);
NSGAIGDscore = calculateSearchIGDScore(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, PopulationNSGASearch.best.objs)

RandomNormalizedHVScores = calculateSearchHvNormalized(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);
RandomHVScores =  calculateSearchHV(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives);
RandomIGDscore = calculateSearchIGDScore(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, PopulationRandomSearch.best.objs)



figure(1)
boxplot([NSGANormalizedHVScores(:,1), RandomNormalizedHVScores(:,1)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: Pablo function -  normalized")


figure(2)
boxplot([NSGANormalizedHVScores(:,2), RandomNormalizedHVScores(:,2)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: PlatEMO function - normalized")

figure(3)
boxplot([NSGAHVScores(:,1), RandomHVScores(:,1)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: Pablo function - not normalized")

figure(4)
boxplot([NSGAHVScores(:,2), RandomHVScores(:,2)])
xticklabels({"NSGA search", "Random search"})
title("Hypervolume: PlatEMO function - not normalized")

figure(5)
boxplot([NSGAIGDscore(:,1), RandomIGDscore(:,1)])
xticklabels({"NSGA search", "Random search"})
title("IGD score - not normalized")

figure(6)
boxplot([NSGAIGDscore(:,2), RandomIGDscore(:,2)])
xticklabels({"NSGA search", "Random search"})
title("IGD score - normalized ")

   


function HVscores = calculateSearchHV(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues)
    HVscores = [];
    referencePoint = maxValues;
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);

        scores = [hypervolume(experimentPopulation.best.objs, referencePoint, 10*length(experimentPopulation.best.objs)) HV(experimentPopulation,referencePoint)];
        HVscores = [HVscores; scores];
    end
end

function HVscores = calculateSearchHvNormalized(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues)
    HVscores = [];
    referencePoint = [1 1];
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);
        experimentObjectives = experimentPopulation.objs;

        normalizedObjecitves = (experimentObjectives - minValues.*ones(length(experimentObjectives),length(minValues))) ./ (maxValues-minValues);
        experimentPopulation = SOLUTION(experimentPopulation.decs, normalizedObjecitves, experimentPopulation.cons);
        scores = [hypervolume(experimentPopulation.best.objs, [1 1], 10*length(experimentPopulation.best.objs)) HV(experimentPopulation,[1 1])]; %% TODO 1 1 for HV function might be incorrect

        HVscores = [HVscores; scores];
    end
end



function IGDscore = calculateSearchIGDScore(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues, paretoFront)
    IGDscore = [];
    for experimentNumber = validExperiments
         experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);
         score = IGD(experimentPopulation,paretoFront);

         experimentObjectives = experimentPopulation.objs;
         normalizedObjectives = (experimentObjectives - minValues.*ones(length(experimentObjectives),length(minValues))) ./ (maxValues-minValues);
         experimentPopulation = SOLUTION(experimentPopulation.decs, normalizedObjectives, experimentPopulation.cons);
         paretoFrontNormalized = (paretoFront - minValues.*ones(length(paretoFront),length(minValues))) ./ (maxValues-minValues);

         NormalizedScore = IGD(experimentPopulation, paretoFrontNormalized);
         IGDscore = [IGDscore; [score, NormalizedScore]];

    end
    
end

