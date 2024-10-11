# Chosen dropdown speed for hundreds of dropdowns

**Author:** Joe
<br/>**Date:** 09/22/2015 07:09:00

This doesn't come up that often (because it's often poor UI practice to have a bazillion dropdowns on a page), but thought I'd write up a post about it.<div><br></div><div>When trying to apply Chosen to a page with hundreds of dropdowns, you may notice it takes forever to render. &nbsp;This is because of the way jQuery works. &nbsp;When you use a selector on elements and call .chosen() on it, jQuery will internally call the .chosen() method on each select, which causes the DOM to be manipulated for each select, and causes the browser to have to recalculate styling after each select is processed.</div><div><br></div><div><div><pre class="brush:html" style="line-height: 1.42857;">&lt;div id="selectArea"&gt;&lt;/div&gt;</pre><pre class="brush:javascript" style="line-height: 1.42857;"><span style="line-height: 1.42857;">var testString = "";
for(var i = 0; i &lt; 800; i++)
    testString += "&lt;select name='crapola" + i + "'&gt;&lt;option&gt;" + i + "&lt;/option&gt;&lt;/select&gt;&lt;br/&gt;";

</span><span style="line-height: 18.5714px;">$("#selectArea").html(testString);
$("select").chosen();
</span></pre></div></div><div><span style="line-height: 18.5714px;"><br></span></div><div>What does this mean speed-wise? &nbsp;For rendering 800 dropdowns, it's roughly 1.7 seconds on a MacBook Pro with an i7 processor. &nbsp;That's too long to require the user to wait IMO. &nbsp;You can test the results on your own machine using this fiddle:</div><div><a href="https://jsfiddle.net/pku5fbf4/2/">https://jsfiddle.net/pku5fbf4/2/</a></div><div><br></div><div>To get around this, you can render your dropdowns in an off-page node, and append them back in once Chosen has done it's stuff. &nbsp;An example of this code is here:</div><div><a href="https://jsfiddle.net/73z2kxsg/4/">https://jsfiddle.net/73z2kxsg/4/</a></div><div><br></div><pre class="brush:html">&lt;div id="selectArea"&gt;&lt;/div&gt;</pre><pre class="brush:javascript">var testString = "";
for(var i = 0; i &lt; 800; i++)
    testString += "&lt;select name='crapola" + i + "'&gt;&lt;option&gt;" + i + "&lt;/option&gt;&lt;/select&gt;&lt;br/&gt;";

var el = $("&lt;div&gt;&lt;/div&gt;").html(testString);
$("select", el).chosen({width: '100%'});
$("#selectArea").append($(el).children());
</pre><div>You'll notice this performs substantially faster (between .5 and .7 seconds total) to render the dropdowns. &nbsp;Since the dropdowns are rendered outside of the DOM, the browser doesn't need to re-process the layout for each dropdown. &nbsp;When we append the selects back into the DOM, it only has to process the layout once, and since it's an append, the events on the Chosen elements are preserved. &nbsp;In fact, this pseudo "shadow DOM" is similar to how UI frameworks like <a href="https://facebook.github.io/react/">React</a> operate.</div><div><br></div><div>As I stated from the beginning of this post, you may want to re-think your UI if you have a ton of dropdowns on your page...but if you're in a pinch and need immediate performance improvements, you can apply this method. &nbsp;It should also work with other control frameworks like Select2 and Semantic UI.</div>
