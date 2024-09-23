
## Installation
Clone the two github-repostiories: 
1. PlatEMO: https://github.com/BIMK/PlatEMO/tree/master
2. MSS: https://github.com/cybergalactic/MSS

Clone this project
1. Go to the file 'setupProject' and check that the folder names 'MSS' and 'PlatEMO' corresponds with what you have called the PlatEMO and MSS folders
2. Run the setupProject.m script 


## Run the experiments
1. Go to the file 'multiobjectiveSearch.m'
2. Choose between the following
- Ship type: "mariner", "nspauv" and "remus100"
- Algorithm type: "random" or "NSGA-ii"
- Number of experiments (default is 30)
- Path to save the data (defaullt is ...)
- Population size (default is 10)
- Number of generations (default is 1000)

Example of running:
    >>> multobjecte (22 )
 

## Evaluate experiments
Located inside folder
ExperimentsFunctions:
- categorize path
- evaluationFunction
- robustNess



# Folder structure
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
