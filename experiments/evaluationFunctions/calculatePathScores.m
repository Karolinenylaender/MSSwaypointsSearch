 function [totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, generatedPath, pointsMatrix, R_switch)
    [transitionIndices, ~] = splitDataBetweenWaypoints(pointsMatrix, R_switch,generatedPath);

    % distance between initial and new waypoints 
    distanceBetweenWaypoints  = zeros(size(pointsMatrix,1),1);
    for pointIndex = 1:size(pointsMatrix,1)
        distanceBetweenWaypoints(pointIndex) = pdist2(initalPointsMatrix(pointIndex,:), pointsMatrix(pointIndex,:),'euclidean');
    end
    totalDistanceBetweenWaypoints = abs(sum(distanceBetweenWaypoints));

    transitionIndices = [1; transitionIndices]; 
    subPathDistances = zeros(length(transitionIndices)-1,1);
    for pointIndex = 1:length(transitionIndices)-1
        startPoint = generatedPath(transitionIndices(pointIndex),:);
        endPoint = generatedPath(transitionIndices(pointIndex+1),:);
        subpathLength = transitionIndices(pointIndex+1) - transitionIndices(pointIndex);
        pointDistance = pdist2(startPoint,endPoint);

        subPathDistances(pointIndex) = subpathLength/pointDistance;
    end
    totalSubpathDistances = sum(subPathDistances);


    % missing waypoints
    numMissingWaypoints = size(pointsMatrix,1) - length(transitionIndices);
    

    
 end