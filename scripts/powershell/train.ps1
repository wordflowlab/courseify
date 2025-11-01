# Courseify - Persona 训练脚本 (PowerShell版本)

param(
    [string]$Action
)

# 导入通用函数
. "$PSScriptRoot\common.ps1"

$projectDir = Get-CurrentProject
$columnsDir = Join-Path $projectDir "reference-courses"
$personasDir = Join-Path $columnsDir "personas"
$manifestFile = Join-Path $personasDir "manifest.json"

# 确保 personas 目录存在
if (-not (Test-Path $personasDir)) {
    New-Item -ItemType Directory -Path $personasDir -Force | Out-Null
}

# 检查是否有专栏数据
$hasColumns = $false
if (Test-Path $columnsDir) {
    $items = Get-ChildItem -Path $columnsDir -Exclude "personas", "index.json", "README.md", ".gitkeep"
    if ($items.Count -gt 0) {
        $hasColumns = $true
    }
}

if (-not $hasColumns) {
    $error = @{
        status = "error"
        action = "no_columns"
        message = "未找到专栏数据"
        suggestion = "请先将专栏资料复制到 reference-courses/ 目录"
        help = @{
            step1 = "cp -r ~/Downloads/专栏/* reference-courses/"
            step2 = "bash scripts/bash/scan-references.sh"
            step3 = "bash scripts/bash/train.sh"
        }
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 读取索引文件
$indexFile = Join-Path $columnsDir "index.json"
if (-not (Test-Path $indexFile)) {
    $error = @{
        status = "error"
        action = "no_index"
        message = "未找到专栏索引文件"
        suggestion = "请先运行扫描脚本生成索引"
        command = "bash scripts/bash/scan-references.sh"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

# 函数: 分析单个专栏
function Analyze-Column {
    param(
        [string]$ColumnPath,
        [string]$ColumnName
    )

    # 读取专栏目录下的所有 MD 文件
    $mdFiles = Get-ChildItem -Path $ColumnPath -Filter "*.md" | Sort-Object Name

    if ($mdFiles.Count -eq 0) {
        Write-Error "未找到章节文件"
        return $null
    }

    # 提取章节列表
    $chapters = @()
    foreach ($file in $mdFiles) {
        $chapters += $file.Name
    }

    # 采样读取章节内容
    $total = $mdFiles.Count
    $sampleIndices = @(0)  # 第1章

    # 中间章
    if ($total -gt 10) {
        $sampleIndices += [math]::Floor($total / 3)
        $sampleIndices += [math]::Floor($total / 2)
        $sampleIndices += [math]::Floor($total * 2 / 3)
    }
    elseif ($total -gt 5) {
        $sampleIndices += [math]::Floor($total / 2)
    }

    # 最后章
    if ($total -gt 1) {
        $sampleIndices += $total - 1
    }

    # 读取采样章节内容
    $sampleContent = ""
    foreach ($idx in $sampleIndices) {
        $file = $mdFiles[$idx]
        $content = Get-Content -Path $file.FullName -TotalCount 200 -Raw

        $sampleContent += "【章节: $($file.Name)】`n"
        $sampleContent += "$content`n"
        $sampleContent += "`n---`n`n"
    }

    # 从 index.json 读取专栏信息
    $indexData = Get-Content $indexFile -Raw | ConvertFrom-Json
    $columnInfo = $indexData.courses | Where-Object { $_.name -eq $ColumnName }

    if ($null -eq $columnInfo) {
        Write-Error "未在索引中找到该专栏"
        return $null
    }

    # 返回分析数据
    $result = @{
        status = "success"
        action = "analyze"
        column = @{
            name = $ColumnName
            field = $columnInfo.field
            level = $columnInfo.level
            chapter_count = $columnInfo.chapter_count
            path = $ColumnPath
        }
        analysis_data = @{
            total_chapters = $mdFiles.Count
            chapter_files = $chapters
            sample_count = $sampleIndices.Count
            sample_content = $sampleContent
        }
        instruction = "AI 请分析以上数据,生成 persona.yaml 配置"
    }

    return $result
}

# 主逻辑
switch ($Action) {
    "--scan-all" {
        # 批量扫描所有专栏
        $indexData = Get-Content $indexFile -Raw | ConvertFrom-Json
        $courses = $indexData.courses | ForEach-Object { $_.name }
        $courseCount = $courses.Count

        $result = @{
            status = "success"
            action = "scan_all"
            total_courses = $courseCount
            courses = $courses
            instruction = "AI 请逐个分析这些专栏,为每个生成 persona"
        } | ConvertTo-Json -Depth 10
        Write-Output $result
    }

    "" {
        # 交互式向导
        $indexData = Get-Content $indexFile -Raw | ConvertFrom-Json
        $courses = @()
        foreach ($course in $indexData.courses) {
            $courses += @{
                name = $course.name
                field = $course.field
                level = $course.level
                chapter_count = $course.chapter_count
            }
        }

        $result = @{
            status = "success"
            action = "interactive"
            total_courses = $courses.Count
            courses = $courses
            instruction = "AI 请引导用户选择要训练的专栏"
        } | ConvertTo-Json -Depth 10
        Write-Output $result
    }

    default {
        # 训练指定专栏
        $columnName = $Action

        # 查找专栏路径
        $indexData = Get-Content $indexFile -Raw | ConvertFrom-Json
        $columnInfo = $indexData.courses | Where-Object { $_.name -eq $columnName }

        if ($null -eq $columnInfo) {
            $error = @{
                status = "error"
                action = "not_found"
                message = "未找到专栏: $columnName"
                suggestion = "使用 /train 查看所有可用专栏"
            } | ConvertTo-Json -Depth 10
            Write-Output $error
            exit 1
        }

        $columnPath = Join-Path $projectDir $columnInfo.path

        # 分析专栏
        $analysisResult = Analyze-Column -ColumnPath $columnPath -ColumnName $columnName
        if ($null -ne $analysisResult) {
            $analysisResult | ConvertTo-Json -Depth 10 | Write-Output
        }
    }
}
