#!/usr/bin/env bash

# Consolidated prerequisite checking script
#
# This script provides unified prerequisite checking for Spec-Driven Development workflow.
#
# Usage: ./check-prerequisites.sh [OPTIONS]
#
# OPTIONS:
#   --json              Output in JSON format
#   --paths-only        Only output path variables (no validation)
#   --help, -h          Show help message
#
# OUTPUTS:
#   JSON mode: {"FEATURE_DIR":"...", "PLAN_FILE":"..."}
#   Text mode: FEATURE_DIR:... \n PLAN_FILE:...
#   Paths only: REPO_ROOT: ... \n BRANCH: ... \n FEATURE_DIR: ... etc.

set -e

# Parse command line arguments
JSON_MODE=false
PATHS_ONLY=false

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --paths-only)
            PATHS_ONLY=true
            ;;
        --help|-h)
            cat << 'EOF'
Usage: check-prerequisites.sh [OPTIONS]

Consolidated prerequisite checking for Spec-Driven Development workflow.

OPTIONS:
  --json              Output in JSON format
  --paths-only        Only output path variables (no prerequisite validation)
  --help, -h          Show this help message

EXAMPLES:
  # Check prerequisites (plan.md required)
  ./check-prerequisites.sh --json

  # Get feature paths only (no validation)
  ./check-prerequisites.sh --paths-only

EOF
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option '$arg'. Use --help for usage information." >&2
            exit 1
            ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get feature paths and validate branch
_paths_output=$(get_feature_paths) || { echo "ERROR: Failed to resolve feature paths" >&2; exit 1; }
eval "$_paths_output"
unset _paths_output
check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

# If paths-only mode, output paths and exit (support JSON + paths-only combined)
if $PATHS_ONLY; then
    if $JSON_MODE; then
        if has_jq; then
            jq -cn \
                --arg repo_root "$REPO_ROOT" \
                --arg branch "$CURRENT_BRANCH" \
                --arg feature_dir "$FEATURE_DIR" \
                --arg plan_file "$PLAN_FILE" \
                '{REPO_ROOT:$repo_root,BRANCH:$branch,FEATURE_DIR:$feature_dir,PLAN_FILE:$plan_file}'
        else
            printf '{"REPO_ROOT":"%s","BRANCH":"%s","FEATURE_DIR":"%s","PLAN_FILE":"%s"}\n' \
                "$(json_escape "$REPO_ROOT")" "$(json_escape "$CURRENT_BRANCH")" "$(json_escape "$FEATURE_DIR")" "$(json_escape "$PLAN_FILE")"
        fi
    else
        echo "REPO_ROOT: $REPO_ROOT"
        echo "BRANCH: $CURRENT_BRANCH"
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo "PLAN_FILE: $PLAN_FILE"
    fi
    exit 0
fi

# Validate required directories and files
if [[ ! -d "$FEATURE_DIR" ]]; then
    echo "ERROR: Feature directory not found: $FEATURE_DIR" >&2
    echo "Run /speckit.plan first to create the feature structure." >&2
    exit 1
fi

if [[ ! -f "$PLAN_FILE" ]]; then
    echo "ERROR: plan.md not found in $FEATURE_DIR" >&2
    echo "Run /speckit.plan first to create the plan." >&2
    exit 1
fi

# Output results
if $JSON_MODE; then
    if has_jq; then
        jq -cn \
            --arg feature_dir "$FEATURE_DIR" \
            --arg plan_file "$PLAN_FILE" \
            '{FEATURE_DIR:$feature_dir,PLAN_FILE:$plan_file}'
    else
        printf '{"FEATURE_DIR":"%s","PLAN_FILE":"%s"}\n' "$(json_escape "$FEATURE_DIR")" "$(json_escape "$PLAN_FILE")"
    fi
else
    echo "FEATURE_DIR:$FEATURE_DIR"
    echo "PLAN_FILE:$PLAN_FILE"
fi
