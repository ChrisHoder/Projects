import Tkinter, tkFileDialog
import math
import random
import numpy as np
import matplotlib as mpl
import csv
from csvWriter import *

mpl.use('macosx')
import pylab

import math

# This class does data analsis
class Analysis:
    
    def __init__(self, name, data, filename = 'test.csv', writeFile = False):
        #A user-supplied name for the analysis
        self.name = None
        #a numpy matrix to hold a copy of the data used for the analysis
        self.data = np.matrix(np.copy(data))
        #normalized data
        self.norm = None
        #a numpy matrix to hold the data projected onto the eigenvalues
        self.pcadata = None
        #the minimum for each data column
        self.min = None
        #the maximum value for each data column
        self.max = None
        #the mean value for each data column
        self.mean = None
        #the eigenvalues
        self.eval = None
        #the eigenvectors
        self.evec = None
        #save the filename
        self.filename = filename
        #save the boolean if we are writing or not (true == write to file)
        self.writeFile = writeFile
        
        self.initialize()
        self.setup()
        
    # This method will initialize all of the data fields for the analysis
    def initialize(self):
        # get the minimum values
        self.min = []
        self.max = []
        self.mean = []
        columns = np.size(self.data,axis=1)
        normalizedData = ()
       # for each column of the PCA data input, get the max, min and normalize it
        for i in range(0,columns):
            #get the column
            data = self.data[:,i]
            #add min,max
            self.min.append(data.min(0).tolist()[0][0])
            self.max.append(data.max(0).tolist()[0][0])
            #if all the values are the same this will cause an infinite number
            # in the normalized, just set this columns to all zeros
            if( self.min[i] == self.max[i]):
                normlizedcol = data-self.min[i]
            else:
                normalizedcol = (data-self.min[i])/(self.max[i]-self.min[i])
            self.mean.append(normalizedcol.mean().tolist())
            #create final normalized data
            normalizedData += (normalizedcol, )
            
        #print "mean", self.mean
        #turn it into a matrix
        norm = np.hstack((normalizedData))
        self.norm = norm
        #print "normalized data", self.norm, "\n"   
    
    # returns the list of eigenvalues as a copy
    def getEigVal(self):
        return np.copy(self.eval)
    
    # somewhat neatly prints out the data to the command line
    def printData(self):
        print "max ", self.max, "\n"
        print "min ", self.min, "\n"
        print "mean ", self.mean, "\n"  
        print "PCA Data \n", self.pcadata, "\n"
    
    # This does the pca data analysis and projection
    def setup(self):
        #compute covariance matrix
        mcov = np.cov( self.norm,rowvar = False)
        print "mcov"
        print mcov
        #get the eiganvalues and eigenvectors
        (meigval, meigvec) = np.linalg.eig( mcov )
        #save data
        self.eval = meigval
        self.evec = meigvec
        #print "meigval"
        #print meigval
        #print "meigvec \n", meigvec
        
        #get the size of the data (number of variables)
        columns = np.size(self.data,axis=1)
        #pca data holder
        pdata = ()
        #for each row in the normalized matrix
        for row in self.norm:
            #difference between the row and the mean
            deltaData = row - self.mean
            pdataRow = deltaData * np.matrix( self.evec )
            pdata += (pdataRow, )
        #turn it into a matrix
        self.pcadata = np.vstack((pdata))
        self.type = []
        for element in self.eval:
            self.type.append("numeric")
        
        #if we wanted to write file do so
        if( self.writeFile == True):
            file = csvWriter(data = self.pcadata, filename = self.filename, headers = self.eval, types = self.type)
        
        
        #print the data to the command line
        self.printData()
        #print "pcadata " , self.pcadata
        # print "\n"
        
    # this returns the size of the data that is being done
    def size(self):       
        return len(self.data)
    
    # This returns the column number associated with the eigenvalues
    # will return -1 if the value is not in the list of eigenvalues
    def getColumn(self, value):
        colNum = 0
        for val in self.eval:
            if( value == val):
                return colNum
            colNum += 1
        return -1
    
    #Selects a subset of the pca data and returns it as a numpy matrix
    def select(self, indices):
        #if no Pca data (check)
        if( self.pcadata == None):
            return None
        # create a tuple to hold the columns
        selected_Num_tup = ()
        for index in indices:
            # add the column to the tuple
            selected_Num_tup += (self.pcadata[:,index], )
        #return the stack
        return np.hstack((selected_Num_tup))

    def writeData(self, filename = 'test.csv'):
        file = csvWriter(data = self.pcadata, filename = filename, headers = self.eval, types = self.type)
        