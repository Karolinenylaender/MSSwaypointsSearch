classdef RandomSearchPopulation < ALGORITHM

    methods
        function main(Algorithm,Problem)
            %% Generate random population
            Population = Problem.Initialization(Problem.N, "random");
            %Population = Problem.Initialization(1);
            %Offspring = randomizePopulation(Problem.N,Problem.D, Problem.minDistanceBetweenPoints, Problem.lower, Problem.upper, Problem.pointDimension);
            
            %[~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);
            Problem  = savePopulation(Problem, Population)
            numberOfEvaluations = length(Population);
            Problem.FE = numberOfEvaluations;

            %% Optimization
            while Algorithm.NotTerminated(Population)
                Population = Problem.Initialization(Problem.N, "random");
                Problem  = savePopulation(Problem, Population);

                %Problem.FE     = Problem.FE + length(Population);
                numberOfEvaluations = numberOfEvaluations + length(Population);
                Problem.FE = numberOfEvaluations;
            end
        end
    end
end

