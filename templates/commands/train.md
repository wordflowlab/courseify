---
description: Persona 训练 - 从专栏中自动提取作者教学风格
argument-hint: [专栏名] | --scan-all | (留空进入交互模式)
scripts:
  sh: ../../scripts/bash/train.sh
  ps1: ../../scripts/powershell/train.ps1
---

# /train - Persona 训练系统 🎓

> **核心理念**: 从你的专栏资料中自动提取作者教学风格,生成 persona 配置
> **目标**: 让 AI 能够模拟该作者的教学方式辅助你创作

---

## 第一步: 运行脚本 ⚠️ 必须执行

### 根据用户参数执行对应操作

```bash
# AI 操作: 根据用户输入执行对应脚本
# /train → bash scripts/bash/train.sh
# /train Flutter核心技术与实战 → bash scripts/bash/train.sh "Flutter核心技术与实战"
# /train --scan-all → bash scripts/bash/train.sh --scan-all
```

---

## 第二步: 根据操作类型处理 ⚠️ 必须执行

### 操作 A: 交互式向导 (用户未指定专栏)

如果返回 `action === "interactive"`:

**展示可用专栏列表**:

```
╔══════════════════════════════════════════════════════════╗
║            🎓 Persona 训练向导                              ║
╚══════════════════════════════════════════════════════════╝

发现 [total_courses] 个专栏,可用于训练 Persona。

从返回的 JSON data.courses 中提取专栏信息,展示:

【1. [name]】
  • 领域: [field]
  • 难度: [level]
  • 章节: [chapter_count] 讲

【2. [name]】
  ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 训练建议:

1. 优先训练你最熟悉的专栏
2. 选择与你要创作的课程同领域的专栏
3. 可以训练多个专栏,后续根据需要激活

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

请选择要训练的专栏 (输入序号或专栏名称):
  • 输入单个序号: 1
  • 输入多个序号: 1,3,5
  • 输入专栏名: Flutter核心技术与实战
  • 训练全部: all

请选择:
```

**⚠️ 等待用户选择**

用户选择后:
- 如果选择单个,跳转到操作 B
- 如果选择多个或 all,跳转到操作 C

---

### 操作 B: 训练单个专栏

如果返回 `action === "analyze"`:

#### 第1步: 展示分析信息

```
╔══════════════════════════════════════════════════════════╗
║            📊 分析专栏: [column.name]                       ║
╚══════════════════════════════════════════════════════════╝

专栏信息:
  • 领域: [column.field]
  • 难度: [column.level]
  • 章节数: [analysis_data.total_chapters] 讲

正在分析...
  ✓ 读取章节列表
  ✓ 采样 [analysis_data.sample_count] 个章节
  ✓ 提取教学特征

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 第2步: AI 深度分析 ⚠️ 核心任务

**重要**: 这是最关键的步骤,AI 必须仔细分析专栏数据。

**输入数据**:
- `column`: 专栏基本信息
- `analysis_data.chapter_files`: 所有章节文件名列表
- `analysis_data.sample_content`: 采样章节的内容

**分析任务**:

##### 2.1 章节结构分析

**目标**: 识别课程的阶段划分模式

分析 `chapter_files` 列表,识别是否有明显的分阶段模式:
- 是否有"开篇词"、"结束语"?
- 是否有"预习篇"、"基础篇"、"进阶篇"、"实战篇"等分段?
- 章节数量分布如何?(前期密集还是均匀分布)

**提取**:
```yaml
preferred_course_structure:
  - name: "阶段名称"
    purpose: "该阶段的目标"
    characteristics: "教学特点"
```

##### 2.2 标题风格分析

**目标**: 识别章节标题的命名模式

遍历 `chapter_files`,分析标题模式:
- **问题式**: "为什么...?" "怎么...?" "如何...?"
- **陈述式**: "XX的原理" "XX实战" "XX深入解析"
- **场景式**: "遇到XX怎么办?" "XX问题分析"

**统计**: 各种模式的占比

**提取**:
```yaml
title_style:
  pattern: "主导模式(问题式/陈述式/场景式)"
  examples:
    - "实际标题示例1"
    - "实际标题示例2"
    - "实际标题示例3"
```

##### 2.3 内容组织分析

**目标**: 分析章节内容的组织结构

分析 `sample_content` 中的采样章节:
- 是否有明显的 Why → What → How 结构?
- 是否以问题/场景开头?
- 理论讲解和实战演示的比例?
- 案例密度 (平均每章几个案例)?

**提取**:
```yaml
content_organization:
  standard_flow:
    - step: "步骤名称(如:问题引入)"
      content: "该步骤的内容类型"

  content_balance:
    theory: XX  # 理论占比
    practice: XX  # 实战占比
    case_study: XX  # 案例占比
    summary: XX  # 总结占比
