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

*(Add your .chm files here with descriptions)*
