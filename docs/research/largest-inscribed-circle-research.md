# Research Report: Largest Inscribed Circle / Tool Fitting Functionality in Alphacam

**Date**: February 12, 2026  
**Researcher**: GitHub Copilot Agent  
**Repository**: h0witzer/Alphacam-Experimental-Plugins  
**Objective**: Investigate existing implementations of largest inscribed circle heuristics or tool-fitting algorithms for arbitrary geometry in the Alphacam API library

---

## Executive Summary

**Finding**: **No existing implementation** of largest inscribed circle calculations or tool-fitting algorithms based on arbitrary geometry was found in the Alphacam API library or codebase.

**Recommendation**: A new add-in will need to be developed to implement this functionality. However, Alphacam provides robust APIs that can be leveraged to build this feature.

---

## Detailed Findings

### 1. Search Results: No Existing Implementation

A comprehensive search of the entire codebase revealed:

❌ **No implementations found for:**
- "Largest inscribed circle" or "inscribed circle" algorithms
- "Minimum enclosing circle" calculations
- Tool-fitting algorithms based on arbitrary geometry
- Heuristics for selecting the largest tool that fits inside a feature
- Query builders based on inscribed circle criteria

✅ **What exists instead:**
- Basic tool selection via `SelectTool()` API
- Circle diameter/radius extraction via `CircleProperties` object
- Tool geometry access via `GetToolGeometry` add-in
- Feature recognition (holes, pockets, slots)

### 2. Available APIs That Can Be Leveraged

While the specific functionality doesn't exist, Alphacam provides several APIs that can be used to **build** this capability:

#### 2.1 Feature API (`Feature.chm` - 58 pages)

**Feature Recognition Capabilities:**
- Automatic detection of holes, pockets, slots, bosses
- Contour extraction from 3D faces
- Edge detection and boundary recognition
- Face analysis with normal vector calculations

**Relevant Methods:**
- `Face_Edge_Point_Details` - Extract comprehensive geometry information
- `Picking_linked_Edges` - Select connected edge chains for boundary detection
- `Draw_Solid_as_Wireframe` - Convert solid to wireframe representation

**Geometric Properties Extractable:**
- Face normals and orientation
- Edge connectivity and chains
- Points and vertices
- Surface area
- Contours and boundaries

**Key Limitation**: The Feature API provides feature **recognition** and **extraction**, but does not include geometric algorithms for calculating inscribed circles or determining maximum tool diameter that fits within arbitrary boundaries.

#### 2.2 acamapi - Core API (`acamapi.chm` - 194 pages)

**Geometry Analysis:**
- `GetCircleProperties` - Extract circle parameters (diameter, radius, center)
- Path manipulation and geometry iteration
- Drawing geometry access via `Geometries` collection

**Tool Selection:**
- `SelectTool()` - Programmatic tool selection
- `AfterSelectToolEvent` - Event triggered after tool selection
- Tool database access

**Code Example from Documentation:**
```vba
Dim p As Path
For Each p In drw.Geometries
    Dim c As CircleProperties
    Set c = p.GetCircleProperties
    If Not (c Is Nothing) Then
        MsgBox "Circle Diameter = " & c.diameter
    End If
Next p
```

**Key Limitation**: While the API can extract circle properties from **circular** geometry, it cannot calculate the largest circle that fits inside **arbitrary** (non-circular) geometry.

#### 2.3 GetToolGeometry Add-in

**Location**: `/alphacam-provided-examples/API/AcamAddInsAPI/Source.r.Example_AcamAddInsAPI/GetToolGeometry.bas`

**Functionality:**
- Retrieves geometric representation of tools as `Paths` objects
- Provides access to tool geometry properties
- Allows programmatic extraction of tool dimensions

**Code Example:**
```vba
Set MT = App.SelectTool("$USER")
If Not (MT Is Nothing) Then
    Set PS = oAddIn.GetGeometries(MT)
    If Not (PS Is Nothing) Then
        Debug.Print PS.Count
    End If
End If
```

**Key Limitation**: This add-in extracts tool geometry but doesn't perform any fitting calculations or comparisons with feature geometry.

#### 2.4 Primitives API (`Primitives.chm` - 15 pages)

**Provides:**
- `gVector` - Vector objects for geometric calculations
- `gPoint` - Point objects for coordinate operations
- `gPV` - Other primitive geometric types

**Key Limitation**: Provides basic geometric primitives but not computational geometry algorithms like inscribed circle calculations.

### 3. Comparison with CAMworks Functionality

**What CAMworks Has (Per Problem Statement):**
- Rule builders for selecting tools by conditions (matching diameters, maximum finish radius)
- **Largest inscribed circle heuristic** for arbitrary shaped features
- Ability to filter geometry of arbitrary shape for the largest available tool that fits

**What Alphacam Has:**
- Rule builders mentioned in problem statement ✅
- Matching diameters for circular features ✅
- Maximum finish radius filtering ✅
- **Largest inscribed circle for arbitrary shapes** ❌ **MISSING**

