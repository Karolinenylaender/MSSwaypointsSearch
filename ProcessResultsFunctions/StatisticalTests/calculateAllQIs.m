close all
clear all

ship = "marienr";
%ship = "remus100";
ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;


if ship == "mariner"
    SearchValidExperiments = 1:7; 
    RandomValidExperiments = 1:13;

else
    SearchValidExperiments = 1:30; 
    RandomValidExperiments = 1:30;
end

PopulationNSGASearch = loadAllShipPopulations(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
PopulationRandomSearch = loadAllShipPopulations(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations);
NSGAObjectives = PopulationNSGASearch.objs;
randomObjectives = PopulationRandomSearch.objs;
combinedObjectives = [NSGAObjectives; randomObjectives];
combinedSearches = SOLUTION([PopulationNSGASearch.decs; PopulationRandomSearch.decs], [PopulationNSGASearch.objs; PopulationRandomSearch.objs], [PopulationNSGASearch.cons; PopulationRandomSearch.cons]);
%shipParetoFront = combinedSearches.best.objs;
%NSGAiiParetoFront = PopulationNSGASearch.best.objs;
%randomParetoFront = PopulationRandomSearch.best.objs;


maxObjectives = [max(combinedObjectives(:,1)), max(combinedObjectives(:,2))];
minObjectives = [min(combinedObjectives(:,1)), min(combinedObjectives(:,2))];

NSGAscores = calucateStatisticalScores(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, PopulationNSGASearch, combinedSearches)
RandomScores = calucateStatisticalScores(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations,maxObjectives, minObjectives, PopulationRandomSearch, combinedSearches)

QIs = ["Generational Distance (GD)", "Euclidean Distance (ED)", "Epsilon (EP)", "Generalized Spead (GS)", " PAreto front size (PFS)", "Inverted Generational Distance (IGD)", "Coverage (C)", "Hypervolume approximation", "Hypervolume"]
QIs = ["Generational Distance (GD) ", "Inverted Generational Distance (IGD)", "Euclidean Distance (ED)", "Epsilon (EP)"  " Pareto front size (PFS)",  "Coverage (C)", "Hypervolume approximation", "Hypervolume Platemo"]

for i = 1:length(QIs)

    figure(i)
    boxplot([NSGAscores(:,i), RandomScores(:,i)])
    xticklabels({"NSGA search", "Random search"})
    title(QIs(i))
end



%epsionScore = epsilon_metric(PopulationNSGASearch.best.objs, PopulationRandomSearch.best.objs)

resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

resultsPath = append(resultsFolder, "/", ship,"/minDistanceMaxPath-QI-values.mat");
save(resultsPath, 'NSGAscores')

resultsPath = append(resultsFolder, "/", ship,"/randomSearch-QI-values.mat");
save(resultsPath, 'RandomScores')






function scoresMatrix = calucateStatisticalScores(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues, searchPopulation, shipPopulation)
    scoresMatrix = [];
    %referencePoint = maxValues;
    referencePoint = [-minValues(1) maxValues(2)];
    optimalPoint = [minValues(1) minValues(2)];
    searchParetoFront = searchPopulation.best.objs;
    shipParetoFront = shipPopulation.best.objs;
    
    thresholdObjective1 = minValues(1);
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);
        experimentParetoFront = experimentPopulation.best.objs;

        % Generational Distance
        GDscore = GD(experimentPopulation,shipParetoFront);

        % IGD
        IGDscore = IGD(experimentPopulation,shipParetoFront);

        % Euclidean Distance
        sIdeal = [min(experimentParetoFront(:,1)) min(experimentParetoFront(:,2))];
        %sIdeal = optimalPoint;
        EDscore = min(pdist2(sIdeal, experimentParetoFront));

        % Epsilon
        epsionScore = epsilon_metric(experimentParetoFront,shipParetoFront);

        % Pareto front size 
        PFSscore = length(experimentParetoFront);

        % Coverage
        CoverageScore = sum(all(ismember(experimentParetoFront,shipParetoFront),2)) / length(shipParetoFront);

        % Hypervolume
        experimentObjectives = experimentPopulation.objs;
        experimentObjectives(:,1) = experimentObjectives(:,1) -ones(length(experimentObjectives),1)*thresholdObjective1;
        experimentPopulation = SOLUTION(experimentPopulation.decs, experimentObjectives, experimentPopulation.cons);
        n = length(minValues)*length(experimentPopulation.best.objs);
        n = 10000;
        HVscores = [hypervolume(experimentPopulation.best.objs, referencePoint, n) HV(experimentPopulation,referencePoint)];

        scores = [GDscore IGDscore EDscore epsionScore PFSscore CoverageScore HVscores];
        scoresMatrix = [scoresMatrix; scores];

    end

end




