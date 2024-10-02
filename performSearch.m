function [Dec,Obj,Con] = performSearch(ship, searchProcess, resultsPath, experimentNumber, numGenerations, populationSize)
    if searchProcess == "minDistanceMaxPath"
        algorithm = @NSGAIIAdapted;
        parameter.populationType = "normal";
    elseif searchProcess == "randomSearch"
        algorithm = @RandomSearchPopulation;
        %populationSize = populationSize*numGenerations;
        %numGenerations = 1;
        parameter.populationType = "randomSearch";
    end

    MaxEvaluation = populationSize*numGenerations;

    shipResultsPath = append(resultsPath, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber));

    parameter.shipResultsPath =  shipResultsPath;
    problem = @shipWaypointsSearch;
    parameter.shipInformation = loadShipSearchParameters(ship);
    
    [Dec,Obj,Con] = platemo('algorithm',algorithm,'problem',problem,'N', populationSize, 'maxFE',MaxEvaluation,'save', 0, 'run', 1, 'parameter', parameter);
    save(shipResultsPath, 'Dec', 'Obj', 'Con') 

end