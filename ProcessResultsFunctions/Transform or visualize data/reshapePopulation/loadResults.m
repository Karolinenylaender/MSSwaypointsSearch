function [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation)
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);
   
    experimentFolderName = append(searchProcess,"-ex", string(experimentNumber),"/"); 

    resultsPath = append(resultsFolder, "/", ship,"/",experimentFolderName, searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));

    load(resultsPath,"Population", "paths");

end