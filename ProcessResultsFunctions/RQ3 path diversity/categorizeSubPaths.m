function [allPathsEvaluations, experimentsCountMap] = categorizeSubpaths(ship, searchProcess, recategorize)
    populationSize = 10; 
    numGenerations = 1000;
    numExperiments = 30;
    validExperiments = 1:numExperiments;


    shipInformation = loadShipSearchParameters(ship);
    numWaypoints = length(shipInformation.initialPoints)/shipInformation.pointDimension;


    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    
    if recategorize == true
        if ship == "mariner"
            numSubpaths = 5;
        else
            numSubpaths = 6;
        end
    
        allPathsEvaluations = [];
        experimentsCountMap= containers.Map;
        for experimentNumber = validExperiments
            experimentsCount = [];
            resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-pathPerformance-exNum-" , num2str(experimentNumber),".mat");
            load(resultsPath, "subPathPerformance", "experimentPerformance");
    
            experimentPopulation = loadExperimentsPopulations(ship, searchProcess, experimentNumber, populationSize, numGenerations);
      
            % use the pareto front
            experimentParetoFront = experimentPopulation.best;
            experimentDecs = experimentParetoFront.decs;
    
            for individualIdx = 1:numWaypoints:(size(experimentDecs,1)*numSubpaths)
                
                currentPath = subPathPerformance(individualIdx:individualIdx+numWaypoints-1,:);
        
                individualPoints = experimentDecs((individualIdx+numWaypoints-1)/numWaypoints,:);
                fullPathEvaluation = [];
                for subpathIdx = 1:numSubpaths
                    if ship == "mariner"
                        subCurrentPath = currentPath(subpathIdx,4:end);
                    else
                        subCurrentPath = currentPath(subpathIdx,2:end);
                    end
                    
                    if any(subCurrentPath == -1) % the subpath is missing
                        type = "M";
                    elseif all(subCurrentPath == 0) % all the angles are stable
                        type = "S";
                    else
                        type = "U"; % one or more angle are unstable;
                    end
                    fullPathEvaluation = [fullPathEvaluation type];
                end
                experimentsCount = [experimentsCount; fullPathEvaluation];
                allPathsEvaluations = [allPathsEvaluations; fullPathEvaluation];   
            end         
            experimentsCountMap(string(experimentNumber)) = experimentsCount;
    
        end
        resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-ProssesedPathPerformance",".mat");
        save(resultsPath, "allPathsEvaluations", "experimentsCountMap");
    else
        resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-ProssesedPathPerformance",".mat");
        load(resultsPath, "allPathsEvaluations", "experimentsCountMap");
    end
end


