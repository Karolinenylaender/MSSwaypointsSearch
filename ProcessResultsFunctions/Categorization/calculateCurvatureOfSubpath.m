function curliness = calculateCurvatureOfSubpath(subPath)
    xpath = subPath(:,1);
    ypath = subPath(:,2);
    n = length(xpath);

    dx = gradient(xpath); 
    dy = gradient(ypath);
    ddx = gradient(dx); 
    ddy = gradient(dy);

    if size(subPath,2) == 2
        
        curvature = abs(ddx .* dy(1:n-2) - dx(1:n-2) .* ddy) ./ ((dx(1:n-2).^2 + dy(1:n-2).^2).^(3/2));
    elseif size(subPath,2) == 3
        zpath = subPath(:,3);
        dz = gradient(zpath);
        ddz = gradient(dz);

        numerator = sqrt((ddy.*dz - ddz.*dy).^2 + (ddz.*dx - ddx.*dz).^2 + (ddx.*dy - ddy.*dx).^2);
        denominator = (dx.^2 + dy.^2 + dz.^2).^(3/2);
        curvature = numerator ./ (denominator + eps); % eps is added to avoid division by zero

    end
    
   
    % Calculate the curliness
    curliness = [mean(abs(curvature)) max(abs(curvature)) std(abs(curvature))];
end
