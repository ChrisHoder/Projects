#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox

class countInfo(Toplevel):
    
    def __init__(self, parent, dataObject, title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #input the dataObject
        self.dataObj = dataObject
        
        #col 1 objects on the canvases
        self.col1Objects = []
        #col2 objects on the canvas
        self.col2Objects = []
        
        self.lowEnd = StringVar()
        self.highEnd = StringVar()
        self.lowEnd2 = StringVar()
        self.highEnd2 = StringVar()
        self.labels = []
        self.labels2 = []
        self.choice = None
        self.choice2 = None
        self.cond1Menu = None
        self.cond2Menu = None
        self.cond1 = None
        self.cond2 = None
        self.cond1SplitNumeric = None
        self.cond2SplitNumeric = None
       
        #top wrapper frame
        self.frameTopLevel = Frame(self, bd = 2)
        self.frameTopLevel.pack()
       
        self.canvas = Canvas(self.frameTopLevel)
        self.initial_focus = self.Condition1(self.canvas)
        self.canvas.pack(padx=5,pady=5)
        
        self.buttonbox(self.frameTopLevel)
        
        self.canvas2 = Canvas(self.frameTopLevel)
        self.Condition2(self.canvas2)
        self.canvas2.pack(side = BOTTOM, padx = 5, pady = 5)
        
        
        
        
        self.grab_set()
        
        if not self.initial_focus:
            self.initial_focus = self
            
            
        self.protocol("WM_DELETE_WINDOW", self.cancel)
        
        #positions the window relative to the parent
        self.geometry("+%d+%d" % (parent.winfo_rootx()+50, parent.winfo_rooty()+50))
        
        self.initial_focus.focus_set()
        
        self.wait_window(self)
        
    def Condition1(self,master):
        #create label with input text
        Label( master, text = "Condition 1:").grid(row=0, column = 0)
        headers = tuple(self.dataObj.header_num())
        self.cond1 = StringVar()
        self.cond1.trace('w', self.getValues)
        self.choice = OptionMenu(master, self.cond1, *headers)
        self.choice.grid(row=0,column = 1 )
        
        return
    
    def Condition2(self, master):
        #create label with input text
        Label( master, text = "Condition 2:").grid(row=0, column = 0)
        headers = tuple(self.dataObj.header_num())
        self.cond2 = StringVar()
        self.cond2.trace('w', self.getValues2)
        self.choice2 = OptionMenu(master, self.cond2, *headers)
        self.choice2.grid(row=0,column = 1 )
        
    def getValues2(self, name, index, mode):
        #clear any already existent menus
        self.clearColChoices(False)
        
        value = self.cond2.get()
        index = self.dataObj.getIndex(value)
        type  = self.dataObj.getType(index)
        if( type == "enum"):
            #get the enum values
            keys = tuple(self.dataObj.getEnumValues(value))
            self.cond2Split = StringVar()
            self.cond2Menu = OptionMenu(self.canvas2, self.cond2Split, *keys)
            self.cond2Menu.grid(row=1,column=0)
            self.col2Objects.append(self.cond2Menu)
        elif( type == "numeric"):
            self.cond2SplitNumeric = StringVar()
            self.cond2SplitNumeric.trace('w', self.numericSplit2)
            keys = ("greater than", "less than", "in between")
            self.cond2Menu = OptionMenu(self.canvas2, self.cond2SplitNumeric, *keys)
            self.cond2Menu.grid(row=1,column=0)
            self.col2Objects.append(self.cond2Menu)
        return
    
    def clearLabels2(self):
        #remove all objects
        for i in range( len(self.labels2)):
            self.labels2[i].destroy()
        #reset list
        self.labels2 = []
        self.lowEnd2.set("0")
        self.highEnd2.set("0")
        
    def numericSplit2(self, name, index, mode):
        #clear labels if they are already on the canvas
        self.clearLabels2()

        #get the user choice
        choice = self.cond2SplitNumeric.get()
        
        #make entry spot for the user based on their choice of less than, greater than or in between
        if( choice == "greater than"):
            self.textLabel = Label(self.canvas2, text = "Greater than:")
            self.textLabel.grid(row=2,column=0)
            self.lowEnd2.set("0")
            #there is no high end on this so we just put NAN to be checked later
            self.highEnd2.set("NAN")
            self.entryPoint = Entry(self.canvas2, textvariable = self.lowEnd2)
            self.entryPoint.grid(row=2,column=1)
        #user chose the less than option 
        elif( choice == "less than"):
            self.textLabel = Label(self.canvas2, text = "Less than:")
            self.textLabel.grid(row=2,column=0)
            #there is no lower end in this choice so we put NAN to be checked later
            self.lowEnd2.set("NAN")
            self.highEnd2.set("0")
            self.entryPoint = Entry(self.canvas2, textvariable = self.highEnd2)
            self.entryPoint.grid(row=2,column=1)
        #user chose the inbetween option
        else:
            self.textLabel = Label(self.canvas2, text = "Greater than:")
            self.textLabel.grid(row=2,column=0)
            #both an upper and lower value on this choice
            self.lowEnd2.set("0")
            self.highEnd2.set("0")
            self.entryPoint = Entry(self.canvas2, textvariable = self.lowEnd2)
            self.entryPoint.grid(row=2,column=1)
            # we have to put 2 lines here 1 for greater than and 1 for less than
            self.textLabel2 = Label(self.canvas2, text = "Less than:")
            self.textLabel2.grid(row =3, column = 0)
            self.entryPoint2 = Entry(self.canvas2, textvariable = self.highEnd2)
            self.entryPoint2.grid(row=3,column=1)
            #add the labels/entries to the self.labels list which allows us to easily remove them latter
            self.labels2.append(self.textLabel2)
            self.labels2.append(self.entryPoint2)
        #add to self.labels for easy removal via self.clearLabels method
        self.labels2.append(self.entryPoint)
        self.labels2.append(self.textLabel)
        return
    
    
    #this will clear the option menus associated with after choosing a columnn for condition 1.
    def clearColChoices(self, boolean):
        #remove all obejcst from list
        if( boolean == True):
            objsList = self.col1Objects
            self.clearLabels()
        else:
            objsList = self.col2Objects
            self.clearLabels2()
            
        for i in range( len(objsList)):
            objsList[i].destroy()
        if( boolean == True):
            self.col1Objects = []
        else:
            self.col2Objects = []
#        if( self.cond1Menu != None):
#            self.cond1Menu.destroy()
#            self.cond1Menu = None
#            self.cond1Split = None
#            self.cond1SplitNumeric = None

        

    def getValues(self, name, index, mode):
        #clear any already existent menus
        self.clearColChoices(True)
        
        value = self.cond1.get()
        index = self.dataObj.getIndex(value)
        type  = self.dataObj.getType(index)
        if( type == "enum"):
            #get the enum values
            keys = tuple(self.dataObj.getEnumValues(value))
            self.cond1Split = StringVar()
            self.cond1Menu = OptionMenu(self.canvas, self.cond1Split, *keys)
            self.cond1Menu.grid(row=1,column=0)
            self.col1Objects.append(self.cond1Menu)
        elif( type == "numeric"):
            self.cond1SplitNumeric = StringVar()
            self.cond1SplitNumeric.trace('w', self.numericSplit)
            keys = ("greater than", "less than", "in between")
            self.cond1Menu = OptionMenu(self.canvas, self.cond1SplitNumeric, *keys)
            self.cond1Menu.grid(row=1,column=0)
            self.col1Objects.append(self.cond1Menu)
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
    
    
    def numericSplit(self, name, index,mode):
        #clear labels if they are already on the canvas
        self.clearLabels()

        #get the user choice
        choice = self.cond1SplitNumeric.get()
        
        #make entry spot for the user based on their choice of less than, greater than or in between
        if( choice == "greater than"):
            self.textLabel = Label(self.canvas, text = "Greater than:")
            self.textLabel.grid(row=2,column=0)
            self.lowEnd.set("0")
            #there is no high end on this so we just put NAN to be checked later
            self.highEnd.set("NAN")
            self.entryPoint = Entry(self.canvas, textvariable = self.lowEnd)
            self.entryPoint.grid(row=2,column=1)
        #user chose the less than option 
        elif( choice == "less than"):
            self.textLabel = Label(self.canvas, text = "Less than:")
            self.textLabel.grid(row=2,column=0)
            #there is no lower end in this choice so we put NAN to be checked later
            self.lowEnd.set("NAN")
            self.highEnd.set("0")
            self.entryPoint = Entry(self.canvas, textvariable = self.highEnd)
            self.entryPoint.grid(row=2,column=1)
        #user chose the inbetween option
        else:
            self.textLabel = Label(self.canvas, text = "Greater than:")
            self.textLabel.grid(row=2,column=0)
            #both an upper and lower value on this choice
            self.lowEnd.set("0")
            self.highEnd.set("0")
            self.entryPoint = Entry(self.canvas, textvariable = self.lowEnd)
            self.entryPoint.grid(row=2,column=1)
            # we have to put 2 lines here 1 for greater than and 1 for less than
            self.textLabel2 = Label(self.canvas, text = "Less than:")
            self.textLabel2.grid(row =3, column = 0)
            self.entryPoint2 = Entry(self.canvas, textvariable = self.highEnd)
            self.entryPoint2.grid(row=3,column=1)
            #add the labels/entries to the self.labels list which allows us to easily remove them latter
            self.labels.append(self.textLabel2)
            self.labels.append(self.entryPoint2)
        #add to self.labels for easy removal via self.clearLabels method
        self.labels.append(self.entryPoint)
        self.labels.append(self.textLabel)
        return

    
    def buttonbox(self, master):
        #add standard button box
        box = Frame(master)
        
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
        
#        w = Button(box, text ="CANCEL", width = 10, command = self.cancel)
#        w.pack(side=LEFT, padx = 5, pady = 5)
#        
        w = Button(box, text = "APPLY", width = 10, command = self.apply)
        w.pack(side=LEFT, padx = 5, pady = 5)
        
        w = Button( box, text = "Clear", width = 10, command = self.clear)
        w.pack(side=LEFT, padx = 5, pady = 5)
       
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.cancel)
      
        
        box.pack(side = BOTTOM)
    
    #this method will clear all saved counts
    def clear(self, event = None):
        self.dataObj.clearCounts()
        
    def ok(self, event = None):
        self.withdraw()
        self.update_idletasks()
        self.parent.focus_set()
        self.destroy()
        return
    
    def cancel(self, event = None):
        self.parent.focus_set()
        self.destroy()
        
    #This will create the dictionary to hold the count information as well
    # as have the dataObject count the occurances
    def apply(self):
        #validate that correct options have been chosen
        check = self.validate()
        if( check == 0):
            return
        #initialize new dictionary
        newCount = {}
        newCount['cond1'] = self.cond1.get()
        index = self.dataObj.getIndex(self.cond1.get())
        typeValue = self.dataObj.getType(index)
        newCount['type1']  = typeValue
        #different type of condition will have different values in the dictionary
        #numeric type will have the low and high end values
        if( typeValue == "numeric"):
            choice = self.cond1SplitNumeric.get()
            if( choice == "greater than"):
                min = float(self.lowEnd.get())
                max = sys.float_info.max
            elif( choice == "less than"):
                min = -sys.float_info.max
                max = float(self.highEnd.get())
            else:
                min = float(self.lowEnd.get())
                max = float(self.highEnd.get())
            newCount['low1'] = min
            newCount['high1'] = max
        #enum type will have just the enumerated value that we are looking for
        # saved as split1 in the dictionary
        elif( typeValue == "enum"):
            newCount['split1'] = self.cond1Split.get()
            
        #now save the information for the second condition
        cond2 = self.cond2.get()
        newCount['cond2'] = cond2
        index = self.dataObj.getIndex(cond2)
        typeValue = self.dataObj.getType(index)
        #print index
        #print self.dataObj.getType(index)
        #again treat the two types differently with the numeric saving the low and high end
        # and the enumerated value having just the split string
        newCount['type2'] = typeValue
        if( typeValue == "numeric"):
            choice = self.cond2SplitNumeric.get()
            if( choice == "greater than"):
                min = float(self.lowEnd2.get())
                max = sys.float_info.max
            elif( choice == "less than"):
                min = -sys.float_info.max
                max = float(self.highEnd2.get())
            else:
                min = float(self.lowEnd2.get())
                max = float(self.highEnd2.get())
            newCount['low2'] = min
            newCount['high2'] = max
            #save the split string under the key split2
        elif( typeValue == "enum"):
            newCount['split2'] = self.cond2Split.get()
        #compute the occurances in the data object
        self.dataObj.countValues(newCount)
        #reset the menu back to origional state
        self.clearColChoices(True)
        self.clearColChoices(False)
        self.cond1.set("")
        self.cond2.set("")
        #print newCount
        
    # This method will validate the users inputs, it will make sure that the user has
    # selected something for both the conditions and if one of them is numeric
    # it will check to see that the inputs are actually numbers, if not then it
    # will alert the user and return a 0, otherwise it will return a 1
    def validate(self):
        cond1 = self.cond1.get()
        cond1Type = self.dataObj.getType(self.dataObj.getIndex(cond1))
        cond2 = self.cond2.get()
        cond2Type = self.dataObj.getType(self.dataObj.getIndex(cond2))
        #no initial choice
        if( cond1 == "" or cond2 == ""):
            return 0
        #check condition1 first
        if( cond1Type == "numeric"):
            #try to float their inputs
            try:
                x = float(self.lowEnd.get())
                y = float(self.highEnd.get())
            except:
                tkMessageBox.showwarning("Cannot convert your input", "Bad Input! Please input a double only!")
                return 0
        elif( cond1Type == "enum"):
            # if they havent made a choice
            if(self.cond1Split.get() == ""):
                return 0
        
        #check the 2nd condition
        if( cond2Type == "numeric"):
            #try to float their input
            try:
                x = float(self.lowEnd2.get())
                y = float(self.highEnd2.get())
            except:
                tkMessageBox.showwarning("Cannot convert your input", "Bad Input! Please input a double only!")
                return 0
        elif( cond2Type == "enum"):
            #if they haven't made a choice
            if( self.cond2Split.get() == ""):
                return 0
        
        #if we get here, the input is valid and we can run the counter
        return 1
    
      
#        
#root = Tk()
#Button(root,text="Hello!").pack()
#root.update()
#d = MyDialog(root, dataHeader = {})
#root.wait_window(d.top)