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
    startExperiment = 402;
    maxExperiments = 421;
    populationSize = 1000;
    numGenerations = 1;
else
    startExperiment = 400;
    maxExperiments = 424;
    populationSize = 100; 
    numGenerations = 10;
end

basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/";


for experimentNumber = startExperiment:maxExperiments
    resultsPath = append(basepath,ship,"/", "processedResults/",searchProcess ,string(experimentNumber))
    load(resultsPath)
    experimentsResultsMap = experimentsResults(string(experimentNumber))
    for generation = 3:3 %1:numGenerations
        generationPath = append(basepath,ship, "/", searchProcess,"-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation));
        load(generationPath)
        generationResults = experimentsResultsMap(string(generation))
        if size(generationResults,2) == 3
           
            if generation == 1
                intialPath = paths('0');
                decs = Population.decs;
                intialPoints = decs(1,:);
                Dec = decs(1:end,:);
                %[initalPointsMatrix,wpt] = transformListOfPointToMatrix(intialPoints, ship);
                %[intialDistanceBetweenWaypoints, intialSubpathDistances, intialNumMissingWaypoints] = calculatePathScores(intialPath, initalPointsMatrix, intialPath, initalPointsMatrix, R_switch);
            
            else
                Dec = Population.decs;
            end
            generationResults
            for individualIndex = 1:size(Dec,1)
                individual = Dec(individualIndex,:);
                individualPath = paths(string(individualIndex));
                [pointsMatrix,wpt] = transformListOfPointToMatrix(individual, ship)
                pathPerformance = evaluatePath(individualPath, pointsMatrix, R_switch);
                pathPerformance
                % TODO save this to the path elns
            end
        end

    end
end


function pathPerformance = evaluatePath(fullPath, pointsMatrix, R_switch)
    [transitionIndices, pathSegments] = splitDataBetweenWaypoints(pointsMatrix, R_switch,fullPath);
    curlinesResultsList = [];
    anglesResultsList = [];
    for pathSectionIndex = 1:length(pathSegments)
        currentPath = pathSegments{pathSectionIndex};
        curlinesResultsList= [curlinesResultsList; calculateTheCurlinessOfThePath(currentPath)];
        anglesResultsList = [anglesResultsList; calucalteTheCurlinesAngles(currentPath, pointsMatrix)];
        
    end
    pathPerformance = [curlinesResultsList anglesResultsList];

end

function angleResults  = calucalteTheCurlinesAngles(fullPath, pointsMatrix)
    xpath = fullPath(:,1);
    ypath = fullPath(:,2);
    n = length(xpath);
    % Calculate the differences
    dx = gradient(xpath); 
    dy = gradient(ypath);
    ddx = gradient(dx); 
    ddy = gradient(dy);


    angles = atan2(dy,dx);
    dAngles = gradient(angles);
    dAngles = mod(dAngles +pi, 2*pi) - pi;

    maxangles = max(dAngles);
    angles_dev = std(dAngles)
    
    angleResults = [maxangles angles_dev]
    if size(fullPath,2) == 3
        zpath = fullPath(:,3);
        dz = gradient(zpath);
        ddz = gradient(dz);
        
        polarAngles = atan2(sqrt(dx.^2 + dy.^2), dz); 
        dpolarAngles = gradient(polarAngles);
        dpolarAngles = mod(dpolarAngles +pi, 2*pi) - pi;
        
        maxpolar = max(dpolarAngles);
        polar_dev = std(dpolarAngles);

        angleResults = [maxpolar polar_dev]
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
        wpt.pos.x = [0 Listpoints(1:numPoints)]';
        wpt.pos.y = [0 Listpoints((numPoints+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y];
    else 
        numPoints = length(Listpoints)/3;
        wpt.pos.x = [0 Listpoints(1:numPoints)]';
        wpt.pos.y = [0 Listpoints((numPoints+1):(numPoints*2))]';
        wpt.pos.z = [0 Listpoints((numPoints*2+1):end)]';
        pointsMatrix = [wpt.pos.x wpt.pos.y wpt.pos.z];
    end
end