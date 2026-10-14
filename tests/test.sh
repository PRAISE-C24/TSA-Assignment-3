#!/usr/bin/env bash
set -u

PASS=0
FAIL=0
APP="./app/app.sh"

assert_exit_code() {
    local name="$1"
    local expected="$2"
    shift 2

    set +e
    "$@" >/dev/null 2>&1
    local rc=$?
    set -e

    if [ "$rc" -eq "$expected" ]; then
        echo "PASS: $name (Exit code $rc matches expected $expected)"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $name (Expected exit code $expected, got $rc)"
        FAIL=$((FAIL + 1))
    fi
}

echo "=========================================="
echo "          RUNNING UNIT TESTS              "
echo "=========================================="

# Test 1: Help command
assert_exit_code "1. Help command displays correctly" 0 "$APP" help

# Test 2: System-info command
assert_exit_code "2. System-info subcommand runs successfully" 0 "$APP" system-info

# Test 3: Invalid commands return exit code 2
assert_exit_code "3. Invalid command returns exit code 2" 2 "$APP" unknown-command

# Test 4: Missing host for check-host returns exit code 2
assert_exit_code "4. Missing host for check-host returns exit code 2" 2 "$APP" check-host

# Test 5: Valid host for check-host (localhost)
assert_exit_code "5. Valid host check executes successfully" 0 "$APP" check-host localhost

# Test 6: Missing port for check-port returns exit code 2
assert_exit_code "6. Missing port for check-port returns exit code 2" 2 "$APP" check-port localhost

# Test 7: Non-numeric port for check-port returns exit code 2
assert_exit_code "7. Non-numeric port returns exit code 2" 2 "$APP" check-port localhost abc

# Test 8: Out-of-range port for check-port returns exit code 2
assert_exit_code "8. Out-of-range port (70000) returns exit code 2" 2 "$APP" check-port localhost 70000

echo "=========================================="
echo "Tests Passed: $PASS"
echo "Tests Failed: $FAIL"
echo "=========================================="

[ "$FAIL" -eq 0 ]