# AngularJS templates with the benefits of Razor

**Author:** Joe
<br/>**Date:** 03/14/2014 23:54:00

<p>While talking with co-workers about some AngularJS code we wrote to use in an MVC project, we wanted to have the benefits of server side processing in our templates.&nbsp; Typically, AngularJS templates are static .html pages...but I'm going to blow your mind...and show you a slick way to utilize Razor views as your templates.</p>  <p>You might be wondering, "Why use Razor?"&nbsp; Well, here's a few reasons:</p>  <ul>   <li>You can define concrete routes to actions/controllers by utilizing Html.ActionLink, Html.Content, etc., reducing the likelihood of malformed/bad links, and gaining the benefits of having it run through .NET routing. </li>    <li>Server-side localization of templates.&nbsp; I've never been a huge fan of i18n scripts for localization in Javascript. </li>    <li>Change out templates on the fly based on the user's roles and enable/disable certain features on the server side. </li> </ul>  <p>So, now that I got you salivating over the possibilities, let's take a look at how to implement such magic:</p>  <pre class="brush: c#;">    public class BaseController : Controller
    {
        public ActionResult AngularTemplate(string id)
        {
            var templateName = id;

            // Verify template path contains no path operators
            if (templateName.Any("/\\".Contains) &amp;&amp; !templateName.Contains(".."))
                return HttpNotFound();

            // Append .template to the end of the template name
            return View(templateName + ".template");
        }
    }</pre>

<p>&nbsp;</p>

<p>What we’re doing above is creating a base controller class that all of our controllers will implement.&nbsp; Within the base controller, there is a shared action that will retrieve a template, process it, and spit it back out to Angular.</p>

<p>Then, let’s say you have a controller named MyController in an area called MyArea, and you have routing set up as the standard /{Controller}/{Action}/{id} scheme.&nbsp; When you set your Angular template url to “/MyArea/MyController/AngularTemplate/CoolTemplate”, that fires off a call to the shared AngularTemplate action, verifies there are no path identifiers, and tells the view engine to search for a template named CoolTemplate.template.cshtml using the defined search patterns (i.e. /MyArea/Views/MyController, /MyArea/Views/Shared, /Views/Shared, etc.)</p>

<p>Pretty slick, huh?&nbsp; And the implementation doesn’t have to use a shared action in a base controller, you can utilize standard actions.&nbsp; This just makes it more dynamic in my opinion, with the benefit of keeping Angular templates located alongside your standard MVC views.</p>
