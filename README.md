# MaksIT-RepoUtils

MaksIT-RepoUtils is a PowerShell 7 toolkit for repository automation. It packages reusable modules and task-focused scripts for release orchestration, coverage badge generation, tagged-commit repair, and self-updating local RepoUtils installations.

## Table of Contents

- [MaksIT-RepoUtils](#maksit-repoutils)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Included Tools](#included-tools)
    - [Shared Modules](#shared-modules)
    - [Scripts](#scripts)
  - [Usage](#usage)
  - [Repository Layout](#repository-layout)
  - [Contributing](#contributing)
  - [Contact](#contact)
  - [License](#license)

## Requirements

- PowerShell 7.0 or later
- Git
- .NET SDK for scripts that build or test .NET projects
- Docker Desktop for release flows that validate Linux builds
- GitHub CLI (`gh`) for GitHub release operations

## Included Tools

### Shared Modules

- `src/GitTools.psm1`: helpers for git-driven workflows
- `src/Logging.psm1`: consistent structured console output
- `src/ScriptConfig.psm1`: script settings loading and command validation
- `src/TestRunner.psm1`: test execution and coverage collection helpers

### Scripts

- `src/Release-Package/Release-Package.ps1`: plugin-driven release engine for repository packaging and publishing
- `src/Generate-CoverageBadges/Generate-CoverageBadges.ps1`: generates SVG coverage badges for README assets
- `src/Force-AmendTaggedCommit/Force-AmendTaggedCommit.ps1`: amends the latest tagged commit, recreates the tag, and force-pushes both
- `src/Update-RepoUtils/Update-RepoUtils.ps1`: refreshes a local RepoUtils copy from the configured source repository

## Usage

Run scripts with PowerShell from the repository root:

```powershell
pwsh -File .\src\Release-Package\Release-Package.ps1
pwsh -File .\src\Generate-CoverageBadges\Generate-CoverageBadges.ps1
pwsh -File .\src\Force-AmendTaggedCommit\Force-AmendTaggedCommit.ps1 -DryRun
pwsh -File .\src\Update-RepoUtils\Update-RepoUtils.ps1
```

Each script reads its configuration from a local `scriptsettings.json` file in the same directory.

## Repository Layout

```text
src/
  GitTools.psm1
  Logging.psm1
  ScriptConfig.psm1
  TestRunner.psm1
  Force-AmendTaggedCommit/
  Generate-CoverageBadges/
  Release-Package/
  Update-RepoUtils/
```

## Contributing

Contribution guidelines are documented in `CONTRIBUTING.md`.

## Contact

If you have any questions or need further assistance, feel free to reach out:

- **Email**: [maksym.sadovnychyy@gmail.com](mailto:maksym.sadovnychyy@gmail.com)

## License

This project is licensed under the terms in `LICENSE.md`.
