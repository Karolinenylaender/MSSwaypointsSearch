classdef MarinerWaypointSearch < PROBLEM
    properties
        R_switch = 500
        Delta_h = 500
        minDistanceBetweenPoints
        validPath
        initialPoints
        intialSegementDistance
        initialPath
        generation
        pointDimension
        pathsMap
    end
    methods
        function Setting(obj)
            %x = [0 2000 5000 3000 6000 10000]';
            %y = [0 0 5000  8000 12000 12000]';

            obj.minDistanceBetweenPoints = obj.R_switch*2+1;
            obj.M = 2;                                  % set number of objectives
            obj.D = 5*2;                                % set number of decision variables 5 = num wpts, 2 = dimension xy 
            %obj.lower = ones(1,obj.D)*(-400); 
            %obj.lower(13:end) = obj.lower(13:end)*0;
            %.upper = ones(1,obj.D)*(2400);  
            %obj.upper(13:end) = ones(1,6)*(150);
            obj.encoding = ones(obj.D,1); 
            obj.generation = 1;
            obj.pointDimension = 2;
            obj.pathsMap = containers.Map();


        end

        function Population = Initialization(obj,N)
            if nargin < 2
                N = obj.N;
            end
            %PopDec = zeros(N, obj.D);
            % xinitial =  [0  2000 5000 3000 6000 10000];
            % yinitial =  [0  0 5000  8000 12000 12000];
            % InitalPoints = [xinitial(:,2:end) yinitial(:,2:end)];
            % 
            % %wpt.pos.x = xinitial';
            % %wpt.pos.y = yinitial';
            % %[simdata, state] = marinerPath(pointMatrix, obj.Delta_h, obj.R_switch);
            % %x = simdata(:,5);
            % %y = simdata(:,6);
            % %path = [x y];
            % 
            % %obj.initialPath = path;
            % %[~, obj.intialSegementDistnace] = calculateSegmentLengths(initialWaypointsMatrix, R_switch,path);
            % [fullpath, subPaths, ~] = performSimulation(InitalPoints, obj);
            % obj.initialPath = fullpath;
            % obj.intialSegementDistance = subPaths;
            % obj.initialPoints = InitalPoints;
            % 
            % obj.lower = InitalPoints - ones(size(InitalPoints))*500; % TODO set upper limit
            % obj.upper = InitalPoints + ones(size(InitalPoints))*500; % TODO lover limit
            % 
            % obj.validPath = ones(obj.N, 1);
            % obj.D = length(InitalPoints);
            % PopDec =  InitalPoints.*ones(N,1);
            [obj, PopDec] =  generateInitialPopulation(obj)
            Population = obj.Evaluation(PopDec);
            

        end

        function PopObj = CalObj(obj, PopDec)            
            PopObj = zeros(obj.N,obj.M);
            for individualIndex = 1:size(PopDec,1)
                 individual = PopDec(individualIndex,:);
                 
                 [fullpath, subPaths, transitionIndices] = performSimulation(individual, obj);
                 obj.pathsMap(string(individualIndex)) = fullpath;
                 [totalDistanceBetweenWaypoints, subPathLength] = evalauteWaypointsAndPath(obj.initialPoints, obj.initialPath, individual, fullpath, subPaths, transitionIndices)

                 PopObj(individualIndex,:) = [-subPathLength totalDistanceBetweenWaypoints ]; 
                 
            end

        end
        function PopCon = CalCon(obj, PopDec)
            % calculate constraint violations
            PopCon = ones(size(PopDec,1),1);
            for individualIndex = 1:size(PopDec,1)
                individual = PopDec(individualIndex,:);
                numPoints = length(individual)/2;
                x = individual(1:numPoints);
                y = individual((numPoints+1):end); 
                
                selPoints = [x' y'];

                PopCon(individualIndex) = round(obj.minDistanceBetweenPoints/2) < min(sqrt( diff(selPoints(:,1)).^2 + diff(selPoints(:,2)).^2));


                PopCon(individualIndex) = PopCon(individualIndex) && (obj.validPath(individualIndex) == 1);
                   
            end
        end

        function PopDec = CalDec(obj, PopDec)
            % calDec - Repair multiple invalid solutions;
            for individualIndex = 1:size(PopDec,1)
                individual = PopDec(individualIndex,:);
                numPoints = length(individual)/2;
                x = individual(1:numPoints);
                y = individual((numPoints+1):end); 
                selPoints = [x' y'];
                
                
                while (isPointsToClose(selPoints, obj.minDistanceBetweenPoints) == true ||  all(any(selPoints(1:end-1,:) == selPoints(2:end,:),2)) || any(all(selPoints== [0 0],2)) )


                    individual = obj.lower + (obj.upper - obj.lower).*rand(1,obj.D);

                    x = individual(1:numPoints);
                    y = individual((numPoints+1):end); 
                    selPoints = [x' y' ];

                end
                PopDec(individualIndex,:) = individual;
            end
        end
    end
