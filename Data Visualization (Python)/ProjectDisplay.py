import Tkinter, tkFileDialog
import math
import random
import numpy as np
import matplotlib as mpl


mpl.use('macosx')
import pylab
import tkMessageBox
import tkSimpleDialog as tks
from plotDialog import *
from view import *
from dataRead import *
from Analysis import *
from PCADialog import *
from ClusterDialog import *
from filterDialog import *
from InfoBox import *
from getInput import *
from countInfo import *
import os
import colorsys
#from PIL import ImageTk, Image
# create a shorthand object for Tkinter so we don't have to type it all the time
tk = Tkinter

# create a class to build and manage the display application

#all callback functions and initialization functions in this class

class DisplayApp:

	# init function
	def __init__(self, width, height):
		
		#motion ratio
		self.kn = 0.95
		self.Delta = np.matrix([0, 0, 0])
		self.offset = np.matrix([20,20])
		self.windowOffset = np.matrix([40,40])
		self.check = .001
		
		self.dxMin = 0.5
		self.dxMax = 10
		self.dxDefault = 3
		
		
		#store figure
		self.fig = None

		# create a tk object, which is the root window
		self.root = tk.Tk()

		# width and height of the window
		self.initDx = width
		self.initDy = height

		# set up the geometry for the window
		self.root.geometry( "%dx%d+50+30" % (self.initDx, self.initDy) )

		# set the title of the window
		self.root.title("D.I.V.A")

		# set the maximum size of the window for resizing
		self.root.maxsize( 1024, 768 )

		# bring the window to the front
		self.root.lift()

		# setup the menus
		self.buildMenus()

		# build the controls
		self.buildControls()
	
		#build point locator
		self.buildLocation()
	
		# build the objects on the Canvas
		self.buildCanvas()

		

		# set up the key bindings
		self.setBindings()

		# set up the application state
		self.objects = []
		self.data = tuple()
		self.dataObject = None
		
		#@add to build axes function
		
		#create a view object
		self.viewObj = View()
		self.viewObj.setScreen(screen = (np.matrix([width, height])-self.windowOffset))
		#print self.viewObj.getScreen()
		
		#axes labels get initialized
		self.xAxisLabel = StringVar()
		self.xAxisLabel.set("x")		
		self.yAxisLabel = StringVar()
		self.yAxisLabel.set("y")
		self.zAxisLabel = StringVar()
		self.zAxisLabel.set("z")
		self.xlabel = None
		self.ylabel = None
		self.zlabel = None
		
		#initialize axes
		self.lines = []
		
		#picture is displayed first
		#self.buildAxes()
		#self.buildLabels()
		
		self.headerData = {}
		
		#Initialize values for the plotting functions
		self.size = None
		self.color = None
		self.normmatrix = None
		self.Analysis = None
		self.data_num = None
		
		#self.image = ImageTk.PhotoImage(Image.open('Diva.jpg'))
		self.image = Tkinter.PhotoImage(file = "diva.gif")
		self.imageWidget = self.canvas.create_image(width/2,height/2,image=self.image)
		
		#canvas.createLIne
		
	# this method will test to see if the header given is a numeric header or not
	# returns true if the header is a numeric dimension and false if it is not
	def testHeader(self,header):
		if(self.dataObject == None):
			tkMessageBox.showwarning("Bad input","No data loaded")
			return False
		
		return self.dataObject.testHeader(header)
	
	#this method will test to see if there is any data loaded.
	# this returns true if there is data loaded, false otherwise
	def dataTest(self):
		if( self.dataObject == None):
			return False
		else:
			return True
	
	# this method will return a list of the headers
	def getHeaders(self):
		return self.dataObject.header_num()
	
	
	# This method will build the bottom section of the display that will display the location in the graph of the point clicked on 
	# by the user when they use the control-mouse click option. 
	def buildLocation(self):
		
		self.infoFrame = tk.Frame(self.root)
		self.infoFrame.pack(side = tk.BOTTOM, padx=2,pady=2,fill=tk.X)
		#make a separator line
		sep = tk.Frame( self.root, height = 2, width = self.initDx, bd = 1, relief = tk.SUNKEN)
		sep.pack(side=tk.BOTTOM, padx=2, pady = 2, fill = tk.X)
		
		#create a string variable to access later when we the user clicks on a data
		self.locationVar = tk.StringVar()
		self.locationVar.set('Point')
		tk.Label(self.infoFrame, textvariable = self.locationVar).pack()
	
		return
	
	# This will create the axes on the canvas, based on the data stored in thew ViewObj
	def buildAxes(self):
		self.vtm = self.viewObj.build()
		# point location matrix
		self.points = np.matrix([ [ 0,1,0,0,0,0],
								  [ 0,0,0,1,0,0],
								  [ 0,0,0,0,0,1],
								  [ 1,1,1,1,1,1]])
		self.axes = self.vtm*self.points
		self.lines = []
		
		#draw axes
		
		# x-axis
		self.lines.append(self.canvas.create_line(self.axes[0,0],self.axes[1,0],self.axes[0,1],self.axes[1,1], fill="red"))
		# y-axis
		self.lines.append(self.canvas.create_line(self.axes[0,2],self.axes[1,2],self.axes[0,3],self.axes[1,3], fill="blue"))
		# z-axis
		self.lines.append(self.canvas.create_line(self.axes[0,4],self.axes[1,4],self.axes[0,5],self.axes[1,5], fill="yellow"))
		
		self.canvas.pack()
		
		
	def buildLabels(self):
		if( self.xlabel != None):
			#delete old labels
			self.canvas.delete(self.xlabel)
			self.canvas.delete(self.ylabel)
			self.canvas.delete(self.zlabel)
		
		#draw labels
		self.labels = np.matrix([ [ 0.5, 1,   0, 0,   0, 0],
								  [ 0  , 0, 0.5, 1,   0, 0],
								  [ 0  , 0,   0, 0, 0.5, 1],
								  [ 1  , 1,   1, 1,   1, 1]])
		offset = self.viewObj.getOffset()
		#bring the x axis label back to about halfway between the bottom axes and the end
		# of the plot
		#LabelTranslate = self.viewObj.translate(-offset[0,0], 0, 0)
		#xlabels = LabelTranslate*self.vtm*self.labels
		self.vtm = self.viewObj.build()
		labels = self.vtm*self.labels
		self.xlabel = self.canvas.create_text(labels[0,0]              ,labels[1,0] + offset[0,1]/2 , text = self.xAxisLabel.get())
		self.ylabel = self.canvas.create_text(labels[0,2]-offset[0,0]/2,labels[1,2] + offset[0,1]/2 , text = self.yAxisLabel.get())
		self.zlabel = self.canvas.create_text(labels[0,4]-offset[0,0]/2,labels[1,4] + offset[0,1]/2 , text = self.zAxisLabel.get())
		self.canvas.pack()
		
	# this will update the positions of the axes based on the data in the viewObj (i.e. creates a VTM)
	def updateAxes(self):
		# if the axes have not been created yet (picture is still there), do nothing
		if( len(self.lines) == 0):
			return
		#build the vtm
		self.vtm = self.viewObj.build()
		#multiply the axis endpoints by the vtm
		self.axes = self.vtm*self.points
		
		# for each line object 
			#update the coordinates of the object
		self.canvas.coords(self.lines[0],self.axes[0,0],self.axes[1,0],self.axes[0,1],self.axes[1,1] )
		self.canvas.coords(self.lines[1],self.axes[0,2],self.axes[1,2],self.axes[0,3],self.axes[1,3] )
		self.canvas.coords(self.lines[2],self.axes[0,4],self.axes[1,4],self.axes[0,5],self.axes[1,5] )
		
		

	def updateLabels(self):
		#if the labels have not yet been created (picture is still there), do nothing
		if( self.xlabel == None):
			return
		offset = self.viewObj.getOffset()
		self.vtm = self.viewObj.build()
		labels = self.vtm*self.labels
		self.canvas.coords(self.xlabel, labels[0,0]              , labels[1,0]+ offset[0,1]/2)
		self.canvas.coords(self.ylabel, labels[0,2]-offset[0,0]/2, labels[1,2]+ offset[0,1]/2)
		self.canvas.coords(self.zlabel, labels[0,4]-offset[0,0]/2, labels[1,4]+ offset[0,1]/2)

	# this method builds the menu items that will be accessible for the user when the display is open
	def buildMenus(self):
		
		# create a new menu
		self.menu = tk.Menu(self.root)

		# set the root menu to our new menu
		self.root.config(menu = self.menu)

		# create a variable to hold the individual menus
		self.menulist = []

		# create a file menu
		filemenu = tk.Menu( self.menu )
		self.menu.add_cascade( label = "File", menu = filemenu )
		self.menulist.append(filemenu)

		# create another menu for kicks
		cmdmenu = tk.Menu( self.menu )
		self.menu.add_cascade( label = "Command", menu = cmdmenu )
		self.menulist.append(cmdmenu)

		# menu text for the elements
		menutext = [ [ 'Open...', '-', 'Quit  \xE2\x8C\x98-Q' ],
					 [ 'Cluster \xE2\x8C\x98-C', 'Clean Data', 'PCA', 'Filter Data', 'Count Occurances', 'Print Data' ] ]

		# menu callback functions
		menucmd = [ [self.handleOpen, None, self.handleQuit],
					[self.handleCmd1, self.handleCmd2, self.handleCmdButton4, self.filterData,self.countData, self.printData] ]
		
		# build the menu elements and callbacks
		for i in range( len( self.menulist ) ):
			for j in range( len( menutext[i]) ):
				if menutext[i][j] != '-':
					self.menulist[i].add_command( label = menutext[i][j], command=menucmd[i][j] )
				else:
					self.menulist[i].add_separator()

	# create the canvas object
	def buildCanvas(self):
		# this makes the canvas the same size as the window, but it could be smaller
		self.canvas = tk.Canvas( self.root, width=self.initDx, height=self.initDy )
		#expand it to the size of the window and fill
		self.canvas.pack( expand=tk.YES, fill=tk.BOTH)
		return


	# build a frame and put controls in it
	def buildControls(self):

		# make a control frame
		self.cntlframe = tk.Frame(self.root)
		self.cntlframe.pack(side=tk.RIGHT, padx=2, pady=2, fill=tk.Y)

		# make a separator line
		sep = tk.Frame( self.root, height=self.initDy, width=2, bd=1, relief=tk.SUNKEN )
		sep.pack( side=tk.RIGHT, padx = 2, pady = 2, fill=tk.Y)

		# make a cmd 1 button in the frame
		self.buttons = []
		#width should be in characters. stored in a touple with the first one being a tag
		
		# this button will open a display for the user to plot the data
		self.buttons.append( ( 'cmd3', tk.Button( self.cntlframe, text="Plot", command=self.handleCmdButton3, width =5) ) )
		self.buttons[-1][1].pack(side = tk.TOP)
		# this will reset the graph image
		self.buttons.append( ( 'cmd1', tk.Button( self.cntlframe, text="Reset", command=self.handleCmdButton, width=5 ) ) )
		self.buttons[-1][1].pack(side=tk.TOP)  # default side is top
		# this will display the graph in a 3d type prespective
		self.buttons.append( ( 'cmd2', tk.Button( self.cntlframe, text="3D", command=self.handleCmdButton2, width=5 ) ) )
		self.buttons[-1][1].pack(side=tk.TOP)  # default side is top
		
		#this will do the data pca
		self.buttons.append( ( 'cmd4', tk.Button( self.cntlframe, text="PCA", command=self.handleCmdButton4, width=5) ) )
		self.buttons[-1][1].pack(side=tk.TOP) 
		#this will bring up a popup dialog to filter the data
		self.buttons.append( ( 'cmd5', tk.Button( self.cntlframe, text="Filter", command=self.filterData, width=5) ) )
		self.buttons[-1][1].pack(side=tk.TOP)
		
		#this will put a button on the window that will open up another dialog which will
		#allow the user to count the occurances of something happening given a certain condition
		self.buttons.append( ('comd7', tk.Button( self.cntlframe, text="Count", command = self.countData)))
		self.buttons[-1][1].pack(side=tk.TOP)
		
		#this will print the data to an html file
		self.buttons.append( ('cmd6', tk.Button( self.cntlframe, text = "Stats", command = self.printData, width = 5)))
		self.buttons[-1][1].pack(side=tk.TOP)
		
		
		
		#this adds a label which will show you the number of points in the data set
		tk.Label(self.cntlframe, text = "Points:").pack()
		self.Points = StringVar()
		self.Points.set("-")
		tk.Label(self.cntlframe, textvariable = self.Points).pack()
		
		#this adds the number of variables so that the user can view it
		tk.Label(self.cntlframe, text = "Variables:").pack()
		self.Variables = StringVar()
		self.Variables.set("-")
		tk.Label(self.cntlframe, textvariable = self.Variables).pack()
	
		return
	
	# This method will update the "number of points" stringVar
	# which displays the number of points in the current data set( as in filtered) on the 
	# right of the window for the user
	def upDatePoints(self):
		numPoints = self.dataObject.size()
		self.Points.set(str(numPoints))
		return

	# This method will update the "number of variables" stringVar 
	# which displays the number of variables on the right of the window
	def upDateVariables(self):
		variables = self.dataObject.dim()
		self.Variables.set(str(variables))
		return
	
	#This button will print out the data of the current data set to an
	#html file and then open it
	def printData(self):
		#check to see if the data is loaded
		test = self.checkData()
		if( test == False):
			return
		filename = StringVar()
		filename.set("stats.html")
		temp = getInput(parent = self.root, inputText = "filename:", entryVar = filename, title = "Choose filename to save data")
		#if the user did not input any filename
		if( filename.get() == ""):
			return
		check = self.dataObject.printDataHtml(filename.get(), filterDataBoolean = False, countStats = True)
		#check to see if the data was saved
		if( check == 1):
			#open the html file in a browser
			os.system("open " + filename.get())

	# This will set all the bindings for the different mouse/button clicks
	def setBindings(self):
		
		self.canvas.bind( '<Button-1>' , self.handleButton1 )
		self.canvas.bind( '<Button-2>' , self.handleButton2 )
		self.canvas.bind( '<Button-3>' , self.handleButton3 )
		self.canvas.bind( '<B1-Motion>', self.handleButton1Motion )
		self.canvas.bind( '<ButtonRelease-1>', self.handleButton1Release)
		self.canvas.bind( '<B2-Motion>', self.handleButton2Motion )
		self.canvas.bind( '<B3-Motion>', self.handleButton3Motion )
		self.root.bind( '<Command-q>', self.handleModQ )
		self.root.bind( '<Command-o>', self.handleModO )
		self.root.bind( '<Command-t>'  , self.countData)
		self.root.bind( '<Control-q>', self.handleQuit )
		self.root.bind( '<Control-c>', self.handleCmd1 )
		self.root.bind( '<Control-f>', self.filterData )
		self.canvas.bind( '<Configure>', self.resize)
		self.canvas.bind( '<Control-Button-1>', self.handleButton4)
		self.canvas.bind( '<Command-Button-1>', self.handleButton5)
		
	
	# This method will build the pca data graph based on the information from the pca analaysis (called when you click on the
	# pca button)
	def buildPCA(self):
		#reset size and color dim which are not used in this plot section
		self.size = None
		self.Color = None
		
		# delete the axes
		for i in range(len(self.objects)):
			self.canvas.delete(self.objects[i])
		self.objects = []
		
		#get x,y,z data points
		x = (self.pcadataHeader.get('x'))
		
		y = (self.pcadataHeader.get('y'))
		z = self.pcadataHeader.get('z')

		data1 = self.Analysis.select([x,y])
		
		
		#length of data
		leng = self.Analysis.size()
		#check to see if there is z data
		if( z == None):
			zData = np.zeros([leng, 1], float)
			data1 = np.hstack((data1,zData))
		else:
			#obtain z data from the dataObject
			zData = self.Analysis.select([z])
			data1 = np.hstack( (data1,zData) )
		
		
		#normalize matrix build
		max_values = []
		min_values = []
		max_values.append( data1[:,0].max())
		min_values.append( data1[:,0].min())
		max_values.append( data1[:,1].max())
		min_values.append( data1[:,1].min())
		max_values.append( data1[:,2].max())
		min_values.append( data1[:,2].min())
		
		if( z == None):
			scale = self.viewObj.scale(1/(max_values[0]-min_values[0]), 1/(max_values[1]-min_values[1]), 0)
		
		else:
			scale = self.viewObj.scale(1/(max_values[0]-min_values[0]), 1/(max_values[1]-min_values[1]), 1/(max_values[2]-min_values[2]))
		
		translate = self.viewObj.translate(-min_values[0], -min_values[1], -min_values[2])
		
		self.normmatrix = scale*translate
		
		#add a row of 1 to every data point
		hom = np.zeros([leng,1],float)
		#creates a column of just 1s
		hom = hom + 1;
		data1 = np.hstack((data1,hom));
		
		self.data_num = data1
	

	
		#build vtm
		vtm = self.viewObj.build()
		
		#plot the data on the graph.
		rowNum = 0
		for row in self.data_num:
			point = vtm * self.normmatrix * row.T
			
			#standard size
			dx = self.dxDefault
			#standard color
			rgb = "#%02x%02x%02x" % (0, 0, 0)
			
			#create and add oval
			oval  = self.canvas.create_oval( point[0,0]-dx, point[1,0]-dx, point[0,0]+dx, point[1,0]+dx, fill = rgb, outline = '')
			self.objects.append(oval)
			
			rowNum += 1
	
	def clearPoints(self):
		# delete the axes
		for i in range(len(self.objects)):
			self.canvas.delete(self.objects[i])
		self.objects = []
		
		#reset axes labels
		self.xAxisLabel.set('x')
		self.yAxisLabel.set('y')
		self.zAxisLabel.set('z')
		self.buildLabels()
		
				
	# Puts points on the canvas
	def buildPoints(self):
		
		# delete the axes
		for i in range(len(self.objects)):
			self.canvas.delete(self.objects[i])
		self.objects = []
		self.size = None
		self.Color = None
		self.data_num = None
		
		
		#get the x,y,z,color,size header names if they exist
		x = self.headerData.get('x')
		y = self.headerData.get('y')
		z = self.headerData.get('z')
		color = self.headerData.get('color')
		sizeV = self.headerData.get('size')
		
		
		
		
		#if there is only one input, then make a histogram
		if( x != '' ):
			if( y == ''):
				pylab.ion()
				pylab.cla()
				#print self.dataObject.select([x])
				pylab.hist(self.dataObject.select([x]))
				pylab.xlabel(x)
				pylab.ylabel("Occurances")
				pylab.show()
				return
		
		#get data
		data1 = self.dataObject.select([x,y])
		
		#if the data is empty exit this method
		if( np.shape(data1)[1] == 0):
			print "No Data, remove filters or change file!"
			return
		
		#length of data
		leng = self.dataObject.size()
		#check to see if there is z data
		if( z == None):
			zData = np.zeros([leng, 1], float)
			data1 = np.hstack((data1,zData))
		else:
			#obtain z data from the dataObject
			zData = self.dataObject.select([z])
			data1 = np.hstack( (data1,zData) )
		
		#add a row of 1 to every data point
		
		hom = np.zeros([leng,1],float)
		#creates a column of just 1s
		hom = hom + 1;
		data1 = np.hstack((data1,hom));
		
		self.data_num = data1
		#check to see if there is a color data
		if( color != None):
			colorData = self.dataObject.select([color])
			#add homogeneous coordinate
			colorData = np.hstack((colorData,hom))
			self.color = colorData
			
		else:
			self.color = None
		
		#check to see if there is a size data
		if( sizeV != None):
			sizeData = self.dataObject.select([sizeV])
			#add homogeneous coordinate
			sizeData = np.hstack((sizeData,hom))
			self.size = sizeData
		else:
			self.size = None
		
		#the code below is for data normalization using the (x-xMin)/(xMax-xMin) process for each
		#dimension of code
		
		#xy ranges
		xRange = self.dataObject.range_num(self.dataObject.getIndex(x))
		yRange = self.dataObject.range_num(self.dataObject.getIndex(y))
		
		
		# z range which is optional
		if( z != None):
			zRange = self.dataObject.range_num(self.dataObject.getIndex(z))
			#scale matrix to divide by (xMax-xMin)
			scale = self.viewObj.scale(1/(xRange[0]-xRange[1]), 1/(yRange[0]-yRange[1]), 1/(zRange[0]-zRange[1]))									
		#no z, so it is all zeros and can be just left unnormalized
		else:
			zRange = [0,0]
			#scale matrix to divide by (xMax-xMin)
			scale = self.viewObj.scale(1/(xRange[0]-xRange[1]), 1/(yRange[0]-yRange[1]), 0)
		
		#create the translation matrix to do the x-xMin part
		translate = self.viewObj.translate(-xRange[1], -yRange[1], -zRange[1])
		
		#create the matrix that will do the normalization of the data (i.e. (x - xMin)/(xMax-xMin))
		self.normmatrix = scale*translate
		
		#if there is a color category
		if( color != None):
			# normalize the color scale information
			colorMinMax = self.dataObject.range_num(self.dataObject.getIndex(color))
			self.colorNorm = (self.color - colorMinMax[1])/(colorMinMax[0]-colorMinMax[1])
			
		# if there is a size section, normalize it
		if( sizeV != None):
			sizeMinMax = self.dataObject.range_num(self.dataObject.getIndex(sizeV))
			self.sizeNorm = (self.size - sizeMinMax[1])/(sizeMinMax[0] - sizeMinMax[1])

		#build the vtm
		vtm = self.viewObj.build()
		
		#plot the data on the graph.
		rowNum = 0
		#for each data vector we need to normalize it and then apply the vtm to get the screen coordinates
		for row in self.data_num:
			point = vtm * self.normmatrix * row.T
			
			#handles the size dimension
			if( sizeV != None):
				#somewhere between min and max, there is a slight cutoff at the min just so points are visible
				dx = self.sizeNorm[rowNum,0]*(self.dxMax)
				if( dx < self.dxMin):
					dx = self.dxMin
			#set the default size if no size dim
			else:
				dx = self.dxDefault
			
			#handles the color dimension
			if( color != None):
				#get the type of the data (should be either numeric or enum)
				type = self.dataObject.getType(self.dataObject.getIndex(color))
				#since it is normalized between 0,1 this is a direct correlation
				alpha = self.colorNorm[rowNum,0]
				
				#base it off of the HSV color scale
				if(type == 'enum'):
					#multiply alpha by 0.8 to prevent going all the way around
					rgb = colorsys.hsv_to_rgb(alpha*0.8, 1, 1)
					rgb = (int(float(rgb[0])*200), int(float(rgb[1])*200), int(float(rgb[2])*200))
					rgb = "#%02x%02x%02x" % (rgb[0], rgb[1], rgb[2])
					
				else:
					rgb = "#%02x%02x%02x" % (200*alpha, 0.0, (1-alpha)*200)
				
				
			#default color == black
			else:
				rgb = "#%02x%02x%02x" % (0, 0, 0)
			# this part stores the location of the point in data space to the oval so that it can be accessed later when we only know
			# the screen coordinates.
			if( z != None):
				Location = '%s: %.2f , %s: %.2f , %s: %.2f' % ( x, row[0,0], y, row[0,1], z, row[0,2] )
			else:
				Location = '%s: %.2f , %s: %.2f' % ( x, row[0,0], y, row[0,1] )
			#check to see if size and color are being used
			if( sizeV != None):
				Location += ', %s: %.2f' % (sizeV, self.size[rowNum,0])
			if( color != None):
				Location += ', %s: %.2f' % (color, self.color[rowNum,0])
				
			#add in the row number
			Location += ' %d' % (rowNum)
			
			#create and add oval
			oval  = self.canvas.create_oval( point[0,0]-dx, point[1,0]-dx, point[0,0]+dx, point[1,0]+dx, fill = rgb, outline = '', tag = Location)
			self.objects.append(oval)
			
			rowNum += 1
		
		
	
		
	# This method will update all of the points in the canvas graph based on the vtm in the viewObj. Color dim does not need to be updated because
	# it is never reset
	def updatePoints(self):
		if( len(self.objects) == 0):
			return
		# if there are data objects plotted
		if ( self.data_num != None):
			vtm = self.viewObj.build()
			rowNum = 0
			
			#for each row in the numeric data
			for row in self.data_num:
				point = vtm *self.normmatrix* row.T
				
				#handles the size dimension
				if( self.size != None):
					#somewhere between min and max, there is a slight cutoff at the min just so points are visible
					dx = self.sizeNorm[rowNum,0]*(self.dxMax)
					if( dx < self.dxMin):
						dx = self.dxMin
						#set the default size if no size dim
				else:
					dx = self.dxDefault
				
			
				#color dim does not need to change here!
				
				#adjust positions
				self.canvas.coords(self.objects[rowNum],point[0,0]-dx, point[1,0]-dx, point[0,0]+dx, point[1,0]+dx)
				rowNum += 1
				
	# this method will load in the data. It does not plot the data and only loads the data into the programs memory
	def handleOpen(self):
		print 'handleOpen'
		#open file that has the data
		fobj = tkFileDialog.askopenfile( parent=self.root, mode='rU', title='Choose a data file (.csv)' )
		#error checking
		if( fobj == None):
			return False
		self.dataObject = csvDataReader(pathName = fobj.name)
		self.upDatePoints()
		self.upDateVariables()
		print "Data Loaded!"
		
		#this returns the axes to the default location and then builds the labels and axes
		self.returnDefault()
		if( len(self.lines) == 0):
			self.buildAxes()
		#deletes the image if it is still on the canvas
		self.canvas.delete(self.imageWidget)
		self.clearPoints()
		
		return True

	def handleQuit(self, event=None):
		print 'Terminating'
		self.root.destroy()

	def handleModQ(self, event):
		self.handleQuit()
	
	def handleModO(self, event):
		self.handleOpen()

	# This method tests to see if there is any data loaded
	# if there is no data loaded it will prompt the user to load data.
	# It will then return True if there is data loaded (either before or during the method)
	# or False if there is no data loaded
	def checkData(self):
		# no dataObject
		if( self.dataObject == None):
			print "Open data file"
			#create dialog box
			response = tkMessageBox.askyesno(title = "No Loaded Data!", message = "Load data?")
			#if the user wants to laod data
			if response:
				check = self.handleOpen()
				if(check == False):
					return False
				return True
			#No data loaded, return false
			else:
				return False
		else:
			return True
	
	# this method will reset the view object to the default settings
	# for the viewer.
	def returnDefault(self):
		self.viewObj.setExtent(np.matrix([1,1,1]))
		self.viewObj.setOffset(np.matrix([20,20]))
		#self.viewObj.setScreen(np.matrix([400,400]))
		self.viewObj.setScreen(np.matrix([self.canvas.winfo_width(),self.canvas.winfo_height()]) - self.windowOffset)
		
		self.viewObj.setU(u = np.matrix([1,0,0]))
		self.viewObj.setVPN(vpn = np.matrix([0,0,-1]))
		self.viewObj.setVRP(vrp = np.matrix([0.5,0.5,1]))
		self.viewObj.setVUP(vup = np.matrix([0,1,0]))
		self.updateAxes()
		self.updatePoints()
		self.updateLabels()
		return

	#reset to default
	def handleCmdButton(self):
		print 'handling command button'
		self.returnDefault()
		return
		
	# 3d view for the user
	def handleCmdButton2(self):
		test = self.checkData()
		if( test == False):
			return
		
		print 'handling command button2'
		self.viewObj.setExtent(np.matrix([ 1.96429238,  1.96429238,  1.96429238]))
		self.viewObj.setOffset(np.matrix([20,-20]))
		#self.viewObj.setScreen(np.matrix([400,400]))
		self.viewObj.setScreen(np.matrix([self.canvas.winfo_width(),self.canvas.winfo_height()]))
		#print self.viewObj.getScreen()
		self.viewObj.setU(u = np.matrix([-0.89773056,  0.10085255, -0.42884566]))
		self.viewObj.setVPN(vpn = np.matrix([ 0.44036241,  0.23344776, -0.86693892]))
		self.viewObj.setVRP(vrp = np.matrix([ 0.43337459,  0.56723291,  0.76298161]))
		self.viewObj.setVUP(vup = np.matrix([-0.01268006,  0.96712507,  0.25398486]))
		self.updateAxes()
		self.updateLabels()
		self.updatePoints()
		return
		
	# this method will open up the plot dialog for the user so that it can determine which categories in the data
	# to plot.
	def handleCmdButton3(self):
		#check to see if there is data loaded
		test = self.checkData()
		
		if( test == False):
			return
		
		print 'handling command button3'
		
		if( self.dataObject.filtersize() == 0):
			tkMessageBox.showwarning("No data!","Remove Filters from the data or load a different data set!")
			return
		
		#create a new dictionary that will store the headers for the x,y,z,size, and color dim
		self.headerData = {}
		#open input dialog
		inputBox = MyDialog(parent = self.root,displayClass = self, dataHeader = self.headerData)
		
		if(self.headerData['check'] == True):
			#plot the points
			self.buildPoints()
			#check points
			self.xAxisLabel.set( self.headerData.get('x') )
			self.yAxisLabel.set( self.headerData.get('y') )
			#z is an optional component
			z = self.headerData.get('z')
			if( z == None ):
				z = ""
			self.zAxisLabel.set( z )
			
			self.buildLabels()
		
	#This mehtod will open up a dialog for the user so that it can determine which categories it wants to plot after
	# PCA analysis has been computed on the data set
	def handleCmdButton4(self):
		#check to see if data has been loaded
		test = self.checkData()
		if( test == False):
			return
		self.size = None
		self.color = None
		
		#check to see if there is any data in the set after filters applied
		if( self.dataObject.filtersize() == 0):
			tkMessageBox.showwarning("No data!","Remove Filters from the data or load a different data set!")
			return
		
		print "handling command button 4"
		
		# run pca on all of the numerical data
		self.Analysis = Analysis(name = "PCA", data = self.dataObject.getData_num())
		#dictioanry that will store the headers for the pca analsysis plots
		self.pcadataHeader = {}
		# this will run the dialog for pca
		inputBox = PCADialog(parent = self.root, pcaDataHeader = self.pcadataHeader, displayClass = self, Analysis = self.Analysis)
		
		
		if( self.pcadataHeader['check'] == True):
			self.xAxisLabel.set( self.pcadataHeader.get('x') )
			self.yAxisLabel.set( self.pcadataHeader.get('y') )
			z = self.pcadataHeader.get('z')
			#z is optional
			if( z == None ):
				z = ""
			self.zAxisLabel.set(z)
			self.buildLabels()
			#graphs the pca points
			self.buildPCA()
			
			if( self.pcadataHeader.get('saveData') ):
				filename = self.pcadataHeader.get('filename')
				filename = filename + ".csv"
				self.Analysis.writeData(filename = filename)
		
	#This method will open up the filter choice menu dialog where the user will
	#be able to choose which fitlers to add/remove from the data.
	#this will also have an option for removing missing data.
	def filterData(self, event=None):
		#check to see if the data is loaded
		test = self.checkData()
		if( test == False):
			return
		a = filterDialog(parent = self.root, displayClass = self, dataObj = self.dataObject, title = "Filter")
		
		return
	
	# This method will open the countInfo Dialog box where the user can count the number
	# of data points that meet two conditions which will be saved in the data object
	def countData(self, event = None):
		#check to see if the data is loaded
		test = self.checkData()
		if( test == False):
			return
		#open dialog
		temp = countInfo(parent = self.root, dataObject = self.dataObject, title = "Count Occurrences within the Data:")
		return
	
	# this method will run the kmeans clustering algorithm on the loaded data
	# a popup dialog will appear with options for the user to choose which columns
	# to run on the kmeans clustering. Default being use all numeric columns
	# the user can also choose the number of clusters to have and the name
	# of this cluster run
	def handleCmd1(self, event = None):
		#check to see if the data is loaded
		test = self.checkData()
		if( test == False):
			return
		#check to see if there is any data
		if( self.dataObject.filtersize() == 0):
			tkMessageBox.showwarning("No data!","Remove Filters from the data or load a different data set!")
			return
		
		#obtain data
		self.clusterInfo = {}
		clusterDialogBox = ClusterDialog(parent = self.root, displayClass = self, clusterInfo = self.clusterInfo,title="Clusters")
		#if nothing is chosen do nothing and exit
		if( self.clusterInfo.get("headers") == None):
			return
		headers = self.clusterInfo.get("headers")
		
		self.dataObject.cluster(headers = headers, clusters = self.clusterInfo.get("clusters"), name = self.clusterInfo.get("name"), normalize = True)
		tkMessageBox.showwarning("Clustering Complete", "The clustering process has now completed!")
		
		print 'handling command 1'
		return

	#this method will be used to clean data
	def handleCmd2(self):
		#check to see if the data is loaded
		test = self.checkData()
		if( test == False):
			return
		#initialize filename variable
		filename = StringVar()
		temp = getInput(parent = self.root, inputText = "Choose Filename:", entryVar = filename, title = "Clean data of missing information")
		#if nothing is input
		if( filename.get() == ""):
			return
		#clean the data
		self.dataObject.setMissingToAverage()
		#save it
		self.dataObject.saveData(filename.get())
		#load the new data back into the system
		self.dataOBject = csvDataReader(pathName = filename.get())
		self.upDatePoints()
		self.upDateVariables()
		print "Data Loaded!"
		return

	def handleCmd3(self):
		print 'handling command 3'

	# Stores scaling data initial values
	def handleButton3(self, event):
		print "handling button3"
		self.baseClick3 = (event.x, event.y)
		self.textent = self.viewObj.getExtent()
		return
	
	#scales the values of the axes/data based on y movement when button 3 is depressed, all based off of initial click location
	def handleButton3Motion(self, event):
		diff = event.y-self.baseClick3[1]
		#determine scale
		scale = 1+(3.0*diff)/self.root.winfo_height()
		#print "scale",scale
		#check to see extremes of scale
		if( scale < 0.1):
			scale = 0.1
		elif( scale > 3):
			scale = 3
		#change the extent
		self.viewObj.setExtent(self.textent*(scale))
		#update drawings
		self.updateAxes()
		self.updateLabels()
		self.updatePoints()
		
		
	# store initial value for translation
	def handleButton1(self, event):
		#print 'handle button 1: %d %d' % (event.x, event.y)
		self.baseClick1 = (event.x, event.y)
		
		closestObj = None
		#for obj in self.objects:
			
		
	# store initial values before rotation (i.e. clone view object)
	def handleButton2(self, event):
		#print 'handle button 2: %d %d' % (event.x, event.y)
		self.baseClick2 = (event.x,event.y)
		self.viewObjClone = self.viewObj.copy(View())
		return
	
	# rotates the data based on movement from initial click location. 400 px is about 1 full rotation
	def handleButton2Motion(self, event):
		divConst = 200.0
		#rotation angles
		delta0 = ((event.x-self.baseClick2[0])/divConst)*math.pi
		delta1 = ((event.y-self.baseClick2[1])/divConst)*math.pi
		
		#clone view object
		viewObjClone2 = self.viewObjClone.copy(View())
		#rotate
		viewObjClone2.rotateVRC(delta0,delta1)
		
		# update points, axes, view obj
		self.viewObj = viewObjClone2
		self.updateAxes()
		self.updateLabels()
		self.updatePoints()
		return
	
	# This is executed when the user releases button1 of the mouse and starts the callback
	# for the continual "inertial" motion
	def handleButton1Release(self, event):
		#call my callback method
		self.callback_Motion()


	# This call back method will continue to be called and apply the inertial effects of the tranlsation
	# caused by the user until it reaches some minimum. The constants self.kn and self.check are set in the 
	# constructor method. This method will be called by the program every 20 ms to update the axes
	def callback_Motion(self):
		# update our travel vector by some scalar constant self.kn
		self.Delta  = self.Delta*self.kn
		
		# this checks to see if the change is between -check < x < check for x,y,z variables		
		if( self.Delta[0,0] < self.check and self.Delta[0,0] > -self.check):
			if( self.Delta[0,1] < self.check and self.Delta[0,1] > -self.check):
				if( self.Delta[0,2] < self.check and self.Delta[0,2] > -self.check):
					# if it is exit and end callbacks
					return
		# update the vrp location
		vrp = self.viewObj.getVRP()
		vrp = vrp + self.Delta
		self.viewObj.setVRP(vrp)
		#update points and axes
		self.updateAxes()
		self.updateLabels()
		self.updatePoints()
		
		#set callback method call
		self.root.after(20, self.callback_Motion)
		return
	
	# this method will handle the 'control-mouse click' combo which will display the point location in data space of the nearest point
	# to the user's click
	def handleButton4(self,event):
		#mouse click location
		x = event.x
		y = event.y
		#gets id of closest oval
		closest = self.canvas.find_closest(x, y, halo = None, start = None)
		# this will get the tag of the closest oval which stores the location in data space of the point
		tag = self.canvas.gettags(closest[0])
		
		# this creates the pointInfo string which will be put on the display
		pointInfo = '' 
		for i in range(0,len(tag)-2):
			pointInfo += " " + tag[i]

		#update display
		self.locationVar.set("Point: " + pointInfo)
		
		return
	
	# this method will handle the 'command-mouse click' combo which will open a display dialog which will display
	# all of the data for that data vector in an image 	
	def handleButton5(self,event):
		#mouse click location
		x = event.x
		y = event.y
		#gets id of closest oval
		closest = self.canvas.find_closest(x, y, halo = None, start = None)
		# this will get the tag of the closest oval which stores the location in data space of the point
		tag = self.canvas.gettags(closest[0])
		length = len(tag)
		if(tag[length-1] == 'current'):
			rowNum = tag[length-2]
		else:
			rowNum = tag[length-1]
		#rowNum = tag[length-2]
		#print tag
		#print rowNum
		dialog = InfoBox(parent = self.root, dataObject = self.dataObject, rowNumber = rowNum, title = "Data Information")
		
		
		return

	# handles translation of the axes / data
	def handleButton1Motion(self, event):

		# this creates a differential motion information for us by updating this
		# every time the mouse is moved
		# calculate the difference
		diff = ( event.x - self.baseClick1[0], event.y - self.baseClick1[1] )
		self.baseClick1 = (event.x, event.y)
		norm = []
		norm.append( float(diff[0])/self.root.winfo_width())
		#print "width", self.root.winfo_width()
		norm.append( float(diff[1])/self.root.winfo_height())
		#print "norm",norm
		adj = 0.8
		#change amount
		delta0 = adj*norm[0]*self.viewObj.getExtent()[0,0]
		delta1 = adj*norm[1]*self.viewObj.getExtent()[0,1]
		
	
	
		
		# adjust vrp	
		vrp = self.viewObj.getVRP()
		self.Delta = delta0*self.viewObj.getU() + delta1*self.viewObj.getVUP()
		vrp = vrp + self.Delta
	
		
		self.viewObj.setVRP(vrp)
		#redraw points
		self.updateAxes()
		self.updateLabels()
		self.updatePoints()
		
		
		
		
	# handles if if the canvas size is changed, will reset the data 
	def resize(self,event):
		#self.viewObj.setScreen(np.matrix([self.canvas.winfo_width(), self.canvas.winfo_height()]))
		#self.handleCmdButton()
		#self.updateAxes()
		#self.updatePoints()
		self.returnDefault()
		return
		
	def main(self):
		print 'Entering main loop'
		#lets everything just sit and listen
		self.root.mainloop()


# executes everything to run
if __name__ == "__main__":
	dapp = DisplayApp(500, 500)
	dapp.main()


