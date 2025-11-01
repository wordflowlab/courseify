# Courseify - 参考课程推荐脚本 (PowerShell版本)

# 导入通用函数
. "$PSScriptRoot\common.ps1"

$projectDir = Get-CurrentProject
$columnsDir = Join-Path $projectDir "reference-courses"
$indexFile = Join-Path $columnsDir "index.json"
$specFile = Join-Path $projectDir "spec.json"

# 检查参考课程索引
if (-not (Test-Path $indexFile)) {
    $error = @{
        status = "error"
        message = "未找到参考课程索引"
        suggestion = "请先运行扫描脚本生成索引"
        command = "bash scripts/bash/scan-references.sh"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 检查课程规格
if (-not (Test-Path $specFile)) {
    $error = @{
        status = "error"
        message = "未找到课程规格"
        suggestion = "请先运行 /spec 命令定义课程"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 读取数据
$indexData = Get-Content $indexFile -Raw | ConvertFrom-Json
$specData = Get-Content $specFile -Raw | ConvertFrom-Json

# 返回数据给 AI
$result = @{
    status = "success"
    spec = $specData
    reference_courses = $indexData
    instruction = "AI 请根据 spec 推荐 Top 3 最相关的参考课程"
} | ConvertTo-Json -Depth 10

Write-Output $result
