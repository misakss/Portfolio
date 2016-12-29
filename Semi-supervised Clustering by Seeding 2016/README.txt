In main: 

1. Choose which dataset to use by using the parameter dataSet.

2. Choose number of cluster wanted by setting the parameter k.

3. kmeans(dataSet,k), kmeans(dataSet,k,seed), kmeans(dataSet,k,seed,cons) will use the
   standard K-Means clustering algorithm, Seeded K-Means clustering algortihm and 
   Constrained K-Means clustering algorithm respectively.

4. The function plotClusters only work for 2D-data.

5. The function evaluate need the true labels as input (y), which only exist for Dataset 2.

6. To change the size of the seed-sets, go to the function seeding and change the parameter sub_rate.