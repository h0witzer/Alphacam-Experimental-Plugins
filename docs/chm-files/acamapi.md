# acamapi.chm - Alphacam Core API Documentation

## Overview

The acamapi (Alphacam API) is the **core and most comprehensive API** for Alphacam. It provides complete programmatic access to Alphacam's CAD/CAM functionality, including drawing operations, geometry creation, machining data, toolpath generation, and application control.

**File**: `acamapi.chm`  
**Total Documentation Pages**: 194 HTML files (largest API by scope)  
**Primary Purpose**: Complete Alphacam automation and integration

## Main Components

### 1. Application Object
The top-level entry point to the Alphacam environment.

**Key Methods:**
- `OpenFile` / `OpenIgesFile` - Open drawings and CAD files
- `LoadAddIn` - Load add-in modules
- `CreateLaserData` - Generate laser cutting data
- `CreateLeadData` - Create lead-in/lead-out paths
- `CreateMillData` - Generate milling toolpaths
- `CreateMillStyle` - Define milling styles
- `ShellAndWait` - Execute external programs
- `SetProcessAffinityMask` - Control CPU affinity
- `Authorise` / `AuthoriseModeless` - License management
- `SelectPostModuleInThisVBAProject` - Post-processor integration
- `CloseGeometryMacro` - Complete geometry recording

**Key Properties:**
- `ActiveDrawing` - Current drawing object
- Application-level settings and state

### 2. Drawing Object
Represents an Alphacam drawing document.

**Key Methods:**
- `CreateSurfaceSwept3` - Create swept surface
- `CreateSurfaceCoons3` - Create Coons surface patch
- `GetMaterial` - Retrieve material properties
- `CreateNestData` - Prepare nesting data
- Geometry creation methods (lines, arcs, circles, splines)
- Layer management
- View control

**Key Properties:**
- `Geometries` - Collection of geometric elements
- Drawing properties and settings

### 3. Path Object
Represents geometric paths and entities.

**Methods:**
- `GetCircleProperties` - Extract circle parameters
- Geometry analysis
- Path manipulation

**Example Usage:**
```vba
Dim drw As Drawing
Set drw = App.ActiveDrawing
Dim p As Path
For Each p In drw.Geometries
    Dim c As CircleProperties
    Set c = p.GetCircleProperties
    If Not (c Is Nothing) Then
        MsgBox "Circle Diameter = " & c.diameter
    End If
Next p
```

### 4. CircleProperties Object
Provides detailed information about circular geometry.

**Properties:**
- `diameter` - Circle diameter
- `radius` - Circle radius
- `center` - Center point coordinates

### 5. Event System
Comprehensive event notifications for Alphacam operations.

**Before Events:**
- File operations (open, save, save as)
- Machining events

**After Events:**
- `AfterCreateNcEvent` - After NC code generation
- `AfterInputCadEvent` - After CAD import
- `AfterInputNcEvent` - After NC import
- `AfterOpenFileEvent` - After file open
- `AfterOutputNcEvent` - After NC output
- `AfterRoughFinishEvent` (Mill/Router) - After roughing/finishing
- `AfterSaveFileEvent` - After file save
- `AfterSelectToolEvent` - After tool selection
- `AfterTurningMachiningEvent` (Lathe) - After turning operations

**Before Events:**
- `BeforeSaveAsFileEvent` - Before save as operation
- Other pre-operation events

## Machine Type Support

The API supports multiple machine types with specialized functionality:

### Mill and Router
- Milling toolpath creation
- Rough and finish operations
- Multi-axis support
- `CreateMillData` method

### Lathe (Turning)
- Turning operations
- `AfterTurningMachiningEvent`
- Lathe-specific toolpaths

### Laser and Flame Cutting
- `CreateLaserData` method
- Laser-specific parameters
- Cutting path optimization

## Major Functional Areas

### CAD Operations
- Geometry creation (lines, arcs, circles, splines, curves)
- Surface creation (swept, Coons, lofted)
- Drawing manipulation
- Layer management
- Import/export (IGES, etc.)

### CAM Operations
- Toolpath generation
- Machining data creation
- Tool selection and management
- Post-processing
- NC code generation

### Material Management
- Material properties
- Material database access
- Material assignment

### File Operations
- Open/save drawings
- Import CAD files (IGES, etc.)
- Export NC code
- File format handling

### Add-In System
- Load custom add-ins
- Extend Alphacam functionality
- Plugin integration

### Post-Processing
- Select post-processors
- Customize NC output
- Machine-specific code generation

