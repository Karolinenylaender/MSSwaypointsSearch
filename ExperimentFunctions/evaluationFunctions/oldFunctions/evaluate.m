%function evaluate
function [average_distance, median_distance, max_distance, min_distance,withinEachWayPoint, missing_waypoints, validPoints, pointsOutsidePath] = evaluate(wayPoints, R_switch, xpath, ypath, zpath)   
    average_distance = 0;
    median_distance= 0;
    max_distance = 0;
    min_distance = 0;
    withinEachWayPoint = 0;
    missing_waypoints = 0;
    validPoints = true;
    if nargin < 5
        [withinEachWayPoint, missing_waypoints] = isPathWithinWaypoints(wayPoints, R_switch, xpath, ypath);
        [average_distance, median_distance, max_distance, min_distance, pointsOutsidePath] = distanceFromOptimalPath(wayPoints, R_switch, xpath, ypath);
        %pointsOutsidePath = roadDeviation(wayPoints, R_switch, xpath, ypath);
    elseif nargin == 5
        [withinEachWayPoint, missing_waypoints] = isPathWithinWaypoints(wayPoints, R_switch, xpath, ypath, zpath);
        [average_distance, median_distance, max_distance, min_distance, pointsOutsidePath] = distanceFromOptimalPath(wayPoints, R_switch, xpath, ypath, zpath);
        %pointsOutsidePath = roadDeviation(wayPoints, R_switch, xpath, ypath, zpath);
        if any(zpath < 0)
            validPoints = false;
        end
    else
        validPoints = false;
    end

end
    

function [withinEachWayPoint, missing_waypoints] = isPathWithinWaypoints(wayPoints, R_switch, xpath, ypath, zpath)
    %path = [xpath(:), ypath(:)];
    if nargin == 4
        path = [xpath(:) ypath(:)];
    else
        path = [xpath(:) ypath(:) zpath(:)];
    end
    missing_waypoints = [];
    for point_idx=1:size(wayPoints,1)
        point = wayPoints(point_idx,:);
        distances = pdist2(point, path, 'euclidean');
        if all(distances > R_switch)
            missing_waypoints = [missing_waypoints; point];
        end
    end

    if isempty(missing_waypoints)
        withinEachWayPoint = true;
    else
        withinEachWayPoint = false;
    end
end

function [average_distance, median_distance, max_distance, min_distance, pointsOutsidePath] = distanceFromOptimalPath(wayPoints, R_switch, xpath, ypath, zpath)
    if nargin == 4 
        points = [xpath, ypath];
    else
        points = [xpath, ypath, zpath];
    end

    num_points = length(xpath);
    min_distances_list = zeros(num_points, 1);

    largest_point =  max(wayPoints(:));
    minimum_dist = largest_point;

    
    % Loop over each point in the generated path
    for i=1:num_points
        point = points(i,:);
        min_dist = largest_point;

        for j= 1:size(wayPoints,1)-1
            v1 = wayPoints(j,:);
            v2 = wayPoints(j+1,:);

            % Calcualte the distance from point to the current line
            % segment
            dist = point_to_line_segment(point, v1, v2);    
            if dist < min_dist
               min_dist = dist;
            end
        end
        if min_dist ~= 0 && min_dist < minimum_dist 
            minimum_dist = min_dist;
        end
        min_distances_list(i) = min_dist;
    end
    mean(min_distances_list);
    min_distances_list = abs(min_distances_list);

    average_distance = mean(min_distances_list);
    median_distance = median(min_distances_list);
    max_distance = max(min_distances_list);
    min_distance = minimum_dist;

    pointsOutsidePath = min_distances_list(min_distances_list>R_switch);
    %prosentageOutside = length(pointsOutsidePath)/num_points

end




       
    

%% END
function dist = point_to_line_segment(pt, v1, v2)
        % Vector from v1 to pt
        a = pt - v1;
        % Vector from v1 to v2
        b = v2 - v1;
        % Projection of a onto b
        t = dot(a, b) / dot(b, b);
        % Clamp t to the interval [0, 1]
        t = max(0, min(1, t));
        % Projection point on the line segment
        proj = v1 + t * b;
        % Distance from pt to the projection
        dist = norm(pt - proj);
end

function mmi = motionSickness(time, state)
    x = state(1:12);
    xdot = state(12:24);
    ui = state(25:28);
    Vc = beta(29);
    betaVc = state(30);


    %simdata = [t z_d theta_d psi_d r_d Vc betaVc wc ui' x']
    betaVc  = simdata(:,7);
    x = [U; zeros(5,1); xn; yn; zn; phi; theta; psi];
    x = simdata
    U = x(1)

    w_e = encounter(w_0,U,beta);           % Frequency of encounter (rad/s)
    %%msi = HMmsi(a_z(i),w_e);               % O'Hanlon and McCauley MSI (%)
    %msi = HMmsi(a_z,w_e)


    x = state(:,1:12);
    xdot = state(:,13:24);
    ui = state(:,25:27);
    Vc = state(:,28);
    betaVc = state(:,29);
    we = state(:,30);



    % check if there are large changes inn acceleration or velcotiy
    U = zeros(length(time),1)
    a_z = zeros(length(time),1)
    wW = Vc
    beta = betaVc
    msi = zeros(length(time),1)
    for step = 1:length(time)
        U(step) = sqrt(u(step)^2 + v(step)^2 + r(step)^2);
        
        a_z = mean(abs(vdot(step)));
        w_e = encounter(wW(step),U,beta(step));           % Frequency of encounter (rad/s)
        msi(step) = HMmsi(a_z,w_e);
    end
    
