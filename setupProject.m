%% Setup folders
addFolderToPath("BIMK-PlatEMO-4.7.0.0/PlatEMO/")
addFolderToPath("MSS")

addFolderToPath("ShipProblems")
addFolderToPath("NSGA-II-Adapted/")

addFolderToPath("ProcessResultsFunctions/")
addFolderToPath("ExperimentsResults")

savepath;
fprintf('MATLAB path updated and saved successfully in MATLAB.\n');

function addFolderToPath(folderName)
    folderInfo = what(folderName);
    if ~isempty(folderInfo)
        basePath = char(folderInfo.path);  % Ensure the path is char

        warning('off', 'MATLAB:rmpath:DirNotFound');
        rmpath(genpath(basePath));
        warning('on', 'MATLAB:rmpath:DirNotFound');
    
        addpath(genpath(basePath));
    else
        fprintf("Did not find folder %s \n", folderName);
    end
end