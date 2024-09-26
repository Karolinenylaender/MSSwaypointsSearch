%% categorize paths

close all
clear all


shipInitialwaypoints

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

N = 100; % Population size
numGenerations = 1;
MaxEvaluation = numGenerations*N; %100*N; % Maximum number of evaluations

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


initalPoints = waypoints(ship) 
R_switch = initalPoints.R_switch;
numMetrics = 3;
figureNumber = 1;
plotPath = false;


if searchProcess == "randomSearch"
    startExperiment = 400;
    maxExperiments = 425;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 1000;
    maxExperiments = 1001;
    populationSize = 20; 
    numGenerations = 511;
end

basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";

experimentsResults = containers.Map() ;
for experimentNumber = startExperiment:maxExperiments
    generationResults = containers.Map();
    for generation = 1:numGenerations
        
        generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
        load(generationPath)
        
        if generation == 1
            intialPath = paths('0');
            decs = Population.decs;
            intialPoints = decs(1,:);
            Dec = decs(1:end,:);
            [initalPointsMatrix,wpt] = transformListOfPointToMatrix(intialPoints, ship);
            %[intialDistanceBetweenWaypoints, intialSubpathDistances, intialNumMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPointsMatrix, R_switch);
        
        else
            Dec = Population.decs;
        end
    
        populationPerformance = zeros(size(Dec,1),3);

        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullpath = individualPath("fullpath");
            pathSegments = individualPath("subPaths");
            transitionIndices = individualPath("transitionIndices");
            
            [pointsMatrix,wpt] = transformListOfPointToMatrix(intialPoints, ship);

            %[pointsMatrix,wpt] = transformListOfPointToMatrix(individual, ship);
            %[totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, individualPath, pointsMatrix, R_switch);
            %populationPerformance(individualIndex,:) = [-totalDistanceBetweenWaypoints, totalSubpathDistances-intialSubpathDistances, numMissingWaypoints];
            %populationPerformance(individualIndex,:) = [-totalDistanceBetweenWaypoints, totalSubpathDistances, numMissingWaypoints];
            %populationPerformance(individualIndex,:) = [-totalSubpathDistances totalDistanceBetweenWaypoints numMissingWaypoints];
            
            pathPerformance = evaluatePath(pointsMatrix, R_switch, transitionIndices, pathSegments)
            numMissingWaypoints = size(pointsMatrix,1) - length(transitionIndices) - 2
            if numMissingWaypoints > 0
                pathPerformance
            end
              
        end
        
        generationResults(string(generation)) = populationPerformance;

    end 
    experimentsResults(string(experimentNumber)) = generationResults;
    resultsPath = append(basepath,ship,"/", "processedResults/",searchProcess ,string(experimentNumber))
    save(resultsPath, "experimentsResults")
end




%% 

%% metrics analysis 



function pathPerformance = evaluatePath(pointsMatrix, R_switch, transitionIndices, pathSegments)
    %transitionIndices = [1; transitionIndices]
    numPoints = size(pointsMatrix,1)
    curlinesResultsList = [];
    anglesResultsList = [];
    for pathSectionIndex = 1:length(pathSegments)
        startPoint = pointsMatrix(pathSectionIndex,:)
        endPoint = pointsMatrix(pathSectionIndex+1,:)
        currentPath = pathSegments{pathSectionIndex};
        curlinesResultsList= [curlinesResultsList; calculateTheCurlinessOfThePath(currentPath)];
        anglesResultsList = [anglesResultsList; calucalteTheCurlinesAngles(currentPath, startPoint, endPoint)];
        
    end
    pathPerformance = [curlinesResultsList anglesResultsList];

    % if length(transitionIndices) == numPoints
    % 
    % else 
    % 
    % end
    % 

end

