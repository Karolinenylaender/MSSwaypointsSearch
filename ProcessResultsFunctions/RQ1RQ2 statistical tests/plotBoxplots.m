%% Generate box plots
close all

plotBoxplot("mariner")
plotBoxplot("remus100")
plotBoxplot("nspauv")

function plotBoxplot(ship)
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);

    resultsPath = append(resultsFolder, "/", ship,"/RndSearch-QI-values.mat");
    load(resultsPath, 'rndSearchScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/WPgenSeed-QI-values.mat");
    load(resultsPath, 'WPgenSeedScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/WPgenComb-QI-values.mat");
    load(resultsPath, 'WPgenCombScores')
    
    resultsPath = append(resultsFolder, "/", ship,"/WPgenRnd-QI-values.mat");
    load(resultsPath, 'WPgenRndScores')
    
    figure;
    boxplot([rndSearchScores, WPgenSeedScores WPgenCombScores WPgenRndScores], 'Whisker', 1.5)
    ax = gca; % Get current axes
    ax.FontSize = 18;
    ax.XTickLabel = {'$RS$','$WPgen_{seed}$', '$WPgen_{comb}$', '$WPgen_{rnd}$'};
    set(gca, 'TickLabelInterpreter', 'latex');
end
