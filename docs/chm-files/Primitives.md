# Primitives.chm - Alphacam Primitives Library Documentation

## Overview

The Primitives library provides fundamental utility objects and vector graphics primitives for general use in Alphacam development. This library includes essential building blocks for graphics operations, file manipulation, cryptography, and data processing.

**File**: `Primitives.chm`  
**Total Documentation Pages**: 15 HTML files  
**Primary Purpose**: Utility objects, vector graphics primitives, and helper functions

## Main Components

### 1. Vector Graphics Objects (g-prefix)
Fundamental graphics primitives for 2D/3D geometry operations.

#### gVector
- **Purpose**: 3D vector representation and operations
- **Operations**: Vector math, transformations, normalization
- **Use Cases**: Direction calculations, geometric computations

#### gPoint
- **Purpose**: 2D/3D point representation
- **Operations**: Point transformations, distance calculations
- **Use Cases**: Coordinate storage, geometric references

#### gPV (Point-Vector)
- **Purpose**: Combined point and vector representation
- **Operations**: Ray calculations, line representations
- **Use Cases**: Line definitions, ray tracing

#### gColor
- **Purpose**: Color representation and manipulation
- **Operations**: Color creation, conversion, blending
- **Use Cases**: Graphics rendering, visual feedback
- **Object Reference**: `The_gColor_Object.htm`

#### Graphics Object
- **Purpose**: High-level graphics operations container
- **File**: `Graphics/Graphics.htm`
- **Contents**: Overview and coordination of graphics primitives

### 2. FilePath Object
File and folder manipulation utilities.

**Purpose**: Simplify file system operations

**Capabilities:**
- Path manipulation and validation
- File existence checking
- Directory operations
- Path combination
- File extension handling
- Directory traversal

**Use Cases:**
- Configuration file management
- Output file path generation
- Resource location
- Temporary file handling

### 3. Crypt Object
Encryption and security utilities.

**Purpose**: Data encryption and serial number generation

**Capabilities:**
- String encryption/decryption
- Long integer encryption
- Serial number generation
- Simple cryptographic operations

**Use Cases:**
- License key generation
- Configuration encryption
- Serial number creation
- Basic data protection

**Note**: Designed for basic protection, not military-grade security

### 4. CSVReader Object
CSV (Comma-Separated Values) file parser.

**Purpose**: Read and parse CSV data files

**Capabilities:**
- Parse CSV files
- Handle quoted fields
- Process multi-line data
- Column access by index or name

**Use Cases:**
- Import part lists
- Read configuration data
- Process exported data
- Batch data loading

### 5. Metaphone Object
Phonetic encoding algorithm implementation.

**Purpose**: Generate phonetic representations of strings

**Capabilities:**
- Phonetic string matching
- Sound-alike search
- Fuzzy string comparison

**Use Cases:**
- Name matching
- Fuzzy search implementations
- Data deduplication
- Sound-based sorting

### 6. RingTone Object
Ring tone generation (legacy functionality).

**Purpose**: Generate simple audio tones

**Capabilities:**
- Tone generation
- Alert sounds
- Audio feedback

**Use Cases:**
- User notifications
- Process completion alerts
- Error indication

### 7. SelectionSet Object
Manage collections of selected items.

**Purpose**: Track and manage user selections

**Capabilities:**
- Store multiple selections
- Selection enumeration
- Set operations (add, remove, clear)

**Use Cases:**
- Multi-item operations
- Batch processing
- Selection history
- Undo/redo support

## Library Structure

### Main Sections

1. **Root Level** (`Primitives.htm`)
   - Library overview
   - Setup instructions
   - General concepts

2. **Graphics** (`Graphics/`)
   - Vector graphics objects
   - 2D/3D primitives
   - Color management
   - Visual diagrams in Images folder

3. **Utilities**
   - FilePath object
   - Crypt object
   - CSV processing
   - Miscellaneous helpers

## Setup and Usage

### Visual Basic Setup
```vba
' Add reference to Primitives.DLL in VBA Editor
' Tools | References | Browse for Primitives.DLL
' Then use objects directly:

Dim pt As gPoint
Set pt = New gPoint
pt.x = 10
pt.y = 20
```

### Common Patterns

#### File Operations
```vba
Dim fp As FilePath
Set fp = New FilePath
If fp.FileExists("C:\path\to\file.txt") Then
    ' Process file
End If
```

#### Vector Math
```vba
Dim v1 As gVector
Dim v2 As gVector
' Perform vector operations
```

#### CSV Reading
```vba
Dim csv As CSVReader
Set csv = New CSVReader
csv.LoadFile "data.csv"
' Process rows
```

## Use Cases by Domain

### Graphics and Geometry
- **Primitives**: gVector, gPoint, gPV
- **Purpose**: Geometric calculations, transformations, rendering
- **Applications**: CAD operations, feature extraction, visualization

### File Management
- **Primitive**: FilePath
- **Purpose**: File system operations
- **Applications**: Config management, output generation, resource loading

### Data Processing
- **Primitives**: CSVReader, SelectionSet
- **Purpose**: Data import/export, collection management
- **Applications**: Batch processing, data exchange, reporting

### Security
- **Primitive**: Crypt
- **Purpose**: Basic encryption and key generation
- **Applications**: Licensing, configuration protection, serial numbers

### Search and Matching
- **Primitive**: Metaphone
- **Purpose**: Phonetic matching
- **Applications**: Fuzzy search, name matching, deduplication

### User Feedback
- **Primitives**: RingTone, gColor
- **Purpose**: Audio/visual feedback
- **Applications**: Notifications, status indication, alerts

## Programming Language

- **Primary**: VBA (Visual Basic for Applications)
- **Type**: COM DLL (Primitives.DLL)
- **Platform**: Windows
- **Distribution**: Separate library file

## Integration Points

### With Other APIs
- **acamapi**: Use gVector/gPoint for geometric operations
- **Feature API**: Graphics primitives for feature visualization
- **Nesting**: FilePath for output file management
- **ConstraintsAPI**: Vector math for constraint calculations

### Standalone Usage
All primitives can be used independently in any VBA project that references the Primitives.DLL

## Technical Details

- **Total Files**: 15 HTML documentation pages (compact, focused library)
- **Documentation Format**: Adobe RoboHelp generated HTML
- **Character Encoding**: Windows-1252
- **Complexity**: Low to Medium - well-defined utility objects
- **Dependencies**: None - self-contained library
- **Distribution**: Primitives.DLL

## Best Practices

1. **Graphics Objects**: Use g-prefixed objects for all geometric calculations
2. **FilePath**: Always validate paths before file operations
3. **Crypt**: Use for simple protection only, not sensitive data
4. **CSVReader**: Handle errors for malformed CSV files
5. **Memory**: Clean up objects when done (Set obj = Nothing)

## Performance Considerations

- Graphics primitives are lightweight and optimized
- FilePath operations are synchronous
- CSVReader loads entire file into memory
- Crypt operations are fast for typical string lengths

## Related APIs

- **acamapi.chm** - Uses Primitives for geometric operations
- **Feature.chm** - Leverages graphics primitives
- **Nesting.chm** - May use FilePath and CSVReader
- **AEDITAPI.chm** - Can use utilities for editor operations

## Visual Documentation

The library includes an **Images** folder with:
- Object model diagrams
- Visual representations of graphics primitives
- Example illustrations
