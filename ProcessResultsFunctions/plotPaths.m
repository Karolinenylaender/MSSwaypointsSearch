%% plot the specfic paths
close all
clear all


individualNumber = 1; %
experimentNumber = 29;
generation = 2;

%ship = "mariner"
%ship = "nspauv";
ship = "remus100";

%searchProcess = "RndSearch";
%searchProcess = "WPgenSeed";
searchProcess = "WPgenComb"
%searchProcess = "WPgenRnd";


%plotSpecificPath(experimentNumber, ship, searchProcess, 10, 9, 'b') % straight
%plotSpecificPath(experimentNumber, ship, searchProcess, 89, 4, 'b') % straight
%plotSpecificPath(experimentNumber, ship, searchProcess, 778, 4, 'b') % straight

%plotSpecificPath(experimentNumber, ship, searchProcess, 445, 4, 'b') % straight

randomGeneration = randi(1000, 1,4)
randomIndividual = randi(10, 1,4)

%[straightPath,straightAngles, straightWpt] = extractPathAndWaypoints(23, ship, searchProcess, randomGeneration(1), randomIndividual(1));
%[semiCurlyPath,semiCurlyAngles, semiCurlyWpt] = extractPathAndWaypoints(23, ship, searchProcess, randomGeneration(2), randomIndividual(2));
%[curlyPath,curlyAngles, curlyWpt] = extractPathAndWaypoints(23, ship, searchProcess, randomGeneration(3), randomIndividual(3));
%[missingPath,missingAngles, missingWpt] = extractPathAndWaypoints(23, ship, searchProcess, 987, 9); % randomGeneration(4), randomIndividual(4));
%missingPath = missingPath(1:size(missingPath,1)/3,:)

[straightPath,straightAngles, straightWpt] = extractPathAndWaypoints(23, ship, searchProcess, 1, 7)
[semiCurlyPath,semiCurlyAngles, semiCurlyWpt] = extractPathAndWaypoints(23, ship, searchProcess, 987,9)
[curlyPath,curlyAngles, curlyWpt] = extractPathAndWaypoints(29, ship, searchProcess, 777, 4)
[missingPath,missingAngles, missingWpt] = extractPathAndWaypoints(23, ship, searchProcess, 1, 6)
missingPath = missingPath(1:size(missingPath,1)/3,:)

straightWpt = [0 0 0; straightWpt];
semiCurlyWpt = [0 0 0; semiCurlyWpt];
curlyWpt = [0 0 0; curlyWpt];
missingWpt = [0 0 0; missingWpt];

R_switch = 5;
% 
% plot3(straightPath(:,2), straightPath(:,1), straightPath(:,3), 'LineWidth',2.0, 'color','b');
% hold on
% plot3( straightWpt(:,2), straightWpt(:,1), straightWpt(:,3), 'bo', 'MarkerSize', R_switch*2);
% hold on
% plot3(curlyPath(:,2), curlyPath(:,1), curlyPath(:,3), 'LineWidth',2.0, 'color','r');
% hold on
% plot3( curlyWpt(:,2), curlyWpt(:,1), curlyWpt(:,3), 'ro', 'MarkerSize', R_switch*2);
% hold on
% plot3(semiCurlyPath(:,2), semiCurlyPath(:,1), semiCurlyPath(:,3), 'LineWidth',2.0, 'color','y');
% hold on
% plot3( semiCurlyWpt(:,2), semiCurlyWpt(:,1), semiCurlyWpt(:,3), 'yo', 'MarkerSize', R_switch*2);
% hold on
% plot3(missingPath(:,2), missingPath(:,1), missingPath(:,3), 'LineWidth',2.0, 'color','g');
% hold on
% plot3( missingWpt(:,2), missingWpt(:,1), missingWpt(:,3), 'go', 'MarkerSize', R_switch*2);
% grid on;
% set(gca, 'ZDir', 'reverse');

% plotShipPath(straightPath, straightWpt, R_switch)
% hold on
% plotShipPath(semiCurlyPath, semiCurlyWpt, R_switch)
% hold on
% plotShipPath(curlyPath, curlyWpt, R_switch)
% hold on
% plotShipPath(missingPath, missingWpt, R_switch)
% hold on



% subplot(3,1,1)
% plot(straightPath(:,1))
% hold on
% plot(curlyPath(:,1))
% hold on
% plot(semiCurlyPath(:,1))
% hold on
% plot(missingPath(:,1))
% 
% subplot(3,1,2)
% plot(straightPath(:,2))
% hold on
% plot(curlyPath(:,2))
% hold on
% plot(semiCurlyPath(:,2))
% hold on
% plot(missingPath(:,2))
% 
% subplot(3,1,3)
% plot(straightPath(:,3))
% hold on
% plot(curlyPath(:,3))
% hold on
% plot(semiCurlyPath(:,3))
% hold on
% plot(missingPath(:,3))

