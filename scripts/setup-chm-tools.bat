@echo off
REM Setup script for CHM reader tools (Windows)

echo Setting up CHM reader tools...

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed.
    echo Please install Python 3 to use the CHM reader tools.
    echo Download from: https://www.python.org/downloads/
    exit /b 1
)

echo Python found:
python --version

REM Check if pip is installed
pip --version >nul 2>&1
if errorlevel 1 (
    echo Error: pip is not installed.
    echo Please install pip to continue.
    exit /b 1
)

echo pip found:
pip --version

REM Install Python dependencies
echo.
echo Installing Python dependencies...
pip install -r tools\chm-reader\requirements.txt

if %errorlevel% equ 0 (
    echo.
    echo Setup complete!
    echo.
    echo You can now use the CHM reader tools:
    echo   - Extract CHM: python tools\chm-reader\extract_chm.py ^<file.chm^>
    echo   - Convert to HTML: python tools\chm-reader\chm_to_html.py ^<file.chm^>
    echo   - Search CHM: python tools\chm-reader\search_chm.py ^<file.chm^> -q "search term"
    echo.
    echo Note: On Windows, .chm files can also be opened directly by double-clicking them.
) else (
    echo.
    echo Error: Failed to install dependencies.
    echo Please check the error messages above and try again.
    exit /b 1
)
