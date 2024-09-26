%% calcualte box plot

% caøcuate hypervoluem
close all
clear all

shipInitialwaypoints

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

if searchProcess == "randomSearch"
    startExperiment = 400;
    maxExperiments = 421;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 400;
    maxExperiments = 423;
    populationSize = 100; 
    numGenerations = 10;
end


numMetrics = 1;
basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";

objective = 1;

experimentsResults = containers.Map() ;
experimentObjectives = [];

experimentsObjectives = zeros((maxExperiments-startExperiment),numGenerations*populationSize);
for experimentNumber = startExperiment:maxExperiments
    generationResults = containers.Map();
    objectivesMatrix = [];
    HV_generationResults = [];
    
    for generation = 1:numGenerations
        
        generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
        load(generationPath)
        
        objs = Population.objs;
        objectivesMatrix = [objectivesMatrix; objs(:,objective)];
        %experimentsObjectives = [experimentsObjectives; objs(:,objective)]

    end 
    experimentsObjectives((experimentNumber-startExperiment+1),:) = objectivesMatrix;
    

    %experimentObjectives = [experimentObjectives; objectivesMatrix]
    %resultsPath = append(basepath,ship,"/", "processedResults/HyperVolume",searchProcess ,string(experimentNumber))
    %save(resultsPath, "HV_generationResults", "HV_experimentResult")
end
%experimentObjectives = [experimentObjectives; objectivesMatrix];
%boxPlot(experimentObjectives)




searchProcess = "randomSearch";
startExperiment = 400;
maxExperiments = 420;
populationSize = 1000;
numGenerations = 1;
RandomExperimentsObjectives = zeros((maxExperiments-startExperiment),numGenerations*populationSize);
for experimentNumber = startExperiment:maxExperiments
    generation = 1;

    
    generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
    load(generationPath)
    
    objs = Population.objs;
    %objectivesMatrix =  objs(:,objective);
    RandomExperimentsObjectives((experimentNumber-startExperiment+1),:) = objs(2:end,objective); % ship the first 
    

    %experimentObjectives = [experimentObjectives; objectivesMatrix]
    %resultsPath = append(basepath,ship,"/", "processedResults/HyperVolume",searchProcess ,string(experimentNumber))
    %save(resultsPath, "HV_generationResults", "HV_experimentResult")
end
% 
titleTextObjective1 = "Objective 1: Length of the path the ships takes between two points";
titleTextObjective2 = "Objective 2: Distance between orginal waypoints and new points";

if objective == 1
    titleText = titleTextObjective1;
else
    titleText = titleTextObjective2;
end


figure(1)
experimentsObjectives = experimentsObjectives';
subplot(2,1,1)
title(titleText)
boxplot(experimentsObjectives(:,1:10))
xticks(1:10)

subplot(2,1,2)
boxplot(experimentsObjectives(:,11:20))
xticks(1:10)
xticklabels(11:20)
xlabel("NSGA-II search experiment number")


% 
% 
% subplot(3,1,2)
% boxplot(experimentsObjectives(:,21:30))
% xlabel("NSGA-II search experiment number")

figure(2)
RandomExperimentsObjectives = RandomExperimentsObjectives';

subplot(2,1,1)
title(titleText)
boxplot(RandomExperimentsObjectives(:,1:10))
xticks(1:10)

subplot(2,1,2)
boxplot(RandomExperimentsObjectives(:,11:20))
xticks(1:10)
xticklabels(11:20)
xlabel("Random search experiment number")


% 
% subplot(3,1,3)
% boxplot(RandomExperimentsObjectives(:,20:end))

[experimentsObjectives(:) RandomExperimentsObjectives(:)]
figure(3)
title(titleText)
boxplot([experimentsObjectives(:) RandomExperimentsObjectives(:)])
xticklabels({"NSGA-II search", "random search"})

% subplot(2,1,2)
% boxplot(RandomExperimentsObjectives' )