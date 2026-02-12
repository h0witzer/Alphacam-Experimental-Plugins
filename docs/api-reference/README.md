# API Reference

This directory will contain extracted or converted API reference documentation from CHM files.

## Contents

Once you extract CHM files using the tools in `tools/chm-reader/`, the HTML documentation will be available here for easy browsing.

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
