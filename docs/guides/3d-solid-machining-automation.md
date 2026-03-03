# Roadmap: Automated 3D Solid-Defined Machining Strategies

## Overview

This guide describes how to build a per-part automation add-in that generates **3D solid-defined machining toolpaths** based on a user-configurable operation list, without relying on layer extraction or the Automation Manager's geometry-mapping strategies. The add-in runs before nesting, processes each part individually, and saves a machined drawing ready for the nesting stage.

---

## Why Skip Layer-Based Automation?

The built-in Automation Manager assigns machining styles to layers. It works well for simple 2.5D geometry, but fails for:

- Complex freeform surfaces (multi-axis, drive surface milling)
- Feature-recognition requirements (pocket depth, face normals, drafted walls)
- Parts where the same layer contains geometries that need different strategies
- Solid-defined toolpaths where Alphacam drives the cutter directly off the B-rep faces

Solid-defined 3D machining (`MillData` methods that accept solid/surface selections rather than 2D profiles) bypasses layers entirely. The API exposes these operations through `IAlphaCamApp` (acamapi) and feature extraction (Feature API).

---

## API Access by Language

Alphacam exposes all automation through a **Windows COM server**. The language you choose determines how you call that COM server.

### C# / .NET (Recommended First Choice)

C# is the language with the best Alphacam support:

- Alphacam ships interop assemblies (`AlphaCAMMill.dll`, `AlphaCAMRouter.dll`, etc.) for direct COM use
- The provided `DotNetAddIns` examples run **inside** the Alphacam process via the add-in host
- You can also drive Alphacam **out-of-process** using `Marshal.GetActiveObject` or `Activator.CreateInstance`
- Full testability using xUnit/NUnit and mocked interfaces (no Alphacam required to run unit tests)
- Visual Studio provides IntelliSense against the interop types

**Relevant examples in this repository:**
- `alphacam-provided-examples/API/DotNetAddIns/DoorExampleAddin/` — in-process add-in with machining routines
- `alphacam-provided-examples/API/CSharp.Net/RunAcam (CSharp)/` — out-of-process COM automation
- `csharp-addins/examples/SolidMachiningAddin.cs` — the example add-in built for this roadmap

### Python (via pywin32)

Python can drive Alphacam via COM using the `pywin32` package (`win32com.client`). This enables:

- Late-binding COM calls without pre-generating interop assemblies
- Scripts runnable from the command line, CI pipelines, or a scheduler
- Rapid prototyping and testing of the strategy logic

**Limitations:**
- No IntelliSense for Alphacam objects (use early binding with `makepy` to generate stubs)
- Only works on Windows (COM is Windows-only)
- Cannot be loaded as an in-process add-in; must drive Alphacam out-of-process

**Minimal Python bootstrap:**

```python
import win32com.client
import json

# Connect to a running Alphacam instance
acam = win32com.client.GetActiveObject("AlphaCAMMill.Application")
drw  = acam.ActiveDrawing

# Load operation config
with open("machining_config.json") as f:
    config = json.load(f)

for op in config["operations"]:
    apply_solid_operation(acam, drw, op)
```

To generate early-binding stubs (one-time setup):

```
python -m win32com.client.makepy "AlphaCAMMill"
```

### C++ (via COM)

C++ can consume the Alphacam COM server through:
- `#import` directives to generate type-library wrappers
- Raw `IDispatch` / `QueryInterface` calls for maximum control

C++ is useful when you need maximum performance or are embedding the logic inside a larger native application, but it requires significantly more boilerplate and is harder to unit-test. Unless you have an existing C++ infrastructure, C# or Python is easier to start with.

---

## Recommended Architecture

