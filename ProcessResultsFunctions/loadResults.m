function [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation)
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));

    load(resultsPath,"Population", "paths");



end