function angleResults  = calucalteTheCurlinesAngles(fullPath, startPoint, endPoint)
    xpath = fullPath(:,1);
    ypath = fullPath(:,2);
    n = length(xpath);
    % Calculate the differences
    dx = gradient(xpath); 
    dy = gradient(ypath);
    %ddx = gradient(dx); 
    %ddy = gradient(dy);


    %anglesXY = atan2(dy,dx);
    %dAnglesXY = gradient(anglesXY);
    %dAnglesXY = mod(dAnglesXY +pi, 2*pi) - pi;
    [anglesXY, dAnglesXY, maxAngleXY, devAngleXY] = anglesBetween(dy, dx);
    anglesDirect = endPoint-startPoint
    anglesDirectXY = atan2(anglesDirect(2),anglesDirect(1));
    %maxangles = max(dAngles);
    %angles_dev = std(dAngles)
    
    angleResults = [maxAngleXY devAngleXY anglesDirectXY]
    if size(fullPath,2) == 3
    
        zpath = fullPath(:,3);
        dz = gradient(zpath);
        ddz = gradient(dz);

        [anglesXZ, dAnglesXZ, maxAngleXZ, devAngleXZ] = anglesBetween(dz, dx);
        [anglesYZ, dAnglesYZ, maxAngleYZ, devAngleYZ] = anglesBetween(dz, dy);
        
        anglesDirectXZ = atan2(anglesDirect(3),anglesDirect(1));
        anglesDirectYZ = atan2(anglesDirect(3),anglesDirect(2));
        %[anglesZ_XY, dAnglesZ_XY, maxAngleZ_XY, devAngleZ_XY] = anglesBetween(sqrt(dx.^2 + dy.^2), dz);
        %[anglesY_XZ, dAnglesY_XZ, maxAngleY_XZ, devAngleY_XZ] = anglesBetween(sqrt(dx.^2 + dz.^2), dy);
        %[anglesX_YZ, dAnglesX_YZ, maxAngleX_YZ, devAngleX_YZ] = anglesBetween(sqrt(dy.^2 + dz.^2), dx);


        angleResults = [angleResults maxAngleXZ, devAngleXZ anglesDirectXZ maxAngleYZ, devAngleYZ anglesDirectYZ]
                        %anglesZ_XY, dAnglesZ_XY, maxAngleZ_XY, devAngleZ_XY,
                        %anglesY_XZ, dAnglesY_XZ, maxAngleY_XZ, devAngleY_XZ,
                        %anglesX_YZ, dAnglesX_YZ, maxAngleX_YZ, devAngleX_YZ]
       
    end


    
    function [angle, dAngle, maxAngle, devAngle] = anglesBetween(axizA, axizB)
        angle = atan2(axizA,axizB);
        dAngle = gradient(angle);
        dAngle = mod(dAngle +pi, 2*pi) - pi;

        maxAngle = max(dAngle);
        devAngle = std(dAngle);

    end

end

function curliness = calculateTheCurlinessOfThePath(fullPath)
    % Assume that x and y are vectors representing the path.
    xpath = fullPath(:,1);
    ypath = fullPath(:,2);
    n = length(xpath);
    % Calculate the differences
    dx = gradient(xpath); 
    dy = gradient(ypath);
    ddx = gradient(dx); 
    ddy = gradient(dy);

    if size(fullPath,2) == 2
        % Calculate the curvature
        curvature = abs(ddx .* dy(1:n-2) - dx(1:n-2) .* ddy) ./ ((dx(1:n-2).^2 + dy(1:n-2).^2).^(3/2));
    elseif size(fullPath,2) == 3
        zpath = fullPath(:,3);
        dz = gradient(zpath);
        ddz = gradient(dz);

        numerator = sqrt((ddy.*dz - ddz.*dy).^2 + (ddz.*dx - ddx.*dz).^2 + (ddx.*dy - ddy.*dx).^2);
        denominator = (dx.^2 + dy.^2 + dz.^2).^(3/2);
        curvature = numerator ./ (denominator + eps); % eps is added to avoid division by zero

    end
    
   
    % Calculate the curliness
    curliness = [mean(abs(curvature)) max(abs(curvature)) std(abs(curvature))];
end

function [pointsMatrix,wpt] = transformListOfPointToMatrix(Listpoints, ship)
    if ship == "mariner"
        numPoints = length(Listpoints)/2;
         pointsMatrix = [[0 0 0]; reshape(Listpoints, [2, numPoints])'];
        wpt.pos.x = pointsMatrix(:,1); 
        wpt.pos.y = pointsMatrix(:,2); 
    else 
        numPoints = length(Listpoints)/3;   
        pointsMatrix = [[0 0 0]; reshape(Listpoints, [3, numPoints])'];
        wpt.pos.x = pointsMatrix(:,1); 
        wpt.pos.y = pointsMatrix(:,2); 
        wpt.pos.z = pointsMatrix(:,3);  
       
    end
    
end