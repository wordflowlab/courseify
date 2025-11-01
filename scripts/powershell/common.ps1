# Courseify 通用函数库 (PowerShell版本)

# 查找 courseify 项目根目录（向上查找 .courseify/config.json）
function Get-CurrentProject {
    $currentDir = Get-Location

    while ($currentDir.Path -ne [System.IO.Path]::GetPathRoot($currentDir.Path)) {
        $configPath = Join-Path $currentDir.Path ".courseify\config.json"
        if (Test-Path $configPath) {
            return $currentDir.Path
        }
        $currentDir = Split-Path $currentDir.Path -Parent
    }

    # 如果没找到，返回当前目录
    return (Get-Location).Path
}

# 获取项目名称
function Get-ProjectName {
    $projectDir = Get-CurrentProject
    return Split-Path $projectDir -Leaf
}

# 检查 spec.json 是否存在
function Test-SpecExists {
    $projectDir = Get-CurrentProject
    $specFile = Join-Path $projectDir "spec.json"

    if (-not (Test-Path $specFile)) {
        $error = @{
            status = "error"
            message = "未找到 spec.json。请先运行 /spec 命令定义课程规格。"
        } | ConvertTo-Json -Compress
        Write-Output $error
        exit 1
    }

    return $specFile
}

# 检查 objective.json 是否存在
function Test-ObjectiveExists {
    $projectDir = Get-CurrentProject
    $objectiveFile = Join-Path $projectDir "objective.json"

    if (-not (Test-Path $objectiveFile)) {
        $error = @{
            status = "error"
            message = "未找到 objective.json。请先运行 /objective 命令设定学习目标。"
        } | ConvertTo-Json -Compress
        Write-Output $error
        exit 1
    }

    return $objectiveFile
}

# 检查 structure.json 是否存在
function Test-StructureExists {
    $projectDir = Get-CurrentProject
    $structureFile = Join-Path $projectDir "structure.json"

    if (-not (Test-Path $structureFile)) {
        $error = @{
            status = "error"
            message = "未找到 structure.json。请先运行 /structure 命令设计课程结构。"
        } | ConvertTo-Json -Compress
        Write-Output $error
        exit 1
    }

    return $structureFile
}

# 输出 JSON 格式结果
function Write-JsonOutput {
    param([string]$JsonString)
    Write-Output $JsonString
}

# 转义 JSON 字符串中的特殊字符
function ConvertTo-EscapedJson {
    param([string]$String)

    $String = $String -replace '\\', '\\'
    $String = $String -replace '"', '\"'
    $String = $String -replace "`n", '\n'
    $String = $String -replace "`t", '\t'
    $String = $String -replace "`r", '\r'

    return $String
}

# 读取文件内容并转义为 JSON 字符串
function Get-FileContentAsJson {
    param([string]$FilePath)

    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw
        return ConvertTo-EscapedJson $content
    }

    return ""
}

# 获取当前时间戳 (ISO 8601)
function Get-CurrentTimestamp {
    return (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
}

# 确保目录存在
function Ensure-Directory {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

# 统计文件行数（排除空行和注释）
function Get-FileLineCount {
    param([string]$FilePath)

    if (Test-Path $FilePath) {
        $lines = Get-Content $FilePath | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' }
        return $lines.Count
    }

    return 0
}

# 错误处理
function Write-ErrorExit {
    param([string]$Message)

    $error = @{
        status = "error"
        message = (ConvertTo-EscapedJson $Message)
    } | ConvertTo-Json -Compress

    Write-Output $error
    exit 1
}

# 成功输出
function Write-SuccessOutput {
    param(
        [string]$Message,
        [hashtable]$Data = @{}
    )

    $output = @{
        status = "success"
        message = (ConvertTo-EscapedJson $Message)
    }

    foreach ($key in $Data.Keys) {
        $output[$key] = $Data[$key]
    }

    Write-Output ($output | ConvertTo-Json -Compress -Depth 10)
}
