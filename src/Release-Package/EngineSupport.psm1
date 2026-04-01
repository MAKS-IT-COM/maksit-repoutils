#requires -Version 7.0
#requires -PSEdition Core

if (-not (Get-Command Write-Log -ErrorAction SilentlyContinue)) {
    $loggingModulePath = Join-Path (Split-Path $PSScriptRoot -Parent) "Logging.psm1"
    if (Test-Path $loggingModulePath -PathType Leaf) {
        Import-Module $loggingModulePath -Force
    }
}

if (-not (Get-Command Get-CurrentBranch -ErrorAction SilentlyContinue)) {
    $gitToolsModulePath = Join-Path (Split-Path $PSScriptRoot -Parent) "GitTools.psm1"
    if (Test-Path $gitToolsModulePath -PathType Leaf) {
        Import-Module $gitToolsModulePath -Force
    }
}

if (-not (Get-Command Get-PluginStageLabel -ErrorAction SilentlyContinue) -or -not (Get-Command Test-IsPublishPlugin -ErrorAction SilentlyContinue)) {
    $pluginSupportModulePath = Join-Path $PSScriptRoot "PluginSupport.psm1"
    if (Test-Path $pluginSupportModulePath -PathType Leaf) {
        Import-Module $pluginSupportModulePath -Force
    }
}

if (-not (Get-Command Resolve-DotNetReleaseVersion -ErrorAction SilentlyContinue)) {
    $releaseContextModulePath = Join-Path $PSScriptRoot "ReleaseContext.psm1"
    if (Test-Path $releaseContextModulePath -PathType Leaf) {
        Import-Module $releaseContextModulePath -Force
    }
}

function Assert-WorkingTreeClean {
    param(
        [Parameter(Mandatory = $true)]
        [bool]$IsReleaseBranch
    )

    $gitStatus = Get-GitStatusShort
    if ($gitStatus) {
        if ($IsReleaseBranch) {
            Write-Error "Working directory has uncommitted changes. Commit or stash them before releasing."
            Write-Log -Level "WARN" -Message "Uncommitted files:"
            $gitStatus | ForEach-Object { Write-Log -Level "WARN" -Message "  $_" }
            exit 1
        }

        Write-Log -Level "WARN" -Message "  Uncommitted changes detected (allowed on dev branch)."
        return
    }

    Write-Log -Level "OK" -Message "  Working directory is clean."
}

function Initialize-ReleaseStageContext {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$RemainingPlugins,

        [Parameter(Mandatory = $true)]
        [psobject]$SharedSettings,

        [Parameter(Mandatory = $true)]
        [string]$ArtifactsDirectory,

        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    Write-Log -Level "STEP" -Message "Verifying tag is pushed to remote..."
    $remoteTagExists = Test-RemoteTagExists -Tag $SharedSettings.tag -Remote "origin"
    if (-not $remoteTagExists) {
        Write-Log -Level "WARN" -Message "  Tag $($SharedSettings.tag) not found on remote. Pushing..."
        Push-TagToRemote -Tag $SharedSettings.tag -Remote "origin"
    }
    else {
        Write-Log -Level "OK" -Message "  Tag exists on remote."
    }

    if (-not $SharedSettings.PSObject.Properties['releaseDir'] -or [string]::IsNullOrWhiteSpace([string]$SharedSettings.releaseDir)) {
        $SharedSettings | Add-Member -NotePropertyName releaseDir -NotePropertyValue $ArtifactsDirectory -Force
    }
}

function New-EngineContext {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Plugins,

        [Parameter(Mandatory = $true)]
        [string]$ScriptDir,

        [Parameter(Mandatory = $true)]
        [string]$UtilsDir,

        [Parameter(Mandatory = $false)]
        [psobject]$Settings
    )

    $version = (Resolve-DotNetReleaseVersion -Plugins $Plugins -ScriptDir $ScriptDir).version
    $artifactsDirectory = [System.IO.Path]::GetFullPath((Join-Path $ScriptDir '..\\..\\release'))

    $currentBranch = Get-CurrentBranch
    # Branches that require a matching git tag (exclude wildcards; default to main if only * is used).
    $releaseBranches = @(
        foreach ($p in ($Plugins | Where-Object { Test-IsPublishPlugin -Plugin $_ })) {
            foreach ($b in (Get-PluginBranches -Plugin $p)) {
                $b
            }
        }
    )
    $releaseBranches = @($releaseBranches | Where-Object { $_ -ne '*' -and -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
    if ($releaseBranches.Count -eq 0) {
        $releaseBranches = @('main')
    }

    $isReleaseBranch = $releaseBranches -contains $currentBranch
    $isNonReleaseBranch = -not $isReleaseBranch

    Assert-WorkingTreeClean -IsReleaseBranch:$isReleaseBranch

    if ($isReleaseBranch) {
        $tag = Get-CurrentCommitTag -Version $version

        if ($tag -notmatch '^v(\d+\.\d+\.\d+)$') {
            Write-Error "Tag '$tag' does not match expected format 'vX.Y.Z' (e.g., v$($version))."
            exit 1
        }

        $tagVersion = $Matches[1]
        if ($tagVersion -ne $version) {
            Write-Error "Tag version ($tagVersion) does not match the release version ($version)."
            Write-Log -Level "WARN" -Message "  Either update the tag or the configured version (DotNetReleaseVersion.projectFiles)."
            exit 1
        }

        Write-Log -Level "OK" -Message "  Tag found: $tag (matches release version)"
    }
    else {
        $tag = "v$version"
        Write-Log -Level "INFO" -Message "  Using release version from configuration (no tag required on non-release branches)."
    }

    return [pscustomobject]@{
        scriptDir = $ScriptDir
        utilsDir = $UtilsDir
        currentBranch = $currentBranch
        version = $version
        tag = $tag
        artifactsDirectory = $artifactsDirectory
        isReleaseBranch = $isReleaseBranch
        isNonReleaseBranch = $isNonReleaseBranch
        releaseBranches = $releaseBranches
        publishCompleted = $false
    }
}

function Get-PreferredReleaseBranch {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$EngineContext
    )

    if ($EngineContext.releaseBranches.Count -gt 0) {
        return $EngineContext.releaseBranches[0]
    }

    return "main"
}

Export-ModuleMember -Function Assert-WorkingTreeClean, Initialize-ReleaseStageContext, New-EngineContext, Get-PreferredReleaseBranch



