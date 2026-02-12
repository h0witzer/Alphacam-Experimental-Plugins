#!/usr/bin/env python3
"""
Convert Compiled HTML Help (.chm) files to browsable HTML format.

This script converts a .chm file to a clean, browsable HTML structure with
an index page and navigation.
"""

import argparse
import os
import sys
import re


def convert_chm_to_html(chm_path, output_dir):
    """
    Convert CHM file to browsable HTML format.
    
    Args:
        chm_path: Path to the .chm file
        output_dir: Directory where HTML will be generated
    """
    try:
        from chm import chm
    except ImportError:
        print("Error: pychm library not installed.")
        print("Install it with: pip install pychm")
        return False
    
    if not os.path.exists(chm_path):
        print(f"Error: CHM file not found: {chm_path}")
        return False
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Open CHM file
    chm_file = chm.CHMFile()
    if not chm_file.LoadCHM(chm_path):
        print(f"Error: Failed to load CHM file: {chm_path}")
        return False
    
    print(f"Converting CHM file: {chm_path}")
    print(f"Output directory: {output_dir}")
    
    html_files = []
    
    # Extract all HTML files
    def extract_html_callback(chm_file, ui, context):
        """Callback function to extract HTML files"""
        if ui.path.endswith(('.html', '.htm')):
            file_path = os.path.join(output_dir, ui.path.lstrip('/'))
            file_dir = os.path.dirname(file_path)
            if file_dir:
                os.makedirs(file_dir, exist_ok=True)
            
            # Extract file content
            result, content = chm_file.RetrieveObject(ui.path)
            if result:
                with open(file_path, 'wb') as f:
                    f.write(content)
                html_files.append(ui.path.lstrip('/'))
                print(f"  Converted: {ui.path}")
        
        return chm.CHM_ENUMERATE_CONTINUE
    
    # Enumerate and extract HTML files
    chm_file.Enumerate(chm.CHM_ENUMERATE_FILES, extract_html_callback, None)
    
    # Create an index page
    create_index_page(output_dir, html_files, os.path.basename(chm_path))
    
    print(f"\nConversion complete! Files saved to: {output_dir}")
    print(f"Open index.html in a browser: file://{os.path.abspath(os.path.join(output_dir, 'index.html'))}")
    
    return True


def create_index_page(output_dir, html_files, chm_name):
    """Create an index page linking to all HTML files"""
    index_html = """<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{title}</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }}
        h1 {{
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }}
        .file-list {{
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .file-list ul {{
            list-style-type: none;
            padding: 0;
        }}
        .file-list li {{
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }}
        .file-list li:last-child {{
            border-bottom: none;
        }}
        .file-list a {{
            color: #007bff;
            text-decoration: none;
        }}
        .file-list a:hover {{
            text-decoration: underline;
        }}
        .info {{
            background-color: #e7f3ff;
            padding: 15px;
            border-left: 4px solid #007bff;
            margin: 20px 0;
        }}
    </style>
</head>
<body>
    <h1>{title}</h1>
    <div class="info">
        <p><strong>Source:</strong> {chm_name}</p>
        <p><strong>Total Files:</strong> {count}</p>
    </div>
    <div class="file-list">
        <h2>Documentation Files</h2>
        <ul>
{file_links}
        </ul>
    </div>
</body>
</html>
"""
    
    # Sort files alphabetically
    html_files.sort()
    
    # Create links for each file
    file_links = []
    for file in html_files:
        # Create a nice display name
        display_name = os.path.basename(file)
        file_links.append(f'            <li><a href="{file}">{display_name}</a> - {file}</li>')
    
    # Fill in the template
    html_content = index_html.format(
        title=f"Documentation: {chm_name}",
        chm_name=chm_name,
        count=len(html_files),
        file_links='\n'.join(file_links)
    )
    
    # Write index file
    index_path = os.path.join(output_dir, 'index.html')
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(html_content)


def main():
    parser = argparse.ArgumentParser(
        description='Convert Compiled HTML Help (.chm) files to browsable HTML',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s api-docs.chm --output ./html
  %(prog)s path/to/docs.chm -o ./output
        """
    )
    
    parser.add_argument('chm_file', help='Path to the .chm file to convert')
    parser.add_argument('-o', '--output', default='./chm_html',
                        help='Output directory (default: ./chm_html)')
    
    args = parser.parse_args()
    
    success = convert_chm_to_html(args.chm_file, args.output)
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
