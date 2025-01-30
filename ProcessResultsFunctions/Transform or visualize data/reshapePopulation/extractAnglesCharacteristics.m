%% Calculate the characteristics from the raw data of the sub-paths angles 
%  vessel
ship = "mariner"
%ship = "nspauv";
%ship = "remus100";

% Approach 
%searchProcess = "RndSearch";
searchProcess = "WPgenSeed";
%searchProcess = "WPgenComb"
%searchProcess = "WPgenRnd";

% Which experiments do you want to extract?
numExperiments = 30;
validExperiments = 1:numExperiments;



resultsPathInfo = what("ProcessedResults");
resultsFolder = char(resultsPathInfo.path);

for experimentNumber = validExperiments
    resultsPath = append(resultsFolder, "/", ship,"/", searchProcess,"-pathPerformance-exNum-" , num2str(experimentNumber),".mat");

    [subPathPerformance, experimentPerformance] = calculatePerformancePerSubpath(ship, searchProcess, experimentNumber);
    save(resultsPath, "subPathPerformance", "experimentPerformance")
end
