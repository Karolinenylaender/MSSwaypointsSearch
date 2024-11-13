
close all
clear all

ship = "remus100";
%ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;



resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

resultsPath = append(resultsFolder, "/", ship,"/minDistanceMaxPath-QI-values.mat");
load(resultsPath, 'NSGAscores')

resultsPath = append(resultsFolder, "/", ship,"/randomSearch-QI-values.mat");
load(resultsPath, 'RandomScores')

resultsPath = append(resultsFolder, "/", ship,"/halfPopSearch-QI-values.mat");
load(resultsPath, 'HalfScores')

if length(NSGAscores) > length(HalfScores)
    newHalfScores = zeros(size(NSGAscores));
    newHalfScores(1:size(HalfScores,1), 1:size(HalfScores,2)) = HalfScores;
    newHalfScores((1+size(HalfScores,1)):end,:) = missing;
    HalfScores = newHalfScores;
    %missingData = ones((length(SearchValidExperiments)-length(HalfValidExperiments))*numGenerations,size(halfObjectives,2))*missing
end


%QIs = ["Generational Distance (GD)", "Euclidean Distance (ED)", "Epsilon (EP)", "Generalized Spead (GS)", " Pareto front size (PFS)", "Inverted Generational Distance (IGD)", "Coverage (C)", "Hypervolume approximation", "Hypervolume"]
QIs = ["Generational Distance (GD) ", "Inverted Generational Distance (IGD)", "Euclidean Distance (ED)", "Epsilon (EP)"  " Pareto front size (PFS)",  "Coverage (C)", "Hypervolume approximation", "Hypervolume Platemo"]


for i = 1:length(QIs)

    figure(i)
    boxplot([NSGAscores(:,i), RandomScores(:,i) HalfScores(:,i)])
    xticklabels({"NSGA search", "Random search", "HalfRandomPop"})
    title(QIs(i))
end


if ship == "mariner"
    SearchValidExperiments = 1:1; 
    RandomValidExperiments = 1:30;
    HalfValidExperiments = 0
elseif ship == "nspauv"
    SearchValidExperiments = 1:30; 
    RandomValidExperiments = 1:30;
    HalfValidExperiments = 1:6; %7:30
elseif ship == "remus100"
    SearchValidExperiments = 1:30; 
    RandomValidExperiments = 1:30;
    HalfValidExperiments = 1:11; % 12:30
end

PopulationNSGASearch = loadAllShipPopulations(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
PopulationRandomSearch = loadAllShipPopulations(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations);
PopulationHalfSearch =  loadAllShipPopulations(ship, "HalfHalfMutation",HalfValidExperiments, populationSize, numGenerations); 
NSGAObjectives = PopulationNSGASearch.objs;
randomObjectives = PopulationRandomSearch.objs;
halfObjectives = PopulationHalfSearch.objs;
combinedSearches = SOLUTION([PopulationNSGASearch.decs; PopulationRandomSearch.decs; PopulationHalfSearch.decs], ...
                            [PopulationNSGASearch.objs; PopulationRandomSearch.objs; PopulationHalfSearch.objs], ...
                            [PopulationNSGASearch.cons; PopulationRandomSearch.cons; PopulationHalfSearch.cons]);
paretoFront = combinedSearches.best.objs;
figure(1+length(QIs))
plot(NSGAObjectives(:,1),NSGAObjectives(:,2),'bo')
hold on
plot(randomObjectives(:,1),randomObjectives(:,2),'ro')
hold on
plot(halfObjectives(:,1),halfObjectives(:,2),'go')
legend("NSGA search", "random search", "NSGA search with 50% random init population")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

figure(2+length(QIs))
plot(NSGAObjectives(:,1),NSGAObjectives(:,2),'bo')
hold on
plot(randomObjectives(:,1),randomObjectives(:,2),'ro')
hold on
plot(halfObjectives(:,1),halfObjectives(:,2),'go')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend("NSGA search", "random search", "NSGA search with 50% random init population", "Pareto front from all searches")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)


figure(3+length(QIs))
paretoFront = PopulationNSGASearch.best.objs;
plot(NSGAObjectives(:,1),NSGAObjectives(:,2),'bo')
hold on
plot(randomObjectives(:,1),randomObjectives(:,2),'ro')
hold on
plot(halfObjectives(:,1),halfObjectives(:,2),'go')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend("NSGA search", "random search", "NSGA search with 50% random init population", "Pareto front from  NSGA-ii seeding ")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

figure(4+length(QIs))
paretoFront = PopulationNSGASearch.best.objs;
plot(NSGAObjectives(:,1),NSGAObjectives(:,2),'bo')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend("NSGA search", "Pareto front from  NSGA-ii seeding ")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)



