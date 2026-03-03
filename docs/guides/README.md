# Development Guides

This directory contains guides and tutorials for developing Alphacam macros and addins.

## API Documentation

Before starting development, review the comprehensive API documentation in **[../chm-files/README.md](../chm-files/README.md)** which covers:

- **acamapi** - Core Alphacam CAD/CAM API
- **Nesting** - Sheet nesting and optimization
- **AEDITAPI** - Editor automation
- **Feature** - Feature extraction
- **Primitives** - Utility objects and graphics
- **ConstraintsAPI** - Parametric constraints

## Available Guides

- **[3D Solid-Defined Machining Automation](./3d-solid-machining-automation.md)**  
  End-to-end roadmap for building a per-part add-in that applies configurable 3D solid-defined machining strategies **before nesting**, without relying on layers or the Automation Manager. Covers:
  - Language options: C# (in-process add-in), Python via COM, C++ via COM
  - Full API object reference for `MillData`, `RoughFinish()`, `Engrave()`, and lead-in/lead-out
  - JSON configuration schema for user-configurable operation lists
  - Pre-nesting integration patterns (event hooks, batch scripts)
  - Related examples: `csharp-addins/examples/SolidMachiningAddin.cs`

## Recommended Topics

Consider creating guides for:

- **Getting Started with VBA Macros**
  - Setting up the development environment
  - Creating your first macro
  - Debugging VBA code in Alphacam

- **Getting Started with C# Addins**
  - Setting up Visual Studio
  - Referencing Alphacam APIs
  - Building and deploying addins

- **API Usage Examples**
  - Common API patterns
  - Working with geometry
  - Managing toolpaths
  - Automating operations

- **Best Practices**
  - Code organization
  - Error handling
  - Testing strategies
  - Performance optimization

- **Troubleshooting**
  - Common issues and solutions
  - Debugging techniques
  - API limitations

## Contributing Guides

When adding new guides:
1. Use Markdown format (.md)
2. Include code examples
3. Add screenshots where helpful
4. Keep guides focused and practical
5. Update this README with links to new guides
