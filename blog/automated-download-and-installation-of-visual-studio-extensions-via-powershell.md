# Automated download and installation of Visual Studio Extensions via Powershell

**Author:** Joe
<br/>**Date:** 05/04/2015 06:05:00

<div>While working on building a Packer/Vagrant Dev VM template, I needed the ability to download and install VSIX packages from the Visual Studio Gallery. &nbsp;I wanted something that would always download the latest version and install it automatically. &nbsp;After looking at some undocumented API's and having no success, I decided to go with web page scraping.</div><div><br></div><div>This script, when provided with the extension's guid, will download the web page from the gallery, parse it for the download link, download the VSIX package, and install it with admin privileges. &nbsp;Also, this<span style="line-height: 1.428571429;">&nbsp;assumes you're already running the script in an elevated PowerShell prompt, and that the webpage doesn't change from the time I wrote this post to the time you're using this script. :-)</span></div><div><span style="line-height: 1.428571429;"><br></span></div><div><b style="line-height: 1.428571429;">Example of how to use the script:</b></div><div><span style="line-height: 1.428571429;">Let's say we want to install NuGet for Visual Studio 2010. &nbsp;The gallery URL for this extension is:</span></div><div><a href="https://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c">https://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c</a></div><div><br></div><div>Assuming you name the script below "Install-Vsix.ps1", and it's in the current directory, you should be able to run the following command:</div><div><br></div><div>
<pre>./Install-Vsix "27077b70-9dad-4c64-adcf-c7cf6bc9970c"</pre>
<div><br></div><div>Here's where the magic happens.  Enjoy!</div>
<pre class="brush: plain">param([String] $PackageGuid)

$ErrorActionPreference = "Stop"

$baseProtocol = "https:"
$baseHostName = "visualstudiogallery.msdn.microsoft.com"

$Uri = "$($baseProtocol)//visualstudiogallery.msdn.microsoft.com/$($PackageGuid)"
$VsixLocation = "$($env:Temp)\$([guid]::NewGuid()).vsix"

$VSInstallDir = (
  (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0 -errorAction SilentlyContinue),
  (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\13.0 -errorAction SilentlyContinue),
  (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0 -errorAction SilentlyContinue),
  (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\11.0 -errorAction SilentlyContinue),
  (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\10.0 -errorAction SilentlyContinue) -ne $null
)[0].InstallDir

if (-Not $VSInstallDir) {
  Write-Error "Visual Studio InstallDir registry key missing"
  Exit 1
}

Write-Host "Grabbing VSIX extension at $($Uri)"
$HTML = Invoke-WebRequest -Uri $Uri

$PackageName = $HTML.ParsedHtml.Title
Write-Host "Attempting to download $($PackageName)..."
$anchors = $HTML.ParsedHtml.getElementById("Downloads").getElementsByTagName("a")
if (-Not $anchors) {
  Write-Error "Could not find download anchor tag on the Visual Studio Extensions page"
  Exit 1
}

$anchor = @($anchors)[0]
if (-Not $anchor.href.EndsWith(".vsix")) {
  Write-Error "Could not find .VSIX file in anchor tag on the Visual Studio Extensions page"
  Exit 1
}

$anchor.protocol = $baseProtocol
$anchor.hostname = $baseHostName
Invoke-WebRequest $anchor.href -OutFile $VsixLocation

if (-Not (Test-Path $VsixLocation)) {
  Write-Error "Downloaded VSIX file could not be located"
  Exit 1
}

Write-Host "Installing $($PackageName)..."
Start-Process -Filepath "$($VSInstallDir)\VSIXInstaller" -ArgumentList "/q /a $($VsixLocation)" -Wait

Write-Host "Cleanup..."
rm $VsixLocation

Write-Host "Installation of $($PackageName) complete!"
</pre></div>
