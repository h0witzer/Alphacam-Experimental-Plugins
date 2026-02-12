# Documentation

This directory contains all documentation related to Alphacam API and macro development.

## Structure

- **chm-files/** - Compiled HTML Help (.chm) files containing Alphacam API documentation
- **api-reference/** - Extracted or converted API reference documentation
- **guides/** - Development guides and tutorials

## Using CHM Files

CHM (Compiled HTML Help) files can be viewed on Windows natively. For cross-platform access:

### Windows
- Double-click the .chm file to open in Windows Help Viewer

### Linux/Mac
Use the CHM reader tools provided in `tools/chm-reader/`:
```bash
# Extract CHM contents
python tools/chm-reader/extract_chm.py docs/chm-files/your-file.chm

# Convert to HTML
python tools/chm-reader/chm_to_html.py docs/chm-files/your-file.chm
```

## Adding Documentation

1. Place .chm files in the `chm-files/` directory
2. Use descriptive filenames (e.g., `alphacam-api-v2024.chm`)
3. Add a brief description in this README for each file added

## Available Documentation

### Alphacam API CHM Files (6 files, 585+ pages)

Complete API documentation is available in the `chm-files/` directory:

1. **[acamapi.chm](./chm-files/acamapi.md)** (194 pages) - Core Alphacam CAD/CAM API
   - Drawing operations, geometry creation, machining, toolpaths, NC output

2. **[Nesting.chm](./chm-files/Nesting.md)** (152 pages) - Sheet nesting and optimization
   - Automated part placement, material utilization, custom nesting engines

3. **[AEDITAPI.chm](./chm-files/AEDITAPI.md)** (154 pages) - Editor automation
   - Document management, text selection, editor operations

4. **[Feature.chm](./chm-files/Feature.md)** (58 pages) - Feature extraction from 3D models
   - Automatic feature recognition, contour extraction, face analysis

5. **[Primitives.chm](./chm-files/Primitives.md)** (15 pages) - Utility library
   - Vector graphics, file operations, encryption, CSV reading

6. **[ConstraintsAPI.chm](./chm-files/ConstraintsAPI.md)** (12 pages) - Parametric constraints
   - Parameter management, algebraic relationships, constraint-driven design

See **[chm-files/README.md](./chm-files/README.md)** for a comprehensive overview, quick start guide, and use case matrix.
