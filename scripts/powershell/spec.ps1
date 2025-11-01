# 定义/更新课程规格

# 加载通用函数库
. "$PSScriptRoot\common.ps1"

# 获取项目路径
$projectDir = Get-CurrentProject
$projectName = Get-ProjectName

$specFile = Join-Path $projectDir "spec.json"
$configFile = Join-Path $projectDir ".courseify\config.json"

# 读取 config.json 中的 defaultField (如果存在)
$defaultField = ""
if (Test-Path $configFile) {
    $config = Get-Content $configFile | ConvertFrom-Json
    $defaultField = $config.defaultField
}

# 如果已有配置，读取现有配置
if (Test-Path $specFile) {
    $existingConfig = Get-Content $specFile -Raw

    $result = @{
        status = "success"
        action = "update"
        project_name = $projectName
        project_path = $projectDir
        spec_file = $specFile
        existing_config = ($existingConfig | ConvertFrom-Json)
        message = "找到现有配置，AI 可引导用户更新"
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
} else {
    # 创建初始配置模板
    $timestamp = Get-CurrentTimestamp

    $template = @{
        course_name = $projectName
        field = $defaultField
        level = ""
        duration = ""
        audience = ""
        format = ""
        platforms = @()
        language = ""
        created_at = $timestamp
        updated_at = $timestamp
    } | ConvertTo-Json -Depth 10

    $template | Set-Content $specFile -Encoding UTF8

    $result = @{
        status = "success"
        action = "create"
        project_name = $projectName
        project_path = $projectDir
        spec_file = $specFile
        default_field = $defaultField
        message = "已创建配置模板，AI 应引导用户填写"
        required_fields = @(
            "field (领域): 编程开发/设计创意/商业管理/语言学习等",
            "level (难度): 入门/进阶/高级",
            "duration (时长): 如 '10小时' 或 '30课时'",
            "audience (受众): 学生/职场新人/职场老手/专业人士等",
            "format (格式): video/text/audio/mixed",
            "platforms (平台): 网易云课堂/腾讯课堂/B站/Notion/飞书等",
            "language (语言): 中文/英文/双语"
        )
    } | ConvertTo-Json -Compress -Depth 10

    Write-Output $result
}
