%% metrics analysis 
close all
clear all
shipInitialwaypoints

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

N = 100; % Population size
numGenerations = 1;
MaxEvaluation = numGenerations*N; %100*N; % Maximum number of evaluations

searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";
ship = "remus100";

initalPoints = waypoints(ship) 
R_switch = initalPoints.R_switch;
numMetrics = 3;
figureNumber = 1;
plotPath = false;


if searchProcess == "randomSearch"
    startExperiment = 1000;
    maxExperiments = 1000;
    populationSize = 20;
    numGenerations = 511;
else
    startExperiment = 20;
    maxExperiments = 20;
    populationSize = 10; 
    numGenerations = 1000;
end

basepath = "/Users/karolinen/Documents/MATLAB/Simulators/ExperimentFunctions/multiobjectiveSearch/results/";


experimentPerformance = [];
totalObjectives = [];
for experimentNumber = startExperiment:maxExperiments
    
    for generation = 182:182 %1:numGenerations
        generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
        %generationPath = "/Users/karolinen/Documents/MATLAB/Simulators/ExperimentFunctions/multiobjectiveSearch/results/remus100/exNum11-19/minDistanceMaxPath-P10-exNum19-g931" %append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
      
        load(generationPath);
        Dec = Population.decs;
        %load(NextgenerationPath);
           
        % if generation == 1
        %     intialPath = paths('0');
        %     decs = Population.decs;
        %     intialPoints = decs(1,:);
        %     Dec = decs(1:end,:);
        %     %[initalPointsMatrix,wpt] = transformListOfPointToMatrix(intialPoints, ship);
        %     %[intialDistanceBetweenWaypoints, intialSubpathDistances, intialNumMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPointsMatrix, R_switch);
        % 
        % else
        %     Dec = Population.decs;
        % end
        Dec = Population.decs;

        generationPerformance = [];
        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullPath = individualPath('fullpath');
            %pathSegments = individualPath('subPaths');
            transitionIndices = individualPath('transitionIndices');
            %[pointsMatrix,wpt] = transformListOfPointToMatrix(individual, ship)
            pointsMatrix  =  reshape(individual, [3, 6])';
        
            pathPerformance = evaluatePath(fullPath, transitionIndices , pointsMatrix, R_switch);
            if transitionIndices(1) == length(fullPath)
                numMissingPaths = length(pointsMatrix)-1;
                pathPerformance = ones(numMissingPaths, 10);

            elseif length(transitionIndices) < (length(pointsMatrix)-1)
                %semiPathPerformance =  evaluatePath (pathSegments , pointsMatrix, R_switch);
                numMissingPaths = 5 - length(transitionIndices);
                missingPathPerformance = -ones(numMissingPaths, 10);
                pathPerformance = [pathPerformance; missingPathPerformance];
            else
                pathPerformance = pathPerformance; %evaluatePath(pathSegments , pointsMatrix, R_switch);

            end
            % TODO save this to the path elns
            generationPerformance = [generationPerformance; pathPerformance];
        end
        experimentPerformance =[experimentPerformance; generationPerformance];

    end
end



function pathPerformance = evaluatePath(fullPath,transitionIndices, pointsMatrix, R_switch)
    [transitionIndices, ~] = splitDataBetweenWaypoints(pointsMatrix, R_switch,fullPath);
    curlinesResultsList = [];
    anglesResultsList = [];
    pathLengths = [];
    transitionIndices = [1; transitionIndices];
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        %currentPath = pathSegments{pathSectionIndex};
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);
        curlinesResultsList= [curlinesResultsList; calculateTheCurlinessOfThePath(currentPath)];
        anglesResultsList = [anglesResultsList; calucalteTheCurlinesAngles(currentPath, startPoint, endPoint)];
        pathLengths = [pathLengths; length(currentPath)/pdist2(startPoint,endPoint)];
        
    end
    pathPerformance = [pathLengths curlinesResultsList anglesResultsList];

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
    anglesDirect = endPoint-startPoint;
    anglesDirectXY = atan2(anglesDirect(2),anglesDirect(1));
    

    %anglesXY = atan2(dy,dx);
    %dAnglesXY = gradient(anglesXY);
    %dAnglesXY = mod(dAnglesXY +pi, 2*pi) - pi;
    [anglesXY, dAnglesXY, maxAngleXY, devAngleXY] = anglesBetween(dy, dx, anglesDirectXY);
    
    %maxangles = max(dAngles);
    %angles_dev = std(dAngles)
    
    angleResults = [maxAngleXY devAngleXY]
    if size(fullPath,2) == 3
    
        zpath = fullPath(:,3);
        dz = gradient(zpath);
        ddz = gradient(dz);
        anglesDirectXZ = atan2(anglesDirect(3),anglesDirect(1));
        anglesDirectYZ = atan2(anglesDirect(3),anglesDirect(2));

        [anglesXZ, dAnglesXZ, maxAngleXZ, devAngleXZ] = anglesBetween(dz, dx, anglesDirectXZ);
        [anglesYZ, dAnglesYZ, maxAngleYZ, devAngleYZ] = anglesBetween(dz, dy, anglesDirectYZ);
        
        
        %[anglesZ_XY, dAnglesZ_XY, maxAngleZ_XY, devAngleZ_XY] = anglesBetween(sqrt(dx.^2 + dy.^2), dz);
        %[anglesY_XZ, dAnglesY_XZ, maxAngleY_XZ, devAngleY_XZ] = anglesBetween(sqrt(dx.^2 + dz.^2), dy);
        %[anglesX_YZ, dAnglesX_YZ, maxAngleX_YZ, devAngleX_YZ] = anglesBetween(sqrt(dy.^2 + dz.^2), dx);


        angleResults = [angleResults maxAngleXZ devAngleXZ maxAngleYZ, devAngleYZ]; % anglesDirectYZ]
        %angleResults = [angleResults maxAngleXZ, devAngleXZ anglesDirectXZ maxAngleYZ] %, devAngleYZ anglesDirectYZ]

        %anglesZ_XY, dAnglesZ_XY, maxAngleZ_XY, devAngleZ_XY,
                        %anglesY_XZ, dAnglesY_XZ, maxAngleY_XZ, devAngleY_XZ,
                        %anglesX_YZ, dAnglesX_YZ, maxAngleX_YZ, devAngleX_YZ]
       
    end
    
    function [angle, dAngle, maxAngle, devAngle] = anglesBetween(axizA, axizB, directAngle)
        angle = atan2(axizA,axizB) - directAngle;
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
