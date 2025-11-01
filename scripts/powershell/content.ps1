# 创作章节内容

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists
$structureFile = Test-StructureExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$chaptersDir = Join-Path $projectDir "chapters"

# 确保章节目录存在
Ensure-Directory $chaptersDir

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json
$structureContent = Get-Content $structureFile -Raw | ConvertFrom-Json

# 检查大纲文件
$outlineFile = Join-Path $projectDir "outline.md"
$outlineExists = Test-Path $outlineFile
$outlineContent = ""
if ($outlineExists) {
    $outlineContent = Get-FileContentAsJson $outlineFile
}

$result = @{
    status = "success"
    action = "create_content"
    project_name = $projectName
    chapters_dir = $chaptersDir
    spec = $specContent
    structure = $structureContent
    outline_exists = $outlineExists
    outline_content = $outlineContent
    message = "AI 应引导用户逐章创作内容"
} | ConvertTo-Json -Compress -Depth 10

Write-Output $result
