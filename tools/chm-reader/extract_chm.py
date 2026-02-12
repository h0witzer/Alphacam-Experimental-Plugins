#!/usr/bin/env python3
"""
Extract contents from Compiled HTML Help (.chm) files.

This script extracts the contents of a .chm file to a specified output directory,
making the documentation accessible on platforms that don't have native CHM support.
"""

import argparse
import os
import sys


def extract_chm(chm_path, output_dir):
    """
    Extract CHM file contents to the specified output directory.
    
    Args:
        chm_path: Path to the .chm file
        output_dir: Directory where contents will be extracted
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
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Open CHM file
    chm_file = chm.CHMFile()
    if not chm_file.LoadCHM(chm_path):
        print(f"Error: Failed to load CHM file: {chm_path}")
        return False
    
    print(f"Extracting CHM file: {chm_path}")
    print(f"Output directory: {output_dir}")
    
    # Extract all files
    def extract_callback(chm_file, ui, context):
        """Callback function to extract each file"""
        if ui.path.endswith('/'):
            # Directory
            dir_path = os.path.join(output_dir, ui.path.lstrip('/'))
            os.makedirs(dir_path, exist_ok=True)
        else:
            # File
            file_path = os.path.join(output_dir, ui.path.lstrip('/'))
            file_dir = os.path.dirname(file_path)
            if file_dir:
                os.makedirs(file_dir, exist_ok=True)
            
            # Extract file content
            result, content = chm_file.RetrieveObject(ui.path)
            if result:
                with open(file_path, 'wb') as f:
                    f.write(content)
                print(f"  Extracted: {ui.path}")
        
        return chm.CHM_ENUMERATE_CONTINUE
    
    # Enumerate and extract all files
    chm_file.Enumerate(chm.CHM_ENUMERATE_ALL, extract_callback, None)
    
    print(f"\nExtraction complete! Files saved to: {output_dir}")
    
    # Try to find the index file
    index_candidates = ['index.html', 'index.htm', 'default.html', 'default.htm']
    for candidate in index_candidates:
        index_path = os.path.join(output_dir, candidate)
        if os.path.exists(index_path):
            print(f"Index file found: {candidate}")
            print(f"Open it in a browser: file://{os.path.abspath(index_path)}")
            break
    
    return True


def main():
    parser = argparse.ArgumentParser(
        description='Extract Compiled HTML Help (.chm) files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s api-docs.chm --output ./extracted
  %(prog)s path/to/docs.chm -o ./output
        """
    )
    
    parser.add_argument('chm_file', help='Path to the .chm file to extract')
    parser.add_argument('-o', '--output', default='./chm_extracted',
                        help='Output directory (default: ./chm_extracted)')
    
    args = parser.parse_args()
    
    success = extract_chm(args.chm_file, args.output)
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
