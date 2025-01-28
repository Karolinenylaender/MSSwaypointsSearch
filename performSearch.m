function [Dec,Obj,Con] = performSearch(ship, searchProcess, resultsPath, experimentNumber, numGenerations, populationSize)
    if searchProcess == "WPgenSeed" 
        algorithm = @WPgen;
        parameter.populationType = "Seed";
        searchName = searchProcess;
    elseif searchProcess == "WPgenComb"
        algorithm = @WPgen;
        parameter.populationType = "Comb";
        searchName = "WPgenComb";
        searchProcess = "minDistanceMaxPath";

    elseif searchProcess == "WPgenRnd"
        algorithm = @WPgen;
        parameter.populationType = "Rnd";
        searchName = "WPgenRnd"
        searchProcess = "minDistanceMaxPath";
    elseif searchProcess == "RndSearch"
        algorithm = @RandomSearchPopulation;
        parameter.populationType = "Random";
        searchName = searchProcess;
    end

    

    MaxEvaluation = populationSize*numGenerations;

    shipResultsPath = append(resultsPath, "/", ship,"/", searchName, "-P", string(populationSize), "-exNum", string(experimentNumber));

    parameter.shipResultsPath =  shipResultsPath;
    problem = @shipWaypointsSearch;
    parameter.shipInformation = loadShipSearchParameters(ship);
    
    [Dec,Obj,Con] = platemo('algorithm',algorithm,'problem',problem,'N', populationSize, 'maxFE',MaxEvaluation,'save', 0, 'run', 1, 'parameter', parameter);
    save(shipResultsPath, 'Dec', 'Obj', 'Con') 

end