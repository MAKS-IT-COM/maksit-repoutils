# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [1.0.8] - 2026-04-01

### Changed

- Release-Package: `scriptsettings.json` keys are camelCase (`plugins`, `name`, `stageLabel`, `enabled`); `stageLabel` uses lowercase phase names (`qualityGate`, `release`, …); engine and plugins use camelCase shared context and `context` on plugin settings; `Get-PluginStage` → `Get-PluginStageLabel`; `DotNetPack` selects newest `.nupkg`/`.snupkg` via loops (avoids fragile multi-line pipelines).

## [1.0.7] - 2026-04-01

### Changed

- Release-Package: `QualityGate` plugin renamed to `DotNetQualityGate` (`CorePlugins/DotNetQualityGate.psm1`). Configure **`stageLabel`**: `qualityGate` (see `scriptsettings.json`; legacy `Stage` / `QualityGate` capitalization removed).
- Release-Package: `NuGet` plugin renamed to `DotNetNuGet` (`CorePlugins/DotNetNuGet.psm1`).

## [1.0.6] - 2026-04-01

### Changed

- Release-Package: `ReleaseVersionContext.psm1` replaced by `ReleaseContext.psm1` (`Resolve-ReleaseVersion`, `Resolve-RelativePaths`, csproj helpers). Added `CorePlugins/ReleaseVersion.psm1` for optional version echo into shared context. Removed top-level `ReleaseContext` from sample `scriptsettings.json`; version source is `ReleaseVersion.projectFiles` only.
- `DotNetPack` accepts plugin-level `projectFiles` (and optional `artifactsDir`) so builds do not rely on removed global `ProjectFiles` on shared context.

### Removed

- `ReleaseVersionContext.psm1` (superseded by `ReleaseContext.psm1`).

## [1.0.5] - 2026-03-31

### Changed

- Release-Package decoupling: introduced top-level `ReleaseContext` (`projectFiles` / `chartPath` / `artifactsDir`) as the primary version source. `New-ReleaseVersionContext` uses it first and keeps plugin-scoped fields as backward-compatible fallback.

## [1.0.4] - 2026-03-31

### Changed

- Documentation and `scriptsettings.json` description/comments: unified `description`, Docker/Helm `_comments` phrasing, removed redundant `branches` comment (covered by top-level description). Added `src/Release-Package/README.md`, expanded root `README.md` layout for the release engine modules, and clarified that release version/artifacts context comes from the first plugin defining `projectFiles` / `artifactsDir` (so duplicate DockerPush entries are unnecessary when already defined earlier, e.g. in DotNetPack).

## [1.0.3] - 2026-03-31

### Added

- HelmPush: optional `pushLatest` — after `helm push`, tags the chart as `:latest` in the same OCI repo via `oras copy` (requires [oras](https://oras.land) on PATH). Defaults to false when omitted.

## [1.0.2] - 2026-03-31

### Changed

- Release-Package: publish plugins (`GitHub`, `DotNetNuGet`, `DockerPush`, `HelmPush`) with **no** `branches` property (or empty list) now run on **every** branch; use an explicit branch list to restrict. `*` means all branches. Git tag validation still uses named branches only (wildcard entries ignored; defaults to `main` when no named branch is configured).

## [1.0.1] - 2026-03-31

### Changed

- Release engine: `DotNetProjectSupport.psm1` replaced by `ReleaseVersionContext.psm1` (`New-ReleaseVersionContext`, `Get-CsprojPropertyValue`, `Get-CsprojVersions`). When `projectFiles` is set and `artifactsDir` is omitted, the engine defaults to `..\..\release` under `Release-Package` (same as chart-only version resolution).

## [1.0.0] - 2026-02-28

### Added

- Initial public release of this repository (shared RepoUtils tooling).
- Shared PowerShell modules for configuration loading, logging, git operations, and test execution.
- `Release-Package` plugin-driven release engine for repository packaging and publishing workflows.
- `Generate-CoverageBadges` utility for generating SVG coverage badges from test coverage results.
- `Force-AmendTaggedCommit` utility for repairing the latest tagged release commit.
- `Update-RepoUtils` utility for refreshing a local RepoUtils installation from a configured repository source.

<!-- 
Template for new releases:

## v1.x.x

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements
-->






