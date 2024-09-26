
function [popDec] = randomizePopulation(populationSize,numberOfDecisionVariables, minDistanceBetweenPoints, lowerlimit, upperLimit, pointDimension)
    popDec = zeros(populationSize, numberOfDecisionVariables);

    numPoints = numberOfDecisionVariables/pointDimension;
    for individNumber = 1:populationSize
        individValid = false;
        while individValid == false 
            tempIndivid = lowerlimit + (upperLimit - lowerlimit).*rand(1,numberOfDecisionVariables);

            if pointDimension == 2
                x = tempIndivid(1:numPoints);
                y = tempIndivid((numPoints+1):end); 
                individValid = round(minDistanceBetweenPoints/2) < min(sqrt( diff(x.^2) + diff(y.^2) )); 
            elseif pointDimension == 3
                x = tempIndivid(1:numPoints);
                y = tempIndivid((numPoints+1):(numPoints*2)); 
                z = tempIndivid((2*numPoints+1):end);
                individValid = round(minDistanceBetweenPoints/2) < min(sqrt( diff(x.^2) + diff(y.^2) + diff(z.^2)));
            end
        end
        popDec(individNumber,:) = tempIndivid;
    end
    
end