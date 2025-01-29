# Experiment data
The experiments data are stored here for each vessel and approach: 
https://www.dropbox.com/scl/fo/mb4ja58ibffrn2gdks4tg/AIKDvxc8oZD9b2vXdI0bPOk?rlkey=mgnn74mhhwydmi7daw4tpcpgb&st=62pwj7vu&dl=0


# Usage Guide
## Step 1: Installation
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

## Step 2: Set the correct matlab files

1. Go to the file 'setupProject' and check that the folder names 'MSS' and 'PlatEMO' corresponds with what you have called the PlatEMO and MSS folders
```
addFolderToPath("BIMK-PlatEMO-4.7.0.0/PlatEMO/")
addFolderToPath("MSS")
```

2. Run the setupProject.m script 
```
setupProject.m
```


## Step 3:  Run the experiments
1. Go to the file 'runExperiments.m'
2. In the file you can choose
* Vessel type: "mariner", "nspauv" and "remus100"
* Algorithm type: "rndSearcoh", "WPgenSeed", "WPgenComb" or "WPgenRnd" 
* Number of experiments (default is 30)
* Path to save the data (defaullt is the folder ExperimentsResults/)
* Population size (default is 10)
* Number of generations (default is 1000)

To run one experiment you can call the function
```
 performSearch(ship, searchProcess, resultsPath, experimentNumber, numGenerations, populationSize)
```

## Step 4: Evaluate the generated waypoints and paths 
*Structure of experiments*
Inside the folder 'ExperiementsResults' there is a folder for each vessel. 
The name of each file indicates the type of search that is performed
> e.g ExperiementsResults/remus100/WPgenComb-P10-exNum51-g2 is the results for
> * Vessel = remus100
> * search method: WPgenComb
> * population size: 10
> * experiment number 51
> * generation number: 2 

Loading this file you can find: 
* 'Population': the Population for the current generation
* 'Path': a map that cointains the 'fullpath', 'angles' and 'transitionIndices' for each individual in the population. 
* * The 'fullpath' is the path of the vessel
* * The 'angles' is the angles of the vessel
* * the 'transitionIndices' is the at which sampling step the vessels reaches a waypoint and redirects its trajectory to the following waypoint. 


# Folder structure
## ShipProblems/
* shipWaypointsSearch.m userproblem for a vessel
* loadShipSearchParameters.m loads the parameters for the vessel
* commonFunctions/ (help functions)
* * calculateSegmentLengths.m
* * evalauteWaypointsAndPath.m
* * generateInitialPopulation.m
* * performSimulation.m
* * pointsToClose.m
* * splitDataBetweenWaypoints.m
* * pathGeneration/ 
* * * paths for each vessel


## NSGA-II-Adapted/
* EnvironmentalSelection.m 
* GArealPoints.m performs crossover and mutation 
* WPgen.m
* RandomSearchPopulation.m
* savePopulation.m


*Evaluate experiments*
Located inside folder ProcessResultsFolder:
* pareto_HV/
* evaluationFunctions/
* * 

* categorize path
* evaluationFunction
* robustNess



