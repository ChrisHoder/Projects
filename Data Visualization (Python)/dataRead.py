import csv
import xlrd
import HTML
import numpy as np
from csvWriter import *
from Cluster import *


# This class will parse a csv file into its header, type and data components
# fileObj is the open csv file
class csvDataReader:
	
	# init function
	def __init__(self, fileObj = None, pathName = "" ):
		# header information
		self.header = ()
		# type information initialized
		self.type = ()
		self.data = ()
		self.num_Index_Dic = {}
		self.data_num = []
		self.enum_link = {}
		self.clusterList = []
		
		#list of the filters in the data
		self.filters = []
		#store the filtered data information
		self.dataFiltered = np.matrix([])
		self.data_numFiltered = []
		self.counts = []
		
		
		# This frist checks to see if there is already an open file, if not
		# it will then check to see if an input pathName was given, if not it will exit
		# otherwise it will open the given pathname File
		if( fileObj == None):
			if( pathName == ""):
				print "bad input. fail!"
				exit()
			else:
				if ( pathName[-4:] == '.xls'):
					self.openxls(pathName)
				elif (pathName[-4:] == '.csv'):
					fileObj = open(pathName, 'rU')
					self.opencsv(fileObj)
				else:
					print "Incorrect file format. Please format in either csv or xls"
					exit()
		else:
			if( fileObj.name[-4:] == '.csv'):
				self.opencsv(fileObj)
			else:
				print "bad data type / operation"
				exit()
				
		#save the pathname
		self.pathname = pathName
	
		
	# This method will parse an xls document using the xlrd package
	# installed. It will store the data the same way that the opencsv will.
	# Dates however, will have been convereted to their numeric form (though still stored
	# as strings for compatibility with the csvReader (which is the central data reader)
	def openxls(self, pathName):
		# open workbook
		wb = xlrd.open_workbook(pathName)
		# hardcoded to select only the first sheet
		sheet = wb.sheet_by_index(0)
		data = ()
		data_num = []
		columns = 0
		# parse the data
		for rownum in range(sheet.nrows):
			# first row is the headers
			if( rownum == 0 ):
				self.header = tuple(sheet.row_values(rownum))
				columns = len(self.header)
			# second row is the types
			elif (rownum == 1):
				self.type = tuple(sheet.row_values(rownum))
				# this will create the linking between the raw headers and the 
				# columns for the numeric data
				self.formatDictionary()
			# the rest of the rows are data
			else:
				dataTemp = ()
				row = sheet.row_values(rownum)
				#check for a comment line
				if( row[0][0] == '#'):
					# it does and is a comment and should be skipped by the parser
					continue
				data_num_row = []
				colnum = 0
				# for each colun in the rows
				for col in row:
					#check to see if it is empyty
					if( col == ''):
						# if the type is numeric and it is empty, set the data to 
						# read -9999
						if( self.type[colnum] == "numeric"):
							dataTemp += ("-9999",)
							data_num_row.append(-9999)
						#check to see if it is and enum
						elif( self.type[colnum] == "enum"):
							data_num_row.append(-9999)
							dataTemp += ("-9999",)
						#non numeric data
						else:
							dataTemp += (col,)
					#not empty data
					else:
						dataTemp += (str(col),)
						#if this is a numeric element, add it to our numeric matrix
						if( self.type[colnum] == "numeric"):
							#add these values as a float to our data
							data_num_row.append(float(col))
						elif( self.type[colnum] == "enum"):
							link = self.enum_link.get(self.header[colnum])
							#hopefully there is at least one value in the enum column...
							# this creates the list of enums
							if( link == None):
								# create a list of the forward and backward dictionaries
								self.enum_link[self.header[colnum]] = [{},{}]
								link = self.enum_link[self.header[colnum]]
							
							enum_Num = link[0].get(col)
							# we have not put this enum in yet
							if( enum_Num == None):
								# add the enum, lenght will always be one greater than the
								# index number
								link[0][col] = float(len(link[0]))
								link[1][float(len(link[0])-1)] = col
								enum_Num = link[0][col]
							#append the enum with teh correct enum integer
							data_num_row.append(enum_Num)
					
					colnum += 1
				
				# if( len(dataTemp) < columns):
					
				#add in this row of numeric data
				data_num.append(data_num_row)
				data += (dataTemp,)
			
			rownum += 1
		#store the raw data (self.data) and the numeric data (self.data_num)
		#this is a matrix of strings that contains the raw data
		self.data = np.matrix(data)
		self.data_num = np.matrix(data_num)
		self.computeFilter()
		return
						
	
				

	# This method will create a link between the raw header indices and the 
	# indices of the numeric data being held
	def formatDictionary(self):
		numeric_num = 0
		colNum = 0
		# create a dictionary relating the two different 
		for col in self.type:
			# add the numeric column to the dictionary
			if (col == "numeric"):
				self.num_Index_Dic[self.header[colNum]] = numeric_num
				numeric_num += 1

			# if it is an enum it will also be in the numeric section
			elif( col == "enum"):
				self.num_Index_Dic[self.header[colNum]] = numeric_num
				
				numeric_num += 1
			colNum += 1
			
		return





	# This method will parse csv files using the open fileObj, it will create
	# a raw data matrix with everything stored as strings and it will also
	# store another numeric matrix and the linking between headers and the 
	# numeric column indices is given by the dictionary self.num_Index_Dic.
	# It will also parse out the header row and the type row and store
	# them separetly as tuples. Enum columns will also be converted to the 
	# numeric values and can be figured out using the self.enum_link list
	def opencsv( self, fileObj ):
		reader = csv.reader(fileObj)
		rownum = 0
		data = ()
		#hold the numeric data
		data_num = []
		# for every row
		for row in reader:
			# this is the header row
			if rownum == 0:
				rowTemp = []
				#make sure it is all stripped of whitespace
				for col in row:
					col = col.strip()
					col = col.lower()
					rowTemp.append(col)
				self.header = tuple(rowTemp)
			# this is the type row
			elif rownum == 1:
				rowTemp = []
				for col in row:
					col = col.strip()
					col = col.lower()
					rowTemp.append(col)
				self.type = tuple(rowTemp)
				# format our link
				self.formatDictionary()
			# all other rows are data points
			else:
				dataTemp = ()
				colnum = 0
				#check to see if a line begins with a #
				if( row[0][0] == '#'):
					# if it does, it is a comment and should be skipped
					# by the parser
					continue
				#this row of numeric data
				data_num_row = []
				for col in row:
					#check to see if it is empty
					if( col == ''):
						# if the type is numeric and it is empty, set the data
						# to read -9999
						if(self.type[colnum] == "numeric"):
							dataTemp += ("-9999",)
							data_num_row.append(-9999)
						#check to see if it is an enum
						elif( self.type[colnum] == "enum"):
							data_num_row.append(-9999)
							dataTemp += ("-9999",)
						# non - numeric data
						else:
							dataTemp += (col,)	
					# not empty data
					else:
						dataTemp += (col,)
						# if this is a numeric element, add it to our numeric matrix
						if( self.type[colnum] == "numeric"):
							# add this values as a float to our data
							#print col
							#print colnum
							#print self.header[colnum]
							data_num_row.append(float(col))
						elif( self.type[colnum] == "enum"):
							link = self.enum_link.get(self.header[colnum])
							#hopefully there is at least one value in the enum column...
							# this creates the list of enums
							if( link == None):
								# create a list of the forward and backward dictionaries
								self.enum_link[self.header[colnum]] = [{},{}]
								link = self.enum_link[self.header[colnum]]
							colValue = col.lower()
							colValue = col.strip()
							
							enum_Num = link[0].get(colValue)
							# we have not put this enum in yet
							if( enum_Num == None):
								# add the enum, lenght will always be one greater than the
								# index number
								link[0][colValue] = float(len(link[0]))
								link[1][float(len(link[0])-1)] = col
								enum_Num = link[0][colValue]
							#append the enum with teh correct enum integer
							data_num_row.append(enum_Num)
					
					colnum += 1
					
				#add in this row of numeric data
				data_num.append(data_num_row)
				data += (dataTemp,)
			
			rownum += 1
	
		fileObj.close()
		# save our data
		self.data = np.matrix(data)
		self.data_num = np.matrix(data_num)
		self.computeFilter()
		return
	
	# This method returns the raw fitlered data (it is a tuple)
	def getData(self):
		return self.dataFiltered
	
	# This method returns the numeric filted data, as a copy
	def getData_num(self):
		return np.matrix(np.copy(self.data_numFiltered))
	

	
	# Takes the column id of a given column and returns the header as a string
	# if no column id is given it will return the list of headers
	def getHeader(self, index = -1):
		if ( index < 0):
			return self.header
		else:
			return self.header[index]
		
	# this method takes in a column index for a numeric column data and 
	# will return the appropriate header
	def getHeader_num(self, index):
		headers = self.header_num()
		for head in headers:
			if( self.num_Index_Dic.get(head) == index):
				return head
		return None
	
	# Takes in an optional column id (index) and returns the type as a string.
	# with no argument a list of all of the types will be returned
	def getType(self, index = -1):
		if ( index < 0):
			return self.type
		else:
			return self.type[index]
	
	#this method will give you the enumerated values for the given header
	def getEnumValues(self, header):
		link = self.enum_link.get(header)
		return link[0].keys()
	
	# Returns a list of the numeric headers
	def header_num(self):
		colNum = 0
		header_Numeric = []
		for col in self.header:
			# find out if it is numeric, if it is add it to our header list
			if self.type[colNum] ==  "numeric":
				header_Numeric.append(col)
			elif( self.type[colNum] == "enum"):
				header_Numeric.append(col)
			colNum += 1
			
		
		return header_Numeric
	
	# this method will return a list of data that is of the enum type and not numeric or any other
	def getEnumType(self):
		colNum = 0
		headers = []
		for col in self.header:
			#find out if it is of enum type
			if self.type[colNum] == "enum":
				headers.append(col)
				
			colNum += 1
			
		return headers
	
	# this method will return only the headers that are of the numeric type and not of the enum or
	#any other data type
	def getNumericOnly(self):
		colNum = 0
		headers = []
		for col in self.header:
			#find out if it is a a numeric type
			if self.type[colNum] == "numeric":
				headers.append(col)
				
			colNum += 1
		return headers

	# Takes in a row and column index and returns the filtered data value. If the value is numeric
	# it will return the numeric version of it
	def value(self, row, col):
		# set a boolean on whether or not it is a numeric data point
		if( self.type[col] == "numeric"):
			return float(self.dataFiltered[row][col])
		else:
			return self.dataFiltered[row][col]
	
		
	# Takes in a row index and returns the data vector in its raw (string) form
	def point(self, Index):
		return self.data[Index]

	# takes in a row index and returns the numeric values only as floats
	def point_Num(self, Index):
		numericValues = [] 
		row  = self.dataFiltered[Index]
		colNum = 0
		for col in row:
			if( self.type[colNum] == "numeric"):
				numericValues.append(float(col))
			colNum += 1
		
		return numericValues
			
	
	# returns the number of variables (columns in each data point)
	def dim(self):
		return len(self.header)
	
	# returns the number of numeric variables in each data point
	def dim_Num(self):
		numCount = 0
		for col in self.type:
			if( col == "numeric"):
				numCount += 1
		
		return numCount
	
	
	# returns the number of data points (rows)	
	def size(self, dataBoolean = False):
		if( dataBoolean == True):
			dataSet = self.data
		else:
			dataSet = self.dataFiltered
		shapeValue = np.shape(dataSet)
		if( shapeValue[1] == 0):
			return 0
		else:
			return shapeValue[0]
	
	#this method returns the index of the header column in the numeric data,
	#it will return none if it is not in the numeric data
	def getNumericIndex(self,header):
		return self.num_Index_Dic.get(header)
	
	#this converts a header to the proper index
	def getIndex(self,header):
		temp = header.strip()
		temp = header.lower() 
		index = 0
		for element in self.header:
			element = element.strip()
			element = element.lower()
			if( element == header):
				#index of the header
				return index
			index += 1
		#ideally would never get here, this means that there is no header in the data
		return -1
	
	#this genaric function will take in the data set (as a numpy matrix and with the same dimmensions
	# as the headers in the object. it is used to allow us to either find stasitics on the
	# filtered data or unfiltered data. dataBoolean == TRUE is the unfiltered data. dataBoolean == FALSE is the filtered data
	def range_numGeneric(self,Index=-1, dataBoolean = True):
		if( dataBoolean == True):
			dataSet = self.data_num
		else:
			dataSet = self.data_numFiltered
			
		range = []
		if( Index < 0):
			max_values = dataSet.max(0).tolist()[0]
			min_values = dataSet.min(0).tolist()[0]
			colnum = 0
			for col in max_values:
				range.append([max_values[colnum], min_values[colnum]])
				colnum += 1
		else:
			# get the right index in the numeric data
			ind  = self.num_Index_Dic.get(self.header[Index])
			if (ind == None):
				return
			#ind = self.num_Index_Dic[self.header[Index]]
			max_value = dataSet[:,ind].max(0).tolist()[0][0]
			min_value = dataSet[:,ind].min(0).tolist()[0][0]
			range.append(max_value)
			range.append(min_value)
		return range
	
	# this method will take the range output and then split it into two outputs, one that contains
	# the minimum values and another that contains the maximum values for all of the data (if no index input) otherwise just
	# for the input index
	def splitRange(self, Index = -1, dataBoolean = True):
		range = self.range_numGeneric(Index, dataBoolean)
		minList = []
		maxList = []
		for element in range:
			minList.append(element[1])
			maxList.append(element[0])
		return minList,maxList
	
	
	# Returns a list of 2-element lists with a minimum and maximum values for each numeric column
	# With an optional index, returns the range for a single column. This function needs to work only for
	# numeric unfiltered data. 
	def range_num(self, Index = -1):
		return self.range_numGeneric(Index, dataBoolean = True)
		
	# this works the same as range_num but instead it will give you the information for the filtered data
	# only
	def range_numFiltered(self,Index=-1):
		return self.range_numGeneric(Index, dataBoolean = False)

	#generalized version of the mean_num function except we can pass either the self.data_num matrix or the self.data_numFiltered
	#data into this and get the information specific to that data. this is an internal method. dataBoolean == True is the unfiltered data. dataBoolean == False is the filtered data
	def mean_numGeneric(self, Index = -1, dataBoolean = True):
		#determine type
		if( dataBoolean == True):
			dataSet = self.data_num
		else:
			dataSet = self.data_numFiltered
		mean = None
		if( Index < 0):
			mean =  dataSet.mean(0).tolist()[0]
		else: 
			# get the right index in the numeric data
			ind = self.num_Index_Dic[self.header[Index]]
			mean = dataSet[:,ind].mean(0).tolist()[0]
		return mean
	# Returns a list of the mean values for each numeric colum. With an optional index, it returns the mean
	# for just the specified column. Uses the built - in numpy function. This is for the unfiltered data
	def mean_num(self, Index = -1):
		return self.mean_numGeneric(Index, dataBoolean = True)
	
	#this will find the mean values for each numeric column in the filtered dataset. this works the same as self.mean_num (see description above)
	# except on the filtered data only
	def mean_numFiltered(self, Index = -1):
		return self.mean_numGeneric(Index, dataBoolean = False)
	
	#generalized version of the sum_num method where we can pass in either the self.data_num matrix or the self.data_numFiltered matrix
	# this is expected to be an internal method. dataBoolean == True will use the unfiltered data, dataBoolean == False will use the filtered data
	def sum_numGeneric(self, Index = -1, dataBoolean = True):
		#determine type
		if( dataBoolean == True):
			dataSet = self.data_num
		else:
			dataSet = self.data_numFiltered
		
		if( Index < 0 ):
			sum_Num = dataSet.sum(0).tolist()[0]
		else:
			# get the right index in the numeric data
			ind = self.num_Index_Dic[self.header[Index]]
			sum_Num = dataSet[:,ind].sum(0).tolist()[0]
		return sum_Num	
	
	# This will return a sum of each numeric column. With an optional index,
	# it will return just the specified column. Uses the built - in numpy function. uses the unfiltered data
	def sum_num(self, Index = -1):
		return self.sum_numGeneric(Index, dataBoolean = True)
	
	#this will return a sum of each numeric column. with optional index, 
	# it will return just he specified column. Uses the filtered data
	def sum_numFiltered(self, Index=-1):
		return self.sum_numGeneric(Index, dataBoolean = False)
	
	
	#this is a generalized stdev finder. it will find the standard deviations for each numeric column. with an optional index.
	# If there is an index it will return a specified column. If dataBoolean == True it will use unfiltered data. if databoolean == false it will use the filtered data
	def stdev_numGeneric(self, Index  = -1, dataBoolean = True):
		#determine type
		if( dataBoolean == True):
			dataSet = self.data_num
		else:
			dataSet = self.data_numFiltered
		
		stdv = None
		if( Index < 0):
			stdv =  dataSet.std(0).tolist()[0]
		else: 
			# get the right index in the numeric data
			ind = self.num_Index_Dic[self.header[Index]]
			stdv = dataSet[:,ind].std(0).tolist()[0]
		return stdv
	
	# Returns a list of the standard deviations for each numeric column. With an optional index.
	# If there is an index it will return specified column. uses unfiltered data
	def stdev_num(self, Index = -1):
		return self.stdev_numGeneric(Index, dataBoolean = True)
	
	# Returns a list of the standard deviations for each numeric column. With an optional index.
	# If there is an index it will return specified column. uses unfiltered data
	def stdev_numFiltered(self, Index = -1):
		return self.stdev_numGeneric(Index, dataBoolean = False)
	
	
	# GENERAL NOTE
	# for the select method, there is a reverse from the above methods
	# the filtered data will be used for the select method because
	# we want the filtered data to be the generic one accessed and not the unfiltered data
	# but i wanted to design the opposite when it came to stdev, range etc so that you still
	# saw the data in relation to other information.
	
	# This method takes in a list of headers and will return just those 
	# columns. If one of the columns is not numeric it will skip it
	# returned type is a numpy matrix
	# will skip a non numeric filtered data column
	# if dataBoolean == True it will use unfiltered data
	# if dataBoolean == False it will use filtered data
	def selectGeneric(self, headers, dataBoolean = False):
		#determine type
		if( dataBoolean == True):
			dataSet = self.data_num
		else:
			dataSet = self.data_numFiltered
		
		#check to make sure that there is data here
		if( np.shape(dataSet)[0] == 0):
			print "no data"
			return np.matrix([])
		if( np.shape(dataSet)[1] == 0):
			print "no data"
			return np.matrix([])
		
		
		selected_Num_tup = ()
		for head in headers:
			head = head.strip()
			head = head.lower()
			#get index
			index = self.num_Index_Dic.get(head)
			#not a numeric column, ignore
			if( index == None):
				continue
			else:
				selected_Num_tup += (dataSet[:,index], )
		if( len(selected_Num_tup) == 0):
			return None
		#return the stack 
		return np.hstack((selected_Num_tup))
	
	
	# This method takes in a list of headers and will return just those 
	# columns. If one of the columns is not numeric it will skip it
	# returned type is a numpy matrix
	# will skip a non numeric filtered data column
	def select(self, headers):
		return self.selectGeneric(headers, dataBoolean = False)
		
	
	#see above method but will use the unfiltered data
	def selectUnFiltered(self, headers):
		return self.selectGeneric(headers, dataBoolean = True)
	
	# this method will select filtered data from the raw tuple and return the
	# column as a list
	def select_RawCol(self,header):
		selected = []
		index = -1
		headNum = 0
		for head in self.header:
			if( head == header):
				index = headNum
				break
			headNum += 1
		
		#no such column, return nothing (an empty list)
		if( index == -1):
			return selected
		
		for row in self.dataFiltered:
			selected.append(row[index])
			
		#return the selected values
		return selected
			
	#OLD METHOD TO BE DELETED
	def getData_numNorm(self):
		range = self.range_num()
		colNum = 0
		dataNorm = ()
		for col in range:
			data = self.data_num[:,colNum]
			data = data / col[0]
			dataNorm += (data, )
			
			colNum += 1
		#put the columns back together
		print np.hstack((dataNorm))
		print self.data_num
		return np.hstack((dataNorm))
			
		
	# This method will test if the header is a numeric column (for right now this includes enums)
	def testHeader(self,header):
		#lower case and strip
		header = header.strip()
		header = header.lower()
		column = self.num_Index_Dic.get(header)
		if(column == None):
			return False
		else:
			return True
	
	# This method will nicely print out the whole data set with each line 
	# displaying the header, type and element for that data point
	def printData(self):
		for row in self.data:
			string = ""
			colnum = 0
			for col in row:
				string += self.getHeader(colnum) + "[" + self.getType(colnum) + "] : " + col + "  "
				colnum += 1
			print string
			print ""
			
			
	# This method will take in a header string, a type string and a clumn matrix of data (with the same number
	# of rows as the data already in the Data class and assumed to be complete) and adds
	# the column to the data set. (will determine if it is numeric/enum and add that to the 
	# numeric data set and update the appropriate dictionaries
	def addColunn(self, header, typeString, columnData):
		#add the header
		header = header.strip()
		header = header.lower()
		self.header += (header, )
		self.type += (typeString, )
		#add the column to the data
		self.data = np.hstack((self.data, columnData))
		typeString = typeString.strip()
		typeString = typeString.lower()
		numericNum = len(self.num_Index_Dic)
		#set the dictionary conversion if it is a numeric or enum

		if( typeString == "numeric" ):
			num_row = []
			self.num_Index_Dic[header] = numericNum
			#assuming the data is complete (no missing entries)
			for row in columnData:
				num_row.append(float(row))
		elif( typeString == "enum"):
			num_row = []
			#create a list of the forward and backward dictionaries
			link = self.enum_link[header] = [{},{}]
			self.num_Index_Dic[header] = numericNum
			#assuming the data is complete( no missing entries)
			for row in columnData:
				#get the enum number
				# row is still in matrix form so get the 0,0 element to get the one 
				#value in it
				enum_Num = link[0].get(row[0,0])
				#we have not put this enum in yet
				if( enum_Num == None):
					#add the enum, length will always be one greater than the index number
					link[0][row[0,0]] = float(len(link[0]))
					link[1][float(len(link[0])-1)] = row[0,0]
					enum_Num = link[0][row[0,0]]
					#print enum_Num
				
				#append the enum with the correct enum integer
				num_row.append(enum_Num)
			
			#add the numeric data column in
			newCol = np.matrix(num_row).transpose()
			self.data_num = np.hstack((self.data_num,newCol))
			
		self.computeFilter()	
		
	# this method will cluster the data with the given number of clusters and on the given headers only. 
	# if no headers are input, the method will cluster all of the numeric data together. the number of clusters is
	# by default 10 but the user can specify how many they wish to have. Likewise they can decide if they want the data
	# normalized before they cluster it and assign ids. After the clustering process the cluster ids for each row will be added 
	# as a new column in the data with the given clustername. if no name has been input, the name will be numeric based
	# on the number of previous clusters added to the data (0,1,2...)
	def cluster(self, headers = None, clusters = 10, name = None, normalize = True):
		#check initial values
		if (headers == None):
			headers = self.header_num()
		if( name == None):
			name = str(len(self.clusterList))
	
		print "name",name
		
	
		#get variable data that contains the normalized data
		data = self.select(headers)
		#check to see if we are normalizing the data 
		if( normalize == True):
			colNum = 0
			normalizedData = ()
			for header in headers:
				#gets the column of data
				dataCol = data[:,colNum]
				#gets the index the header is
				index = self.getIndex(header)
				#gets the range
				rangeValue = self.range_num(index)
				#get the normalized column
				normalizedcol = (dataCol - rangeValue[1])/(rangeValue[0] - rangeValue[1])
				#add it to the now normalized data set
				normalizedData += (normalizedcol, )
				
				colNum += 1
			#set the normalized data to be a matrix
			norm = np.hstack((normalizedData))
			print "norm", norm
		#if there is no normalization, the data is just set to be the norm data (for simplicity later)
		else:
			norm = data
		
		
		#create a new cluster object for kmeans
		clusterInfo = Cluster()
		#add it to the list of clusters
		self.clusterList.append(clusterInfo)
		#generate the cluster data
		clusterInfo.kmeans(name = name, headers = headers, k = clusters, data = norm)
		#get the id of each point in the data
		ids = clusterInfo.classify(data = norm)

		# add the column to the data as an enum type and with a header name = to name
		self.addColunn(header = name, typeString = "enum", columnData = ids)
		return
		
	#add a filter to the data
	def addFilter(self, filterValue):
		self.filters.append(filterValue)
		self.computeFilter()
		
	#returns a deep copy of the list of counts that have been done
	# on this data set
	def getCounts(self):
		countCopy =  []
		for i in range(len(self.counts)):
			countCopy.append(self.counts[i].copy())
		return countCopy
	
	#this deletes all records of previous counts
	def clearCounts(self):
		self.counts = []
	
	#get a tuple of the list of filters. this is a deep copy
	def getFilters(self):
		filtersCopy = []
		for i in range(len(self.filters)):
			filtersCopy.append(self.filters[i].copy())
			
		return tuple(filtersCopy)
	
	#this will remove a filter from the list
	def removeFilter(self, filterValue):
		self.filters.remove(filterValue)
		#print self.filters
		self.computeFilter()
		#print self.dataFiltered
		#print self.data_numFiltered
		
	#this method will create the filtered data based on the list of filters stored in the object, this will
	#be the data that the user interacts with in all cases
	def computeFilter(self):
		#initially the filtered data is the entire set of data
		self.data_numFiltered = self.data_num
		self.dataFiltered = self.data
		#if there are no filters, exit here
		if( len(self.filters) == 0):
			return
		
		#for each filter on the data:
		for filterInfo in self.filters:
			#initialize a second filter variables, which will become the new filtered data
			self.data_numFiltered2 = []
			self.dataFiltered2 = []
			#get the column header
			header = filterInfo['header']
			#get the index for the column header
			colNum = self.getNumericIndex(header)
			#get the type enum or numeric
			type = filterInfo['type']
			
			#if we are filtering an enum data
			if( type == "enum"):
				#for an enum the splitvalue is the enumerated value that we are filtering on
				splitValue = filterInfo['splitValue']
				#this is the numeric version of this enum in the dataset
				enumNumeric = self.enum_link.get(header)[0][splitValue]
				#filter all the data on this one
				rowNum = 0
				for row in self.dataFiltered:
					#it is of this enum type so we can add the data
					#print self.data_numFiltered[rowNum]
					if( self.data_numFiltered[rowNum, colNum] == enumNumeric):
						self.dataFiltered2.append(row)
						self.data_numFiltered2.append(self.data_numFiltered[rowNum]) 
					#increment row number
					rowNum += 1
				#if we have filtered out all of the data
				if( len(self.dataFiltered2) == 0):
					self.data_numFiltered  = np.matrix([])
					self.dataFiltered = np.matrix([])
					break
				#save this as our filtered data
				self.data_numFiltered = np.vstack(tuple(self.data_numFiltered2))
				self.dataFiltered = np.vstack((self.dataFiltered2))
			#numeric filter, the value must be between the min and max values
			elif( type == "numeric"):
				#get min/max sections
				min = filterInfo['low']
				max = filterInfo['high']
				rowNum = 0
				for row in self.data_numFiltered:
					#check to see if the value is within the given boundaries
					if( row[0,colNum] < max):
						if( row[0,colNum] > min):
				 			#add the data it is between our values
							self.data_numFiltered2.append(row)
							self.dataFiltered2.append(self.data[rowNum])
					#increment the row number
					rowNum +=1
				#if we have filtered out all of the data
				if( len(self.dataFiltered2) == 0):
					self.data_numFiltered  = np.matrix([])
					self.dataFiltered = np.matrix([])
					break
				self.data_numFiltered = np.vstack((self.data_numFiltered2))
				self.dataFiltered = np.vstack(tuple(self.dataFiltered2))
		#print "data", self.dataFiltered, "\n\n"
		#print "data_num", self.data_numFiltered, "\n\n"
		
		return

	#this method will return the number of colums in the data (this will be the number of
	#dimmensions considered. this is helpful because if one filters out all of the data
	# this value will be set to 0
	def filtersize(self):
		shapeFilter = np.shape(self.dataFiltered)
		return shapeFilter[1]
		
		
	#this will print all of the statistical data to an HTML file of the 
	#give filename
	# the statistical information will be compiled as tables where each row is a different dimension (header)
	# and then each column represents a different statistical value such as min, max, stdev and mean.
	# the countStats boolean will print out the occurance statistics genereated using features such as
	# the "count" button on the main GUI. The filterdataBoolean will print out the entire filtered data to the
	# html document when True
	def printDataHtml(self, filename, countStats = True, filterDataBoolean = False):
		if( self.size() == 0):
			print "no Data!"
			return 0
		f = open(filename,'w')
		#adds the unfiltered data
		f.write('computed stats for ' + self.pathname + '<p> un-filtered Statistics <p>')
		stringValue = '<p> number of points %s <p>' % ( str(self.size(dataBoolean = True)))
		f.write(stringValue)
		
		dataLabel = ['min','max','stdev','mean']
		#add a dummy line to the header, this will be the other top
		headers = np.hstack(('-',self.header_num())).tolist()
		#print "headers", headers
		
		#get the statistical data
		
		#min/max
		min,max =self.splitRange(dataBoolean = True)
		#turn into numpy matrices
		min = np.matrix(min)
		max = np.matrix(max)
		#stdev values
		stdevValues = np.matrix(self.stdev_num())
		#mean values
		meanValues = np.matrix(self.mean_num())
		#combined all of the data so that they are columns
		data = np.hstack((min.T,max.T,stdevValues.T,meanValues.T))
		#add the labels of what each column is ( max,min,stdev,mean)
		data = np.vstack((dataLabel, data))
		
		#add the headers which are the rows
		data = np.hstack((np.matrix(headers).T, data))
		#turn this numpy matrix to a list
		value = data.tolist()
		#turn this list to an html table string
		htmlTable = HTML.table(value)
		#write out this string to our file
		f.write(htmlTable)
		
		#if we have filteres applied print out that stats
		if( len(self.filters) != 0):
			#print out the filters
			filterStrings = []
			
			#create a list of all the filters, printed out as a string
			for i in range(len(self.filters)):
				filterStrings.append(self.getFilterString(self.filters[i], i))
			# this will create an HTML list of all of the filters
			htmlcode = HTML.list(filterStrings)
			f.write('<p>Filters<p>')
			f.write(htmlcode)
			f.write('<p>')
			
			#adds the filtered data
			f.write('<p> computed stasts for filtered data <p>')
			
			#number of points in the filtered data set
			
			stringValue = '<p> number of points %s <p>' % ( str(self.size(dataBoolean = False)))
			f.write(stringValue)
			
			
			# this will make the statistical table for the filtered data, this is the same process as above for the full
			# data and compare comments for information
			
			#get filtered data
			dataLabel = ['min','max','stdev','mean']
			#add a dummy line to the header, this will be the other top
			headers = np.hstack(('-',self.header_num())).tolist()
			#get statistical data
			min,max =self.splitRange(dataBoolean = False)
			min = np.matrix(min)
			max = np.matrix(max)
			stdevValues = np.matrix(self.stdev_numFiltered())
			meanValues = np.matrix(self.mean_numFiltered())
			
			#compile data into one large matrix
			data = np.hstack((min.T,max.T,stdevValues.T,meanValues.T))
			
			data = np.vstack((dataLabel, data))
			
			data = np.hstack((np.matrix(headers).T, data))
			
			value = data.tolist()
			#write out table
			htmlTable = HTML.table(value)
			f.write(htmlTable)
			
			
		#print out the count stats if the boolean is true and
		# there are counts data
		if( countStats == True and len(self.counts) != 0):
			f.write('<p> Counted occurances within the data set <p>')
			tableValues = []
			tableValues.append(['Condition1', 'Condition2', 'counts'])
			#for each count, make it a row in our table
			for i  in range (len(self.counts)):
				row = []
				countDic = self.counts[i]
				#first column will be a string which says what the condition 1 was
				col1 = countDic['cond1']
				typeValue = countDic['type1']
				#if the type is numeric, include the values it is between
				if( typeValue == "numeric"):
					#build conditon1
					col1 = col1 + " with a value between: (" + str(countDic['low1']) + ", " + str(countDic['high1']) + ")"
				#it is an enum and include the enum value
				else:
					col1 = col1 + " with the value: " + countDic['split1']
				row.append(col1)
				col2 = countDic['cond2']
				typeValue = countDic['type2']
				#if the type is numeric include the values it is between
				if( typeValue == "numeric"):
			   		col2 = col2 + " with a value between (" + str(countDic['low2']) + ", " + str(countDic['high2']) + ")"
				#it is an enum, include that enum
				else:
					col2 = col2 + " with a value: " + countDic['split2']
				row.append(col2)
				#add the number of counts
				row.append(str(countDic['count']))
				tableValues.append(row)
			htmlcode = HTML.table(tableValues)
			f.write(htmlcode)
			f.write('<p>')
		
		# You can choose to print out all of the filtered data as an HTML table
		if( filterDataBoolean == True and len(self.filters) != 0):
			f.write('<p> Full Filtered Data <p>')
			data = np.vstack((self.header,self.dataFiltered))
			htmlcode = HTML.table(data.tolist())
			f.write(htmlcode)
		
		
		f.close()
		return 1


	# This method will generate a string which has the infromation of what the particular filter (filterValue is a dictionary) contained. the index can be input
	# to number the filter in the string
	# it will output something such as
	#      0, Header: test type, Type: enum, Enum Value: Post-Injury 1 
	def getFilterString(self, filterValue, index):
		#add index first
		filterString = str(index) + ", "
		#add header
		temp = "Header: " + filterValue['header']
		filterString += temp
		#add type
		type = filterValue['type']
		filterString += ", Type: " + type
		#treat the different types differently
		
		# enum type just needs the Enum value you are filtering on
		if( type == "enum"):
			filterString += ", Enum Value: " + filterValue['splitValue']
		#numeric filter needs the low and high end that the data must be between
		elif( type == "numeric"):
			filterString += ", low End: " + str(filterValue['low'])
			filterString += ", high End: " + str(filterValue['high'])
		#return string
		return filterString
	
	
	# This method will remove the rows with missing data from the filtered data matrices. It will go down the rows
	# and check to see if there are anly -9999 values. If there are it will remove the row from the filtered data.
	def removeMissingFiltered(self):
		# we will build these lists as our new filtered data
		data2 = []
		data_num2 = []
		#get the lists of our current filtered data
		data_numlist = self.data_numFiltered.tolist()
		datalist = self.dataFiltered.tolist()
		rowNum = 0
		#for each row in the numeric data
		for row in data_numlist:
			#boolean to tell if we found a missing data value
			missing = False
			#for each column in the row
			for col in row:
				#chceck to see if it is a missing data point
				if( col == float(-9999)):
					#if it is set this boolean to true and we will not add it to our new data list
					missing = True
					#stop checking this row, we already have a missing data  point
					break
			# we  did not find a missing data point, add it to our list of the new data
			if( missing == False):
				data2.append(datalist[rowNum])
				data_num2.append(row)
			rowNum += 1
		#save our new filtered data, and numeric data
		self.data_numFiltered = np.matrix(data_num2)
		self.dataFiltered = np.matrix(data2)
		
		
	# This method will remove the rows that contain missing data from the data object. THIS IS IRREVERSIBLE without reloading the data.
	def removeMissing(self):
		#data we will populate as our new data
		data2 = []
		data_num2 = []
		#lists of current data
		data_numlist = self.data_num.tolist()
		datalist = self.data.tolist()
		rowNum = 0
		#for each row in the numeric data
		for row in data_numlist:
			#boolean to see if we found a missing data
			missing = False
			#for each column in this row
			for col in row:
				#if we find a missing data value
				if( col == float(-9999)):
					#set the bolean to true and stop checking
					missing = True
					break
			#we did not find any missing data in this row, so we can add it to our new data list
			if( missing == False):
				data2.append(datalist[rowNum])
				data_num2.append(row)
			rowNum += 1
		#save our new data as a matrix
		self.data_num = np.matrix(data_num2)
		self.data = np.matrix(data2)
		#compute the new filtered data without the rows with missing data
		self.computeFilter()
		
		
	# This method will set all of the numeric spots with missing data to be equal to the average value in the column.
	def setMissingToAverage(self):
		#get the average for each column
		colmeans = []
		#number of cols
		shapeValues = np.shape(self.data_num)
		colNumbers = shapeValues[1]
		rowNum = shapeValues[0]
		#for each column
		for i in range(0,colNumbers):
			#get col data
			data = self.data_num[:,i]
			#get type
			header = self.getHeader_num(i)
			typeDat = self.type[self.getIndex(header)]
			#if we have a numeric type
			if( typeDat == "numeric"):
				dataRemoved = []
				#for each row check to see if it is a missing data point
				for j in range(0,rowNum):
					if(data[j,0] != float(-9999)):
						dataRemoved.append(data[j,0])
				dataRemoved = np.matrix(dataRemoved).T
				colmeans.append(dataRemoved.mean().tolist())
			#for enum columns just add a dummy
			else:
				colmeans.append(0)
		
		#now reset all missing data point by the computed averages from above
		for i in range(0, colNumbers):
			#check type, because we are only considering numeric
			header = self.getHeader_num(i)
			typeDat = self.type[self.getIndex(header)]
			#do nothing if it is enum type
			if( typeDat == "numeric"):
				for j in range(0,rowNum):
					#if it is missing data
					if( self.data_num[j,i] == float(-9999)):
						#convert string one also
						header = self.getHeader_num(i)
						index = self.getIndex(header)
						#print header,index,j,i
						self.data_num[j,i] = colmeans[i]
						self.data[j,index] = colmeans[i]
						
						
	# this will write out our data to the given filename as a csv (include .csv in the filename) 
	def saveData(self, filename):
		temp = csvWriter(data = self.data, filename = filename, headers = self.header, types = self.type)
		
			
	# This method will count the occurances that two conditions are met which are givne in the newCount dictionary
	# the number of occurances will be added to the dictionary and the dictionary will be saved in a list of these counts
	# so that it can be printed out and referenced later
	def countValues(self, newCount):
		#get the first condition information
		cond1 = newCount.get('cond1')
		data = self.select([cond1])
		type1 = newCount.get('type1')
		# if it is a numeric condition, we need to find the values that are inbetween a min and a max
		if(  type1 == "numeric"):
			low = newCount.get('low1')
			high = newCount.get('high1')
			#get indices of rows that match our condition
			indices = [i for i, x in enumerate(data) if (x >= low and x <= high)]
		#for an enum condition we only need to find out when we have the same enum
		else:
			#enumerated string
			splitType = newCount.get('split1')
			# we need to get the numeric value for this enum string in our numeric data
			linkDic = self.enum_link.get(cond1)[0]
			numericValue = linkDic.get(splitType)
			#these are the indices that this conditon is met
			indices = [i for i, x in enumerate(data) if (x == numericValue)]
			
			
		#now use these indices to check the next condition
		
		#condition 2 information
		cond2 = newCount.get('cond2')
		data = self.select([cond2])
		type1 = newCount.get('type2')
		count = 0
		#again we need to split on the type
		# numeric values need to be between a min and a max
		if( type1 == "numeric"):
			#get low/high values
			low = newCount.get('low2')
			high = newCount.get('high2')
			#for each index that we know meets condition1
			for i in range( len(indices)):
				index = indices[i]
				#get the data point
				dp = data[index,0]
				#see if it matches our second condition, if it does increment our count
				if( ( dp <= high) and ( dp >= low)):
					count += 1
		# if the type is an enum we just need to see if data point matches
		elif( type1 == "enum"):
			#get the numeric version of our enum in this numeric data matrix
			splitType = newCount.get('split2')
			linkDic = self.enum_link.get(cond2)[0]
			numericValue = linkDic.get(splitType)
			#for each index that we know meets condition 1
			for i in range( len(indices)):
				index = indices[i]
				dp = data[index,0]
				#compare the enum numbers
				if( dp == numericValue):
					#it matches, increment
					count += 1
		#save the number of counts
		newCount['count'] = count
		#add the data to our list
		self.counts.append(newCount)
		#this will print the result out to the user
		print newCount
		
		
		
					