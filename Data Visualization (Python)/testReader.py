import numpy as np
from dataRead import *
import os
from countInfo import *
from Tkinter import *

#os.system("open BasicUnixCommands.html")
#

l = np.matrix([])
#print np.shape(l)[0,0]
#print l
#a = csvDataReader(pathName = "MCMI2010.csv")
#root = Tk()
#emp = countInfo(parent = root, dataObject = a)
#a.setMissingToAverage()
#a.saveData('test123.csv')
#a = csvDataReader(pathName = "AustraliaCoast.csv")
#a = csvDataReader(pathName = "MCMI2010.csv")
a = csvDataReader(pathName = "testdata.csv")
b = a.select('0')
root = Tk()
emp = countInfo(parent = root, dataObject = a)
#print a.range_num()
#min, max = a.splitRange()
#print min


#newFilter = {}
#newFilter['header'] = '0'
#newFilter['type'] = "numeric"
#newFilter['low'] = 0
#newFilter['high'] = 99999999

#newFilter = {}
#newFilter['header'] = 'premax'
#newFilter['type'] = "numeric"
#newFilter['low'] = 400
#newFilter['high'] = 99999999
#
#a.addFilter(newFilter)
#a.printDataHtml('hello.html')
#
##a.removeFilter(newFilter)
#
#
#newFilter2 = {}
#newFilter2['header'] = '5'
#newFilter2['type'] = "enum"
#newFilter2['splitValue'] = "a"
#
#a.addFilter(newFilter2)
#
#
#newFilter3 = {}
#newFilter3['header'] = '5'
#newFilter3['type'] = "enum"
#newFilter3['splitValue'] = "b"
#
#a.addFilter(newFilter3)

#newFilter = {}
#newFilter['header'] = 'below'
#newFilter['type'] = 'enum'
#
#a.addFilter(newFilter)
#
#values = a.getFilters()
#print values
#filter1 = values[0]
#print filter1
#filter1['header'] = 'damn'
#values2 = a.getFilters()
#print values2
#a.removeFilter(values2[1])
#values3 = a.getFilters()
#print values3

#
#a = np.matrix([1,2,3])
#b = np.matrix([2,3,4])
#c = np.vstack((a,b))
#print a
#print b
#print c
#
#d = ()
#d = (d, b)
#print d
#
#
#e = np.matrix([[1,2,3],[4,5,6],[7,8,9]])
#print e
#f = e[0]
#g = e[1]
#h = np.vstack((f,g))
#print f
#print g
#print h
#print h[0]