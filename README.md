# Alphacam Experimental Plugins

A repository for developing and testing Alphacam macros and addins using VBA and C#. This repository provides a complete development environment with tools for accessing CHM documentation and testing your automation solutions.

## 📁 Repository Structure

```
Alphacam-Experimental-Plugins/
├── vba-macros/              # VBA macro development
│   ├── examples/            # Example VBA macros
│   ├── templates/           # Template files for new macros
│   ├── tests/               # Test documentation and files
│   └── README.md
├── csharp-addins/           # C# addin development
│   ├── examples/            # Example C# addins
│   ├── templates/           # Template projects
│   ├── tests/               # Unit and integration tests
│   ├── lib/                 # Shared libraries and dependencies
│   └── README.md
├── docs/                    # Documentation
│   ├── chm-files/           # Place .chm API documentation here
│   ├── api-reference/       # Extracted API documentation
│   ├── guides/              # Development guides and tutorials
│   ├── VBA_PARSING_SUMMARY.md     # VBA parsing capabilities summary
│   ├── VBA_PARSING_CAPABILITIES.md # Technical parsing details
│   ├── VBA_CODE_EXAMPLES.md       # Extracted VBA code examples
│   └── README.md
├── tools/                   # Development tools
│   ├── chm-reader/          # Tools for reading CHM files
│   │   ├── extract_chm.py
│   │   ├── chm_to_html.py
│   │   ├── search_chm.py
│   │   ├── requirements.txt
│   │   └── README.md
│   ├── vba_parser.py        # VBA code parser for .bas and .arb files
│   └── vba_parsing_results.json  # Parsed VBA analysis
└── scripts/                 # Helper scripts
    ├── setup-chm-tools.sh   # Setup for Linux/Mac
    ├── setup-chm-tools.bat  # Setup for Windows
    └── README.md
```

## 🚀 Getting Started

### Prerequisites

- **For VBA Development**: 
  - Alphacam installed
  - Basic VBA knowledge
  
- **For C# Development**:
  - .NET SDK 6.0 or later
  - Visual Studio or VS Code
  - Alphacam installed

- **For CHM Reader Tools** (optional):
  - Python 3.6 or later
  - pip package manager

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/h0witzer/Alphacam-Experimental-Plugins.git
   cd Alphacam-Experimental-Plugins
   ```

2. **Review API documentation**:
   - See **[docs/chm-files/README.md](docs/chm-files/README.md)** for complete API reference
   - 6 CHM files with 585+ pages of documentation covering all Alphacam APIs

3. **Add your CHM documentation files** (if needed):
   - CHM files are already included in `docs/chm-files/`
   - Additional documentation can be placed there

4. **Set up CHM reader tools** (optional, for Linux/Mac or advanced Windows users):
   ```bash
   # Linux/Mac
   ./scripts/setup-chm-tools.sh
   
   # Windows
   scripts\setup-chm-tools.bat
   ```

## 📖 API Documentation

This repository includes comprehensive API documentation for all Alphacam APIs:

- **[acamapi](docs/chm-files/acamapi.md)** - Core CAD/CAM API (194 pages)
- **[Nesting](docs/chm-files/Nesting.md)** - Sheet nesting & optimization (152 pages)
- **[AEDITAPI](docs/chm-files/AEDITAPI.md)** - Editor automation (154 pages)
- **[Feature](docs/chm-files/Feature.md)** - Feature extraction (58 pages)
- **[Primitives](docs/chm-files/Primitives.md)** - Utility library (15 pages)
- **[ConstraintsAPI](docs/chm-files/ConstraintsAPI.md)** - Parametric constraints (12 pages)

**See [docs/chm-files/README.md](docs/chm-files/README.md)** for the complete overview with:
- Detailed API descriptions
- Use case matrix
- Quick start guides
- Code examples
- API relationships

### Viewing CHM Documentation

### On Windows
Simply double-click the .chm files in `docs/chm-files/` to view them in Windows Help Viewer.

### On Linux/Mac or for Advanced Usage
Use the provided Python tools to extract and search CHM files:

```bash
# Extract CHM contents to HTML
python tools/chm-reader/extract_chm.py docs/chm-files/your-api.chm --output docs/api-reference/extracted

# Convert to browsable HTML with index
python tools/chm-reader/chm_to_html.py docs/chm-files/your-api.chm --output docs/api-reference/html

# Search for API methods
python tools/chm-reader/search_chm.py docs/chm-files/your-api.chm --query "DrawLine"
```

## 🔍 VBA Code Analysis

This repository includes a comprehensive VBA parser that can extract and analyze information from Alphacam VBA files:

### VBA Parser Tool

Parse both `.bas` (plain text) and `.arb` (binary OLE compound) VBA files:

```bash
# Parse all VBA files in repository
python3 tools/vba_parser.py --all