figure(5+length(QIs))
paretoFront = PopulationRandomSearch.best.objs;
plot(NSGAObjectives(:,1),NSGAObjectives(:,2),'bo')
hold on
plot(randomObjectives(:,1),randomObjectives(:,2),'ro')
hold on
plot(halfObjectives(:,1),halfObjectives(:,2),'go')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend("NSGA search", "random search", "NSGA search with 50% random init population", "Pareto front from random search ")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

figure(6+length(QIs))
plot(randomObjectives(:,1),randomObjectives(:,2),'ro')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend( "random search", "Pareto front from random search")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)


figure(7+length(QIs))
paretoFront = PopulationHalfSearch.best.objs;
plot(NSGAObjectives(:,1),NSGAObjectives(:,2),'bo')
hold on
plot(randomObjectives(:,1),randomObjectives(:,2),'ro')
hold on
plot(halfObjectives(:,1),halfObjectives(:,2),'go')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend("NSGA search", "random search", "NSGA search with 50% random init population", "Pareto front from NSGA-ii with 50% random initial population ")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

figure(8+length(QIs))
plot(halfObjectives(:,1),halfObjectives(:,2),'go')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend( "NSGA search with 50% random init population","Pareto front from NSGA-ii with 50% random initial population ")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)




% PopulationNSGASearch = loadAllShipPopulations(ship, "minDistanceMaxPath",1:30, populationSize, numGenerations);
% PopulationRandomSearch = loadAllShipPopulations(ship, "randomSearch",1:30, populationSize, numGenerations);
% epsionScore = epsilon_metric(PopulationNSGASearch.best.objs, PopulationRandomSearch.best.objs)



votesForNSGAI = zeros(length(QIs),1);
for i = 1:length(QIs)

    if i < 6 
        if(median(NSGAscores(:,i)) < median(RandomScores(:,i)))
            votesForNSGAI(i) = 1;
        end
        
    else
        if(median(NSGAscores(:,i)) > median(RandomScores(:,i)))
            votesForNSGAI(i) = 1;
        end
        

    end
    
end
votesForNSGAI
QIs(~votesForNSGAI)


%% Difference Tests (DT)
% the Mann-Whitney U test to determine the significance of differences in the results
% the Vargha and Delaney A12 statistics as the effect size measure to determine the strength of the significance,


[a12valuesA, mannWhitneyUtestValuesA, finalVoteA] = voteOnSearchType(NSGAscores, RandomScores,QIs)
[a12valuesB, mannWhitneyUtestValuesB, finalVoteB] = voteOnSearchType(NSGAscores, HalfScores,QIs)
[a12valuesC, mannWhitneyUtestValuesC, finalVoteC] = voteOnSearchType(HalfScores, RandomScores,QIs)

% a12values = zeros(length(QIs),1);
% mannWhitneyUtestValues = zeros(length(QIs),1);
% finalVote =zeros(length(QIs),1);
% for i = 1:length(QIs)
%     mannWhitneyUtestValues(i) = ranksum(NSGAscores(:,i), RandomScores(:,i));
%     if i < 6 
%        a12values(i) = a12(NSGAscores(:,i), RandomScores(:,i));
% 
%     else
%        a12values(i) = a12( RandomScores(:,i),NSGAscores(:,i));
%     end
% 
%     if mannWhitneyUtestValues(i) < 0.05 && a12values(i) > 0.5
%         finalVote(i) = 1;
%     elseif mannWhitneyUtestValues(i) < 0.05 a12values(i) < 0.5
%         finalVote(i) = -1;
%     elseif mannWhitneyUtestValues(i) >= 0.05
%          finalVote(i) = 0;
%     else 
%         finalVote(i) = 2;
%     end
% 
% end
% a12values
% mannWhitneyUtestValues
% finalVote


function [a12values, mannWhitneyUtestValues, finalVote] = voteOnSearchType(TypeA, TypeB,QIs)
    a12values = zeros(length(QIs),1);
    mannWhitneyUtestValues = zeros(length(QIs),1);
    finalVote =zeros(length(QIs),1);
    
    for i = 1:length(QIs)
        
        mannWhitneyUtestValues(i) = ranksum(TypeA(:,i), TypeB(:,i));
        
        if i < 4 
           a12values(i) = a12(TypeA(:,i), TypeB(:,i));
           
        else
           a12values(i) = a12( TypeB(:,i),TypeA(:,i));
        end
       
        if mannWhitneyUtestValues(i) < 0.05 && a12values(i) > 0.5
            finalVote(i) = 1;
        elseif mannWhitneyUtestValues(i) < 0.05 && a12values(i) < 0.5
            finalVote(i) = -1;
        elseif mannWhitneyUtestValues(i) >= 0.05
             finalVote(i) = 0;
        else 
            finalVote(i) = 2;
        end
        
    end
    
end