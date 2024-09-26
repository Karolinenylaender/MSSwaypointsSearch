% calcuate hypervoluem
close all
clear all

shipInitialwaypoints

%ship = "npsauv";
%ship = "mariner"
ship = "remus100";


%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 400;
maxExperiments = 427;
populationSize = 100; 
numGenerations = 10;

basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";

N = 1000;
referencePoint = [1 1];

objectivesAllExperiments = [];

HV_experimentResult = [];
HV_experimentsMap = containers.Map();
for experimentNumber = startExperiment:maxExperiments
    objectivesForAllGenerations = [];
    HV_generationResults = [];
    
    for generation = 1:numGenerations
        
        generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
        load(generationPath)
        
        objs = Population.objs;  
        objectivesForAllGenerations = [objectivesForAllGenerations; objs];

        normalizedObjectives = [normalize(objs(:,1),'range') normalize(objs(:,2),'range')];
        HV_generationResults = [HV_generationResults; hypervolume(normalizedObjectives,referencePoint,N)];
        
    end 
    HV_experimentsMap(string(experimentNumber)) = HV_generationResults;
    normalizedObjectives = [normalize(objectivesForAllGenerations(:,1),'range') normalize(objectivesForAllGenerations(:,2),'range')];
    HV_experimentResult = hypervolume(normalizedObjectives,referencePoint,N);
    HV_experimentsMap(append(string(experimentNumber), "-combined")) = HV_experimentResult;

    objectivesAllExperiments = [objectivesAllExperiments; objectivesForAllGenerations];
end
normalizedObjectives = [normalize(objectivesAllExperiments(:,1),'range') normalize(objectivesAllExperiments(:,2),'range')];
HV_shipResuls = hypervolume(normalizedObjectives,referencePoint,N);
shipResults = containers.Map();
shipResults(ship) = HV_experimentsMap;
shipResults(append(ship,"-combined")) = HV_shipResuls;
resultsPath = append(basepath,ship,"/", "processedResults/HyperVolume-",searchProcess, string(startExperiment), "-", string(maxExperiments))
save(resultsPath, "shipResults")



searchProcess = "randomSearch"
startExperiment = 400;
maxExperiments = 420;
populationSize = 1000;
numGenerations = 1;
Random_objectivesAllExperiments = [];
Random_HV_experimentResult = [];
HV_RandomExperimentsMap = containers.Map();

for experimentNumber =startExperiment:maxExperiments
    generation = 1;
        
    generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
    load(generationPath)
    
    objs = Population.objs;  
    normalizedObjectives = [normalize(objs(:,1),'range') normalize(objs(:,2),'range')];
    Random_HV_experimentResult = [Random_HV_experimentResult; hypervolume(normalizedObjectives,referencePoint,N)];
    HV_RandomExperimentsMap(string(experimentNumber)) = Random_HV_experimentResult;

    Random_objectivesAllExperiments = [Random_objectivesAllExperiments; objs];
    %resultsPath = append(basepath,ship,"/", "processedResults/HyperVolume",searchProcess ,string(experimentNumber))
    %save(resultsPath, "HV_generationResults", "HV_experimentResult")
end
normalizedObjectives = [normalize(Random_objectivesAllExperiments(:,1),'range') normalize(Random_objectivesAllExperiments(:,2),'range')];
Random_HV_shipResuls = hypervolume(normalizedObjectives,referencePoint,N);
RandomShipResults = containers.Map();
RandomShipResults(ship) = HV_RandomExperimentsMap;
RandomShipResults(append(ship,"-combined")) = Random_HV_shipResuls;
resultsPath = append(basepath,ship,"/", "processedResults/HyperVolume-",searchProcess, string(startExperiment), "-", string(maxExperiments))
save(resultsPath, "RandomShipResults")

subplot(2,1,1)
plot(HV_experimentResult)
title(["NSGA-II search HV - all experiments combined:", num2str(HV_shipResuls)])
ylabel("Hypervolume")
xlabel("ExperimentNumber")
subplot(2,1,2)
plot(Random_HV_experimentResult)
title(["Random search HV - all experiments combined:", num2str(Random_HV_shipResuls)])
ylabel("Hypervolume")


