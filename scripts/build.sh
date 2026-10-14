#!/usr/bin/env bash
set -e

IMAGE_NAME="devops-tool"

echo "=========================================="
echo "   BUILDING & SMOKE TESTING DOCKER IMAGE  "
echo "=========================================="

# 1. Build Docker image
echo "Building Docker image ($IMAGE_NAME)..."
docker build -t "$IMAGE_NAME" .
echo "  -> Build successful!"

# 2. Smoke Test: help
echo "Running smoke test: help..."
docker run --rm "$IMAGE_NAME" help >/dev/null
echo "  -> Help smoke test passed."

# 3. Smoke Test: system-info
echo "Running smoke test: system-info..."
docker run --rm "$IMAGE_NAME" system-info >/dev/null
echo "  -> System-info smoke test passed."

# 4. Smoke Test: invalid-command (expects exit code 2)
echo "Running smoke test: invalid-command..."
set +e
docker run --rm "$IMAGE_NAME" invalid-subcommand >/dev/null 2>&1
RC=$?
set -e

if [ "$RC" -eq 2 ]; then
    echo "  -> Invalid-command smoke test passed (Exit code 2)."
else
    echo "  -> Invalid-command smoke test failed (Expected exit code 2, got $RC)."
    exit 1
fi

echo "=========================================="
echo "   ALL DOCKER SMOKE TESTS PASSED!         "
echo "=========================================="