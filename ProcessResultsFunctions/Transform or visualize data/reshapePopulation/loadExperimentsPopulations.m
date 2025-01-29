function experimentPopulation = loadExperimentsPopulations(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    
    experimentFolderName = append(searchProcess,"-ex", string(experimentNumber),"/"); 
    folderName = append("ExtractedPopulations/",experimentFolderName); 
    
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    objectivesPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber),".mat");
    if exist(objectivesPath) == 2
        load(objectivesPath,'experimentPopulation');
    else
        % merge together generation
        decsList = [];
        objsList = [];
        consList = [];
        addList = [];
        for generation = 1:numGenerations
            resultsPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation),".mat");
            load(resultsPath, 'Population');
            decsList = [decsList; Population.decs];
            objsList = [objsList; Population.objs];
            consList = [consList; Population.cons];
            addList = [addList Population.add];

        end
        experimentPopulation = SOLUTION(decsList, objsList, consList);
        save(objectivesPath,'experimentPopulation');
    end
end