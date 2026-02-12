# C# Addins

This directory contains C# addins for Alphacam automation and customization.

## Structure

- **examples/** - Sample C# addins demonstrating common operations
- **tests/** - Unit tests and integration tests for C# addins
- **templates/** - Template projects for creating new C# addins
- **lib/** - Shared libraries and dependencies

## Getting Started

1. Ensure you have .NET SDK installed
2. Place Alphacam API assemblies in the `lib/` directory
3. Reference the .chm API documentation in `docs/chm-files/`
4. Use the templates provided to create new addins

## Building

```bash
# Build all addins
dotnet build

# Run tests
dotnet test
```

## Testing

Unit tests should be placed in the `tests/` directory using a testing framework like xUnit or NUnit. Follow the AAA (Arrange-Act-Assert) pattern for test structure.

## Best Practices

- Use dependency injection where possible
- Follow C# naming conventions
- Write comprehensive unit tests
- Document public APIs with XML comments
- Handle exceptions gracefully
