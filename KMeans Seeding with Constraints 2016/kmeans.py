# -*- coding: utf-8 -*-
"""
Created on Wed Oct  5 22:40:41 2016

@author: Martin Isaksson
"""

#from string import *
#import sys
import numpy as np
import matplotlib.pyplot as plt
#from pylab import *
from sklearn import datasets
from random import randint
import time
from scipy.spatial.distance import cdist
#from sklearn.datasets.samples_generator import make_blobs
from amltlearn.datasets import make_blobs
from numpy.random import normal
iris = datasets.load_iris()

# Function: Constraint
# -------------
# Compute kmeans with constraint, which
# is that the seeding set S keeps their labels 
# and don't get used in the kmeans algorithm
# again
def constraint(dataSet, idx_seed_labels, part1_labels, k):
    new_dSet=np.delete(dataSet, idx_seed_labels, axis=0)
    idx_part2_labels=np.delete(np.array(range(0,dataSet.shape[0])), idx_seed_labels)
    centroids,part2_labels=kmeans(new_dSet,k)
    labels=np.zeros([dataSet.shape[0],dataSet.shape[1]+1])
    labels[idx_seed_labels,:]=part1_labels
    labels[idx_part2_labels,:]=part2_labels
    return centroids,labels 
    
# Function: Seeding
# -------------
# Return seeds from the subset S to 
# better initialize the centroids for the 
# kmeans algorithm. Subsample by 10%
def seeding(dataSet, k):
    sub_rate=0.1
    S=dataSet[::round(sub_rate*dataSet.shape[0])]
    centroids,labels=kmeans(S,k)
    idx_tmp=np.array(range(dataSet.shape[0]))
    idx_seed_labels=idx_tmp[::round(sub_rate*dataSet.shape[0])]
    return centroids,labels,idx_seed_labels

# Function: Get Number of Features
# -------------
# Returns the number of features in the dataSet
def getNumFeatures(dataSet):
    numFeatures=dataSet.shape[0]
    return numFeatures

# Function: Get Random Centroids
# -------------
# Returns the randomized centroids    
def getRandomCentroids(numFeatures, k, dataSet):
    # An alternative aproach is to choose the k datasamples 
    # that have the largest Euclidean Distance
    centroids=np.zeros([k,2])
    for i in range(0,k):
        centroids[i]=dataSet[randint(0,numFeatures-1)]
    return centroids
        
# Function: Should Stop
# -------------
# Returns True or False if k-means is done. K-means terminates either
# because it has run a maximum number of iterations OR the centroids
# stop changing.
def shouldStop(oldCentroids, centroids, iterations):
    MAX_ITERATIONS=1000
    if iterations > MAX_ITERATIONS: 
        print('STOP: Reason: Too many iterations')
        return True    
    elif oldCentroids==None:
        return False
    elif len(oldCentroids)!=len(centroids):
        return False
    return (centroids==oldCentroids).all()

# Function: Get Labels
# -------------
# Returns a label for each piece of data in the dataset. 
def getLabels(dataSet, centroids, numFeatures, k):
    # For each element in the dataset, chose the closest centroid. 
    # Make that centroid's index the element's label.
    ext_dataSet=np.zeros(numFeatures)
    labels=np.column_stack((dataSet,ext_dataSet))
#    d=np.zeros([numFeatures,k])
    c_idx=np.zeros(numFeatures)
    dist=cdist(dataSet,centroids,'euclidean')
    for i in range(0,numFeatures):
        c_idx[i]=np.where(dist[i,:]==dist[i,:].min())[0][0]
#    for i in range(0,numFeatures):
#        for j in range(0,k):
#            d[i,j]=np.sqrt(sum((dataSet[i,:] - centroids[j,:]) ** 2))    
#        c_idx[i]=np.where(d[i,:]==d[i,:].min())[0][0]    
    labels[:,-1]=c_idx
    return labels

