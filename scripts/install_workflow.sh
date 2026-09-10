#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /absolute/path/to/target-repository" >&2
  exit 64
fi

target_repo=$1
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
skill_dir=$(cd "$script_dir/.." && pwd)
source_workflow="$skill_dir/assets/claude-airpods.yml"
workflow_dir="$target_repo/.github/workflows"
target_workflow="$workflow_dir/claude-airpods.yml"

if [[ ! -d "$target_repo/.git" ]]; then
  echo "Target is not a Git repository: $target_repo" >&2
  exit 65
fi

if [[ -e "$target_workflow" ]]; then
  echo "Refusing to overwrite existing workflow: $target_workflow" >&2
  exit 66
fi

mkdir -p "$workflow_dir"
cp "$source_workflow" "$target_workflow"

echo "Installed: $target_workflow"
echo "Next: review the workflow, configure one Claude secret, commit, and push."
