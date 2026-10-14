#!/usr/bin/env bash
set -e

echo "=========================================="
echo "          RUNNING LINT CHECKS             "
echo "=========================================="

# Check that required files exist
REQUIRED_FILES=(
    "app/app.sh"
    "tests/test.sh"
    "scripts/build.sh"
    "Dockerfile"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$f" ]; then
        echo "Error: Required file '$f' is missing." >&2
        exit 1
    fi
    echo "  [OK] Found required file: $f"
done

# Run bash syntax validation (-n)
echo "------------------------------------------"
echo "Running Bash syntax checks..."
bash -n app/app.sh
bash -n tests/test.sh
bash -n scripts/build.sh
echo "  [OK] Syntax checks passed."

# Optional ShellCheck integration
if command -v shellcheck &>/dev/null; then
    echo "------------------------------------------"
    echo "Running ShellCheck..."
    shellcheck app/app.sh tests/test.sh scripts/build.sh
    echo "  [OK] ShellCheck passed."
else
    echo "------------------------------------------"
    echo "  [INFO] ShellCheck not installed, skipping static analysis."
fi

echo "=========================================="
echo "      ALL LINT CHECKS PASSED!             "
echo "=========================================="