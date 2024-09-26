%clear all
close all

figureNumber = 1;

%basepath10_1000 = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P10-exNum1000-g"
basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/ExperimentFunctions/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P"

% generationPerformances10_0 = calculateGenerationPerformances(basepath, 10, 1000, 103);
% generationPerformances10_5 = calculateGenerationPerformances(basepath,10,1005, 662);
% generationPerformances10_6 = calculateGenerationPerformances(basepath,10,1006, 1651);
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% plot(generationPerformances10_0(:,1))
% hold on
% plot(generationPerformances10_5(:,1))
% hold on
% plot(generationPerformances10_6(:,1))
% legend('Aitors approach','Combination', 'Combination')
% title("Closest distance from optimal point with normalization")
% 
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% plot(generationPerformances10_0(:,2))
% hold on
% plot(generationPerformances10_5(:,2))
% hold on
% plot(generationPerformances10_6(:,2))
% legend('Aitors approach','Combination', 'Combination')
% title("Normalized average")
% 
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% subplot(3,1,1)
% plot(generationPerformances10_0(:,3))
% legend('Aitors approach')
% subplot(3,1,2)
% plot(generationPerformances10_5(:,3))
% legend('Combination')
% subplot(3,1,3)
% plot(generationPerformances10_6(:,3))
% legend('Combination')
% title("Hypervolume with worst point [1 1]")
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% subplot(3,1,1)
% plot(generationPerformances10_0(:,8))
% legend('Aitors approach')
% subplot(3,1,2)
% plot(generationPerformances10_5(:,8))
% legend('Combination')
% subplot(3,1,3)
% plot(generationPerformances10_6(:,8))
% legend('Combination')
% title("Average number of missing waypoints")
% 
% 
% % max and average
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% title("Objective 1: Average and maximum")
% subplot(4,1,1)
% plot(generationPerformances10_0(:,4))
% hold on
% plot(generationPerformances10_5(:,4))
% hold on
% plot(generationPerformances10_6(:,4))
% title("Objective 1: Average for generation")
% subplot(4,1,2)
% plot(generationPerformances10_0(:,6))
% hold on
% plot(generationPerformances10_5(:,6))
% hold on
% plot(generationPerformances10_6(:,6))
% legend('Aitors approach','Combination', 'Combination')
% title("Objective 1: Maximum for generation")
% 
% subplot(4,1,3)
% plot(generationPerformances10_0(:,5))
% hold on
% plot(generationPerformances10_5(:,5))
% hold on
% plot(generationPerformances10_6(:,5))
% title("Objective 2: Maximum for generation")
% 
% subplot(4,1,4)
% plot(generationPerformances10_0(:,7))
% hold on
% plot(generationPerformances10_5(:,7))
% hold on
% plot(generationPerformances10_6(:,7))
% legend('Aitors approach','Combination', 'Combination')
% title("Objective 2: Average for generation")



%% 20 population
% generationPerformances20_0 = calculateGenerationPerformances(basepath,20,1000, 511);
% generationPerformances20_4 = calculateGenerationPerformances(basepath,20,1004, 239);
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% plot(generationPerformances20_0(:,1))
% hold on
% plot(generationPerformances20_4(:,1))
% legend('Aitors approach','Combination')
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% plot(generationPerformances20_0(:,2))
% hold on
% plot(generationPerformances20_4(:,2))
% legend('Aitors approach','Combination')
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% subplot(2,1,1)
% legend('Aitors approach')
% 
% plot(generationPerformances20_0(:,3))
% subplot(2,1,2)
% plot(generationPerformances20_4(:,3))
% legend('Combination')
% title("Hypervolume")
% 
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% subplot(2,1,1)
% plot(generationPerformances20_0(:,8))
% legend('Aitors approach')
% subplot(2,1,2)
% plot(generationPerformances20_4(:,8))
% legend('Combination')
% title("Average number of missing waypoints")
% 
% % max and average
% figure(figureNumber)
% figureNumber = figureNumber + 1;
% title("Objective 1: Average and maximum")
% subplot(4,1,1)
% plot(generationPerformances20_0(:,4))
% hold on
% plot(generationPerformances20_4(:,4))
% title("Average for generation")
% subplot(4,1,2)
% plot(generationPerformances20_0(:,6))
% hold on
% plot(generationPerformances20_4(:,6))
% legend('Aitors approach','Combination')
% title("Maximum for generation")
% 
% subplot(4,1,3)
% plot(generationPerformances20_0(:,5))
% hold on
% plot(generationPerformances20_4(:,5))
% title("Objective 2: Maximum for generation")
% 
% subplot(4,1,4)
% plot(generationPerformances20_0(:,7))
% hold on
% plot(generationPerformances20_4(:,7))
% legend('Aitors approach','Combination')
% title("Objective 2: Average for generation")
% 


%% 30 population
generationPerformances30_1 = calculateGenerationPerformances(basepath,30,1001, 382);
generationPerformances30_2 = calculateGenerationPerformances(basepath,30,1002, 28);
generationPerformances30_3 = calculateGenerationPerformances(basepath,30,1003, 110);


figure(figureNumber)
figureNumber = figureNumber + 1;
plot(generationPerformances30_1(:,1))
hold on
plot(generationPerformances30_2(:,1))
hold on
plot(generationPerformances30_3(:,1))
legend('Aitors approach','Aitors approach', 'Combination')


