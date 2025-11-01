# 生成练习题

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists
$structureFile = Test-StructureExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$exercisesDir = Join-Path $projectDir "exercises"

# 确保练习题目录存在
Ensure-Directory $exercisesDir

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json
$structureContent = Get-Content $structureFile -Raw | ConvertFrom-Json

$result = @{
    status = "success"
    action = "create_exercises"
    project_name = $projectName
    exercises_dir = $exercisesDir
    spec = $specContent
    structure = $structureContent
    message = "AI 应引导用户为每章生成练习题"
} | ConvertTo-Json -Compress -Depth 10

Write-Output $result
