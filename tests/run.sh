#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

assert_eq() {
    local expected="$1"
    local actual="$2"
    local message="$3"
    if [[ "$expected" != "$actual" ]]; then
        fail "$message (expected='$expected', actual='$actual')"
    fi
}

assert_file_exists() {
    local path="$1"
    [[ -f "$path" ]] || fail "Expected file to exist: $path"
}

assert_file_missing() {
    local path="$1"
    [[ ! -e "$path" ]] || fail "Expected path to be missing: $path"
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="$3"
    if [[ "$haystack" != *"$needle"* ]]; then
        fail "$message (missing '$needle')"
    fi
}

write_ticket() {
    local dir="$1"
    local id="$2"
    local status="$3"
    local title="$4"
    local parent="${5:-}"
    local deps="${6:-}"
    local priority="${7:-2}"

    {
        echo "---"
        echo "id: $id"
        echo "status: $status"
        [[ -n "$parent" ]] && echo "parent: $parent"
        [[ -n "$deps" ]] && echo "deps: [$deps]"
        echo "priority: $priority"
        echo "---"
        echo "# $title"
        echo
    } > "$dir/${id}.md"
}

setup_archive_fixture() {
    local dir="$1"
    write_ticket "$dir" "go-root" "closed" "Root Closed"
    write_ticket "$dir" "go-child-a" "closed" "Child A" "go-root"
    write_ticket "$dir" "go-child-b" "closed" "Child B" "go-root"
    write_ticket "$dir" "go-open" "open" "Open Ticket"
}

test_archive_archives_all_eligible() {
    local tmp
    tmp="$(mktemp -d)"
    setup_archive_fixture "$tmp"

    local output
    output="$(TICKETS_DIR="$tmp" "$ROOT_DIR/tk-archive")"

    assert_contains "$output" "(3 tickets archived)" "archive summary should match"
    assert_file_exists "$tmp/archive/go-root.md"
    assert_file_exists "$tmp/archive/go-child-a.md"
    assert_file_exists "$tmp/archive/go-child-b.md"
    assert_file_exists "$tmp/go-open.md"
    assert_file_missing "$tmp/go-root.md"
    rm -rf "$tmp"
}

test_archive_dry_run_keeps_files() {
    local tmp
    tmp="$(mktemp -d)"
    setup_archive_fixture "$tmp"

    local output
    output="$(TICKETS_DIR="$tmp" "$ROOT_DIR/tk-archive" --dry-run)"

    assert_contains "$output" "(3 tickets would be archived)" "dry-run summary should match"
    assert_file_exists "$tmp/go-root.md"
    assert_file_exists "$tmp/go-child-a.md"
    assert_file_exists "$tmp/go-child-b.md"
    assert_file_missing "$tmp/archive"
    rm -rf "$tmp"
}

test_tree_smoke() {
    local tmp
    tmp="$(mktemp -d)"

    write_ticket "$tmp" "go-root" "open" "Root Open"
    write_ticket "$tmp" "go-child" "closed" "Child Closed" "go-root"

    local output
    output="$(TICKETS_DIR="$tmp" "$ROOT_DIR/tk-tree")"

    assert_contains "$output" "go-root [open] Root Open" "tree should print root"
    assert_contains "$output" "go-child [closed] Child Closed" "tree should print child"
    rm -rf "$tmp"
}

test_deps_mermaid_smoke() {
    local tmp
    tmp="$(mktemp -d)"

    write_ticket "$tmp" "go-a" "open" "Ticket A" "" "go-b"
    write_ticket "$tmp" "go-b" "closed" "Ticket B"

    local output
    output="$(TICKETS_DIR="$tmp" "$ROOT_DIR/tk-deps-mermaid")"

    assert_contains "$output" "graph TD" "mermaid should include graph header"
    assert_contains "$output" "[\"go-a [open] Ticket A\"]" "node labels should be quoted"
    assert_contains "$output" "-->" "mermaid should include dependency edge"
    rm -rf "$tmp"
}

run_test() {
    local name="$1"
    "$name"
    echo "PASS: $name"
}

run_test test_archive_archives_all_eligible
run_test test_archive_dry_run_keeps_files
run_test test_tree_smoke
run_test test_deps_mermaid_smoke

echo "All extension tests passed."
