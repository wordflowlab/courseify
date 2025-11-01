# 风格模拟系统 (Mimic) 使用指南

> **版本**: v0.3.0
> **更新日期**: 2025-11-01

---

## 概述

风格模拟系统 (Mimic) 是 Courseify 的核心功能之一,允许 AI 模拟优秀专栏作者的教学风格,帮助你学习专业课程设计方法,快速提升课程质量。

### 核心理念

- 📚 **学习大师**: 从优秀专栏作者的教学方法中学习
- 🎭 **风格模拟**: AI 以特定作者的方式指导你创作
- 🚀 **快速提升**: 借鉴成熟的课程设计模式
- ✍️ **保持原创**: 学习方法而非照搬内容

---

## 快速开始

### 1. 查看可用作者

```bash
/mimic list
```

系统会展示所有可模拟的专栏作者:

```
╔══════════════════════════════════════════════════════════╗
║              🎭 可模拟的专栏作者                            ║
╚══════════════════════════════════════════════════════════╝

【1. 陈航 - Flutter核心技术与实战】
  • 领域: 编程开发
  • 难度: 高级
  • 风格特点: 技术深入、原理讲解、实战结合

【2. 林晓斌 - MySQL实战45讲】
  • 领域: 编程开发
  • 难度: 进阶
  • 风格特点: 问题驱动、深入浅出、生产案例

【3. 倪朋飞 - Linux性能优化实战】
  • 领域: 编程开发
  • 难度: 进阶
  • 风格特点: 实战为主、工具演示、性能分析

...
```

### 2. 激活作者风格

```bash
/mimic activate 陈航
```

激活成功后会显示作者的教学风格特征:

```
╔══════════════════════════════════════════════════════════╗
║              ✅ 风格模拟已激活                              ║
╚══════════════════════════════════════════════════════════╝

🎭 当前模拟: 陈航 (《Flutter核心技术与实战》)

【作者身份】
我是陈航,Google Flutter团队早期成员。我相信学习技术不应只停留在表面...

【教学理念】
- 原理优先: 先理解why,再学how
- 实战结合: 每个知识点都有实际应用
- 系统化: 构建完整的知识体系
- 循序渐进: 从简单到复杂,稳步提升

【风格特征】
- 章节结构: 预习篇 + 基础篇 + 进阶篇 + 实战篇
- 标题风格: 问题导向,如"为什么要学X?"
- 内容组织: Why(10%) → What(20%) → How(60%) → Think(10%)
- 标志性元素: 每讲必有思考题,强调原理理解

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡ 接下来,AI 将以陈航的风格辅助你创作

你可以:
  /outline   - 以该作者风格设计大纲
  /content   - 以该作者风格创作内容
  /review    - 以该作者标准评估质量
  /mimic deactivate - 退出风格模拟
```

### 3. 使用作者风格创作

激活 Persona 后,执行其他命令时会自动应用该作者的风格:

**设计大纲**:
```bash
/outline
```

AI 会检测到激活的作者风格,并按照该作者的方法引导你设计:
- Express 模式: 生成符合该作者风格的大纲
- Coach 模式: 用该作者的理念引导你思考
- Hybrid 模式: 生成该作者风格的框架供你填充

**创作内容**:
```bash
/content
```

AI 会按照该作者的内容组织方式指导你创作,例如陈航的 "Why → What → How → Think" 结构。

**评估质量**:
```bash
/review
```

AI 会用该作者的质量标准评估你的课程,指出与该作者风格的差距和改进方向。

### 4. 退出风格模拟

```bash
/mimic deactivate
```

退出后,AI 将恢复默认模式,不再模拟特定作者风格。

### 5. 查看当前状态

```bash
/mimic status
```

显示当前是否激活了作者风格,以及激活的是哪位作者。

---

## 可模拟的作者

### 1. 陈航 - Flutter核心技术与实战

**适用场景**:
- 技术类课程(编程、框架、工具)
- 需要深入讲解原理
- 重视实战应用

**风格特点**:
- 📚 结构清晰: 预习篇+基础篇+进阶篇+实战篇
- 🎯 问题导向: 标题使用问题式
- 🔍 原理深入: Why → What → How → Think
- 💡 思考为重: 每讲必有思考题

**最佳实践**:
```bash
# 1. 激活陈航风格
/mimic activate 陈航

# 2. 设计大纲(AI会建议使用4阶段结构)
/outline

# 3. 创作内容(AI会强调Why+What+How+Think)
/content

# 4. 评估质量(AI会检查是否有思考题、原理讲解等)
/review
```

---

### 2. 林晓斌 - MySQL实战45讲

**适用场景**:
- 数据库、系统类课程
- 强调生产环境问题
- 问题驱动学习

**风格特点**:
- 🎯 问题驱动: 从真实问题出发
- 🔍 深入浅出: 用简单语言讲复杂原理
- 📊 案例丰富: 生产环境真实案例
- 🤔 思考引导: 每讲结尾有思考题

