%% perform statistical tests
close all
clear all

%ship = "npsauv";
%ship = "mariner"
ship = "remus100";

shipList = [ "remus100"] %, "nspauv", "mariner"];
searchProcesses = ["minDistanceMaxPath","randomSearch"];


%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 1;
maxExperiments = 15 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;

figure
for shipIndex = 1:length(shipList)
    ship = shipList(shipIndex);
    normalShipHV = shipHyperVolume(ship, "minDistanceMaxPath", 2, 8, populationSize, numGenerations);
    %normalShipHV = shipHyperVolume(ship, "minDistanceMaxPath", startExperiment, maxExperiments, populationSize, numGenerations)

    randomShipHV = shipHyperVolume(ship,  "randomSearch", 20, 21, populationSize, numGenerations);
    %randomShipHV = shipHyperVolume(ship,  "randomSearch", startExperiment, maxExperiments, populationSize, numGenerations);

    a12 = A12test(normalShipHV,randomShipHV)

    subplot(length(shipList),1,shipIndex)
    boxplot([normalShipHV, randomShipHV])
    title(["Ship: ", ship])
    xticks(1:2)
    xticklabels(["normal search", "random search"])
    


end





function shipHV = shipHyperVolume(ship, searchProcess, startExperiment, maxExperiments, populationSize, numGenerations)
    referencePoint = [1 1];
    shipHV = []
    for experimentNumber = startExperiment:maxExperiments
        totalObjectives = [];
        for generation = 1:numGenerations
            [Population, ~] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
            Obj = Population.objs; 
            totalObjectives = [totalObjectives; Obj];
        end
        normalizedObjectives = [normalize(totalObjectives(:,1),'range') normalize(totalObjectives(:,2),'range')];
        HV = hypervolume(normalizedObjectives,referencePoint,1000);
        shipHV = [shipHV HV];
    end
    %normalizedObjectives = [normalize(shipObjectives(:,1),'range') normalize(shipObjectives(:,2),'range')];
    %HV = hypervolume(normalizedObjectives,referencePoint,1000);

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
