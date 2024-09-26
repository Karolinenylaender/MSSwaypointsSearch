%% statistical tests
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
    maxExperiments = 420;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 400;
    maxExperiments = 427;
    populationSize = 100; 
    numGenerations = 10;
end


ship = "remus100";

basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";
%generationPath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/randomSearch-P1000-exNum200-g1"
%generationPath = ""/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/randomSearch-P100-exNum200-g1"

%experimentsResults = containers.Map() ;
%experimentObjectives = [];

% % objPathMatrix = zeros((maxExperiments-startExperiment), numGenerations*populationSize);
% % objDistanceMatrix = zeros((maxExperiments-startExperiment), numGenerations*populationSize);
% % 
% % objPathList = [];
% % objDistList = [];
% % for experimentNumber = startExperiment:maxExperiments
% %      %objPathList = [];
% %      %objDistList = [];
% %      for generation = 1:numGenerations
% % 
% %         generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
% %         load(generationPath)
% %         objs = Population.objs;
% %         objPath = objs(:,1);
% %         objPathList = [objPathList; objPath];
% %         objDist = objs(:,2);
% %         objDistList = [objDistList; objDist];
% % 
% %      end
% %      %objPathMatrix((experimentNumber-startExperiment+1),:) = objPathList;
% %      %objDistanceMatrix((experimentNumber-startExperiment+1),:) = objDistList;
% % end
% % 
% % 
% % 
% % 
% % searchProcess = "randomSearch";
% % startExperiment = 400;
% % maxExperiments = 420;
% % populationSize = 1000;
% % numGenerations = 1;
% % RandomExperimentsObjectives = zeros((maxExperiments-startExperiment),numGenerations*populationSize);

%RandomObjPathMatrix = zeros((maxExperiments-startExperiment), numGenerations*populationSize);
%RandomObjDistanceMatrix = zeros((maxExperiments-startExperiment), numGenerations*populationSize);

% % RandomObjPathList = [];
% % RandomObjDistanceList = [];
% % for experimentNumber = startExperiment:maxExperiments
% %     generation = 1    
% %     generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
% %     load(generationPath)
% % 
% %     objs = Population.objs;
% %     objs = objs(2:end,:);
% % 
% %     %RandomObjPathMatrix((experimentNumber-startExperiment+1),:) = objs(:,1);
% %     RandomObjPathList = [RandomObjPathList; objs(:,1)]
% %     %RandomObjDistanceMatrix((experimentNumber-startExperiment+1),:) = objs(:,2);
% %     RandomObjDistanceList = [RandomObjDistanceList; objs(:,2)]
% % 
% % end


% 
% % Perform Mann-Whitney U-test for Objective 1
% [p1, h1, stats1] = ranksum(objPathList, RandomObjPathList);
% fprintf('Objective 1: p-value = %.4f, U-statistic = %.4f\n', p1, stats1.ranksum);
% h1
% stats1
% a12_obj1 = A12test(objPathList,RandomObjPathList)
% 
% % Perform Mann-Whitney U-test for Objective 2
% [p2, h2, stats2] = ranksum(objDistList, RandomObjDistanceList);
% fprintf('Objective 2: p-value = %.4f, U-statistic = %.4f\n', p2, stats2.ranksum);
% h2
% stats2
% 
% a12_obj1 = A12test(objDistList, RandomObjDistanceList)

RandomStartExperiment = 400
RandomMaxExperiments = 420
resultsHVrandom = append(basepath,ship,"/", "processedResults/HyperVolume-","randomSearch", string(RandomStartExperiment), "-", string(RandomMaxExperiments));
load(resultsHVrandom,"RandomShipResults")
resultsHVobjective = append(basepath,ship,"/", "processedResults/HyperVolume-","minDistanceMaxPath", string(startExperiment), "-", string(maxExperiments));
load(resultsHVobjective, "shipResults")

%resultsFull = zeros((RandomMaxExperiments-RandomStartExperiment)*(maxExperiments-startExperiment)*numGenerations,3);
resultsFull = containers.Map();
for RandomExperimentNumber =RandomStartExperiment:RandomMaxExperiments
    randomExperimentResults = RandomShipResults(string(RandomExperimentNumber));
    for ObjectiveExperimentNumber =startExperiment:maxExperiments
        objectiveExperiemntResults = shipResults(string(ObjectiveExperimentNumber));
        for generation = 1:numGenerations
            generationResults = objectiveExperiemntResults(string(generation))
            [p, h, stats] = ranksum(generationResults, randomExperimentResults);
            a12 = A12test(generationResults, randomExperimentResults)
            resultsFull(append(string(RandomExperimentNumber), "-", string(ObjectiveExperimentNumber), "-", string(generation))) = [p h a12];
        end
    end

end



function a12 = A12test(x,y)
    nx = length(x);
    ny = length(y);

    ties = 0;
    wins = 0;

    for i = 1:nx
        for j = 1:ny
            if x(i) < y(j)
                wins = wins + 1;
            elseif x(i) == y(j)
                ties = ties + 1;
            end
        end
    end

    a12 = (wins +0.5*ties) / (nx*ny);
end