**最佳实践**:
```bash
# 适合数据库、系统优化类课程
/mimic activate 林晓斌

# AI 会建议:
# - 每章从一个具体问题开始
# - 用架构图/流程图说明原理
# - 提供生产环境的解决方案
# - 设计检验理解程度的思考题
```

---

### 3. 倪朋飞 - Linux性能优化实战

**适用场景**:
- 性能优化类课程
- 工具使用教学
- 运维、DevOps 课程

**风格特点**:
- 🛠️ 实战为主: 大量工具使用演示
- 📋 步骤清晰: 可操作的分析步骤
- 📊 数据驱动: 命令输出和性能指标
- 🔄 Before/After: 优化效果对比

**最佳实践**:
```bash
# 适合运维、性能优化类课程
/mimic activate 倪朋飞

# AI 会建议:
# - 按系统资源分类(CPU/内存/IO/网络)
# - 每章包含工具使用演示
# - 提供完整的分析步骤
# - 展示优化前后对比
```

---

## 工作原理

### Persona 配置结构

每个作者的风格都保存在 YAML 配置文件中:

```yaml
author:
  name: "陈航"
  course: "Flutter核心技术与实战"

persona:
  identity: "我是陈航,我相信..."
  teaching_philosophy:
    - "原理优先"
    - "实战结合"

structure_patterns:
  preferred_course_structure:
    - name: "预习篇"
      purpose: "建立认知"

  title_style:
    pattern: "问题导向"
    examples:
      - "为什么要学Flutter?"

content_organization:
  standard_flow:
    - step: "为什么 (Why)"
      content: "引发思考"

signature_elements:
  must_have:
    - element: "思考题"
      purpose: "深化理解"

facilitation_prompts:
  when_designing_outline: |
    【以陈航的风格辅助设计大纲】
    1. 建议采用预习篇+基础篇+进阶篇+实战篇
    2. 推荐使用问题导向的标题
    ...

  when_creating_content: |
    【以陈航的风格创作内容】
    1. Why (10%)
    2. What (20%)
    3. How (60%)
    4. Think (10%)
    ...

  when_reviewing_quality: |
    【以陈航的标准评估质量】
    1. 是否有思考题?
    2. 原理讲解是否深入?
    ...
```

### AI 如何应用风格

1. **激活时**:
   - 读取 persona YAML 文件
   - 提取作者信息和风格特征
   - 复制到 `.courseify/active-persona.yaml`

2. **执行命令时**:
   - 检查是否存在 `active-persona.yaml`
   - 如果存在,读取对应的 `facilitation_prompts`
   - 在 AI 的工作流程中注入该提示词

3. **具体应用**:
   - `/outline`: 使用 `when_designing_outline` 提示词
   - `/content`: 使用 `when_creating_content` 提示词
   - `/review`: 使用 `when_reviewing_quality` 提示词

---

## 使用场景

### 场景 1: 学习专业课程设计方法

**问题**: 不知道如何设计一门专业的技术课程

**解决方案**:
```bash
# 1. 激活陈航的风格(技术课程专家)
/mimic activate 陈航

# 2. 使用 coach 模式,学习他的设计思路
/outline

# AI 会参考陈航的方法引导你:
# - 如何划分课程阶段?
# - 如何设计章节标题?
# - 如何平衡理论和实践?
```

---

### 场景 2: 快速生成高质量大纲

**问题**: 需要快速生成一个专业的课程大纲

**解决方案**:
```bash
# 1. 激活想要模拟的作者
/mimic activate 林晓斌

# 2. 使用 express 模式快速生成
/outline

# AI 会生成符合林晓斌风格的大纲:
# - 问题驱动的标题
# - 每章从具体问题开始
# - 深入原理剖析
# - 包含思考题
```

---

### 场景 3: 提升内容质量

**问题**: 已有大纲,但内容质量不确定

**解决方案**:
```bash
# 1. 激活行业标杆作者
/mimic activate 倪朋飞

# 2. 用该作者的标准评估
/review

# AI 会指出:
# - 缺少工具使用演示
# - 分析步骤不够清晰
# - 建议增加 before/after 对比
```

---

### 场景 4: 混合多种风格

**策略**: 可以在不同阶段激活不同作者

```bash
# 大纲设计阶段:参考陈航的系统化结构
/mimic activate 陈航
/outline

# 内容创作阶段:参考林晓斌的案例教学
/mimic deactivate
/mimic activate 林晓斌
/content

# 质量评估阶段:参考倪朋飞的实战标准
/mimic deactivate
/mimic activate 倪朋飞
/review
```

---

## 注意事项

### ✅ 应该这样用

1. **学习方法论**: 学习作者的课程设计思路和教学方法
2. **参考不照搬**: 根据自己的课程特点灵活应用
3. **保持原创**: 内容仍然由你自己创作,AI 只提供方法指导
4. **选择合适的作者**: 根据课程类型选择最匹配的作者风格

### ❌ 不应该这样用

1. **完全照搬**: 不要期望 AI 生成和原作者一模一样的内容
2. **忽视差异**: 你的课程和原专栏有差异,需要灵活调整
3. **过度依赖**: 风格模拟是辅助工具,不能替代你的思考
4. **混淆目标**: 目标是学习方法,而非复制课程

