

import csv
import json
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
import scipy.io as sio
from matplotlib import gridspec


ships = [ "remus100"] #, "nspauv", "mariner"]

numSubpaths = [5, 6, 6]
numExperiments = 30
searchNames = ["randomSearch", "minDistanceMaxPath", "HalfHalfMutation", "randInitPop"]
#searchNames = ["RndSearch", "WPgenSeed", "WPgenComb", "WPgenRnd"]
searchNames = ["WPgenSeed", "WPgenComb", "WPgenRnd"]

baseResultsPath = '/Users/karolinen/Documents/MATLAB/Simulators/ExperimentsResults/ProcessedResults/'


def generate_heatmap(data,xticks, yticks, shipname, title):
    fig, ax = plt.subplots(figsize=(10,6))
    #im = ax.imshow(resultsDatalimited)
    #ax= sns.heatmap(resultsDatalimited, annot=True, cmap=sns.cubehelix_palette(as_cmap=True), cbar=True, xticklabels=xticks, yticklabels=yticks,  linewidths=5)
    cmapColor = "YlGnBu" #YlGnBu #sns.cubehelix_palette(as_cmap=True)
    vmax = np.max(data[:,:-1])
    ax= sns.heatmap(data, annot=True, cmap=cmapColor,vmax= vmax, cbar=True, xticklabels=xticks, yticklabels=yticks,  linewidths=0.25, square=False)
    print(data)

    #for text in ax.texts:
    #    text.set_fontsize(20)   

    plt.axvline(x=20, color='black', linestyle=':', linewidth=2) 
    plt.yticks(rotation=0)

    plt.axvline(x=len(xticks)-1, color='black', linestyle=':', linewidth=2)  # After Style columns
    plt.axhline(y=4, color='black', xmin=-5, linestyle=':', linewidth=2)  # After Style columns
    plt.axhline(y=8, color='black', linestyle=':', linewidth=2)  # After Style columns
    #plt.axhline(y=12, color='black', linestyle=':', linewidth=2)  # After Style columns

    #ax.text(-1.5, 2, "RS", ha='center', va='center', fontsize=12, fontweight='bold')
    ax.text(-1.5, 2, "WPgen$_{seed}$", ha='center', va='center', fontsize=12, fontweight='bold')
    ax.text(-1.5, 6, "WPgen$_{comb}$", ha='center', va='center', fontsize=12, fontweight='bold')
    ax.text(-1.5, 10, "WPgen$_{rnd}$", ha='center', va='center', fontsize=12, fontweight='bold')

    


    #plt.title("Count of different types for each subpath for vessel " + shipname, fontsize=14, fontweight='bold')
    plt.tight_layout()
    plt.show() 
    

def create_df_from_mat(base_file_path, ship, searchApproaches, numSubpaths):
    combinedSearchesResultsFull = []
    combinedSearchesResultsLimited = []
    for search in searchApproaches:

        resultsPathfull = baseResultsPath + ship + "/" +search+ "-full"  + "-typesOfPaths.mat"
        #resultsPathlimited = baseResultsPath + ship +"/" +search+"-limited" + "-typesOfPaths.mat"
        #print(resultsPathfull)
        #filepath = base_filep_path + ship + search
        resultsDatafullMAT = sio.loadmat(resultsPathfull)
        resultsDatafull = resultsDatafullMAT.get("countOfEachType")
        #resultsDatalimitedMAT = sio.loadmat(resultsPathlimited)
        #resultsDatalimited = resultsDatalimitedMAT.get("countOfEachType")

        #print(resultsDatafull)
        #print(resultsDatalimited)
        if len(combinedSearchesResultsFull) == 0:
            #print(np.size(resultsDatafull))
            combinedSearchesResultsFull = resultsDatafull
        else:
            #print(np.size(combinedSearchesResultsFull))
            #print(np.size(resultsDatafull))
            combinedSearchesResultsFull = np.append(combinedSearchesResultsFull, resultsDatafull, axis=0)
        #if len(combinedSearchesResultsLimited) == 0: 
        #    combinedSearchesResultsLimited = resultsDatalimited
        #else:
        #    combinedSearchesResultsLimited = np.append(combinedSearchesResultsLimited, resultsDatalimited, axis= 0)
    #print(combinedSearchesResultsFull)
    #print(np.shape(combinedSearchesResultsFull))
    #print(np.shape(combinedSearchesResultsLimited))
    #print(combinedSearchesResultsLimited)

    xticks = [f"SP{i}" for i in range(1, numSubpaths + 1)]+ ["Total"]
    yticks = ["Straight", "Semi-unstable", "Unstable", "Missing"]*len(searchApproaches)
    #print(np.shape(combinedSearchesResultsFull))
    print(combinedSearchesResultsFull[:,5]/30)
    generate_heatmap(combinedSearchesResultsFull, xticks, yticks, ship, "full")
    
    #generate_heatmap(combinedSearchesResultsLimited, xticks, yticks, ship, "limited")


    #thresholdPaths = resultsData.get('limitedAllPathsEvaluations')
    #allPaths = resultsData.get('allPathsEvaluations')
    
    #plt.show()


create_df_from_mat(baseResultsPath, "mariner", searchNames, 5)
create_df_from_mat(baseResultsPath, "remus100", searchNames, 6)
create_df_from_mat(baseResultsPath, "nspauv", searchNames, 6)   


