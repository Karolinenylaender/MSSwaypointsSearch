function [withinEachWayPoint, missingWaypoints] = isPathWithinWaypoints(wayPoints, R_switch,path)
    missingWaypoints = [];
    for point_idx=1:size(wayPoints,1)
        point = wayPoints(point_idx,:);
        distances = pdist2(point, path, 'euclidean');
        if all(distances > R_switch)
            missingWaypoints = [missing_waypoints; point];
        end
    end

    if isempty(missing_waypoints)
        withinEachWayPoint = true;
    else
        withinEachWayPoint = false;
    end
end