### 4. Related Functionality in Alphacam

The following existing capabilities are tangentially related:

| Feature | Description | Relevance |
|---------|-------------|-----------|
| Feature Recognition | Automatic detection of holes, pockets, slots | Can identify feature types but not calculate max tool size |
| Circle Properties | Extract diameter/radius from circular geometry | Only works for perfect circles, not arbitrary shapes |
| Contour Extraction | Extract 2D contours from 3D faces | Could provide boundary data for inscribed circle algorithm |
| Edge Detection | Identify and chain edges | Could provide boundary data for analysis |
| Tool Selection API | Programmatic tool selection | Would be used to select tool after calculation |
| Tool Geometry Access | Get geometric properties of tools | Useful for comparing tool sizes |

### 5. Gaps Requiring Development

To implement CAMworks-equivalent functionality, the following needs to be developed:

1. **Inscribed Circle Calculation Algorithm**
   - Algorithm to calculate the largest circle that fits inside arbitrary closed polygons/curves
   - Support for complex geometries (concave, convex, with holes)
   - Performance optimization for real-time feature analysis

2. **Tool-to-Feature Matching Logic**
   - Compare inscribed circle diameter with available tool diameters
   - Select largest tool that fits (with appropriate clearance)
   - Handle tool database queries

3. **Integration with Feature Recognition**
   - Extract feature boundaries from recognized features
   - Convert 3D feature geometry to 2D profiles for analysis
   - Handle multiple contours and island detection

4. **User Interface Components**
   - Rule builder UI for inscribed circle criteria
   - Visual feedback showing inscribed circle calculations
   - Tool selection dialog with inscribed circle metrics

5. **Performance Considerations**
   - Efficient algorithms for large part files
   - Caching of calculations
   - Progressive refinement for complex geometry

---

## Recommended Implementation Approach

### Phase 1: Algorithm Development
1. Research and implement inscribed circle algorithms:
   - Voronoi diagram-based approach
   - Medial axis transform
   - Iterative approximation methods
2. Create unit tests for various geometric shapes
3. Benchmark performance

### Phase 2: API Integration
1. Use **Feature API** to extract contours and boundaries
2. Use **acamapi** to access tool database and properties
3. Implement feature-to-tool matching logic
4. Create add-in using C# (recommended) or VBA

### Phase 3: UI Development
1. Extend rule builders to include inscribed circle criteria
2. Add visual feedback for inscribed circle calculations
3. Integrate with existing tool selection workflows

### Phase 4: Testing & Optimization
1. Test with production parts from previous CAMworks workflows
2. Compare results with CAMworks outputs
3. Optimize for performance
4. Create user documentation

---

## Technical Resources Available

### Documentation
- Feature API: 58 pages in `Feature.chm`
- acamapi: 194 pages in `acamapi.chm`
- Primitives API: 15 pages in `Primitives.chm`
- All documentation available in `/docs/chm-files/`

### Code Examples
- GetToolGeometry: `/alphacam-provided-examples/API/AcamAddInsAPI/`
- Tool selection examples: `/alphacam-provided-examples/API/VBMacros/OperationsExamples.bas`
- Feature extraction examples: Throughout API examples

### Development Environment
- C# add-in templates: `/csharp-addins/templates/`
- VBA macro templates: `/vba-macros/templates/`
- Testing infrastructure: `/csharp-addins/tests/`

---

## Conclusion

**The requested largest inscribed circle functionality does not currently exist in the Alphacam API library.** However, Alphacam provides comprehensive APIs for:
- Feature recognition and extraction
- Geometry analysis
- Tool database access
- Add-in development

These APIs provide the necessary **building blocks** to develop the required functionality. A custom add-in implementing computational geometry algorithms for inscribed circle calculations would need to be created to achieve feature parity with CAMworks.

**Next Steps:**
1. Approve this research report
2. Prioritize algorithm approach (Voronoi vs. Medial Axis vs. Iterative)
3. Begin Phase 1: Algorithm Development
4. Create proof-of-concept with simple geometric shapes
5. Iterate toward production-ready solution

---

## Appendix: Search Methodology

**Search Terms Used:**
- "inscribed circle", "largest inscribed circle", "maximum inscribed circle"
- "tool fitting", "tool selection", "fit tool"
- "diameter", "radius", "geometry", "feature"
- "rule builder", "query builder", "filter"

**Locations Searched:**
- All source code files (.bas, .cs, .cpp, .py)
- All documentation files (.md, .chm)
- All example code in `/alphacam-provided-examples/`
- All add-in implementations in `/csharp-addins/`
- All VBA macros in `/vba-macros/`

**Tools Used:**
- grep/ripgrep for text search
- glob for file pattern matching
- Manual code review of relevant examples
- Documentation analysis of all 6 API CHM files

---

**Report End**
