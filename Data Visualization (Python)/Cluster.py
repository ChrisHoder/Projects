# some help on implementing the clustering was recieved from the following blog
# http://www.janeriksolem.net/2009/04/clustering-using-scipys-k-means.html
import numpy as np
import scipy
from scipy.cluster.vq import vq, kmeans, whiten

class Cluster:
    
    #init function
    def __init__(self):

        #unique identifier for the cluster
        self.name = None
        
        #a list of the headers used to create the clustering
        self.headers = None
        
        #the number of clusters
        self.k = None
        
        # the set of cluster means
        self.means = None
        
    # this will whiten the data using the scipy.cluster.vq whiten method and return it
    def whitenData(self, data):
        return whiten(data)
        
    # takes in a name, list of headers, number of clusters, and a numpy matrix with each data point as a row. executes k-mean clustering. 
    # the name, headers, and k are copied into the Cluster object and the means is generated by the clustering
    def kmeans(self, name, headers, k, data, whiten = False):
        #copy values into Cluster object
        self.name = name.rstrip()
        self.headers = []
        self.headers.extend(headers)
        
        self.k = k
        
        if( whiten == True):
            data = whiten(data)
        
        #clustering algorighm using the scipy methods
        #comments will relate variable names to documentation
        
        #centroids == codebook, variance == distortion
        centroids, variance = kmeans(data,self.k)
        self.means = centroids
        #code, distance = vq(data,centroids)
        
    #takes in a numpy matrix with each data point as a row and returns a 1-column matrix with the cluster ID of the closest cluster mean
    def classify(self, data):
        code,distance = vq(data,self.means)
        return np.matrix(code).transpose()
    
   
    