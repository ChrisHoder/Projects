import numpy as np
import scipy
from scipy.cluster.vq import vq, kmeans, whiten


features  = np.matrix([[ 1.9,2.3],
                    [ 1.5,2.5],
                    [ 0.8,0.6],
                    [ 0.4,1.8],
                    [ 0.1,0.1],
                    [ 0.2,1.8],
                    [ 2.0,0.5],
                    [ 0.3,1.5],
                    [ 1.0,1.0]])
print features
whitened = whiten(features)
print "whitened", whitened
centroids, variance = kmeans(whitened,4)
#centroids == codebook, variance == distortion
#centroids, variance = kmeans(features,2)
print centroids
print variance
code, distance = vq(features,centroids)
print "code", code
print "distance", distance

print "length of code", len(code)
print "length of features", len(features)

#matrix of code
print code.T 
a= np.matrix(code)
print  a
b = a.transpose()
print b
print  b[3,0]
#print mCode.T, "\n"
#print mCode.T[0,3]