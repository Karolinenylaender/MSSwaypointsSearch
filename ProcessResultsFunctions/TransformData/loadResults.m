function [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation)
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);
    if searchProcess == "minDistanceMaxPath"
        experimentFolderName = append("ex", string(experimentNumber),"/");
    elseif searchProcess == "randomSearch"
        experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
    end

    resultsPath = append(resultsFolder, "/", ship,"/",experimentFolderName, searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));

    load(resultsPath,"Population", "paths");



end