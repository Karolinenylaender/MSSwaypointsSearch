function [obj, PopDec] =  generateInitialPopulation(obj)

    [fullpath, ~, transitionIndices] = performSimulation(obj.initalPoints, obj);
    paths = containers.Map();
    paths("fullpath") = fullpath;
    paths("subPaths") = subPaths;
    paths("transitionIndices") = transitionIndices;
    obj.pathsMap('0') = paths;

    obj.initialPoints = InitalPoints;
    obj.initialPath = fullpath; 
    obj.intialSegementDistance =calculateSegmentLengths(transitionIndices, fullpath);

    if obj.shipName == "mariner"

        xLower = xinitial - ones(size(xinitial))*400;
        xUpper = xinitial + ones(size(xinitial))*400;
    
        yLower = yinitial - ones(size(yinitial))*400;
        yUpper = yinitial + ones(size(yinitial))*400;
    
        obj.lower = [xLower(:,2:end)' yLower(:,2:end)']';
        obj.upper = [xUpper(:,2:end)' yUpper(:,2:end)']';
    elseif obj.shipName == "remus100" || obj.shipName == "nspauv"
        xLower = xinitial - ones(size(xinitial))*150;
        xUpper = xinitial + ones(size(xinitial))*150;
    
        yLower = yinitial - ones(size(yinitial))*150;
        yUpper = yinitial + ones(size(yinitial))*150;
    
        zLower =  zeros(size(zinitial));
        zUpper =  zinitial + ones(size(zinitial))*150;
    
        obj.lower = [xLower(:,2:end)' yLower(:,2:end)' zLower(:,2:end)']';
        obj.upper = [xUpper(:,2:end)' yUpper(:,2:end)' zUpper(:,2:end)']';
    end
        
    
    obj.lower = obj.lower(:)';
    obj.upper = obj.upper(:)';

    obj.D = length(InitalPoints);
    obj.validPath = ones(obj.N, 1);

    strategyAitor = true;
    if strategyAitor 
        randomAitorPopulation = seedPopulation((obj.N)-1,obj.D, obj.minDistanceBetweenPoints, obj.lower, obj.upper, obj.pointDimension, InitalPoints);
    end
    PopDec = [obj.initialPoints; randomAitorPopulation];

end