end

function energyConsumption(data)
    % give a number for the energy consumption
    x0 = data.x0
    simdata = data.simdata
    state = data.state
    
end

function shipStateStabilty(data)
    % check if there are large changes inn acceleration or velcotiy
end

function pointsOutsidePath = roadDeviation(wayPointsPath, R_switch, xpath, ypath, zpath)
    % roadRadius = R_switch;

    % if nargin == 4
    %     %wayPointsPath = [waypoints.pos.x; waypoints.pos.y]
    %     generatedPath = [xpath ypath];
    % 
    %     %[in,on] = ispolygon(xpath, ypath)
    % 
    % 
    %     % Calculate the road
    %     dx = diff(wayPointsPath(:,1));
    %     dy = diff(wayPointsPath(:,2));
    %     normals = [dy -dx] ./ sqrt(dx.^2 + dy.^2);
    % 
    %     upperPath = [wayPointsPath(1,:)-roadRadius*[1 1]]
    %     for pointIxd =1:size(wayPointsPath,1)-1
    % 
    %         change = ones(1,2)
    %         if (dx(pointIxd)) < 0
    %             change(2) = 1
    %         elseif dx(pointIxd) == 0
    %             change(2) = -1
    %         else 
    %             change(2) = -1
    %         end
    % 
    %         change = ones(1,2)
    %         if (dy(pointIxd)) < 0
    %             change(1) = 1
    %         elseif dy(pointIxd) == 0
    %             change(1) = -1
    %         else 
    %             change(1) = -1
    %         end
    % 
    %         %upperPath = [upperPath; wayPointsPath(pointIxd,:)+roadRadius*[1 -1]]
    %         upperPath = [upperPath; wayPointsPath(pointIxd,:)+roadRadius*change]
    % 
    %     end
    %     upperPath = [upperPath; wayPointsPath(end,:)+roadRadius*change]
    % 
    %     lowerPath = [wayPointsPath(1,:)+roadRadius*[1 1]]
    %     for pointIxd =1:size(wayPointsPath,1)
    %         lowerPath = [upperPath; wayPointsPath(2:end,:) - roadRadius*normals]
    %     end
    % 
    %     %normals = [-1 1; normals]
    %     %leftSide =  wayPointsPath + normals*roadRadius
    %     %rightSide = wayPointsPath - normals*roadRadius
    %     %road = [leftSide; rightSide]
    %     %road = [wayPointsPath(1,) + roadRadius*normals; wayPointsPath(2,:) - roadRadius*normals];
    %     %%upperPath = [wayPointsPath(1:end-1,:) + roadRadius*normals;  
    %     %%             wayPointsPath(end,:)-roadRadius*[0 1]]
    %     %lowerPath = [wayPointsPath(1,:); wayPointsPath(2:end,:) - roadRadius*normals]
    %     %lowerPath = [wayPointsPath(1,:)-roadRadius*[1 0];
    %     %             wayPointsPath(2:end,:) - roadRadius*normals]
    % 
    %     roadfigure = [upperPath;  flip(lowerPath)]
    %     %road = [wayPointsPath(1:end-1,:) + roadRadius*normals; 
    %     %        wayPointsPath(end,:); 
    %     %        wayPointsPath(1,:); 
    %     %        wayPointsPath(2:end,:) - roadRadius*normals];
    %     plot(wayPointsPath(:,2), wayPointsPath(:,1), 'b--o', upperPath(:,2), upperPath(:,1), 'g'); %, lowerPath(:,2), lowerPath(:,1))
    %     %plot(wayPointsPath(:,2), wayPointsPath(:,1), roadfigure(:,2), roadfigure(:,1))
    %     isOnRoad = inpolygon(generatedPath(:,1),generatedPath(:,2), roadfigure(:,1), roadfigure(:,2));
    %     pointsNotOnRoad = generatedPath(~isOnRoad,:);
    % 
    %     pointsOutsidePath = pointsNotOnRoad;
    % 
    % else
    %     %wayPointsPath = [waypoints.pos.x; waypoints.pos.y; waypoints.pos.z]
    %     generatedPath = [xpath'; ypath'; zpath'];
    % 
    % 
    %     % Calculate the minimum distance from the point to the path
    %     distances = sqrt(sum(bsxfun(@minus, wayPointsPath, reshape(generatedPath,1,size(generatedPath,2),[])).^2,2));
    %     minDistances = squeeze(min(distances,[],1));
    % 
    %    % Check which points are inside the tube
    %     areInsideTube = minDistances <= tubeRadius;
    % 
    %     % Get the points that are not inside the tube
    %     pointsNotInsideTube = generatedPath(~areInsideTube,:);
    % 
    %     pointsOutsidePath = pointsNotInsideTube;
    % end
    
end


function timestepsBetweenWaypoints(path, points, R_switch)
    
    % Calculate distances
    point_distances = [sqrt(sum(diff(points).^2,2)); 0]; 
    
    % Find waypoints within radius R
    within_radius = distances <= R_switch;
    
    % Calculate time steps
    scaled_time_steps = (sum(within_radius, 2) .* point_distances)
end