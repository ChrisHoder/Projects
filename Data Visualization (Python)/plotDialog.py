#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox
#this method will create a dialog box that will allow the user to customize the options to plot data.

class MyDialog(Toplevel):
    
    def __init__(self, parent, displayClass, dataHeader, title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #set class
        self.dClass = displayClass
        #dictionary to store the header data in 
        self.dataHeader = dataHeader
        self.result = None
        
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
        
        #labels for the different popdown menus that will be used by the user.
        # this uses the grid system and you can match up the rows
        Label(master, text="X axis:").grid(row=0)
        Label(master, text="Y axis:").grid(row=1)
        Label(master, text="Optional Components").grid(row=2)
        Label(master, text="Z axis:").grid(row=3)
        Label(master, text="Color Dim:").grid(row=4)
        Label(master, text="Size Dim:").grid(row=5)

                # the constructor syntax is:
        # OptionMenu(master, variable, *values)
        
        optionList = self.dClass.getHeaders()
        #add a null choice
        optionList.append('')
        #get length, subtract 1 so index from 0
        length = len(optionList)-1
        optionList = tuple(optionList)
    
        self.x = StringVar()
        self.x.set(optionList[length])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om1 = apply(OptionMenu, (master, self.x) + optionList)
        self.om1.grid(row=0, column=1)
        
        self.y = StringVar()
        self.y.set(optionList[length])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om2 = apply(OptionMenu, (master, self.y) + optionList)
        self.om2.grid(row=1, column=1)
        
        self.z = StringVar()
        self.z.set(optionList[length])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om3 = apply(OptionMenu, (master, self.z) + optionList)
        self.om3.grid(row=3, column=1)
        
        self.color = StringVar()
        self.color.set(optionList[length])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om4 = apply(OptionMenu, (master, self.color) + optionList)
        self.om4.grid(row=4, column=1)
        
        self.size = StringVar()
        self.size.set(optionList[length])
        #self.om = OptionMenu ( self, self.v, *optionList )
        self.om5 = apply(OptionMenu, (master, self.size) + optionList)
        self.om5.grid(row=5, column=1)
        
        return self.om1 # initial focus

    
    def buttonbox(self):
        #add standard button box
        box = Frame(self)
        
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
        w = Button(box,text="Cancel", width=10,command = self.cancel)
        w.pack(side=LEFT,padx=5,pady=5)
        
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.cancel)
        
        box.pack()
        
    def ok(self, event = None):
        if not self.validate():
            self.initial_focus.focus_set() #put focus back
            return
        
        self.withdraw()
        self.update_idletasks()
        self.apply()
        self.dataHeader['check'] = True
        self.parent.focus_set()
        self.destroy()
    
        
        
    def cancel(self, event = None):
        self.dataHeader['check'] = False
        #put focus back on parent window
        self.parent.focus_set()
        self.destroy()
        
    def validate(self):
        if(self.dClass.dataTest() == False):
            tkMessageBox.showwarning("Bad input","No data loaded")
            return 0
        
        x     = self.x.get()
        y     = self.y.get()
        z     = self.z.get()
        color = self.color.get()
        size  = self.size.get()
        
        messageString = ""
        #check the x axis
        if( x == ''):
            messageString += " No input to x axes."
        
        
        #check the y axis
        #if( y == ''):
           # messageString += " No input to y axes."
            
        #we have at least one error
        if( messageString != ""):
            tkMessageBox.showwarning("Bad input",messageString)
            return 0
        
        return 1
    
    def apply(self):
        #get initial values
        x     = self.x.get()
        y     = self.y.get()
        z     = self.z.get()
        color = self.color.get()
        size  = self.size.get()
        
        
        self.dataHeader['x'] = x
        self.dataHeader['y'] = y
        
        if( z != ''):
            self.dataHeader['z'] = z
        if( color != ''):
            self.dataHeader['color'] = color
        if( size != ''):
            self.dataHeader['size'] = size
            
        return
     
        
    
      
#        
#root = Tk()
#Button(root,text="Hello!").pack()
#root.update()
#d = MyDialog(root, dataHeader = {})
#root.wait_window(d.top)