% Multiobjective search
close all
clear all




%% Initialize the problem

algorithm = @NSGAIIAdapted; % Define the algorithm
N = 10; % Population size
numGenerations =1000;
MaxEvaluation = numGenerations*N; %100*N; % Maximum number of evaluations
run = 1; % Number of runs
numPopSaved = 0; % Save the result to files (0 - No, 1 - Yes)
numMxperiments = 30;
startExperiment = 1;
endExperiment = startExperiment+numMxperiments;

global shipResultsPath;

%fullPath = mfilename('fullpath')
currentPath = mfilename('fullpath') %matlab.desktop.editor.getActiveFilename;
resultsPath = append(currentPath,"/results")

searchProcess = "minDistanceMaxPath"
searchProcess = "minDistanceMaxPath"
%ship = "mariner"
%ship = "nspauv"
ship = "remus100"



if searchProcess == "randomSearch"
    N = 1001; % 10*100
    if ship == "mariner"
        for experiement = startExperiment:endExperiment
            shipResultsPath = append(resultsPath, "/mariner/", "randomSearch", "-P", string(N), "-exNum", string(experiement))
            [Dec,Obj,Con] = platemo('algorithm',@RandomSearchPopulation,'problem',@MarinerWaypointSearch,'N', N, 'maxFE',MaxEvaluation,'save', numPopSaved, 'run', run);
            save(shipResultsPath, 'Dec', 'Obj', 'Con') 
       end
    elseif ship == "nspauv"
        for experiement = startExperiment:endExperiment 
             shipResultsPath = append(resultsPath, "/nspauv/", "randomSearch", "-P", string(N), "-exNum", string(experiement))
            [Dec,Obj,Con] = platemo('algorithm',@RandomSearchPopulation,'problem',@npsauvWaypointsSearch,'N', N, 'maxFE',MaxEvaluation,'save', numPopSaved, 'run', run);
            save(shipResultsPath, 'Dec', 'Obj', 'Con')
        end
    elseif ship == "remus100"
        for experiement = startExperiment:endExperiment
            shipResultsPath = append(resultsPath, "/remus100/", "randomSearch", "-P", string(N), "-exNum", string(experiement))
            [Dec,Obj,Con] = platemo('algorithm',@RandomSearchPopulation,'problem',@Remus100WaypointsSearch,'N', N, 'maxFE',MaxEvaluation,'save', numPopSaved, 'run', run);
            save(shipResultsPath, 'Dec', 'Obj', 'Con')
        end
    end
elseif searchProcess == "minDistanceMaxPath"
    if ship == "mariner"
        
        for experiement = startExperiment:endExperiment
            shipResultsPath = append(resultsPath, "/mariner/", "minDistanceMaxPath", "-P", string(N), "-exNum", string(experiement))
            [Dec,Obj,Con] = platemo('algorithm',@NSGAIIAdapted,'problem',@MarinerWaypointSearch,'N', N, 'maxFE',MaxEvaluation,'save', numPopSaved, 'run', run);
            save(shipResultsPath, 'Dec', 'Obj', 'Con')
        end
    elseif ship == "nspauv"
        for experiement = startExperiment:endExperiment
            shipResultsPath = append(resultsPath, "/nspauv/", "minDistanceMaxPath", "-P", string(N), "-exNum", string(experiement))
            [Dec,Obj,Con] = platemo('algorithm',@NSGAIIAdapted,'problem',@npsauvWaypointsSearch,'N', N, 'maxFE',MaxEvaluation,'save', numPopSaved, 'run', run);
            save(shipResultsPath, 'Dec', 'Obj', 'Con')
        end
    elseif ship == "remus100"
        for experiement = startExperiment:endExperiment
            tic
            shipResultsPath = append(resultsPath, "/remus100/", "minDistanceMaxPath", "-P", string(N), "-exNum", string(experiement));
            [Dec,Obj,Con] = platemo('algorithm',@NSGAIIAdapted,'problem',@Remus100WaypointsSearch,'N', N, 'maxFE',MaxEvaluation,'save', numPopSaved, 'run', run);
            save(shipResultsPath, 'Dec', 'Obj', 'Con')
            toc
        end
    end
end










