# TFS Team Room - Chrome popup notifications

**Author:** Joe
<br/>**Date:** 03/14/2014 09:03:00

Are you getting tired of flipping back and forth between Team Room chats and your day-to-day coding tasks?&nbsp; Well, you'll enjoy this post!  <div>   <br></div>  <div>The following TamperMonkey script will tap into the guts of the TFS Team Room, intercept each post, and display it in a nice Chrome desktop notification.</div>  <div>   <br></div>  <div style="text-align: center"><img style="float: none; line-height: 1.4285" src="/FILES%2f2014%2f03%2fawesomeness.jpg.axdx"></div>  <div style="text-align: center">   <br></div>  <div style="text-align: left">   <ol>     <li><span style="line-height: 1.4285">Install the <a href="https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=en">TamperMonkey </a>plugin into Chrome</span></li>      <li><span style="line-height: 1.4285">Add a new user script, and paste the code below into the script window</span></li>      <li><span style="line-height: 1.4285">Profit!</span></li>   </ol>    <div><b>Note</b> - you may have to change your notification settings to get this script to function properly:</div>    <div><a href="https://support.google.com/chrome/answer/3220216?hl=en">https://support.google.com/chrome/answer/3220216?hl=en</a></div>    <div>     <br></div>    <div><b>Known bugs/issues</b> (will be fixed in a future release):</div>    <div>     <ul>       <li>This script only works for Visual Studio Online.&nbsp; If you want it to work with your internal TFS servers, change the @match url in the comment block at the top.</li>        <li>When anyone is tagged, the message will stay open until you close it</li>        <li>TFS notifications won't display correctly (like check-ins, people entering/leaving rooms, etc.)&nbsp; For example, when a check-in against a task occurs, all you'll see is "Task 1234 has changed", with no other details.</li>        <li>Clicking on a notification doesn't focus on the tab that issued it.&nbsp; This feature will be added in a future release.</li>     </ul>   </div> </div>  <div style="text-align: center">   <br></div>  <div>   <pre class="brush: js;">// ==UserScript==
// @name       TFS Team Room notifications in Chrome
// @namespace  http://nuts4.net
// @version    0.51
// @description Getting tired of switching back and forth between a browser and Visual Studio...just to see if you have any chat notifications?  Use this script, and get your notifications directly on your desktop!
// @match      https://*.visualstudio.com/_rooms*
// @copyright  2013+, Joe Coutcher
// ==/UserScript==
 
// Bookmarklet to activate Chrome notifications on TFS Team Room Chat
$(function() {
    if (window.webkitNotifications.checkPermission() != 0) {
        window.webkitNotifications.requestPermission();
    }
    
    console.log("TFS Notifications - Setting up 10 second delay...");
    // Activate the plugin after 10 seconds
    window.setTimeout(function() {
        $.connection.chatHub.on('messageReceived', function(roomId, message) {
            var messageNotification = function(image, title, content) {
                var _notification = window.webkitNotifications.createNotification(_tfsIcon, title, content);
                _notification.show();
                
                // If you are mentioned in the chat, keep it displayed until you actively close it.
                if (message.Mentions.length == 0) {
                    window.setTimeout(function() {
                        _notification.cancel();
                    }, 5000);
                }
            };
            
            if (message.PostedByUserTfId != $.connection.chatHub.state.id) {
                if (message.Content.indexOf("{") == 0) {
                    var _tfsServerIcon = "/_static/tfs/20131021T164530/_content/tfs-large-icons.png";
                    var serverMessage = $.parseJSON(message.Content);
                    messageNotification(_tfsServerIcon, serverMessage.type, serverMessage.title);
                } else {
                    var _tfsIcon = "/_api/_common/IdentityImage?id=" + message.PostedByUserTfId;
                    
                    if (window.webkitNotifications.checkPermission() == 0) {
                        messageNotification(_tfsIcon, message.PostedByUserName, message.Content);
                    }
                }
            }
        });
        console.log("TFS Notification code has loaded.");
    }, 10000);
});</pre>
</div>
