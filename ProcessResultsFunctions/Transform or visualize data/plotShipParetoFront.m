%% plot pareto fronts

close all
clear all

ship = "remus100";
ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;
searchProcess = "minDistanceMaxPath";


if ship == "nspauv"
    SearchValidExperiments = 1:24; 
    RandomValidExperiments = [1:18 25:30]; 

else
    SearchValidExperiments = 1:30; 
    RandomValidExperiments = 1:30;
end

PopulationNSGASearch = loadAllShipPopulations(ship, "minDistanceMaxPath",SearchValidExperiments, populationSize, numGenerations);
PopulationRandomSearch = loadAllShipPopulations(ship, "randomSearch",RandomValidExperiments, populationSize, numGenerations);
NSGAObjectives = PopulationNSGASearch.objs;
randomObjectives = PopulationRandomSearch.objs;
combinedObjectives = [NSGAObjectives; randomObjectives];


maxObjectives = [max(combinedObjectives(:,1)), max(combinedObjectives(:,2))];
minObjectives = [min(combinedObjectives(:,1)), min(combinedObjectives(:,2))];


referencePoint = [-minObjectives(1) maxObjectives(2)];
thresholdObjective1 = minObjectives(1);

NSGAParetoFront = PopulationNSGASearch.best.objs;
NSGAParetoFront(:,1) = NSGAParetoFront(:,1) -ones(length(NSGAParetoFront),1)*thresholdObjective1;
NSGAParetoFront = NSGAParetoFront*diag(1./referencePoint);
RandomParetoFront = PopulationRandomSearch.best.objs;
RandomParetoFront(:,1) = RandomParetoFront(:,1) -ones(length(RandomParetoFront),1)*thresholdObjective1;
RandomParetoFront = RandomParetoFront*diag(1./referencePoint);


figure(1)
plot(NSGAParetoFront(:,1), NSGAParetoFront(:,2), 'bo')
hold on
plot(RandomParetoFront(:,1), RandomParetoFront(:,2), 'ro')
legend("NSGA search", "random search")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 sum of path lenths")

figure(2)
plot(NSGAObjectives(:,1), NSGAObjectives(:,2),'bo')
hold on
plot(randomObjectives(:,1), randomObjectives(:,2),'ro')
legend("NSGA search", "random search")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 sum of path lenths")

RandomPF = [];
NSGAPF = [];
for experimentNumber = SearchValidExperiments
    experimentPopulation = loadExperimentsPopulations(ship, "minDistanceMaxPath",experimentNumber, populationSize, numGenerations);
    NSGAPF = [NSGAPF; experimentPopulation.best.objs];
end
for experimentNumber = RandomValidExperiments
    experimentPopulation = loadExperimentsPopulations(ship, "randomSearch",experimentNumber, populationSize, numGenerations);
    RandomPF = [RandomPF; experimentPopulation.best.objs];
end

NSGAPF(:,1) = NSGAPF(:,1) -ones(length(NSGAPF),1)*thresholdObjective1;
NSGAPF = NSGAPF*diag(1./referencePoint);
RandomPF(:,1) = RandomPF(:,1) -ones(length(RandomPF),1)*thresholdObjective1;
RandomPF = RandomPF*diag(1./referencePoint);

figure(3)
plot(NSGAPF(:,1), NSGAPF(:,2), 'bo')
hold on
plot(RandomPF(:,1), RandomPF(:,2), 'ro')
legend("NSGA search", "random search")
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 sum of path lenths")

plotNumber = 4;
for experimentNumber = SearchValidExperiments
    figure(plotNumber)
    
    plot(NSGAPF(:,1), NSGAPF(:,2), 'bo')
    hold on
    plot(RandomPF(:,1), RandomPF(:,2), 'ro')
    hold on

    experimentPopulation = loadExperimentsPopulations(ship, "minDistanceMaxPath",experimentNumber, populationSize, numGenerations);
    experimentPF = experimentPopulation.best.objs;
    experimentPF(:,1) = experimentPF(:,1) -ones(length(experimentPF),1)*thresholdObjective1;
    experimentPF = experimentPF*diag(1./referencePoint);

    HVscore = hypervolume(experimentPF, [1 1], 10000)

    plot(experimentPF(:,1),experimentPF(:,2), 'k*','MarkerSize',10)

    legendtext = strcat("pareto front epxeriment num. ", num2str(experimentNumber))
    legend("other NSGA search PF", "random search PF",legendtext)
    ylabel(" [Minmimize] objective 2 distance between points")
    xlabel(" [Maximize of the negative] objecitve 1 sum of path lenths")
    titleText = strcat("pareto front for NSGA-ii experient ", num2str(experimentNumber), " and HV score: ", num2str(HVscore))
    title(titleText)
    plotNumber = plotNumber + 1;

end
for experimentNumber = RandomValidExperiments
    figure(plotNumber)
    plot(NSGAPF(:,1), NSGAPF(:,2), 'bo')
    hold on
    plot(RandomPF(:,1), RandomPF(:,2), 'ro')
    hold on

    experimentPopulation = loadExperimentsPopulations(ship, "randomSearch",experimentNumber, populationSize, numGenerations);
    experimentPF = experimentPopulation.best.objs;
    experimentPF(:,1) = experimentPF(:,1) -ones(length(experimentPF),1)*thresholdObjective1;
    experimentPF = experimentPF*diag(1./referencePoint);

    plot(experimentPF(:,1),experimentPF(:,2), 'k*','MarkerSize',10)
    HVscore = hypervolume(experimentPF, [1 1], 10000)

    
    legendtext = strcat("pareto front epxeriment num. ", num2str(experimentNumber))

    legend("other NSGA search PF", "random search PF",legendtext)
    ylabel(" [Minmimize] objective 2 distance between points")
    xlabel(" [Maximize of the negative] objecitve 1 sum of path lenths")
    titleText = strcat("pareto front for NSGA-ii experient ", num2str(experimentNumber), " and HV score: ", num2str(HVscore))
    title(titleText)
    plotNumber = plotNumber + 1;

end


%% TODOs 
% combine the pareto fronts in the plot
% plot nsgaii vs full random pareto


function HVscores = calculateSearchHV(ship, searchProcess,validExperiments, populationSize, numGenerations,maxValues, minValues)
    HVscores = [];
    %referencePoint = maxValues;
    referencePoint = [-minValues(1) maxValues(2)];
    optimalPoint = [-maxValues(1) minValues(2)];
    thresholdObjective1 = minValues(1);
    for experimentNumber = validExperiments
        experimentPopulation = loadExperimentsPopulations(ship, searchProcess,experimentNumber, populationSize, numGenerations);

        experimentObjectives = experimentPopulation.objs;
        experimentObjectives(:,1) = experimentObjectives(:,1) -ones(length(experimentObjectives),1)*thresholdObjective1;
        experimentPopulation = SOLUTION(experimentPopulation.decs, experimentObjectives, experimentPopulation.cons);

    end
end
