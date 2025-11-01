# 生成课程大纲(支持三种模式)

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 检查前置条件
$specFile = Test-SpecExists
$objectiveFile = Test-ObjectiveExists
$structureFile = Test-StructureExists

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName
$outlineFile = Join-Path $projectDir "outline.md"
$modeFile = Join-Path $projectDir ".courseify\creation_mode"

# 解析命令行参数
$mode = "coach"
for ($i = 0; $i -lt $args.Count; $i++) {
    if ($args[$i] -eq "--mode" -and $i + 1 -lt $args.Count) {
        $mode = $args[$i + 1]
        $i++
    }
}

# 读取配置
$specContent = Get-Content $specFile -Raw | ConvertFrom-Json
$objectiveContent = Get-Content $objectiveFile -Raw | ConvertFrom-Json
$structureContent = Get-Content $structureFile -Raw | ConvertFrom-Json

# 保存创作模式
Ensure-Directory (Join-Path $projectDir ".courseify")
$mode | Set-Content $modeFile -Encoding UTF8

# 如果已有大纲文件
if (Test-Path $outlineFile) {
    $result = @{
        status = "success"
        action = "review"
        project_name = $projectName
        outline_file = $outlineFile
        mode = $mode
        spec = $specContent
        objective = $objectiveContent
        structure = $structureContent
        message = "找到现有大纲，AI 可引导用户修改或审阅"
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
} else {
    # 创建初始模板
    $template = @"
# $projectName - 课程大纲

> 创作模式: $mode

## 课程概述

## 章节大纲

"@

    $template | Set-Content $outlineFile -Encoding UTF8

    $result = @{
        status = "success"
        action = "create"
        project_name = $projectName
        outline_file = $outlineFile
        mode = $mode
        spec = $specContent
        objective = $objectiveContent
        structure = $structureContent
        message = "已创建大纲模板，AI 应根据模式($mode)引导用户创作"
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
}
