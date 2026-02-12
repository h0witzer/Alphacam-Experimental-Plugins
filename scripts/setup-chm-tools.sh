#!/bin/bash
# Setup script for CHM reader tools

echo "Setting up CHM reader tools..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed."
    echo "Please install Python 3 to use the CHM reader tools."
    exit 1
fi

echo "Python 3 found: $(python3 --version)"

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "Error: pip3 is not installed."
    echo "Please install pip3 to continue."
    exit 1
fi

echo "pip3 found: $(pip3 --version)"

# Install Python dependencies
echo ""
echo "Installing Python dependencies..."
pip3 install -r tools/chm-reader/requirements.txt

if [ $? -eq 0 ]; then
    echo ""
    echo "Setup complete!"
    echo ""
    echo "You can now use the CHM reader tools:"
    echo "  - Extract CHM: python3 tools/chm-reader/extract_chm.py <file.chm>"
    echo "  - Convert to HTML: python3 tools/chm-reader/chm_to_html.py <file.chm>"
    echo "  - Search CHM: python3 tools/chm-reader/search_chm.py <file.chm> -q 'search term'"
else
    echo ""
    echo "Error: Failed to install dependencies."
    echo "Please check the error messages above and try again."
    exit 1
fi
