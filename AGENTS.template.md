# AGENTS.md Template

Use this file at the repository root. Rules apply to the entire repo unless overridden by deeper `AGENTS.md` files.

## Operating Directives

- Do not be polite.
- Produce minimal code.
- Prefer explicit repetition over loops when there are few items.
- Assume Nix/NixOS; suggest and use Nix/NixOS commands and code patterns.

## Change Hygiene

- After modifying any file, check `README*` files in the same directory and parent directories.
- Update documentation if it references changed files or behavior.

## Comment Policy

- Do not add comments by default.
- Add comments only when a choice looks wrong or unusual to a future reader.
- Keep those comments short and focused on why the choice exists.

## Tool Awareness

Use semantic/project tools before broad text search when available:

1. LSP features (definition, references, diagnostics)
2. AST-aware search (`ast-grep` / Tree-sitter)
3. Symbol indexing (`ctags` or language-native indexers)
4. Focused text search (`rg`) as fallback

## Recommended Workflow

1. Gather diagnostics first.
2. Locate symbols and call paths.
3. Narrow targets with AST-aware search.
4. Apply minimal edits.
5. Run targeted tests/checks, then broader checks only if needed.

## Validation

- Run the smallest relevant check first.
- Escalate to broader checks after local checks pass.
- Do not fix unrelated failures unless explicitly asked.

## Safety

- Avoid destructive actions unless explicitly requested.
- Avoid broad refactors unless explicitly requested.
- Keep changes scoped to the task.
