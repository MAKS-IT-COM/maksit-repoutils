# Contributing to MaksIT-RepoUtils

Thank you for contributing to MaksIT-RepoUtils. This repository contains reusable PowerShell 7 modules and automation scripts for repository maintenance, release workflows, and coverage reporting.

## Getting Started

1. Fork the repository.
2. Clone your fork locally.
3. Create a branch for your change.
4. Make and test your change.
5. Submit a pull request against `main`.

## Development Setup

### Prerequisites

- PowerShell 7.0 or later
- Git
- .NET SDK when working with scripts that run .NET builds or tests
- Docker Desktop when using release workflows that validate Linux builds
- GitHub CLI (`gh`) when using plugins or scripts that publish releases

### Repository Layout

- `src/*.psm1`: shared utility modules
- `src/Release-Package`: plugin-driven release engine
- `src/Generate-CoverageBadges`: coverage badge generator for README assets
- `src/Force-AmendTaggedCommit`: utility for fixing the latest tagged release commit
- `src/Update-RepoUtils`: updater that refreshes a local RepoUtils installation

## Working on Changes

### Verify Scripts

Run scripts directly with PowerShell from their own directory so relative paths resolve correctly:

```powershell
pwsh -File .\src\Release-Package\Release-Package.ps1
pwsh -File .\src\Generate-CoverageBadges\Generate-CoverageBadges.ps1
pwsh -File .\src\Force-AmendTaggedCommit\Force-AmendTaggedCommit.ps1 -DryRun
pwsh -File .\src\Update-RepoUtils\Update-RepoUtils.ps1
```

Before opening a pull request, validate the script you changed and any shared module it depends on.

### Code Style

- Follow PowerShell best practices and prefer clear, pipeline-friendly functions.
- Keep shared behavior in modules under `src` instead of duplicating logic across scripts.
- Use comment-based help for scripts and exported functions.
- Keep configuration in the relevant `scriptsettings.json` file when behavior is intended to be user-configurable.
- Preserve cross-platform compatibility unless a script is explicitly platform-specific.

### Commit Messages

Use clear, conventional commit messages. A simple format such as `type: short description` is preferred.

Examples:

- `docs: fix contributing guide`
- `fix: handle missing tag sorting fallback`
- `feat: add release plugin validation`

## Pull Request Process

1. Ensure the affected scripts run without errors.
2. Update documentation when behavior or configuration changes.
3. Update `CHANGELOG.md` when the change affects users.
4. Keep the pull request focused on a single change or closely related set of changes.
5. Submit the pull request against `main`.

## Release Notes

The main release workflow is handled by `src/Release-Package/Release-Package.ps1`. Supporting utilities include:

- `src/Generate-CoverageBadges/Generate-CoverageBadges.ps1`
- `src/Force-AmendTaggedCommit/Force-AmendTaggedCommit.ps1`
- `src/Update-RepoUtils/Update-RepoUtils.ps1`

Review each script's comment-based help and local `scriptsettings.json` before running it in a real repository.

## License

By contributing, you agree that your contributions are licensed under the terms in `LICENSE.md`.
