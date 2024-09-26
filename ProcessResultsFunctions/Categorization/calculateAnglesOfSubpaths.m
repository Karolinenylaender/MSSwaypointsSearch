function angleResults  = calculateAnglesOfSubpaths(fullPath)
    xpath = fullPath(:,1);
    ypath = fullPath(:,2);
    n = length(xpath);
    % Calculate the differences
    dx = gradient(xpath); 
    dy = gradient(ypath);
    %ddx = gradient(dx); 
    %ddy = gradient(dy);
    startPoint = fullPath(1,:);
    endPoint = fullPath(end,:);
    anglesDirect = endPoint-startPoint;

    anglesDirectXY = atan2(anglesDirect(2),anglesDirect(1));
    

    %anglesXY = atan2(dy,dx);
    %dAnglesXY = gradient(anglesXY);
    %dAnglesXY = mod(dAnglesXY +pi, 2*pi) - pi;
    [anglesXY, dAnglesXY, maxAngleXY, devAngleXY] = anglesBetween(dy, dx, anglesDirectXY);
    
    %maxangles = max(dAngles);
    %angles_dev = std(dAngles)
    
    angleResults = [maxAngleXY devAngleXY];
    if size(fullPath,2) == 3
    
        zpath = fullPath(:,3);
        dz = gradient(zpath);
        %ddz = gradient(dz);
        anglesDirectXZ = atan2(anglesDirect(3),anglesDirect(1));
        anglesDirectYZ = atan2(anglesDirect(3),anglesDirect(2));

        [anglesXZ, dAnglesXZ, maxAngleXZ, devAngleXZ] = anglesBetween(dz, dx, anglesDirectXZ);
        [anglesYZ, dAnglesYZ, maxAngleYZ, devAngleYZ] = anglesBetween(dz, dy, anglesDirectYZ);
        
        
        %[anglesZ_XY, dAnglesZ_XY, maxAngleZ_XY, devAngleZ_XY] = anglesBetween(sqrt(dx.^2 + dy.^2), dz);
        %[anglesY_XZ, dAnglesY_XZ, maxAngleY_XZ, devAngleY_XZ] = anglesBetween(sqrt(dx.^2 + dz.^2), dy);
        %[anglesX_YZ, dAnglesX_YZ, maxAngleX_YZ, devAngleX_YZ] = anglesBetween(sqrt(dy.^2 + dz.^2), dx);


        angleResults = [angleResults maxAngleXZ devAngleXZ maxAngleYZ, devAngleYZ]; % anglesDirectYZ]
        %angleResults = [angleResults maxAngleXZ, devAngleXZ anglesDirectXZ maxAngleYZ] %, devAngleYZ anglesDirectYZ]

        %anglesZ_XY, dAnglesZ_XY, maxAngleZ_XY, devAngleZ_XY,
                        %anglesY_XZ, dAnglesY_XZ, maxAngleY_XZ, devAngleY_XZ,
                        %anglesX_YZ, dAnglesX_YZ, maxAngleX_YZ, devAngleX_YZ]
       
    end
    
    function [angle, dAngle, maxAngle, devAngle] = anglesBetween(axizA, axizB, directAngle)
        angle = atan2(axizA,axizB) - directAngle;
        dAngle = gradient(angle);
        dAngle = mod(dAngle +pi, 2*pi) - pi;

        maxAngle = max(dAngle);
        devAngle = std(dAngle);

    end

end