# Symlink your way to...sanity?...with Visual Studio 2017's new MSBuild location

**Author:** Joe
<br/>**Date:** 12/19/2017 11:08:00

<p>I've been working on a new development VM for work, and decided it was finally time to make the jump to Visual Studio 2017.&nbsp; That's when I discovered MSBuild went to an app-local installation (i.e. it's no longer located in "C:\Program Files (x86)\MSBuild").&nbsp; This sucks when you have have a bunch of MSBuild extensions that are installed in the global directory.</p>
<p>This is a complete hack, but I have a workaround that keeps the plugins installed in the global location (for backwards compatibility), and works with the new location:</p>
<pre class="brush:ps;auto-links:false;toolbar:false" contenteditable="false">Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module VSSetup -Scope CurrentUser -Force

Write-Output "Creating symlinks for MSBuild extensions"
$newMSBuildLocations = Get-VSSetupInstance
Get-ChildItem "${env:ProgramFiles(x86)}\MSBuild\Microsoft\*" -Directory | Foreach-Object {
    $directoryToSymlink = $_
    $newMSBuildLocations | %{
        cmd /c mklink /D "`"$($_.InstallationPath)\MSBuild\Microsoft\$($directoryToSymlink.Name)`"" "`"$directoryToSymlink`""
    }
}</pre>
<p>What this script does is:</p>
<ol>
<li>Sets up the NuGet provider in Windows 10</li>
<li>Installs the <a href="https://github.com/Microsoft/vssetup.powershell">Microsoft/VSSetup.Powershell</a> module</li>
<li>Makes a call to Get-VSSetupInstance to grab a list of all 2017+ installations on the system</li>
<li>For each directory in the global MSBuild\Microsoft directory, it creates a symlink in the new location pointing to the global directory</li>
</ol>
<p>This is only set up for the Microsoft folder, but that's all I needed in my instance.&nbsp; It could be modified to pull from a different folder in MSBuild, or you could provide a list of folders that should always be symlinked in the newer versions.</p>
<p>Hopefully this helps other developers until Microsoft can resolve the backwards compatibility issue!</p>
