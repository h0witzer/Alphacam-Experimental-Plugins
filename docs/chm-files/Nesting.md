# Nesting.chm - Alphacam Nesting API Documentation

## Overview

The Nesting API provides comprehensive programmatic access to Alphacam's advanced nesting capabilities. This API enables developers to automate sheet layout optimization, manage nesting configurations, and control the entire nesting process through code.

**File**: `Nesting.chm`  
**Total Documentation Pages**: 152 HTML files  
**Primary Purpose**: Automated sheet nesting, layout optimization, and material utilization

## Main Components

### 1. Nesting Object
The core object that manages nesting operations.

**Key Methods:**
- `AutoNest` - Automatic nesting with optimization
- `Nest` - Manual nesting control
- `NestUsingEngine` - Nest using specific nesting engine
- `NewNestList` - Create new nesting configuration
- `NewSheetList` - Create new sheet list
- `NewTemporaryNestList` - Create temporary nesting session
- `LoadNestList` - Load saved nesting configuration
- `DeleteNestList` - Remove nesting list
- `DeleteNestListByIndex` - Remove by index
- `DeleteAllNestLists` - Clear all nesting lists
- `GetNestData` - Retrieve nesting results
- `GetNestInformation` - Get nesting statistics and information

**Key Properties:**
- `Count` - Number of nest lists
- `Item` - Access specific nest list
- `Level` - Nesting level/priority
- `Extensions` - Access nesting extensions

**Event Handlers:**
- `RegisterEventHandler` - Register for nesting events
- `RegisterExtensionHandler` - Register extension handlers
- `RegisterDebugEventHandler` - Debug event monitoring
- `RegisterDebugExtensionHandler` - Debug extension monitoring
- `UnRegisterEventHandler` - Unregister handlers

### 2. NestList Object
Represents a collection of parts to be nested.

- **Purpose**: Manage lists of parts for nesting operations
- **Operations**: Add, remove, configure parts for nesting

### 3. NestSheet Object
Represents sheet material for nesting.

- **Purpose**: Define sheet properties and constraints
- **Properties**: Sheet dimensions, material, grain direction

### 4. NestParts Collection & NestPart Object
Manages individual parts in the nesting operation.

- **Purpose**: Configure individual parts for nesting
- **Properties**: Part geometry, quantity, rotation constraints

### 5. NestPartInstance Object
Represents a placed instance of a part on a sheet.

- **Purpose**: Track placed parts and their positions
- **Properties**: Position, rotation, sheet assignment

### 6. NestInformation Object
Provides statistics and results of nesting operations.

- **Purpose**: Access nesting efficiency, material usage, and placement data
- **Metrics**: Utilization percentage, waste, number of sheets used

### 7. NestExtension & NestExtensions
Plugin system for custom nesting behavior.

- **Purpose**: Extend nesting functionality with custom logic
- **Type**: `ExtensionType` enumeration defines extension types
- **Capabilities**: Custom placement algorithms, validation, post-processing

## Enumerations

### NestDirection
Controls part orientation and rotation during nesting.

### NestCutDirection
Defines cutting path direction for nested parts.

### ExtensionType
Types of nesting extensions available.

### NestLevel
Priority levels for nesting operations.

## Nesting Events

The API provides comprehensive event notifications:

- **NestEvents** - Core nesting lifecycle events
- **Debug Events** - Detailed debugging information
- **Extension Events** - Custom extension notifications

## Use Cases

### Material Optimization
- Minimize waste through intelligent part placement
- Maximize sheet utilization
- Calculate material requirements automatically

### Production Planning
- Generate optimal cutting layouts
- Estimate material costs
- Plan sheet requirements for production runs

### Automation
- Batch processing of nesting jobs
- Automated layout generation
- Integration with ERP/MRP systems

### Custom Nesting Algorithms
- Implement custom placement strategies via extensions
- Add business-specific nesting rules
- Integrate third-party nesting engines

## Key Features

### Automatic Nesting
- AI-driven part placement
- Multi-sheet optimization
- Rotation and orientation optimization
- Grain direction consideration

### Manual Control
- Programmatic part placement
- Custom spacing rules
- Sheet-specific constraints
- Priority-based nesting

### Sheet Management
- Multiple sheet sizes
- Material type tracking
- Grain direction handling
- Remnant tracking

### Part Configuration
- Quantity specification
- Rotation constraints (0°, 90°, 180°, 270°)
- Spacing requirements
- Priority levels

### Results and Reporting
- Material utilization statistics
- Waste calculation
- Sheet count and usage
- Part placement coordinates
- Detailed nesting information

## Workflow

### Basic Nesting Workflow:
1. Create or load a NestList
2. Add parts with quantities and constraints
3. Define sheet properties (size, material, grain)
4. Configure nesting parameters
5. Execute nesting operation (AutoNest or manual)
6. Retrieve results via GetNestInformation
7. Extract placement data via GetNestData

### Extension Workflow:
1. Implement custom extension logic
2. Register extension handler
3. Hook into nesting lifecycle events
4. Apply custom algorithms or validation
5. Return results to nesting engine

## Programming Language

- **Primary**: VBA (Visual Basic for Applications)
- **Platform**: Windows COM automation
- **Extensibility**: COM-based extension model

## Advanced Features

### Nesting Engines
- Support for multiple nesting algorithms
- Switch between engines programmatically
- Custom engine integration via extensions

### Temporary Nesting
- Test layouts without saving
- Quick what-if scenarios
- Temporary configurations

### Debug Mode
- Detailed event logging
- Step-by-step placement tracking
- Performance monitoring

## Integration Points

- **Drawing API**: Access part geometry from drawings
- **Output**: Generate NC code for nested layouts
- **Reporting**: Export nesting results
- **Extensions**: Plugin architecture for customization

## Related APIs

- **acamapi.chm** - Core Alphacam API for drawing and geometry access
- **Feature.chm** - Feature extraction for complex part geometry
- **Primitives.chm** - Graphics primitives for visualization

## Technical Details

- **Total Files**: 152 HTML documentation pages (largest API documentation)
- **Documentation Format**: RoboHelp generated HTML
- **Character Encoding**: Windows-1252
- **Complexity**: High - comprehensive nesting system with many options
- **Components**: 10+ major object types with extensive methods and properties

## Performance Considerations

- Large part quantities may require optimization
- Sheet size affects nesting algorithm performance
- Extension handlers should be efficient
- Consider using temporary nesting for testing

## Best Practices

1. Register event handlers to monitor nesting progress
2. Use GetNestInformation to verify results before committing
3. Implement proper error handling for nesting failures
4. Clean up temporary nest lists after use
5. Consider material grain direction for optimal results
6. Use appropriate nesting engine for part complexity
