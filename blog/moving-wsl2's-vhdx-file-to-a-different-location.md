# Moving WSL2's VHDX file to a different location

**Author:** Joe
<br/>**Date:** 07/14/2020 14:54:00

<p>I, like anyone who's been using Windows Subsystem for Linux, was excited when WSL2 was finally released.&nbsp; I was even more excited when Docker released support for WSL2.&nbsp; But, that excitement quickly went away once I started&nbsp;building containers.</p>
<p>With WSL2, images/containers are now stored in the&nbsp;virtual machine's VHDX image.&nbsp; When images/containers are purged, space is freed inside the VHDX, but is never released back to the host OS.&nbsp; This can cause the VHDX file to start balooning out of control, which is problematic if your&nbsp;primary&nbsp;boot drive is low on space.&nbsp; This is a known issue, and this <a href="https://github.com/microsoft/WSL/issues/4699">GitHub issue</a> has a workaround for shrinking the image (some of those steps are listed below).</p>
<p>To work around this, you can move the VHDX to&nbsp;a different drive/partition.&nbsp; Here's a PowerShell script do do it (USE AT YOUR OWN RISK):</p>
<pre class="brush:ps;auto-links:false;toolbar:false" contenteditable="false">$ErrorActionPreference = "Stop"

$newLocation = "E:\VMs\WSL2\"

cd ~\AppData\Local\Docker\wsl\data
wsl --shutdown
Optimize-VHD .\ext4.vhdx -Mode Full
mkdir $newLocation -Force
mv ext4.vhdx $newLocation
cd ..
rm data
New-Item -ItemType SymbolicLink -Path "data" -Target $newLocation</pre>
<p>Just change the $newLocation parameter, and it'll move the VHDX file to the new location.&nbsp; If you're using Windows 10 Home, <a href="https://github.com/microsoft/WSL/issues/4699#issuecomment-627133168">you can use this workaround for the Optimize-VHD command</a>.&nbsp; This will stop WSL, optimize the VHD (which releases unallocated space inside the VHDX back to the host OS), moves the VHDX to the new location, and replaces the "data" folder with a symlink to the new location.</p>
<p>I've done limited testing, and everything seems to work as expected.&nbsp; If you run into issues, let me know in the comments!</p>
<p><strong>Note:</strong>&nbsp;If you're running Docker for Windows without WSL/WSL2, these steps may work with DockerDesktop.vhdx...but in that case, you may want to just change the VHDX location in the Hyper-V VM instance.</p>
