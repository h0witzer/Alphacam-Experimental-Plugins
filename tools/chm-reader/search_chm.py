#!/usr/bin/env python3
"""
Search through Compiled HTML Help (.chm) documentation files.

This script allows you to search for terms within CHM files, making it easy
to find relevant API documentation and examples.
"""

import argparse
import os
import sys
import re
from html.parser import HTMLParser


class HTMLTextExtractor(HTMLParser):
    """Extract text content from HTML"""
    
    def __init__(self):
        super().__init__()
        self.text = []
    
    def handle_data(self, data):
        self.text.append(data)
    
    def get_text(self):
        return ' '.join(self.text)


def search_chm(chm_path, query, case_sensitive=False, context_lines=2):
    """
    Search for a query string in CHM file.
    
    Args:
        chm_path: Path to the .chm file
        query: Search query string
        case_sensitive: Whether to perform case-sensitive search
        context_lines: Number of context lines to show around matches
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
    
    # Open CHM file
    chm_file = chm.CHMFile()
    if not chm_file.LoadCHM(chm_path):
        print(f"Error: Failed to load CHM file: {chm_path}")
        return False
    
    print(f"Searching in: {chm_path}")
    print(f"Query: '{query}'")
    print(f"Case sensitive: {case_sensitive}")
    print("-" * 80)
    
    matches = []
    
    # Search through all HTML files
    def search_callback(chm_file, ui, context):
        """Callback function to search in each file"""
        if ui.path.endswith(('.html', '.htm')):
            # Extract file content
            result, content = chm_file.RetrieveObject(ui.path)
            if result:
                try:
                    # Decode content
                    text_content = content.decode('utf-8', errors='ignore')
                    
                    # Extract text from HTML
                    extractor = HTMLTextExtractor()
                    extractor.feed(text_content)
                    plain_text = extractor.get_text()
                    
                    # Search for query
                    search_text = plain_text if case_sensitive else plain_text.lower()
                    search_query = query if case_sensitive else query.lower()
                    
                    if search_query in search_text:
                        # Count occurrences
                        count = search_text.count(search_query)
                        matches.append((ui.path, count, plain_text))
                        
                except Exception as e:
                    pass  # Skip files that can't be parsed
        
        return chm.CHM_ENUMERATE_CONTINUE
    
    # Enumerate and search all files
    chm_file.Enumerate(chm.CHM_ENUMERATE_FILES, search_callback, None)
    
    # Display results
    if not matches:
        print(f"\nNo matches found for '{query}'")
        return True
    
    print(f"\nFound {len(matches)} file(s) with matches:\n")
    
    for file_path, count, content in matches:
        print(f"File: {file_path}")
        print(f"Matches: {count}")
        
        # Show context around matches
        if case_sensitive:
            pattern = re.escape(query)
        else:
            pattern = re.escape(query)
            content_lower = content.lower()
            query_lower = query.lower()
        
        # Find and display context
        lines = content.split('\n')
        for i, line in enumerate(lines):
            search_line = line if case_sensitive else line.lower()
            search_query = query if case_sensitive else query.lower()
            
            if search_query in search_line:
                # Show context
                start = max(0, i - context_lines)
                end = min(len(lines), i + context_lines + 1)
                
                print("  Context:")
                for j in range(start, end):
                    prefix = "  >>> " if j == i else "      "
                    print(f"{prefix}{lines[j].strip()}")
                print()
        
        print("-" * 80)
    
    print(f"\nSearch complete! Found {sum(count for _, count, _ in matches)} total match(es) in {len(matches)} file(s)")
    
    return True


def main():
    parser = argparse.ArgumentParser(
        description='Search through Compiled HTML Help (.chm) documentation files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s api-docs.chm --query "DrawLine"
  %(prog)s docs.chm -q "function" --case-sensitive
  %(prog)s api.chm -q "Initialize" -c 5
        """
    )
    
    parser.add_argument('chm_file', help='Path to the .chm file to search')
    parser.add_argument('-q', '--query', required=True,
                        help='Search query string')
    parser.add_argument('--case-sensitive', action='store_true',
                        help='Perform case-sensitive search')
    parser.add_argument('-c', '--context', type=int, default=2,
                        help='Number of context lines to show (default: 2)')
    
    args = parser.parse_args()
    
    success = search_chm(args.chm_file, args.query, args.case_sensitive, args.context)
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
