function obj = savePopulation(obj, Population, parameter)
    %global shipResultsPath
    shipResultsPath = parameter.shipResultsPath;
    
    generationPath = append(shipResultsPath, "-g", string(obj.generation));
    paths = obj.pathsMap;
    save(generationPath,"Population", "paths");
    obj.generation = obj.generation + 1;
    obj.pathsMap = containers.Map();
end