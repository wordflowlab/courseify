# 内容质量评估

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json

# 检查是否有大纲
$outlineFile = Join-Path $projectDir "outline.md"
$hasOutline = Test-Path $outlineFile
$outlineContent = ""
if ($hasOutline) {
    $outlineContent = Get-FileContentAsJson $outlineFile
}

# 检查是否有章节内容
$chaptersDir = Join-Path $projectDir "chapters"
$hasChapters = $false
$chaptersCount = 0
if (Test-Path $chaptersDir) {
    $mdFiles = Get-ChildItem -Path $chaptersDir -Filter "*.md"
    $chaptersCount = $mdFiles.Count
    if ($chaptersCount -gt 0) {
        $hasChapters = $true
    }
}

$result = @{
    status = "success"
    action = "review"
    project_name = $projectName
    spec = $specContent
    has_outline = $hasOutline
    outline_content = $outlineContent
    has_chapters = $hasChapters
    chapters_count = $chaptersCount
    message = "AI 应对课程内容进行质量评估"
} | ConvertTo-Json -Compress -Depth 10

Write-Output $result
