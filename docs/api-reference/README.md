# API Reference

This directory contains or will contain extracted/converted API reference documentation from CHM files.

## CHM Documentation Available

Complete API documentation is provided in CHM format in the `../chm-files/` directory:

- **acamapi.chm** - Core Alphacam CAD/CAM API (194 pages)
- **Nesting.chm** - Sheet nesting and optimization (152 pages)
- **AEDITAPI.chm** - Editor automation (154 pages)
- **Feature.chm** - Feature extraction (58 pages)
- **Primitives.chm** - Utility library (15 pages)
- **ConstraintsAPI.chm** - Parametric constraints (12 pages)

See **[../chm-files/README.md](../chm-files/README.md)** for detailed documentation about each API.

## Extracted HTML Documentation

Once you extract CHM files using the tools in `tools/chm-reader/`, the HTML documentation will be available here for easy browsing without requiring CHM viewers.

## Recommended Structure

```
api-reference/
├── alphacam-api-v2024/
│   ├── index.html
│   ├── classes/
│   ├── methods/
│   └── properties/
├── alphacam-macros/
│   └── ...
└── README.md
```

## Extracting Documentation

Use the CHM reader tools to extract documentation:

```bash
# Extract to this directory
python tools/chm-reader/extract_chm.py docs/chm-files/api.chm --output docs/api-reference/alphacam-api

# Or convert to browsable HTML
python tools/chm-reader/chm_to_html.py docs/chm-files/api.chm --output docs/api-reference/alphacam-api
```
