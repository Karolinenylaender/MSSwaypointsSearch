function [subPathPerformance, experimentPerformance] = loadProsessedResults(ship, searchProcess, experimentNumber, populationSize, numGenerations)
 
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber),".mat");
    if exist(resultsPath) == 2
        load(resultsPath, 'subPathPerformance', 'experimentPerformance')
    else
        % didnt find file - calcuates 
        [subPathPerformance, experimentPerformance]  = CalculateSearchPerformancePerSubpath(ship, searchProcess, experimentNumber, populationSize, numGenerations);
        save(resultsPath, 'subPathPerformance', 'experimentPerformance')
    end
end