```
┌─────────────────────────────────────────────┐
│           machining_config.json             │  ← user-editable
│  { "operations": [                          │
│      { "type": "3DRoughParallel",           │
│        "tool": "BallEnd-12mm.art",          │
│        "stepover": 2.0,                     │
│        "final_depth": -30.0 },              │
│      { "type": "3DFinishParallel",          │
│        "tool": "BallEnd-6mm.art",           │
│        "stepover": 0.5,                     │
│        "final_depth": -30.0 }  ] }          │
└───────────────────────┬─────────────────────┘
                        │ loaded by
┌───────────────────────▼─────────────────────┐
│         SolidMachiningAddin (C#)            │
│  1. Open part file (IAlphaCamApp.OpenFile)  │
│  2. Select solid body geometry              │
│  3. For each operation in config:           │
│     a. SelectTool(tool name)                │
│     b. Create MillData / SolidMillData      │
│     c. Set depth, stepover, strategy type  │
│     d. Call machining method (returns Paths)│
│     e. Optionally add lead-in/lead-out      │
│  4. Save drawing                            │
│  5. Hand off to nesting pipeline            │
└─────────────────────────────────────────────┘
```

---

## Key API Objects for 3D Solid Machining

All objects below are in the `AlphaCAMMill` namespace (acamapi COM library).

| Object / Method | Purpose |
|---|---|
| `IAlphaCamApp` | Top-level application; entry point |
| `IAlphaCamApp.ActiveDrawing` | The current `Drawing` object |
| `IAlphaCamApp.SelectTool(name)` | Selects a tool from the tool library; returns `MillTool` |
| `IAlphaCamApp.CreateMillData()` | Creates a `MillData` parameter block |
| `MillData.MaterialTop` | Z height of the top of material |
| `MillData.FinalDepth` | Final Z depth of cut |
| `MillData.SafeRapidLevel` | Clearance plane Z height |
| `MillData.RapidDownTo` | Rapid feed Z position |
| `MillData.Stock` | Amount of material left after operation |
| `MillData.StepLength` | Step distance for 3D strategies |
| `MillData.ChordError` | Chord tolerance for arc approximation |
| `MillData.McComp` | Cutter compensation (`acamCompTOOLCEN`, etc.) |
| `MillData.RoughFinish()` | Generates roughing/finishing toolpaths; returns `Paths` |
| `MillData.Engrave()` | 3D engraving/drive-surface toolpath; returns `Paths` |
| `Drawing.Geometries` | All geometry objects in the drawing |
| `Path.Selected` | Set to `true` to include geometry in toolpath operation |
| `Paths.Item(i)` | Access individual toolpath (1-based index) |
| `Path.SetLeadInOutAuto(...)` | Add automatic lead-in/lead-out to a toolpath |
| `Marshal.ReleaseComObject(obj)` | **Always** release COM objects when done |

> **Feature API** (`Feature.chm`): Use this API to auto-recognize machinable features (pockets, bosses, holes) on the solid, extract their contours, and feed those selected geometries to the `MillData` operations above. See `docs/chm-files/Feature.md` for the full object model.

---

## Step-by-Step Roadmap

### Phase 1 — Validate the Concept (1–2 days)

1. Use the existing `DoorExampleAddin` as a reference. Build it and load it into Alphacam.
2. Manually select a solid face or surface in Alphacam, call `CreateMillData`, set parameters, and call `RoughFinish()` from the addin. Verify you get toolpaths without touching layers.
3. Confirm `MillData.Engrave()` works for your drive-surface strategy.

### Phase 2 — Design the Configuration Schema (1 day)

Define `machining_config.json`. Minimum fields per operation:

```json
{
  "operations": [
    {
      "name": "Roughing",
      "type": "RoughFinish",
      "tool": "C:\\Licomdat\\rtools.alp\\BallEnd-12mm.art",
      "safe_rapid": 50.0,
      "rapid_down_to": 5.0,
      "material_top": 0.0,
      "final_depth": -30.0,
      "stock": 0.5,
      "step_length": 2.0,
      "chord_error": 0.05,
      "compensation": "ToolCentre",
      "lead_in": true
    },
    {
      "name": "Finishing",
      "type": "Engrave",
      "tool": "C:\\Licomdat\\rtools.alp\\BallEnd-6mm.art",
      "safe_rapid": 50.0,
      "rapid_down_to": 5.0,
      "material_top": 0.0,
      "final_depth": -30.0,
      "step_length": 0.5,
      "chord_error": 0.01,
      "lead_in": true
    }
  ]
}
```

