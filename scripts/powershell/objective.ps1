# 设定学习目标

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$objectiveFile = Join-Path $projectDir "objective.json"

# 读取 spec 配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json

# 如果已有目标文件
if (Test-Path $objectiveFile) {
    $existingObjective = Get-Content $objectiveFile -Raw | ConvertFrom-Json

    $result = @{
        status = "success"
        action = "update"
        project_name = $projectName
        objective_file = $objectiveFile
        spec = $specContent
        existing_objective = $existingObjective
        message = "找到现有学习目标，AI 可引导用户更新"
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
} else {
    # 创建初始模板
    $template = @{
        knowledge = @()
        skills = @()
        outcomes = @()
    } | ConvertTo-Json -Depth 10

    $template | Set-Content $objectiveFile -Encoding UTF8

    $result = @{
        status = "success"
        action = "create"
        project_name = $projectName
        objective_file = $objectiveFile
        spec = $specContent
        message = "已创建学习目标模板，AI 应引导用户填写"
        guidance = @{
            knowledge = "学员将学到的知识点列表"
            skills = "学员将掌握的技能列表"
            outcomes = "学完后能够做到的具体成果"
        }
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
}
