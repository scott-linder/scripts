#/bin/bash

# Normalize File Names
# Converts upper to lower case and spaces to underlines.
# Does not recurse or follow symlinks.

set -e

for f in *; do
    n=$(echo "$f" | tr '[:upper:] ' '[:lower:]_')
    [[ $f == $n ]] || mv "$f" "$n"
done

