import Tkinter, tkFileDialog
import math
import random
import numpy as np
import matplotlib as mpl

mpl.use('macosx')
import pylab

import math

# This class is used for creating and managing the viewing parameters and view transforamtion matrix for data visualization
class View:
    
    # this method will initialize all of the internal data storage with default values.
    def __init__(self):
        self.vrp = np.matrix([0.5,0.5,1.0])
        self.vpn = np.matrix([0.0,0.0,-1.0])
        self.vup = np.matrix([0.0,1,0.0])
        self.u = np.matrix([1,0.0,0.0])
        self.extent = np.matrix([1.0,1.0,1.0])
        self.screen = np.matrix([400.0,400.0])
        self.offset = np.matrix([20.0,20.0])
        
    
    # The following methods are a bunch of getter and setter methods for manipulating the internal
    # data that is stored
    
    def getVRP(self):
        return self.vrp
    
    def setVRP(self,vrp):
        self.vrp = vrp
    
    def getVPN(self):
        return self.vpn
    
    def setVPN(self,vpn):
        self.vpn = vpn
    
    def getVUP(self):
        return self.vup
    
    def setVUP(self, vup):
        self.vup = vup
    
    def getU(self):
        return self.u
    
    def setU(self,u):
        self.u = u
    
    def getExtent(self):
        return self.extent
    
    def setExtent(self, extent):
        self.extent = extent
    
    def getScreen(self):
        return self.screen
    
    def setScreen(self,screen):
        self.screen = screen
    
    def getOffset(self):
        return self.offset
    
    def setOffset(self,offset):
        self.offset = offset
    
    
    # This method will build the view transformation matrix (VTM) that will be returned. This method will contain the transformations to
    # move and rotate the data in to the screen coordinates.
    def build(self):
        #create identity matrix
        vtm = np.identity(4, float)
        # translation matrix to move the VRP to the origin 
        t1  = np.matrix( [[   1,0,0,-self.vrp[0,0]],
                         [   0,1,0,-self.vrp[0,1]],
                         [   0,0,1,-self.vrp[0,2]],
                         [   0,0,0,1]] )
        
        
        #add translation to VTM
        vtm = t1*vtm
        
        #calculate the reference axes
        tu   = np.cross(self.vup, self.vpn)
        tvup = np.cross(self.vpn, tu)
        tvpn = np.copy( self.vpn)
        
        #Normalize and save new reference axes
        self.u = self.normalize(tu)
        self.vup = self.normalize(tvup)
        self.vpn = self.normalize(tvpn)
        
    
        #align the axes
        r1 = np.matrix([[ self.u[0,0],   self.u[0,1],   self.u[0,2],   0.0],
                        [ self.vup[0,0], self.vup[0,1], self.vup[0,2], 0.0],
                        [ self.vpn[0,0], self.vpn[0,1], self.vpn[0,2], 0.0],
                        [ 0.0          , 0.0          , 0.0          , 1.0 ] ])
        #add alignment to the vtm  
        vtm = r1*vtm

        
        #Translate the lower left corner of the view space to the origin.
        vtm = self.translate(0.5*self.extent[0,0], 0.5*self.extent[0,1], 0) * vtm
        
        #Uses the extent and screen size values to scale the screen
        vtm = self.scale(-(self.screen[0,0] / self.extent[0,0]),(-self.screen[0,1] / self.extent[0,1]), 1.0/self.extent[0,2])*vtm
        
        #translate the lower left corner to the origin and  and add the view offset
        vtm = self.translate(self.screen[0,0] + self.offset[0,0], self.screen[0,1] + self.offset[0,1], 0) * vtm
        #return the vtm to the caller
        return vtm
    
    # This will rotate our data about the center of the view volumn. The input angles are the angles of rotation of the VUP and U vectors respectively in radians.
    # This method has no outputs but will change the internallys stored vector data.
    def rotateVRC(self, angleVUP, angleU):
        # axis alignment matrix using u, vup and vpn
        Rxyz = self.alignMatrix()
        # translation matrix to move the center point to the origin
        alongVPN = self.vrp + 0.5*self.extent[0,2]*self.vpn
        t1 = self.translate(-alongVPN[0,0], -alongVPN[0,1], -alongVPN[0,2])
        #t1   = self.translate( -self.vrp[0,0], -self.vrp[0,1], -self.vrp[0,2] - self.extent[0,2]*0.5)
        #rotation matrix about hte y axis by the VUP angle
        r1   = self.rotateY(angleVUP)
        # rotation matrix about the x axis by the U angle
        r2   = self.rotateX(angleU)
        # reverse translation matrix to move the data back to where it was
        t2   = t1.I

        #create a matrix with all of the data in it
        tvrc = np.vstack((self.vrp, self.u, self.vup, self.vpn))
        tH   = np.matrix([ 1       , 0     , 0       , 0])
        # add homogeneous coordinate
        tvrc = np.hstack((tvrc,tH.T))
        
        # rotate data
        tvrc = (t2*Rxyz.T*r2*r1*Rxyz*t1*tvrc.T).T
    
        # assign new vrp,u,vup,vpn locations
        self.vrp = tvrc[0,:3]
        self.u   = self.normalize(tvrc[1,:3])
        self.vup = self.normalize(tvrc[2,:3])
        self.vpn = self.normalize(tvrc[3,:3])
        
        #done
        return
        
    
    # This method will create a translation matrix. The inputs are xExtent,yExtent,zExtent which translate the x,y,z components respectively. The returned numpy matrix is 4x4
    def translate(self, xExtent, yExtent, zExtent):
        t = np.matrix([ [1.0,0.0,0.0,xExtent],
                        [0.0,1.0,0.0,yExtent],
                        [0.0,0.0,1.0,zExtent],
                        [0.0,0.0,0.0,1.0]])
    
        return t
                
    # This method will return a scale matrix. The inputs are as follows: xScale, yScale, zScale are the x, y, and z scales respectively. 
    # This method is used by the rotateVRC and the build methods to do data transformations. the returned numpy matrix is a 4x4 matrix    
    def scale(self,xScale,yScale,zScale):
        s = np.matrix([ [xScale,0     ,0     ,0],
                        [0     ,yScale,0     ,0],
                        [0     ,0     ,zScale,0],
                        [0     ,0     ,0     ,1]])

        return s
    # This method will return a rotation matrix about the x-axis. The input is the angle in radians with which to rotate.
    # This method is used by the rotateVRC method to do rotations.
    def rotateX(self, angle):
        r = np.matrix([ [1, 0            , 0             , 0],
                        [0, np.cos(angle), -np.sin(angle), 0],
                        [0, np.sin(angle), np.cos(angle) , 0],
                        [0, 0            , 0             , 1]])
        return r
    
    # This method will return a rotation matrix about the y-axis. The input is the angle in radians with which to rotate.
    # This method is used to do data transformations
    def rotateY(self,angle):
        r = np.matrix([ [np.cos(angle) ,0,np.sin(angle),0],
                        [0             ,1,0            ,0],
                        [-np.sin(angle),0,np.cos(angle),0],
                        [0             ,0,0            ,1]])
        return r
    
    #This method will return a rotation matrix about the z-axis. The input is the angle in radians with which to rotate. 
    # This method is used for data transformations.
    def rotateZ(self,angle):
        r = np.matrix([ [np.cos(angle),-np.sin(angle),0,0],
                        [np.sin(angle),np.cos(angle) ,0,0],
                        [0            ,0             ,1,0],
                        [0            ,0             ,0,1]])
        return r
     
     # This method will create an alignment matrix used align the data along our standard euclidean axes using u, vup and vpn. 
     # It is used in the rotateVRC method to align the axis before rotation.
    def alignMatrix(self):
        v = np.matrix([ [self.u[0,0]  , self.u[0,1]  , self.u[0,2]  , 0],
                        [self.vup[0,0], self.vup[0,1], self.vup[0,2], 0],
                        [self.vpn[0,0], self.vpn[0,1], self.vpn[0,2], 0],
                        [0            , 0            , 0            , 1],
                        ])
        return v
        
    # This method will take in a numpy matrix ( row vector) and return a normalized vector. i.e. the same vector divided by the magnitude. 
    # This method is used to get a normalized u, vup, vpn vectors in our view class 
    def normalize(self,vector):
        mag = math.sqrt(vector[0,0]*vector[0,0]+ vector[0,1]*vector[0,1]+vector[0,2]*vector[0,2])
        normVect = np.matrix([vector[0,0]/mag,vector[0,1]/mag,vector[0,2]/mag])
        return normVect
    
    
    # This method will take in a different view object. The method will copy all the internally stored data (i.e. u,vup,vpn,vrp, extent,offset...)
    # to the input view object and return the input view object which is now a copy. The purpose of this method is to copy the view object. 
    #This is useful when using the view object to manipulate data. By creating a copy we are able to return to the beginning state much easier.
    def copy(self, viewObj):
        viewObj.vrp = self.vrp
        viewObj.vpn = self.vpn
        viewObj.vup = self.vup
        viewObj.u   = self.u
        viewObj.extent = self.extent
        viewObj.screen = self.screen
        viewObj.offset = self.offset
        
        return viewObj


    # This method will print out all of the stored data within the view class in an easy to read syntax.
    # This is largely used in debugging and setting parameters for the GUI which would run the view class.
    def printData(self):
        print "vrp", self.vrp
        print "vpn", self.vpn
        print "vup", self.vup
        print "u", self.u
        print "extent", self.extent
        print "screen", self.screen
        print "offset", self.offset