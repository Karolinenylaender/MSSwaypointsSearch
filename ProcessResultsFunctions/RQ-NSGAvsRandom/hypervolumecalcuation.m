%% hypervolume calcuations
close all
clear all
ship = "remus100";
populationSize = 10; 
numGenerations = 1000;

searchProcess = "minDistanceMaxPath";
SearchValidExperiments = 1:30; 
RandomValidExperiments = 1:30;
%RandomValidExperiments(21) = [];

PopulationRandomSearch = loadAllShipObjectives(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations);
objectivesRandomSearch = PopulationRandomSearch.objs;
%objectivesRandomSearch(:,1) = -objectivesRandomSearch(:,1);
PopulationNSGASearch = loadAllShipObjectives(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
objectivesNSGASearch = PopulationNSGASearch.objs;
%objectivesNSGASearch(:,1) = -objectivesNSGASearch(:,1);

topPercentiles = 100

maxObjective1 = max([objectivesNSGASearch(:,1); objectivesRandomSearch(:,1)])
%maxObjective1 = min([objectivesNSGASearch(:,1); objectivesRandomSearch(:,1)], topPercentiles)
minObjective1 = min([objectivesNSGASearch(:,1); objectivesRandomSearch(:,1)])
%meanObjective1 = mean([objectivesNSGASearch(:,1); objectivesRandomSearch(:,1)])
%stdObjective1 = std([objectivesNSGASearch(:,1); objectivesRandomSearch(:,1)])

maxObjective2 = max([objectivesNSGASearch(:,2); objectivesRandomSearch(:,2)])
minObjective2 = min([objectivesNSGASearch(:,2); objectivesRandomSearch(:,2)])
%meanObjective2 = mean([objectivesNSGASearch(:,2); objectivesRandomSearch(:,2)])
%stdObjective2 = std([objectivesNSGASearch(:,2); objectivesRandomSearch(:,2)])

maxValueList = [maxObjective1 maxObjective2]
minValueList = [minObjective1 minObjective2]
% meanValueList = [meanObjective1 meanObjective2]
% stdValueList = [stdObjective1 stdObjective2]

normalizedSearch = (objectivesNSGASearch - minValueList.*ones(length(objectivesNSGASearch),length(minValueList))) ./ (maxValueList-minValueList)
%normalizedSearch(:,1) = ones(length(objectivesNSGASearch),1) - normalizedSearch(:,1);
%%normalizedSearch(normalizedSearch(:,1) > 1 ,:) = [];
%normalizedSearch(normalizedSearch(:,1) > 1) = 1;
normalizedRandom = (objectivesRandomSearch - minValueList.*ones(length(objectivesRandomSearch),length(minValueList))) ./ (maxValueList-minValueList)
%normalizedRandom(:,1) = ones(length(objectivesRandomSearch),1) - normalizedRandom(:,1);
%normalizedRandom(normalizedRandom(:,1) > 1 ,:) = [];
% standardSearch = (objectivesNSGASearch - meanValueList.*ones(length(objectivesNSGASearch),length(meanValueList))) ./ stdValueList
% standardRandom =objectivesRandomSearch
% (objectivesRandomSearch - meanValueList.*ones(length(objectivesRandomSearch),length(meanValueList))) ./ stdValueList
% 



worstObjective1 = 1;
worstObjecitve2 = 1;
referencePoint = [worstObjective1 worstObjecitve2];


figure(1)
plot(objectivesNSGASearch(:,1), objectivesNSGASearch(:,2),'bo')
hold on
plot(objectivesRandomSearch(:,1), objectivesRandomSearch(:,2),'ro')
ylabel("[Minmimize] objective 2 distance between points")
xlabel("[Maximize] objecitve 1 sum of path lenths")
legend("NSGA search", "random search")


figure(2)
plot(normalizedSearch(:,1), normalizedSearch(:,2),'bo')
hold on
plot(normalizedRandom(:,1), normalizedRandom(:,2),'ro')
hold on
plot(worstObjective1,worstObjecitve2, "kx",'MarkerSize', 30)

legend("NSGA search", "random search", "reference point - worst point")

[HVsearch] = calculateHV4eachExperiment(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations, maxValueList,minValueList, referencePoint);
[HVrandom] = calculateHV4eachExperiment(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations, maxValueList,minValueList, referencePoint);


hypervolume(normalizedSearch,referencePoint,1000)
hypervolume(normalizedRandom,referencePoint,1000)
a12testResults = A12test(HVsearch,HVrandom)


figure(3)
boxplot(HVsearch)
title("HV NSGA search")

figure(4)
boxplot(HVrandom)
title("HV random search")

figure(5)
boxplot(objectivesNSGASearch)
xticks(1:2)
xticklabels(["[Maximize] objecitve 1 sum of path lenths", "[Minmimize] objective 2 distance between points"])
title("NSGA search")

figure(6)
boxplot(normalizedSearch)
xticks(1:2)
xticklabels(["[Maximize] objecitve 1 sum of path lenths", "[Minmimize] objective 2 distance between points"])
title("NSGA search - normalized ")

figure(7)
boxplot(objectivesRandomSearch)
xticks(1:2)
xticklabels(["[Maximize] objecitve 1 sum of path lenths", "[Minmimize] objective 2 distance between points"])
title("Random search")

figure(8)
boxplot(normalizedRandom)
xticks(1:2)
xticklabels(["[Maximize] objecitve 1 sum of path lenths", "[Minmimize] objective 2 distance between points"])
title("Random search - normalized")
% 
figure(9)
histogram(objectivesNSGASearch(:,1))
hold on
histogram(objectivesRandomSearch(:,1))

figure(10)
histogram(objectivesNSGASearch(:,2))
hold on
histogram(objectivesRandomSearch(:,2))






function [HVlist]  = calculateHV4eachExperiment(ship, searchProcess,validExperiments, populationSize, numGenerations, maxValueList,minValueList, referencePoint)
    HVlist = []; %zeros(length(validExperiments),1);
    for experimentNumber = validExperiments

        experimentPopulation = loadExperimentsObjectives(ship, searchProcess,experimentNumber, populationSize, numGenerations);
        experimentObjecitves = experimentPopulation.objs;
        %experimentObjecitves(:,1) = experimentObjecitves(:,1);
        normalizedObjecitve1 = (experimentObjecitves + minValueList(1).*ones(length(experimentObjecitves),1) ./ (maxValueList(1)-minValueList(1)));

        normalizedObjecitves = (experimentObjecitves - minValueList.*ones(length(experimentObjecitves),length(minValueList))) ./ (maxValueList-minValueList);
        %normalizedObjecitves(:,1) = ones(length(experimentObjecitves),1)-normalizedObjecitves(:,1);
        %normalizedObjecitves(normalizedObjecitves(:,1) > 1) = 1;
        %normalizedObjecitves(normalizedObjecitves(:,1) > 1,:) = [];
        %normalizedObjecitves = experimentObjecitves
        %referencePoint = [0 maxValueList(2)]
        

        HVlist = [HVlist hypervolume(normalizedObjecitves,referencePoint,1000)];
        %HVlist = [HVlist calculate_igd(normalizedObjecitves, referencePoint)]
        normalizedObjecitves;
    end
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