end



function pointsAreToClose = isPointsToClose(points, maxDistanceBetweenPoints)
    if round(maxDistanceBetweenPoints/2) < min(sqrt(diff(points(:,1)).^2 + diff(points(:,2)).^2 ))
        pointsAreToClose = false;
    else
        pointsAreToClose = true;
    end
    
end





function [totalDistanceBetweenWaypoints, totalSubpathDistances] = evalauteWaypointsAndPath(initialPoints, intialPath, newPoints, fullpath, subPaths, transitionIndices)
    %[transitionIndices, pathSegments] = splitDataBetweenWaypoints(newPoints, R_switch,generatedPath);
    numPoints = length(initialPoints)/2; 
    xInitial = [0 initialPoints(1:numPoints)]';
    yInitial = [0 initialPoints((numPoints+1):end)]'; 
    xNew = [0 newPoints(1:numPoints)]';
    yNew = [0 newPoints((numPoints+1):end)]'; 
    initialPointsMatrix = [xInitial yInitial];
    newPointsMatrix = [xNew yNew];

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

function [fullpath, subPaths, transitionIndices] = performSimulation(listOfPoints, obj)

     numPoints = length(listOfPoints)/2;
     wpt.pos.x = [0 listOfPoints(1:numPoints)]';
     wpt.pos.y = [0 listOfPoints((numPoints+1):end)]';
     pointMatrix = [wpt.pos.x wpt.pos.y];

     [simdata, ~] = marinerPath(wpt, obj.Delta_h, obj.R_switch);
     x = simdata(:,5);
     y = simdata(:,6);
     fullpath = [x y];


     [transitionIndices, subPaths] = splitDataBetweenWaypoints(pointMatrix, obj.R_switch,fullpath);
end


function [obj, PopDec] =  generateInitialPopulation(obj)
    xinitial =  [0  2000 5000 3000 6000 10000];
    yinitial =  [0  0 5000  8000 12000 12000];
    InitalPoints = [xinitial(:,2:end) yinitial(:,2:end)];
       

    obj.lower = InitalPoints - ones(size(InitalPoints))*500; 
    obj.upper = InitalPoints + ones(size(InitalPoints))*500; 

    [fullpath, ~, transitionIndices] = performSimulation(InitalPoints, obj);
    obj.pathsMap('0') = fullpath;
    obj.initialPoints = InitalPoints;
    obj.initialPath = fullpath; 
    obj.intialSegementDistance = calculateSegmentLengths(transitionIndices, fullpath);
    obj.D = length(InitalPoints);
    obj.validPath = ones(obj.N, 1);


    randomPopulation = randomizePopulation(obj.N-1,obj.D, obj.minDistanceBetweenPoints, obj.lower, obj.upper, 2);
    PopDec = [obj.initialPoints; randomPopulation];
end


 function totalSubpathDistances  = calculateSegmentLengths(transitionIndices, fullpath)
    

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

