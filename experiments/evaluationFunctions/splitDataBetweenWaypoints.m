function [transitionIndices, pathSegments] = splitDataBetweenWaypoints(pointsMatrix, R_switch,path)
    transitionIndices = []; 
    pathSegments = [];
    current_start_idx = 1 ;
    for pointIndex = 1:length(pointsMatrix) - 1
        %startPoint = pointsMatrix(pointIndex,:);
        endPoint = pointsMatrix(pointIndex+1,:);

        for pathPoints = current_start_idx:size(path,1)
            dist_to_end =  pdist2(path(pathPoints,:), endPoint);

            if dist_to_end < R_switch
                % store segment indeices
                transitionIndices = [transitionIndices; pathPoints];
                pathSegments{end+1} = path(current_start_idx:pathPoints,:); % Store the indices of the segment
                current_start_idx = pathPoints + 1; % Update the start index for the next segment
                break;
            end

        end

    end
    
    
        
    if current_start_idx <= size(path, 1) 
        if isempty(pathSegments)
            pathSegments{1} =  path(current_start_idx:size(path, 1),:);
            transitionIndices = size(path,1);
        else
            pathSegments{end} = [pathSegments{end}; path(current_start_idx:size(path, 1),:)];
            transitionIndices(end) = size(path,1);
        end
        %pathSegments{end+1} = path(current_start_idx:size(path, 1),:);
    end
   
end