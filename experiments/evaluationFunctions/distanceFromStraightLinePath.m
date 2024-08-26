function distances_list = distanceFromStraightLinePath(wayPoints, R_switch, xpath, ypath, zpath)
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


    distances_list = abs(min_distances_list);
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
