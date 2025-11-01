# 创作章节内容 - 分课时生成模式

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists
$structureFile = Test-StructureExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$chaptersDir = Join-Path $projectDir "chapters"
$outlinesDir = Join-Path $projectDir "outlines"
$progressFile = Join-Path $projectDir ".courseify\content-progress.json"

# 确保章节目录存在
Ensure-Directory $chaptersDir

# 解析命令行参数
$chapter = $null
$lesson = $null
$fromChapter = $null
$fromLesson = $null
$retryChapter = $null
$retryLesson = $null
$continue = $false

for ($i = 0; $i -lt $args.Count; $i++) {
    switch ($args[$i]) {
        "--chapter" {
            if ($i + 1 -lt $args.Count) {
                $chapter = [int]$args[$i + 1]
                $i++
            }
        }
        "--lesson" {
            if ($i + 1 -lt $args.Count) {
                $lesson = [int]$args[$i + 1]
                $i++
            }
        }
        "--from-chapter" {
            if ($i + 1 -lt $args.Count) {
                $fromChapter = [int]$args[$i + 1]
                $i++
            }
        }
        "--from-lesson" {
            if ($i + 1 -lt $args.Count) {
                $fromLesson = [int]$args[$i + 1]
                $i++
            }
        }
        "--retry-chapter" {
            if ($i + 1 -lt $args.Count) {
                $retryChapter = [int]$args[$i + 1]
                $i++
            }
        }
        "--retry-lesson" {
            if ($i + 1 -lt $args.Count) {
                $retryLesson = [int]$args[$i + 1]
                $i++
            }
        }
        "--continue" {
            $continue = $true
        }
    }
}

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json
$structureContent = Get-Content $structureFile -Raw | ConvertFrom-Json

# 获取总章节数
$totalChapters = $structureContent.chapters.Count

# 读取大纲文件
$outlineData = @{}
if (Test-Path $outlinesDir) {
    Get-ChildItem -Path $outlinesDir -Filter "chapter-*.md" | ForEach-Object {
        $fileName = $_.BaseName
        $chapterNum = [int]($fileName -replace 'chapter-', '')
        $content = Get-FileContentAsJson $_.FullName
        $outlineData[$chapterNum.ToString()] = $content
    }
}

# 读取或初始化进度文件
if (Test-Path $progressFile) {
    $progressContent = Get-Content $progressFile -Raw | ConvertFrom-Json
    $completedItems = ($progressContent.completed | ForEach-Object { "$($_.chapter):$($_.lesson)" }) -join ","
    $currentChapter = $progressContent.current_chapter
    $currentLesson = $progressContent.current_lesson
    $failedItems = ($progressContent.failed | ForEach-Object { "$($_.chapter):$($_.lesson)" }) -join ","
} else {
    $completedItems = ""
    $currentChapter = 1
    $currentLesson = 1
    $failedItems = ""
    # 创建初始进度文件
    Ensure-Directory (Join-Path $projectDir ".courseify")
    $initialProgress = @{
        total_chapters = $totalChapters
        completed = @()
        current_chapter = 1
        current_lesson = 1
        failed = @()
        updated_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    $initialProgress | ConvertTo-Json -Depth 10 | Set-Content $progressFile -Encoding UTF8
}

# 处理特定章节/课时生成
if ($null -ne $chapter) {
    $currentChapter = $chapter
    if ($null -ne $lesson) {
        $currentLesson = $lesson
    } else {
        $currentLesson = 1
    }
} elseif ($null -ne $fromChapter) {
    $currentChapter = $fromChapter
    if ($null -ne $fromLesson) {
        $currentLesson = $fromLesson
    } else {
        $currentLesson = 1
    }
} elseif ($null -ne $retryChapter) {
    $currentChapter = $retryChapter
    if ($null -ne $retryLesson) {
        $currentLesson = $retryLesson
    } else {
        $currentLesson = 1
    }
} elseif ($continue) {
    # 使用进度文件中的当前位置
    $currentChapter = $currentChapter
    $currentLesson = $currentLesson
}

# 输出给 AI 的 JSON
$result = @{
    status = "success"
    action = "generate_content"
    project_name = $projectName
    chapters_dir = $chaptersDir
    outlines_dir = $outlinesDir
    total_chapters = $totalChapters
    completed_items = $completedItems
    current_chapter = $currentChapter
    current_lesson = $currentLesson
    failed_items = $failedItems
    spec = $specContent
    structure = $structureContent
    outlines = $outlineData
    progress_file = $progressFile
    message = "AI 应逐章逐课时生成内容,每课时保存到独立文件"
}

$result | ConvertTo-Json -Compress -Depth 10
