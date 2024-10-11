# HACK: Force VT-x to be always on when booting to Windows on your MacBook

**Author:** Joe
<br/>**Date:** 04/05/2016 14:55:00

<p><span style="color: #ff0000;"><strong>Warning:</strong> While this worked on my 15" MacBook Pro (mid 2014, EMC 2881), and newer models based on the comments below, this messes with the Model Specific Registers on your Intel processor.&nbsp; Also, this&nbsp;WILL NOT WORK&nbsp;on AMD-based systems...should Apple ever release one.&nbsp; Before proceeding, ensure that rEFInd&nbsp;is supported for your specific Mac/processor.&nbsp; By following any of the steps outlined below, you agree to not hold me liable for any damages. &nbsp;You've been warned!</span></p>
<p>Ok, if you're at this point, you've agreed to chance fate. &nbsp;So, I got fed up that Apple's UEFI BIOS doesn't set VT-x enabled by default when a Boot Camp partition is started by default. &nbsp;Having to boot into OS X, then reboot into Windows just so I can use Hyper-V/Docker is a huge time suck, and a bit ridiculous.</p>
<p>I sat out to find a solution, and had a hard time digging up information. &nbsp;I stumbled upon a possible solution from 10 years ago using rEFIt, an EFI-based shell from ArchLinux, and some hacky EFI app to enable it, but the hacky solution only works for 32-bit mode...not 64-bit.</p>
<p>After researching about rEFIt, I found a newer version called rEFInd. &nbsp;Turns out, it has the option to enable VT-x and lock it when it starts up. &nbsp;If you're not familiar with rEFInd, it's a boot loader (similar to Grub) that is specifically built for EFI-based systems. &nbsp;By using this bootloader to start Windows, VT-x will be enabled before the Windows kernel gets started, and Hyper-V will always work without a reboot into OS X.</p>
<ol>
<li>Go here and download rEFInd (the zip version):&nbsp;<a href="http://www.rodsbooks.com/refind/getting.html">http://www.rodsbooks.com/refind/getting.html</a></li>
<li>Extract the zip&nbsp;to a folder, open the refind folder and edit refind.conf-sample.</li>
<li>In refind.conf-sample:<br /> Set the timeout to 5 seconds (or whatever you want)<br /> Find enable_and_lock_vmx, uncomment the line and set it to true <strong><span style="color: #ff0000;">(HERE BE DRAGONS)</span></strong></li>
<li>Shut down your computer.</li>
<li>After powering back up, press and hold Command+R before the chime/apple logo appears to boot into Apple Recovery.</li>
<li>Once in Apple Recovery, go to Utilities -&gt; Terminal, and execute the following to disable System Integrity Protection (necessary for writing to the EFI -&nbsp;<a href="http://www.rodsbooks.com/refind/sip.html">http://www.rodsbooks.com/refind/sip.html</a>)
<blockquote>csrutil disable</blockquote>
</li>
<li>Reboot into your normal OSX installation, and open a terminal window</li>
<li>Navigate to the folder where you extracted rEFInd, and run
<blockquote>./refind-install</blockquote>
</li>
<li>Note: The installer will copy the refind.conf-sample file to EFI/refind/refind.conf on your ESP partition. &nbsp;If you need to change settings later on, you'll have to mount the partition first (use the first two commands from the uninstall instructions below to mount it.)</li>
<li>Reboot your Mac and go back into recovery mode by pressing Command+R. (Now, your Mac may freeze. If it does, press and hold the power button until the LCD turns off, then turn it back on.)</li>
<li>Once in Apple Recovery, go to Utilities -&gt; Terminal, and execute the following to turn back on System Integrity Protection
<blockquote>csrutil enable</blockquote>
</li>
<li>Reboot your Mac</li>
</ol>
<p>You'll be greeted by a GUI bootloader menu, which will load whatever&nbsp;OS you sat as your default. &nbsp;In my case, this was Windows, and Hyper-V worked flawlessly from a cold boot!</p>
<p><strong><span style="line-height: 1.8;">Troubleshooting:</span></strong></p>
<p><span style="line-height: 1.8;">If for some reason rEFInd is not working, power off the Mac, hold the Option key and power back on. Keep holding Option until you get to the UEFI bootloader menu, and you can boot back into OSX.</span></p>
<p>If you change your default boot OS via Boot Camp, it may stop rEFInd from loading in the future. Just re-run the installer after changing the default boot OS, and it should fix the issue.</p>
<p><strong>Uninstall:</strong></p>
<p>If you need to uninstall rEFInd, boot back into Apple Recovery, go to Terminal, and (assuming your EFI partition is disk0s1) run the following:</p>
<pre class="brush:bash;auto-links:false;toolbar:false" contenteditable="false">mkdir /Volumes/ESP
mount -t msdos /dev/disk0s1 /Volumes/ESP
rm -R -f /Volumes/ESP/EFI/refind
umount /Volumes/ESP

</pre>
<p><span style="line-height: 1.8;">Once that's complete, exit Terminal, click on the Apple menu in the upper left corner, and open Startup Disk. Select the disk you want to start by default, and reboot.</span></p>
