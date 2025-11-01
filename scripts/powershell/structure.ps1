# 设计课程结构

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists
$objectiveFile = Test-ObjectiveExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$structureFile = Join-Path $projectDir "structure.json"

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json
$objectiveContent = Get-Content $objectiveFile -Raw | ConvertFrom-Json

# 如果已有结构文件
if (Test-Path $structureFile) {
    $existingStructure = Get-Content $structureFile -Raw | ConvertFrom-Json

    $result = @{
        status = "success"
        action = "update"
        project_name = $projectName
        structure_file = $structureFile
        spec = $specContent
        objective = $objectiveContent
        existing_structure = $existingStructure
        message = "找到现有课程结构，AI 可引导用户更新"
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
} else {
    # 创建初始模板
    $template = @{
        total_duration = ""
        chapters = @()
    } | ConvertTo-Json -Depth 10

    $template | Set-Content $structureFile -Encoding UTF8

    $result = @{
        status = "success"
        action = "create"
        project_name = $projectName
        structure_file = $structureFile
        spec = $specContent
        objective = $objectiveContent
        message = "已创建课程结构模板，AI 应引导用户设计章节和课时"
        guidance = @{
            total_duration = "课程总时长(如 '10小时' 或 '30课时')"
            chapters = "章节列表，每章包含: chapter_number, title, duration, lessons[]"
        }
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
}
