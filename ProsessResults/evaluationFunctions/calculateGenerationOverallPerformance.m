function generationPerformance = calculateGenerationOverallPerformance(ObjectiveMatrix)
    [numIndividuals, numObjectives] = size(ObjectiveMatrix);
    normalizedObjectives = zeros(size(ObjectiveMatrix));
    %individualScores = zeros(numIndividuals,1);
    %objectiveDistanceFromOptimal = zeros(numIndividuals,1);
    optimalPoint = [0 0];

    normalizedObjectives(:,1) = ObjectiveMatrix(:,1)./ (ObjectiveMatrix(:,1)+ ones(numIndividuals,1))  -ones(numIndividuals,1);
    normalizedObjectives(:,2) = ObjectiveMatrix(:,2)./ (ObjectiveMatrix(:,2)+ ones(numIndividuals,1));  

    objectiveDistanceFromOptimal = pdist2(optimalPoint,normalizedObjectives);
    minMaxAverage = sum(normalizedObjectives,2)/numObjectives;
    populationHV = hypervolume(normalizedObjectives,[1 1]);
    generationPerformance = [min(objectiveDistanceFromOptimal) min(minMaxAverage) populationHV]; 
end