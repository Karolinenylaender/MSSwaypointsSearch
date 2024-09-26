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


generationResults = experimentsResults(string(experimentNumber))
performanceMatrix = []
generationKey = 10;
performance = generationResults(string(generationKey))
performanceMatrix = [performanceMatrix; performance]
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