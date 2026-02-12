# Quick Start Guide

Welcome to the Alphacam Experimental Plugins repository! This guide will help you get started quickly.

## What's Been Set Up For You

This repository is now fully configured with:

✅ **VBA Macro Development Environment**
- Templates for creating new macros
- Example macros to learn from
- Test documentation structure

✅ **C# Addin Development Environment**
- C# project templates
- Example addins with best practices
- Unit testing framework ready

✅ **Documentation System**
- Place for your .chm API files
- Tools to extract and browse CHM files on any platform
- Structure for guides and tutorials

✅ **CHM Reader Tools**
- Python scripts to extract CHM contents
- Convert CHM to browsable HTML
- Search through documentation

## First Steps

### 1. Add Your Documentation

Place your Alphacam API .chm files in:
```
docs/chm-files/
```

### 2. Set Up CHM Tools (Optional)

If you want to extract or search CHM files:

**Windows:**
```cmd
scripts\setup-chm-tools.bat
```

**Linux/Mac:**
```bash
chmod +x scripts/setup-chm-tools.sh
./scripts/setup-chm-tools.sh
```

### 3. Start Developing

**For VBA:**
1. Copy `vba-macros/templates/MacroTemplate.bas` to `vba-macros/examples/`
2. Rename and edit your new macro
3. Load it in Alphacam and test
4. Document tests in `vba-macros/tests/`

**For C#:**
1. Copy `csharp-addins/templates/AddinTemplate.cs` to `csharp-addins/examples/`
2. Rename and implement your addin
3. Build: `dotnet build`
4. Test: `dotnet test`

## Using CHM Documentation

### On Windows (Easiest)
Just double-click the .chm file in `docs/chm-files/`

### On Any Platform
```bash
# Extract to HTML
python3 tools/chm-reader/extract_chm.py docs/chm-files/api.chm

# Convert with index page
python3 tools/chm-reader/chm_to_html.py docs/chm-files/api.chm --output docs/api-reference/api-html

# Search for API methods
python3 tools/chm-reader/search_chm.py docs/chm-files/api.chm --query "DrawLine"
```

## Example Projects

### VBA Example
Check out `vba-macros/examples/HelloWorld.bas` for a simple working example.

### C# Example
Check out `csharp-addins/examples/HelloWorld.cs` for a simple working example.

## Directory Overview

```
📁 vba-macros/          ← VBA macro development
  📁 examples/          ← Working macro examples
  📁 templates/         ← Start new macros from these
  📁 tests/             ← Test documentation

📁 csharp-addins/       ← C# addin development
  📁 examples/          ← Working addin examples
  📁 templates/         ← Start new addins from these
  📁 tests/             ← Unit tests
  📁 lib/               ← Shared libraries

📁 docs/                ← All documentation
  📁 chm-files/         ← Put your .chm files here
  📁 api-reference/     ← Extracted documentation
  📁 guides/            ← Development guides

📁 tools/               ← Development tools
  📁 chm-reader/        ← CHM extraction & search tools

📁 scripts/             ← Setup and helper scripts
```

## Getting Help

- Read the README in each folder for detailed information
- Check example files for working code patterns
- Refer to extracted API documentation in `docs/api-reference/`

## Next Steps

1. ✅ Add your .chm documentation files
2. ✅ Try the example VBA macro or C# addin
3. ✅ Create your first custom macro or addin using templates
4. ✅ Write tests to verify functionality
5. ✅ Share your work by committing to the repository

Happy coding! 🚀
