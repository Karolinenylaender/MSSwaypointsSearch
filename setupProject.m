

%addFolderToPath("experiments/")
%addFolderToPath("pathGeneration")
%addFolderToPath("multiobjectiveSearch")
%addFolderToPath("pareto_HV")

addFolderToPath("BIMK-PlatEMO-4.7.0.0/PlatEMO/")
addFolderToPath("MSS")
addFolderToPath("ShipProblems")
addFolderToPath("NSGA-II-Adapted/")
%addFolderToPath(extract)
addFolderToPath("ExperimentFunctions/")

% Save the updated path
savepath;
fprintf('MATLAB path updated and saved successfully in MATLAB.\n');

function addFolderToPath(folderName)
    folderInfo = what(folderName);
    if ~isempty(folderInfo)
        basePath = char(folderInfo.path);  % Ensure the path is char
    end

    warning('off', 'MATLAB:rmpath:DirNotFound');
    rmpath(genpath(basePath));
    warning('on', 'MATLAB:rmpath:DirNotFound');

    addpath(genpath(basePath));
end