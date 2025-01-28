% hypervolume with QI for each search - make it less messy

close all
clear all

ship = "mariner";
%ship = "remus100";
ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;

if ship == "mariner"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30; 
elseif ship == "nspauv"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30;
elseif ship == "remus100"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30;
end




resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

reCalculate = false;
if reCalculate == true

    randomSearchPopulation = loadAllShipPopulations(ship, "RndSearch",randomSearchValidExperiments, populationSize, numGenerations);
    seedNSGAPopulation = loadAllShipPopulations(ship, "WPgenSeed",seedNSGAValidExperiments, populationSize, numGenerations);
    mixedNSGAPopulation = loadAllShipPopulations(ship, "WPgenComb",mixedNSGAValidExperiments, populationSize, numGenerations); 
    randomNSGAPopulation =  loadAllShipPopulations(ship, "WPgenRnd",randomNSGAValidExperiments, populationSize, numGenerations); 
    
     
    randomSearchObjectives = randomSearchPopulation.objs;
    seedNSGAObjectives = seedNSGAPopulation.objs;
    mixedNSGAObjecitves = mixedNSGAPopulation.objs;
    randomNSGAObjectives = randomNSGAPopulation.objs;
    
    combinedObjectives = [randomSearchObjectives; seedNSGAObjectives; mixedNSGAObjecitves; randomNSGAObjectives];
    
    distribution = [max(randomSearchObjectives) max(seedNSGAObjectives) max(mixedNSGAObjecitves) max(randomNSGAObjectives);
                    min(randomSearchObjectives) min(seedNSGAObjectives) min(mixedNSGAObjecitves) min(randomNSGAObjectives);
                    mean(randomSearchObjectives) mean(seedNSGAObjectives) mean(mixedNSGAObjecitves) mean(randomNSGAObjectives);
                    median(randomSearchObjectives) median(seedNSGAObjectives) median(mixedNSGAObjecitves) median(randomNSGAObjectives);];
    
    randomSearchParetoFront = randomSearchPopulation.best.objs;
    seedNSGAParetoFront = seedNSGAPopulation.best.objs;
    mixedNSGAParetoFront = mixedNSGAPopulation.best.objs;
    randomNSGAParetoFront = randomNSGAPopulation.best.objs;
    
    combinedSearches = SOLUTION([randomSearchPopulation.decs; seedNSGAPopulation.decs; mixedNSGAPopulation.decs; randomNSGAPopulation.decs], ...
                                          [randomSearchPopulation.objs; seedNSGAPopulation.objs; mixedNSGAPopulation.objs; randomNSGAPopulation.objs], ...
                                          [randomSearchPopulation.cons; seedNSGAPopulation.cons; mixedNSGAPopulation.cons; randomNSGAPopulation.cons]);
    
    
    
    maxObjectives = [max(combinedObjectives(:,1)), max(combinedObjectives(:,2))];
    minObjectives = [min(combinedObjectives(:,1)), min(combinedObjectives(:,2))];

    randomSearchScores = calucateStatisticalScores(ship, "RndSearch",randomSearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, randomSearchPopulation, combinedSearches);
    seedNSGAscores = calucateStatisticalScores(ship, "WPgenSeed",seedNSGAValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, seedNSGAPopulation, combinedSearches);
    mixedNSGAScores = calucateStatisticalScores(ship, "WPgenComb",mixedNSGAValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, mixedNSGAPopulation, combinedSearches);
    randomNSGAScores = calucateStatisticalScores(ship, "WPgenSeed",randomNSGAValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, randomNSGAPopulation, combinedSearches);

    resultsPath = append(resultsFolder, "/", ship,"/randomSearch-QI-values.mat");
    save(resultsPath, 'rndSearchScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/minDistanceMaxPath-QI-values.mat");
    save(resultsPath, 'WPgenSeedScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/halfPopSearch-QI-values.mat");
    save(resultsPath, 'WPgenCombScores')    
    
    resultsPath = append(resultsFolder, "/", ship,"/randInit-QI-values.mat");
    save(resultsPath, 'WPgenRndcores')

else
    resultsPath = append(resultsFolder, "/", ship,"/RndSearch-QI-values.mat");
    load(resultsPath, 'rndSearchScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/WPgenSeed-QI-values.mat");
    load(resultsPath, 'WPgenSeedScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/WPgenComb-QI-values.mat");
    load(resultsPath, 'WPgenCombScores')

    resultsPath = append(resultsFolder, "/", ship,"/WPgenRnd-QI-values.mat");
    load(resultsPath, 'WPgenRndScores')
end

% 


allResultsMap = containers.Map();

allResultsMap("RndSearch") = rndSearchScores;
allResultsMap("WPgenSeed") = WPgenSeedScores;
allResultsMap("WPgenComb") = WPgenCombScores;
allResultsMap("WPgenRnd") = WPgenRndScores;

 

% Seed NSGA vs the rest
results = [["Approach 1" "Approach 2" "A12" "mannWhitney U-test" "Best search"]];
results = [results; voteOnSearchType(allResultsMap, "RndSearch", "WPgenSeed")];
results = [results; voteOnSearchType(allResultsMap, "RndSearch", "WPgenComb")];
results = [results; voteOnSearchType(allResultsMap, "RndSearch", "WPgenRnd")];
results = [results; voteOnSearchType(allResultsMap, "WPgenSeed", "WPgenComb")];
results = [results;voteOnSearchType(allResultsMap,  "WPgenSeed", "WPgenRnd" )];
results = [results; voteOnSearchType(allResultsMap, "WPgenComb", "WPgenRnd" )];

display(results)
resultsPath = append(resultsFolder, "/", ship,"/StatisticalTest-results.mat");
save(resultsPath, "results")



%searchNames = ["Random Search", "NSGA seed", "NSGA mixed", "NSGA random"];
searchNames = {"RS",'\texttt{WPgen$_{seed}}$', 'texttt{$WPgen_{comb}}$', '${texttt{WPgen_{rnd}}$'};
%searchNames = {'rndSearch', 'WPgen_seed', 'WPge_{comb}', 'WPgen_{rnd}'};


figure(1)
AX = axes;
boxplot([rndSearchScores, WPgenSeedScores WPgenCombScores WPgenRndScores], 'Labels', {{'RS', 'WPgenSeed', 'WPgenComb', 'WPgenRnd'}}, 'Whisker', 1.5)
%xlabel('Groups ($n_1 = 3$)', 'Interpreter', 'latex');
%set(searchNames,'Interpreter','latex')

%%% xticklabels({'RS', 'WPgenSeed', 'WPgenComb', 'WPgenRnd'});
%xticklabels(searchNames)
ax = gca; % Get current axes
ax.FontSize = 18;
ax.XTickLabel = {'$\mathbf{RS}$','$\mathbf{WPgen_{seed}}$', '$\mathbf{WPgen_{comb}}$', '$\mathbf{WPgen_{rnd}}$'};
set(gca, 'TickLabelInterpreter', 'latex');

%ax.XAxis.TickLabelInterpreter = 'latex'; % Set interpreter to LaTeX

%xticklabels({'SA(MO)$_{2}$H','RSMOH','MODA', 'tt'})
%Ax.TickLabelInterpreter = 'latex';
%xticklabels(searchNames,'Interpreter','latex')
%title(["Hypervolume: " ship])

%h = findobj(gca, 'Tag', 'Box'); % Find box objects
%for k = 1:length(h)
%    h(k).LineWidth = 2; % Increase line width for better visibility
%end



function scoresMatrix = calucateStatisticalScores(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues, searchPopulation, shipPopulation)
    scoresMatrix = [];
    referencePoint = [-minValues(1) maxValues(2)];
    thresholdObjective1 = minValues(1);

    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);
        %experimentParetoFront = experimentPopulation.best.objs;

        
        % Hypervolume
        experimentObjectives = experimentPopulation.objs;
        experimentObjectives(:,1) = experimentObjectives(:,1) -ones(length(experimentObjectives),1)*thresholdObjective1;
        experimentPopulation = SOLUTION(experimentPopulation.decs, experimentObjectives, experimentPopulation.cons);
        %n = length(minValues)*length(experimentPopulation.best.objs);
        n = 10000;
        HVscores = [hypervolume(experimentPopulation.best.objs, referencePoint, n)];
        scoresMatrix = [scoresMatrix; HVscores];

    end

end




function resultsInfo = voteOnSearchType(searchResultsMap, searchOneName, searchTwoName)
    % [a12value, mannWhitneyUtestValue, vote]    
    searchOne = searchResultsMap(searchOneName);
    searchTwo = searchResultsMap(searchTwoName);

    mannWhitneyUtestValue = ranksum(searchOne, searchTwo);
    a12value = a12(searchOne,searchTwo);

    if mannWhitneyUtestValue < 0.05 && a12value > 0.5
        finalVote = searchOneName; %[finalVote; searchOneName];
    elseif mannWhitneyUtestValue < 0.05 && a12value < 0.5
        finalVote = searchTwoName; %[finalVote; searchTwoName];
    elseif mannWhitneyUtestValue >= 0.05 || a12value == 0.5
        finalVote = "ND"; % [finalVote; "ND"]; 
    else
        finalVote = "";
    end
    resultsInfo = [searchOneName searchTwoName num2str(a12value) num2str(mannWhitneyUtestValue) finalVote] 
    
end