# Function: Get Centroids
# -------------
# Returns k random centroids, each of dimension n.
def getCentroids(dataSet, labels, k, numFeatures):
    # Each centroid is the geometric mean of the points that
    # have that centroid's label. Important: If a centroid is empty (no points have
    # that centroid's label) you should randomly re-initialize it.
    centroids=np.zeros([k,dataSet.shape[1]])
    x=np.zeros([numFeatures,dataSet.shape[1]])
    for i in range(0,k):
        if any(labels[:,-1]==i):
            idx=np.where(labels[:,-1]==i)[0]
            X=dataSet[idx,:]
            div=X.shape[0]
            for j in range(0,dataSet.shape[1]):
                x[:,j]=np.array(sum(X[:,j])/div)
            centroids[i]=x[i,:]    
#            x=dataSet[idx,0]
#            y=dataSet[idx,1]
#            x_div=x.shape[0]
#            y_div=y.shape[0]
#            x_c=sum(x)/x_div
#            y_c=sum(y)/y_div
#            centroids[i]=np.array([x_c,y_c])
        elif all(labels[:,-1]!=i):
            centroids[i]=getRandomCentroids(numFeatures, 1, dataSet)
    return centroids

# Function: Plot Clusters
# -------------
# Plot the clusters in different colors.
def plotClusters(labels):
    color=['g','c','m','y','k','w','b','r','g','c','m','y','k','w','b','r'] # For max 8 different clusters
    l=list(set(labels[:,-1]))
    for i in range(0,len(l)):
        idx=np.where(labels[:,-1]==i)[0]
        plt.scatter(labels[idx,0], labels[idx,1],c=color[i])
            
# Function: K Means
# -------------
# K-Means is an algorithm that takes in a dataset and a constant
# k and returns k centroids (which define clusters of data in the
# dataset which are similar to one another).
def kmeans(dataSet, k, seed=None, cons=None):
	
    # Initialize centroids randomly or by seeding
    numFeatures = getNumFeatures(dataSet)
    if seed==None and cons==None:
        centroids = getRandomCentroids(numFeatures, k, dataSet)
    elif seed!=None or cons!=None:
        centroids,part1_labels,idx_seed_labels=seeding(dataSet,k)
        if cons!=None:
            centroids,labels=constraint(dataSet, idx_seed_labels, part1_labels, k)
    
    # Initialize book keeping vars.
    iterations = 0
    oldCentroids = None
    
    # Run the main k-means algorithm
    while not shouldStop(oldCentroids, centroids, iterations):
        # Save old centroids for convergence test. Book keeping.
        oldCentroids = centroids
        iterations += 1
        
        # Assign labels to each datapoint based on centroids
        labels = getLabels(dataSet, centroids, numFeatures, k)
        
        # Assign centroids based on datapoint labels
        centroids = getCentroids(dataSet, labels, k, numFeatures)
        
    # We can get the labels too by calling getLabels(dataSet, centroids, numFeatures, k)
    return centroids,labels

start_time = time.time()
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
#x=iris['data'][:, 3]    
#y=iris['data'][:, 2]
#dataSet=np.column_stack((x,y))

#X, y = make_blobs(n_samples=[25,200], n_features=2, centers=[[1,1], [0,0]], cluster_std=[0.1,0.4])
#dataSet=X

size1 = 75
size2 = 75
data = np.zeros((size1+size2,2))

data[0:size1, 0] = normal(loc=0.0, scale=0.1, size=size1)
data[0:size1, 1] = normal(loc=0.0, scale=0.6, size=size1)
data[size1:, 0] = normal(loc=0.75, scale=0.1, size=size2)
data[size1:, 1] = normal(loc=0.0, scale=0.6, size=size2)

dataSet=data

k=2 # Number of clusters
seed=1 # To run kmeans with seeding, if not just use 2 inputs in the algorithm
cons=1 # To run kmeans with constraint, if not just use 2 or 3 inputs in the algorithm
centroids,labels=kmeans(dataSet,k,seed,cons)

print("--- %s seconds ---" % (time.time() - start_time))
#plt.figure(figsize=(10,10))
#plt.scatter(x, y)
plotClusters(labels)
plt.scatter(centroids[:,0], centroids[:,1], c='r')
plt.show()




