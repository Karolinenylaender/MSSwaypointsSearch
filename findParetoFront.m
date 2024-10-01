%% calculate the peatro front

ship = "npsauv";
%ship = "mariner"
ship = "remus100";

%searchProcess = "randomSearch";
searchProcess = "minDistanceMaxPath";


startExperiment = 4;
maxExperiments = 4 %startExperiment+30;
populationSize = 10; 
numGenerations = 1000;

%function [experimentPerformance, totalObjectives] = calculate(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    numMetrics = 10;
    experimentPerformance = [];
    totalObjectives = [];
    
    for generation = 1:numGenerations
        [Population, paths] = loadResults(ship, searchProcess, experimentNumber, populationSize, generation);
    
        Obj = Population.objs;
        
        %Obj(:,1) = -Obj(:,1);
        totalObjectives = [totalObjectives; Obj];
        %[Population,FrontNo,CrowdDis] = EnvironmentalSelection(Population,populationSize);
        % Perform non-dominated sorting
        
    end
    totalObjectives = totalObjectives(totalObjectives < 1000);
    [FrontNo, MaxFront] = NDSort(totalObjectives, length(totalObjectives));

    % Extract the solutions in the first Pareto front
    paretoFront = totalObjectives(FrontNo == 1, :);
    figure(experimentNumber)
    % Plot the Pareto front for two objectives
    plot(paretoFront(:, 1), paretoFront(:, 2), 'ro');
    xlabel('Objective 1');
    ylabel('Objective 2');
    title('Pareto Front');
    grid on;
%end


