import csv

#This class will write out the given data into a csv file with the given filename. The first
#row will be the header, the second the type as input to the class
class csvWriter:

    def __init__(self,data,filename, headers,types):
        self.data = data
        self.filename = filename
        self.headers = headers
        self.types = types
        #save data
        self.writeData()

	#this method writes the data out
    def writeData(self):
        writeFile = open(self.filename,'wb')
        dataWriter = csv.writer(writeFile, delimiter=',')
        #write out the header and type first
        dataWriter.writerow(self.headers)
        dataWriter.writerow(self.types  )
        #for each row write the data
        for row in self.data:
            row = row.tolist()[0]
            dataWriter.writerow(row)
    
        writeFile.close()