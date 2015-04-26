#created with help from the following website: http://effbot.org/tkinterbook/tkinter-dialog-windows.htm

#look at http://stackoverflow.com/questions/9762486/python-tkinter-scroll-frame-expand-labelframe-in-canvas
#help with the scrollbar from http://effbot.org/zone/tkinter-autoscrollbar.htm
#and some help from stackoverflow user : Onlyjus 
    # he provided some insight on how scrollbars work and some helpful advice

from Tkinter import *
import os
import tkMessageBox




# this is an autoscrollbar class taken from the above website and will then only display the scrollbar when
# it is needed and the material in one of the canvases has grown too big
class AutoScrollbar(Scrollbar):
    # a scrollbar that hides itself if it's not needed.  only
    # works if you use the grid geometry manager.
    def set(self, lo, hi):
        if float(lo) <= 0.0 and float(hi) >= 1.0:
            # grid_remove is currently missing from Tkinter!
            self.tk.call("grid", "remove", self)
        else:
            self.grid()
        Scrollbar.set(self, lo, hi)
    def pack(self, **kw):
        raise TclError, "cannot use pack with this widget"
    def place(self, **kw):
        raise TclError, "cannot use place with this widget"


#this method will create a dialog box that will allow the user to customize the options to cluster the data. The user can select different columsn to include in the clustering
# as well as the number of clusters to allow. Finally the user can select the name of the clustering to be saved as (this will be the header when the csvReader class calls this class)
class ClusterDialog(Toplevel):
    
    def __init__(self, parent, displayClass, clusterInfo, title = None):
        
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
        self.clusterInfo    = clusterInfo        
      
      
        #stores checkbox variables
        self.varList = None
        self.boxList = None
        self.name = None
        
        self.frameTopLevel  = Frame(self,bd=2, width = 550,height=800)
        
        self.frameTopLevel.pack()
       
        
#        body = Canvas(self.frameTopLevel, yscrollcommand = vscrollbar.set)
#        body.grid(row=0,column = 0, sticky = N+E+S+W)
#        vscrollbar.config(command=canvas.yview)
#        
#        canvas = Canvas()
#        
#        #create a scroll bar
        
        self.buttonbox(self.frameTopLevel)
        self.frame = Frame(self.frameTopLevel, width = 550,height=500)
        
        #frame=Frame(root,width=300,height=300)
        self.frame.grid(row=0,column=0)
        self.frame.pack()
        
        self.vbar = AutoScrollbar(self.frame)
        self.vbar.grid(row=0,column=1,sticky=N+S)
        self.hbar = AutoScrollbar(self.frame)
        self.hbar.grid(row=1,column=1,sticky=E+W)
        
        self.canvas=Canvas(self.frame,bg='#FFFFFF',width = 550, height=500, yscrollcommand=self.vbar.set, xscrollcommand=self.hbar.set)
        self.canvas.grid(row=0,column=0,sticky=N+S+E+W)
        self.vbar.config(command=self.canvas.yview)
        self.hbar.config(command=self.canvas.xview)
        self.frame.grid_rowconfigure(0,weight=1)
        self.frame.grid_columnconfigure(0,weight=1)
        frame = Frame(self.canvas)
        frame.rowconfigure(1,weight=1)
        frame.columnconfigure(1,weight=1)
        self.body(frame)
        self.canvas.create_window(0,0,anchor=NW,window=frame)
        frame.update_idletasks()
        self.canvas.config(scrollregion=self.canvas.bbox("all"))
        #print "bbox call", self.canvas.bbox(ALL)