```

##### 2.4 教学元素识别

**目标**: 识别标志性的教学元素

在 `sample_content` 中搜索:
- 是否每讲都有"思考题"?
- 是否有"知识点回顾"、"本章总结"?
- 是否有"练习题"、"实战任务"?
- 是否有特殊标记 (如📌、⚠️、💡)?

**提取**:
```yaml
signature_elements:
  must_have:
    - element: "元素名称(如:思考题)"
      format: "具体格式"
      purpose: "作用说明"
```

##### 2.5 教学理念推断

**目标**: 从内容中推断作者的教学理念

基于以上分析,总结作者的教学哲学:
- 强调什么? (原理/实战/案例/思考)
- 教学顺序偏好? (理论先行 vs 问题驱动)
- 学习方式? (被动接受 vs 主动思考)

**提取**:
```yaml
teaching_philosophy:
  - "理念1"
  - "理念2"
  - "理念3"
```

#### 第3步: 生成 facilitation_prompts ⚠️ 最重要

**这是 persona 的核心**,决定了 AI 如何以该作者的风格辅助创作。

基于以上分析,为 3 个场景生成具体的指导提示词:

##### 3.1 when_designing_outline

**场景**: 用户执行 `/outline` 时

**提示词内容**:
- 建议采用该作者的章节结构模式
- 推荐该作者的标题风格
- 强调该作者重视的内容比例

**格式**:
```yaml
when_designing_outline: |
  【以 [作者名] 的风格辅助设计大纲】

  1. 📚 结构建议:
     建议采用"[该作者的阶段划分模式]"
     例如: [具体说明]

  2. 📝 标题风格:
     推荐使用"[该作者的标题模式]"
     例如: [具体示例]

  3. 📊 内容比例:
     理论XX% + 实战XX% + 案例XX% + 思考XX%

  4. ✨ 特色元素:
     [该作者的标志性元素,如每讲必有思考题]
```

##### 3.2 when_creating_content

**场景**: 用户执行 `/content` 时

**提示词内容**:
- 指导按该作者的内容组织流程创作
- 强调该作者的写作重点
- 提醒包含标志性元素

**格式**:
```yaml
when_creating_content: |
  【以 [作者名] 的风格创作内容】

  1. [步骤1名称] (XX%)
     - [具体指导]

  2. [步骤2名称] (XX%)
     - [具体指导]

  3. [步骤3名称] (XX%)
     - [具体指导]

  4. [步骤4名称] (XX%)
     - [具体指导]

  💡 不要忘记: [标志性元素提醒]
```

##### 3.3 when_reviewing_quality

**场景**: 用户执行 `/review` 时

**提示词内容**:
- 用该作者的质量标准检查
- 评估是否符合该作者的风格特征

**格式**:
```yaml
when_reviewing_quality: |
  【以 [作者名] 的标准评估质量】

  1. [评估维度1]
     - 是否...?
     - 是否...?

  2. [评估维度2]
     - 是否...?
     - 是否...?

  3. [评估维度3]
     - 是否...?
     - 是否...?
```

#### 第4步: 生成完整的 persona.yaml

**组装所有提取的数据**,生成完整配置:

```yaml
# [专栏名] - 教学风格配置

author:
  name: "[从专栏名推断作者名,或使用专栏名]"
  course: "[专栏名]"
  role: "[根据内容推断角色,如'数据库专家']"
  background: "[可选,如果能从内容推断]"

persona:
  identity: |
    我是[作者名/专栏名],专注[领域]。
    我相信[从教学理念总结的核心信念]。

  teaching_philosophy:
    - "[理念1]"
    - "[理念2]"
    - "[理念3]"

  communication_style: |
    [从内容风格总结,如"深入浅出,善用类比"]

structure_patterns:
  preferred_course_structure:
    - name: "[阶段1]"
      purpose: "[目标]"
      characteristics: "[特点]"
    # ... 更多阶段

  title_style:
    pattern: "[模式]"
    examples:
      - "[示例1]"
      - "[示例2]"
      - "[示例3]"

content_organization:
  standard_flow:
    - step: "[步骤1]"
      content: "[内容描述]"
    # ... 更多步骤

  content_balance:
    theory: [数字]
    practice: [数字]
    case_study: [数字]
    summary: [数字]

signature_elements:
  must_have:
    - element: "[元素1]"
      format: "[格式]"
      purpose: "[作用]"
    # ... 更多元素

  preferred_teaching_methods:
    - "[方法1]"
    - "[方法2]"

