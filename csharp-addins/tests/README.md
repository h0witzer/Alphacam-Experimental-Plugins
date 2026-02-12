# C# Addin Tests

This directory contains unit tests and integration tests for C# addins.

## Testing Framework

We recommend using **xUnit** or **NUnit** for testing C# addins. Example test file structure is provided.

## Running Tests

```bash
# Install dependencies (if not using project file)
dotnet add package xunit
dotnet add package xunit.runner.visualstudio

# Run all tests
dotnet test

# Run specific test
dotnet test --filter "FullyQualifiedName~HelloWorldTests"

# Run with verbose output
dotnet test --logger "console;verbosity=detailed"
```

## Test Structure

- Use the **AAA pattern** (Arrange-Act-Assert)
- One test class per production class
- Clear, descriptive test names
- Test both success and failure scenarios

## Mocking

For testing code that interacts with Alphacam API:

```csharp
using Moq;

// Create mock of Alphacam API
var mockApi = new Mock<IAlphacamAPI>();
mockApi.Setup(x => x.GetVersion()).Returns("2024.1");

// Inject mock into your addin
var addin = new YourAddin(mockApi.Object);
```

## Integration Tests

For integration tests that require Alphacam:
- Place in separate test project or namespace
- Mark with `[Trait("Category", "Integration")]`
- Run separately from unit tests

## Coverage

To generate code coverage reports:

```bash
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=lcov
```
