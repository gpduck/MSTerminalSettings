###############################################################################
# Customize these properties and tasks for your module.
###############################################################################

# ----------------------- Basic properties --------------------------------

# The root directories for the module's docs, src and test.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$DocsRootDir = "$PSScriptRoot/docs"
$SrcRootDir  = "$PSScriptRoot/src"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$TestRootDir = "$PSScriptRoot/test"

# The name of your module should match the basename of the PSD1 file.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ModuleName = Get-Item $SrcRootDir/*.psd1 |
                  Where-Object { $null -ne (Test-ModuleManifest -Path $_ -ErrorAction SilentlyContinue) } |
                  Select-Object -First 1 | Foreach-Object BaseName

# The $OutDir is where module files and updatable help files are staged for signing, install and publishing.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OutDir = "$PSScriptRoot/Release"

# The local installation directory for the install task. Defaults to your home Modules location.
try {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $InstallPath = Join-Path (Split-Path $profile.CurrentUserAllHosts -Parent) `
                            "Modules\$ModuleName\$((Test-ModuleManifest -Path $SrcRootDir\$ModuleName.psd1).Version.ToString())"
} catch {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $InstallPath = $null
}
# Default Locale used for help generation, defaults to en-US.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$DefaultLocale = 'en-US'

# Items in the $Exclude array will not be copied to the $OutDir e.g. $Exclude = @('.gitattributes')
# Typically you wouldn't put any file under the src dir unless the file was going to ship with
# the module. However, if there are such files, add their $SrcRootDir relative paths to the exclude list.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$Exclude = @()

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$PackageRestoreEnabled = $False

# ------------------ Script analysis properties ---------------------------

# Enable/disable use of PSScriptAnalyzer to perform script analysis.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ScriptAnalysisEnabled = $true

# When PSScriptAnalyzer is enabled, control which severity level will generate a build failure.
# Valid values are Error, Warning, Information and None.  "None" will report errors but will not
# cause a build failure.  "Error" will fail the build only on diagnostic records that are of
# severity error.  "Warning" will fail the build on Warning and Error diagnostic records.
# "Any" will fail the build on any diagnostic record, regardless of severity.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
[ValidateSet('Error', 'Warning', 'Any', 'None')]
$ScriptAnalysisFailBuildOnSeverityLevel = 'Error'

# Path to the PSScriptAnalyzer settings file.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ScriptAnalyzerSettingsPath = "$PSScriptRoot/ScriptAnalyzerSettings.psd1"

# ------------------- Script signing properties ---------------------------

# Set to $true if you want to sign your scripts. You will need to have a code-signing certificate.
# You can specify the certificate's subject name below. If not specified, you will be prompted to
# provide either a subject name or path to a PFX file.  After this one time prompt, the value will
# saved for future use and you will no longer be prompted.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ScriptSigningEnabled = $false

# Specify the Subject Name of the certificate used to sign your scripts.  Leave it as $null and the
# first time you build, you will be prompted to enter your code-signing certificate's Subject Name.
# This variable is used only if $SignScripts is set to $true.
#
# This does require the code-signing certificate to be installed to your certificate store.  If you
# have a code-signing certificate in a PFX file, install the certificate to your certificate store
# with the command below. You may be prompted for the certificate's password.
#
# Import-PfxCertificate -FilePath .\myCodeSigingCert.pfx -CertStoreLocation Cert:\CurrentUser\My
#
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CertSubjectName = $null

# Certificate store path.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CertPath = "Cert:\"

# -------------------- File catalog properties ----------------------------

# Enable/disable generation of a catalog (.cat) file for the module.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CatalogGenerationEnabled = $false

# Select the hash version to use for the catalog file: 1 for SHA1 (compat with Windows 7 and
# Windows Server 2008 R2), 2 for SHA2 to support only newer Windows versions.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CatalogVersion = 2

# ---------------------- Testing properties -------------------------------

# Enable/disable Pester code coverage reporting.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CodeCoverageEnabled = $false

# CodeCoverageFiles specifies the files to perform code coverage analysis on. This property
# acts as a direct input to the Pester -CodeCoverage parameter, so will support constructions
# like the ones found here: https://github.com/pester/Pester/wiki/Code-Coverage.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CodeCoverageFiles = "$SrcRootDir/*.ps1", "$SrcRootDir/*.psm1"

# -------------------- Publishing properties ------------------------------

# Your NuGet API key for the PSGallery.  Leave it as $null and the first time you publish,
# you will be prompted to enter your API key.  The build will store the key encrypted in the
# settings file, so that on subsequent publishes you will no longer be prompted for the API key.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$NuGetApiKey = $env:PowershellGalleryKey

# Name of the repository you wish to publish to. If $null is specified the default repo (PowerShellGallery) is used.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$PublishRepository = "PSGallery"

# ----------------------- Misc properties ---------------------------------

# In addition, PFX certificates are supported in an interactive scenario only,
# as a way to import a certificate into the user personal store for later use.
# This can be provided using the CertPfxPath parameter. PFX passwords will not be stored.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$SettingsPath = "$env:LOCALAPPDATA/Plaster/NewModuleTemplate/SecuredBuildSettings.clixml"

# Specifies an output file path to send to Invoke-Pester's -OutputFile parameter.
# This is typically used to write out test results so that they can be sent to a CI
# system like AppVeyor.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$TestOutputFile = "$PSScriptRoot/PesterResults.xml"

# Specifies the test output format to use when the TestOutputFile property is given
# a path.  This parameter is passed through to Invoke-Pester's -OutputFormat parameter.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$TestOutputFormat = "NUnitXml"

###############################################################################
# Customize these tasks for performing operations before and/or after file staging.
###############################################################################

# Executes before the StageFiles task.
Task BeforeStageFiles -Before StageFiles {
}

# Executes after the StageFiles task.
Task AfterStageFiles -After StageFiles {
    $ManifestPath = Join-Path $OutDir "${ModuleName}\${ModuleName}.psd1"
    $Manifest = Get-Content $ManifestPath -Raw

    # Update module version
    if($env:APPVEYOR_BUILD_VERSION) {
        $VersionPart = $env:APPVEYOR_BUILD_VERSION.Split("-")[0]
        $Manifest = $Manifest -Replace "ModuleVersion ?= ?['`"](\d+\.?){2,4}['`"]", "ModuleVersion = '$VersionPart'"
    } else {
        "AppVeyor build version not detected"
    }

    # Update prerelase string
    if($env:APPVEYOR_REPO_COMMIT_MESSAGE -like "pre: *" -and $env:OS -eq "Windows_NT") {
        $Manifest = $Manifest -Replace 'Prerelease = \$null', 'Prerelease = "pre"'
        if($env:APPVEYOR_BUILD_VERSION -notlike "*-pre") {
            Update-AppveyorBuild -Version "${env:APPVEYOR_BUILD_VERSION}-pre"
        }
    } else {
        "AppVeyor pre-release not detected"
    }

    # Write updated manifest
    Set-Content -Path $ManifestPath -Value $Manifest

    if($env:APPVEYOR_REPO_COMMIT_MESSAGE_EXTENDED) {
        $ReleaseNotesTitle = $env:APPVEYOR_REPO_COMMIT_MESSAGE
        $ReleaseNotesBody = $env:APPVEYOR_REPO_COMMIT_MESSAGE_EXTENDED.Replace("\n", "`n")
        $ReleaseNotes = "$ReleaseNotesTitle`n`n$ReleaseNotesBody"
        Update-ModuleManifest -Path $ManifestPath -ReleaseNotes $ReleaseNotes
    }
}