%subplot(2,2,1)
figure(1)
plot3(straightPath(:,2), straightPath(:,1), straightPath(:,3), 'LineWidth',2.0, 'color','b');
hold on
plot3( straightWpt(:,2), straightWpt(:,1), straightWpt(:,3), 'ro', 'MarkerSize', R_switch*2);
grid on;
set(gca, 'ZDir', 'reverse');
xlabel("East") % y axis
ylabel("North") % x axis
zlabel("Downward from sea level") % z axis
%title("Example of stable path")
ax = gca; % Get current axes
ax.FontSize = 16;

%subplot(2,2,2)
figure(2)
plot3(curlyPath(:,2), curlyPath(:,1), curlyPath(:,3), 'LineWidth',2.0, 'color','b');
hold on
plot3( curlyWpt(:,2), curlyWpt(:,1), curlyWpt(:,3), 'ro', 'MarkerSize', R_switch*2.5);
grid on;
set(gca, 'ZDir', 'reverse');
xlabel("East") % y axis
ylabel("North") % x axis
zlabel("Downward from sea level") % z axis
hold on
%title("Example of unstable path")
ax = gca; % Get current axes
ax.FontSize = 16;

%subplot(2,2,3)
%figure(3)
%plot3(semiCurlyPath(:,2), semiCurlyPath(:,1), semiCurlyPath(:,3), 'LineWidth',2.0, 'color','b');
%hold on
%plot3( semiCurlyWpt(:,2), semiCurlyWpt(:,1), semiCurlyWpt(:,3), 'ro', 'MarkerSize', R_switch*2.5);
%grid on;
%set(gca, 'ZDir', 'reverse');
%xlabel("East") % y axis
%ylabel("North") % x axis
%zlabel("Downward from sea level") % z axis
%hold on
%title("Example of semi-unstable path")
%ax = gca; % Get current axes
%ax.FontSize = 16;

%subplot(2,2,4)
figure(4)
plot3(missingPath(:,2), missingPath(:,1), missingPath(:,3), 'LineWidth',2.0, 'color','b');
hold on
plot3( missingWpt(:,2), missingWpt(:,1), missingWpt(:,3), 'ro', 'MarkerSize', R_switch*2.5);
grid on;
set(gca, 'ZDir', 'reverse');
xlabel("East") % y axis
ylabel("North") % x axis
zlabel("Downward from sea level") % z axis
%title("Example of missing path")
ax = gca; % Get current axes
ax.FontSize = 18;


%legend("path", "waypoints")

% xlabel("East") % y axis
% ylabel("North") % x axis
% zlabel("Downward from sea level") % z axis
% hold on
%legend({"straight path", "straight WP", "semi-curly path", "semi-curly WP", "curly path ", "curly WP", "unstable/ missing path", "unstable/ missing WP"}, 'Location','northwest','NumColumns',2)

figure(5)
plot(straightPath(:,2), straightPath(:,1), 'LineWidth',2.0, 'color','b');
hold on
plot(straightWpt(:,2), straightWpt(:,1), 'ro', 'MarkerSize', R_switch*2.5);
grid
xlabel("East") % y axis
ylabel("North") % x axis
ax = gca; % Get current axes
ax.FontSize = 18;

figure(6)
plot(curlyPath(:,2), curlyPath(:,1), 'LineWidth',2.0, 'color','b');
hold on
plot(curlyWpt(:,2), curlyWpt(:,1), 'ro', 'MarkerSize', R_switch*2.5);
grid
xlabel("East") % y axis
ylabel("North") % x axis
ax = gca; % Get current axes
ax.FontSize = 18;

figure(7)
plot(missingPath(:,2), missingPath(:,1), 'LineWidth',2.0, 'color','b');
hold on
plot(missingWpt(:,2), missingWpt(:,1), 'ro', 'MarkerSize', R_switch*2.5);
grid
xlabel("East") % y axis
ylabel("North") % x axis
ax = gca; % Get current axes
ax.FontSize = 18;

