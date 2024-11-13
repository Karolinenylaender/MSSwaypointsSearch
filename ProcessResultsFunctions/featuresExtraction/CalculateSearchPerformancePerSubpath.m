function [subPathPerformance, experimentPerformance] = CalculateSearchPerformancePerSubpath(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    experimentPerformance = [];
    subPathPerformance = [];

    numMetrics = 4;

    if ship == "remus100"
        numInitialWaypoints = 6;
    elseif ship == "nspauv"
        numInitialWaypoints = 6;
    elseif ship == "mariner"
        numInitialWaypoints = 7;
    end

    for generation = 1:numGenerations
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
        Obj = Population.objs;
        populationPerformanceMatrix = [];

        for individualIndex = 1:size(Obj,1)
            %individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullPath = individualPath('fullpath');
            transitionIndices = individualPath('transitionIndices');
            angles = individualPath('angles');
            if size(angles,2) > numMetrics - 1
                angles = angles(:,1:3);
            end
            
            individualPerformance = extractFeaturesPath(fullPath, angles, transitionIndices);

            peaksPerformance = [individualPerformance(:,2:end) sum(individualPerformance(:,2:end),2)];

            if transitionIndices(1) == length(fullPath)
                numMissingPaths = numInitialWaypoints;
                individualPerformance = -ones(numMissingPaths, numMetrics);
                maxNumberOfPeaks = peaksPerformance;
                averageNumberOfPeaks = peaksPerformance;
                sumNumberOfPeaks = peaksPerformance;
            elseif length(transitionIndices) < numInitialWaypoints
                numMissingPaths = numInitialWaypoints - length(transitionIndices);
                missingPathPerformance = -ones(numMissingPaths, numMetrics);
                individualPerformance = [individualPerformance; missingPathPerformance];
                maxNumberOfPeaks = max(peaksPerformance, [], 1);
                averageNumberOfPeaks = mean(peaksPerformance);
                sumNumberOfPeaks = sum(peaksPerformance);
            else
                numMissingPaths = 0;
                maxNumberOfPeaks = max(peaksPerformance, [], 1);
                averageNumberOfPeaks = mean(peaksPerformance);
                sumNumberOfPeaks = sum(peaksPerformance);
            end

            
            numberOfPeaksMatrix = [maxNumberOfPeaks; averageNumberOfPeaks; sumNumberOfPeaks];
            
            

            subPathPerformance = [subPathPerformance; individualPerformance];
            populationPerformanceMatrix = [populationPerformanceMatrix; [numMissingPaths numberOfPeaksMatrix(:)']];

            % individualPerformance = [numMissingPaths peaksPerformance(:)']
            % if transitionIndices(1) == length(fullPath)
            %     % all subpaths are missing
            %     numMissingPaths = numInitialWaypoints; 
            % 
            %     subPathPerformance = -ones(numMissingPaths, numMetrics);
            % 
            % elseif length(transitionIndices) < numInitialWaypoints
            %     % one or more subpaths are missing
            %     numMissingPaths = numInitialWaypoints - length(transitionIndices);
            %     missingPathPerformance = -ones(numMissingPaths, numMetrics);
            %     subPathPerformance = [individualPerformance; missingPathPerformance];
            % end
            % experimentPerformance = [experimentPerformance; individualPerformance];
        end
        experimentPerformance = [experimentPerformance; [Obj populationPerformanceMatrix]];
    end
    
end

function fullpathPerformance = extractFeaturesPath(fullPath, angles, transitionIndices)
    fullpathPerformance = [];
    transitionIndices = [1 transitionIndices'];
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
        
        numPeaksForAngles = zeros(size(currentAngles,2),1);
        for angleType = 1:size(currentAngles,2)
            [AnglesNumPeaks, ~] = calculateNumberOfPeaks(currentAngles(:,angleType));
            numPeaksForAngles(angleType) = AnglesNumPeaks;
        end
        lengthOfPath = length(currentPath)/pdist2(startPoint,endPoint);

        currentPathFeatures = [lengthOfPath; numPeaksForAngles];

        fullpathPerformance = [fullpathPerformance; currentPathFeatures'];
    end

end

function [numPeaks, validPeaks] = calculateNumberOfPeaks(measurement)
    neighborhoodSize = floor(length(measurement)/100);
    threshold = 0.01;

    [autocorrelation, ~] = xcorr(measurement, 'coeff');
    [peaks,~] = findpeaks(autocorrelation, 'MinPeakDistance',neighborhoodSize);
    
    validPeaks = peaks(peaks > threshold);
    numPeaks = length(validPeaks) - 1 ;
    if numPeaks < 0
        numPeaks = 0;
    end

   
end