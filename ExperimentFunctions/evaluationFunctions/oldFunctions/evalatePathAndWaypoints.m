function performance = evalatePathAndWaypoints(initalpoints, intialpath, generatedPath, waypointsMatrix, R_switch)

     [transitionIndices, pathSegments] = splitDataBetweenWaypoints(waypointsMatrix, R_switch,generatedPath);
     performanceMatrix = [];
     for segment = 1:length(pathSegments)
        startpoint = waypointsMatrix(segment,:);
        endPoint = waypointsMatrix(segment +1,:);
        %distanceBetweenPoints = sqrt(sum(startPoint - endPoint.^2))
        distanceBetweenPoints = pdist2(startpoint, endPoint, 'euclidean');
        currentPath = pathSegments{segment};
    
        x = currentPath(:,1);
        y = currentPath(:,2);
        z = currentPath(:,3);
        % Define your path
        
        % Calculate the path's derivative
        dx = gradient(x); % Changes in x
        dy = gradient(y); % Changes in y
        dz = gradient(z);
        
    
        % Calculate the second derivative
        d2x = gradient(dx); % Changes in dx
        d2y = gradient(dy); % Changes in dy
        d2z = gradient(dz);
    
        %std_dev_velocity = std(sqrt(dx.^2 + dy.^2));
        %std_dev_acceleration = std(sqrt(d2x.^2 + d2y.^2));
    
        angles = atan2(dy,dx);
        dAngles = diff(angles);
        dAngles = mod(dAngles +pi, 2*pi) - pi;

        polarAngles = atan2(sqrt(dx.^2 + dy.^2), dz); 
        dpolarAngles = diff(polarAngles);
        dpolarAngles = mod(dpolarAngles +pi, 2*pi) - pi;
     
    
        
        % Calculate the magnitude of the derivative
        %fluxness = sqrt(dx.^2 + dy.^2);
        curvature = sqrt(d2x.^2 + d2y.^2 + d2z.^2);
    
        %averagefluxness = mean(fluxness);
        %maxfluxness = max(fluxness);
        %total_variation = sum(sqrt(dx.^2 + dy.^2));
        averagecurvature = mean(curvature);
        %maxcurvature = max(curvature);
        %std_dev = std(curvature);
        %averageAngles = mean(dAngles);
        maxangles = max(dAngles);
        angles_dev = std(dAngles);
        %avg_polar = mean(dpolarAngles);
        maxpolar = max(dpolarAngles);
        polar_dev = std(dpolarAngles);
        
        distanceBetweenPoints = length(currentPath)/distanceBetweenPoints;
    
        %performanceList = [segment std_dev_velocity std_dev_acceleration averagefluxness maxfluxness averagecurvature maxcurvature std_dev averageAngles maxangles angles_dev distanceBetweenPoints];
        performanceList = [averagecurvature maxangles angles_dev maxpolar polar_dev distanceBetweenPoints];
        performanceMatrix = [performanceMatrix; performanceList];
     end

     axisDistances = zeros(size(intialpath,2),1);
     for axis = 1:size(intialpath,2)
        axisDistances(axis) = dtw(intialpath(:,axis), generatedPath(:,axis));
     end
     totalPathDistanceDTW = sum(axisDistances);
     [withinEachWayPoint, missingWaypoints] = findMissingWaypoints(waypointsMatrix, R_switch, generatedPath);

     distanceBetweenWaypoints = 0;
     for pointIndex = 1:size(initalpoints,1)
         distanceBetweenWaypoints = distanceBetweenWaypoints + pdist2(initalpoints(pointIndex,:), waypointsMatrix(pointIndex,:), 'euclidean');
     end

     
     %distanceBetweenWaypoints = diff(initalpoints-waypointsMatrix);
     %distanceBetweenWaypoints = sum(abs(distanceBetweenWaypoints));

     
     performance = [sum(performanceMatrix,1)  totalPathDistanceDTW distanceBetweenWaypoints size(missingWaypoints,1)];


end



function [withinEachWayPoint, missingWaypoints] = findMissingWaypoints(wayPoints, R_switch,path)
    missingWaypoints = [];
    for point_idx=1:size(wayPoints,1)
        point = wayPoints(point_idx,:);
        distances = pdist2(point, path, 'euclidean');
        if all(distances > R_switch)
            missingWaypoints = [missingWaypoints; point];
        end
    end

    if isempty(missingWaypoints)
        withinEachWayPoint = true;
    else
        withinEachWayPoint = false;
    end
end