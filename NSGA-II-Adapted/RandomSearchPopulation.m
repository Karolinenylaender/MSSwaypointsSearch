classdef RandomSearchPopulation < ALGORITHM

    methods
        function main(Algorithm,Problem)
            %% Generate random population
            Algorithm.parameter.populationType = "random";
            Population = Problem.Initialization(Problem.N,Algorithm.parameter); % "random");
            numGeneration = Problem.generation;
            %Population = Problem.Initialization(1);
            %Offspring = randomizePopulation(Problem.N,Problem.D, Problem.minDistanceBetweenPoints, Problem.lower, Problem.upper, Problem.pointDimension);
            
            %[~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);
            Problem = savePopulation(Problem, Population, Algorithm.parameter);
            numberOfEvaluations = length(Population);
            Problem.FE = numberOfEvaluations;
           

            %% Optimization
            while Algorithm.NotTerminated(Population)
                Population = Problem.Initialization(Problem.N, Algorithm.parameter); %"random");
                numGeneration = numGeneration+1;
                Problem.generation = numGeneration;
                Problem = savePopulation(Problem, Population, Algorithm.parameter);

                %Problem.FE     = Problem.FE + length(Population);
                numberOfEvaluations = numberOfEvaluations + length(Population);
                Problem.FE = numberOfEvaluations;
            end
        end
    end
end