function plotSpecificPath(experimentNumber, ship, searchProcess, generation, individualNumber, pathColor)
    populationSize = 10; 
    maxGenerations = 1000;
    %for generation =  1:maxGenerations
    if searchProcess == "minDistanceMaxPath"
        experimentFolderName = append("ex", string(experimentNumber),"/");
    elseif searchProcess == "randomSearch"
        experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "HalfHalfMutation"
        experimentFolderName = append("half-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "randInitPop"
        experimentFolderName = append("randInit-ex", string(experimentNumber),"/"); 
    end

    
    
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);
    shipInformation = loadShipSearchParameters(ship);
    R_switch = shipInformation.R_switch;
    
    
    resultsPath = append(resultsFolder, "/", ship,"/",experimentFolderName, searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
    
        load(resultsPath,"Population", "paths");
        %for individualNumber = 1:10
            figureNum = individualNumber
            %figure(figureNum)
        
            decs = Population.decs
            waypointsList = decs(individualNumber,:)
            numPoints = length(waypointsList)/shipInformation.pointDimension;
            pointsMatrix  =  [zeros(1,shipInformation.pointDimension); reshape(waypointsList, [shipInformation.pointDimension, numPoints])']
            pathsMap = paths(string(individualNumber));
            string(individualNumber)
            anglesPath = pathsMap('angles');
            fullPath = pathsMap('fullpath');
            transitionIndices = pathsMap('transitionIndices')
            pointsMatrix = fullPath(transitionIndices,:)
            
            %plotShipPath(fullPath, pointsMatrix, R_switch)
    
            xpath = fullPath(:,1);
            ypath = fullPath(:,2);
            zpath = fullPath(:,3);
            xpoints = pointsMatrix(:,1);
            ypoints = pointsMatrix(:,2);
            zpoints = pointsMatrix(:,3);
    
            if length(pointsMatrix) == 6
                h = plot3(ypath, xpath, zpath) %, 'LineWidth',2.0, 'color',pathColor);

            end
            hold on
            %plot3(ypoints, xpoints, zpoints, append(pathColor,'o'), 'MarkerSize', R_switch*2);
            %hold off;
            grid on;
            set(gca, 'ZDir', 'reverse');
    
            xlabel("East") % y axis
            ylabel("North") % x axis
            zlabel("Downward from sea level") % z axis
            hold on
            %view(-25, 30)
       %end
%end
end

function [fullPath,anglesPath, pointsMatrix] = extractPathAndWaypoints(experimentNumber, ship, searchProcess, generation, individualNumber)
    populationSize = 10; 
    
    if searchProcess == "WPgenSeed"
        experimentFolderName = append("WPgenSeed-ex", string(experimentNumber),"/");
    elseif searchProcess == "RndSearch"
        experimentFolderName = append("RndSearch-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "WPgenComb"
        experimentFolderName = append("WPGenComb-ex", string(experimentNumber),"/"); 
    elseif searchProcess == "WPgenRnd"
        experimentFolderName = append("WPgenRnd-ex", string(experimentNumber),"/"); 
    end
    
    
    resultsPathInfo = what("ExperimentsResults");
    resultsFolder = char(resultsPathInfo.path);
    shipInformation = loadShipSearchParameters(ship);
    R_switch = shipInformation.R_switch;
    
    
    resultsPath = append(resultsFolder, "/", ship,"/",experimentFolderName, searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation))
    load(resultsPath,"Population", "paths");

    decs = Population.decs;
    waypointsList = decs(individualNumber,:);
    numPoints = length(waypointsList)/shipInformation.pointDimension;
    pointsMatrix  =   reshape(waypointsList, [shipInformation.pointDimension, numPoints])';
    pathsMap = paths(string(individualNumber));
    string(individualNumber);
    anglesPath = pathsMap('angles');
    fullPath = pathsMap('fullpath');
    transitionIndices = pathsMap('transitionIndices');

    if length(transitionIndices) == length(pointsMatrix)
        pointsMatrix = fullPath(transitionIndices,:);
    end
end


function plotShipPathOverTime(fullPath, pointsMatrix, R_switch)
    if nargin < 2
        R_switch = 5;
    end
    %close all;
    if size(fullPath,2) == 2
        xpath = fullPath(:,1);
        ypath = fullPath(:,2);

        xpoints = pointsMatrix(:,1);
        ypoints = pointsMatrix(:,2);

        figure
        plot(ypath,xpath)
        hold on;
        plot(ypoints, xpoints, 'rx', 'MarkerSize', 15);
        hold off;
        grid on;
        xlabel("y axis")
        ylabel("x axis")
    else
        xpath = fullPath(:,1);
        ypath = fullPath(:,2);
        zpath = fullPath(:,3);
        xpoints = pointsMatrix(:,1);
        ypoints = pointsMatrix(:,2);
        zpoints = pointsMatrix(:,3);

        subplot(3,1,1)
        plot(ypath,xpath)
        hold on
        plot(ypoints, xpoints, 'rx', 'MarkerSize', 15);
        hold off
        xlabel("y axis")
        ylabel("x axis")
        grid on

        subplot(3,1,2)
        plot(ypath,zpath)
        hold on;
        plot(ypoints, zpoints, 'rx', 'MarkerSize', 15);
        hold off;
        xlabel("y axis")
        ylabel("z axis")
        grid on

        subplot(3,1,3)
        plot3(ypath, xpath, zpath)
        hold on
        plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', R_switch);
        hold off;
        grid on;
        set(gca, 'ZDir', 'reverse');
        xlabel("y axis")
        ylabel("x axis")
        zlabel("z axis")
        view(-25, 30)
    end
end
