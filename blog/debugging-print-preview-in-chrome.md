# Debugging print preview in Chrome

**Author:** Joe
<br/>**Date:** 06/12/2014 13:28:00

<p>Every web developer has had to deal with this.&nbsp; Open up the print stylesheet…make some tweaks…open browser…open print preview…close print preview…make more tweaks…open print preview…etc.&nbsp; And yeah yeah yeah…there is a way to emulate the print css in the browser, but that doesn’t do squat when trying to adjust content to fit the width of whatever page standard you’re supporting (letter/A4/etc.)</p>  <p>Well, here’s a bit of a shortcut for at least the closing/opening of print preview.&nbsp; Open the print preview window, right click on the preview, and click “Inspect Element”.</p>  <p>Go into the javascript console, and paste this in:</p>  <pre class="brush: c#;">setInterval(function() {
    this.printPreview.previewArea_.previewGenerator_.pageRanges_ = null;
    this.printPreview.previewArea_.previewGenerator_.requestPreview();
}, 3000)</pre>

<p>&nbsp;</p>

<p>That will refresh your print preview window every 3 seconds.&nbsp; My plan is to expand on this, and make it a Chrome plug-in that listens using an observer.</p>
