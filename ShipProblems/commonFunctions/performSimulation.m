function [fullpath, subPaths, transitionIndices] = performSimulation(listOfPoints, obj)
    numPoints = length(listOfPoints)/obj.pointDimension;
     pointsMatrix = reshape(listOfPoints, [obj.pointDimension, numPoints])';
     if obj.shipName == "mariner"
         wpt.pos.x  = [0; pointsMatrix(:,1)];
         wpt.pos.y  = [0; pointsMatrix(:,2)];
    
         [simdata, ~] = marinerPath(wpt, obj.Delta_h, obj.R_switch);
         x = simdata(:,5);
         y = simdata(:,6);
         fullpath = [x y];

     elseif obj.shipName == "remus100"
         wpt.pos.x  = [0; pointsMatrix(:,1)];
         wpt.pos.y  = [0; pointsMatrix(:,2)];
         wpt.pos.z  = [0; pointsMatrix(:,3)];
     
         [simdata , ~, ~] = remus100path(wpt, obj.R_switch);      
         eta_mutated = simdata(:,18:23);
         x_mutated = eta_mutated(:,1);
         y_mutated = eta_mutated(:,2);
         z_mutated = eta_mutated(:,3);
         fullpath = [x_mutated y_mutated z_mutated];


     elseif obj.shipNAme == "nspauv"

         wpt.pos.x  = [0; pointsMatrix(:,1)];
         wpt.pos.y  = [0; pointsMatrix(:,2)];
         wpt.pos.z  = [0; pointsMatrix(:,3)];
         
         [simdata , ~, ~] = npsauvPath(wpt, obj.R_switch);      
         eta_mutated = simdata(:,17:22);
         x_mutated = eta_mutated(:,1);
         y_mutated = eta_mutated(:,2);
         z_mutated = eta_mutated(:,3);
         fullpath = [x_mutated y_mutated z_mutated];
    
        
     end
     [transitionIndices, subPaths] = splitDataBetweenWaypoints(pointsMatrix, obj.R_switch,fullpath);

     
end