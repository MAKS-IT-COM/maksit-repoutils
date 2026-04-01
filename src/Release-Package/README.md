# Release-Package

Plugin-driven release engine. Run `Release-Package.ps1` from this directory (or `Release-Package.bat`). Configuration: `scriptsettings.json` (see `_comments` for plugin keys).

Canonical source: this folder in **maksit-repoutils**. Product repositories refresh via `Update-RepoUtils` or by copying from here.

## Modules (orchestration)

| File | Role |
|------|------|
| `Release-Package.ps1` | Loads settings, builds `New-EngineContext`, runs plugins in order. |
| `PluginSupport.psm1` | Plugin discovery, optional `branches` / `*` for publish plugins, `Invoke-ConfiguredPlugin`. |
| `ReleaseContext.psm1` | Resolves semver via `Resolve-DotNetReleaseVersion` from the `DotNetReleaseVersion` plugin `projectFiles` (first `.csproj` `<Version>`). |
| `EngineSupport.psm1` | Working tree check, release vs dev branch, git tag validation, shared context (`version`, `tag`, …). |

## Plugins

`CorePlugins/` — e.g. `DotNetReleaseVersion`, `DockerPush`, `HelmPush`. Optional `CustomPlugins/`.

`DotNetPack` and `DotNetQualityGate` (when used) can declare their own `projectFiles`; semver still comes only from `DotNetReleaseVersion.projectFiles`.


