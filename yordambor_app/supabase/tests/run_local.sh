#!/usr/bin/env bash
# Runs every migration on a throwaway local PostgreSQL, then the checks and
# the behaviour tests. Needs PostgreSQL 15+ (psql, initdb, pg_ctl) and is
# run as a user PostgreSQL accepts (not root):
#
#   supabase/tests/run_local.sh
#
# Supabase's own schemas (auth, storage) and roles come from
# supabase_stub.sql, enough for these migrations; nothing touches a real
# project.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
bin="$(dirname "$(command -v pg_ctl || ls /usr/lib/postgresql/*/bin/pg_ctl | tail -1)")"
data="$(mktemp -d)"
port=54329

"$bin/initdb" -D "$data" -A trust -U postgres >/dev/null
"$bin/pg_ctl" -D "$data" -o "-p $port -k $data -c listen_addresses=" \
  -l "$data/log" start >/dev/null
trap '"$bin/pg_ctl" -D "$data" stop -m fast >/dev/null; rm -rf "$data"' EXIT

psql=(psql -h "$data" -p "$port" -U postgres -v ON_ERROR_STOP=1 -q)
"${psql[@]}" -d postgres -c 'create database yb' >/dev/null
"${psql[@]}" -d yb -f "$here/supabase_stub.sql" >/dev/null 2>&1

for file in "$root"/migrations/0*.sql; do
  "${psql[@]}" -d yb -f "$file" >/dev/null 2>"$data/err" || {
    echo "FAILED: $(basename "$file")"; cat "$data/err"; exit 1; }
done
echo "Migrations applied."

# The newest migration must be safe to run twice.
latest="$(ls "$root"/migrations/0*.sql | tail -1)"
"${psql[@]}" -d yb -f "$latest" >/dev/null 2>&1
echo "$(basename "$latest") runs twice."

for check in "$root"/checks/0*_check.sql; do
  problems="$("${psql[@]}" -d yb -At -f "$check" | grep -c PROBLEM || true)"
  echo "$(basename "$check"): $problems problem(s)"
  [ "$problems" -eq 0 ] || exit 1
done

for test in "$here"/0*_behaviour.sql; do
  echo "== $(basename "$test")"
  "${psql[@]}" -d yb -f "$test"
done