Extend with additional fields as your strategies become more complex (tolerances, axis limits, rest-machining reference tools, etc.).

### Phase 3 — Implement the C# Add-in (2–3 days)

See `csharp-addins/examples/SolidMachiningAddin.cs` for the working scaffold. Key implementation points:

- **Inject `IAlphaCamApp`** via the constructor so the class can be unit-tested with a mock.
- **Use `System.Text.Json`** (or `Newtonsoft.Json`) to deserialise the config file.
- **Geometry selection**: iterate `Drawing.Geometries` and set `Path.Selected = true` on the solid/surface geometries you want to machine. Alternatively use the Feature API to auto-select faces matching a criterion.
- **Tool selection**: call `SelectTool(toolPath)` before each operation and release the returned `MillTool` with `Marshal.ReleaseComObject`.
- **Always call `Marshal.ReleaseComObject`** on every COM object as soon as you're done with it. Failing to do so causes memory leaks and can crash Alphacam.

### Phase 4 — Python Prototype (optional, 1 day)

If you want to validate the strategy logic in Python before writing the full C# add-in:

```python
# python-scripts/solid_machining.py
import json
import sys
import win32com.client

COMP_MAP = {
    "ToolCentre": 0,   # acamCompTOOLCEN
    "Left":       1,   # acamCompLEFT
    "Right":      2,   # acamCompRIGHT
}

def apply_rough_finish(acam, drw, op):
    tool = acam.SelectTool(op["tool"])
    md   = acam.CreateMillData()
    md.SafeRapidLevel = op["safe_rapid"]
    md.RapidDownTo    = op["rapid_down_to"]
    md.MaterialTop    = op["material_top"]
    md.FinalDepth     = op["final_depth"]
    md.Stock          = op.get("stock", 0.0)
    md.StepLength     = op.get("step_length", 1.0)
    md.ChordError     = op.get("chord_error", 0.05)
    md.McComp         = COMP_MAP.get(op.get("compensation", "ToolCentre"), 0)
    paths = md.RoughFinish()
    # release COM objects immediately
    tool  = None
    md    = None
    return paths

def apply_engrave(acam, drw, op):
    tool = acam.SelectTool(op["tool"])
    md   = acam.CreateMillData()
    md.SafeRapidLevel       = op["safe_rapid"]
    md.RapidDownTo          = op["rapid_down_to"]
    md.MaterialTop          = op["material_top"]
    md.FinalDepth           = op["final_depth"]
    md.StepLength           = op.get("step_length", 0.5)
    md.ChordError           = op.get("chord_error", 0.01)
    md.EngraveType          = 0   # acamEngraveGEOMETRIES
    paths = md.Engrave()
    tool  = None
    md    = None
    return paths

STRATEGY_MAP = {
    "RoughFinish": apply_rough_finish,
    "Engrave":     apply_engrave,
}

def run(config_path):
    with open(config_path) as f:
        config = json.load(f)

    acam = win32com.client.GetActiveObject("AlphaCAMMill.Application")
    drw  = acam.ActiveDrawing

    # Select all solid/surface geometry (adapt selection criteria to your parts)
    geos = drw.Geometries
    for i in range(1, geos.Count + 1):
        geo = geos.Item(i)
        geo.Selected = True

    for op in config["operations"]:
        strategy_fn = STRATEGY_MAP.get(op["type"])
        if strategy_fn is None:
            print(f"Unknown operation type: {op['type']}", file=sys.stderr)
            continue
        print(f"Applying {op['name']} ({op['type']}) ...")
        paths = strategy_fn(acam, drw, op)
        print(f"  -> {paths.Count} toolpath(s) created")

if __name__ == "__main__":
    config_path = sys.argv[1] if len(sys.argv) > 1 else "machining_config.json"
    run(config_path)
```

