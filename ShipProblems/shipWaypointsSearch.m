classdef shipWaypointsSearch < PROBLEM
    properties
        minDistanceBetweenPoints
        initialPoints 
        initialPath
        R_switch
        generation
        pointDimension
        pathsMap
        shipName 
    end
    methods
        % Default settings of the problem
        function Setting(obj)

            obj.M = 2;                                     % Set number of objectives
            obj.generation = 1;
            obj.pathsMap = containers.Map(); 

        end
        
        function Population = Initialization(obj,N, parameters)

            populationType = parameters.populationType; 
            shipInformation = parameters.shipInformation;

            obj.shipName = shipInformation.shipName;
            obj.initialPoints = shipInformation.initialPoints;
            obj.pointDimension = shipInformation.pointDimension;
            obj.R_switch = shipInformation.R_switch;
            obj.minDistanceBetweenPoints = obj.R_switch*2+1; 
            
            obj.D = length(obj.initialPoints);
            obj.encoding = ones(obj.D,1);

            [lower, upper, PopDec] =  generateInitialPopulation(obj, populationType);
            obj.lower = lower;
            obj.upper = upper;
            Population = obj.Evaluation(PopDec);

            
        end

        function PopObj = CalObj(obj, PopDec)
            PopObj = zeros(obj.N,obj.M);
            for individualIndex = 1:size(PopDec,1)
                
                individual = PopDec(individualIndex,:);
                [fullpath, subPaths, transitionIndices, angles] = performSimulation(individual, obj);
                paths = containers.Map();
                paths("fullpath") = fullpath;
                paths("transitionIndices") = transitionIndices;
                paths("angles") = angles;
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

                if obj.pointDimension == 3
                    PopCon(individualIndex) = PopCon(individualIndex) || any(z < zeros(1,numPoints));
                end
                   
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







