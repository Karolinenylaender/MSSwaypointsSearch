# plot boxplots
import csv
import json
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
import scipy.io as sio
from matplotlib import gridspec

shipNames = ["mariner", "remus100", "nspauv"]

numSubpaths = [5, 6, 6]
numExperiments = 30
searchNames = ["randomSearch", "minDistanceMaxPath", "halfPopSearch", "randInit"]

baseResultsPath = '/Users/karolinen/Documents/MATLAB/Simulators/ExperimentsResults/ProcessedResults/'


def loadValues(baseResultsPath, ship, search, searchName):
    resultsPath = baseResultsPath + ship + "/" + search + "-QI-values.mat"
    print(resultsPath)
    HVresultsMat = sio.loadmat(resultsPath)
    HVresults  = HVresultsMat.get(searchName)
    HVresults = HVresults.flatten()

    return HVresults


for ship in shipNames:
    HVrandom = loadValues(baseResultsPath, ship, "randomSearch", "randomSearchScores")
    HVseed   = loadValues(baseResultsPath, ship, "minDistanceMaxPath","seedNSGAscores")
    HVcomb   = loadValues(baseResultsPath, ship, "halfPopSearch", "mixedNSGAScores")
    HVrnd    = loadValues(baseResultsPath, ship, "randInit", "randomNSGAScores")
    HVresults = [HVrandom.tolist(), HVseed.tolist(), HVcomb.tolist(), HVrnd.tolist()]
    

    labels = ["RndSearch", "WPgen$_{seed}$", "WPgen$_{comb}$", "WPgen$_{rnd}$"]
    palette = ['r', 'g', 'b', 'y']

    fig, ax = plt.subplots()

    ax.set_ylabel("Quality indicator: HV")

    ax.set_title('Hypervolume distribution for vessel ' + ship)
    ax.boxplot(HVresults, labels=labels)


# show plot
plt.show()



        
        
