function [experimentPerformance] = CalculateSearchPerformancePerSubpath(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    experimentPerformance = [];
    for generation = 1:numGenerations
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
        Dec = Population.decs;
        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullPath = individualPath('fullpath');
            transitionIndices = individualPath('transitionIndices');
            angles = individualPath('angles');

            pointsMatrix  =  reshape(individual, [3, 6])';

            individualPerformance = extractFeaturesPath(fullPath, angles, transitionIndices);
            if transitionIndices(1) == length(fullPath)
                % all subpaths are missing
                plotShipPath(fullPath,pointsMatrix,5)
                numMissingPaths = length(pointsMatrix);
                  
                individualPerformance = -ones(numMissingPaths, numMetrics);

            elseif length(transitionIndices) < (length(pointsMatrix))
                % one or more subpaths are missing
                numMissingPaths = length(pointsMatrix) - length(transitionIndices);
                missingPathPerformance = -ones(numMissingPaths, numMetrics);
                individualPerformance = [individualPerformance; missingPathPerformance];
            end
            experimentPerformance = [experimentPerformance; individualPerformance]
        end
    end
    
end

function fullpathPerformance = extractFeaturesPath(fullPath, angles, transitionIndices)
    fullpathPerformance = [];
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
        
        numPeaksForAngles = zeros(size(currentAngles,1),1);
        for angleType = 1:size(currentAngles,1)
            [AnglesNumPeaks, ~] = calculateNumberOfPeaks(currentAngles);
            numPeaksForAngles(angleType) = AnglesNumPeaks;
        end
        lengthOfPath = length(currentPath)/pdist2(startPoint,endPoint);

        currentPathFeatures = [lengthOfPath, numPeaksForAngles];
        
        fullpathPerformance = [fullpathPerformance; currentPathFeatures];
    end

end