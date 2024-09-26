function [Dec,Obj,Con] = performSearch(ship, searchProcess, resultsPath, experimentNumber, numGenerations, populationSize)
    if searchProcess == "minDistanceMaxPath"
        algorithm = @NSGAIIAdapted;
    elseif searchProcess == "randomSearch"
        algorithm = @RandomSearchPopulation;
    end

    if ship == "mariner"
        problem = @MarinerWaypointSearch;
    elseif ship == "nspauv"
        problem = @npsauvWaypointsSearch;
    elseif ship == "remus100"
        problem = @Remus100WaypointsSearch;
    end

    MaxEvaluation = populationSize*numGenerations;

    global shipResultsPath 
    shipResultsPath = append(resultsPath, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber));

    [Dec,Obj,Con] = platemo('algorithm',algorithm,'problem',problem,'N', populationSize, 'maxFE',MaxEvaluation,'save', 0, 'run', 1);
    save(shipResultsPath, 'Dec', 'Obj', 'Con') 

end