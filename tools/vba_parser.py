#!/usr/bin/env python3
"""
VBA Parser for Alphacam Files

This tool parses .bas (plain text VBA) and .arb (OLE compound VBA project) files
to extract and analyze VBA macro code structure.

Supports:
- .bas files: Plain text VBA Basic modules
- .arb files: OLE compound documents containing VBA projects
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import json


class VBABasParser:
    """Parser for plain text .bas VBA Basic module files"""
    
    def __init__(self, file_path: str):
        self.file_path = file_path
        self.content = ""
        self.module_name = ""
        self.option_statements = []
        self.subs = []
        self.functions = []
        self.variables = []
        self.api_calls = []
        
    def parse(self) -> Dict:
        """Parse the .bas file and extract all components"""
        try:
            with open(self.file_path, 'r', encoding='utf-8', errors='ignore') as f:
                self.content = f.read()
        except Exception as e:
            return {"error": f"Failed to read file: {str(e)}"}
        
        self._extract_module_name()
        self._extract_option_statements()
        self._extract_subs()
        self._extract_functions()
        self._extract_variables()
        self._extract_api_calls()
        
        return self._build_result()
    
    def _extract_module_name(self):
        """Extract module name from VB_Name attribute"""
        match = re.search(r'Attribute\s+VB_Name\s*=\s*"([^"]+)"', self.content)
        if match:
            self.module_name = match.group(1)
    
    def _extract_option_statements(self):
        """Extract Option statements (Option Explicit, etc.)"""
        matches = re.finditer(r'^\s*Option\s+(\w+)', self.content, re.MULTILINE)
        self.option_statements = [match.group(1) for match in matches]
    
    def _extract_subs(self):
        """Extract all Sub procedures"""
        # Match Sub declarations with their content
        pattern = r'(Public|Private|Friend)?\s*Sub\s+(\w+)\s*\((.*?)\)(.*?)End\s+Sub'
        matches = re.finditer(pattern, self.content, re.DOTALL | re.IGNORECASE)
        
        for match in matches:
            visibility = match.group(1) or "Public"
            name = match.group(2)
            params = match.group(3).strip()
            body = match.group(4).strip()
            
            # Count lines in body
            lines = len([l for l in body.split('\n') if l.strip() and not l.strip().startswith("'")])
            
            self.subs.append({
                "name": name,
                "visibility": visibility,
                "parameters": params if params else "none",
                "line_count": lines
            })
    
    def _extract_functions(self):
        """Extract all Function procedures"""
        pattern = r'(Public|Private|Friend)?\s*Function\s+(\w+)\s*\((.*?)\)\s*As\s+(\w+)(.*?)End\s+Function'
        matches = re.finditer(pattern, self.content, re.DOTALL | re.IGNORECASE)
        
        for match in matches:
            visibility = match.group(1) or "Public"
            name = match.group(2)
            params = match.group(3).strip()
            return_type = match.group(4)
            body = match.group(5).strip()
            
            lines = len([l for l in body.split('\n') if l.strip() and not l.strip().startswith("'")])
            
            self.functions.append({
                "name": name,
                "visibility": visibility,
                "parameters": params if params else "none",
                "return_type": return_type,
                "line_count": lines
            })
    
    def _extract_variables(self):
        """Extract variable declarations"""
        # Public, Private, and Dim declarations at module level
        patterns = [
            r'^\s*(Public|Private|Dim)\s+(\w+)\s+As\s+(\w+)',
            r'^\s*Const\s+(\w+)\s+As\s+(\w+)\s*=',
        ]
        
        for pattern in patterns:
            matches = re.finditer(pattern, self.content, re.MULTILINE)
            for match in matches:
                if len(match.groups()) == 3:
                    scope, name, var_type = match.groups()
                    self.variables.append({
                        "name": name,
                        "type": var_type,
                        "scope": scope
                    })
    
    def _extract_api_calls(self):
        """Extract Alphacam API object usage"""
        # Common Alphacam API patterns
        api_patterns = {
            'App': r'\bApp\.',
            'Drawing': r'\bDrawing\b',
            'ActiveDrawing': r'\bActiveDrawing\b',
            'Path': r'\bPath\b',
            'Geo2D': r'\bGeo2D\b',
            'PolyLine': r'\bPolyLine\b',
            'Element': r'\bElement\b',
            'MillData': r'\bMillData\b',
            'MillTool': r'\bMillTool\b',
            'WorkPlane': r'\bWorkPlane\b',
            'Layer': r'\blayer\b',
            'Frame': r'\bFrame\.',
        }
        
        api_usage = {}
        for api_name, pattern in api_patterns.items():
            matches = re.findall(pattern, self.content)
            if matches:
                api_usage[api_name] = len(matches)
        
        self.api_calls = api_usage
    
    def _build_result(self) -> Dict:
        """Build the parsing result dictionary"""
        return {
            "file_path": self.file_path,
            "file_name": os.path.basename(self.file_path),
            "module_name": self.module_name,
            "option_statements": self.option_statements,
            "total_subs": len(self.subs),
            "total_functions": len(self.functions),
            "total_variables": len(self.variables),
            "subs": self.subs,
            "functions": self.functions,
            "variables": self.variables,
            "api_calls": self.api_calls,
            "total_lines": len(self.content.split('\n'))
        }


class VBAArbParser:
    """Parser for .arb OLE compound document VBA project files"""
    
    def __init__(self, file_path: str):
        self.file_path = file_path
        self.content = b""
        self.text_content = ""
        self.modules = []
        self.references = []
        
    def parse(self) -> Dict:
        """Parse the .arb file and extract VBA components"""
        try:
            with open(self.file_path, 'rb') as f:
                self.content = f.read()
        except Exception as e:
            return {"error": f"Failed to read file: {str(e)}"}
        
        # Convert to text for pattern matching (with error handling)
        self.text_content = self.content.decode('latin-1', errors='ignore')
        
        self._extract_modules()
        self._extract_references()
        self._extract_vba_code()
        
        return self._build_result()
    
    def _extract_modules(self):
        """Extract module names from the VBA project"""
        # Look for Module= patterns in the project data
        matches = re.finditer(r'Module=(\w+)', self.text_content)
        self.modules = [match.group(1) for match in matches]
    
    def _extract_references(self):
        """Extract external library references"""
        # Look for GUID references to external libraries
        patterns = [
            r'\{([0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12})\}',
            r'#([\w\s.]+)#',
        ]
        
        refs = set()
        for pattern in patterns:
            matches = re.finditer(pattern, self.text_content)
            refs.update([match.group(1) for match in matches])
        
        self.references = list(refs)
    
    def _extract_vba_code(self):
        """Extract actual VBA code from the compound document"""
        # Look for common VBA keywords to identify code sections
        vba_keywords = [
            'Attribute VB_Name',
            'Option Explicit',
            'Public Sub',
            'Private Sub',
            'Public Function',
            'Private Function',
            'Dim ',
            'Set ',
        ]
        
        # Find sections that contain multiple VBA keywords
        code_sections = []
        lines = self.text_content.split('\n')
        
        current_section = []
        in_code_section = False
        
        for line in lines:
            # Check if line contains VBA keywords
            if any(keyword in line for keyword in vba_keywords):
                in_code_section = True
                current_section.append(line)
            elif in_code_section:
                # Continue collecting if we're in a code section
                if line.strip() and not all(ord(c) < 32 or ord(c) > 126 for c in line if c):
                    current_section.append(line)
                else:
                    # End of code section
                    if len(current_section) > 5:  # Only save substantial sections
                        code_sections.append('\n'.join(current_section))
                    current_section = []
                    in_code_section = False
        
        # Parse any found code sections
        self.code_sections = code_sections
    
    def _build_result(self) -> Dict:
        """Build the parsing result dictionary"""
        return {
            "file_path": self.file_path,
            "file_name": os.path.basename(self.file_path),
            "file_type": "VBA OLE Compound Document (.arb)",
            "file_size": len(self.content),
            "modules": self.modules,
            "module_count": len(self.modules),
            "references": self.references[:10],  # Limit to first 10
            "reference_count": len(self.references),
            "has_vba_code": len(self.modules) > 0,
            "code_sections_found": len(getattr(self, 'code_sections', []))
        }


def parse_file(file_path: str) -> Dict:
    """Parse a VBA file (either .bas or .arb)"""
    ext = os.path.splitext(file_path)[1].lower()
    
    if ext == '.bas':
        parser = VBABasParser(file_path)
    elif ext == '.arb':
        parser = VBAArbParser(file_path)
    else:
        return {"error": f"Unsupported file type: {ext}"}
    
    return parser.parse()


def find_vba_files(root_dir: str) -> List[str]:
    """Find all .bas and .arb files in the directory tree"""
    vba_files = []
    for ext in ['.bas', '.arb']:
        vba_files.extend(Path(root_dir).rglob(f'*{ext}'))
    return sorted([str(f) for f in vba_files])


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: python vba_parser.py <file_or_directory>")
        print("       python vba_parser.py --all  (parse all VBA files in repo)")
        sys.exit(1)
    
    arg = sys.argv[1]
    
    if arg == '--all':
        # Parse all VBA files in the repository
        repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        files = find_vba_files(repo_root)
        results = []
        
        print(f"Found {len(files)} VBA files to parse...")
        print()
        
        for file_path in files:
            print(f"Parsing: {file_path}")
            result = parse_file(file_path)
            results.append(result)
        
        # Print summary
        print("\n" + "="*80)
        print("PARSING SUMMARY")
        print("="*80)
        
        bas_files = [r for r in results if r.get('file_name', '').endswith('.bas')]
        arb_files = [r for r in results if r.get('file_name', '').endswith('.arb')]
        
        print(f"\nTotal files parsed: {len(results)}")
        print(f"  .bas files: {len(bas_files)}")
        print(f"  .arb files: {len(arb_files)}")
        
        if bas_files:
            total_subs = sum(r.get('total_subs', 0) for r in bas_files)
            total_functions = sum(r.get('total_functions', 0) for r in bas_files)
            print(f"\n.bas File Statistics:")
            print(f"  Total Subs: {total_subs}")
            print(f"  Total Functions: {total_functions}")
            print(f"  Total Procedures: {total_subs + total_functions}")
        
        if arb_files:
            total_modules = sum(r.get('module_count', 0) for r in arb_files)
            print(f"\n.arb File Statistics:")
            print(f"  Total Modules: {total_modules}")
        
        # Save detailed results to JSON
        output_file = os.path.join(repo_root, 'tools', 'vba_parsing_results.json')
        with open(output_file, 'w') as f:
            json.dump(results, f, indent=2)
        print(f"\nDetailed results saved to: {output_file}")
        
    else:
        # Parse single file or directory
        if os.path.isfile(arg):
            result = parse_file(arg)
            print(json.dumps(result, indent=2))
        elif os.path.isdir(arg):
            files = find_vba_files(arg)
            print(f"Found {len(files)} VBA files in {arg}")
            for file_path in files:
                result = parse_file(file_path)
                print(json.dumps(result, indent=2))
        else:
            print(f"Error: {arg} is not a valid file or directory")
            sys.exit(1)


if __name__ == '__main__':
    main()
