#!/usr/bin/env python3
import sys

def find_non_ascii_lines(file_path):
    with open(file_path, "rb") as f:
        for line_number, line in enumerate(f, start=1):
            try:
                line.decode("ascii")
            except UnicodeDecodeError:
                print(f"Line {line_number}: contains non-ASCII characters")
                print(line.decode("utf-8", errors="replace").rstrip())
                print("-" * 80)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path_to_file>")
        sys.exit(1)

    find_non_ascii_lines(sys.argv[1])
