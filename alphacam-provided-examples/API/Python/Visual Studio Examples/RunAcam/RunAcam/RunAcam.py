import win32com.client as win32

# Open the Alphacam Router module using the ProgID string
acApp = win32.gencache.EnsureDispatch('Ar5axaps.Application')
acApp.Visible = True

# Draw a rectangle, fillet and add some text
drw = acApp.ActiveDrawing
pthRect = drw.CreateRectangle(0, 0, 100, 75)
pthRect.Fillet(5)
text = drw.CreateText2("This has been created from Python!", 5, 40, 4)
# Ensure the drawing can be seen
drw.ZoomAll()

# Save to the Licomdir folder
drw.SaveAs(acApp.LicomdirPath + "Licomdir\\Python Example Drawing")

# Wait for the user to press a key before exiting
_ = input("Press ENTER to quit:")

# Release COM Objects
pthRect = None
text = None
drw = None

# Quit the application and release the COM object
acApp.Quit()
acApp = None
