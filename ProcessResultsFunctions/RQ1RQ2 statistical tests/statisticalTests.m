%% Statisitcal tests: 


numExperiments= 30;


recalculateHV = false;
calculateAgreement("mariner",recalculateHV)
calculateAgreement("remus100",recalculateHV)
calculateAgreement("nspauv", recalculateHV)


function calculateAgreement(ship, recalculateHV)

    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    
    
    if recalculateHV == true
        calculateHV(ship)
    end

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
    
    allResultsMap = containers.Map();
    
    allResultsMap("RndSearch") = rndSearchScores;
    allResultsMap("WPgenSeed") = WPgenSeedScores;
    allResultsMap("WPgenComb") = WPgenCombScores;
    allResultsMap("WPgenRnd") = WPgenRndScores;
    
     
    
    % Seed NSGA vs the rest
    results = [["Approach 1" "Approach 2" "A12" "mannWhitney U-test" "Best search"]];
    results = [results; voteOnSearchType(allResultsMap, "RndSearch", "WPgenSeed")];
    results = [results; voteOnSearchType(allResultsMap, "RndSearch", "WPgenComb")];
    results = [results; voteOnSearchType(allResultsMap, "RndSearch", "WPgenRnd")];
    results = [results; voteOnSearchType(allResultsMap, "WPgenSeed", "WPgenComb")];
    results = [results;voteOnSearchType(allResultsMap,  "WPgenSeed", "WPgenRnd" )];
    results = [results; voteOnSearchType(allResultsMap, "WPgenComb", "WPgenRnd" )];
    
    display(results)
    resultsPath = append(resultsFolder, "/", ship,"/StatisticalTest-results.mat");
    save(resultsPath, "results")
end

function resultsInfo = voteOnSearchType(searchResultsMap, searchOneName, searchTwoName) 
    searchOne = searchResultsMap(searchOneName);
    searchTwo = searchResultsMap(searchTwoName);

    mannWhitneyUtestValue = ranksum(searchOne, searchTwo);
    a12value = a12(searchOne,searchTwo);

    if mannWhitneyUtestValue < 0.05 && a12value > 0.5
        finalVote = searchOneName;
    elseif mannWhitneyUtestValue < 0.05 && a12value < 0.5
        finalVote = searchTwoName;
    elseif mannWhitneyUtestValue >= 0.05 || a12value == 0.5
        finalVote = "ND"; 
    else
        finalVote = "";
    end
    resultsInfo = [searchOneName searchTwoName num2str(a12value) num2str(mannWhitneyUtestValue) finalVote]; 
    
end