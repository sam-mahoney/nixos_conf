#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_PATH="${SCRIPT_DIR}/../AGENTS.template.md"
TARGET_DIR="${1:-$(pwd)}"
TARGET_FILE="${TARGET_DIR}/AGENTS.md"
FORCE="${2:-}"

if [[ ! -f "${TEMPLATE_PATH}" ]]; then
  printf 'Template not found: %s\n' "${TEMPLATE_PATH}" >&2
  exit 1
fi

if [[ ! -d "${TARGET_DIR}" ]]; then
  printf 'Target directory not found: %s\n' "${TARGET_DIR}" >&2
  exit 1
fi

if [[ -f "${TARGET_FILE}" && "${FORCE}" != "--force" ]]; then
  printf 'Refusing to overwrite existing %s (pass --force to replace).\n' "${TARGET_FILE}" >&2
  exit 1
fi

cp "${TEMPLATE_PATH}" "${TARGET_FILE}"
printf 'Wrote %s\n' "${TARGET_FILE}"
