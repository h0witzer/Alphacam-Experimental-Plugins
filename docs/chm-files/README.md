# Alphacam API Documentation Index

## Overview

This directory contains compiled HTML help files (.chm) documenting the Alphacam API suite. These CHM files provide comprehensive reference documentation for developing Alphacam add-ins, macros, and automation scripts.

**Total Documentation**: 585 HTML pages across 6 API libraries  
**Primary Language**: VBA (Visual Basic for Applications)  
**Platform**: Windows COM Automation

## Quick Reference

| CHM File | Size | Pages | Primary Purpose | Complexity |
|----------|------|-------|-----------------|------------|
| [acamapi.chm](#acamapi) | 506 KB | 194 | Core CAD/CAM API | High |
| [Nesting.chm](#nesting) | 115 KB | 152 | Sheet nesting & optimization | High |
| [AEDITAPI.chm](#aeditapi) | 145 KB | 154 | Editor automation | Medium |
| [Feature.chm](#feature) | 366 KB | 58 | Feature extraction | Advanced |
| [Primitives.chm](#primitives) | 132 KB | 15 | Utility objects & graphics | Low |
| [ConstraintsAPI.chm](#constraintsapi) | 50 KB | 12 | Parametric constraints | Medium |

## API Documentation Files

### acamapi
**File**: `acamapi.chm` | **Pages**: 194 | **Detail**: [acamapi.md](./acamapi.md)

The **core and most comprehensive** Alphacam API providing complete access to CAD/CAM functionality.

**Key Features:**
- Drawing creation and manipulation
- Geometry operations (lines, arcs, circles, surfaces)
- Machining operations (milling, turning, laser cutting)
- Toolpath generation
- NC code output
- Material management
- File import/export (IGES, etc.)
- Event system for operation monitoring
- Add-in loading and management

**Main Objects:**
- `Application` - Top-level Alphacam access
- `Drawing` - Drawing document operations
- `Path` - Geometric path objects
- `CircleProperties` - Circle analysis

**Use Cases:**
- Complete CAD/CAM automation
- Custom toolpath generation
- Batch drawing processing
- ERP/MRP integration
- Custom workflows

---

### Nesting
**File**: `Nesting.chm` | **Pages**: 152 | **Detail**: [Nesting.md](./Nesting.md)

Advanced nesting API for optimizing part layout on sheet material.

**Key Features:**
- Automatic nesting with AI optimization
- Manual nesting control
- Multiple nesting engines
- Material utilization tracking
- Sheet and remnant management
- Custom nesting extensions
- Event-driven nesting workflow
- Debug and monitoring capabilities

**Main Objects:**
- `Nesting` - Core nesting operations
- `NestList` - Part collection for nesting
- `NestSheet` - Sheet material definition
- `NestPart` / `NestParts` - Individual parts
- `NestPartInstance` - Placed part instances
- `NestInformation` - Results and statistics
- `NestExtension` - Custom extensions

**Use Cases:**
- Material waste minimization
- Production planning
- Automated layout generation
- Custom nesting algorithms
- Cost estimation

---

### AEDITAPI
**File**: `AEDITAPI.chm` | **Pages**: 154 | **Detail**: [AEDITAPI.md](./AEDITAPI.md)

Editor automation API for programmatic control of the Alphacam Editor.

**Key Features:**
- Document management
- Text/content selection
- Cursor control and navigation
- Copy/paste/cut operations
- Machine configuration access
- Editor frame control
- Event notifications

**Main Objects:**
- `Application` - Editor application
- `Document` - Editor document
- `Documents` - Document collection
- `Selection` - Content selection
- `Machine` / `Machines` - Machine configs
- `Frame` - Editor window
- `Options` - Editor preferences

**Use Cases:**
- Editor task automation
- Batch document processing
- Custom editing tools
- Macro creation
- Document manipulation

---

### Feature
**File**: `Feature.chm` | **Pages**: 58 | **Detail**: [Feature.md](./Feature.md)

Advanced feature extraction and analysis for 3D solid models and CAD geometry.

**Key Features:**
- Automatic feature recognition
- Contour extraction from 3D models
- Edge detection and analysis
- Face analysis and highlighting
- Work plane extraction
- Part auto-alignment
- Visual utilities (face painting, view alignment)
- Wireframe conversion

**Main Areas:**
- Feature extraction and configuration
- Contour and edge extraction
- CAD import processing
- Utility tools for visualization
- API for programmatic access

**Use Cases:**
- Automated feature-based machining
- CAD import processing
- Model analysis
- Part orientation
- Visual feature identification

---

### Primitives
**File**: `Primitives.chm` | **Pages**: 15 | **Detail**: [Primitives.md](./Primitives.md)

Fundamental utility library with graphics primitives and helper objects.

**Key Features:**
- Vector graphics objects (gVector, gPoint, gPV, gColor)
- File path manipulation (FilePath)
- Encryption utilities (Crypt)
- CSV file reading (CSVReader)
- Phonetic matching (Metaphone)
- Selection set management
- Audio feedback (RingTone)

**Main Objects:**
- Graphics: `gVector`, `gPoint`, `gPV`, `gColor`
- Utilities: `FilePath`, `Crypt`, `CSVReader`
- Helpers: `Metaphone`, `RingTone`, `SelectionSet`

**Use Cases:**
- Geometric calculations
- File system operations
- Data import/export
- Security and licensing
- Graphics rendering

---

### ConstraintsAPI
**File**: `ConstraintsAPI.chm` | **Pages**: 12 | **Detail**: [ConstraintsAPI.md](./ConstraintsAPI.md)

Parametric constraint management for constraint-driven geometry.

**Key Features:**
- Parameter definition and management
- Algebraic relationships
- Geometric constraints
- Constrained drawing insertion
- Constraint evaluation
- UI integration

**Main Objects:**
- `ConstraintMain` - Entry point
- `ConstraintAlgebra` - Parameter management
- `ConstraintIgm` - Constraint relationships

**Use Cases:**
- Parametric design
- Configurable part families
- Design automation
- Constraint-based modeling
- Dynamic geometry

---

## API Relationships

```
acamapi (Core API)
├── AEDITAPI (Editor specialization)
├── Nesting (via CreateNestData)
├── Feature (CAD/CAM integration)
├── ConstraintsAPI (Parametric design)
└── Primitives (Utilities used throughout)
```

### Dependencies
- **acamapi** is the foundation - all other APIs integrate with it
- **Primitives** provides utilities used by multiple APIs
- **Feature** enhances CAD import and machining preparation
- **Nesting** extends acamapi for layout optimization
- **ConstraintsAPI** adds parametric capabilities
- **AEDITAPI** provides specialized editor control

## Development Quick Start

### 1. VBA Setup
```vba
' In VBA Editor: Tools | References
' Enable these type libraries:
' ☑ Alphacam API Type Library (acamapi)
' ☑ Alphacam Primitives Type Library
' ☑ Alphacam Constraints Type Library (if needed)
' ☑ Alphacam Nesting Type Library (if needed)
```

### 2. Basic Code Structure
```vba
Sub AutomateAlphacam()
    ' Get Application object
    Dim app As Application
    Set app = [Application Instance]
    
    ' Get active drawing
    Dim drw As Drawing
    Set drw = app.ActiveDrawing
    
    ' Perform operations
    ' ...
    
    ' Clean up
    Set drw = Nothing
    Set app = Nothing
End Sub
```

### 3. Common Patterns

#### Geometry Iteration
```vba
For Each path In drawing.Geometries
    ' Process geometry
Next
```

#### Event Handling
```vba
' Register for events
' Implement event handlers
```

#### Feature Extraction
```vba
' Use Feature API to extract features
' Process recognized features
' Generate toolpaths
```

#### Nesting Workflow
```vba
' Create nest list
' Add parts
' Configure sheets
' Execute nesting
' Get results
```

## Use Case Matrix

| Use Case | Primary API | Supporting APIs |
|----------|-------------|-----------------|
| CAD Drawing | acamapi | Primitives |
| Machining/Toolpaths | acamapi | Feature |
| Editor Automation | AEDITAPI | acamapi |
| Feature Recognition | Feature | acamapi, Primitives |
| Sheet Nesting | Nesting | acamapi |
| Parametric Design | ConstraintsAPI | acamapi |
| Batch Processing | acamapi | All APIs |
| Custom Add-ins | acamapi | Primitives |

## Machine Type Coverage

| Machine Type | Primary API | Key Methods |
|--------------|-------------|-------------|
| Mill/Router | acamapi | CreateMillData, AfterRoughFinishEvent |
| Lathe/Turning | acamapi | AfterTurningMachiningEvent |
| Laser/Flame | acamapi | CreateLaserData |
| All Types | acamapi | Common geometry and drawing operations |

## Complexity Levels

### Beginner (Start Here)
1. **Primitives** - Simple utilities, easy to understand
2. **ConstraintsAPI** - Small, focused API
3. **AEDITAPI** - Straightforward editor operations

### Intermediate
4. **acamapi** - Core API with moderate learning curve
5. **Feature** - Requires understanding of 3D geometry

### Advanced
6. **Nesting** - Complex optimization with many options

## Common Development Scenarios

### Scenario 1: Simple Macro
**APIs**: acamapi, Primitives  
**Complexity**: Low  
**Example**: Iterate geometries, perform calculations, output results

### Scenario 2: Feature-Based Machining
**APIs**: acamapi, Feature  
**Complexity**: Medium-High  
**Example**: Import model, extract features, generate toolpaths

### Scenario 3: Production Nesting
**APIs**: Nesting, acamapi  
**Complexity**: Medium-High  
**Example**: Load parts, optimize layout, generate cutting paths

### Scenario 4: Parametric Part Family
**APIs**: ConstraintsAPI, acamapi  
**Complexity**: Medium  
**Example**: Define parameters, create constrained geometry, generate variants

### Scenario 5: Custom Add-in
**APIs**: All  
**Complexity**: High  
**Example**: Full-featured add-in with custom UI and workflows

## Viewing the Documentation

### On Windows
Simply double-click any .chm file to open it in the Windows Help viewer.

### On Linux/Mac
Use the CHM reader tools in `tools/chm-reader/`:

```bash
# Extract CHM to HTML
python tools/chm-reader/extract_chm.py docs/chm-files/acamapi.chm --output docs/extracted/acamapi

# Search CHM contents
python tools/chm-reader/search_chm.py docs/chm-files/acamapi.chm --query "CreateMillData"
```

See [tools/chm-reader/README.md](../../tools/chm-reader/README.md) for more information.

## Additional Resources

### Repository Documentation
- **[QUICKSTART.md](../../QUICKSTART.md)** - Quick start guide
- **[CONTRIBUTING.md](../../CONTRIBUTING.md)** - Contribution guidelines
- **[README.md](../../README.md)** - Project overview
- **[docs/README.md](../README.md)** - Documentation overview
- **[docs/api-reference/README.md](../api-reference/README.md)** - API reference guide
- **[docs/guides/README.md](../guides/README.md)** - How-to guides

### Code Examples
- **[csharp-addins/examples/](../../csharp-addins/examples/)** - C# add-in examples
- **[vba-macros/examples/](../../vba-macros/examples/)** - VBA macro examples

### Testing
- **[csharp-addins/tests/](../../csharp-addins/tests/)** - C# add-in tests
- **[vba-macros/tests/](../../vba-macros/tests/)** - VBA macro tests

## Support and Community

For questions, issues, or contributions:
1. Check the CHM documentation for API specifics
2. Review example code in the repository
3. Read the QUICKSTART.md guide
4. Consult CONTRIBUTING.md for contribution guidelines
5. Open an issue on GitHub for bugs or feature requests

## License and Legal

These CHM files contain proprietary Alphacam API documentation. They are provided for development purposes. Refer to the Alphacam license agreement for usage terms.

## Last Updated

This index and supporting documentation was last updated: February 2026

---

**Happy Coding with Alphacam!** 🚀
