close all
clear all

exNum = 1;
maxGen = 224 %1000;
populationSize = 10;
numWaypoints = 6;
searchProcess = "minDistanceMaxPath";
ship = "remus100";

AverageMissingWayPoints = zeros(maxGen,numWaypoints+1);
totalObjectives = [];
for generation = 1:maxGen

    [Population, paths] = loadResults(ship, searchProcess, exNum, populationSize, generation);
    objectives = Population.objs;
    
    missingWaypoints = zeros(1,numWaypoints+1);
    for individual = 1:size(objectives,1)
        individualPath = paths(string(individual));
        transitionIndices = individualPath('transitionIndices');
        %numMissingWaypoints = numWaypoints - length(transitionIndices);
        if (transitionIndices(1) == length(individualPath('fullpath')))
            numMissingWaypoints = numWaypoints;
        else
            numMissingWaypoints = numWaypoints - length(transitionIndices) + 1;
    
        end
        
        totalObjectives = [totalObjectives; objectives(individual,:) numMissingWaypoints];
        % if numMissingWaypoints > 0
        %     numMissingWaypoints;
        % end

        %missingWaypoints = missingWaypoints+ numMissingWaypoints;

        
        missingWaypoints(numMissingWaypoints+1) = missingWaypoints(numMissingWaypoints+1) + 1;

    end
    
    missingWaypoints
    if generation == 1 
        AverageMissingWayPoints(generation,:) = missingWaypoints;
    else
        AverageMissingWayPoints(generation,:) = AverageMissingWayPoints(generation-1,:) + missingWaypoints;

    end

    %AverageMissingWayPoints = [AverageMissingWayPoints missingWaypoints/size(objectives,1)]
        
end 
AverageMissingWayPoints
missingWaypoints = sum(AverageMissingWayPoints,1)


totalObjectives


