classdef MarinerWaypointSearch < PROBLEM
    properties
        Delta_h = 500;                   % Look-ahead distance
        R_switch = 400;                  % Radius of switching circle
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

            obj.minDistanceBetweenPoints = obj.R_switch*2+1;
            obj.M = 2;                                  % set number of objectives
            obj.D = 5*2;                                % set number of decision variables 5 = num wpts, 2 = dimension xy 

            obj.encoding = ones(obj.D,1); 
            obj.generation = 1;
            obj.pointDimension = 2;
            obj.pathsMap = containers.Map();
            obj.generationPerformances = [];
            obj.shipName = "mariner";
        end

        function Population = Initialization(obj,N)
            if nargin < 2
                N = obj.N;
            end
            xinitial =  [0  2000 5000 3000 6000 10000];
            yinitial =  [0  0 5000  8000 12000 12000];
            InitalPoints = [xinitial(:,2:end)' yinitial(:,2:end)']';
            InitalPoints = InitalPoints(:)'; 

            obj.initialPoints = InitalPoints;
            
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
            % calculate constraint violations
            PopCon = ones(size(PopDec,1),1);
            for individualIndex = 1:size(PopDec,1)
                individual = PopDec(individualIndex,:);
                numPoints = length(individual)/obj.pointDimension;

                pointsMatrix  =  reshape(individual, [obj.pointDimension, numPoints])';

                PopCon(individualIndex) = round(obj.minDistanceBetweenPoints/2) > min(sqrt( diff(pointsMatrix(:,1)).^2 + diff(pointsMatrix(:,2)).^2));
                   
            end
        end

        function PopDec = CalDec(obj, PopDec)
            % calDec - Repair multiple invalid solutions;
            for individualIndex = 1:size(PopDec,1)
                individual = PopDec(individualIndex,:);
                numPoints = length(individual)/2;
                pointsMatrix  =  reshape(individual, [obj.pointDimension, numPoints])';
                
                while (isPointsToClose(pointsMatrix, obj.minDistanceBetweenPoints) == true ||  all(any(pointsMatrix(1:end-1,:) == pointsMatrix(2:end,:),2)) || any(all(pointsMatrix== [0 0],2)))
                    individual = obj.lower + (obj.upper - obj.lower).*rand(1,obj.D);
                    pointsMatrix  =  reshape(individual, [obj.pointDimension, numPoints])';

                end
                PopDec(individualIndex,:) = individual;
            end
        end
    end
end






