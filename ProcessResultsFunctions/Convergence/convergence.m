%% visualisize experiments results
close all
clear all

ship = "npsauv";
%ship = "mariner"
ship = "remus100";
searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";

if searchProcess == "randomSearch"
    startExperiment = 1;
    maxExperiments = 420;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 1;
    maxExperiments = 1; %startExperiment+30;
    populationSize = 10; 
    numGenerations = 263 %1000;
end
ship = "remus100";



%for experimentNumber = startExperiment:maxExperiments

experimentNumber = 1
%populationSize = 100; 
%numGenerations = 10;
%resultsPath = append(basepath,ship,"/", "processedResults/", searchProcess,string(experimentNumber))
%load(resultsPath)

performanceMatrix = []
for generation = 1:numGenerations
    [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
    objectives = Population.objs;
    performanceMatrix = [performanceMatrix; objectives];

end

%generationResults = experimentsResults(string(experimentNumber))
%performanceMatrix = []
%generationKey = 10;
%performance = generationResults(string(generationKey))
%performanceMatrix = [performanceMatrix; performance]
figure(1)
subplot(3,1,1)
plot(performance(:,1), performance(:,2),'o')
subplot(3,1,2)
plot(performance(:,1),'o')
subplot(3,1,3)
plot(performance(:,2),'o')

figure(2)
boxplot(performance(:,1))

figure(3)
boxplot(performance(:,2))
% for generationKey = 1:length(generationResults.keys)
%     performance = generationResults(string(generationKey))
% 
%     performanceMatrix = [performanceMatrix; performance]
% 
% end