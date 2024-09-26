function normalizedMatrix = normalizeRows(matrixToNormalize)
    normalizedMatrix = zeros(size(matrixToNormalize));
    for col = 1:size(matrixToNormalize,2)
        normalizedMatrix(:,col) = matrixToNormalize(:,col)./(ones(size(matrixToNormalize,1),1) + matrixToNormalize(:,col));
        %normalizedMatrix(:,col) = normalize(matrixToNormalize(:,col), 'range');
    end
  
end