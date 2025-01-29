%% plot distribution of data

close all
clear all

ship = "mariner";
ship = "remus100";
ship = "nspauv";
populationSize = 10; 
numGenerations = 1000;


if ship == "mariner"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30; 
    randomNSGAValidExperiments = 1:30; 
elseif ship == "nspauv"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30;
elseif ship == "remus100"
    randomSearchValidExperiments = 1:30;
    seedNSGAValidExperiments = 1:30;
    mixedNSGAValidExperiments = 1:30;
    randomNSGAValidExperiments = 1:30;
end

randomSearchPopulation = loadAllShipPopulations(ship, "randomSearch",randomSearchValidExperiments, populationSize, numGenerations);
seedNSGAPopulation = loadAllShipPopulations(ship, "minDistanceMaxPath",seedNSGAValidExperiments, populationSize, numGenerations);
mixedNSGAPopulation = loadAllShipPopulations(ship, "HalfHalfMutation",mixedNSGAValidExperiments, populationSize, numGenerations); 
randomNSGAPopulation =  loadAllShipPopulations(ship, "randInitPop",randomNSGAValidExperiments, populationSize, numGenerations); 
 
randomSearchObjectives = randomSearchPopulation.objs;
seedNSGAObjectives = seedNSGAPopulation.objs;
mixedNSGAObjecitves = mixedNSGAPopulation.objs;
randomNSGAObjectives = randomNSGAPopulation.objs;

distribution = [max(randomSearchObjectives) max(seedNSGAObjectives) max(mixedNSGAObjecitves) max(randomNSGAObjectives);
                min(randomSearchObjectives) min(seedNSGAObjectives) min(mixedNSGAObjecitves) min(randomNSGAObjectives);
                mean(randomSearchObjectives) mean(seedNSGAObjectives) mean(mixedNSGAObjecitves) mean(randomNSGAObjectives);
                median(randomSearchObjectives) median(seedNSGAObjectives) median(mixedNSGAObjecitves) median(randomNSGAObjectives);]

randomSearchParetoFront = randomSearchPopulation.best.objs;
seedNSGAParetoFront = seedNSGAPopulation.best.objs;
mixedNSGAParetoFront = mixedNSGAPopulation.best.objs;
randomNSGAParetoFront = randomNSGAPopulation.best.objs;

combinedSearchesPopulation = SOLUTION([randomSearchPopulation.decs; seedNSGAPopulation.decs; mixedNSGAPopulation.decs; randomNSGAPopulation.decs], ...
                                      [randomSearchPopulation.objs; seedNSGAPopulation.objs; mixedNSGAPopulation.objs; randomNSGAPopulation.objs], ...
                                      [randomSearchPopulation.cons; seedNSGAPopulation.cons; mixedNSGAPopulation.cons; randomNSGAPopulation.cons]);

searchNames = ["Random Search", "NSGA seed", "NSGA mixed", "NSGA random"]


%% Combined searches
paretoFront = combinedSearchesPopulation.best.objs;
figure(1)
subplot(1,2,1)
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
legend(searchNames)
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

subplot(1,2,2)
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
hold on
plot(paretoFront(:,1),paretoFront(:,2), 'k*')
legend([searchNames, "Pareto front for all searches"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)
set(gcf,'position',[200,200,2000,750])

%% Random search 
figure(2)
subplot(1,2,1)
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
hold on
plot(randomSearchParetoFront(:,1),randomSearchParetoFront(:,2), 'k*')
legend([searchNames, "Pareto front for random search"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")

ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

subplot(1,2,2)
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(randomSearchParetoFront(:,1),randomSearchParetoFront(:,2), 'k*')
legend([searchNames(1), "Pareto front for random search"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)
set(gcf,'position',[200,200,2000,750])

%% NSGA seed population 
figure(3)
subplot(1,2,1)
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
hold on
plot(seedNSGAParetoFront(:,1),seedNSGAParetoFront(:,2), 'k*')
legend([searchNames, "Pareto front for NSGA seed"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

subplot(1,2,2)
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(seedNSGAParetoFront(:,1),seedNSGAParetoFront(:,2), 'k*')
legend([searchNames(2), "Pareto front for NSGA seed"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)
set(gcf,'position',[200,200,2000,750])


%% NSGA mixed initial population
figure(4)
subplot(1,2,1)
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
hold on
plot(mixedNSGAParetoFront(:,1),mixedNSGAParetoFront(:,2), 'k*')
legend([searchNames, "Pareto front for NSGA mixed"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

subplot(1,2,2)
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(mixedNSGAParetoFront(:,1),mixedNSGAParetoFront(:,2), 'k*')
legend([searchNames(3), "Pareto front for NSGA mixed"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)
set(gcf,'position',[200,200,2000,750])

figure(5)
subplot(1,2,1)
plot(seedNSGAObjectives(:,1),seedNSGAObjectives(:,2),'bo')
hold on
plot(randomSearchObjectives(:,1),randomSearchObjectives(:,2),'ro')
hold on
plot(mixedNSGAObjecitves(:,1),mixedNSGAObjecitves(:,2),'go')
hold on
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
hold on
plot(randomNSGAParetoFront(:,1),randomNSGAParetoFront(:,2), 'k*')
legend([searchNames, "Pareto front for NSGA random population"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)

subplot(1,2,2)
plot(randomNSGAObjectives(:,1), randomNSGAObjectives(:,2), 'co')
hold on
plot(randomNSGAParetoFront(:,1),randomNSGAParetoFront(:,2), 'k*')
legend([searchNames(4), "Pareto front for NSGA random population"])
ylabel(" [Minmimize] objective 2 distance between points")
xlabel(" [Maximize of the negative] objecitve 1 path length between waypoints")
title(ship)
set(gcf,'position',[200,200,2000,750])