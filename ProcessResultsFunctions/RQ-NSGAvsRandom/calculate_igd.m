function igd_value = calculate_igd(S, P)
    % S: Matrix of obtained solutions (n x m) 
    %    where n is the number of solutions and m is the number of objectives.
    % P: Matrix of reference Pareto front (k x m)
    %    where k is the number of reference points and m is the number of objectives.

    % Number of reference points
    num_ref_points = size(P, 1);
    
    % Initialize the sum of minimum distances
    total_distance = 0;
    
    % Loop through each point in the reference Pareto front
    for i = 1:num_ref_points
        % For each reference point, calculate the distance to all points in S
        distances = sqrt(sum((S - P(i, :)).^2, 2));
        
        % Find the minimum distance
        min_distance = min(distances);
        
        % Add the minimum distance to the total
        total_distance = total_distance + min_distance;
    end
    
    % Compute the IGD value by averaging the total distance
    igd_value = total_distance / num_ref_points;
end
