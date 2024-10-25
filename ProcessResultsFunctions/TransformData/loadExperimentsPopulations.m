function experimentPopulation = loadExperimentsPopulation(ship, searchProcess, experimentNumber, populationSize, numGenerations)
    if searchProcess == "minDistanceMaxPath"
        experimentFolderName = append("ex", string(experimentNumber),"/");
    elseif searchProcess == "randomSearch"
        experimentFolderName = append("rand-ex", string(experimentNumber),"/"); 
    end
    folderName = append("ExtractedPopulations/",experimentFolderName); 
    
    resultsPathInfo = what("ProcessedResults");
    resultsFolder = char(resultsPathInfo.path);
    objectivesPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber),".mat");
    if exist(objectivesPath) == 2
        load(objectivesPath,'experimentPopulation');
    else
        %experimentPopulation = [];
        % if searchProcess == "minDistanceMaxPath"
        %         experimentFolderName = append("ex", string(experimentNumber),"/");
        % elseif searchProcess == "randomSearch"
        %     experimentFolderName = append("rand-ex", string(experimentNumber),"/");
        % end
        % folderName = append("ExtractedPopulations/",experimentFolderName);
        decsList = [];
        objsList = [];
        consList = [];
        addList = [];
        for generation = 1:numGenerations
            resultsPath = append(resultsFolder, "/", ship,"/",folderName, "Pop-",searchProcess, "-P", string(populationSize), "-exNum", string(experimentNumber), "-g", string(generation),".mat");
            load(resultsPath, 'Population');
            decsList = [decsList; Population.decs];
            objsList = [objsList; Population.objs];
            consList = [consList; Population.cons];
            addList = [addList Population.add];
            % if isempty(experimentPopulation)
            %      experimentPopulation = Population;
            % else 
            %     experimentPopulation.decs = [experimentPopulation.decs; Population.decs];
            %     experimentPopulation.objs = [experimentPopulation.objs; Population.objs];
            %     experimentPopulation.cons = [experimentPopulation.cons; Population.cons];
            %     experimentPopulation.adds = [experimentPopulation.adds; Population.adds];
            % 
            %     %experimentObjecitves = [experimentObjecitves; Population.objs];
            % end
          
        end
        experimentPopulation = SOLUTION(decsList, objsList, consList);
        save(objectivesPath,'experimentPopulation');
    end
end