# 生成视频脚本

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$scriptsDir = Join-Path $projectDir "scripts_output"

# 确保脚本目录存在
Ensure-Directory $scriptsDir

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json

# 检查是否有章节内容
$chaptersDir = Join-Path $projectDir "chapters"
$hasChapters = Test-Path $chaptersDir

$result = @{
    status = "success"
    action = "create_scripts"
    project_name = $projectName
    scripts_dir = $scriptsDir
    spec = $specContent
    has_chapters = $hasChapters
    message = "AI 应引导用户生成视频录制脚本"
} | ConvertTo-Json -Compress -Depth 10

Write-Output $result
