#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox

# This method will create a pop up dialog for the user to view the current filters being used on the data that is loaded. It willhave an option menu which contains a string describing each
# filter. In this the user can then remove filters from the data.
class viewFilters(Toplevel):
    
    def __init__(self, parent, dClass, dataObject, title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #displayclass
        self.dClass = dClass

        self.dataObj = dataObject
        #stringvar that the filter choice will be made with
        self.filterChoice = StringVar()
        #optionMenu for list of filters
        self.choice = None
        
        self.canvas = Frame(self)
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
        
    # this method will setup all of the options that will be used for graphing and the labels and buttons.
    def body(self,master):
        #if the option menu is already there, delete it and create
        # a new one
        if( self.choice ):
            self.choice.destroy()
        #get current list of filters
        filters = self.dataObj.getFilters()
        if( len(filters) == 0):
            self.choice = Label(master, text = "No Filters applied")
            self.choice.grid(row=1,column=0)
            return
        filterList = []
        #turn them into a list of strings in appropriate format
        for i in range(len(filters)):
            filterList.append(self.dataObj.getFilterString(filterValue = filters[i], index = i))
        #create an option menu of the list of filters for the user to choose
        filterList = tuple(filterList)
        self.filterChoice.set("")
        self.choice = OptionMenu(master, self.filterChoice, *filterList)
        
        self.choice.grid(row=1, column = 0)
        
    
    # add the buttons to the data
    def buttonbox(self):
        #add standard button box
        box = Frame(self)
        
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
        
        w = Button(box, text= "Remove Filter", width = 10, command = self.Remove)
        w.pack(side=LEFT, padx=5,pady=5)
       
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.ok)
      
        
        box.pack()
    
    #this method will just close the window
    def ok(self, event = None):
       
        self.withdraw()
        self.update_idletasks()
        self.parent.focus_set()
        self.destroy()
        return
    
    # This method will remove the filter selected in the optionmenu from the data
    def Remove(self, event = None):
        #get the users choice
        choice = self.filterChoice.get()
        #if the user has selected an option
        if( choice != ""):
            # we need to get the index number, which is the first bit before the comma
            values = choice.split(",",1)
            #then we need to get the filter dictionary from the list to remove it
            filters = self.dataObj.getFilters()
            #this removes it
            self.dataObj.removeFilter(filters[int(values[0])])
            #this rebuilds our optionmenu updated on the new list of filters
            self.body(self.canvas)
            #reset points
            self.dClass.upDatePoints()
        return
    
        
