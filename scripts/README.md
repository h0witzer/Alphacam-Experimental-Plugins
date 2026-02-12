# Scripts Directory

This directory contains helper scripts for setting up and managing the Alphacam plugins development environment.

## Available Scripts

### Setup Scripts

#### `setup-chm-tools.sh` (Linux/Mac)
Sets up the Python environment and installs dependencies for CHM reader tools.

```bash
chmod +x scripts/setup-chm-tools.sh
./scripts/setup-chm-tools.sh
```

#### `setup-chm-tools.bat` (Windows)
Windows version of the CHM tools setup script.

```cmd
scripts\setup-chm-tools.bat
```

## Creating New Scripts

When adding new scripts:
1. Place them in this directory
2. Use descriptive names
3. Add documentation in this README
4. Make shell scripts executable: `chmod +x script-name.sh`
5. Include error handling and helpful messages

## Script Naming Convention

- Use lowercase with hyphens: `setup-environment.sh`
- Add platform-specific extensions: `.sh` for Unix/Linux/Mac, `.bat` for Windows
- Keep names descriptive but concise
