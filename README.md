# MaksIT-RepoUtils

MaksIT-RepoUtils is a PowerShell 7 toolkit for repository automation. It packages reusable modules and task-focused scripts for release orchestration, coverage badge generation, tagged-commit repair, and self-updating local RepoUtils installations.

## Table of Contents

- [MaksIT-RepoUtils](#maksit-repoutils)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Included Tools](#included-tools)
    - [Shared Modules](#shared-modules)
    - [Release engine](#release-engine)
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
- `src/TestRunner.psm1`: test execution and coverage collection helpers (one or many test projects; Cobertura metrics are aggregated)

### Release engine

`src/Release-Package/` — plugin-driven release automation:

- `Release-Package.ps1`: entry script; loads `scriptsettings.json` and runs plugins
- `PluginSupport.psm1`, `EngineSupport.psm1`, `ReleaseContext.psm1`: orchestration, branch rules, and semver resolution via the `DotNetReleaseVersion` plugin (`projectFiles` → first `.csproj` `<Version>`)
- `CorePlugins/*.psm1`: plugins (e.g. `DotNetReleaseVersion`, DotNetPack, GitHub, NuGet, DockerPush, HelmPush)

See `src/Release-Package/README.md` for module layout.

### Scripts

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

Each script reads its configuration from a local `scriptsettings.json` file in the same directory. For coverage badges, prefer `paths.testProjects` (array of relative test project paths); `paths.testProject` remains supported for a single project. The Release-Package `DotNetTest` plugin accepts `projects` (array) or `project` (string).

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
    Release-Package.ps1
    PluginSupport.psm1
    EngineSupport.psm1
    ReleaseContext.psm1
    CorePlugins/
    CustomPlugins/
  Update-RepoUtils/
```

## Contributing

Contribution guidelines are documented in `CONTRIBUTING.md`.

## Contact

If you have any questions or need further assistance, feel free to reach out:

- **Email**: [maksym.sadovnychyy@gmail.com](mailto:maksym.sadovnychyy@gmail.com)

## License

This project is licensed under the terms in `LICENSE.md`.
