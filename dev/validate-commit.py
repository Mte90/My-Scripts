#!/usr/bin/env python
import re, sys, os

def main():
    # example:
    # feat(apikey): added the ability to add api key to configuration
    pattern = r'(build|ci|docs|feat|fix|perf|refactor|style|test|revert)(\([\w\-]+\))?:\s.*'
    commit = sys.argv[1]
    m = re.match(pattern, commit)
    if m == None:
        print('')
        print("Conventional commit validation failed")
        print("  Commit types: build|ci|docs|feat|fix|perf|refactor|style|test|revert")
        print("Example: feat(parser): add ability to parse arrays.")
        sys.exit()
    os.system('git commit -m "' + commit + '"')

if __name__ == "__main__":
    main()