figure(figureNumber)
figureNumber = figureNumber + 1;
plot(generationPerformances30_1(:,2))
hold on
plot(generationPerformances30_2(:,2))
hold on
plot(generationPerformances30_3(:,2))
legend('Aitors approach','Aitors approach', 'Combination')


figure(figureNumber)
figureNumber = figureNumber + 1;
subplot(3,1,1)
plot(generationPerformances30_1(:,3))
legend('Aitors approach')
subplot(3,1,2)
plot(generationPerformances30_2(:,3))
legend('Aitors approach')
subplot(3,1,3)
plot(generationPerformances30_3(:,3))
legend('Combination')
title("Hypervolume")

figure(figureNumber)
figureNumber = figureNumber + 1;
subplot(3,1,1)
plot(generationPerformances30_1(:,8))
legend('Aitors approach')
subplot(3,1,2)
plot(generationPerformances30_2(:,8))
legend('Aitors approach')
subplot(3,1,3)
plot(generationPerformances30_3(:,8))
legend('Combination')
title("Average number of missing waypoints")

% max and average
figure(figureNumber)
figureNumber = figureNumber + 1;
title("Objective 1: Average and maximum")
subplot(4,1,1)
plot(generationPerformances30_1(:,4))
hold on
plot(generationPerformances30_2(:,4))
hold on
plot(generationPerformances30_3(:,4))
title("Objective 1: Average for generation")
subplot(4,1,2)
plot(generationPerformances30_1(:,6))
hold on
plot(generationPerformances30_2(:,6))
hold on
plot(generationPerformances30_3(:,6))
title("Objective 1: Maximum for generation")

subplot(4,1,3)
plot(generationPerformances30_1(:,5))
hold on
plot(generationPerformances30_2(:,5))
hold on
plot(generationPerformances30_3(:,5))
title("Objective 2: Maximum for generation")

subplot(4,1,4)
plot(generationPerformances30_1(:,7))
hold on
plot(generationPerformances30_2(:,7))
hold on
plot(generationPerformances30_3(:,7))
legend('Aitors approach','Aitors approach', 'Combination')
title("Objective 2: Average for generation")



% basepath20_1000 = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P20-exNum1000-g"
% generationPerformances20_0 = calculateGenerationPerformances(basepath20_1000, 511)
% basepath20_1004 = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P20-exNum1004-g"
% generationPerformances20_4 = calculateGenerationPerformances(basepath20_1004, 239)
% 

% 




% if popSize == 10
%     basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P10-exNum500-g"
%     %maxGen = 
% 
% elseif popSize == 20
%     basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P20-exNum501-g"
%         maxGen = 1000
% elseif popSize == 30
%     basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P30-exNum502-g"
% end

% basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P30-exNum1002-g"
% AitorGenerationPerformances = calculateGenerationPerformances(basepath, 94)
% figure(1)
% plot(AitorGenerationPerformances(:,1))
% figure(2)
% plot(AitorGenerationPerformances(:,2))

% basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P10-exNum510-g"
% AitorGenerationPerformances = calculateGenerationPerformances(basepath, 2882)
% 
% basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P10-exNum511-g"
% ComobGenerationPerformances = calculateGenerationPerformances(basepath, 2157)
% 
% basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P10-exNum512-g"
% RandomGenerationPerformances = calculateGenerationPerformances(basepath, 2218)
% 
% figure(1)
% plot(AitorGenerationPerformances(:,1))
% hold on
% plot(ComobGenerationPerformances(:,1))
% hold on
% plot(RandomGenerationPerformances(:,1))
% legend("Seed population", "Combination", "Random")
% 
% figure(2)
% plot(AitorGenerationPerformances(:,2))
% hold on
% plot(ComobGenerationPerformances(:,2))
% hold on
% plot(RandomGenerationPerformances(:,2))
% legend("Seed population", "Combination", "Random")
% 
% 
% figure(3)
% plot(AitorGenerationPerformances(:,3))
% hold on
% plot(ComobGenerationPerformances(:,3))
% hold on
% plot(RandomGenerationPerformances(:,3))
% legend("Seed population", "Combination", "Random")


function generationPerformances = calculateGenerationPerformances(basepath, PopulationSize, exNum, maxGen)    
    generationPerformances = [];
    for generation = 1:maxGen
        generationPath = append(basepath,string(PopulationSize), "-exNum", string(exNum),"-g" , string(generation));
        load(generationPath);
        objectives = Population.objs;
        missingWaypoints = 0
        for individual = 1:size(objectives,1)
            individualPath = paths(string(individual));
            numMissingWaypoints = 5 - length(individualPath('transitionIndices'));
            missingWaypoints = missingWaypoints+ numMissingWaypoints;
        end
        AverageMissingWayPoints = missingWaypoints/size(objectives,1);
        
        %maxObj1 = sort(objectives)
        %maxObj2 = 
        averageObjectives = [mean(objectives(:,1)) mean(objectives(:,2))];
        maximumObjectives = [min(objectives(:,1)) max(objectives(:,2))];
        

        performance = [calculateGenerationOverallPerformance(objectives) averageObjectives maximumObjectives AverageMissingWayPoints];
        generationPerformances = [generationPerformances; performance];
        
       
        
    end
end


%plot(log(generationPerformances(:,1)))
