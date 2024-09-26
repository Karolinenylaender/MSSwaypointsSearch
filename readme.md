
## Usage Guide
# Step 1: Installation
Clone the two github-repostiories: 
1. PlatEMO: https://github.com/BIMK/PlatEMO/tree/master
2. MSS: https://github.com/cybergalactic/MSS
```
git clone https://github.com/BIMK/PlatEMO/tree/master
git clone https://github.com/cybergalactic/MSS
```

3. Clone this project
```
git clone https://github.com/Karolinenylaender/MSSwaypointsSearch
```

# Step 2: Set the correct matlab files

1. Go to the file 'setupProject' and check that the folder names 'MSS' and 'PlatEMO' corresponds with what you have called the PlatEMO and MSS folders
```
addFolderToPath("BIMK-PlatEMO-4.7.0.0/PlatEMO/")
addFolderToPath("MSS")
```

2. Run the setupProject.m script 
```
setupProject.m
```


# Step 3:  Run the experiments
1. Go to the file 'runExperiments.m'
2. In the file you can choose
* Ship type: "mariner", "nspauv" and "remus100"
* Algorithm type: "randomSearch" or "NSGA-ii"
* Number of experiments (default is 30)
* Path to save the data (defaullt is the folder ExperimentsResults/)
* Population size (default is 10)
* Number of generations (default is 1000)

To run one experiment you can call the function
```
 performSearch(ship, searchProcess, resultsPath, experimentNumber, numGenerations, populationSize)
```

# Step 4: Evaluate the generated waypoints and paths 
* Structure of experiments*
Inside the folder 'ExperiementsResults' there is a folder for each ship. 
The name of each file indicates the type of search that is performed
e.g ExperiementsResults/remus100/minDistanceMaxPath-P10-exNum51-g2 is the results for
* ship = remus100
* search method: minDistanceMaxPath
* population size: 10
* experiment number 50
* generation number: 2 

Loading this file you can find: 
* 'Population': the Population for the current generation
* 'Path': a map that cointains the 'fullpath' and 'transitionIndices' for each individual in the population. 


*Evaluate experiments*
Located inside folder ProcessResultsFolder:
* categorize path
* evaluationFunction
* robustNess


## Folder structure
1. NSGA-II-Adapted 
> Contains the adapted NSGA-II and random search functions
> GArealPoints performs crossover where the points (x,y) or (x,y,z) are moved together

2. ShipProblems - Contains the userProblems defined each ship
- /commenFunctions - contains the common functions utilized by each ship
    - calculate SegmentLength 
    - evalauteWaypointsAndPath
    - generateinitialPopulation
    - performSimulation 
    - poinsToClose
    - /pathGeneration - generates the paths for each ship
