# 生成课程大纲 - 分章生成模式

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists
$objectiveFile = Test-ObjectiveExists
$structureFile = Test-StructureExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$outlinesDir = Join-Path $projectDir "outlines"
$progressFile = Join-Path $projectDir ".courseify\outline-progress.json"

# 确保 outlines 目录存在
Ensure-Directory $outlinesDir

# 解析命令行参数
$chapter = $null
$fromChapter = $null
$retryChapter = $null
$continue = $false

for ($i = 0; $i -lt $args.Count; $i++) {
    switch ($args[$i]) {
        "--chapter" {
            if ($i + 1 -lt $args.Count) {
                $chapter = [int]$args[$i + 1]
                $i++
            }
        }
        "--from" {
            if ($i + 1 -lt $args.Count) {
                $fromChapter = [int]$args[$i + 1]
                $i++
            }
        }
        "--retry" {
            if ($i + 1 -lt $args.Count) {
                $retryChapter = [int]$args[$i + 1]
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
$objectiveContent = Get-Content $objectiveFile -Raw | ConvertFrom-Json
$structureContent = Get-Content $structureFile -Raw | ConvertFrom-Json

# 获取总章节数
$totalChapters = $structureContent.chapters.Count

# 读取或初始化进度文件
if (Test-Path $progressFile) {
    $progressContent = Get-Content $progressFile -Raw | ConvertFrom-Json
    $completedChapters = $progressContent.completed -join ","
    $currentChapter = $progressContent.current
    $failedChapters = $progressContent.failed -join ","
} else {
    $completedChapters = ""
    $currentChapter = 1
    $failedChapters = ""
    # 创建初始进度文件
    Ensure-Directory (Join-Path $projectDir ".courseify")
    $initialProgress = @{
        total_chapters = $totalChapters
        completed = @()
        current = 1
        failed = @()
        updated_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    $initialProgress | ConvertTo-Json -Depth 10 | Set-Content $progressFile -Encoding UTF8
}

# 处理特定章节生成
if ($null -ne $chapter) {
    $currentChapter = $chapter
} elseif ($null -ne $fromChapter) {
    $currentChapter = $fromChapter
} elseif ($null -ne $retryChapter) {
    $currentChapter = $retryChapter
} elseif ($continue) {
    # 使用进度文件中的当前章节
    $currentChapter = $currentChapter
}

# 输出给 AI 的 JSON
$result = @{
    status = "success"
    action = "generate_outline"
    project_name = $projectName
    outlines_dir = $outlinesDir
    total_chapters = $totalChapters
    completed_chapters = $completedChapters
    current_chapter = $currentChapter
    failed_chapters = $failedChapters
    spec = $specContent
    objective = $objectiveContent
    structure = $structureContent
    progress_file = $progressFile
    message = "AI 应逐章生成大纲,每章保存到独立文件"
}

$result | ConvertTo-Json -Compress -Depth 10
