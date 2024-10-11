# Windows Terminal - Run as Administrator by default

**Author:** Joe
<br/>**Date:** 07/15/2019 07:45:00

<p>I was excited to try out the new <a href="https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701" target="_blank">Windows Terminal</a>&nbsp;preview build in the Microsoft Store, since I had&nbsp;downloaded/compiled earlier builds and fell in love with it!</p>
<p>Unfortunately, since the app is distributed in a UWP package, Microsoft decided that shortcuts to UWP apps can't be made to run as an administrator.&nbsp; For developers such as myself that pretty much live in an administrative PowerShell prompt, having to right click the icon every time to run as an administrator is a huge time suck.&nbsp; So, I searched for a workaround:</p>
<ol>
<li>Right click on your desktop, and click New -&gt; Shortcut</li>
<li>For the location, type in the following and click next:<br /><code><span style="font-family: Roboto, Verdana, Arial, Helvetica, sans-serif;">&nbsp;&nbsp;</span>C:\Windows\system32\cmd.exe /c start /b wt</code></li>
<li>For the name, type in "Windows Terminal", and click Next.</li>
<li>Now, right click on the new shortcut, and click Properties.</li>
<li>On the Shortcut tab, click Advanced, and click "Run as Administrator"</li>
</ol>
<p>You'll now have a shortcut you can drag onto your task bar that'll launch&nbsp;Windows Terminal as an admin!</p>
<p>Also, if you want to change the shortcut icon to the one provided by Windows Terminal, it can be downloaded from the GitHub repo:<br /><a href="https://github.com/microsoft/terminal/blob/master/res/terminal.ico">https://github.com/microsoft/terminal/blob/master/res/terminal.ico</a></p>
