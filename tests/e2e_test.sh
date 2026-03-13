#!/usr/bin/env bash
# End-to-end integration test for the weekplanner stack.
# Requires giraf-deploy stack running (docker compose up).
#
# Usage: ./tests/e2e_test.sh [CORE_URL] [WEEKPLANNER_URL]

set -euo pipefail

CORE="${1:-http://localhost:8000}"
WP="${2:-http://localhost:5171}"
PASS=0
FAIL=0

# ── helpers ───────────────────────────────────────────────

assert_status() {
  local label="$1" expected="$2" actual="$3"
  if [[ "$actual" == "$expected" ]]; then
    echo "  PASS  $label (HTTP $actual)"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (expected $expected, got $actual)"
    FAIL=$((FAIL + 1))
  fi
}

assert_json_field() {
  local label="$1" json="$2" field="$3"
  if echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); assert '$field' in d" 2>/dev/null; then
    echo "  PASS  $label (field '$field' present)"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (field '$field' missing)"
    FAIL=$((FAIL + 1))
  fi
}

# ── setup: register + login ──────────────────────────────

echo "=== Setup ==="

# Register (ignore conflict if user already exists)
curl -sf -X POST "$CORE/api/v1/auth/register" \
  -H 'Content-Type: application/json' \
  -d '{"username":"e2euser","password":"E2eTestPass99","email":"e2e@test.com","first_name":"E2E","last_name":"Test"}' \
  > /dev/null 2>&1 || true

# Login
LOGIN=$(curl -sf -X POST "$CORE/api/v1/token/pair" \
  -H 'Content-Type: application/json' \
  -d '{"username":"e2euser","password":"E2eTestPass99"}')
ACCESS=$(echo "$LOGIN" | python3 -c "import sys,json; print(json.load(sys.stdin)['access'])")
AUTH="Authorization: Bearer $ACCESS"

# Verify JWT has user_id and org_roles
JWT_PAYLOAD=$(echo "$ACCESS" | cut -d. -f2 | base64 -d 2>/dev/null || true)
assert_json_field "JWT contains user_id" "$JWT_PAYLOAD" "user_id"
assert_json_field "JWT contains org_roles" "$JWT_PAYLOAD" "org_roles"

# ── giraf-core: org, citizen, grade ──────────────────────

echo ""
echo "=== giraf-core: shared domain ==="

