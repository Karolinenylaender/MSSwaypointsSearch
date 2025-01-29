function [lower, upper, PopDec] =  generateInitialPopulation(obj, populationType)

    if populationType ~= "Random"

        [fullpath, subPaths, transitionIndices, angles] = performSimulation(obj.initialPoints, obj);
        paths = containers.Map();
        paths("fullpath") = fullpath;
        paths("transitionIndices") = transitionIndices;
        paths("angles") = angles;
        obj.pathsMap('0') = paths;
        obj.initialPath = fullpath; 
    end
    
    numPoints = length(obj.initialPoints)/obj.pointDimension;
    pointsMatrix  =  reshape(obj.initialPoints, [obj.pointDimension, numPoints])';
    if obj.shipName == "mariner"
        xinitial = pointsMatrix(:,1);
        yinitial = pointsMatrix(:,2);

        xLower = xinitial - ones(size(xinitial))*400;
        xUpper = xinitial + ones(size(xinitial))*400;
    
        yLower = yinitial - ones(size(yinitial))*400;
        yUpper = yinitial + ones(size(yinitial))*400;
    

        lower = [xLower yLower]';
        upper = [xUpper yUpper]';

    elseif obj.shipName == "remus100" || obj.shipName == "nspauv"
        xinitial = pointsMatrix(:,1);
        yinitial = pointsMatrix(:,2);
        zinitial = pointsMatrix(:,3);

        xLower = xinitial - ones(size(xinitial))*150;
        xUpper = xinitial + ones(size(xinitial))*150;
    
        yLower = yinitial - ones(size(yinitial))*150;
        yUpper = yinitial + ones(size(yinitial))*150;
    
        zLower =  zeros(size(zinitial));
        zUpper =  zinitial + ones(size(zinitial))*150;
    
        lower = [xLower yLower zLower]';
        upper = [xUpper yUpper zUpper]';
    end
        
    
    lower = lower(:)';
    upper = upper(:)';

    if populationType == "Random"
        % Fully random 
        PopDec = randomizePopulation(obj, lower, upper);
    elseif populationType == "Seed"
        % Fully seeded
        mutatedPopulation = seedPopulation((obj.N)-1,obj.D, obj.minDistanceBetweenPoints, obj.lower, obj.upper, obj.pointDimension, obj.initialPoints);
        PopDec = [obj.initialPoints; mutatedPopulation];
        
    elseif populationType == "Comb"
        % Combination
        randomPopulation = randomizePopulation(obj, lower, upper);
        randomPopulation = randomPopulation(1:size(randomPopulation,1)/2,:);
        mutatedPopulation = seedPopulation((obj.N)/2-1,obj.D, obj.minDistanceBetweenPoints, obj.lower, obj.upper, obj.pointDimension, obj.initialPoints);
        PopDec = [obj.initialPoints; mutatedPopulation; randomPopulation];

    elseif populationType == "Rnd"
        % Random with initial WP
        randomPopulation = randomizePopulation(obj, lower, upper);
        randomPopulation = randomPopulation(1:size(randomPopulation,1)-1,:);
        PopDec = [obj.initialPoints; randomPopulation];
    end
  
    

end