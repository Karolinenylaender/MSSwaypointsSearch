close all
clear all

shipInitialwaypoints

ship = "remus100"
initalpoints = waypoints(ship)
intialPointsMatrix = [initalpoints.pos.x initalpoints.pos.y initalpoints.pos.z]
[simdata , ALOSdata, state] = remus100path(initalpoints, initalpoints.R_switch);
eta_mutated = simdata(:,18:23);
x_mutated = eta_mutated(:,1);
y_mutated = eta_mutated(:,2);
z_mutated = eta_mutated(:,3);
initialPath = [x_mutated y_mutated z_mutated];


basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/remus100-multiobjecitve"
basepath = "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/remus100-minWptMaxDist"
basepath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/results/multiobjective/remus100-minWptMaxDTW"

metrics = ['avg_curv', 'max_angles', 'angles_std', 'max_XYZangles', 'anglesXYZ_std', 'distancePath', 'DTWdistance', 'pointDistance', 'missingWpt']

perfromanceMatrix = []
experimentNum = 1;
for exnum = 1:experimentNum
    expath = append(basepath,"E",string(exnum))
    
    load(expath, 'Dec')
    for individualIndex = 1:size(Dec,1)
        %individ_wayPoint = Dec(individ_index,:)
        R_switch = 5
        individual = Dec(individualIndex,:);
        numPoints = length(individual)/3
        wpt.pos.x = [0 individual(1:numPoints)]'
        wpt.pos.y = [0 individual((numPoints+1):(numPoints*2))]'
        wpt.pos.z = [0 individual((numPoints*2+1):end)]'
        generatedWaypoints = [wpt.pos.x wpt.pos.y wpt.pos.z];
        [simdata , ALOSdata, state] = remus100path(wpt, R_switch);
        
        time = simdata(:,1);        
        eta_mutated = simdata(:,18:23);
        x_mutated = eta_mutated(:,1);
        y_mutated = eta_mutated(:,2);
        z_mutated = eta_mutated(:,3);
        generatedPath = [x_mutated y_mutated z_mutated]
    
        performanceList = evalatePathAndWaypoints(intialPointsMatrix, initialPath, generatedPath, generatedWaypoints, R_switch);
        perfromanceMatrix = [perfromanceMatrix; performanceList]
     
        

  
    
    end

    scaledPerformance = zeros(size(perfromanceMatrix));  % create an empty matrix of the same size as A
    
    for i = 1:size(perfromanceMatrix ,2)
        scaledPerformance(:,i) = rescale(perfromanceMatrix(:,i), 0, 100);
    end

    figure
    plot(scaledPerformance')
    xticks(1:numel(metrics));
    xticklabels(metrics);
    xtickangle(45);
    ylabel('performance')
    legend(cellstr(num2str((1:size(perfromanceMatrix,1))', 'Column %d')), 'Location','best')

    scaledPerformance
    

end

resultsPath = append(path, "-resultsMatrix")
save(resultsPath, perfromanceMatrix)
