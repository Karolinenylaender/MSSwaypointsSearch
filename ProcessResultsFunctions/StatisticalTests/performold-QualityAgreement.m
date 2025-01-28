
close all
clear all

ship = "remus100";
%ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;

searchNames = ["Random Search", "NSGA seed", "NSGA mixed", "NSGA random"]


resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

resultsPath = append(resultsFolder, "/", ship,"/randomSearch-QI-values.mat");
load(resultsPath, 'randomSearchScores')

resultsPath = append(resultsFolder, "/", ship,"/minDistanceMaxPath-QI-values.mat");
load(resultsPath, 'seedNSGAscores')

resultsPath = append(resultsFolder, "/", ship,"/halfPopSearch-QI-values.mat");
load(resultsPath, 'mixedNSGAScores')


resultsPath = append(resultsFolder, "/", ship,"/randInit-QI-values.mat");
load(resultsPath, 'randomNSGAScores')    

if length(seedNSGAscores) > length(mixedNSGAScores)
    newMixedNSGAScores = zeros(size(seedNSGAscores));
    newMixedNSGAScores(1:size(mixedNSGAScores,1), 1:size(mixedNSGAScores,2)) = mixedNSGAScores;
    newMixedNSGAScores((1+size(mixedNSGAScores,1)):end,:) = missing;
    mixedNSGAScores = newMixedNSGAScores;
   
end

if length(seedNSGAscores) > length(randomNSGAScores)
    newRandonNSGAScores = zeros(size(seedNSGAscores));
    newRandonNSGAScores(1:size(randomNSGAScores,1), 1:size(randomNSGAScores,2)) = randomNSGAScores;
    newRandonNSGAScores((1+size(randomNSGAScores,1)):end,:) = missing;
    randomNSGAScores = newRandonNSGAScores;
end

QIs = ["Generational Distance (GD) ", "Inverted Generational Distance (IGD)", "Euclidean Distance (ED)", "Epsilon (EP)"  " Pareto front size (PFS)",  "Coverage (C)", "Hypervolume approximation", "Hypervolume Platemo"]

for i = 1:length(QIs)

    figure(i)
    boxplot([randomSearchScores(:,i), seedNSGAscores(:,i) mixedNSGAScores(:,i) randomNSGAScores(:,i)])
    xticklabels(searchNames)
    title(QIs(i))
end


[a12values, mannWhitneyUtestValuesA, voteA] = voteOnSearchType(seedNSGAscores, randomSearchScores,length(QIs),"NSGAseed", "RandomSearch" );
[a12values, mannWhitneyUtestValuesA, voteB] = voteOnSearchType(mixedNSGAScores, randomSearchScores,length(QIs),"NSGAmixed", "RandomSearch");
[a12values, mannWhitneyUtestValuesA, voteC] = voteOnSearchType(randomNSGAScores, randomSearchScores,length(QIs), "NSGArandom", "RandomSearch");


[a12values, mannWhitneyUtestValuesA, voteD] = voteOnSearchType(seedNSGAscores, mixedNSGAScores,length(QIs),"NSGAseed", "NSGAmixed" );
[a12values, mannWhitneyUtestValuesA, voteE] = voteOnSearchType(seedNSGAscores, randomNSGAScores,length(QIs),"NSGAseed", "NSGArandom" );
[a12values, mannWhitneyUtestValuesA, voteF] = voteOnSearchType(mixedNSGAScores, randomNSGAScores,length(QIs),"NSGAmixed", "NSGArandom");

comparisationsTypes = ["seedNSGA vs Random ", "mixedNSGA vs Random", "random NSGA vs Random", "seedNSGA vs mixed NSGA", "seedNSGA vs random NSGA", "mixed NSGA vs random NSGA"]
finalVotes = [["Quality indicator" comparisationsTypes]; ...
              QIs' voteA voteB voteC voteD voteE voteF]



function [a12values, mannWhitneyUtestValues, finalVote] = voteOnSearchType(SearchOne, SearchTwo,NumberOfQualityIndicators, SearchOneName, SearchTwoName)
    a12values = zeros(NumberOfQualityIndicators,1);
    mannWhitneyUtestValues = zeros(NumberOfQualityIndicators,1);
    finalVote = string;
    
    for i = 1:NumberOfQualityIndicators
        mannWhitneyUtestValues(i) = ranksum(SearchOne(:,i), SearchTwo(:,i));
        
        if i < 4
            % switch to compare the smallest
           a12values(i) = a12(SearchTwo(:,i), SearchOne(:,i));
           
        else
           a12values(i) = a12( SearchOne(:,i),SearchTwo(:,i));
        end
        
       
        if mannWhitneyUtestValues(i) < 0.05 && a12values(i) > 0.5
            finalVote = [finalVote; SearchOneName];
        elseif mannWhitneyUtestValues(i) < 0.05 && a12values(i) < 0.5
            finalVote = [finalVote; SearchTwoName];
        elseif mannWhitneyUtestValues(i) >= 0.05 || a12values(i) == 0.5
            finalVote = [finalVote; "ND"]; 
        else
            finalVote
        end
        
    end
    finalVote = finalVote(2:end)
    
end