#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox
from viewFilters import *

#This class will create a dialog box for filtering the data that is loaded. It will allow you to choose either an enum to filter on. or if you want to filter on a 
# numeric value it will allow you to choose if you want it to be a "greater than", "less than" or "in between" choice. The apply button will then validate your 
#choice and apply the filter to the data object that was input to the class. The ok button will close the window. The view filters button will allow the user to view the current filters in place
# by opening another dialog box

class filterDialog(Toplevel):
    
    #constructor method
    def __init__(self, parent, displayClass, dataObj,  title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #set class
        self.dClass = displayClass
        #save the data object
        self.dataObj = dataObj
        
        #boxes
        self.colChoice = None
        #variableGet
        self.splitValue = None
        #split option dropdown Menu for both numeric and enum sections
        self.splitChoice = None
        #column choice optionMenu for both numeric and enums
        self.choice = None
        #holds the labels and entry boxes for the numeric data
        self.labels = []
        #low end and high end choices for filtering on a numeric value
        self.lowEnd = StringVar()
        self.highEnd = StringVar()
        
        
        self.canvas = Canvas(self)
        self.initial_focus = self.body(self.canvas)
        self.canvas.pack(padx=5,pady=5)
        
        self.buttonbox()
        
        self.grab_set()
        
        if not self.initial_focus:
            self.initial_focus = self
            
            
        self.protocol("WM_DELETE_WINDOW", self.ok)
        
        #positions the window relative to the parent
        self.geometry("+%d+%d" % (parent.winfo_rootx()+50, parent.winfo_rooty()+50))
        
        self.initial_focus.focus_set()
        
        self.wait_window(self)
        
    # This sets up the body of the popup dialog with all of the buttons and information
    def body(self,master):
        #create dialog body. return widget that should have
        #initial focus. this method should be overriden
        
        #set up a choice for the user to choose if the filter is on a numeric
        # or an enum variable
        self.NumVar = IntVar()
        self.EnumVar = IntVar()
        self.numCheck = Checkbutton(master, text = "Numeric", variable = self.NumVar, command = self.numericCallback)
        self.numCheck.grid(row=0,column=0)
        self.EnumCheck = Checkbutton(master,text="Enum",variable = self.EnumVar, command = self.enumCallback)
        self.EnumCheck.grid(row=0,column=1)
   
    #callback for when the user selects the enum checkbox, it will get all of the enumerated columns in the 
    # data and put them in a dropdown menu for the user to select a specific column
    def enumCallback(self):
        #deselect the numeric choice because the user wants an enum
        self.numCheck.deselect()
        #delete all old objects on the canvas if there are any
        self.clearAllObjects()
        
        #if the button is selected
        if(self.EnumVar.get() == 1):
        
            #create a dropdown box of all of the enum types in the data
            headers = tuple(self.dataObj.getEnumType())
            self.colChoice = StringVar()
            self.colChoice.trace('w', self.enumGet)
            self.choice = OptionMenu(self.canvas, self.colChoice, *headers)
            self.choice.grid(row=1,column=0)
    
        
    #this method will remove all the objects from the canvas. This does not remove the buttons or the checkboxes (for enum/numeric) but \
    #will remove any specific dropdown menus or entrys that they have created
    def clearAllObjects(self):
        #If this widget has been made, remove it
        if( self.choice ):
            self.choice.destroy()
            self.choice = None
        
        if( self.splitChoice ):
            self.splitChoice.destroy()
            self.splitChoice = None
        #this will help prevent the user from hitting ok when they havent selected anything, checked in validation
        self.splitValue = None
        #removes all labels for the numeric cases (see method)
        self.clearLabels()
            


    #This is a callback on the stringvariable in the option menu for the enumerated columns. It will get all the enumerated values for the specific header that 
    # was selected and put them in a dropdown menu for the user to choose.
    def enumGet(self,name,index,mode):
        #if the dropdown menu already exists, remove it first
        if( self.splitChoice):
            self.splitChoice.destroy()
            self.splitChoice = None
        #get the enumerated values for the selected headers
        keys = tuple(self.dataObj.getEnumValues(self.colChoice.get()))
        #make the dropdown menu
        #this is the string that will contain the chosen key
        self.splitValue = StringVar()
        self.splitChoice = OptionMenu(self.canvas, self.splitValue, *keys)
        self.splitChoice.grid(row=2,column=0)
        
    
    # This is a callback for the numerical checkbox. It will be called whenever the user selects/deselects the checkbox. Additionally it will deselect
    # the enumerated checkbox because only 1 can be checked at a time. it will first remove
    # any objects on the canvas except the two initial checkboxes. After that it will check to see if it is selected. if isn't it will do nothing.
    # if it is selected the method will get a list of all of the headers that are of numeric type and put them in a dropdown menu box for the user
    # to select one to filter on
    def numericCallback(self):
        #deselect the enum checkbox because we can only have one selected at a time
        self.EnumCheck.deselect()
        #delete all old objects on the canvas if there are any
        self.clearAllObjects()
        #only do something if the checkbox is actually checked
        if( self.NumVar.get() == 1):
            #get the numeric headers in the data
            headers = tuple(self.dataObj.getNumericOnly())
            #set a callback on the user's choice of numeric header
            self.colChoice = StringVar()
            self.colChoice.trace('w', self.numType)
            #make a dropdown box
            self.choice = OptionMenu(self.canvas, self.colChoice, *headers)
            self.choice.grid(row=1,column=0)
        return
    
    # This callback will give the user more options after he/she has chosen a given numeric header to filter on
    # this method will create an additional dropdown menu for the user to choose to filter the numeric values either
    # "greater than" a certain value, "less than" a certain value, or "inbetween" two values. 
    def numType(self,name,index,mode):
        #remove any potential stuff already on canvas
        if( self.splitChoice):
            self.splitChoice.destroy()
            self.splitChoice = None
        self.clearLabels()
        
        #set up the variable to hold the users choice and a callback to be called when the 
        #value changes
        self.splitValue = StringVar()
        self.splitValue.trace('w', self.numChoices)
        #different options
        keys = ("greater than", "less than", "in between")
        #make the option menu
        self.splitChoice = OptionMenu(self.canvas, self.splitValue, *keys)
        self.splitChoice.grid(row = 2, column = 0)
        return
    
    
    # This method will clear the canvas of the entry and labels associated with choosing a numeric filter point
    #it will also reset the filter string vars to 0
    def clearLabels(self):
        #remove all objects
        for i in range( len(self.labels)):
            self.labels[i].destroy()
        #reset list
        self.labels = []
        self.lowEnd.set("0")
        self.highEnd.set("0")
    
    # this method will be called when the user selects a filter option. The method will remove any previously created entry/labels and then
    # create new ones on the canvas for the user based on their chioce in the above dropdown box
    def numChoices(self, name, index, mode):
        #clear labels if they are already on the canvas
        self.clearLabels()
        #get the user choice
        choice = self.splitValue.get()
        
        #make entry spot for the user based on their choice of less than, greater than or in between
        if( choice == "greater than"):
            self.textLabel = Label(self.canvas, text = "Greater than:")
            self.textLabel.grid(row=3,column=0)
            self.lowEnd.set("0")
            #there is no high end on this so we just put NAN to be checked later
            self.highEnd.set("NAN")
            self.entryPoint = Entry(self.canvas, textvariable = self.lowEnd)
            self.entryPoint.grid(row=3,column=1)
        #user chose the less than option 
        elif( choice == "less than"):
            self.textLabel = Label(self.canvas, text = "Less than:")
            self.textLabel.grid(row=3,column=0)
            #there is no lower end in this choice so we put NAN to be checked later
            self.lowEnd.set("NAN")
            self.highEnd.set("0")
            self.entryPoint = Entry(self.canvas, textvariable = self.highEnd)
            self.entryPoint.grid(row=3,column=1)
        #user chose the inbetween option
        else:
            self.textLabel = Label(self.canvas, text = "Greater than:")
            self.textLabel.grid(row=3,column=0)
            #both an upper and lower value on this choice
            self.lowEnd.set("0")
            self.highEnd.set("0")
            self.entryPoint = Entry(self.canvas, textvariable = self.lowEnd)
            self.entryPoint.grid(row=3,column=1)
            # we have to put 2 lines here 1 for greater than and 1 for less than
            self.textLabel2 = Label(self.canvas, text = "Less than:")
            self.textLabel2.grid(row =4, column = 0)
            self.entryPoint2 = Entry(self.canvas, textvariable = self.highEnd)
            self.entryPoint2.grid(row=4,column=1)
            #add the labels/entries to the self.labels list which allows us to easily remove them latter
            self.labels.append(self.textLabel2)
            self.labels.append(self.entryPoint2)
        #add to self.labels for easy removal via self.clearLabels method
        self.labels.append(self.entryPoint)
        self.labels.append(self.textLabel)

        
    #create buttons on the window for the user to have option
    def buttonbox(self):
        #add standard button box
        box = Frame(self)
        
        #ok button
        w = Button(box, text="OK", width = 5, command = self.ok, default=ACTIVE)
        w.grid(row = 0, column=0)
        #w.pack(side=LEFT,padx=5,pady=5)
        
        #apply button
        w = Button(box,text="Apply", width=5, command = self.apply)
        #w.pack(side=LEFT,padx=5,pady=5)
        w.grid(row = 0, column=1)
        # view current filters
        w = Button(box,text="View Filters", width=10,command = self.viewFilters)
        #w.pack(side=LEFT,padx=5,pady=5)
        w.grid(row = 0, column=2)
        
        w = Button(box,text= "Remove All Missing", width = 15, command = self.removeMissing)
        #w.pack(side=BOTTOM, padx = 5, pady = 5)
        w.grid(row = 1, columnspan = 2)
        
        w = Button(box, text = "Remove Missing from Filtered", width = 30, command = self.removeMissingFiltered)
        w.grid(row=2, columnspan=3)
        
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.ok)
        
        box.pack()
        
    # this method will remove all the rows with missing data from the filtered data. This will need to be recalled everytime that the
    # user updates the filters because that causes the filtered data to be recomputed. 
    def removeMissingFiltered(self):
        #remove the rows with missing data
        self.dataObj.removeMissingFiltered()
        #update the display that shows how many points the current data set contains
        self.dClass.upDatePoints()
        
    # This method will remove, permanently from the dataObject the rows that contain any missing data. This will warn the user first that this is
    # an irreversable process and the data would need to be reloaded. It will then remove the rows and update the number of poitns on the display
    def removeMissing(self):
        #warn the user of the operation we are about to do
        response = tkMessageBox.askyesno(title = "Are you sure!", message = "We cannot undo this operation and you would need to reload data")
         #if the user wants to remove the missing data
        if response:
            #remove the points from the data object
            self.dataObj.removeMissing()
            #update the points display on the main GUI
            self.dClass.upDatePoints()
            
        else:
            return
      

        
    #this method will allow the user to open an additional window and view the filters that they have already put on the data
    #the user will be able to remove filters in this window
    def viewFilters(self):
        temp = viewFilters(parent = self.parent, dClass = self.dClass, dataObject = self.dataObj, title = "Current Filters")
        return
        
    # ok button will exit the window. 
    def ok(self, event = None):
        self.parent.focus_set()
        self.destroy()
        return 1
        

    
       
    #this tests to make sure that there are valid choices for the filters before saving them to the dataObject and appling the filters
    #to the loaded data. 1 == inputs are valid, 0 == inputs are invalid
    def validate(self):
        #if it is a filter on an enumerated column
        if( self.EnumVar.get() == 1):
            #this means that the user has had the option to look at enum types
            if( self.splitValue != None):
                #the user has actually selected an option
                if( self.splitValue.get() != ""):
                    return 1
                else:
                    tkMessageBox.showwarning("Select Value", "You have not selected an enumerated value yet!")
                    return 0
            else:
                return 0
        #if it is a filter on a numeric column
        if( self.NumVar.get() == 1):
            #the user has selected at least 1 option so that the entry spots exist on the canvas if this
            #variable is not None
            if(self.entryPoint != None):
                #switch on the type of filter, above, below or in between
                choice = self.splitValue.get()
                print choice
                if( choice == "greater than"):
                    #try to double the value and if you can't, we have a problem
                    try:
                        x = float(self.lowEnd.get())
                    except:
                        tkMessageBox.showwarning("Cannot convert your input", "Bad Input! Please input a double only!")
                        return 0
                    #was able to float the input, we can validate
                    return 1
                #user is input to the highEnd variable, check that
                elif( choice == "less than"):
                    try:
                        x = float(self.highEnd.get())
                    #failed to convert, notify user
                    except:
                       tkMessageBox.showwarning("Cannot convert your input", "Bad Input! Please input a double only!")
                       return 0 
                    #was able to convert input, we can validate
                    return 1
                #the user is doing an inbetween meaning that we need to check both variables
                else:
                    try:
                        x = float(self.lowEnd.get())
                        y = float(self.highEnd.get())
                    except:
                        tkMessageBox.showwarning("Cannot convert your input", "Bad Input! Please input a double only!")
                        return 0
                    #we could float both variables, we can validate
                    return 1
        #the user has not selected anything, validation fails
        return 0
    
    #This method will apply the filters that the user input. it will first validate the filter choices to make sure they are legit and show 
    # an error message if the users choices are bad
    def apply(self):
        #if validation fails exit method
        if( self.validate() == 0):
            return
        #dictionary will hold the filter information
        newFilter = {}
        #filtering on a enum variable
        if( self.EnumVar.get() == 1):
            newFilter['type'] = "enum"
            #add the header to our new filter dictionary
            newFilter['header'] = self.colChoice.get()
            #add the enum that they are splitting on
            newFilter['splitValue'] = self.splitValue.get()            
        #filtering a numeric variable
        elif( self.NumVar.get() == 1):
            #numeric type
            newFilter['type'] = "numeric"
            #header we are filtering on
            newFilter['header'] = self.colChoice.get()
           
            #we need to figure out what type of numeric split we are doing so that we can set the appropriate variables
            choice = self.splitValue.get()
            if( choice == "greater than"):
                #only the low end was input, there is no high end, set it to the max value for the system
                min = float(self.lowEnd.get())
                max = sys.float_info.max
            elif( choice == "less than"):
                #only the high end was input, there is no low end, set it to the min value for the system
                min = -sys.float_info.max
                max = float(self.highEnd.get())
            else:
                #filter is inbetween two values
                min = float(self.lowEnd.get())
                max = float(self.highEnd.get())
               
            newFilter['low'] = min
            newFilter['high'] = max
            
        self.dataObj.addFilter(newFilter)
        #update point display
        self.dClass.upDatePoints()
        #reset the filter options for the user to potentially add
        #another filter
        self.EnumCheck.deselect()
        self.numCheck.deselect()
        self.clearAllObjects() 
        return
     
