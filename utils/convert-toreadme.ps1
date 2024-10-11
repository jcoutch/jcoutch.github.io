[xml]$blogML = Get-Content -Path "BlogML.xml"

# Sort posts by date-created
$sortedPosts = $blogML.blog.posts.post | Sort-Object -Descending { [datetime]$_.'date-created' }

# Initialize markdown content
$markdownContent = "# Blog Posts`n`n"

# Iterate through each sorted post and append to markdown content
foreach ($post in $sortedPosts) {
    $title = $post.title.'#cdata-section'
    $dateCreated = [datetime]$post.'date-created'
    
    # Create a filename based on the post title
    $fileName = ($title -replace '\s+', '-')
    $fileName = ($fileName -replace '\\', '-')
    $fileName = ($fileName -replace '\/', '-')
    $fileName = "$($fileName -replace '\?+', '-').md".ToLower()

    # Create a relative URL
    $relativeUrl = "blog/$fileName"
    
    $markdownContent += "* [$title]($relativeUrl) - $dateCreated`n"
}

# Output markdown content to a file
$markdownContent | Out-File -FilePath "blog_posts.md" -Encoding utf8