# Courseify - 专栏分析脚本 (PowerShell版本)

param(
    [string]$CourseName
)

# 导入通用函数
. "$PSScriptRoot\common.ps1"

$projectDir = Get-CurrentProject
$columnsDir = Join-Path $projectDir "reference-courses"
$indexFile = Join-Path $columnsDir "index.json"

# 检查索引文件
if (-not (Test-Path $indexFile)) {
    $error = @{
        status = "error"
        message = "未找到参考课程索引"
        suggestion = "请先运行扫描脚本"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 检查参数
if ([string]::IsNullOrEmpty($CourseName)) {
    $error = @{
        status = "error"
        message = "请指定要分析的专栏名称"
        usage = "/analyze <专栏名>"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 读取索引
$indexData = Get-Content $indexFile -Raw | ConvertFrom-Json

# 查找专栏
$course = $indexData.courses | Where-Object { $_.name -eq $CourseName }

if ($null -eq $course) {
    $error = @{
        status = "error"
        message = "未找到专栏: $CourseName"
        suggestion = "使用 /reference 查看所有可用专栏"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 读取专栏章节
$coursePath = Join-Path $projectDir $course.path
$chapters = Get-ChildItem -Path $coursePath -Filter "*.md" | Sort-Object Name

$chapterList = @()
foreach ($chapter in $chapters) {
    $chapterList += @{
        number = $chapter.BaseName
        title = $chapter.Name
        filename = $chapter.Name
    }
}

# 返回分析数据
$result = @{
    status = "success"
    course = $course
    chapters = $chapterList
    instruction = "AI 请深入分析该专栏的章节结构和教学设计"
} | ConvertTo-Json -Depth 10

Write-Output $result
