function [experimentPerformance, totalObjectives] = CalculateFeaturesExperiment(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    numMetrics = 4;
    experimentPerformance = [];
    totalObjectives = [];
    
    for generation = 1:numGenerations
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
        % if generation == 1
        %     intialPath = paths('0');
        %     decs = Population.decs;
        %     intialPoints = decs(1,:);
        % 
        %     fullPath = intialPath('fullpath');
        %     transitionIndices = intialPath('transitionIndices');
        %     angles = intialPath('angles');
        % 
        %     initialPoints  =  reshape(intialPoints, [3, 6])';
        %     initalPathPerformance = evaluatePath(fullPath, transitionIndices, angles);
        % 
        % end
        Obj = Population.objs; 
        totalObjectives = [totalObjectives; Obj];
        Dec = Population.decs;

        generationPerformance = [];
        for individualIndex = 1:size(Dec,1)
            individual = Dec(individualIndex,:);
            individualPath = paths(string(individualIndex));
            fullPath = individualPath('fullpath');
            transitionIndices = individualPath('transitionIndices');
            angles = individualPath('angles');

            pointsMatrix  =  reshape(individual, [3, 6])';

            pathPerformance = evaluatePath(fullPath, transitionIndices, angles);
            if transitionIndices(1) == length(fullPath)
                plotShipPath(fullPath,pointsMatrix,5)
                numMissingPaths = length(pointsMatrix);
                  
                pathPerformance = -ones(numMissingPaths, numMetrics);

            elseif length(transitionIndices) < (length(pointsMatrix))
                numMissingPaths = length(pointsMatrix) - length(transitionIndices);

                % newPointsMatrix = fullPath(transitionIndices,:);
                % 
                % plot3(fullPath(:,2),fullPath(:,1), fullPath(:,3));
                % hold on
                % %plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', 5);
                % %hold on
                % plot3(newPointsMatrix(:,2), newPointsMatrix(:,1), newPointsMatrix(:,3), 'ro', 'MarkerSize', 5);
                % %hold on
                % %plot3(endPoint(:,2), endPoint(:,1), endPoint(:,3), 'bo', 'MarkerSize', 5);
                % set(gca, 'ZDir', 'reverse');
                % xlabel("y axis")
                % ylabel("x axis")
                % zlabel("z axis")
                % title("fullpath")
                % grid

                %plotShipPath(fullPath,newPointsMatrix,5)

                missingPathPerformance = -ones(numMissingPaths, numMetrics);
                pathPerformance = [pathPerformance; missingPathPerformance];
            else
                pathPerformance = pathPerformance; 
                % if any(pathPerformance(2:end,2:end) > 10)
                %     newPointsMatrix = fullPath(transitionIndices,:);
                % 
                %     figure
                %     plot3(fullPath(:,2),fullPath(:,1), fullPath(:,3));
                %     hold on
                %     %plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', 5);
                %     %hold on
                %     plot3(newPointsMatrix(:,2), newPointsMatrix(:,1), newPointsMatrix(:,3), 'ro', 'MarkerSize', 5);
                %     %hold on
                %     %plot3(endPoint(:,2), endPoint(:,1), endPoint(:,3), 'bo', 'MarkerSize', 5);
                %     set(gca, 'ZDir', 'reverse');
                %     xlabel("y axis")
                %     ylabel("x axis")
                %     zlabel("z axis")
                %     title("fullpath")
                %     grid
                % 
                %     pathPerformance
                % 
                % end
                
                % if any(pathPerformance(:,1)>13) && (any(pathPerformance(:,2) > 0.01) || any(pathPerformance(2:end,3) > 0.1) || any(pathPerformance(2:end,4) > 0.02)) 
                %     % max and std curvature
                %     pathPerformance
                %     pathPerformance(:,1:4)
                %     plotShipPath(fullPath,pointsMatrix,5)
                %     pathPerformance;
                % end
                % 
                % if any(pathPerformance(:,1)>10)
                %     % length of path
                %     pathPerformance
                %     pathPerformance(:,1)
                %     plotShipPath(fullPath,pointsMatrix,5)
                %     pathPerformance;
                % end
                % if any(pathPerformance(:,2) > 0.01) || any(pathPerformance(2:end,3) > 0.1) || any(pathPerformance(2:end,4) > 0.02) 
                %     % max and std curvature
                %     pathPerformance
                %     pathPerformance(:,2:4)
                %     plotShipPath(fullPath,pointsMatrix,5)
                %     pathPerformance;
                % end
                % 
                % if any(pathPerformance(:,5) > pi/2) ||  any(pathPerformance(:,6) > 0.01)  
                %     pathPerformance
                %     pathPerformance(:,5:6)
                %     plotShipPath(fullPath,pointsMatrix,5)
                %     pathPerformance;
                %     % angle xy max
                % 
                %     % angle xy std 
                % 
                % end   
                % if any(pathPerformance(:,7) > pi/2) || any(pathPerformance(:,8) > 0.01) 
                %     pathPerformance
                %     pathPerformance(:,7:8)
                %     plotShipPath(fullPath,pointsMatrix,5)
                %     pathPerformance;
                %     % angle xz std 
                %      % angle xz max
                % end
                % if any(pathPerformance(:,9) > pi/2) || any(pathPerformance(:,10) > 0.01)  
                %     pathPerformance
                %     pathPerformance(:,9:10)
                %     plotShipPath(fullPath,pointsMatrix,5)
                %     pathPerformance;
                %     % angle yz max
                % 
                %     % angle yz std     
                % 
                % end

            end
            generationPerformance = [generationPerformance; pathPerformance];
        end

        experimentPerformance =[experimentPerformance; generationPerformance];

    end
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber));
    save(resultsPath, "experimentPerformance", "totalObjectives")
