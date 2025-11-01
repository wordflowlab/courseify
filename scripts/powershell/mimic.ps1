# Courseify - 风格模拟脚本 (PowerShell版本)

param(
    [string]$Action,
    [string]$AuthorId
)

# 导入通用函数
. "$PSScriptRoot\common.ps1"

$projectDir = Get-CurrentProject
$personasDir = Join-Path $projectDir "reference-courses\personas"
$manifestFile = Join-Path $personasDir "manifest.json"
$activePersonaDir = Join-Path $projectDir ".courseify"
$activePersonaFile = Join-Path $activePersonaDir "active-persona.yaml"

# 确保配置目录存在
if (-not (Test-Path $activePersonaDir)) {
    New-Item -ItemType Directory -Path $activePersonaDir -Force | Out-Null
}

# 检查 personas 目录
if (-not (Test-Path $personasDir)) {
    $error = @{
        status = "error"
        message = "未找到 personas 目录,请先添加作者配置"
        action = "setup_needed"
    } | ConvertTo-Json -Depth 10
    Write-Output $error
    exit 1
}

switch ($Action) {
    "list" {
        # 列出所有可用的作者 persona
        if (-not (Test-Path $manifestFile)) {
            $error = @{
                status = "error"
                message = "未找到 manifest.json,请先扫描专栏"
            } | ConvertTo-Json -Depth 10
            Write-Output $error
            exit 1
        }

        $personasJson = Get-Content $manifestFile -Raw | ConvertFrom-Json
        $result = @{
            status = "success"
            action = "list"
            data = $personasJson
        } | ConvertTo-Json -Depth 10
        Write-Output $result
    }

    "activate" {
        # 激活某个作者的风格
        if ([string]::IsNullOrEmpty($AuthorId)) {
            $error = @{
                status = "error"
                message = "请指定作者ID或名称"
            } | ConvertTo-Json -Depth 10
            Write-Output $error
            exit 1
        }

        # 查找匹配的 persona
        $personaFile = $null

        # 先尝试精确匹配ID
        $candidateFile = Join-Path $personasDir "$AuthorId.yaml"
        if (Test-Path $candidateFile) {
            $personaFile = $candidateFile
        }
        else {
            # 尝试从 manifest 中查找
            if (Test-Path $manifestFile) {
                $manifest = Get-Content $manifestFile -Raw | ConvertFrom-Json

                # 通过 ID 查找
                $persona = $manifest.personas | Where-Object { $_.id -eq $AuthorId }

                if ($null -eq $persona) {
                    # 通过名称查找 (不区分大小写)
                    $persona = $manifest.personas | Where-Object {
                        $_.name -like "*$AuthorId*"
                    } | Select-Object -First 1
                }

                if ($null -ne $persona) {
                    $personaFile = Join-Path $personasDir $persona.config_file
                }
            }
        }

        if ([string]::IsNullOrEmpty($personaFile) -or -not (Test-Path $personaFile)) {
            $error = @{
                status = "error"
                message = "未找到作者: $AuthorId"
                suggestion = "使用 /mimic list 查看可用作者"
            } | ConvertTo-Json -Depth 10
            Write-Output $error
            exit 1
        }

        # 复制 persona 配置到激活文件
        Copy-Item -Path $personaFile -Destination $activePersonaFile -Force

        $result = @{
            status = "success"
            action = "activate"
            persona_file = $activePersonaFile
            message = "已激活作者风格,请AI加载并解析配置"
        } | ConvertTo-Json -Depth 10
        Write-Output $result
    }

    "deactivate" {
        # 退出风格模拟
        if (Test-Path $activePersonaFile) {
            Remove-Item -Path $activePersonaFile -Force
            $result = @{
                status = "success"
                action = "deactivate"
                message = "已退出风格模拟"
            } | ConvertTo-Json -Depth 10
            Write-Output $result
        }
        else {
            $result = @{
                status = "info"
                action = "deactivate"
                message = "当前未激活任何风格"
            } | ConvertTo-Json -Depth 10
            Write-Output $result
        }
    }

    "status" {
        # 查看当前激活的风格
        if (Test-Path $activePersonaFile) {
            $result = @{
                status = "success"
                action = "status"
                active = $true
                persona_file = $activePersonaFile
            } | ConvertTo-Json -Depth 10
            Write-Output $result
        }
        else {
            $result = @{
                status = "success"
                action = "status"
                active = $false
                message = "当前未激活任何风格"
            } | ConvertTo-Json -Depth 10
            Write-Output $result
        }
    }

    default {
        # 显示使用帮助
        $error = @{
            status = "error"
            message = "未知操作: $Action"
            usage = @{
                list = "/mimic list - 列出所有可用作者"
                activate = "/mimic activate <作者名> - 激活某个作者的风格"
                deactivate = "/mimic deactivate - 退出风格模拟"
                status = "/mimic status - 查看当前激活的风格"
            }
        } | ConvertTo-Json -Depth 10
        Write-Output $error
        exit 1
    }
}
