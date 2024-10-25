%% perform statistical tests
close all
clear all

%ship = "npsauv";
%ship = "mariner"
ship = "remus100";

shipList = [ "remus100"] %, "nspauv", "mariner"];
%searchProcesses = ["minDistanceMaxPath","randomSearch"];


%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";
SearchValidExperiments = [1 2 3 4 5 6 7 8 9 10 11 12 15];% 16 17 18 19 20 21 22 23 24 25 26 27 28 29]; % 13 14 30
RandomValidExperiments = [1 5 6 7 8 9 10 11 12 13 14 16]; % 2 3 4 15 17-30

%startExperiment = 1;
%maxExperiments = 30 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;

a12 = A12test(zeros(15,1), zeros(15,1))


%figure
%for shipIndex = 1:length(shipList)
    shipIndex = 1
    ship = ship % shipList(shipIndex);
    [normalShipHV, normalHV, objNormal] = shipHyperVolume(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
    %normalShipHV = shipHyperVolume(ship, "minDistanceMaxPath", startExperiment, maxExperiments, populationSize, numGenerations)

    [randomShipHV, randomHV, objRandom] = shipHyperVolume(ship,  "randomSearch", RandomValidExperiments, populationSize, numGenerations);
    %randomShipHV = shipHyperVolume(ship,  "randomSearch", startExperiment, maxExperiments, populationSize, numGenerations);
    
    a12Ship = A12test(normalHV,randomHV) 
    a12 = A12test(normalShipHV,randomShipHV)
    a12_obj_1 = A12test(objNormal(:,1),objRandom(:,1))
    a12_obj_2 = A12test(objNormal(:,2),objRandom(:,2))

    %Create a cell array
    if length(normalShipHV) < length(randomShipHV)
        normalShipHV = [normalShipHV nan(1,length(randomShipHV)-length(normalShipHV))];
    elseif length(normalShipHV) > length(randomShipHV)
        randomShipHV = [randomShipHV nan(1,length(normalShipHV)-length(randomShipHV))];
    end
    data = [normalShipHV; randomShipHV]';
    
    % Create a boxchart
    figure(shipIndex)
    boxplot(data, 'Labels', {'normal search', 'random search'})
    subplot(length(shipList),1,shipIndex)
    boxplot(data, 'Labels', {'normal search', 'random search'})
    xticks(1:2)
    xticklabels(["normal search", "random search"])



%end



% function [shipHV, HV,normalizedObjectives] = shipHyperVolume(ship, searchProcess, startExperiment, maxExperiments, populationSize, numGenerations)
%     referencePoint = [1 1];
%     shipHV = []
%     totalShipObjectives = []
%     for experimentNumber = startExperiment:maxExperiments
% 
%         [subPathPerformance, experimentPerformance]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);
% 
% 
%         objectives = [experimentPerformance(:,1:2)];
%         totalShipObjectives = [totalShipObjectives; objectives]
%         normalizedObjectives = [normalize(objectives(:,1),'range') normalize(objectives(:,2),'range')];
%         HV = hypervolume(normalizedObjectives,referencePoint,1000);
%         shipHV = [shipHV HV];
% 
%     end
%     normalizedObjectives = [normalize(totalShipObjectives(:,1),'range') normalize(totalShipObjectives(:,2),'range')];
%     HV = hypervolume(normalizedObjectives,referencePoint,1000);
% 
% end

function [shipHV, HV,totalShipObjectives] = shipHyperVolume(ship, searchProcess,validExperiments, populationSize, numGenerations)
    referencePoint = [1 1];
    shipHV = []
    totalShipObjectives = []
    for experimentNumber = validExperiments
        if searchProcess == "minDistanceMaxPath"
            experimentFolderName = append("ex", string(experimentNumber),"/");
        elseif searchProcess == "randomSearch"
            experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
        end
        folderName = append("ExtractedPopulations/",experimentFolderName) 
        resultsPathInfo = what("ProcessedResults");
        resultsFolder = char(resultsPathInfo.path);
        genrationObjectives = []
        for generation = 1:numGenerations
            %[Population, ~] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
            resultsPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation),".mat");
            load(resultsPath, 'Population');
            genrationObjectives = [genrationObjectives; Population.objs];
        end


        %[subPathPerformance, experimentPerformance]  = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations);        
        %objectives = [experimentPerformance(:,1:2)];

        totalShipObjectives = [totalShipObjectives; genrationObjectives];
        normalizedObjectives = [normalize(genrationObjectives(:,1),'range') normalize(genrationObjectives(:,2),'range')];
        HV = hypervolume(normalizedObjectives,referencePoint,1000);
        shipHV = [shipHV HV];

    end
    normalizedObjectives = [normalize(totalShipObjectives(:,1),'range') normalize(totalShipObjectives(:,2),'range')];
    HV = hypervolume(normalizedObjectives,referencePoint,1000);

end




function a12 = A12test(x,y)
    nx = length(x);
    ny = length(y);

    ties = 0;
    wins = 0;

    for i = 1:nx
        for j = 1:ny
            if x(i) > y(j)
                wins = wins + 1;
            elseif x(i) == y(j)
                ties = ties + 1;
            end
        end
    end

    a12 = (wins +0.5*ties) / (nx*ny);
end