### Phase 5 — Pre-Nesting Integration (1 day)

To run the add-in automatically before nesting:

1. Register the add-in to respond to the `AfterOpenFileEvent` event (acamapi event system).
2. On open, check whether a `machining_config.json` exists in the same folder as the part file (or a central config folder).
3. If found, execute the machining pipeline automatically, then save the drawing.
4. The nesting pipeline picks up the saved drawing with toolpaths already applied.

Alternatively, call the add-in as a **pre-nesting script** from a batch file / CI step:

```batch
:: run_machining.bat
alphacam_driver.exe --addin SolidMachiningAddin.dll --config machining_config.json --part MyPart.alp
```

### Phase 6 — Testing and Validation (ongoing)

- **Unit tests** (`csharp-addins/tests/SolidMachiningAddinTests.cs`): Mock `IAlphaCamApp` and verify config parsing and strategy dispatch logic without Alphacam installed.
- **Integration tests**: Load a known part, run the addin, verify toolpath count and depths in the saved drawing.
- **Regression**: Keep a library of reference parts and expected toolpath outputs. Run the addin against them after every config change.

---

## Relevant Examples in This Repository

| Path | What it shows |
|---|---|
| `alphacam-provided-examples/API/DotNetAddIns/DoorExampleAddin/` | Complete in-process .NET add-in with `CreateMillData`, `RoughFinish`, `Engrave`, and lead-in/lead-out |
| `alphacam-provided-examples/API/DotNetAddIns/DoorExampleAddin/MachiningRoutines.cs` | Reusable helper class for `CreateMillData` and 3D engrave |
| `alphacam-provided-examples/API/CSharp.Net/RunAcam (CSharp)/` | Out-of-process COM automation from a standalone C# application |
| `alphacam-provided-examples/API/AcamAddInsAPI/C#/AcamAddinsSampleCode.cs` | Menu integration, command items, event handling in a C# add-in |
| `csharp-addins/examples/SolidMachiningAddin.cs` | Scaffold for the configurable 3D machining add-in (this roadmap) |
| `csharp-addins/tests/SolidMachiningAddinTests.cs` | xUnit tests for the addin (no Alphacam required) |

---

## API Documentation Reference

All CHM files are in `docs/chm-files/`:

| File | Relevant to this feature |
|---|---|
| `acamapi.chm` | `IAlphaCamApp`, `Drawing`, `MillData`, `Path`, `Paths`, events |
| `Feature.chm` | Solid feature recognition, contour/face extraction, auto-alignment |
| `Primitives.chm` | `gVector`, `gPoint` for 3D geometry calculations |
| `Nesting.chm` | Integration point after machining is complete |

---

## Frequently Asked Questions

**Q: Can I use Python as an in-process add-in (like C#)?**  
A: No. Alphacam's add-in host only supports .NET assemblies. Python must drive Alphacam out-of-process via COM.

**Q: Can I use C++ as an in-process add-in?**  
A: Not via the standard add-in host (which is .NET-based). C++ is suitable for out-of-process COM automation or for writing a post-processor DLL via the `DotNetPosts` / `VisualCPP` patterns.

**Q: How do I select only the solid faces I want to machine without layers?**  
A: Use the Feature API (`Feature.chm`) to enumerate faces, check their normals, areas, or feature type, then call `Path.Selected = true` on only the faces that match your criteria.

**Q: Will this work for multi-axis (4-axis / 5-axis) toolpaths?**  
A: The same `MillData` object supports multi-axis strategies. Set the appropriate `MillData` properties for tilt axis, tool axis control, and collision avoidance. Consult the `acamapi.chm` `MillData` section for the full property list.

**Q: How do I make the config reloadable at runtime without restarting Alphacam?**  
A: Watch the config file for changes using `System.IO.FileSystemWatcher`. When a change is detected, reload the JSON and apply the new operation list to the current drawing.
