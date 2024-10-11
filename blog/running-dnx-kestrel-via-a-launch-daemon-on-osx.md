# Running DNX/Kestrel via a Launch Daemon on OSX

**Author:** Joe
<br/>**Date:** 02/01/2016 14:05:00

<p>While .NET Core is meant to help .NET developers implement cross-platform solutions, there's not a whole lot of documentation about how to get your ASP.NET Core websites up and running as a daemon service.</p>
<p>These are the steps I performed to start my Kestrel website on system start-up. &nbsp;They may be more than what's needed, but what can you expect? &nbsp;Setting up ASP.NET websites on platforms other than Windows is uncharted waters. :-)</p>
<p>What you'll need to do is the following:</p>
<ol>
<li>Set up your <a href="http://johnpapa.net/getting-started-with-asp-net-5-on-osx/">DNVM/DNU/DNX environment via brew</a>.</li>
<li>Set up a user account in System Preferences -&gt; Users and Groups. &nbsp;This account will be the account your daemon runs under. &nbsp;In this example, it'll be "testuser".</li>
<li>Create the folder "/usr/local/netcore" and grant the "testuser" account read/write/execute access (you can lock down access later as needed.)</li>
<li>Add the following file into /Library/LaunchDaemons. &nbsp;Modify the Label and UserName values to reflect your own site. &nbsp;Save the file with the same name as your label, but with ".plist" appended (i.e. "com.nuts4net.testsite.plist") &nbsp;This will tell OSX's launchd process to run your service on startup, and restart it in the event it crashes.<br />
<pre class="brush:xml;auto-links:false;toolbar:false" contenteditable="false">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"&gt;
&lt;plist version="1.0"&gt;
    &lt;dict&gt;
        &lt;key&gt;Label&lt;/key&gt;
        &lt;string&gt;com.nuts4net.testsite&lt;/string&gt;
        &lt;key&gt;UserName&lt;/key&gt;
        &lt;string&gt;testuser&lt;/key&gt;
        &lt;key&gt;ProgramArguments&lt;/key&gt;
        &lt;array&gt;
            &lt;string&gt;/bin/bash&lt;/string&gt;
            &lt;string&gt;/usr/local/netcore/testsite/run-site.sh&lt;/string&gt;
        &lt;/array&gt;
        &lt;key&gt;RunAtLoad&lt;/key&gt;
        &lt;true/&gt;
        &lt;key&gt;KeepAlive&lt;/key&gt;
        &lt;true/&gt;
    &lt;/dict&gt;
&lt;/plist&gt;</pre>
<p>&nbsp;</p>
</li>
<li>Deploy your web code to the /usr/local/netcore folder. &nbsp;In the plist example above, my code sits in "testsite".</li>
<li>Create a script called "run-site.sh" with the following contents, place it in /usr/local/netcore/testsite, make it executable by yourself and root:<br />
<pre class="brush:bash;auto-links:false;toolbar:false" contenteditable="false">source /usr/local/Cellar/dnvm/1.0.0-dev/bin/dnvm.sh
cd /usr/local/netcore/testsite
dnx web</pre>
</li>
<li>Open up a terminal window, and type the following:<br />
<pre class="brush:bash;auto-links:false;toolbar:false" contenteditable="false">sudo launchctl load -w /Library/LaunchDaemons/org.nuts4net.testsite</pre>
</li>
<li>Open up the Console app, and filter to "org.nuts4net.testsite". &nbsp;If everything worked, you should see the initial start-up of the script. &nbsp;If you see issues about the script failing, and re-starting in 10 seconds, execute the following command in your terminal window to stop the service so you can investigate:<br />
<pre class="brush:bash;auto-links:false;toolbar:false" contenteditable="false">sudo launchctl load -w /Library/LaunchDaemons/org.nuts4net.testsite</pre>
</li>
</ol>
<p>Let me know in the comments if you run into any issues, notice something I missed, or have improvements to this process. &nbsp;I'm by no means an OSX guy...just know enough to be dangerous with it. &nbsp;;-)</p>
