import win32com.client as win32
import ctypes  # An included library with Python install.   

def get_user_float_value(prompt):
    value = (float(input(prompt)))
    return value

def draw_outer_geo(width, height):
    outerPath = drw.CreateRectangle(0, 0, width, height)
    outerPath.Fillet(5)
    return outerPath

def draw_inner_geo(width, height, offset):
    geo2D = drw.Create2DGeometry(offset, offset)
    geo2D.AddLine(width-offset, offset)
    geo2D.AddLine(width-offset, height - 2 * offset)
    geo2D.AddArc2Point(width/2,height-offset,offset,height-2*offset)
    innerPath=geo2D.CloseAndFinishLine()
    geo2D = None
    return innerPath

def Select_Tool(ToolFilename):
    try:
        milltool = acApp.SelectTool(ToolFilename)
    except:
        ctypes.windll.user32.MessageBoxW(0, "Error selecting tool: \n" + ToolFilename, "Alphacam Python Example", 1)
        return False      

    milltool = None
    return True

def machine_geo(geo, depth):

    milldata = acApp.CreateMillData()
    milldata.SafeRapidLevel = 10
    milldata.RapidDownTo = 2
    milldata.MaterialTop = 0
    milldata.FinalDepth = depth
    geo.Selected = True
    milldata.RoughFinish()

    milldata = None
    return True
    
# Ask the user to type some sizes
width=get_user_float_value("Type Width:")
height=get_user_float_value("Type Height:")

acApp = win32.gencache.EnsureDispatch('Ar5axaps.Application')
acApp.Visible = True

drw = acApp.ActiveDrawing

# Draw the outer geometry using the sizes from the user
outer = draw_outer_geo(width, height)

# Set the tool be be on the outside of the created geometry
outer.ToolInOut = -1 # Outside

# Draw the inner geometry assuming a distance of 50 from the outer profile
inner = draw_inner_geo(width, height, 50)

# The inner geometry will be machined with the tool set to follow the inside of the created geometry
inner.ToolInOut = 1 # Inside

# Machine the outer geometry with the 20mm Flat Tool
if(Select_Tool(acApp.LicomdatPath + "\Licomdat\Rtools.alp\Flat - 20mm.art") == True):
    machine_geo(outer, -19) 

    # Machine the inner geometry with "Router - Emc4"
    if(Select_Tool(acApp.LicomdatPath + "\Licomdat\Rtools.alp\Router - Emc4.art")):
        machine_geo(inner, -5.5)

# Show the complete drawing
drw.ZoomAll()

_ = input("Press ENTER to quit:")

# Release COM objects
inner = None
outer = None
drw = None

acApp.New()
acApp.Quit()

acApp = None
