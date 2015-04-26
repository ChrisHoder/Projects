#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox
#this method will create a dialog box that will allow the user to customize the options to plot data.

class InfoBox(Toplevel):
    
    def __init__(self, parent, dataObject, rowNumber, title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #set data object and row number
        self.dataObject = dataObject
        try:
            self.rowNumber = int(rowNumber)
        except:
            print "error tried to int() the following : ", rowNumber
            num = rowNumber.split('.')
            self.rowNumber = int(num[0])
            
            #self.rowNumber = int(float(rowNumber))
            
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
        
    # this method will setup all of the options that will be used for graphing and the labels and buttons.
    def body(self,master):
        #create dialog body. return widget that should have
        #initial focus. this method should be overriden
        
        #get headers
        headers = self.dataObject.getHeader()
        #get the correct row
        row = self.dataObject.getData()[self.rowNumber,:].tolist()[0]
        #create the box information
        colNum = 0
        #for each column, get the header and present the data point in data space
        for col in row:
            Label( master, text = headers[colNum]).grid(row = colNum, column = 0)
            Label( master, text = col).grid(row = colNum, column = 1)
            colNum += 1
          
        return

    
    def buttonbox(self):
        #add standard button box
        box = Frame(self)
        
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
       
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.cancel)
      
        
        box.pack()
        
    def ok(self, event = None):
       
        self.withdraw()
        self.update_idletasks()
        self.parent.focus_set()
        self.destroy()
        return
    
    def cancel(self, event = None):
        self.parent.focus_set()
        self.destroy()
    
      
#        
#root = Tk()
#Button(root,text="Hello!").pack()
#root.update()
#d = MyDialog(root, dataHeader = {})
#root.wait_window(d.top)