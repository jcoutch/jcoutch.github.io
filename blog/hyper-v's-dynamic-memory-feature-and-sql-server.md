# Hyper-V's Dynamic Memory feature and SQL Server

**Author:** Joe
<br/>**Date:** 01/15/2018 12:58:00

<p>While attempting to deploy a fresh copy of a Visual Studio database project to my SQL Server 2017 instance in Hyper-V VM, I ran into this error when attempting to create a column store index:</p>
<pre><span style="color: #ff0000;">A timeout occurred while waiting for memory resources to execute the query in resource pool 'default'</span></pre>
<p>After running across <a href="https://www.sqlskills.com/blogs/joe/the-case-of-the-columnstore-index-and-the-memory-grant/" target="_blank">Joe Sack's post over at SQL Skills</a>, I decided to try increasing my VM's RAM from 8 GB to 11.5 GB (the max I had available.)&nbsp; I tried executing the CREATE COLUMNSTORE INDEX command again, and after 25 seconds, it timed out with the same error.</p>
<p>I checked the resource pool allocation requests, and the CREATE statement was trying to allocate 140 MB of RAM...which should've been available after the memory increase.</p>
<p>So, I checked Task Manager, and it said I only had 5.6 GB of RAM installed in the guest VM.&nbsp; Say whaaaat?!?</p>
<p>Turns out, if your Hyper-V VM has the Dynamic Memory feature turned on, SQL Server won't request additional memory from the Hypervisor when it's close to the current "hardware max" value, which resulted in the timeouts I was seeing.&nbsp; So, I shut down my VM, turned off the Dynamic Memory feature in the Memory section of my VM settings, restarted it, and the CREATE statement executed in a fraction of a second.</p>
<p>In my case, this is fine, since this VM is a development environment on my local machine, but for those who are using SQL Server on a Hyper-V VM, definitely review <a href="https://msdn.microsoft.com/en-us/library/hh372970.aspx" target="_blank">Microsoft's recommendations for using Dynamic Memory on the guest OS</a> (the only article I could find.)</p>
