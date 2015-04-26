#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

from Tkinter import *
import os
import tkMessageBox


# This class can be used to create a generic dialog that will get a string input from the user. It takes in the string variable which will be changed by the
# user when they enter something into the entry box. The inputText input is the text that will come before the entry box.
class getInput(Toplevel):
    
    def __init__(self, parent, inputText, entryVar, title = None):
        
        Toplevel.__init__(self, parent)
        self.transient(parent)
        #top = self.top = Toplevel(parent)
        if title:
            self.title(title)
        #set parent
        self.parent = parent
        #input text for user to read
        self.inputText = inputText
        #input stringvar for dialog to change
        self.entryVar = entryVar
       
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
        #create label with input text
        Label( master, text = self.inputText).grid(row=0)
        #entry var is input by the user
        self.entry = Entry(master,textvariable=self.entryVar)
        self.entry.grid(row=1)
    
        return

    #buttons for the user --- only ok and cancel
    def buttonbox(self):
        #add standard button box
        box = Frame(self)
        
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
        
        w = Button(box, text ="CANCEL", width = 10, command = self.cancel)
        w.pack(side=LEFT, padx = 5, pady = 5)
       
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.cancel)
      
        
        box.pack()
    
    #closes the window
    def ok(self, event = None):
        self.withdraw()
        self.update_idletasks()
        self.parent.focus_set()
        self.destroy()
        return
    
    # closes the window but first sets the entry to ""
    def cancel(self, event = None):
        self.entryVar.set("")
        self.parent.focus_set()
        self.destroy()
    
      
#        
#root = Tk()
#Button(root,text="Hello!").pack()
#root.update()
#d = MyDialog(root, dataHeader = {})
#root.wait_window(d.top)