quality_standards:
  - "[标准1]"
  - "[标准2]"
  - "[标准3]"

facilitation_prompts:
  when_designing_outline: |
    [完整的指导提示词]

  when_creating_content: |
    [完整的指导提示词]

  when_reviewing_quality: |
    [完整的指导提示词]
```

#### 第5步: 保存 persona 配置

**AI 操作**: 使用 Write 工具保存

```bash
# 生成文件名 (规范化)
# 示例: "Flutter核心技术与实战" → "flutter-core-tech.yaml"
```

**文件路径**: `reference-courses/personas/[文件名].yaml`

#### 第6步: 展示训练结果

```
╔══════════════════════════════════════════════════════════╗
║            ✅ Persona 训练完成!                             ║
╚══════════════════════════════════════════════════════════╝

📁 已保存: reference-courses/personas/[文件名].yaml

🎭 作者风格特征:
  • 教学理念: [总结 teaching_philosophy]
  • 章节结构: [总结 structure_patterns]
  • 标题风格: [总结 title_style]
  • 标志元素: [总结 signature_elements]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 接下来你可以:

  /mimic list      - 查看所有可用 persona
  /mimic activate [专栏名] - 激活该 persona
  /outline         - 以该风格设计大纲

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**任务完成** ✅

---

### 操作 C: 批量训练 (--scan-all)

如果返回 `action === "scan_all"`:

**展示批量训练界面**:

```
╔══════════════════════════════════════════════════════════╗
║            🚀 批量训练模式                                   ║
╚══════════════════════════════════════════════════════════╝

发现 [total_courses] 个专栏,将逐个分析训练。

这可能需要一些时间,请耐心等待...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**AI 操作**: 对返回的每个专栏:
1. 调用 `bash scripts/bash/train.sh "[专栏名]"`
2. 获取分析数据
3. 按操作 B 的流程生成 persona
4. 显示进度

```
[1/17] 正在分析: Flutter核心技术与实战...
✅ 已生成: flutter-core-tech.yaml

[2/17] 正在分析: MySQL实战45讲...
✅ 已生成: mysql-45.yaml

...

[17/17] 正在分析: Kubernetes核心原理...
✅ 已生成: k8s-core.yaml

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 批量训练完成!

✅ 成功训练 17 个 persona
📁 保存位置: reference-courses/personas/

💡 使用方法:
  /mimic list  - 查看所有 persona
  /mimic activate [专栏名] - 激活使用

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**任务完成** ✅

---

## 错误处理

### 如果 status === "error"

#### 错误类型 1: no_columns

```
❌ 错误: 未找到专栏数据

请先将专栏资料复制到 reference-courses/ 目录:

  cp -r ~/Downloads/专栏/* reference-courses/

然后运行扫描脚本生成索引:

  bash scripts/bash/scan-references.sh

最后再运行训练:

  /train
```

#### 错误类型 2: no_index

```
❌ 错误: 未找到专栏索引文件

请先运行扫描脚本生成索引:

  bash scripts/bash/scan-references.sh
```

#### 错误类型 3: not_found

```
❌ 错误: 未找到专栏 "[专栏名]"

请检查专栏名称是否正确,或使用交互模式查看所有可用专栏:

  /train
```

---

## 重要提醒 ⚠️

### AI 的职责

1. **深度分析**: 仔细阅读采样内容,准确识别教学模式
2. **准确提取**: 提取真实存在的特征,不要臆造
3. **生成提示词**: facilitation_prompts 要具体可操作
4. **保持中立**: 不要加入主观评价,只描述客观特征

### 分析原则

1. **基于事实**: 所有结论必须基于实际分析的内容
2. **模式识别**: 寻找重复出现的模式和规律
3. **适度抽象**: 既要保留特色,又要有一定通用性
4. **可操作性**: facilitation_prompts 要让 AI 能直接应用

### 质量标准

一个好的 persona 应该:
- ✅ 准确反映该作者的教学风格
- ✅ facilitation_prompts 具体可操作
- ✅ 包含足够的示例和说明
- ✅ 适用于该领域的课程设计

---

## 使用示例

```bash
# 场景 1: 首次使用,交互式选择
/train
# → 看到所有专栏列表
# → 选择 1,3,5 训练 3 个
# → AI 逐个分析并生成

# 场景 2: 训练指定专栏
/train Flutter核心技术与实战
# → AI 分析该专栏
# → 生成 flutter-core-tech.yaml

# 场景 3: 批量训练所有专栏
/train --scan-all
# → AI 分析所有 17 个专栏
# → 生成 17 个 persona.yaml
```

---

**开始执行第一步** ⬇️
