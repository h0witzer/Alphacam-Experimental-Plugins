# VBA Parsing Tools for Alphacam

This directory contains tools for parsing and analyzing VBA macro files used in Alphacam.

## Overview

The Alphacam software uses VBA (Visual Basic for Applications) macros in two formats:
1. **`.bas` files** - Plain text VBA Basic modules
2. **`.arb` files** - Binary OLE compound documents containing complete VBA projects

This toolset provides comprehensive parsing capabilities for both formats.

## Files

### `vba_parser.py`
Main parsing tool that extracts structured information from VBA files.

**Features:**
- Parse `.bas` plain text VBA modules
- Parse `.arb` binary VBA project files
- Extract subs, functions, variables, and API usage
- Generate JSON output for further processing
- Batch processing of multiple files

**Usage:**
```bash
# Parse all VBA files in the repository
python3 vba_parser.py --all

# Parse a single file
python3 vba_parser.py path/to/file.bas
python3 vba_parser.py path/to/file.arb

# Parse all files in a directory
python3 vba_parser.py path/to/directory/
```

### `vba_parsing_results.json`
Complete parsing results for all VBA files in the repository.

**Contains:**
- File metadata (path, name, size, type)
- Module information
- Procedure definitions (subs and functions)
- Variable declarations
- Alphacam API usage statistics
- External library references

## Parsing Capabilities

### .bas File Parsing

Extracts:
- ✅ Module names (from VB_Name attributes)
- ✅ Option statements
- ✅ Public/Private Sub procedures
- ✅ Public/Private Functions with return types
- ✅ Parameter lists
- ✅ Variable declarations (Public, Private, Dim)
- ✅ Line counts for each procedure
- ✅ Alphacam API object usage patterns

### .arb File Parsing

Extracts:
- ✅ VBA project module names
- ✅ External library references (by GUID)
- ✅ OLE compound document structure
- ✅ Embedded VBA code sections
- ✅ Project metadata

## Example Output

### Parsing a .bas file:
```json
{
  "file_name": "HelloWorld.bas",
  "module_name": "HelloWorld",
  "option_statements": ["Explicit"],
  "total_subs": 1,
  "total_functions": 0,
  "subs": [
    {
      "name": "HelloWorld",
      "visibility": "Public",
      "parameters": "none",
      "line_count": 8
    }
  ],
  "api_calls": {
    "App": 2,
    "Frame": 1
  }
}
```

### Parsing an .arb file:
```json
{
  "file_name": "PolyLinesToLayer.arb",
  "file_type": "VBA OLE Compound Document (.arb)",
  "modules": ["Events", "Main"],
  "module_count": 2,
  "has_vba_code": true,
  "references": [
    "Visual Basic For Applications",
    "AlphaCAM Router",
    "OLE Automation"
  ]
}
```

## Repository Statistics

Based on parsing all files in this repository:

- **71 total VBA files**
  - 56 `.bas` files
  - 15 `.arb` files
- **749 total procedures**
  - 304 Sub procedures
  - 445 Functions
- **146 VBA modules** in .arb files

## Alphacam API Objects Detected

The parser identifies usage of these Alphacam API objects:

| Object | Purpose |
|--------|---------|
| `App` | Main application object |
| `Drawing` / `ActiveDrawing` | Drawing manipulation |
| `Path` | Geometry paths (2D/3D) |
| `Geo2D` / `PolyLine` | Geometry creation |
| `Element` | Path elements (lines, arcs) |
| `MillData` | Machining operation parameters |
| `MillTool` | Tool definitions |
| `WorkPlane` | 3D work plane definitions |
| `Layer` | Layer management |
| `Frame` | UI frame and dialogs |

## Understanding the File Formats

### .bas Files (Plain Text)
Standard VBA Basic module files that can be viewed in any text editor. They follow the standard VBA syntax and can be imported into VBA projects.

**Structure:**
```vba
Attribute VB_Name = "ModuleName"
Option Explicit

Public Sub ProcedureName()
    ' Code here
End Sub
```

### .arb Files (Binary OLE Compound)
Microsoft OLE Compound Document Format containing:
- VBA project metadata
- Multiple VBA modules
- External library references
- Project settings and configurations

These files require special parsing to extract the embedded VBA code and metadata.

## Technical Details

### Dependencies
- Python 3.6+
- Standard library only (no external dependencies)

### Implementation
- **Regular expressions** for pattern matching in VBA code
- **Binary file reading** for .arb OLE compound documents
- **JSON output** for structured data representation

### Parser Classes

#### `VBABasParser`
Parses plain text `.bas` files using regex patterns to extract:
- Module structure
- Procedure definitions
- Variable declarations
- API usage patterns

#### `VBAArbParser`
Parses binary `.arb` files by:
- Reading OLE compound document structure
- Extracting project directory information
- Identifying module names and references
- Locating embedded VBA code sections

## Use Cases

1. **Code Analysis** - Understand VBA macro structure and dependencies
2. **Documentation** - Generate documentation from VBA code
3. **Migration** - Extract VBA code for migration to other platforms
4. **API Usage** - Analyze how Alphacam API is being used
5. **Code Search** - Find specific procedures or API patterns

## Further Reading

See the comprehensive documentation:
- [VBA Parsing Capabilities](../docs/VBA_PARSING_CAPABILITIES.md) - Detailed analysis of parsing results

## Contributing

To extend the parser:
1. Add new regex patterns to extract additional VBA constructs
2. Enhance .arb parsing to extract more metadata
3. Add support for other VBA-related file formats
4. Improve API pattern detection

## License

This tool is part of the Alphacam Experimental Plugins repository.
