# VBA Tests

This directory contains test files for VBA macros.

## Testing Approach

Since VBA doesn't have a built-in unit testing framework, we recommend:

1. **Manual Testing**: Create test workbooks with sample data
2. **Test Documentation**: Document test cases in markdown files
3. **VBA-TDD**: Consider using a VBA testing framework like [Rubberduck](https://github.com/rubberduck-vba/Rubberduck)

## Test Structure

Each macro should have a corresponding test file that documents:
- Test case description
- Input data
- Expected results
- Actual results
- Pass/Fail status

## Example Test File

Create test documentation files like `HelloWorld_Tests.md`:

```markdown
# HelloWorld Macro Tests

## Test Case 1: Basic Execution
- **Description**: Verify macro runs without errors
- **Steps**: 
  1. Open Alphacam
  2. Run HelloWorld macro
  3. Verify message box appears
- **Expected**: Message box with "Hello World" text
- **Status**: Pass

## Test Case 2: Error Handling
- **Description**: Verify error handling works
- **Steps**: 
  1. Modify macro to trigger error
  2. Run macro
  3. Verify error message appears
- **Expected**: Error dialog with descriptive message
- **Status**: Pass
```
