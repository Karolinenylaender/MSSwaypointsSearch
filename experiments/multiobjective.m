%% mutli objective

%% Initialize the problem
%problem = @waypointMarinerProblem; % Define the problem
algorithm = @NSGAII; % Define the algorithm
problem = @waypointMarinerProblem; % Select the problem
N = 10; % Population size
evaluation = 2000; % Maximum number of evaluations
run = 1; % Number of runs
numPopSaved = 10; % Save the result to files (0 - No, 1 - Yes)


%platemo('algorithm',@NSGAII,'problem',@ZDT1,'N', N, 'maxFE',evaluation, 'run', run);
% [Dec,Obj,Con] = platemo('algorithm',@NSGAII,'problem',@waypointMarinerProblem,'N', N, 'maxFE',evaluation,'save', numPopSaved, 'run', run);
% path = '/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/MSS/TestEvaluation/Results/multiobjective/mariner'
% clear save
% save(path, 'Dec', 'Obj', 'Con')



[Dec,Obj,Con] = platemo('algorithm',@NSGAII,'problem',@waypointsRemus100Problem,'N', N, 'maxFE',evaluation,'save', numPopSaved, 'run', run);
path = '/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/MSS/TestEvaluation/Results/multiobjective/remus100/'
runpath = append(path,"E",evaluation, "-P", N)
clear save
save(path, 'Dec', 'Obj', 'Con')




%% Display the results
% figure; 
% scatter([result.objs(:,1)], [result.objs(:,2)], 'o');
% title('Objective space');
% xlabel('Objective 1');
% ylabel('Objective 2');
% grid on;


