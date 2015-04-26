#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox
#this class will create a dialog window for plotting pca data on the main program.
class PCADialog(Toplevel):
    
    #constructor method
    def __init__(self, parent, displayClass, pcaDataHeader, Analysis, title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #set class
        self.dClass = displayClass
        #set analysis
        self.Analysis = Analysis
        self.result = None
        self.pcaDataheader = pcaDataHeader
        
        body = Frame(self)
        self.initial_focus = self.body(body)
        body.pack(padx=5,pady=5)
        
        self.buttonbox()
        
        self.grab_set()
        
        if not self.initial_focus:
            self.initial_focus = self
            
            
        self.protocol("WM_DELETE_WINDOW", self.cancel)
        
        #positions the window relative to the parent
        self.geometry("+%d+%d" % (parent.winfo_rootx()+50, parent.winfo_rooty()+50))
        
        self.initial_focus.focus_set()
        
        self.wait_window(self)
        
    # This sets up the body of the popup dialog with all of the buttons and information
    def body(self,master):
        #create dialog body. return widget that should have
        #initial focus. this method should be overriden
        
        
        #get the eigen values
        eigval = self.Analysis.getEigVal()
        valueNum = 0
        optionList = ()
        optionList += ('', )
        #create a string that lists all of the eigen values
        for value in eigval:
            
            optionList += (str(valueNum)+" : " + str(value), )
            valueNum += 1
        #create a label that shows the list of eigen values to the user with a number that is associated in the drop box 
        #graph menu below
        w = Label(master,text="Choose which Eigenvectors to plot based on Eigenvalues")
        
        w.grid(row=0, columnspan=(2*len(eigval)), sticky=W)

        
        # labels that go with the option menus
        Label(master, text="X axis:").grid(row=1)
        Label(master, text="Y axis:").grid(row=2)
        Label(master, text="Optional Components").grid(row=3)
        Label(master, text="Z axis:").grid(row=4)
        #Label(master, text="Color Dim:").grid(row=5)
        #Label(master, text="Size Dim:").grid(row=6)

             
        
        

        #set up the variables for each of the different dimmensions
    
        self.x = StringVar()
        self.x.set(optionList[0])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om1 = apply(OptionMenu, (master, self.x) + optionList)
        self.om1.grid(row=1, column=1)
        
        self.y = StringVar()
        self.y.set(optionList[0])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om2 = apply(OptionMenu, (master, self.y) + optionList)
        self.om2.grid(row=2, column=1)
        
        self.z = StringVar()
        self.z.set(optionList[0])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om3 = apply(OptionMenu, (master, self.z) + optionList)
        self.om3.grid(row=4, column=1)
        
        
        self.writeVar = IntVar()
        self.writeButton = Checkbutton(master,text = "save PCA", variable = self.writeVar)
        self.writeButton.grid(row=5,columnspan=2,sticky=W)
        
        Label(master,text="Filename (optional):").grid(row=6,column=0,sticky=W)
        self.filenameVar = StringVar()
        self.filenameVar.set("")
        self.filenameEntry = Entry(master,textvariable = self.filenameVar)
        self.filenameEntry.grid(row=6, column=1)
        
        return self.om1 # initial focus

    
    #This is the cancel / ok button
    def buttonbox(self):
        #add standard button box
        box = Frame(self)
        
        #ok button
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
        # cancel button
        w = Button(box,text="Cancel", width=10,command = self.cancel)
        w.pack(side=LEFT,padx=5,pady=5)
        
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.cancel)
        
        box.pack()
        
    # ok button will first validate the choices (see validate method) and then exit the dialog
    # if everything is ok 
    def ok(self, event = None):
        if not self.validate():
            self.initial_focus.focus_set() #put focus back
            return
        
        self.withdraw()
        self.update_idletasks()
        self.apply()
        #sets a boolean to know if the data should be graphed or not
        self.pcaDataheader['check'] = True
        self.parent.focus_set()
        self.destroy()
        return 1
        
    # this is a cancel button which will just exit the dialog and should not plot anything
    def cancel(self, event = None):
        #sets a boolean to know if the data should be graphed or not
        self.pcaDataheader['check'] = False
        #put focus back on parent window
        self.parent.focus_set()
        self.destroy()
        return 0
       
    #this tests to make sure that there are inputs 
    def validate(self):
        if(self.dClass.dataTest() == False):
            tkMessageBox.showwarning("Bad input","No data loaded")
            return 0
        # get input options
        
        xValue = self.x.get()
        if(xValue == ""):
            x = ''
        else:
            x = xValue.split()[0]
        yValue = self.y.get()
        if(yValue == ""):
            y = ''
        else:
            y = yValue.split()[0]
        
        
        if( x != ''):
            x = int(x)
    
        if( y != ''):
            y = int(y)
        
        messageString = ""
        #check the x axis
        if( x == ''):
            messageString += " No input to x axes."
        
        #check the y axis
        if( y == ''):
            messageString += " No input to y axes."

       
        #we have at least one error
        if( messageString != ""):
            tkMessageBox.showwarning("Bad input",messageString)
            return 0
        
        #returns 1 if everything is ok
        return 1
    
    #this method is called right before exiting. it will set the input dictionary with the information for
    # the display method to grab the data and graph it
    def apply(self):
        #get initial values
        xValue = self.x.get()
        x = xValue.split()[0]
        yValue = self.y.get()
        y = yValue.split()[0]
        zValue     = self.z.get()
        
        
        #the value for the dictionary is the index number on the pca columns data
        self.pcaDataheader['x'] = int(x)
        self.pcaDataheader['y'] = int(y)
        
        #if there is a z data spot
        if( zValue != ''):
            z = zValue.split()[0]
            self.pcaDataheader['z'] = int(z)
        
        if(self.writeVar.get() == 1):
            filename = self.filenameVar.get()
            if( filename == ''):
                filename = "test.csv"
            
            self.pcaDataheader['filename'] = filename
            self.pcaDataheader['saveData'] = True
            
            
        return
     
        
    
      
#        
#root = Tk()
#Button(root,text="Hello!").pack()
#root.update()
#d = MyDialog(root, dataHeader = {})
#root.wait_window(d.top)