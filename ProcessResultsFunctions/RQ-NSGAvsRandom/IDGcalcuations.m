%% Inverted Generational Distance Indicator 
% close all
% clear all
% ship = "remus100";
% populationSize = 10; 
% numGenerations = 1000;
% 
% searchProcess = "minDistanceMaxPath";
% SearchValidExperiments = 1:30; 
% RandomValidExperiments = 1:30;


close all
clear all
ship = "remus100";
ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;

searchProcess = "minDistanceMaxPath";
if ship == "nspauv"
    SearchValidExperiments = 1:3; 
    RandomValidExperiments = [1 2 3] % 4 5 6 25 26 27 28 29 30];
else
    SearchValidExperiments = 1:30; 
    RandomValidExperiments = 1:30;
end

PopulationNSGASearch = loadAllShipObjectives(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
PopulationRandomSearch = loadAllShipObjectives(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations);
allObjectives = [PopulationNSGASearch.objs; PopulationRandomSearch.objs];
maxValueList = [max(allObjectives(:,1)) max(allObjectives(:,2))];
minValueList = [min(allObjectives(:,1)) min(allObjectives(:,2))];

bestFront  = returnParetoFront(PopulationNSGASearch,PopulationRandomSearch, "best");
NSGAScores = calculateScore(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations, bestFront, "best");
RandomScores = calculateScore(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations, bestFront, "best");
figure(1)
plot(allObjectives(:,1),allObjectives(:,2), 'bo')
hold on
plot(bestFront(:,1),bestFront(:,2), 'ro')

figure(2)
boxplot([NSGAScores(:,1), RandomScores(:,1)])
xticklabels({"NSGA search", "Random search"})


refPoint = [0 0];
distanceFront = returnParetoFront(PopulationNSGASearch,PopulationRandomSearch, "distance", length(bestFront),refPoint);
NSGAScores = calculateScore(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations, distanceFront,"distance",  maxValueList,minValueList);
RandomScores = calculateScore(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations, distanceFront, "distance",  maxValueList,minValueList);

figure(4)
plot(allObjectives(:,1),allObjectives(:,2), 'bo')
hold on
plot(distanceFront(:,1),distanceFront(:,2), 'ro')

figure(5)
boxplot([NSGAScores(:,1), RandomScores(:,1)])
xticklabels({"NSGA search", "Random search"})
figure(6)
boxplot([NSGAScores(:,2), RandomScores(:,2)])
xticklabels({"NSGA search", "Random search"})
title("hypervolume")


% frontNoFront = returnParetoFront(PopulationNSGASearch,PopulationRandomSearch, "frontNo", length(bestFront));
% NSGAScores = calculateScore(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations, referencePoints,"frontNo");
% RandomScores = calculateScore(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations, referencePoints,"frontNo");
% 
% figure(7)
% plot(allObjectives(:,1),allObjectives(:,2), 'bo')
% hold on
% plot(frontNoFront(:,1),frontNoFront(:,2), 'ro')
% 
% figure(8)
% boxplot([NSGAScores(:,1), RandomScores(:,1)])
% xticklabels({"NSGA search", "Random search"})
% figure(9)
% boxplot([NSGAScores(:,2), RandomScores(:,2)])
% xticklabels({"NSGA search", "Random search"})



function scoresMatrix = calculateScore(ship, searchProcess,validExperiments, populationSize, numGenerations, referencePoints, frontType, maxValueList,minValueList)
    scoresMatrix = []; %zeros(length(validExperiments),1);
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsObjectives(ship, searchProcess,experimentNumber, populationSize, numGenerations);
        experimentObjecitves = experimentPopulation.objs;

        if frontType == "distance"
            %referencePoint = [1 0.5];
            normalizedObjecitves = (experimentObjecitves - minValueList.*ones(length(experimentObjecitves),length(minValueList))) ./ (maxValueList-minValueList);
            experimentPopulation = SOLUTION(experimentPopulation.decs, normalizedObjecitves, experimentPopulation.cons);
            IGDScore = IGD(experimentPopulation,referencePoints);
            HVScore = hypervolume(experimentPopulation.objs, [1 1],1000);
            scores = [IGDScore HVScore];
        else
            IGDScore = IGD(experimentPopulation,referencePoints);
            %IDGPlussScore = IGDp(experimentPopulation,referencePoints);

            %HVScore = hypervolume(experimentPopulation.objs,maxValueList,1000);
            scores = [IGDScore]
        end

        
        %HVscore =  hypervolume(normalizedObjecitves,referencePoint,numPointsHV);


        scoresMatrix = [scoresMatrix; scores];
    end
end