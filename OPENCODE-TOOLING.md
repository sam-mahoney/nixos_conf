# OpenCode Tooling Plan and Workflow

This document defines a single-PR implementation plan for advanced coding tools around OpenCode, why each tool matters, and the day-to-day workflow that uses them.

## Goals

- Improve code understanding speed in large repos.
- Increase edit safety by reducing broad text-based changes.
- Shorten debug/verify loops after edits.
- Keep behavior predictable with clear fallbacks.

## Scope

Primary scope for one-shot implementation:

1. AST query tool (Tree-sitter based)
2. Symbol index tool (definitions/references/workspace symbols)
3. Diagnostics aggregator (LSP + build + test)
4. Test impact mapper (nearest + affected tests)
5. Code action bridge (feature-flagged, opt-in by default)

## Why These Tools Matter

### AST Query

- Finds semantic structures (functions, classes, call sites) without brittle regex.
- Enables precise targeting for edits and audits.
- Reduces false matches in large mixed-language repos.

### Symbol Index

- Speeds navigation across files and modules.
- Supports fast definition/reference lookups from cached graph data.
- Improves architectural understanding before making changes.

### Diagnostics Aggregator

- Presents one merged view of current issues.
- Prioritizes highest-value fixes first (severity + proximity).
- Removes duplicate errors reported by multiple systems.

### Test Impact Mapper

- Runs fewer tests while keeping confidence high.
- Maps changed files to nearest or likely affected tests.
- Makes iterative development much faster.

### Code Action Bridge (Opt-in)

- Exposes LSP quick-fixes and import actions through tools.
- Adds automation while preserving safety with feature flags.
- Can be rolled out gradually to avoid surprising edits.

## Single-PR Architecture

### Shared Contracts

All tools should return a consistent envelope:

- `ok`: boolean success status
- `tool`: tool name
- `summary`: short human-readable result
- `data`: machine-usable payload
- `errors`: normalized error list
- `timing_ms`: execution timing
- `degraded`: whether fallback path was used

### Capability Detection

- Detect available backends at startup (LSP servers, parsers, test runners).
- Mark unavailable capabilities clearly in responses.
- Never hard-fail when one backend is missing.

### Fallback Strategy

- Prefer semantic tool path first.
- Fall back to reduced-capability mode with explicit warning.
- Preserve deterministic response structure across all paths.

## Testing Strategy

### Unit Coverage

- Query parsing and AST match extraction.
- Symbol graph insert/update/lookup logic.
- Diagnostics deduplication and sort rules.
- Test impact mapping heuristics.

### Integration Fixtures

Use fixture projects for:

- TypeScript/JavaScript
- Python
- Go
- C/C++

Each fixture should validate expected outputs for:

- symbol definitions/references
- AST capture matches
- diagnostic merge behavior
- test impact mapping

### Reliability Cases

- Missing language server
- Invalid parser grammar
- Timeout and cancellation
- Partial cache corruption
- Large workspace behavior

### Performance Gates (Practical Default)

- AST query typical response: under 500ms
- Symbol lookup (warm cache): under 250ms
- Diagnostics aggregation: under 1000ms
- Test-impact mapping phase: under 1000ms

## Workflow

This is the intended operational workflow for coding tasks:

1. Triage with diagnostics aggregator.
2. Locate architecture with symbol index.
3. Narrow precise edit targets with AST query.
4. Apply minimal changes.
5. Validate fast with test impact mapper.
6. Escalate to broader test/build checks when stable.

### Why This Workflow Works

- Front-loads understanding before editing.
- Uses structural queries to reduce accidental edits.
- Keeps verify loops fast early, broad later.
- Produces consistent summaries for easier PR review.

## Rollout and Safety

- Ship code actions disabled by default (`feature.code_actions = false`).
- Enable per-repo or per-session during early adoption.
- Track tool success/failure/fallback rates.
- Keep rollback switches for each major capability.

## Definition of Done

- All five tools return normalized envelopes.
- Degraded mode works without crashes.
- Fixture and unit tests pass for all target languages.
- Performance gates meet practical defaults.
- Documentation explains why, when, and how to use each tool.
