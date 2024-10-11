[xml]$blogML = Get-Content -Path "BlogML.xml"

# Iterate through each post and create a markdown file
foreach ($post in $blogML.blog.posts.post) {
    $title = $post.title.'#cdata-section'

    $title = $post.title.'#cdata-section'
    $content = $post.content.'#cdata-section'
    $author = $post.authors.author.ref
    $dateCreated = [datetime]$post.'date-created'

    $markdownContent = $content
    $markdownContent = "# $title`n`n**Author:** $author`n<br/>**Date:** $dateCreated`n`n$markdownContent"
    
    # Create a filename based on the post title
    $fileName = ($title -replace '\s+', '-')
    $fileName = ($fileName -replace '\\', '-')
    $fileName = ($fileName -replace '\/', '-')
    $fileName = "$($fileName -replace '\?+', '-').md".ToLower()
    $filePath = Join-Path -Path (Get-Location) -ChildPath "blog" -AdditionalChildPath $fileName

    # Write the markdown content to the file
    $markdownContent | Out-File -FilePath $filePath -Encoding utf8
}