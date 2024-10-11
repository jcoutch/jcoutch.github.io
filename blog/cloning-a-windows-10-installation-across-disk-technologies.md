# Cloning a Windows 10 installation across disk technologies

**Author:** Joe
<br/>**Date:** 12/17/2016 09:52:00

<p>A while back, I decided it was time to upgrade by desktop system, and bought one of the new Intel NUC's (Skull Canyon.) &nbsp;To cut back on the initial cost, I've been running off the mSATA drive from my old desktop system via a mSATA-&gt;USB 3.0 adapter&nbsp;(with surprisingly good performance.) &nbsp;I decided it was time to&nbsp;get proper storage, and picked up a Toshiba/OCZ RD400 256 GB NVME m.2 drive (try saying that 5 times fast!)</p>
<p>Since my existing Windows installation was sat up exactly how I liked it, I wanted to clone it to my new drives. &nbsp;This proved a bit difficult...especially with switching from USB to m.2...and using GPT partitions with UEFI...so I'm going to outline the steps I used in case it helps someone else:</p>
<p>Items you'll need:</p>
<ul>
<li>Original storage device</li>
<li>New storage device</li>
<li>2 USB Flash Drives (at least 8 GB each)</li>
</ul>
<p>&nbsp;</p>
<p>Before&nbsp;swapping the drives, perform the following steps:</p>
<p><strong>Step 1 - Download drivers!</strong></p>
<ol>
<li>If your new drive is on a completely different bus from your original drive (i.e. upgrading from SATA to m.2), you MUST download&nbsp;and extract the drivers for the new bus to a folder on your hard drive...otherwise your machine WILL NOT BOOT at the end of this process. &nbsp;In my case, I downloaded the Toshiba/OCZ NVME drivers and extracted the "x64" folder to C:\nvme</li>
</ol>
<p><strong>Step 2 - Creating the Clonezilla&nbsp;USB boot drive:</strong></p>
<ol>
<li>Download <a href="http://clonezilla.org/downloads/download.php?branch=alternative">Clonezilla Alternate Stable ISO for amd64</a></li>
<li>While the ISO is downloading, format one of your flash drives for FAT32.</li>
<li>Mount the ISO in Windows by double clicking it, and copy all files directly into the root of the flash drive.</li>
<li>Remove the flash drive.</li>
</ol>
<p><strong>Step 3 - Creating the Windows 10 USB Installer boot drive:</strong></p>
<ol>
<li>Plug in your second flash drive.</li>
<li>Download the <a href="https://www.microsoft.com/en-in/software-download/windows10">Windows 10&nbsp;Media Creation Tool</a>&nbsp;and run it.</li>
<li>Click Create Installation Media for another computer.</li>
<li>Check "Use the recommended options for this PC" and click next.</li>
<li>Click "USB flash drive"&nbsp;and click next.</li>
<li>Select the flash drive from the list, and click Next.</li>
<li>Once the process is complete, shut down the&nbsp;computer.</li>
</ol>
<p><strong>Step 4&nbsp;- Clone the drive</strong></p>
<ol>
<li>Install the new drive in your computer, insert the Clonezilla flash drive, and start your computer. &nbsp;You may need to change your BIOS options to allow booting from the flash drive.</li>
<li>The Clonezilla boot menu will pop up. &nbsp;For most systems, just press enter. &nbsp;In my case, the only option that would successfully boot was "(Default settings, KMS)"</li>
<li>You can press Enter to the language and keyboard prompts.</li>
<li>Select<strong> Start Clonezilla</strong> and press Enter.</li>
<li>Select <strong>Device-Device</strong> and press Enter.</li>
<li>When asked what mode you want to run in, select&nbsp;<strong>Expert</strong> and press Enter.</li>
<li>Select <strong>disk_to_Local_disk</strong> and press Enter.</li>
<li>The next few screens will have you select the source disk, the target disk, and prompt you with a large list of steps you can choose to do to the drive. &nbsp;When the large list pops up, <strong>uncheck the option to install grub</strong> (for a Windows partiton, you don't need it.)</li>
<li>All of the other steps in the wizard, leave it&nbsp;set to the defaults and press Enter,&nbsp;<strong>except for the step that asks what you want to do after the clone.</strong>&nbsp; On this step, select "Power Off" and press Enter.</li>
<li>Once everything is configured, Clonezilla will ask you <strong>twice</strong> if you're sure you want to clone the drive. &nbsp;Confirm away, and the clone process will start. &nbsp;Once the system powers off, proceed to Step 4</li>
</ol>
<p><strong>Step 5 - Make Windows bootable again</strong></p>
<ol>
<li>With the machine powered off, remove the original storage device. &nbsp;THIS IS A MUST! &nbsp;With GPT-based drives, there is a GUID that identifies which partition Windows should boot from. &nbsp;Since you cloned the drive, there's now two drives with identical GUID's.</li>
<li>Insert the Windows 10 Installer flash drive and power on the computer.</li>
<li>Once booted into the Installer, select your language and click Next.</li>
<li>Down in the lower left corner, select "Repair my computer."</li>
<li>Click&nbsp;Troubleshoot -&gt; Advanced options -&gt; Command Prompt</li>
<li>Type "diskpart" and press enter.</li>
<li>Type "list disk", press enter, find the number of your new storage device, and type "select disk x" (replacing x with the number of the drive) and press enter.</li>
<li>Type "select partition 1" and press enter (partition 1 is your EFI boot partition.)</li>
<li>Type "assign" and press enter.</li>
<li>Type "exit" and press enter.</li>
<li>If your new storage device is the only drive on your system, type "D:" and press enter. &nbsp;Then type "dir" and press enter, and you should see an EFI folder. &nbsp;If not, continue to try other drives above "D:", like "E:", "F:" etc. until you find one with an EFI folder. &nbsp;Don't use "X:", as that's the flash drive.</li>
<li>Once you find the EFI folder, type "cd EFI\Microsoft\Boot" and press enter.</li>
<li>Now, type "bcdedit /store bcd" and press enter. &nbsp;Most systems will have 2 sections listed, one for {bootmgr} and one for {default}. &nbsp;In most cases, you want to modify the {default} section. &nbsp;We're going to tell the Windows bootloader how to find the correct boot partition.</li>
<li>Type "bcdedit /store bcd /set {default} <strong>device</strong> partition=C:" and press enter.</li>
<li>Type "bcdedit /store bcd /set {default} <strong>osdevice</strong> partition=C:" and press enter.</li>
<li>Now that the BCD has been fixed, install the drivers you downloaded in step 1 by typing&nbsp;"dism /image:C:\ /add-driver /driver:C:\nvme" and press enter. &nbsp;The reason you have to do this is&nbsp;your original hard drive was on a completely different bus, and the driver needed to read from the new drive (and continue the boot process) is missing. &nbsp;This installs the driver so the boot process can find it.</li>
<li>Type "exit", restart the system, and pull out the flash drive.</li>
</ol>
<p>If everything goes as planned, you'll be looking at&nbsp;the Windows 10 login screen from your new storage device. &nbsp;:-)</p>
<p>If you wish to use the old drive for storage, I would recommend&nbsp;either creating a new partition table/formatting the drive from a different PC. &nbsp;The GUID's are still identical, and may cause your system to either boot from the wrong drive, or cause your new drive to not boot at all.</p>
