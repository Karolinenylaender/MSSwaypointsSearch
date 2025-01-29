
function pointsAreToClose = pointsToClose(PointsMatrix, minDistance)
    if size(PointsMatrix,2) == 2
        pointsAreToClose  = minDistance > min(sqrt(diff(PointsMatrix(:,1)).^2 + diff(PointsMatrix(:,2)).^2 ));
    else
        pointsAreToClose  = minDistance > min(sqrt( diff(PointsMatrix(:,1)).^2 + diff(PointsMatrix(:,2)).^2 + diff(PointsMatrix(:,3)).^2)); 
    end
end
