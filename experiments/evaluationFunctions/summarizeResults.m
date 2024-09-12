
path =     "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/randomSearch-P100-exNum101";
experimentsResultsPath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P100-exNum112-experimentResults-112";


load(experimentsResultsPath)
%load('/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P100-exNum113-experimentResults-113.mat')
%load('/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/mariner/minDistanceMaxPath-P100-exNum110-experimentResults-110.mat')
load('/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/mariner/minDistanceMaxPath-P100-exNum113-experimentResults-113.mat')

%experimentsResults.keys
%generationResults = experimentsResults('111')
generationResults.keys

results = []
for i = 1:10
    gengen = generationResults(string(i));
    missing = nnz(gengen(:,3))
   
    results = [results missing]
    
    
end


experimentsResultsPath =  "/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P100-exNum112-experimentResults-112";


load(experimentsResultsPath)
%load('/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/minDistanceMaxPath-P100-exNum113-experimentResults-113.mat')
%load('/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/mariner/minDistanceMaxPath-P100-exNum110-experimentResults-110.mat')
load("/Users/karolinen/Documents/Projects/Projects/Ships/Simulators/experiments/multiobjectiveSearch/results/remus100/randomSearch-P100-exNum100-experimentResults-100")

%experimentsResults.keys
%generationResults = experimentsResults('111')
generationResults.keys

resultsRandom = []
for i = 1:10
    gengen = generationResults(string(i));
    missing = nnz(gengen(:,3))
   
    resultsRandom = [resultsRandom missing]
    
    
end

plot(results)
hold on
plot(resultsRandom)
legend("NSGA-ii", "random")
xlabel("generation")
ylabel("number of unstable paths per generation")