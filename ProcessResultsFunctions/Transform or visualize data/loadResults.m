function [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation)
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);
    if searchProcess == "WPgenSeed"
        experimentFolderName = append("WPgenSeed-ex", string(experimentNumber),"/");
    elseif searchProcess == "RndSearch"
        experimentFolderName = append("RndSearch-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "WPgenComb" 
        experimentFolderName = append("WPgenComb-ex", string(experimentNumber),"/");
    elseif searchProcess == "WPgenRnd"
        experimentFolderName = append("WPgenRnd-ex", string(experimentNumber),"/"); 
    
    end

    resultsPath = append(resultsFolder, "/", ship,"/",experimentFolderName, searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));

    load(resultsPath,"Population", "paths");



end