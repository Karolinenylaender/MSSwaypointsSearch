function [totalDistanceBetweenWaypoints, totalSubpathDistances] = evalauteWaypointsAndPath(initialPoints, intialPath, newPoints, fullpath, subPaths, transitionIndices)
    pointDimension = size(fullpath,2);
    numPoints = length(newPoints)/pointDimension;
    if pointDimension == 2
        initialPointsMatrix = [[0 0]; reshape(initialPoints, [pointDimension, numPoints])'];
        newPointsMatrix  = [[0 0]; reshape(newPoints, [pointDimension, numPoints])'];

    elseif pointDimension == 3
        initialPointsMatrix = [[0 0 0]; reshape(initialPoints, [pointDimension, numPoints])'];
        newPointsMatrix  = [[0 0 0]; reshape(newPoints, [pointDimension, numPoints])'];
    end

    % distance between initial and new waypoints 
    distanceBetweenWaypoints  = zeros(size(newPointsMatrix,1),1);
    for pointIndex = 1:size(newPointsMatrix,1)
        distanceBetweenWaypoints(pointIndex) = pdist2(initialPointsMatrix(pointIndex,:), newPointsMatrix(pointIndex,:),'euclidean');
    end
    totalDistanceBetweenWaypoints = abs(sum(distanceBetweenWaypoints));
    
    
    transitionIndices = [1; transitionIndices]; 
    subPathDistances = zeros(length(transitionIndices)-1,1);
    for pointIndex = 1:length(transitionIndices)-1
        startPoint = fullpath(transitionIndices(pointIndex),:);
        endPoint = fullpath(transitionIndices(pointIndex+1),:);
        subpathLength = transitionIndices(pointIndex+1) - transitionIndices(pointIndex);
        pointDistance = pdist2(startPoint,endPoint);

        subPathDistances(pointIndex) = subpathLength/pointDistance;
    end
    totalSubpathDistances = sum(subPathDistances);

    
end