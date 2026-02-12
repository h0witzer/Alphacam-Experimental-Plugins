# ConstraintsAPI.chm - Alphacam Constraints Manager API Documentation

## Overview

The ConstraintsAPI provides programmatic access to Alphacam's Constraints Manager functionality. This API enables developers to work with parametric constraints, algebraic parameters, and constraint relationships in Alphacam drawings.

**File**: `ConstraintsAPI.chm`  
**Total Documentation Pages**: 12 HTML files  
**Primary Purpose**: Parametric constraint management and constraint-driven geometry

## Main Components

### 1. ConstraintMain Object
The primary entry point for the Constraints API.

- **Purpose**: Main object that provides access to Algebra and IGM objects
- **Key Method**: `InsertConstrainedDrawing` - Insert constrained geometry
- **Role**: Gateway to constraint system functionality

### 2. ConstraintAlgebra Object
Manages algebraic parameters and their relationships.

- **Purpose**: Holds all data about parameters in the constraint system
- **Key Features**:
  - Parameter definition and management
  - Algebraic relationships
  - Parameter evaluation
- **Child Objects**: `Parameter` - individual parameter objects

### 3. ConstraintIgm Object
Manages constraints and geometric relationships (IGM = Interactive Geometry Manager).

- **Purpose**: Holds information about constraints between geometric elements
- **Key Method**: `Evaluate` - Evaluate constraint expressions
- **Features**: Constraint definition, validation, and evaluation

## Main Topics/Sections

1. **Introduction** - Getting started with constraints
   - `ConstraintsIntro.htm` - Introduction to the constraints system
   - `Basics.htm` - Basic concepts and workflow

2. **API** - Core API reference
   - Object model documentation
   - Method and property references
   - Code examples

3. **UI** - User interface integration
   - Working with constraint UI elements

4. **HowTo** - Practical guides and tutorials

5. **Reference** - Complete API reference

## Key Concepts

### Parameters
- Algebraic variables that drive geometry
- Can be simple values or complex expressions
- Stored and managed by ConstraintAlgebra

### Constraints
- Relationships between geometric elements
- Dimensional constraints (distances, angles)
- Geometric constraints (parallel, perpendicular, tangent)
- Managed by ConstraintIgm

### Constrained Drawings
- Drawings with parametric relationships
- Can be inserted and manipulated programmatically
- Automatically update when parameters change

## Setup Requirements

To use the Constraints API in VBA:

1. Open the VBA Editor in Alphacam
2. Go to **Tools | References**
3. Enable **'Alphacam Constraints Type Library'**
4. Access constraint objects through ConstraintMain

## Use Cases

- **Parametric Design**: Create geometry driven by parameters
- **Automated Configuration**: Build configurable part templates
- **Design Automation**: Generate families of similar parts
- **Constraint-Based Modeling**: Define relationships between geometric elements
- **Dynamic Geometry**: Create self-updating designs

## Programming Language

- **Primary**: VBA (Visual Basic for Applications)
- **Type Library**: Alphacam Constraints Type Library
- **Platform**: Windows COM automation

## Example Workflow

The documentation includes annotated examples showing:

1. Reference the Constraints Type Library
2. Create/access ConstraintMain object
3. Work with ConstraintAlgebra for parameters
4. Use ConstraintIgm for geometric constraints
5. Insert and manipulate constrained drawings

## Integration Points

- Works with Alphacam drawing objects
- Integrates with the main Alphacam API (acamapi)
- Can be used in conjunction with Feature API

## Related APIs

- **acamapi.chm** - Core Alphacam API for drawing operations
- **Feature.chm** - Feature extraction and manipulation
- **Primitives.chm** - Graphics and vector operations

## Technical Details

- **Total Files**: 12 HTML documentation pages
- **Documentation Format**: Adobe RoboHelp generated HTML
- **Character Encoding**: UTF-8
- **Complexity**: Moderate - focused API with clear object hierarchy