# Parse a single file
python3 tools/vba_parser.py path/to/file.bas
python3 tools/vba_parser.py path/to/file.arb

# Parse a directory
python3 tools/vba_parser.py path/to/directory/
```

### Parsing Capabilities

✅ **71 VBA files** successfully parsed (100% success rate)
- 56 `.bas` files (plain text VBA modules)
- 15 `.arb` files (binary VBA project containers)

✅ **749 procedures** extracted
- 304 Sub procedures
- 445 Functions

✅ **Extracts**:
- Module names and structure
- Sub/Function definitions with parameters
- Variable declarations
- API object usage patterns (Drawing, Path, MillData, etc.)
- External library references

### Documentation

- **[VBA Parsing Summary](docs/VBA_PARSING_SUMMARY.md)** - Executive summary and statistics
- **[VBA Parsing Capabilities](docs/VBA_PARSING_CAPABILITIES.md)** - Technical details
- **[VBA Code Examples](docs/VBA_CODE_EXAMPLES.md)** - Real extracted code examples
- **[Tools README](tools/README.md)** - Parser usage guide

## 🔧 VBA Macro Development

### Creating a New Macro

1. Copy the template:
   ```bash
   cp vba-macros/templates/MacroTemplate.bas vba-macros/examples/MyNewMacro.bas
   ```

2. Edit your macro in a text editor or VBA IDE

3. Test in Alphacam

4. Document your tests in `vba-macros/tests/`

See [vba-macros/README.md](vba-macros/README.md) for detailed instructions.

## 🔨 C# Addin Development

### Creating a New Addin

1. Copy the template:
   ```bash
   cp csharp-addins/templates/AddinTemplate.cs csharp-addins/examples/MyNewAddin.cs
   ```

2. Implement your addin logic

3. Build the project:
   ```bash
   dotnet build
   ```

4. Run tests:
   ```bash
   dotnet test
   ```

5. Deploy to Alphacam's addin directory

See [csharp-addins/README.md](csharp-addins/README.md) for detailed instructions.

## 🧪 Testing

### VBA Testing
VBA uses manual testing with documented test cases. See [vba-macros/tests/README.md](vba-macros/tests/README.md) for the testing approach.

### C# Testing
C# addins use xUnit or NUnit for automated testing:

```bash
# Run all tests
dotnet test

# Run specific test
dotnet test --filter "FullyQualifiedName~HelloWorldTests"

# Generate coverage report
dotnet test /p:CollectCoverage=true
```

## 📚 Documentation

- **VBA Macros**: [vba-macros/README.md](vba-macros/README.md)
- **C# Addins**: [csharp-addins/README.md](csharp-addins/README.md)
- **CHM Tools**: [tools/chm-reader/README.md](tools/chm-reader/README.md)
- **API Documentation**: Place CHM files in [docs/chm-files/](docs/chm-files/)
- **Development Guides**: [docs/guides/](docs/guides/)

## 🤝 Contributing

1. Create a new branch for your feature or fix
2. Follow the existing code structure and conventions
3. Test your changes thoroughly
4. Document your code and provide examples
5. Submit a pull request

## 📝 Best Practices

### VBA Macros
- Use `Option Explicit` for type safety
- Implement error handling with `On Error GoTo`
- Document your code with comments
- Keep macros modular and reusable

### C# Addins
- Follow C# naming conventions
- Use dependency injection where possible
- Write comprehensive unit tests
- Document public APIs with XML comments
- Handle exceptions gracefully

## 🛠️ Troubleshooting

### CHM Files Won't Open on Windows
- Right-click the file → Properties → Click "Unblock" → OK

### Python Tools Installation Issues
- Ensure Python 3.6+ is installed: `python --version`
- Upgrade pip: `pip install --upgrade pip`
- Install dependencies manually: `pip install pychm beautifulsoup4 lxml`

### C# Build Errors
- Verify .NET SDK is installed: `dotnet --version`
- Restore packages: `dotnet restore`
- Clean and rebuild: `dotnet clean && dotnet build`

## 📄 License

[Add your license information here]

## 👥 Authors

[Add author/maintainer information here]

## 🔗 Resources

- [Alphacam Official Website](https://www.alphacam.com/)
- [VBA Reference](https://docs.microsoft.com/en-us/office/vba/api/overview/)
- [.NET Documentation](https://docs.microsoft.com/en-us/dotnet/)