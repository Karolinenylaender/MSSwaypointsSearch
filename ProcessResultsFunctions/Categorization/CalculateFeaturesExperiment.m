function [experimentPerformance, totalObjectives] = CalculateFeaturesExperiment(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    numMetrics = 10;
    experimentPerformance = [];
    totalObjectives = [];
    
    for generation = 1:numGenerations
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
        if generation == 1
            intialPath = paths('0');
            decs = Population.decs;
            intialPoints = decs(1,:);

            fullPath = intialPath('fullpath');
            transitionIndices = intialPath('transitionIndices');

            initialPoints  =  reshape(intialPoints, [3, 6])';
            initalPathPerformance = evaluatePath(fullPath, transitionIndices);

        end
        Obj = Population.objs; 
        totalObjectives = [totalObjectives; Obj];
        Dec = Population.decs;

        generationPerformance = [];
        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullPath = individualPath('fullpath');
            transitionIndices = individualPath('transitionIndices');

            pointsMatrix  =  reshape(individual, [3, 6])';

            pathPerformance = evaluatePath(fullPath, transitionIndices);
            if transitionIndices(1) == length(fullPath)
                plotShipPath(fullPath,pointsMatrix,5)
                numMissingPaths = length(pointsMatrix);
                  
                pathPerformance = -ones(numMissingPaths, numMetrics);

            elseif length(transitionIndices) < (length(pointsMatrix))
                numMissingPaths = length(pointsMatrix) - length(transitionIndices);

                plotShipPath(fullPath,pointsMatrix,5)

                missingPathPerformance = -ones(numMissingPaths, numMetrics);
                pathPerformance = [pathPerformance; missingPathPerformance];
            else
                pathPerformance = pathPerformance; 
                
                if any(pathPerformance(:,1)>13) && (any(pathPerformance(:,2) > 0.01) || any(pathPerformance(2:end,3) > 0.1) || any(pathPerformance(2:end,4) > 0.02)) 
                    % max and std curvature
                    pathPerformance
                    pathPerformance(:,1:4)
                    plotShipPath(fullPath,pointsMatrix,5)
                    pathPerformance;
                end

                if any(pathPerformance(:,1)>10)
                    % length of path
                    pathPerformance
                    pathPerformance(:,1)
                    plotShipPath(fullPath,pointsMatrix,5)
                    pathPerformance;
                end
                if any(pathPerformance(:,2) > 0.01) || any(pathPerformance(2:end,3) > 0.1) || any(pathPerformance(2:end,4) > 0.02) 
                    % max and std curvature
                    pathPerformance
                    pathPerformance(:,2:4)
                    plotShipPath(fullPath,pointsMatrix,5)
                    pathPerformance;
                end

                if any(pathPerformance(:,5) > pi/2) ||  any(pathPerformance(:,6) > 0.01)  
                    pathPerformance
                    pathPerformance(:,5:6)
                    plotShipPath(fullPath,pointsMatrix,5)
                    pathPerformance;
                    % angle xy max

                    % angle xy std 

                end   
                if any(pathPerformance(:,7) > pi/2) || any(pathPerformance(:,8) > 0.01) 
                    pathPerformance
                    pathPerformance(:,7:8)
                    plotShipPath(fullPath,pointsMatrix,5)
                    pathPerformance;
                    % angle xz std 
                     % angle xz max
                end
                if any(pathPerformance(:,9) > pi/2) || any(pathPerformance(:,10) > 0.01)  
                    pathPerformance
                    pathPerformance(:,9:10)
                    plotShipPath(fullPath,pointsMatrix,5)
                    pathPerformance;
                    % angle yz max

                    % angle yz std     

                end

            end
            generationPerformance = [generationPerformance; pathPerformance];
        end

        experimentPerformance =[experimentPerformance; generationPerformance];

    end
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber));
    save(resultsPath, "experimentPerformance", "totalObjectives")
end



function pathPerformance = evaluatePath(fullPath,transitionIndices)
    curlinesResultsList = [];
    anglesResultsList = [];
    pathLengths = [];
    transitionIndices = [1; transitionIndices];
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
        curlinesResultsList= [curlinesResultsList; calculateCurvatureOfSubpath(currentPath)];
        anglesResultsList = [anglesResultsList; calculateAnglesOfSubpaths(currentPath)];
        pathLengths = [pathLengths; length(currentPath)/pdist2(startPoint,endPoint)];
        
    end
    pathPerformance = [pathLengths curlinesResultsList anglesResultsList];

end