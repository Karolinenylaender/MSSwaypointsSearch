function combinedPopulations = loadAllShip(ship, searchProcess, validExperiments, populationSize, numGenerations)
    
    folderName = append("ExtractedPopulations/");
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    objectivesPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum",string(validExperiments(1)), "-", string(validExperiments(end)),".mat");
    
    if exist(objectivesPath) == 2
        load(objectivesPath,'combinedPopulations');
    else
        combinedPopulations = [];
        decsList = [];
        objsList = [];
        consList = [];
        for experimentNumber = validExperiments
            experimentPopulation = loadExperimentsPopulation(ship, searchProcess, experimentNumber,populationSize, numGenerations);
            decsList = [decsList; experimentPopulation.decs];
            objsList = [objsList; experimentPopulation.objs];
            consList = [consList; experimentPopulation.cons];
    
        end
        combinedPopulations = SOLUTION(decsList, objsList, consList);
        save(objectivesPath,'combinedPopulations');
    end
    
end