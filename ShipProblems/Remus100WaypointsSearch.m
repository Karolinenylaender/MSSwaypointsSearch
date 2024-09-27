classdef Remus100WaypointsSearch < PROBLEM
    properties
        minDistanceBetweenPoints
        %validPath
        initialPoints 
        initialPath
        R_switch = 5
        generation
        %path
        pointDimension
        pathsMap
        %generationPerformances
        shipName = "remus100"
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
            %obj.generationPerformances = [];
            %obj.evaluationMap = containers.Map();

            obj.shipName = "remus100";
        end
        
        function Population = Initialization(obj,N, populationType)
            if nargin < 2
                N = obj.N;
                populationType = "normal"
            elseif nargin < 3
                obj.N = N;
                populationType = "normal"
            end
            populationType = populationType;
            xinitial =  [0  -20 -100   0  200, 200  400];
            yinitial =  [0  200  600 950 1300 1800 2200];
            zinitial =  [0   10  100 100   50   50   50];
            InitalPoints = [xinitial(:,2:end)' yinitial(:,2:end)' zinitial(:,2:end)']';
            InitalPoints = InitalPoints(:)'; 
            obj.initialPoints = InitalPoints;
            obj.D = length(obj.initialPoints);
            [lower, upper, PopDec] =  generateInitialPopulation(obj, populationType);
            obj.lower = lower;
            obj.upper = upper;
            Population = obj.Evaluation(PopDec);

            
        end

        function PopObj = CalObj(obj, PopDec)
            PopObj = zeros(obj.N,obj.M);
            for individualIndex = 1:size(PopDec,1)
                
                individual = PopDec(individualIndex,:);
                [fullpath, subPaths, transitionIndices] = performSimulation(individual, obj);
                paths = containers.Map();
                paths("fullpath") = fullpath;
                paths("transitionIndices") = transitionIndices;
                obj.pathsMap(string(individualIndex)) =paths;
                
                [totalDistanceBetweenWaypoints, subPathLength] = evalauteWaypointsAndPath(obj.initialPoints, obj.initialPath, individual, fullpath, subPaths, transitionIndices);
                PopObj(individualIndex,:) = [-subPathLength totalDistanceBetweenWaypoints];
            end 
            %obj.generationPerformances = [obj.generationPerformances; calculateGenerationOverallPerformance(PopObj)];
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







