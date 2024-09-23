classdef Remus100WaypointsSearch < PROBLEM
    properties
        minDistanceBetweenPoints
        validPath
        initialPoints 
        intialSegementDistance
        initialPath
        R_switch = 5
        generation
        path
        pointDimension
        pathsMap
        generationPerformances
    end
    methods
        % Default settings of the problem
        function Setting(obj)

            obj.minDistanceBetweenPoints = obj.R_switch*2+1;  
            obj.M = 2;                                     % Set number of objectives
            obj.D = 6*3;                                   % Set number of decision variables

            obj.encoding = ones(obj.D,1);
            obj.generation = 1;
            obj.pointDimension = 3;
            obj.pathsMap = containers.Map(); % container to save all the paths for one generation 
            obj.generationPerformances = [];
            %obj.evaluationMap = containers.Map();
        end
        
        function Population = Initialization(obj,N)
            if nargin < 2
                N = obj.N;
            else
                obj.N = N;
            end
            
            [obj, PopDec] =  generateInitialPopulation(obj);
            Population = obj.Evaluation(PopDec);

            
        end

        function PopObj = CalObj(obj, PopDec)
            PopObj = zeros(obj.N,obj.M);
            for individualIndex = 1:size(PopDec,1)
                
                individual = PopDec(individualIndex,:);
                [fullpath, subPaths, transitionIndices] = performSimulation(individual, obj);
                paths = containers.Map();
                paths("fullpath") = fullpath;
                paths("subPaths") = subPaths;
                paths("transitionIndices") = transitionIndices;
                obj.pathsMap(string(individualIndex)) =paths;
                
                [totalDistanceBetweenWaypoints, subPathLength] = evalauteWaypointsAndPath(obj.initialPoints, obj.initialPath, individual, fullpath, subPaths, transitionIndices);
                PopObj(individualIndex,:) = [-subPathLength totalDistanceBetweenWaypoints];
            end 
            obj.generationPerformances = [obj.generationPerformances; calculateGenerationOverallPerformance(PopObj)];
        end

        function PopCon = CalCon(obj, PopDec)
            PopCon = ones(size(PopDec,1),1);
            for individualIndex = 1:size(PopDec,1)
                individual = PopDec(individualIndex,:);

                numPoints = length(individual)/obj.pointDimension;

                pointsMatrix  =  reshape(individual, [obj.pointDimension, numPoints])';
                z = pointsMatrix(:,3)';

                PopCon(individualIndex) = round(obj.minDistanceBetweenPoints/2) > min(sqrt( diff(pointsMatrix(:,1)).^2 + diff(pointsMatrix(:,2)).^2 + diff(pointsMatrix(:,3)).^2));
                PopCon(individualIndex) = PopCon(individualIndex) || any(z < zeros(1,numPoints));

                   
            end



        end
        function PopDec = CalDec(obj, PopDec)
            % calDec - Repair multiple invalid solutions
            for individualIndex = 1:size(PopDec,1)
                individual = PopDec(individualIndex,:);
                numPoints = length(individual)/obj.pointDimension;

                pointsMatrix  =  reshape(individual, [obj.pointDimension, numPoints])';


                while (pointsToClose(pointsMatrix, obj.minDistanceBetweenPoints/2) == true ||  all(any(pointsMatrix(1:end-1,:) == pointsMatrix(2:end,:),2)) || any(all(pointsMatrix== [0 0 0],2)) || all(pointsMatrix(:,3) < zeros(numPoints,1))) % && (obj.validPath(individualIndex) ~= 1))
                    individual = obj.lower + (obj.upper - obj.lower).*rand(1,obj.D);
                    pointsMatrix  =  reshape(individual, [obj.pointDimension, numPoints])';

                end
                PopDec(individualIndex,:) = individual;
                    

            end

        end
        
    end
end

function validation = pointsToClose(PointsMatrix, minDistance)
    validation = minDistance > min(sqrt( diff(PointsMatrix(:,1)).^2 + diff(PointsMatrix(:,2)).^2 + diff(PointsMatrix(:,3)).^2)); 

end



function totalSubpathDistances  = calculateSegmentLengths(transitionIndices, fullpath)
    transitionIndices = [1; transitionIndices]; %% at 1 size the inital point = [0 0 0]
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

