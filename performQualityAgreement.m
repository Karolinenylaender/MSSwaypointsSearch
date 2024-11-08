
close all
clear all

ship = "remus100";
ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;



resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

resultsPath = append(resultsFolder, "/", ship,"/minDistanceMaxPath-QI-values.mat");
load(resultsPath, 'NSGAscores')

resultsPath = append(resultsFolder, "/", ship,"/randomSearch-QI-values.mat");
load(resultsPath, 'RandomScores')



%QIs = ["Generational Distance (GD)", "Euclidean Distance (ED)", "Epsilon (EP)", "Generalized Spead (GS)", " Pareto front size (PFS)", "Inverted Generational Distance (IGD)", "Coverage (C)", "Hypervolume approximation", "Hypervolume"]
QIs = ["Generational Distance (GD) Search ", "Generational Distance (GD) combined", ...
       "Inverted Generational Distance (IGD) Search", "Inverted Generational Distance (IGD) cobined", ...
       "Euclidean Distance (ED)","Epsilon (EP) search", ...
       "Epsilon (EP) ship"  " Pareto front size (PFS)", ...
       "Coverage (C) Search",  "Coverage (C) Combined", ...
       "Hypervolume approximation", "Hypervolume platEMO"]

for i = 1:length(QIs)

    figure(i)
    boxplot([NSGAscores(:,i), RandomScores(:,i)])
    xticklabels({"NSGA search", "Random search"})
    title(QIs(i))
end


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


a12values = zeros(length(QIs),1);
mannWhitneyUtestValues = zeros(length(QIs),1);
finalVote =zeros(length(QIs),1);
for i = 1:length(QIs)
    mannWhitneyUtestValues(i) = ranksum(NSGAscores(:,i), RandomScores(:,i));
    if i < 6 
       a12values(i) = a12(NSGAscores(:,i), RandomScores(:,i));
       
    else
       a12values(i) = a12( RandomScores(:,i),NSGAscores(:,i));
    end

    if mannWhitneyUtestValues(i) < 0.05 && a12values(i) > 0.5
        finalVote(i) = 1;
    elseif mannWhitneyUtestValues(i) < 0.05 a12values(i) < 0.5
        finalVote(i) = -1;
    elseif mannWhitneyUtestValues(i) >= 0.05
         finalVote(i) = 0;
    else 
        finalVote(i) = 2;
    end
    
end
a12values
mannWhitneyUtestValues
finalVote