---

## 常见问题

### Q1: 激活作者风格后,AI 会完全按照该作者的方式创作吗?

**A**: 不会。AI 会:
- ✅ 参考该作者的结构模式和教学理念
- ✅ 提供符合该风格的建议
- ❌ 但不会照搬原专栏的具体内容
- ❌ 最终的课程内容仍然由你决定

---

### Q2: 可以同时激活多个作者吗?

**A**: 不可以。同一时间只能激活一个作者,因为:
- 不同作者的风格可能冲突
- 保持风格的一致性
- 建议: 可以在不同阶段切换不同作者

---

### Q3: 我的课程和这些作者的课程类型不同,还能用吗?

**A**: 可以,但需要灵活应用:
- 技术课程 → 参考陈航、林晓斌
- 运维课程 → 参考倪朋飞
- 商业课程 → 可以借鉴结构设计思路,但具体内容需调整
- 建议: 学习通用的教学方法,而非具体的技术内容

---

### Q4: 如何知道 AI 是否在使用作者风格?

**A**: 在执行命令时会有明确提示:
```
🎭 检测到激活的作者风格: 陈航 (《Flutter核心技术与实战》)

在设计大纲时,我将参考该作者的教学风格:
...
```

---

### Q5: 可以添加自己的 Persona 吗?

**A**: 可以!步骤:
1. 在 `reference-courses/personas/` 创建 YAML 文件
2. 按照现有格式定义风格特征
3. 更新 `manifest.json`
4. 使用 `/mimic activate [你的作者名]`

---

## 最佳实践

### 1. 选择合适的作者

根据课程类型选择:
- **技术深度课程** → 陈航(Flutter)
- **问题驱动课程** → 林晓斌(MySQL)
- **工具实战课程** → 倪朋飞(Linux)

### 2. 分阶段使用

```bash
# 阶段1: 学习结构设计
/mimic activate 陈航
/outline (coach模式,学习如何思考)

# 阶段2: 快速生成框架
/mimic activate 林晓斌
/outline (express模式,快速生成)

# 阶段3: 质量评估
/mimic activate 倪朋飞
/review (用不同标准检验)
```

### 3. 结合参考课程系统

```bash
# 1. 先查看推荐的参考专栏
/reference

# 2. 选择一个分析其结构
/analyze Flutter核心技术与实战

# 3. 激活该作者的风格
/mimic activate 陈航

# 4. 开始创作
/outline
```

### 4. 迭代优化

```bash
# 第一轮: 用作者A的标准评估
/mimic activate 陈航
/review
# 发现: 缺少原理讲解

# 第二轮: 补充原理部分
/content

# 第三轮: 用作者B的标准评估
/mimic activate 林晓斌
/review
# 发现: 缺少实际案例

# 第四轮: 补充案例
/content
```

---

## 技术细节

### 文件结构

```
reference-courses/
├── personas/
│   ├── manifest.json              # 作者索引
│   ├── chen-hang-flutter.yaml     # 陈航的风格配置
│   ├── lin-xiaobin-mysql.yaml     # 林晓斌的风格配置
│   └── ni-pengfei-linux.yaml      # 倪朋飞的风格配置
│
.courseify/
└── active-persona.yaml            # 当前激活的作者配置
```

### 脚本命令

```bash
# 查看所有作者
scripts/bash/mimic.sh list

# 激活作者(支持ID和名称)
scripts/bash/mimic.sh activate chen-hang-flutter
scripts/bash/mimic.sh activate 陈航

# 退出风格模拟
scripts/bash/mimic.sh deactivate

# 查看当前状态
scripts/bash/mimic.sh status
```

---

## 更新日志

### v0.3.0 (2025-11-01)

**新增功能**:
- ✅ 风格模拟系统基础功能
- ✅ 3个专栏作者 Persona(陈航、林晓斌、倪朋飞)
- ✅ `/mimic` 命令(list/activate/deactivate/status)
- ✅ 集成到 `/outline`、`/content`、`/review` 命令

**文件变更**:
- 新增 `reference-courses/personas/` 目录
- 新增 `scripts/bash/mimic.sh` 脚本
- 新增 `templates/commands/mimic.md` 命令模板
- 修改 `templates/commands/outline-*.md` (3个文件)
- 修改 `templates/commands/content.md`
- 修改 `templates/commands/review.md`
- 更新 `src/types/index.ts`

---

## 贡献

欢迎贡献更多作者的 Persona 配置!

**步骤**:
1. 研究该作者的专栏结构和风格
2. 创建 YAML 配置文件
3. 提取教学理念和标志性元素
4. 编写 facilitation_prompts
5. 测试并提交 PR

**质量标准**:
- 准确反映作者的教学风格
- facilitation_prompts 具体可操作
- 包含足够的示例和说明
- 适用于该类型的课程设计

---

## 支持

如有问题或建议,请:
- 查看 [README.md](../README.md)
- 查看 [CHANGELOG.md](../CHANGELOG.md)
- 提交 Issue 到项目仓库

---

**Happy Learning!** 🎓
