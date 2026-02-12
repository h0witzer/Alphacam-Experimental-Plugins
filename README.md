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
│   └── README.md
├── tools/                   # Development tools
│   └── chm-reader/          # Tools for reading CHM files
│       ├── extract_chm.py
│       ├── chm_to_html.py
│       ├── search_chm.py
│       ├── requirements.txt
│       └── README.md
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

2. **Add your CHM documentation files**:
   - Place Alphacam API .chm files in `docs/chm-files/`

3. **Set up CHM reader tools** (optional, for Linux/Mac or advanced Windows users):
   ```bash
   # Linux/Mac
   ./scripts/setup-chm-tools.sh
   
   # Windows
   scripts\setup-chm-tools.bat
   ```

## 📖 Using CHM Documentation

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