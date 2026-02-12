# AEDITAPI.chm - Alphacam Editor API Documentation

## Overview

The AEDITAPI (Alphacam Editor API) provides programmatic access to the Alphacam Editor functionality. This API allows developers to automate and extend the editor capabilities through VBA macros and add-ins.

**File**: `AEDITAPI.chm`  
**Total Documentation Pages**: 154 HTML files  
**Primary Purpose**: Editor automation and scripting

## Main Components

### 1. Application Object
The top-level object that provides access to the editor environment.

- **Purpose**: Entry point for accessing documents, machines, and other editor objects
- **Key Methods**: File operations, document access
- **Key Properties**: Application-level settings and collections

### 2. Document Object
Represents an open document in the editor.

- **Purpose**: Manipulate and query individual documents
- **Methods**: Document operations (save, close, modify)
- **Properties**: Document metadata and content

### 3. Documents Collection
Manages multiple open documents.

- **Purpose**: Access and enumerate all open documents
- **Methods**: Add, remove, iterate through documents
- **Properties**: Count, current document

### 4. Selection Object
Controls text/content selection within documents.

- **Purpose**: Programmatic selection and manipulation of editor content
- **Key Methods**:
  - `SelectionCharRight` - Move selection right
  - `SelectionEndOfDocument` - Move to end
  - `SelectionDelete` - Delete selected content
  - `SelectionCopy` - Copy selection
  - `SelectionCut` - Cut selection
  - `SelectionPaste` - Paste content
  - `SelectionBackSpace` - Delete backward
  - `SelectionCancel` - Clear selection
- **Properties**: Current selection state, cursor position

### 5. Machine Object & Machines Collection
Represents machine configurations.

- **Purpose**: Access and manage machine definitions
- **Methods**: Machine-specific operations
- **Properties**: Machine parameters and settings

### 6. Frame Object
Represents the editor's frame/window.

- **Purpose**: Control editor window and UI elements
- **Methods**: Window manipulation
- **Properties**: Window state and properties

### 7. Options Object
Manages editor options and preferences.

- **Purpose**: Get and set editor configuration
- **Properties**: Various editor settings

## Main Topics/Sections

1. **Introduction** - Getting started with the AEDITAPI
2. **Objects** - Detailed object model documentation
3. **Alphaeedit Event Notifications** - Event-driven programming
4. **Misc** - Miscellaneous utilities and helpers

## Event Notifications

The API includes event-driven capabilities with the `AedMovementType` enumeration for handling editor events.

## Use Cases

- **Automation**: Automate repetitive editor tasks
- **Batch Processing**: Process multiple documents programmatically
- **Custom Tools**: Build custom editing tools and utilities
- **Integration**: Integrate editor functionality into workflows
- **Scripting**: Create macros for complex editing operations

## Programming Language

- **Primary**: VBA (Visual Basic for Applications)
- **Platform**: Windows COM automation

## Getting Started

1. Reference the AEDITAPI library in your VBA project
2. Create an instance of the Application object
3. Access documents through the Documents collection
4. Use Selection object for content manipulation

## Example Concepts

```vba
' Typical usage pattern (conceptual)
Dim app As Application
Set app = [Get Application Instance]

' Access documents
Dim doc As Document
Set doc = app.Documents.Item(1)

' Work with selections
app.Selection.SelectAll
app.Selection.Copy
```

## Related APIs

- **acamapi.chm** - Core Alphacam API
- **Feature.chm** - Feature extraction capabilities

## Technical Details

- **Total Files**: 154 HTML documentation pages
- **Documentation Format**: Adobe RoboHelp generated HTML
- **Character Encoding**: Windows-1252