### Process Control
- Execute external programs (`ShellAndWait`)
- Control CPU affinity
- Performance optimization

## Use Cases

### CAD Automation
- Automated drawing creation
- Batch geometry generation
- Parametric part creation
- Drawing modification and cleanup

### CAM Automation
- Automated toolpath generation
- Batch machining operations
- Custom machining strategies
- Toolpath optimization

### Integration
- ERP/MRP integration
- PDM/PLM connectivity
- Custom workflow automation
- Data exchange with other systems

### Customization
- Custom machining cycles
- Specialized toolpath strategies
- Industry-specific workflows
- Add-in development

### Batch Processing
- Process multiple drawings
- Automated NC generation
- Batch post-processing
- Report generation

## Programming Language

- **Primary**: VBA (Visual Basic for Applications)
- **Platform**: Windows COM automation
- **Extensibility**: Add-in model for C#/VB.NET

## Event-Driven Programming

The API supports event-driven development:
1. Register event handlers
2. Respond to Alphacam operations
3. Implement custom logic at key points
4. Modify behavior dynamically

## Integration Points

### Internal APIs
- **AEDITAPI**: Editor automation
- **Nesting**: Nesting operations via `CreateNestData`
- **Feature**: Feature extraction integration
- **ConstraintsAPI**: Constraint management
- **Primitives**: Graphics and utilities

### External Systems
- Post-processors via `SelectPostModuleInThisVBAProject`
- External programs via `ShellAndWait`
- File import/export for CAD systems
- Add-ins for custom extensions

## Example Workflows

### Create and Machine a Part
1. Create or open drawing (`Application.OpenFile`)
2. Access drawing object (`Application.ActiveDrawing`)
3. Create geometry (Drawing methods)
4. Set material (`Drawing.GetMaterial` / set)
5. Generate toolpaths (`CreateMillData`, `CreateLaserData`, etc.)
6. Post-process and output NC code

### Process Imported CAD File
1. Import file (`Application.OpenIgesFile`)
2. Analyze geometry (iterate `Geometries` collection)
3. Extract features (integrate with Feature API)
4. Generate toolpaths
5. Output NC code

### Batch Processing
1. Open each drawing in sequence
2. Apply standardized operations
3. Generate toolpaths
4. Save results
5. Generate reports

## Advanced Features

### Surface Creation
- Swept surfaces (`CreateSurfaceSwept3`)
- Coons patches (`CreateSurfaceCoons3`)
- Complex 3D surface modeling

### Geometry Analysis
- Circle properties extraction
- Path analysis
- Geometric queries

### Lead-In/Lead-Out
- `CreateLeadData` for optimized tool entry/exit
- Minimize tool marks
- Improve surface finish

### Multi-Machine Support
- Machine-type-specific events
- Specialized methods for different machine types
- Flexible architecture

## Technical Details

- **Total Files**: 194 HTML documentation pages (most comprehensive API)
- **Documentation Format**: Adobe RoboHelp generated HTML
- **Character Encoding**: Mixed (check individual files)
- **Complexity**: High - full CAD/CAM system access
- **Scope**: Complete Alphacam functionality
- **Documentation Location**: `html/` subdirectory

## Best Practices

1. **Always check for Nothing**: Verify object references before use
2. **Use event handlers**: Monitor operations for error handling
3. **Clean up**: Release COM objects when done
4. **Error handling**: Implement robust error handling for file operations
5. **Transaction pattern**: Open, modify, save, close in proper sequence
6. **Tool selection**: Always select appropriate tools for operations
7. **Material setup**: Set material before generating toolpaths

## Performance Considerations

- Batch operations can be memory-intensive
- Use `SetProcessAffinityMask` for CPU control on large jobs
- Event handlers should be efficient
- Release objects promptly to free resources
- Consider using `ShellAndWait` for external processing

## Related APIs

- **All other CHM files** - acamapi is the foundation for all Alphacam APIs
- **AEDITAPI.chm** - Editor-specific operations
- **Nesting.chm** - Advanced nesting via acamapi
- **Feature.chm** - Feature extraction for CAM
- **ConstraintsAPI.chm** - Parametric design
- **Primitives.chm** - Utility objects used by acamapi

## Documentation Organization

The acamapi documentation is organized in the `html/` directory with:
- Application object documentation
- Drawing object documentation
- Event documentation
- Method references with examples
- Property references
- Enumeration definitions

## License and Authorization

The API includes license management:
- `Authorise` method for license checking
- `AuthoriseModeless` for modeless dialogs
- Proper license handling in add-ins
- License-aware feature access
