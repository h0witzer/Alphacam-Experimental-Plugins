import os
import win32com.client as win32
from CreateDoor import create_door      # The routine to draw the simple parametric door

# Define a simple class to hold the part filename and the quantity to be nested
class PartToBeNested:
    def __init__(self, filename, quantity):
        self.filename = filename
        self.quantity = quantity

# Read the CSV file containing the part sizes to be produced       
def ReadFile():
    datafile_path = os.path.join(os.path.dirname(__file__), "ListOfSizesToProduce.txt")
    my_file = open(datafile_path, "r")

    # read the file
    data = my_file.read()
  
    # Add the contents of the file to a list, using the newline /n to separate the lines into list items
    processing_list = data.split("\n")
    my_file.close()
    return processing_list

# Read the CSV file
processing_list = ReadFile()

# Launch Alphacam Router
acApp = win32.gencache.EnsureDispatch('Ar5axaps.Application')
acApp.Visible = True

N=acApp.Nesting     # Get the Alphacam Nesting class
N.DeleteAllNestLists()  # Ensure all nest lists are deleted

# Make the output folder if it does not exist already
outputfolder = acApp.LicomdirPath + "Licomdir\\Python Nesting Example"
if not os.path.exists(outputfolder):
   os.makedirs(outputfolder)

# Make a new nest list and set the time to be spent optimising to 10 seconds
nl = N.NewNestList(outputfolder + "\\PythonTest.anl")
nl.TotalTime = 10

count=1
drw=acApp.ActiveDrawing

# Make a list to store instances of the PartToBeNested class
parts_to_nest = []

# Loop through the processing list read from the CSV file
for dataline in range(1, len(processing_list)):
    # Start with a new drawing
    acApp.New()
    # Split the line of data from the CSV file into a list using the comma as a delimiter
    line = processing_list[dataline].split(",")
    # Door width and height are in the first 2 items
    create_door(acApp, int(line[0]), int(line[1]))
    # Make a file name based on the counter variable
    filename = outputfolder + "\\" + str(count) + ".ard"
    # Save the drawing
    drw.SaveAs(filename)
    # The quantity to be nested is in the 3rd column of CSV data
    qty = int(line[2])
    # Add the file and the quantity to a new instance of the PartToBeNested class
    part_to_be_nested = PartToBeNested(filename, qty)
    # Add the PartToBeNested instance to the list
    parts_to_nest.append(part_to_be_nested) 
    # Increment the count to ensure all parts have a unique file name
    count +=1

# Ensure Alphacam starts with a new drawing
acApp.New()

# Loop through the list of PartToBeNested
for part in parts_to_nest:
    # Add the file to the nest list
    np = nl.AddFile(part.filename)
    # Set the quantity
    np.Required = part.quantity
    # Allow 90° rotation
    np.RotationAngle = 90
    np = None

drw=acApp.ActiveDrawing

# Make a nesting SheetList
sl = N.NewSheetList()

# Draw the nested sheet geometry  
sheetGeo = drw.CreateRectangle(0, 0, 2440, 1220)  
# Add this to the SheetList
ns = sl.Add(sheetGeo)

# Set the quantity of sheets to be unlimited
ns.Required = 0

# Assume 19 thick
ns.Thickness = 19

# Nest the part in the nest list using the Sheet List
nlReturn = N.Nest(nl, sl)

# Show the nested result
drw.ZoomAll()

# Save the nestlist
nl.Save()
# Save the nested drawing
drw.SaveAs(outputfolder + "\\nest.ard")
# Ensure the nest list is removed 
N.DeleteAllNestLists()

# Clean up COM objects
sheetGeo = None
ns = None
sl= None
nl = None
N = None
drw = None

# Wait for the user to respond before exiting Alphacam
_ = input("Press ENTER to quit:")
acApp.Quit()
acApp = None
