function normalizedMatrix = normalizeRows(matrixToNormalize, normalizationType, includeMissing)
    if nargin <2
        normalizationType = "squashing";
    end
    if nargin < 3
        includeMissing = false;
    end
    
    if includeMissing == false 
        numberOfMissingPath = sum(matrixToNormalize(:,1) == -1);
        normalizedMatrix = zeros(size(matrixToNormalize,1)-numberOfMissingPath, size(matrixToNormalize,2));
    else
        normalizedMatrix = zeros(size(matrixToNormalize));
    end

    
    for col = 1:size(matrixToNormalize,2)
        vectorToNormalize = matrixToNormalize(:,col);
        vectorToNormalize = vectorToNormalize(vectorToNormalize ~= -1);
        if normalizationType == "minMax"
            normalizedVector = (vectorToNormalize - min(vectorToNormalize))/ (max(vectorToNormalize) -min(vectorToNormalize) );

        elseif normalizationType == "zscore"
            normalizedVector = zscore(vectorToNormalize);
            normalizedVector = (normalizedVector - min(normalizedVector)) / (max(normalizedVector) - min(normalizedVector));


        elseif normalizationType == "decimalScaling"
            decimalScale = ceil(log10(max(abs(vectorToNormalize))));   
            normalizedVector = vectorToNormalize /10^decimalScale;
            normalizedVector = (normalizedVector - min(normalizedVector)) / (max(normalizedVector) - min(normalizedVector));

        elseif normalizationType == "unitVector"
            normalizedVector = vectorToNormalize / norm(vectorToNormalize);
            normalizedVector = (normalizedVector - min(normalizedVector)) / (max(normalizedVector) - min(normalizedVector));


        elseif normalizationType == "robustScaling"
            normalizedVector = (vectorToNormalize -quantile(vectorToNormalize, 0.25)) /(quantile(vectorToNormalize, 0.75) - quantile(vectorToNormalize, 0.25)); 
            normalizedVector = (normalizedVector - min(normalizedVector)) / (max(normalizedVector) - min(normalizedVector));


        elseif normalizationType == "squashing"
            normalizedVector = vectorToNormalize./(ones(length(vectorToNormalize),1) + vectorToNormalize);

        elseif  normalizationType == "normal"
            normalizedVector = normalize(vectorToNormalize, 'range');
        end

        if includeMissing == true
            fullNormalizedVector = matrixToNormalize(:,col);
            fullNormalizedVector(fullNormalizedVector ~= -1) =  normalizedVector;
        else
            fullNormalizedVector = normalizedVector;
        end
        
        normalizedMatrix(:,col) = fullNormalizedVector;


  
end