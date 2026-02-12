# CHM Reader Tools

Tools for extracting and reading Compiled HTML Help (.chm) files on various platforms.

## Overview

These tools allow you to extract, convert, and search through .chm documentation files, making the Alphacam API documentation accessible during development regardless of your platform.

## Tools

- **extract_chm.py** - Extract CHM file contents to HTML
- **chm_to_html.py** - Convert CHM to browsable HTML format
- **search_chm.py** - Search through CHM documentation

## Requirements

```bash
pip install -r requirements.txt
```

## Usage

### Extract CHM Contents
```bash
python extract_chm.py path/to/file.chm --output output_directory
```

### Convert to HTML
```bash
python chm_to_html.py path/to/file.chm --output output_directory
```

### Search Documentation
```bash
python search_chm.py path/to/file.chm --query "search term"
```

## Platform Support

- **Windows**: Native CHM support, tools optional
- **Linux**: Requires `libchm` and Python tools
- **macOS**: Requires Python tools
