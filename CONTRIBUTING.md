# Contributing to Alphacam Experimental Plugins

Thank you for your interest in contributing! This document provides guidelines for contributing to the repository.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists
2. Create a new issue with:
   - Clear title
   - Detailed description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Environment details (Alphacam version, OS, etc.)

### Adding New Macros or Addins

1. **Fork and Clone**
   ```bash
   git clone https://github.com/h0witzer/Alphacam-Experimental-Plugins.git
   cd Alphacam-Experimental-Plugins
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-macro-name
   ```

3. **Develop Your Code**
   - For VBA: Add to `vba-macros/examples/`
   - For C#: Add to `csharp-addins/examples/`
   - Follow existing code style and structure

4. **Test Thoroughly**
   - VBA: Document tests in `vba-macros/tests/`
   - C#: Add unit tests in `csharp-addins/tests/`
   - Verify your code works in Alphacam

5. **Document Your Work**
   - Add comments to your code
   - Update README files if needed
   - Create usage examples

6. **Commit and Push**
   ```bash
   git add .
   git commit -m "Add [feature name]: brief description"
   git push origin feature/your-macro-name
   ```

7. **Create Pull Request**
   - Provide a clear description
   - Reference any related issues
   - Include screenshots or examples if applicable

## Code Style Guidelines

### VBA Macros

```vba
' Use descriptive comments
Option Explicit

' Constants in UPPER_CASE
Private Const MAX_RETRIES As Integer = 3

' Variables in camelCase
Dim itemCount As Integer
Dim userName As String

' Function names in PascalCase
Function CalculateTotal() As Double
    ' Add error handling
    On Error GoTo ErrorHandler
    
    ' Implementation here
    
    Exit Function
ErrorHandler:
    MsgBox "Error: " & Err.Description
End Function
```

### C# Addins

```csharp
using System;

namespace AlphacamAddins.Examples
{
    /// <summary>
    /// Clear XML documentation comments
    /// </summary>
    public class MyAddin
    {
        // Constants in UPPER_CASE with underscores
        private const int MAX_RETRIES = 3;
        
        // Private fields with underscore prefix
        private string _apiConnection;
        
        // Properties in PascalCase
        public string AddinName { get; set; }
        
        // Methods in PascalCase
        public void Execute()
        {
            try
            {
                // Implementation here
            }
            catch (Exception ex)
            {
                // Handle errors gracefully
                HandleError(ex);
            }
        }
        
        private void HandleError(Exception ex)
        {
            // Error handling implementation
        }
    }
}
```

## Testing Requirements

### VBA Testing

Document test cases in markdown format:

```markdown
# MyMacro Tests

## Test Case 1: Basic Functionality
- **Description**: Test basic operation
- **Steps**: 
  1. Step one
  2. Step two
- **Expected**: Expected result
- **Status**: Pass/Fail

## Test Case 2: Error Handling
...
```

### C# Testing

Write unit tests using xUnit:

```csharp
using Xunit;

namespace AlphacamAddins.Tests
{
    public class MyAddinTests
    {
        [Fact]
        public void MyMethod_ValidInput_ReturnsExpectedResult()
        {
            // Arrange
            var addin = new MyAddin();
            
            // Act
            var result = addin.MyMethod("test");
            
            // Assert
            Assert.Equal("expected", result);
        }
        
        [Fact]
        public void MyMethod_InvalidInput_ThrowsException()
        {
            // Arrange
            var addin = new MyAddin();
            
            // Act & Assert
            Assert.Throws<ArgumentException>(() => addin.MyMethod(null));
        }
    }
}
```

## Documentation Guidelines

### Code Comments

- Comment complex logic
- Explain "why" not "what"
- Keep comments up to date
- Use TODO/FIXME/NOTE markers appropriately

### README Files

When adding features that need documentation:

1. Update the relevant README.md
2. Add usage examples
3. Include screenshots if applicable
4. List any new dependencies

### CHM Documentation

If you have Alphacam API documentation:

1. Place .chm files in `docs/chm-files/`
2. Name files descriptively (e.g., `alphacam-2024-api.chm`)
3. Add a brief description to `docs/README.md`

## Pull Request Checklist

Before submitting a pull request:

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] New code has tests (for C#)
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] No unnecessary files included (check .gitignore)
- [ ] Code works in Alphacam (if applicable)

## Questions?

If you have questions:

1. Check existing documentation
2. Search closed issues
3. Open a new discussion or issue

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

Thank you for contributing! 🎉
