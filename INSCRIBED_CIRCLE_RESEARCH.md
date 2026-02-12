# Research Summary: Tool Selection Based on Largest Inscribed Circle

## Quick Answer

**No, this functionality does not exist in the Alphacam API library.**

The ability to query or filter geometry based on a largest inscribed circle heuristic (i.e., selecting the largest tool that fits inside arbitrary shaped features) is **not currently available** in Alphacam.

## What This Means

You will need to develop a **new add-in** to implement this functionality. This was confirmed after a comprehensive search of:
- All API documentation (6 CHM files, 585+ pages)
- All code examples (VBA, C#, Python, C++, Delphi)
- All existing add-ins and macros
- Feature recognition APIs
- Tool selection APIs
- Geometry analysis capabilities

## What Alphacam Currently Has

✅ **Existing tool selection capabilities:**
- Rule builders for circular features (matching diameters)
- Maximum finish radius filtering
- Basic programmatic tool selection via `SelectTool()` API
- Tool geometry extraction
- Feature recognition (holes, pockets, slots)

❌ **Missing (needs development):**
- Largest inscribed circle calculations
- Tool fitting algorithms for arbitrary geometry
- Query builders based on inscribed circle criteria

## Available Building Blocks

While the inscribed circle functionality doesn't exist, Alphacam provides APIs that can be used to **build** it:

1. **Feature API** - Extract contours, boundaries, and feature geometry
2. **acamapi** - Access tool database, geometry, and drawing operations
3. **Primitives API** - Basic geometric primitives (points, vectors)
4. **GetToolGeometry** - Extract tool dimensions and properties

## Recommended Next Steps

1. **Review the detailed research report**: See `docs/research/largest-inscribed-circle-research.md` for:
   - Complete analysis of available APIs
   - Gap analysis vs CAMworks functionality
   - Recommended implementation approach (4-phase plan)
   - Technical resources and code examples

2. **Choose an algorithm approach**:
   - Voronoi diagram-based
   - Medial axis transform
   - Iterative approximation

3. **Begin development**:
   - Start with Phase 1: Algorithm Development
   - Create proof-of-concept with simple shapes
   - Integrate with Alphacam APIs
   - Build UI components

## Full Report

For comprehensive details, see: **[docs/research/largest-inscribed-circle-research.md](docs/research/largest-inscribed-circle-research.md)**

The full report includes:
- Detailed API analysis (Feature API, acamapi, Primitives API)
- Comparison with CAMworks functionality
- Gap analysis and development requirements
- 4-phase implementation roadmap
- Code examples and technical resources
- Complete search methodology

---

**Date**: February 12, 2026  
**Report Author**: GitHub Copilot Agent  
**Status**: ✅ Research Complete - Ready for Development Planning
