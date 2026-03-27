#!/usr/bin/env pwsh

# Consolidated prerequisite checking script (PowerShell)
#
# This script provides unified prerequisite checking for Spec-Driven Development workflow.
#
# Usage: ./check-prerequisites.ps1 [OPTIONS]
#
# OPTIONS:
#   -Json               Output in JSON format
#   -PathsOnly          Only output path variables (no validation)
#   -Help, -h           Show help message

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$PathsOnly,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output @"
Usage: check-prerequisites.ps1 [OPTIONS]

Consolidated prerequisite checking for Spec-Driven Development workflow.

OPTIONS:
  -Json               Output in JSON format
  -PathsOnly          Only output path variables (no prerequisite validation)
  -Help, -h           Show this help message

EXAMPLES:
  # Check prerequisites (plan.md required)
  .\check-prerequisites.ps1 -Json

  # Get feature paths only (no validation)
  .\check-prerequisites.ps1 -PathsOnly

"@
    exit 0
}

# Source common functions
. "$PSScriptRoot/common.ps1"

# Get feature paths and validate branch
$paths = Get-FeaturePathsEnv

if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH -HasGit:$paths.HAS_GIT)) {
    exit 1
}

# If paths-only mode, output paths and exit (support combined -Json -PathsOnly)
if ($PathsOnly) {
    if ($Json) {
        [PSCustomObject]@{
            REPO_ROOT   = $paths.REPO_ROOT
            BRANCH      = $paths.CURRENT_BRANCH
            FEATURE_DIR = $paths.FEATURE_DIR
            PLAN_FILE   = $paths.PLAN_FILE
        } | ConvertTo-Json -Compress
    } else {
        Write-Output "REPO_ROOT: $($paths.REPO_ROOT)"
        Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
        Write-Output "FEATURE_DIR: $($paths.FEATURE_DIR)"
        Write-Output "PLAN_FILE: $($paths.PLAN_FILE)"
    }
    exit 0
}

# Validate required directories and files
if (-not (Test-Path $paths.FEATURE_DIR -PathType Container)) {
    Write-Output "ERROR: Feature directory not found: $($paths.FEATURE_DIR)"
    Write-Output "Run /speckit.plan first to create the feature structure."
    exit 1
}

if (-not (Test-Path $paths.PLAN_FILE -PathType Leaf)) {
    Write-Output "ERROR: plan.md not found in $($paths.FEATURE_DIR)"
    Write-Output "Run /speckit.plan first to create the plan."
    exit 1
}

# Output results
if ($Json) {
    [PSCustomObject]@{
        FEATURE_DIR = $paths.FEATURE_DIR
        PLAN_FILE   = $paths.PLAN_FILE
    } | ConvertTo-Json -Compress
} else {
    Write-Output "FEATURE_DIR:$($paths.FEATURE_DIR)"
    Write-Output "PLAN_FILE:$($paths.PLAN_FILE)"
}