end



function pathPerformance = evaluatePath(fullPath,transitionIndices, angles)
    curlinesResultsList = [];
    anglesResultsList = [];
    pathLengths = [];
    transitionIndices = [1; transitionIndices];
    
    xpoints = fullPath(transitionIndices,1);
    ypoints = fullPath(transitionIndices,2);
    zpoints = fullPath(transitionIndices,3);

    
    
    for pathSectionIndex = 1:length(transitionIndices)-1
        currentPath = fullPath(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        currentAngles = angles(transitionIndices(pathSectionIndex):transitionIndices(pathSectionIndex+1),:);
        startPoint = fullPath(transitionIndices(pathSectionIndex),:);
        endPoint = fullPath(transitionIndices(pathSectionIndex+1),:);

        %curlinesResultsList= [curlinesResultsList; calculateCurvatureOfSubpath(currentPath)];
        %anglesResultsList = [anglesResultsList; calculateAnglesOfSubpaths(currentPath)];
        
        anglesResultsList = [anglesResultsList; extractFeaturesFromAngles(currentAngles(:,1:3))];
        % feat = reshape(anglesResultsList(end,:), [3,3])'
        % freqs = feat(:,1);
        % periods = feat(:,2);
        % zerosCrossing = feat(:,3);
        periods = anglesResultsList(end,:);
        

        pathLengths = [pathLengths; length(currentPath)/pdist2(startPoint,endPoint)];
         
        if pathLengths(pathSectionIndex) > 15 || (all(periods(:) > 3) ) %|| all(zerosCrossing > 10)


            % pathLengths(pathSectionIndex);
            % all(periods(:) > 3) ;
            % %all(zerosCrossing > 10);
            % 
            % close all
            % figureNumer = 1;
            % %feat = reshape(anglesResultsList(end,:), [3,3])';
            % plotAngles(currentPath,currentAngles, figureNumer, "waypoint subpath")
            % plotAngles(fullPath,angles, figureNumer+2, "fullpath")
            % 
            figure(5)
            subplot(2,1,1)
            plot3(currentPath(:,2),currentPath(:,1), currentPath(:,3));
            hold on
            plot3(startPoint(:,2), startPoint(:,1), startPoint(:,3), 'go', 'MarkerSize', 5);
            hold on
            plot3(endPoint(:,2), endPoint(:,1), endPoint(:,3), 'bo', 'MarkerSize', 5);
            set(gca, 'ZDir', 'reverse');
            xlabel("y axis")
            ylabel("x axis")
            zlabel("z axis")
            title("waypoint subpath")
            grid 
            subplot(2,1,2)
            plot3(fullPath(:,2),fullPath(:,1), fullPath(:,3));
            hold on
            plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', 5);
            hold on
            plot3(startPoint(:,2), startPoint(:,1), startPoint(:,3), 'go', 'MarkerSize', 5);
            hold on
            plot3(endPoint(:,2), endPoint(:,1), endPoint(:,3), 'bo', 'MarkerSize', 5);
            set(gca, 'ZDir', 'reverse');
            xlabel("y axis")
            ylabel("x axis")
            zlabel("z axis")
            title("fullpath")
            grid
            % 
            % 
            % signalNames = ["phi", "theta", "psi", "u", "v", "w", "p", "q", "r"];
            % for angIndex = 1:9 %9
            %      currentMetric  = currentAngles(:,angIndex);
            %       extractFeatures(currentMetric, signalNames(angIndex), 5+angIndex);
            % end
            %feat = reshape(anglesResultsList(end,:), [3,3])';
            %plotAngles(currentPath,normalize(currentAngles), figureNumer+4, "normalized waypoint subpath" )
            %plotAngles(fullPath,normalize(angles), figureNumer+6, "normalized fullpath")


            % xdot = gradient(fullPath(:,1));
            % ydot = gradient(fullPath(:,2));
            % zdot = gradient(fullPath(:,3));
            % tdot = 1:length(xdot);
            % x = fullPath(:,1);
            % y = fullPath(:,2);
            % z = fullPath(:,3);
            % u = angles(:,4);
            % v = angles(:,5);
            % w = angles(:,6);
            % t = 1:length(x);



            % figure(5)
            % subplot(611),plot(t,x)
            % xlabel('Time (s)'),title('North position (m)'),grid
            % subplot(612),plot(t,y)
            % xlabel('Time (s)'),title('East position (m) '),grid
            % subplot(613),plot(t,z)
            % xlabel('Time (s)'),title(' Downwards position (m)'),grid
            % subplot(614),plot(t,u, tdot, xdot)
            % legend(["measurement", "gradient"])
            % xlabel('Time (s)'),title('Surge velocity (m/s)'),grid
            % subplot(615),plot(t,v, tdot, ydot)
            % legend(["measurement", "gradient"])
            % xlabel('Time (s)'),title('Sway velocity (m/s)'),grid
            % subplot(616),plot(t,w)
            % hold on
            % plot(tdot, zdot)
            % legend(["measurement", "gradient"])
            % xlabel('Time (s)'),title('Heave velocity (m/s)'),grid
            % set(findall(gcf,'type','line'),'linewidth',2)
            % set(findall(gcf,'type','text'),'FontSize',14)
            % sgtitle("fullpath: measurement vs calculated gradient")
            % 
            % xdot = gradient(currentPath(:,1));
            % ydot = gradient(currentPath(:,2));
            % zdot = gradient(currentPath(:,3));
            % tdot = 1:length(xdot);
            % x = currentPath(:,1);
            % y = currentPath(:,2);
            % z = currentPath(:,3);
            % u = currentAngles(:,4);
            % v = currentAngles(:,5);
            % w = currentAngles(:,6);
            % t = 1:length(x();
            % 
            % figure(6)
            % subplot(611),plot(t,x)
            % xlabel('Time (s)'),title('North position (m)'),grid
            % subplot(612),plot(t,y)
            % xlabel('Time (s)'),title('East position (m) '),grid
            % subplot(613),plot(t,z)
            % xlabel('Time (s)'),title(' Downwards position (m)'),grid
            % subplot(614),plot(t,u, tdot, xdot)
            % legend(["measurement", "gradient"])
            % xlabel('Time (s)'),title('Surge velocity (m/s)'),grid
            % subplot(615),plot(t,v, tdot, ydot)
            % legend(["measurement", "gradient"])
            % xlabel('Time (s)'),title('Sway velocity (m/s)'),grid
            % subplot(616),plot(t,w, tdot, zdot)
            % legend(["measurement", "gradient"])
            % xlabel('Time (s)'),title('Heave velocity (m/s)'),grid
            % sgtitle("waypoints subpath: measurement vs calculated gradient")




        end
        
    end
    %pathPerformance = [pathLengths curlinesResultsList anglesResultsList];
    pathPerformance = [pathLengths anglesResultsList];

end