function [totalDistanceBetweenWaypoints, totalSubpathDistances] = evalauteWaypointsAndPath(initialPoints, intialPath, newPoints, fullpath, subPaths, transitionIndices)
    % Reshape points list to matrix
    pointDimension = size(fullpath,2);
    numPoints = length(newPoints)/pointDimension;
    initialPointsMatrix = [[0 0 0]; reshape(initialPoints, [pointDimension, numPoints])'];
    newPointsMatrix  = [[0 0 0]; reshape(newPoints, [pointDimension, numPoints])'];

    % calculate distance between initial points and new points
    distanceBetweenWaypoints  = zeros(size(newPointsMatrix,1),1);
    for pointIndex = 1:size(newPointsMatrix,1)
        distanceBetweenWaypoints(pointIndex) = pdist2(initialPointsMatrix(pointIndex,:), newPointsMatrix(pointIndex,:),'euclidean');
    end
    totalDistanceBetweenWaypoints = abs(sum(distanceBetweenWaypoints));
    
    % calculate the path length between each point
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


function [fullpath, subPaths, transitionIndices] = performSimulation(listOfPoints, obj)
     numPoints = length(listOfPoints)/obj.pointDimension;
     pointsMatrix = reshape(listOfPoints, [obj.pointDimension, numPoints])';
     wpt.pos.x  = [0; pointsMatrix(:,1)];
     wpt.pos.y  = [0; pointsMatrix(:,2)];
     wpt.pos.z  = [0; pointsMatrix(:,3)];
     
 
     [simdata , ~, ~] = remus100path(wpt, obj.R_switch);      
     eta_mutated = simdata(:,18:23);
     x_mutated = eta_mutated(:,1);
     y_mutated = eta_mutated(:,2);
     z_mutated = eta_mutated(:,3);
     fullpath = [x_mutated y_mutated z_mutated];


     [transitionIndices, subPaths] = splitDataBetweenWaypoints(pointsMatrix, obj.R_switch,fullpath);
end


function [obj, PopDec] =  generateInitialPopulation(obj)
    xinitial =  [0  -20 -100   0  200, 200  400];
    yinitial =  [0  200  600 950 1300 1800 2200];
    zinitial =  [0   10  100 100   50   50   50];
    InitalPoints = [xinitial(:,2:end)' yinitial(:,2:end)' zinitial(:,2:end)']';
    InitalPoints = InitalPoints(:)'; 
    obj.pointDimension = 3;

    [fullpath, subPaths, transitionIndices] = performSimulation(InitalPoints, obj);
    paths = containers.Map();
    paths("fullpath") = fullpath;
    paths("subPaths") = subPaths;
    paths("transitionIndices") = transitionIndices;
    obj.pathsMap('0') = paths;

    obj.initialPoints = InitalPoints;
    obj.initialPath = fullpath; 
    obj.intialSegementDistance =calculateSegmentLengths(transitionIndices, fullpath);

    xLower = xinitial - ones(size(xinitial))*150;
    xUpper = xinitial + ones(size(xinitial))*150;

    yLower = yinitial - ones(size(yinitial))*150;
    yUpper = yinitial + ones(size(yinitial))*150;

    zLower =  zeros(size(zinitial));
    zUpper =  zinitial + ones(size(zinitial))*150;

    obj.lower = [xLower(:,2:end)' yLower(:,2:end)' zLower(:,2:end)']';
    obj.upper = [xUpper(:,2:end)' yUpper(:,2:end)' zUpper(:,2:end)']';
    obj.lower = obj.lower(:)';
    obj.upper = obj.upper(:)';
   
    obj.D = length(InitalPoints);
    obj.validPath = ones(obj.N, 1);

    %randomPopulation = randomizePopulation(obj.N/2,obj.D, obj.minDistanceBetweenPoints, obj.lower, obj.upper, 3);
    strategyAitor = true;
    if strategyAitor 
        randomAitorPopulation = seedPopulation((obj.N)-1,obj.D, obj.minDistanceBetweenPoints, obj.lower, obj.upper, obj.pointDimension, InitalPoints);
    end
    PopDec = [obj.initialPoints; randomAitorPopulation]; %; randomPopulation];

    %PopDec = [obj.initialPoints; randomAitorPopulation; randomPopulation];
    %PopDec = [obj.initialPoints; randomPopulation];


end