# Create org
ORG=$(curl -sf -X POST "$CORE/api/v1/organizations" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"name":"E2E School"}')
ORG_ID=$(echo "$ORG" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
assert_json_field "Create org" "$ORG" "id"

# Re-login for updated org_roles
ACCESS=$(curl -sf -X POST "$CORE/api/v1/token/pair" \
  -H 'Content-Type: application/json' \
  -d '{"username":"e2euser","password":"E2eTestPass99"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['access'])")
AUTH="Authorization: Bearer $ACCESS"

# Create citizen
CITIZEN=$(curl -sf -X POST "$CORE/api/v1/organizations/$ORG_ID/citizens" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"first_name":"Test","last_name":"Child"}')
CIT_ID=$(echo "$CITIZEN" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
assert_json_field "Create citizen" "$CITIZEN" "id"

# Create grade
GRADE=$(curl -sf -X POST "$CORE/api/v1/organizations/$ORG_ID/grades" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"name":"E2E Grade"}')
GRADE_ID=$(echo "$GRADE" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
assert_json_field "Create grade" "$GRADE" "id"

# List members (verify email field)
MEMBERS=$(curl -sf "$CORE/api/v1/organizations/$ORG_ID/members?limit=10" -H "$AUTH")
assert_json_field "Members have email" "$(echo "$MEMBERS" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin)['items'][0]))")" "email"
assert_json_field "Members have membership_id" "$(echo "$MEMBERS" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin)['items'][0]))")" "membership_id"

# ── weekplanner-api: activities ──────────────────────────

echo ""
echo "=== weekplanner-api: activities ==="

# Create activity for citizen
ACT=$(curl -sf -X POST "$WP/weekplan/to-citizen/$CIT_ID" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"date":"2026-06-01","startTime":"09:00:00","endTime":"10:00:00","pictogramId":null}')
ACT_ID=$(echo "$ACT" | python3 -c "import sys,json; print(json.load(sys.stdin)['activityId'])")
assert_json_field "Create citizen activity" "$ACT" "activityId"

# Create activity for grade
GACT=$(curl -sf -X POST "$WP/weekplan/to-grade/$GRADE_ID" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"date":"2026-06-01","startTime":"11:00:00","endTime":"12:00:00","pictogramId":null}')
assert_json_field "Create grade activity" "$GACT" "activityId"

# Read citizen activities
CACTS=$(curl -sf "$WP/weekplan/$CIT_ID?date=2026-06-01" -H "$AUTH")
echo "$CACTS" | python3 -c "import sys,json; d=json.load(sys.stdin); assert len(d)>=1" 2>/dev/null \
  && { echo "  PASS  List citizen activities (got results)"; ((PASS++)); } \
  || { echo "  FAIL  List citizen activities (empty)"; ((FAIL++)); }

# Read grade activities
GACTS=$(curl -sf "$WP/weekplan/grade/$GRADE_ID?date=2026-06-01" -H "$AUTH")
echo "$GACTS" | python3 -c "import sys,json; d=json.load(sys.stdin); assert len(d)>=1" 2>/dev/null \
  && { echo "  PASS  List grade activities (got results)"; ((PASS++)); } \
  || { echo "  FAIL  List grade activities (empty)"; ((FAIL++)); }

# Read single activity
SINGLE=$(curl -sf "$WP/weekplan/activity/$ACT_ID" -H "$AUTH")
assert_json_field "Get activity by ID" "$SINGLE" "activityId"

# Toggle complete
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X PUT "$WP/weekplan/activity/$ACT_ID/iscomplete?IsComplete=true" -H "$AUTH")
assert_status "Toggle activity complete" "200" "$STATUS"

# Update activity
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X PUT "$WP/weekplan/activity/$ACT_ID" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"date":"2026-06-01","startTime":"09:30:00","endTime":"10:30:00"}')
assert_status "Update activity" "200" "$STATUS"

# ── validation: weekplanner → giraf-core ─────────────────

echo ""
echo "=== Validation chain ==="

# Invalid citizen → 404
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST "$WP/weekplan/to-citizen/99999" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"date":"2026-06-01","startTime":"09:00:00","endTime":"10:00:00","pictogramId":null}')
assert_status "Invalid citizen rejected" "404" "$STATUS"

# Invalid grade → 404
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST "$WP/weekplan/to-grade/99999" \
  -H 'Content-Type: application/json' -H "$AUTH" \
  -d '{"date":"2026-06-01","startTime":"09:00:00","endTime":"10:00:00","pictogramId":null}')
assert_status "Invalid grade rejected" "404" "$STATUS"

# Delete activity
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X DELETE "$WP/weekplan/activity/$ACT_ID" -H "$AUTH")
assert_status "Delete activity" "204" "$STATUS"

# Verify deleted
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  "$WP/weekplan/activity/$ACT_ID" -H "$AUTH")
assert_status "Deleted activity returns 404" "404" "$STATUS"

# ── cleanup ──────────────────────────────────────────────

echo ""
echo "=== Cleanup ==="
curl -sf -X DELETE "$CORE/api/v1/organizations/$ORG_ID" -H "$AUTH" > /dev/null
echo "  Deleted test org $ORG_ID"

# ── summary ──────────────────────────────────────────────

echo ""
echo "=============================="
echo "  $PASS passed, $FAIL failed"
echo "=============================="

[[ $FAIL -eq 0 ]] || exit 1