###############################################################################
# Customize these tasks for performing operations before and/or after Build.
###############################################################################

# Executes before the BeforeStageFiles phase of the Build task.
Task BeforeBuild -Before Build {
}

# Executes after the Build task.
Task AfterBuild -if (!$CopyOnly) -After Build {
    try {
        Microsoft.PowerShell.Management\Push-Location -LiteralPath $OutDir
        Import-Module microsoft.powershell.archive
        Compress-Archive -path .\$ModuleName -DestinationPath ..\${ModuleName}.zip -Force
    } finally {
        Microsoft.PowerShell.Management\Pop-Location
    }
}

###############################################################################
# Customize these tasks for performing operations before and/or after BuildHelp.
###############################################################################

# Executes before the BuildHelp task.
Task BeforeBuildHelp -Before BuildHelp {
}

# Executes after the BuildHelp task.
Task AfterBuildHelp -After BuildHelp {
}

###############################################################################
# Customize these tasks for performing operations before and/or after BuildUpdatableHelp.
###############################################################################

# Executes before the BuildUpdatableHelp task.
Task BeforeBuildUpdatableHelp -Before BuildUpdatableHelp {
}

# Executes after the BuildUpdatableHelp task.
Task AfterBuildUpdatableHelp -After BuildUpdatableHelp {
}

###############################################################################
# Customize these tasks for performing operations before and/or after GenerateFileCatalog.
###############################################################################

# Executes before the GenerateFileCatalog task.
Task BeforeGenerateFileCatalog -Before GenerateFileCatalog {
}

# Executes after the GenerateFileCatalog task.
Task AfterGenerateFileCatalog -After GenerateFileCatalog {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Install.
###############################################################################

# Executes before the Install task.
Task BeforeInstall -Before Install {
}

# Executes after the Install task.
Task AfterInstall -After Install {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Publish.
###############################################################################

# Executes before the Publish task.
Task BeforePublish -Before Publish {
}

# Executes after the Publish task.
Task AfterPublish -After Publish {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Test.
###############################################################################

# Executes before the Test task.
Task BeforeTest -Before Test {
}

# Executes after the Test task.
Task AfterTest -After Test {
    if($env:APPVEYOR_JOB_ID -and (Test-Path $TestOutputFile)) {
        try {
            $wc = New-Object System.Net.WebClient
            $wc.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", $TestOutputFile)
        } catch {
            Write-Host "Error uploading test results: $($_.Exception.Message)"
        }
    } else {
        "Skipping upload test results"
    }
}

Task AfterClean -After Clean {
}
