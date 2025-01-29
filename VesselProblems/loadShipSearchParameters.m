function shipInformation = loadShipSearchParameters(shipName)
    if shipName == "mariner"
        xinitial =  [0  2000 5000 3000 6000 10000];
        yinitial =  [0  0 5000  8000 12000 12000];
        InitalPoints = [xinitial(:,2:end)' yinitial(:,2:end)']';
        InitalPoints = InitalPoints(:)'; 
      
        shipInformation.shipName = shipName;
        shipInformation.initialPoints = InitalPoints;
        shipInformation.pointDimension = 2;
        shipInformation.R_switch = 400;
    
    elseif shipName == "remus100"
        xinitial =  [0  -20 -100   0  200, 200  400];
        yinitial =  [0  200  600 950 1300 1800 2200];
        zinitial =  [0   10  100 100   50   50   50];
        InitalPoints = [xinitial(:,2:end)' yinitial(:,2:end)' zinitial(:,2:end)']';
        InitalPoints = InitalPoints(:)'; 

        shipInformation.shipName = shipName;
        shipInformation.initialPoints = InitalPoints;
        shipInformation.pointDimension = 3;
        shipInformation.R_switch = 5;
    elseif shipName == "nspauv"
        xinitial =  [0   50  100   0  100, 200  400];
        yinitial =  [0  200  600 950 1300 1800 2200];
        zinitial =  [0   10  100 200  200  200  150];
        InitalPoints = [xinitial(:,2:end)' yinitial(:,2:end)' zinitial(:,2:end)']';
        InitalPoints = InitalPoints(:)'; 

        shipInformation.shipName = shipName;
        shipInformation.initialPoints = InitalPoints;
        shipInformation.pointDimension = 3;
        shipInformation.R_switch = 5;

    end


      
end