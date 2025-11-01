# 导出到多平台

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$exportsDir = Join-Path $projectDir "exports"

# 确保导出目录存在
Ensure-Directory $exportsDir
Ensure-Directory (Join-Path $exportsDir "notion")
Ensure-Directory (Join-Path $exportsDir "feishu")
Ensure-Directory (Join-Path $exportsDir "netease")

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json

# 检查可导出的内容
$hasOutline = Test-Path (Join-Path $projectDir "outline.md")

$chaptersDir = Join-Path $projectDir "chapters"
$hasChapters = $false
if (Test-Path $chaptersDir) {
    $mdFiles = Get-ChildItem -Path $chaptersDir -Filter "*.md"
    if ($mdFiles.Count -gt 0) {
        $hasChapters = $true
    }
}

$exercisesDir = Join-Path $projectDir "exercises"
$hasExercises = $false
if (Test-Path $exercisesDir) {
    $files = Get-ChildItem -Path $exercisesDir
    if ($files.Count -gt 0) {
        $hasExercises = $true
    }
}

$scriptsOutputDir = Join-Path $projectDir "scripts_output"
$hasScripts = $false
if (Test-Path $scriptsOutputDir) {
    $files = Get-ChildItem -Path $scriptsOutputDir
    if ($files.Count -gt 0) {
        $hasScripts = $true
    }
}

$result = @{
    status = "success"
    action = "export"
    project_name = $projectName
    exports_dir = $exportsDir
    spec = $specContent
    exportable_content = @{
        outline = $hasOutline
        chapters = $hasChapters
        exercises = $hasExercises
        scripts = $hasScripts
    }
    message = "AI 应引导用户选择导出平台和格式"
} | ConvertTo-Json -Compress -Depth 10

Write-Output $result
