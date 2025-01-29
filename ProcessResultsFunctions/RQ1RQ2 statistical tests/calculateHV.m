function calculateHV(ship)
    populationSize = 10; 
    numGenerations = 1000;
    numExperiments = 30;
    
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    validExperiments = 1:numExperiments;
    rndSearchPopulation = loadAllShipPopulations(ship, "RndSearch",validExperiments, populationSize, numGenerations);
    seedWPgenPopulation = loadAllShipPopulations(ship, "WPgenSeed",validExperiments, populationSize, numGenerations);
    combWPgenPopulation = loadAllShipPopulations(ship, "WPgenComb",validExperiments, populationSize, numGenerations); 
    rndWPgenPopulation =  loadAllShipPopulations(ship, "WPgenRnd",validExperiments, populationSize, numGenerations); 
    
     
    rndSearchObjectives = rndSearchPopulation.objs;
    seedNSGAObjectives = seedWPgenPopulation.objs;
    mixedNSGAObjecitves = combWPgenPopulation.objs;
    randomNSGAObjectives = rndWPgenPopulation.objs;

    combinedObjectives = [rndSearchObjectives; seedNSGAObjectives; mixedNSGAObjecitves; randomNSGAObjectives];

    combinedSearches = SOLUTION([rndSearchPopulation.decs; seedWPgenPopulation.decs; combWPgenPopulation.decs; rndWPgenPopulation.decs], ...
                                [rndSearchPopulation.objs; seedWPgenPopulation.objs; combWPgenPopulation.objs; rndWPgenPopulation.objs], ...
                                [rndSearchPopulation.cons; seedWPgenPopulation.cons; combWPgenPopulation.cons; rndWPgenPopulation.cons]);

    maxObjectives = [max(combinedObjectives(:,1)), max(combinedObjectives(:,2))];
    minObjectives = [min(combinedObjectives(:,1)), min(combinedObjectives(:,2))];

    rndSearchScores = calucateStatisticalScores(ship, "RndSearch",validExperiments, populationSize, numGenerations,maxObjectives, minObjectives, rndSearchPopulation, combinedSearches);
    WPgenSeedScores = calucateStatisticalScores(ship, "WPgenSeed",validExperiments, populationSize, numGenerations,maxObjectives, minObjectives, seedWPgenPopulation, combinedSearches);
    WPgenCombScores = calucateStatisticalScores(ship, "WPgenComb",validExperiments, populationSize, numGenerations,maxObjectives, minObjectives, combWPgenPopulation, combinedSearches);
    WPgenRndScores = calucateStatisticalScores(ship, "WPgenSeed",validExperiments, populationSize, numGenerations,maxObjectives, minObjectives, rndWPgenPopulation, combinedSearches);

    % save results
    resultsPath = append(resultsFolder, "/", ship,"/randomSearch-QI-values.mat");
    save(resultsPath, 'rndSearchScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/minDistanceMaxPath-QI-values.mat");
    save(resultsPath, 'WPgenSeedScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/halfPopSearch-QI-values.mat");
    save(resultsPath, 'WPgenCombScores')    
    
    resultsPath = append(resultsFolder, "/", ship,"/randInit-QI-values.mat");
    save(resultsPath, 'WPgenRndScores')

    function scoresMatrix = calucateStatisticalScores(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues, searchPopulation, shipPopulation)
        scoresMatrix = [];
        referencePoint = [-minValues(1) maxValues(2)];
        thresholdObjective1 = minValues(1);

        for experimentNumber = validExperiments
            experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);
            
    
            experimentObjectives = experimentPopulation.objs;
            experimentObjectives(:,1) = experimentObjectives(:,1) -ones(length(experimentObjectives),1)*thresholdObjective1; % reshape objective 1 to go from max to min
            experimentPopulation = SOLUTION(experimentPopulation.decs, experimentObjectives, experimentPopulation.cons);
            %n = length(minValues)*length(experimentPopulation.best.objs);
            n = 10000;
            HVscores = [hypervolume(experimentPopulation.best.objs, referencePoint, n)];
            scoresMatrix = [scoresMatrix; HVscores];
    
        end

    end

end