#        self.hbar = Scrollbar(self.frame,orient=HORIZONTAL)
#        self.hbar.pack(side=BOTTOM,fill=X)
#        self.hbar.config(command=self.canvas.xview)
#        self.vbar=Scrollbar(self.frame,orient=VERTICAL)
#        self.vbar.pack(side=RIGHT,fill=Y)
#        self.vbar.config(command=self.canvas.yview)
        #self.canvas.config(width=300,height=300)
        #self.canvas.config(xscrollcommand=self.hbar.set, yscrollcommand=self.vbar.set,scrollregion=(0,0,500,1000))
        #self.canvas.pack(side=LEFT,expand=True,fill=BOTH)
        #self.grab_set()
        
        #get the coordinates
        #cord = self.canvas.coords(self.name)
        #print "cord", cord
        #self.canvas.create_rectangle(50, 25, 150, 75, fill="blue")
        #self.canvas.pack()
        
        
       # if not self.initial_focus:
    #    self.initial_focus = self
            
            
        self.protocol("WM_DELETE_WINDOW", self.cancel)
        
        #positions the window relative to the parent
        #self.geometry("%dx%d" % (parent.winfo_rootx()+50, 300+50)+"+10+10")
        #self.geometry("550x300+10+10")
        
        
        
        #self.initial_focus.focus_set()
        
        self.wait_window(self)
        return
            
    # this method will setup all of the options that will be used for graphing and the labels and buttons.    
    def body(self,master):
        #create dialog body. return widget that should have
        #initial focus. this method should be overriden
       
        
       
        #create a list of checkboxes where each checkbox is one of the
        #numeric header values from the data that is given to the dialog box
        self.varList = []
        self.boxList = []
        headers = self.dClass.getHeaders()
        i = 0
        #for each header, create a checkbox and add it to the dialog
        for header in headers:
            var = IntVar()
            cb = Checkbutton(master, text = header, variable = var)
            #cb.pack()
            cb.grid(row = i, columnspan = 2, sticky='news')
            self.boxList.append(cb)
            self.varList.append(var)
            i += 1
        
        #option for the user to select how many clusters to have
        Label(master,text="# of clusters: ").grid(row=i, sticky='news')
        self.clusterNumber = StringVar()
        self.clusters = Entry(master, textvariable=self.clusterNumber)
        self.clusterNumber.set(str(10))
        self.clusters.grid(row=i, column=1,sticky='news')
        #self.clusters.pack()
        i += 1
        #option for the user to name the clustering
        Label(master,text="Clustering name (optional):").grid(row=i,sticky='news')
        self.nameVar = StringVar()
        self.nameVar.set("")
        self.name = Entry(master, textvariable=self.nameVar)
        #self.name.pack()
        self.name.grid(row=i,column=1,sticky='news')
        
        
    
        
    
    def buttonbox(self,master):
        #add standard button box
        box = Frame(master)
        
        w = Button(box, text="OK", width = 10, command = self.ok, default=ACTIVE)
        w.pack(side=LEFT,padx=5,pady=5)
        w = Button(box,text="Cancel", width=10,command = self.cancel)
        w.pack(side=LEFT,padx=5,pady=5)
        w = Button(box, text="Default", width = 10, command = self.default)
        w.pack(side=LEFT,padx=5,pady=5)
        w = Button(box, text = "Select All", width = 12, command = self.select)
        w.pack(side=TOP, padx =5, pady=5)
        
        
        self.bind("<Return>",self.ok)
        self.bind("<Escape>",self.cancel)
        
        box.pack()
        
    def select(self, event = None):
        for cb in self.boxList:
            cb.select()
        
        return
    def ok(self, event = None):
        if not self.validate():
            self.initial_focus.focus_set() #put focus back
            return
        
        self.withdraw()
        self.update_idletasks()
        self.apply()
        self.parent.focus_set()
        self.destroy()
    
        
        
    def cancel(self, event = None):
        #put focus back on parent window
        self.parent.focus_set()
        self.destroy()
    
    def default(self, event = None):        
        self.withdraw()
        self.update_idletasks()
        #use all headers
        headers = []
        allHeaders = self.dClass.getHeaders()
        for i in range(0,len(allHeaders)):
           headers.append(allHeaders[i])
        
        #set the headers data for the dClass
        self.clusterInfo["headers"] = headers
        #set the number of clusters they want in the kmeans process
        self.clusterInfo["clusters"] = int(self.clusterNumber.get())
        #set the name
        name = self.nameVar.get()
        
        #if there is no input to the name box then it will just set
        # name to be 0 and the name will be determined in the clustering
        #class based on other clusters done
        if( name == ""):
            name = None
        self.clusterInfo["name"] = name
        
        #close the dialog box
        self.parent.focus_set()
        self.destroy()
        
    def validate(self):
        count = 0
        for variables in self.varList:
            count += variables.get()
        
        if( count == 0 ):
            tkMessageBox.showwarning("No Data Selected", "Please Select columns for clustering")
            return 0
        
        return 1
    
    def apply(self):
        #for each column variable
        columnNum = 0
        allHeaders = self.dClass.getHeaders()
        headers = []
        # this sets the headers
        for variables in self.varList:
            var = variables.get()
            print var
            print allHeaders[columnNum]
            #if it is selected
            if(var == 1):
                headers.append(allHeaders[columnNum])
            #increment the column number
            columnNum += 1
        self.clusterInfo["headers"] = headers
        
        #set the number of clusters
        self.clusterInfo["clusters"] = int(self.clusterNumber.get())
        
        #set the name
        name = self.nameVar.get()
        #if there is no input to the name box then it will just set
        # name to be 0 and the name will be determined in the clustering
        #class based on other clusters done
        if( name == ""):
            name = None
        
        self.clusterInfo["name"] = name
        
        return
     
        
    
      
#        
#root = Tk()
#Button(root,text="Hello!").pack()
#root.update()
#d = MyDialog(root, dataHeader = {})
#root.wait_window(d.top)